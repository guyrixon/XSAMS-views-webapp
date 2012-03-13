<%-- 
    Document   : later
    Created on : Mar 12, 2012, 5:28:24 PM
    Author     : Guy Rixon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="refresh" content="5"/>
    <title>Download in progress</title>
  </head>
  <body>
    <h1>Download in progress</h1>
    <p>The data are being downloaded. Reload this page to see the results (reloading
       is done automatically in most browsers).</p>
    <p>Bytes downloaded so far: <%=request.getAttribute("eu.vamdc.xsams.views.bytesdownloaded")%></p>
  </body>
</html>
