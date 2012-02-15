package eu.vamdc.xsams.views;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author Guy Rixon
 */
public class LineListServlet extends TransformingServlet {

  @Override
  protected void get(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    log("***** MUST NOT HAPPEN****");
    String key = getKey(request);
    StreamSource in = getData(key);
    String u = getOriginalUrlEncoded(key);
    String reloadUrl = (u == null)? null : Locations.getServiceLocation(request) + "?url=" + u;
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    PrintWriter w = response.getWriter();
    startXhtmlUtf8Document(w, "Line-list view of XSAMS");
    w.println("<body>");
    w.println("<p>(<a href='" 
              + Locations.getStateListLocation(request, key) +
              "'>Switch to view of states</a>)</p>");
    if (reloadUrl != null) {
      w.println("<p>(<a href='" + reloadUrl + "'>Reload orginal data</a>)</p>");
    }
    File tmp = File.createTempFile("xsams", null);
    System.out.println("Intermediate XML for line-list cached at " + tmp);
    StreamResult tmpOut = new StreamResult(new FileOutputStream(tmp));
    StreamSource tmpIn = new StreamSource(new FileInputStream(tmp));
    StreamResult out = new StreamResult(w);
    transform(in, tmpOut, getLineListTransformer());
    transform(tmpIn, out, getLineListDisplayTransformer(Locations.getStateLocation(request, key)));
    w.print("</body>");
    w.print("</html>");
  }
  
  
  private Transformer getLineListTransformer() throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/line-list.xsl");
    if (q == null) {
      throw new ServletException("Can't find the stylesheet");
    }
    StreamSource transform = new StreamSource(q);
    try {
      return TransformerFactory.newInstance().newTransformer(transform);
    } catch (TransformerConfigurationException ex) {
      throw new ServletException(ex);
    }
  }
  
  private Transformer getLineListDisplayTransformer(String stateLocation) 
      throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/line-list-display.xsl");
    if (q == null) {
      throw new ServletException("Can't find the stylesheet");
    }
    StreamSource transform = new StreamSource(q);
    try {
      Transformer t = TransformerFactory.newInstance().newTransformer(transform);
      t.setParameter("state-location", stateLocation);
      return t;
    } catch (TransformerConfigurationException ex) {
      throw new ServletException(ex);
    }
  }
  
  @Override
  protected String getDocumentTitle() {
    return "Line-list view of XSAMS";
  }
  
  
  @Override
  protected void writeContent(String lineListUrl,
                              String stateListUrl,
                              String selectedStateUrl,
                              String reloadUrl,
                              String stateId,
                              StreamSource in,
                              PrintWriter w) throws ServletException, IOException {
    log("***" + selectedStateUrl + "***");
    w.println("<body>");
    w.println("<p>(<a href='" + stateListUrl + "'>Switch to view of states</a>)</p>");
    w.println("<p>(<a href='" + reloadUrl + "'>Reload orginal data</a>)</p>");
    File tmp = File.createTempFile("xsams", null);
    System.out.println("Intermediate XML for line-list cached at " + tmp);
    StreamResult tmpOut = new StreamResult(new FileOutputStream(tmp));
    StreamSource tmpIn = new StreamSource(new FileInputStream(tmp));
    StreamResult out = new StreamResult(w);
    transform(in, tmpOut, getLineListTransformer());
    transform(tmpIn, out, getLineListDisplayTransformer(selectedStateUrl));
    w.print("</body>");
    w.print("</html>");
  }
  
}
