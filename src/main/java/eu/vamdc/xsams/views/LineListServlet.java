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
    String key = getKey(request);
    StreamSource in = getData(key);
    String stateListUrl = "../state-list/" + key;
    response.setContentType("text/html");
    PrintWriter w = response.getWriter();
    w.println("<html>");
    w.println("<head>");
    w.println("<title>Views of XSAMS</title>");
    w.println("</head>");
    w.println("<body>");
    w.println("<p>(<a href='" + stateListUrl + "'>Switch to view of states</a>)</p>");
    File tmp = File.createTempFile("xsams", null);
    StreamResult tmpOut = new StreamResult(new FileOutputStream(tmp));
    StreamSource tmpIn = new StreamSource(new FileInputStream(tmp));
    StreamResult out = new StreamResult(w);
    transform(in, tmpOut, getLineListTransformer());
    transform(tmpIn, out, getLineListDisplayTransformer());
    w.print("</body>");
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
  
  private Transformer getLineListDisplayTransformer() throws ServletException {
    InputStream q = this.getClass().getResourceAsStream("/line-list-display.xsl");
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
