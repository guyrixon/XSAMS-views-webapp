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
public class SelectedStateServlet extends TransformingServlet {
  
  @Override
  protected String getDocumentTitle() {
    return "Single-state view of XSAMS";
  }
  
  @Override
  protected void writeContent(String lineListUrl,
                              String stateListUrl,
                              String reloadUrl,
                              String selectedStateUrl,
                              String stateId,
                              StreamSource in,
                              PrintWriter w) throws ServletException, IOException {
    StreamResult out = new StreamResult(w);
    transform(in, out, getTransformer(stateId));
  }
  
  
  private Transformer getTransformer(String stateId) throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/selected-state.xsl");
    if (q == null) {
      throw new ServletException("Can't find the stylesheet");
    }
    StreamSource transform = new StreamSource(q);
    try {
      Transformer t = TransformerFactory.newInstance().newTransformer(transform);
      t.setParameter("stateID", stateId);
      return t;
    } catch (TransformerConfigurationException ex) {
      throw new ServletException(ex);
    }
  }
  
}
