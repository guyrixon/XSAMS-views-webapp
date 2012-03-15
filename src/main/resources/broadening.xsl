<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="1.0">
  
  <!-- Specifies the transition for which to display broadening. -->
  <xsl:param name="id"/>
  
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Broadening view of XSAMS</title>
        <link rel="stylesheet" href="../xsams-views.css" type="text/css"/>
      </head>
      <body>
        <h1>Broadening of a single radiative-transition in XSAMS</h1>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:RadiativeTransition">
    <xsl:if test="@id=$id">
      <p><xsl:text>Transition ID: </xsl:text><xsl:value-of select="@id"/></p>
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xsams:EnergyWavelength">
    <xsl:if test="xsams:Wavelength">
      <p>
        <xsl:text>Wavelength = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Wavelength"/></xsl:call-template>
      </p> 
    </xsl:if>
    <xsl:if test="xsams:Frequency">
      <p>
        <xsl:text>Frequency = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Frequency"/></xsl:call-template>
      </p>
    </xsl:if>
    <xsl:if test="xsams:Wavenumber">
      <p>
        <xsl:text>Wavenumber = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Wavenumber"/></xsl:call-template>  
      </p>
    </xsl:if>
    <xsl:if test="xsams:Energy">
      <p>
        <xsl:text>Transition energy = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Energy"/></xsl:call-template>  
      </p>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xsams:Broadening">
    <h2><xsl:text>Broadening: </xsl:text><xsl:value-of select="@name"/></h2>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xsams:Lineshape">
    <h3><xsl:text>Line shape: </xsl:text><xsl:value-of select="@name"/></h3>
    <p><xsl:value-of select="xsams:Comments"/></p>
    <p>Characterized by:</p>
    <dl>
    <xsl:for-each select="xsams:LineshapeParameter">
      <dt><xsl:value-of select="@name"/></dt>
      <xsl:choose>
        <xsl:when test="xsams:Value">
          <dd><xsl:text>= </xsl:text><xsl:value-of select="xsams:Value"/></dd>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="function-ref" select="xsams:FitParameters/@functionRef"/>
          <xsl:variable name="function" select="/xsams:XSAMSData/xsams:Functions/xsams:Function[@functionID=$function-ref]"/>
          <xsl:variable name="fit-parameters" select="xsams:FitParameters"/>
          <dd>
            <xsl:text>= </xsl:text>
            <xsl:value-of select="$function/xsams:Expression"/>
            <xsl:if test="$function/xsams:Expression/@computerLanguage">
              <xsl:text> (in </xsl:text><xsl:value-of select="$function/xsams:Expression/@computerLanguage"/><xsl:text>)</xsl:text>
            </xsl:if>   
            <xsl:text> where:</xsl:text>
            <ul>
              <xsl:for-each select="$function/xsams:Arguments/xsams:Argument">
                <xsl:variable name="name" select="@name"/>
                <li>
                  <xsl:value-of select="@name"/>
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="@units"/>
                  <xsl:text>; valid from </xsl:text>
                  <xsl:value-of select="$fit-parameters/xsams:FitArgument[@name=$name]/xsams:LowerLimit"/>
                  <xsl:text> to </xsl:text>
                  <xsl:value-of select="$fit-parameters/xsams:FitArgument[@name=$name]/xsams:UpperLimit"/>
                  <xsl:text>) </xsl:text>
                  <xsl:value-of select="xsams:Description"/>
                </li>
               </xsl:for-each>
               <xsl:for-each select="$function/xsams:Parameters/xsams:Parameter">
                 <xsl:variable name="name" select="@name"/>
                 <li>
                   <xsl:value-of select="@name"/>
                   <xsl:text> = </xsl:text>
                   <xsl:value-of select="$fit-parameters/xsams:FitParameter[@name=$name]/xsams:Value"/>
                   <xsl:text> </xsl:text>
                   <xsl:value-of select="xsams:Description"/>
                 </li>
               </xsl:for-each>
            </ul>
          </dd>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    </dl>
  </xsl:template>
  
  <xsl:template name="value-with-unit">
    <xsl:param name="quantity"/>
    <xsl:value-of select="$quantity/xsams:Value"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$quantity/xsams:Value/@units"/>
  </xsl:template>
  
  <xsl:template match="text() | @*"/>
  
</xsl:stylesheet>