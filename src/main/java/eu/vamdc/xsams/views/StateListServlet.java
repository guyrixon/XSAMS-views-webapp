package eu.vamdc.xsams.views;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
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
    URL reload = getOriginalUrl(key);
    response.setContentType("text/html");
    String lineListUrl = "../line-list/" + key;
    String reloadUrl = "../service?url=";
    PrintWriter w = response.getWriter();
    w.println("<html>");
    w.println("<head>");
    w.println("<title>Views of XSAMS</title>");
    w.println("</head>");
    w.println("<body>");
    w.println("<p>(<a href='" + lineListUrl + "'>Switch to view of raditive transitions</a>)</p>");
    StreamResult out = new StreamResult(w);
    transform(in, out, getStateListDisplayTransformer());
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
