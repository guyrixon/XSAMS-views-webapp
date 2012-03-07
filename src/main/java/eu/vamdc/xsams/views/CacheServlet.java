package eu.vamdc.xsams.views;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

/**
 * An abstract parent for all servlets in the application. This parent just
 * deals with logging and reporting of errors. It provides the following
 * support to its subclasses.
 * <ul>
 * <li>An inheritable commons-logging {@link #Log}.
 * <li>All Exception instances from the sub-class caught (including
 * runtime exceptions that inherit from Exception, but not those that inherit
 * from Error).
 * <li>All caught exceptions logged with stack traces.
 * <li>Instances of RequestException reported as 400 errors.
 * <li>All other caught exceptions reported as 500 errors.
 * </ul>
 * The above provisions apply to GET and POST requests only.
 * 
 * @author Guy Rixon
 */
public class CacheServlet extends ErrorReportingServlet {
  
  private DataCache cache;
  
  
  @Override
  public void get(HttpServletRequest request, HttpServletResponse response) 
      throws RequestException, IOException {
    
    URL u = getUrl(request);
    String key = cache.put(u);
    LOG.info("Cached at " + cache.get(key).getCacheFile());
    redirect(request, key, response);
  }

  @Override
  public void post(HttpServletRequest request, HttpServletResponse response) throws IOException, RequestException {
    if ("application/x-www-form-urlencoded".equals(request.getContentType())) {
      LOG.debug("Handling application/x-www-form-urlencoded");
      URL u = getUrl(request);
      String key = cache.put(u);
      LOG.debug("Cached at " + cache.get(key).getCacheFile());
      redirect(request, key, response);
      LOG.debug("Redirection committed.");
    }
    else {
      LOG.debug("Handling multipart");
      try {
        ServletFileUpload upload = new ServletFileUpload();
        FileItemIterator iter = upload.getItemIterator(request);
        boolean cached = false;
        while (iter.hasNext()) {
          FileItemStream item = iter.next();
          String name = item.getFieldName();
          if (name.equals("url") && item.isFormField()) {
            String key = uploadFromUrl(item);
            redirect(request, key, response);
          }
          InputStream stream = item.openStream();
          if (item.isFormField()) {
            LOG.debug("Form field " + name + " with value " + Streams.asString(stream) + " detected.");
          }
          else {
            LOG.debug("File field " + name + " with file name " + item.getName() + " detected.");
            String key = cache.put(stream);
            redirect(request, key, response);
          }
          stream.close();
        }
      }
      catch (FileUploadException e) {
        throw new RequestException(e);
      }
    }
  }
    
  /**
   * Initializes the map of cached data.
   */
  @Override
  public void init() {
    cache = new DataCache();
    getServletContext().setAttribute(DataCache.CACHE_ATTRIBUTE, cache);
  }
  
  /**
   * Destroys the data cache, deleting the data.  
   */
  @Override
  public void destroy() {
    try {
      getServletContext().removeAttribute(DataCache.CACHE_ATTRIBUTE);
      cache.empty();
      cache = null;
      
    }
    catch (Exception e) {
     LOG.error("Failed to delete the data cache", e);
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
  
  private URL getUrl(HttpServletRequest request) throws RequestException {
    String[] values = request.getParameterValues("url");
    if (values == null) {
      throw new RequestException("Please set the url parameter or upload a file"); 
    }
    else if (values.length > 1) {
      throw new RequestException("This application reads only one URL at a time");
    }
    else {
      String value = values[0].trim();
      try {
        URL u = new URL(value);
        System.out.println("Accepted URL " + u + " as a data source");
        return u;
      }
      catch (MalformedURLException e) {
        throw new RequestException("'" + value + "' is not a valid URL");
      }
    }

  }
  
  
  private void redirect(HttpServletRequest request, String key, HttpServletResponse response) {
    response.setHeader("Location", Locations.getStateListLocation(request, key));
    response.setStatus(HttpServletResponse.SC_SEE_OTHER);
  }
  
  
  /**
   * Uploads a data set to the cache where the URL is given in the request.
   * 
   * @param item The request fragment holding the URL.
   * @return The key for the cached data.
   * @throws RequestException If the data cannot be uploaded.
   */
  private String uploadFromUrl(FileItemStream item) throws RequestException {
    try {
      InputStream i = item.openStream();
      try {
        String url = Streams.asString(i);
        URL u = new URL(url);
        return cache.put(u);
      }
      finally {
        i.close();
      }
    }
    catch (Exception e) {
      throw new RequestException("Can't upload from parameter 'url'", e);
    }
  }

  /**
   * Uploads a data set to the cache where the data are given in the request.
   * 
   * @param item The request fragment holding the data.
   * @return The key for the cached data.
   * @throws RequestException If the data cannot be uploaded.
   */
  private String uploadFromRequestBody(FileItemStream item) throws RequestException {
    try {
      InputStream i = item.openStream();
      try {
        return cache.put(i);
      }
      finally {
        i.close();
      }
    }
    catch (Exception e) {
      throw new RequestException("Can't upload from request body", e);
    }
  }
  
}
