package eu.vamdc.xsams.views;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Date;
import java.util.Hashtable;
import java.util.Map.Entry;
import java.util.Set;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

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
  
  private static final Log LOG = LogFactory.getLog(DataCache.class);
  
  public static final long CACHE_LIFETIME_IN_SECONDS = 24L * 60L * 60L;
  
  public static final long CACHE_LIFETIME_IN_MILLISECONDS = 
      CACHE_LIFETIME_IN_SECONDS * 1000L;
  
  private Integer counter;
  
  private Hashtable<String, CachedDataSet> map;
  
  public DataCache() {
    counter = 0;
    map = new Hashtable<String, CachedDataSet>();
  }
  
  /**
   * Deletes the content of the put.
   * 
   * @throws IOException If any data-set cannot be deleted.
   */
  public synchronized void empty() throws IOException {
    for (CachedDataSet x : map.values()) {
      if (!x.getCacheFile().delete()) {
        throw new IOException("Failed to delete " + x.getCacheFile() + " from the data cache");
      }
    }
  }
  
  
  public String put(URL u) throws IOException, RequestException {
    File f = File.createTempFile("cache-", ".xsams.xml");
    
    BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(f));
    try {
      URLConnection uc = u.openConnection();
      uc.setConnectTimeout(60000);
      uc.setReadTimeout(60000);
      uc.setRequestProperty("Accept-Encoding", "gzip, deflate");
      
      uc.connect();
      
      String encoding = uc.getContentEncoding();
      LOG.info("Transfer encoding is " + encoding);
      
      InputStream q;
      if (encoding != null && encoding.equalsIgnoreCase("gzip")) {
        q = new GZIPInputStream(uc.getInputStream());
      }
      else if (encoding != null && encoding.equalsIgnoreCase("deflate")) {
        q = new InflaterInputStream(uc.getInputStream(), new Inflater(true));
      }
      else {
        q = uc.getInputStream();
      }
      BufferedInputStream in = new BufferedInputStream(q);
      
      int n = 0;
      try {
        for (n = 0; true; n++) {
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
        LOG.info(n + " bytes read from " + u);
        if (n == 0) {
          throw new RequestException("No data was read from " + u);
        }
        in.close();
      }
    }
    finally {
      out.close();
    }
    
    return put(u, f);
  }
  
  public String put(InputStream in) throws IOException {
    File f = File.createTempFile("cache-", ".xsams.xml");
    
    BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(f));
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
      out.close();
    }
    
    return put(null, f);
  }
  
  public synchronized String put(URL u, File f) {
    counter++;
    String key = counter.toString();
    map.put(key, new CachedDataSet(u,f));
    return key;
  }
  
  public synchronized CachedDataSet get(String k) {
    return map.get(k);
  }
  
  public synchronized boolean contains(String k) {
    return map.containsKey(k);
  }
  
  public synchronized void remove(String k) {
    if (map.containsKey(k)) {
      map.get(k).delete();
      map.remove(k);
    }
  }
  
  public synchronized void purge() {
    Set<Entry<String,CachedDataSet>> s = map.entrySet();
    for (Entry<String,CachedDataSet> q : s) {
      Date entryTime = q.getValue().getEntryTime();
      if (isTooOld(entryTime)) {
        q.getValue().delete();
        s.remove(q);
      }
    }
  }
  
  private boolean isTooOld(Date then) {
    Date now = new Date();
    long age = now.getTime() - then.getTime();
    return age > CACHE_LIFETIME_IN_MILLISECONDS;
  }
  
  
  
}
