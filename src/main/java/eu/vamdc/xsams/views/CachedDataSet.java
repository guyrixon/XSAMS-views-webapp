package eu.vamdc.xsams.views;

import java.io.File;
import java.net.URL;
import java.util.Date;

/**
 *
 * @author Guy Rixon
 */
public class CachedDataSet {
  
  private final File cacheFile;
  
  private final URL originalUrl;
  
  private final Date entryTime;
  
  public CachedDataSet(URL u, File f) {
    cacheFile = f;
    originalUrl = u;
    entryTime = new Date();
  }
  
  public File getCacheFile() {
    return cacheFile;
  }
  
  public URL getOriginalUrl() {
    return originalUrl;
  }
  
  public Date getEntryTime() {
    return entryTime;
  }
  
  public void delete() {
    if (cacheFile != null) {
      cacheFile.delete();
    }
  }
  
}
