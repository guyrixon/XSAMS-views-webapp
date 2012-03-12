package eu.vamdc.xsams.views;

import java.io.File;
import java.net.URL;
import java.util.Date;
import java.util.concurrent.Future;

/**
 *
 * @author Guy Rixon
 */
public class CachedDataSet {
  
  private final File cacheFile;
  
  private final URL originalUrl;
  
  private final Date entryTime;
  
  private final Future<Object> future;
  
  public CachedDataSet(URL u, File file, Future<Object> f) {
    cacheFile = file;
    originalUrl = u;
    future = f;
    entryTime = new Date();
  }
  
  protected CachedDataSet(URL u, File file, Future<Object> f, Date d) {
    cacheFile = file;
    originalUrl = u;
    future = f;
    entryTime = d;
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
  
  public boolean isReady() throws DownloadException {
    if (future == null) {
      return true;
    }
    else {
      if (future.isDone()) {
        try {
          future.get();
        }
        catch (Exception e) {
          throw new DownloadException("Download failed", e.getCause());
        }
        return true;
      }
      else {
        return false;
      }
    }
  }
  
  public void delete() {
    if (future != null) {
      future.cancel(true);
    }
    if (cacheFile != null) {
      cacheFile.delete();
    }
  }
  
}
