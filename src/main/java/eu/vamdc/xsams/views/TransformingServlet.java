package eu.vamdc.xsams.views;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * A servlet that transforms data to web pages using XSLT. The servlet uses
 * the data cache shared throughout the web application.
 * 
 * @author Guy Rixon
 */
public abstract class TransformingServlet extends HttpServlet {
  
  /*
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    try {
      get(request, response);
    }
    catch (RequestException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
    catch (Exception e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
    }
  }
   * 
   */
  
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    try {
      produceDocument(request, response);
    }
    catch (RequestException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
    catch (Exception e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
    }
  }
  
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    try {
      produceDocument(request, response);
    }
    catch (RequestException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
    catch (Exception e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
    }
  }
  
  protected abstract void get(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException;
  
  protected StreamSource getData(String key) throws ServletException, FileNotFoundException {
    DataCache cache = (DataCache) getServletContext().getAttribute(CacheFilter.CACHE_ATTRIBUTE);
    if (cache == null) {
      throw new ServletException("The data cache is missing");
    }
    cache.purge();
    CachedDataSet x = cache.get(key);
    if (x == null) {
      throw new RequestException("Nothing is cached under " + key);
    }
    try {
      FileReader fr = new FileReader(x.getCacheFile());
      return new StreamSource(fr);
    }
    catch (FileNotFoundException e) {
      throw new ServletException("Cache file " + x.getCacheFile() + " is missing");
    }
  }
  
  protected String getKey(HttpServletRequest request) throws RequestException {
    String q = request.getPathInfo();
    log("q=" + q);
    return (q.startsWith("/"))? q.substring(1) : q;
  }
  
  protected String getOriginalUrlEncoded(String key) throws RequestException {
    DataCache cache = (DataCache) getServletContext().getAttribute(CacheFilter.CACHE_ATTRIBUTE);
    if (cache == null) {
      throw new RequestException("The data cache is missing");
    }
    CachedDataSet x = cache.get(key);
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
  
  
  protected void transform(StreamSource in, StreamResult out, Transformer t)
      throws ServletException {
    try {
      t.transform(in, out);
    }
    catch (Exception e) {
      throw new ServletException(e);
    }
  }
  
  /**
   * Writes the opening of an XHTML-1 (strict) document in UTF-8 encoding.
   * Writes the following text to the given writer:
   * <ul>
   * <li>the DOCTYPE;</li>
   * <li>the opening of the head element;
   * <li>the opening of the html element, with namespace declaration;</li>
   * <li>the content-type meta-element (giving the type as text.html and the encoding as UTF-8;</li>
   * <li>the title;</li>
   * <li>the closing of the head element.</li>
   * </ul>
   * The caller must write the body of the document, starting with the opening
   * tag of the body element, and the closing tag of the html element. The
   * caller must arrange for the output encodign to be UTF-8 before calling
   * this method.
   * 
   * @param out The writer to which the document is written.
   * @param title The title text of the document.
   */
  protected void startXhtmlUtf8Document(PrintWriter out, String title) {
    out.println("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>");
    out.println("<html xmlns='http://www.w3.org/1999/xhtml'>");
    out.println("<head>");
    out.println("<meta http-equiv='Content-type' content='text/html;charset=UTF-8' />");
    out.println("<title>" + title + "</title>");
    out.println("</head>");
  }
  
  
  
  protected abstract String getDocumentTitle();
  
  protected abstract void writeContent(String lineListUrl,
                                       String stateListUrl,
                                       String selectedStateUrl,
                                       String reloadUrl,
                                       String stateId,
                                       StreamSource in,
                                       PrintWriter out) throws ServletException, IOException;
  
  protected void produceDocument(HttpServletRequest request, HttpServletResponse response) throws RequestException, ServletException, FileNotFoundException, IOException {
    String key = getKey(request);
    StreamSource in = getData(key);
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    String u = getOriginalUrlEncoded(key);
    String reloadUrl = (u == null)? "" : Locations.getServiceLocation(request) + "?url=" + u;
    PrintWriter w = response.getWriter();
    startXhtmlUtf8Document(w, getDocumentTitle());
    w.println("<body>");
    writeContent(Locations.getLineListLocation(request, key),
                 Locations.getStateListLocation(request, key),
                 Locations.getStateLocation(request, key),
                 reloadUrl,
                 request.getParameter("stateID"),
                 getData(key),
                 response.getWriter());
    w.println("</body>");
  }
  
}
