package eu.vamdc.xsams.views;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLEncoder;
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
public class StateListServlet extends TransformingServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    try {
      URL remote = getOriginalDataUrl(request);
      URL local = getDataAccessUrl(remote);
      getServletContext().log("Taking data from " + local);
      StreamSource in = new StreamSource(local.openStream()); 
      StreamResult out = new StreamResult(response.getOutputStream());
      transform(in, out, getStateListDisplayTransformer(), remote);
    }
    catch (RequestException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.toString());
    }
    catch (Exception e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
    }
  }
  
  
  private Transformer getStateListDisplayTransformer() throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/state-list-display.xsl");
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
  
}
