package eu.vamdc.xsams.views;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
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
  
  private Transformer getLineListTransformer(String stateLocation) 
      throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/line-list.xsl");
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
    StreamResult out = new StreamResult(w);
    transform(in, out, getLineListTransformer(selectedStateUrl));
    w.print("</body>");
    w.print("</html>");
  }
  
}
