package eu.vamdc.xsams.views;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
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
  
  
  protected URL getOriginalDataUrl(HttpServletRequest request) throws RequestException {
    try {
      return new URL(getParameter(request, "url"));
      
    }
    catch (MalformedURLException e) {
      throw new RequestException("Parameter url is not a valid URL");
    }
  }
  
  protected URL getDataAccessUrl(URL remote) throws RequestException {
    DataCache c = 
        (DataCache) getServletContext().getAttribute(CacheFilter.CACHE_ATTRIBUTE);
    return (c == null || !c.contains(remote))? remote : c.get(remote);
  }
  
  /**
   * Supplies the value of an HTTP parameter, applying some checks.
   * 
   * @param request The HTTP request containing the parameter.
   * @param name The name of the parameter
   * @return The value of the parameter, stripped of leading and trailing white space.
   * @throws RequestException If the parameter is not present in the request.
   * @throws RequestException If the parameter's value is an empty string.
   */
  protected String getParameter(HttpServletRequest request, String name) 
      throws RequestException {
    String value = request.getParameter(name);
    if (value == null) {
      throw new RequestException("Parameter " + name + " is missing");
    }
    String trimmedValue = value.trim();
    if (trimmedValue.length() == 0) {
      throw new RequestException("Parameter " + name + " is empty");
    }
    return trimmedValue;
  }
  
  
  
  protected void transform(StreamSource in, StreamResult out, Transformer t, URL u)
      throws ServletException {
    try {
      String url = URLEncoder.encode(u.toString(), "UTF-8");
      t.setParameter("xsams-url", url);
      t.transform(in, out);
    }
    catch (Exception e) {
      throw new ServletException(e);
    }
  }
  
}
