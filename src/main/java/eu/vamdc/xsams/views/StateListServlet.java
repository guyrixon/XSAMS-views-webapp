package eu.vamdc.xsams.views;

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
public class StateListServlet extends TransformingServlet {

  @Override
  protected void get(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    String key = getKey(request);
    StreamSource in = getData(key);
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    String u = getOriginalUrlEncoded(key);
    String reloadUrl = (u == null)? null : Locations.getServiceLocation(request) + "?url=" + u;
    PrintWriter w = response.getWriter();
    startXhtmlUtf8Document(w, "State-list view of XSAMS");
    w.println("<body>");
    w.println("<p>(<a href='" + 
              Locations.getLineListLocation(request, key) + 
              "'>Switch to view of radiative transitions</a>)</p>");
    if (reloadUrl != null) {
      w.println("<p>(<a href='" + reloadUrl + "'>Reload orginal data</a>)</p>");
    }
    StreamResult out = new StreamResult(w);
    transform(in, out, getStateListDisplayTransformer(Locations.getStateLocation(request, key)));
    w.println("</body>");
    w.println("</html>");
  }
  
  
  private Transformer getStateListDisplayTransformer(String stateLocation) 
      throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/state-list-display.xsl");
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
  
}
