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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * A map of downloaded data. For each remote data-set, identified by
 * its URL, the map may hold zero or one local copies. The local data are
 * made accessible via keys, returned by {@link #get}. 
 * <p>
 * Cache mappings may be removed by calling  {#remove} (putting a null value 
 * for a mapping is <em>not</em> equivalent to removing the mapping and should 
 * not be tried).
 * <p>
 * Calling {@link #empty} empties the cache and deletes the associated data.
 * After this, new mappings may be entered.
 * <p>
 * Thread safety is important. The contents of the cache are catalogued in 
 * a private HashMap, with a private counter to hold the last-issued key. 
 * Access to the map and counter is via synchronized, protected methods called
 * from the public methods. The lock on the instance is held for a short a time
 * as possible. In particular, the lock is not held while data are being
 * read in to the cache, but only while they are added in the map.
 * 
 * @author Guy Rixon
 */
public class DataCache {
  
  private static final Log LOG = LogFactory.getLog(DataCache.class);
  
  public final static String CACHE_ATTRIBUTE = "eu.vamdc.xsams.views.cacheMap";
  
  public static final long CACHE_LIFETIME_IN_SECONDS = 24L * 60L * 60L;
  
  public static final long CACHE_LIFETIME_IN_MILLISECONDS = 
      CACHE_LIFETIME_IN_SECONDS * 1000L;
  
  private Integer counter;
  
  private HashMap<String, CachedDataSet> map;
  
  public DataCache() {
    counter = 0;
    map = new HashMap<String, CachedDataSet>();
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
  
  /**
   * Reads the given URL and caches the data there obtained.
   * 
   * @param u The URL for the data.
   * @return The key for the cached data.
   * @throws IOException
   * @throws RequestException 
   */
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
  
  /**
   * Reads the given stream and caches the data there obtained.
   * 
   * @param in The stream of data.
   * @return The key for the cached data.
   * @throws IOException 
   */
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
  
  /**
   * Caches the data in a given file, associated with a given URL.
   * 
   * @param u The URL of origin of the data.
   * @param f The file in which the data are cached.
   * @return A key for the cached data.
   */
  protected String put(URL u, File f) {
    return put(new CachedDataSet(u,f));
  }
  
  /**
   * Adds a given data-set to the shared view of the cache.
   * This is the only point in the class where data are shared. The other put
   * methods store data but have to class this method to share them. By extension,
   * this is the only method where new keys are allocated.
   * 
   * @param x The data-set to be shared.
   * @return The key to the stored data.
   */
  protected synchronized String put(CachedDataSet x) {
    counter++;
    String key = counter.toString();
    map.put(key, x);
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
  
  /**
   * Removes from the cache all data older than a time specified by the
   * constant {@link ACHE_LIFETIME_IN_MILLISECONDS}.
   */
  public synchronized void purge() {
    Iterator<Entry<String,CachedDataSet>> i = map.entrySet().iterator();
    while (i.hasNext()) {
      Entry<String,CachedDataSet> q = i.next();
      if (isTooOld(q.getValue().getEntryTime())) {
        q.getValue().delete();
        i.remove();
      }
    }
  }
  
  /**
   * Determines whether a data set is old enough to be purged from the cache.
   * 
   * @param then The timestamp for the data.
   * @return True if the data are old enough to be purged.
   */
  private boolean isTooOld(Date then) {
    Date now = new Date();
    long age = now.getTime() - then.getTime();
    return age > CACHE_LIFETIME_IN_MILLISECONDS;
  }
  
  
  
}
