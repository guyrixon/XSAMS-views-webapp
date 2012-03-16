package eu.vamdc.xsams.views;

import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Guy Rixon
 */
public class Locations {
  
  public static String getRootLocation(HttpServletRequest request) {
    return String.format("http://%s:%d%s",
                         request.getServerName(),
                         request.getLocalPort(),
                         request.getContextPath());
  }
  
  public static String getServiceLocation(HttpServletRequest request) {
    return getRootLocation(request) + "/service";
  }
  
  public static String getStateListLocation(HttpServletRequest request, String key) {
    return getRootLocation(request) + "/state-list/" + key;
  }
  
  public static String getLineListLocation(HttpServletRequest request, String key) {
    return getRootLocation(request) + "/line-list/" + key;
  }
  
  public static String getStateLocation(HttpServletRequest request, String key) {
    return getRootLocation(request) + "/state/" + key;
  }
  
  public static String getBroadeningLocation(HttpServletRequest request, String key) {
    return getRootLocation(request) + "/broadening/" + key;
  }
  
  public static String getCapabilitiesLocation(HttpServletRequest request) {
    return getRootLocation(request) + "/capabilities";
  }
  
  public static String getCapabilitiesCssLocation(HttpServletRequest request) {
    return getRootLocation(request) + "/Capabilities.xsl";
  }
  
  public static String getResultsCssLocation(HttpServletRequest request) {
    return getRootLocation(request) + "/xsams-views.css";
  }
  
}
