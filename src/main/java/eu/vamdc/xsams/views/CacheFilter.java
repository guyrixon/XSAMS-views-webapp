package eu.vamdc.xsams.views;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * A JEE filter to cache data obtained from URLs.
 * <p>
 * The filter composes a {@link DataCache} which it creates when
 * {@link #init} is called and throws away (deleting the data) when 
 * {@link #destroy} is called. The cache contents therefore last for the
 * lifetime of the filter. The {@code DataCache} is shared with the rest of
 * the application via the attribute named {@link #CACHE_ATTRIBUTE} in the
 * servlet context.
 * <p>
 * The filter inspects the request for the parameter {@code url}, which the
 * filter expects to contain the URL for a remote data-set. The filter attempts
 * to add the data to the cache. If the data cannot be cached, the filter
 * allows the request to continue; the servlets reading the cache must then
 * either get fresh data from the given URL or send an error response.
 * <p>
 * If the {@code reload} parameter is present in the request, the filter
 * removes the data-set from the cache, downloads a fresh copy and caches that
 * copy.
 * 
 * @author Guy Rixon
 */
public class CacheFilter implements Filter {
  
  private ServletContext context;
  
  public final static String CACHE_ATTRIBUTE = "eu.vamdc.xsams.views.cacheMap";
  
  private DataCache cache;
  
  
  

  /**
   *
   * @param request The servlet request we are processing
   * @param response The servlet response we are creating
   * @param chain The filter chain we are processing
   *
   * @exception IOException if an input/output error occurs
   * @exception ServletException if a servlet error occurs
   */
  @Override
  public void doFilter(ServletRequest request, ServletResponse response,
      FilterChain chain)
      throws IOException, ServletException {
    
    
    try {
      URL u = getParameterAsUrl(request, "url");
      if (request.getParameter("reload") != null) {
        cache.remove(u);
      }
      if (cache.contains(u)) {
        context.log("Already in the data cache: " + u);
      }
      else {
        context.log("Attempting to cache " + u);
        cache.put(u);
        context.log("Cached " + u + " at " + cache.get(u));
      }
    }
    catch (Exception e) {
      context.log("Failed to cache data: " + e);
    }
    
    chain.doFilter(request, response);
  }

  /**
   * Initializes the map of cached data.
   */
  @Override
  public void init(FilterConfig filterConfig) {
    context = filterConfig.getServletContext();
    cache = new DataCache();
    filterConfig.getServletContext().setAttribute(CACHE_ATTRIBUTE, cache);
  }
  
  /**
   * Destroys the data cache, deleting the data.  
   */
  @Override
  public void destroy() {
    try {
      context.removeAttribute(CACHE_ATTRIBUTE);
      cache.empty();
      cache = null;
      
    }
    catch (Exception e) {
     context.log("Failed to delete the data cache: " + e);
    }
    finally {
      context = null;
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
  private String getParameter(ServletRequest request, String name) 
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
   * Supplies the value of a parameter, applying some checks.
   * 
   * @param request The HTTP request containing the parameter.
   * @param name The name of the parameter
   * @return The URL from the parameter's value.
   * @throws RequestException If the parameter is not present in the request.
   * @throws RequestException If the parameter's value is an empty string.
   * @throws RequesrException If the parameter's value cannot be parsed as a URL.
   */
  private URL getParameterAsUrl(ServletRequest request, String name) 
      throws RequestException, MalformedURLException {
    try {
      return new URL(getParameter(request, name));
    } catch (MalformedURLException ex) {
      throw new RequestException("Parameter " + name + " is not a URL");
    }
  }

}
