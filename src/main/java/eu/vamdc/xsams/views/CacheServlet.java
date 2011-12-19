package eu.vamdc.xsams.views;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

/**
 *
 * @author Guy Rixon
 */
public class CacheServlet extends HttpServlet {
  
  public final static String CACHE_ATTRIBUTE = "eu.vamdc.xsams.views.cacheMap";
  
  private DataCache cache;
  
  @Override
  public void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws ServletException, IOException {
    try {
      get(request, response);
    }
    catch (RequestException e) {
      log(e.toString());
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
  }
  
  @Override
  public void doPost(HttpServletRequest request, HttpServletResponse response) 
      throws ServletException, IOException {
    try {
      post(request, response);
    }
    catch (RequestException e) {
      log(e.toString());
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
  }
  
  public void get(HttpServletRequest request, HttpServletResponse response) 
      throws RequestException, IOException {
    String url = getParameter(request, "url");
    log("url = " + url);
    
    if (url != null) {
      try {
        // Cache the data from the URL
        log("Caching " + url);
        URL u = new URL(url);
        String key = cache.put(u);
        
        // Redirect to a servlet that reads the cached data.
        redirect(request, key, response);
      }
      catch (MalformedURLException u) {
        throw new RequestException("Parameter 'url' is not a valid URL");
      }
    }
    
    else {
      throw new RequestException("One of 'url' or 'upload' must be set");
    }
  }

  public void post(HttpServletRequest request, HttpServletResponse response) throws IOException, RequestException {
    
    try {
    
      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload();

      // Parse the request
      FileItemIterator iter = upload.getItemIterator(request);
      while (iter.hasNext()) {
        FileItemStream item = iter.next();
        String name = item.getFieldName();
        InputStream stream = item.openStream();
        if (item.isFormField()) {
          log("Form field " + name + " with value " + Streams.asString(stream) + " detected.");
        }
        else {
          log("File field " + name + " with file name " + item.getName() + " detected.");
          String key = cache.put(stream);
          // Redirect to a servlet that reads the cached data.
          redirect(request, key, response);
        }
        stream.close();
      }
    }
    catch (FileUploadException e) {
      throw new RequestException(e);
    }
  }
    
  /**
   * Initializes the map of cached data.
   */
  @Override
  public void init() {
    cache = new DataCache();
    getServletContext().setAttribute(CACHE_ATTRIBUTE, cache);
  }
  
  /**
   * Destroys the data cache, deleting the data.  
   */
  @Override
  public void destroy() {
    try {
      getServletContext().removeAttribute(CACHE_ATTRIBUTE);
      cache.empty();
      cache = null;
      
    }
    catch (Exception e) {
     log("Failed to delete the data cache: " + e);
    }
  }  
  
  /**
   * Supplies the value of a parameter, applying some checks.
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
      return null;
    }
    else {
      String trimmedValue = value.trim();
      if (trimmedValue.length() == 0) {
        throw new RequestException("Parameter " + name + " is empty");
      }
      else {
        return trimmedValue;
      }
    }
  }
  
  
  private void redirect(HttpServletRequest request, String key, HttpServletResponse response) {
    String location = String.format("http://%s:%d%s/state-list/%s",
                                    request.getLocalName(),
                                    request.getLocalPort(),
                                    request.getContextPath(),
                                    key);
    response.setHeader("Location", location);
    response.setStatus(HttpServletResponse.SC_SEE_OTHER);
  }

    
    
  
  
}
