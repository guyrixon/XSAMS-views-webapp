package eu.vamdc.xsams.views;

import java.io.File;
import java.net.URL;
import java.util.Date;
import static org.junit.Assert.*;
import org.junit.Test;

/**
 *
 * @author Guy Rixon
 */
public class DataCachTest {
 
  @Test
  public void testPurge() throws Exception {
    DataCache sut = new DataCache();
    
    // Make an entry for a file old enough to be purged.
    File f1 = File.createTempFile("junk", ".dat");
    URL u = new URL("http://foo/bar");
    Date d = new Date(System.currentTimeMillis() - 30*60*60*1000); // 30 hrs ago
    CachedDataSet x1 = new CachedDataSet(u, f1, null, null, d);
    String k1 = sut.put(x1);
    
    // Make another entry for a new file.
    File f2 = File.createTempFile("junk", ".dat");
    CachedDataSet x2 = new CachedDataSet(u, f2, null, null);
    String k2 = sut.put(x2);
    
    sut.purge();
    
    assertFalse(sut.contains(k1));
    assertTrue(sut.contains(k2));
  }
  
}
