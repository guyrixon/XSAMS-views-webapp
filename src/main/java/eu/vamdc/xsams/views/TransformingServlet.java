package eu.vamdc.xsams.views;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * A servlet that transforms data to web pages using XSLT. The servlet uses
 * the data cache shared throughout the web application.
 * 
 * @throws RequestException If the request does not identified the cached data to view.
 * @throws RequestException If the specified data are not in the cache.
 * @throws FileNotFoundException If the data are known to the cache but their file is missing.
 * @throws IOException If the response cannot be written.
 * @throws IllegalStateException If the data cache is not available.
 * @throws IllegalStateException If the transforming stylesheet is not available.
 * @throws TransformerException If the XSAMS cannot be transformed to HTML.
 * @author Guy Rixon
 */
public class TransformingServlet extends ErrorReportingServlet {
  
  @Override
  public void get(HttpServletRequest request, HttpServletResponse response) 
      throws RequestException, IllegalStateException, FileNotFoundException, 
             IOException, TransformerException, DownloadException, ServletException {
    String key = getKey(request);
    
    DataCache d = getCache();
    CachedDataSet x = d.get(key);
    if (x == null) {
      LOG.error("Data are missing for " + key);
      throw new ServletException("The cache has no record of these data");
    }
    if (x.isReady()) {
      LOG.info("Data are ready for " + key);
      transformXsams(request, key, response);
    }
    else {
      LOG.info("Data are not ready for " + key);
      writeDeferral(request, x, response);
    }
  }
  
  @Override
  public void post(HttpServletRequest request, HttpServletResponse response) 
      throws RequestException, IllegalStateException, FileNotFoundException, 
             IOException, TransformerException, DownloadException, ServletException {
    get(request, response);
  }
  
  public void transformXsams(HttpServletRequest request, String key, HttpServletResponse response) 
      throws RequestException, IllegalStateException, FileNotFoundException, IOException, TransformerException {
    StreamSource in = getData(key);
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    StreamResult out = new StreamResult(response.getWriter());
    
    Transformer t = TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl", null).newTransformer(getXslt());
    t.setParameter("line-list-location", Locations.getLineListLocation(request, key));
    t.setParameter("state-list-location", Locations.getStateListLocation(request, key));
    t.setParameter("collision-list-location", Locations.getCollisionListLocation(request, key));
    t.setParameter("state-location", Locations.getStateLocation(request, key));
    t.setParameter("collision-location", Locations.getCollisionLocation(request, key));
    t.setParameter("broadening-location", Locations.getBroadeningLocation(request, key));
    t.setParameter("css-location", Locations.getResultsCssLocation(request));
    t.setParameter("js-location", Locations.getPostTableJsLocation(request));
    String id = request.getParameter("id");
    if (id != null) {
      t.setParameter("id", id);
    }
    t.transform(in, out);
  }
  
  
  
  protected StreamSource getData(String key) 
      throws RequestException, IllegalStateException, FileNotFoundException {
    DataCache cache = (DataCache) getServletContext().getAttribute(DataCache.CACHE_ATTRIBUTE);
    if (cache == null) {
      throw new IllegalStateException("The data cache is missing");
    }
    getCache().purge();
    CachedDataSet x = getCache().get(key);
    if (x == null) {
      throw new RequestException("Nothing is cached under " + key);
    }
    try {
      FileReader fr = new FileReader(x.getCacheFile());
      return new StreamSource(fr);
    }
    catch (FileNotFoundException e) {
      throw new FileNotFoundException("Cached XSAMS file " + x.getCacheFile() + " is missing");
    }
  }
  
  protected String getKey(HttpServletRequest request) throws RequestException {
    String q = request.getPathInfo();
    return (q.startsWith("/"))? q.substring(1) : q;
  }
  
  protected Source getXslt() {
    String stylesheetName = getInitParameter("stylesheet");
    URL in = this.getClass().getResource("/"+stylesheetName);
    if (in == null) {
      throw new IllegalStateException("Can't find the stylesheet " + stylesheetName);
    }
    return new StreamSource(in.toString());
  }
  
  
  protected DataCache getCache() throws IllegalStateException {
    DataCache cache = (DataCache) getServletContext().getAttribute(DataCache.CACHE_ATTRIBUTE);
    if (cache == null) {
      throw new IllegalStateException("The data cache is missing");
    }
    return cache;
  }

  private void writeDeferral(HttpServletRequest request, CachedDataSet x, HttpServletResponse response) 
      throws ServletException, IOException {
    long bytesDownloaded = x.getByteCounter().get();
    request.setAttribute("eu.vamdc.xsams.views.bytesdownloaded", bytesDownloaded);
    request.getRequestDispatcher("/later.jsp").forward(request, response);
  }
  
  
}
