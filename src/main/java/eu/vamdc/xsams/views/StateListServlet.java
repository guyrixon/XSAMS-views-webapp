package eu.vamdc.xsams.views;

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
public class StateListServlet extends TransformingServlet {
  
  
  
  protected void writeContent(String lineListUrl,
                              String stateListUrl,
                              String selectedStateUrl,
                              String reloadUrl,
                              String stateId,
                              StreamSource in,
                              PrintWriter w) throws ServletException {
    
    w.println("<h1>State-list view of XSAMS</h1>");
    w.println("<p>(<a href='" + lineListUrl + "'>Switch to view of radiative transitions</a>)</p>");
    w.println("<p>(<a href='" + reloadUrl + "'>Reload orginal data</a>)</p>");
    
    StreamResult out = new StreamResult(w);
    transform(in, out, getTransformer(lineListUrl, stateListUrl, selectedStateUrl, reloadUrl, stateId));
  }
  
  
  
  
  
  @Override
  protected Transformer getTransformer(String lineListUrl,
                                       String stateListUrl,
                                       String selectedStateUrl,
                                       String reloadUrl,
                                       String stateId)  
      throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/state-list-display.xsl");
    if (q == null) {
      throw new ServletException("Can't find the stylesheet");
    }
    StreamSource transform = new StreamSource(q);
    try {
      Transformer t = TransformerFactory.newInstance().newTransformer(transform);
      t.setParameter("line-list-location", lineListUrl);
      t.setParameter("state-location", selectedStateUrl);
      return t;
    } catch (TransformerConfigurationException ex) {
      throw new ServletException(ex);
    }
  }
  
}
