package eu.vamdc.xsams.views;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
  protected void get(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    String stateId = request.getParameter("stateID");
    log("stateID = " + stateId);
    File tmp = File.createTempFile("xsams", null);
    log("Intermediate data cached at " + tmp);
    try {
      String key = getKey(request);
      StreamSource in = getData(key);
      StreamResult tmpOut = new StreamResult(new FileOutputStream(tmp));
      StreamSource tmpIn = new StreamSource(new FileInputStream(tmp));
      StreamResult out = new StreamResult(response.getOutputStream());
      transform(in, tmpOut, getSelectedStateTransformer(stateId));
      transform(tmpIn, out, getSelectedStateDisplayTransformer());
    }
    finally {
      tmp.delete();
    }
  }
  
  
  private Transformer getSelectedStateTransformer(String stateId) throws ServletException {
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
  
  private Transformer getSelectedStateDisplayTransformer() throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/selected-state-display.xsl");
    if (q == null) {
      throw new ServletException("Can't find the stylesheet");
    }
    StreamSource transform = new StreamSource(q);
    try {
      Transformer t = TransformerFactory.newInstance().newTransformer(transform);
      return t;
    } catch (TransformerConfigurationException ex) {
      throw new ServletException(ex);
    }
  }
  
}
