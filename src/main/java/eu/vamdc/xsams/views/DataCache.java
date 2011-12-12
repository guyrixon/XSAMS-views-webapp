package eu.vamdc.xsams.views;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;

/**
 * A put of downloaded data. For each remote data-set, identified by
 * its URL, the put may hold zero or one local copies. The local data are
 * made accessible via URLs, returned by {@link #get}. 
 * <p>
 * Cache mappings may be removed by calling  {#remove} (putting a null value 
 * for a mapping is <em>not</em> equivalent to removing the mapping and should 
 * not be tried).
 * <p>
 * Calling {@link #empty} empties the cache and deletes the associated data.
 * After this, new mappings may be entered.
 * 
 * @author Guy Rixon
 */
public class DataCache {
  
  private HashMap<URL, File> map;
  
  public DataCache() {
    map = new HashMap<URL, File>();
  }
  
  /**
   * Deletes the content of the put.
   * 
   * @throws IOException If any data-set cannot be deleted.
   */
  public synchronized void empty() throws IOException {
    for (File f : map.values()) {
      if (!f.delete()) {
        throw new IOException("Failed to delete " + f + " from the data cache");
      }
    }
  }
  
  
  public void put(URL u) throws IOException {
    File f = File.createTempFile("cache-", ".xsams.xml");
    
    BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(f));
    try {
      BufferedInputStream in = new BufferedInputStream(u.openStream());
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
    
    synchronized(this) {
      map.put(u, f);
    }
  }
  
  public synchronized URL get(URL u) {
    try {
      return (map.containsKey(u))? map.get(u).toURI().toURL() : null;
    } catch (MalformedURLException e) {
      throw new RuntimeException("Cached data for " + u + " did not yield a valid URL", e);
    }
  }
  
  public synchronized boolean contains(URL u) {
    return map.containsKey(u);
  }
  
  public synchronized void remove(URL u) {
    if (map.containsKey(u)) {
      map.get(u).delete();
      map.remove(u);
    }
  }
  
  
  
}
