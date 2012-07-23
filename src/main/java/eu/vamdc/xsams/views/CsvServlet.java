package eu.vamdc.xsams.views;

import java.io.IOException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Servlet to transform an HTML table to CSV. XSLT is used for the transformation.
 * <p>
 * The table is read from the body of the HTTP request and written to the body
 * of the HTTP response. Hence, this servlet only works for POST requests (it
 * will response to get requests because of its inheritance from 
 * {@ link ErrorReportingServlet} but these requests will fail).
 * <p>
 * Input should be in XHTML and should include a single table; output is 
 * likely to be malformed if multiple tables are present. The document
 * element may be the table element, or the latter may be nested in other
 * elements.
 * <p>
 * Output conforms to RFC4180
 * (including Windows-style line-breaks) and is encoded in UTF-8.
 * 
 * @author Guy Rixon
 */
public class CsvServlet extends ErrorReportingServlet {

  @Override
  public void get(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, TransformerException, ServletException {
    transformTable(request, response);
  }
  
  @Override
  public void post(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, TransformerException, DownloadException, ServletException {
    transformTable(request, response);
  }

  
  /**
   * Reads an XHTML table from the body of the request and writes the CSV 
   * equivalent to the body of the response. Output conforms to RFC4180
   * (including Windows-style line-breaks) and is encoded in UTF-8.
   * <p>
   * Input should be in XHTML and should include a single table; output is 
   * likely to be malformed if multiple tables are present. The document
   * element may be the table element, or the latter may be nested in other
   * elements.
   *
   * @throws IOException if the body of the HTTP request cannot be opened.
   * @throws TransformerConfigurationException If the Saxon transformer cannot be created.
   * @throws TransformerException If the transformation cannot be executed.
   */
  public void transformTable(HttpServletRequest request, HttpServletResponse response) 
      throws RequestException, IOException, TransformerConfigurationException, TransformerException {
    StreamSource in = new StreamSource(request.getInputStream());
    response.setContentType("text/csv");
    response.setCharacterEncoding("UTF-8");
    StreamResult out = new StreamResult(response.getWriter());
    
    Transformer t = TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl", null).newTransformer(getXslt());
    t.transform(in, out);
  }
  
  protected Source getXslt() {
    String stylesheetName = getInitParameter("stylesheet");
    URL in = this.getClass().getResource("/"+stylesheetName);
    if (in == null) {
      throw new IllegalStateException("Can't find the stylesheet " + stylesheetName);
    }
    return new StreamSource(in.toString());
  }
}
