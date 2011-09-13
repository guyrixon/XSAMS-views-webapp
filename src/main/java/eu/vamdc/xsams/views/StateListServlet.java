package eu.vamdc.xsams.views;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author Guy Rixon
 */
public class StateListServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws IOException, ServletException {
    URL u = new URL(request.getParameter("url"));
    StreamSource in = new StreamSource(u.openStream());
    
    StreamResult out = new StreamResult(response.getOutputStream());
    transform(in, out, getStateListDisplayTransformer(), u);
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
  
  private void transform(StreamSource in, StreamResult out, Transformer t, URL u)
      throws ServletException {
    try {
      String url = URLEncoder.encode(u.toString(), "UTF-8");
      t.setParameter("xsamsUrl", u.toString());
      t.setParameter("lineListUrl", "line-list?url="+url);
      t.setParameter("selectedStateUrl", "state?url="+url);
      t.transform(in, out);
    }
    catch (Exception e) {
      throw new ServletException(e);
    }
  }
  
}
