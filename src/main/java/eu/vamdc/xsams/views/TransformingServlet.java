package eu.vamdc.xsams.views;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
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
    
    CachedDataSet x = getCache().get(key);
    if (x.isReady()) {
      transformXsams(request, key, response);
    }
    else {
      writeDeferral(request, response);
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
    
    Transformer t = TransformerFactory.newInstance().newTransformer(getXslt());
    t.setParameter("line-list-location", Locations.getLineListLocation(request, key));
    t.setParameter("state-list-location", Locations.getStateListLocation(request, key));
    t.setParameter("state-location", Locations.getStateLocation(request, key));
    t.setParameter("broadening-location", Locations.getBroadeningLocation(request, key));
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
    log("q=" + q);
    return (q.startsWith("/"))? q.substring(1) : q;
  }
  
  protected String getOriginalUrlEncoded(String key) throws RequestException {
    CachedDataSet x = getCache().get(key);
    if (x == null) {
      throw new RequestException("Nothing is cached under " + key);
    }
    URL u = x.getOriginalUrl();
    try {
      return (u == null)? null : URLEncoder.encode(u.toString(), "UTF-8");
    }
    catch (UnsupportedEncodingException e) {
      throw new RuntimeException(e);
    }
  }
  
  protected Source getXslt() {
    String stylesheetName = getInitParameter("stylesheet");
    InputStream in = this.getClass().getResourceAsStream("/"+stylesheetName);
    if (in == null) {
      throw new IllegalStateException("Can't find the stylesheet " + stylesheetName);
    }
    return new StreamSource(in);
  }
  
  
  protected DataCache getCache() throws IllegalStateException {
    DataCache cache = (DataCache) getServletContext().getAttribute(DataCache.CACHE_ATTRIBUTE);
    if (cache == null) {
      throw new IllegalStateException("The data cache is missing");
    }
    return cache;
  }

  private void writeDeferral(HttpServletRequest request, HttpServletResponse response) 
      throws ServletException, IOException {
    request.getRequestDispatcher("/later.jsp").forward(request, response);
  }
  
  
}
