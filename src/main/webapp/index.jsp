<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Views of XSAMS</title>
    </head>
    <body>
        <h1>Views of an XSAMS document</h1>
        <form  action="line-list" method="get">
          <p>
            List of radiative transitions for XSAMS document at URL: 
            <input type="text" size="96" name="url"/>
            <input type="submit"/>
          </p>
        </form>
        <form action="state-list" method="get">
          <p>
            List of state for XSAMS document at URL: 
            <input type="text" size="96" name="url"/>
            <input type="submit"/>
          </p>
        </form>
    </body>
</html>
