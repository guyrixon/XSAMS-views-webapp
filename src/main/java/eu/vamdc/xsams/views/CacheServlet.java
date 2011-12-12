package eu.vamdc.xsams.views;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Guy Rixon
 */
public class CacheServlet extends HttpServlet {
  
  /**
   * Handles a request to POST new data.
   * Caches the data in a file, and redirects to a page to handle the cached
   * data.
   * 
   * @param request The HTTP request
   * @param response The HTTP response (a redirection).
   * @throws ServletException
   * @throws IOException 
   */
  @Override
  public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      URL originalData = getParameterAsUrl(request, "url");
      URL cachedData = cacheData(originalData);
    }
    catch (RequestException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
    catch (Exception e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
    }
    
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
  private String getParameter(HttpServletRequest request, String name) 
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

  /**
   * Supplies the value of an HTTP parameter, applying some checks.
   * 
   * @param request The HTTP request containing the parameter.
   * @param name The name of the parameter
   * @return The URL from the parameter's value.
   * @throws RequestException If the parameter is not present in the request.
   * @throws RequestException If the parameter's value is an empty string.
   * @throws RequesrException If the parameter's value cannot be parsed as a URL.
   */
  private URL getParameterAsUrl(HttpServletRequest request, String name) 
      throws RequestException {
    try {
      return new URL(getParameter(request, name));
    } catch (MalformedURLException ex) {
      throw new RequestException("Parameter " + name + " is not a URL");
    }
  }

  /**
   * Downloads external data from a URL to a cache. The location returned
   * for the cached version could be in any scheme, but {@code file} is the
   * original implementation.
   * 
   * @param originalData Location of original data.
   * @return Location of cached data.
   */
  private URL cacheData(URL originalData) 
      throws IOException {
    File cache = File.createTempFile(null, ".xsams.xml");
    
    BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(cache));
    try {
      BufferedInputStream in = new BufferedInputStream(originalData.openStream());
      try {
        while (true) {
          int c = in.read();
          if (c == -1) {
            break;
          }
          else {
            out.write(c);
          }
        }
      }
      finally {
        in.close();
      }
    }
    finally {
      out.close();
    }
    
    return cache.toURI().toURL();
  }
    
    
  
  
}
