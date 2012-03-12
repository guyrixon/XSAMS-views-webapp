package eu.vamdc.xsams.views;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.concurrent.Callable;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * A download of an XML file from a URL to a cache file.
 * The download is {@code Callable}: the actual transfer of bytes happens 
 * during the {@link #call} method, which can throw checked exceptions. 
 * This method returns null on completion (there is no result that can 
 * be returned as an object reference).
 * 
 * @author Guy Rixon
 */
public class Download implements Callable<Object> {
  
  private static final Log LOG = LogFactory.getLog(DataCache.class);
  
  /**
   * The character encoding to use for the cache file.
   */
  private final static Charset UTF8 = Charset.forName("UTF-8");
  
  /**
   * The URL from which to read the data.
   */
  private URL url;
  
  /**
   * The file in which to cache the data.
   */
  private File file;
  
  /**
   * Constructs a Download for a given URL and cache file.
   * 
   * @param u The URL to download.
   * @param f The file (must exist before construction).
   * @throws FileNotFoundException If the file does not exist.
   */
  public Download(URL u, File f) throws FileNotFoundException {
    url = u;
    file = f;
    if (!f.exists()) {
      throw new FileNotFoundException("Cache file does not exist: " + f);
    }
  }

  /**
   * Executes the download.
   * 
   * @return null, even when the download succeeds.
   * @throws FileNotFoundException If the file does not exist.
   * @throws DownloadException If the URL is read but gives no bytes.
   */
  @Override
  public Object call() throws DownloadException, IOException {
    readFromUrl(url, file);
    return null;
  }
  
  /**
   * Downloads the data from a URL and copies them to a file. If the URL supports
   * "gzip" or "deflate" compression then the download is compressed in transfer
   * and the data are decompressed before filing.
   * 
   * @param u The URL to read.
   * @param f The file to receive the data.
   * @throws IOException If the URL cannot be read.
   * @throws IOException If the file cannot be written.
   * @throws FileNotFoundException If the file does not exist.
   * @throws DownloadException If the URL is read but gives no bytes.
   */
  private void readFromUrl(URL u, File f) 
      throws IOException, FileNotFoundException, DownloadException {
    URLConnection uc = u.openConnection();
    uc.setConnectTimeout(60000);
    uc.setReadTimeout(60000);
    uc.setRequestProperty("Accept-Encoding", "gzip, deflate");
      
    uc.connect();
      
    String encoding = uc.getContentEncoding();
    LOG.debug("Transfer encoding is " + encoding);
      
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
    long n;
    try {
      readFromStream(in, f);
    }
    finally {
      in.close();
    }
  }
  
  
  /**
   * Reads data from a stream and writes them to a file.
   * 
   * @param in The data to be read.
   * @param f The file to receive the data.
   * @return The number of bytes read.
   * @throws FileNotFoundException If the given file does not exist.
   * @throws IOException If the stream cannot be read.
   * @throws IOException If the the file cannot be written.
   * @throws DownloadException if the stream gave no bytes.
   */
  private void readFromStream(InputStream i, File f) 
      throws FileNotFoundException, IOException, DownloadException {
    BufferedReader in = new BufferedReader(new InputStreamReader(i, UTF8));
    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), UTF8));
    LOG.info("Caching to " + f);
    try {
      long n;
      for (n = 0; true; n++) {
        int c = in.read();
        if (c == -1) {
          break;
        }
        else {
          out.write(c);
        }
      }
      if (n == 0L) {
        throw new DownloadException("No data were read");
      }
    }
    finally {
      out.close();
    }
  }
  
  
}
