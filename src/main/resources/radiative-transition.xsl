<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3">
  
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  <xsl:param name="id"/>
  
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Single-transition view of XSAMS</title>
      </head>
      <body>
        <h1>Single-transition view of XSAMS</h1>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:text>Data set: </xsl:text><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        <p><xsl:text>Transition: </xsl:text><xsl:value-of select="$id"/></p>
        <xsl:apply-templates select="xsams:Processes/xsams:Radiative/xsams:RadiativeTransition[@id=$id]"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:EnergyWavelength">
    <xsl:for-each select="xsams:Wavenumber">
      <p>
        <xsl:text>Wavenumber: </xsl:text>
        <xsl:call-template name="full-quantity">
          <xsl:with-param name="quantity"><xsl:copy-of select="."/></xsl:with-param>
        </xsl:call-template>
      </p>
    </xsl:for-each>
    <xsl:for-each select="xsams:Frequency">
      <p>
        <xsl:text>Frequency: </xsl:text>
        <xsl:call-template name="full-quantity">
          <xsl:with-param name="quantity"><xsl:copy-of select="."/></xsl:with-param>
        </xsl:call-template>
      </p>
    </xsl:for-each>
    <xsl:for-each select="xsams:Wavelength">
      <p>
        <xsl:text>Wavelength: </xsl:text>
        <xsl:call-template name="full-quantity">
          <xsl:with-param name="quantity"><xsl:copy-of select="."/></xsl:with-param>
        </xsl:call-template>
      </p>
    </xsl:for-each>
    <xsl:for-each select="xsams:Energy">
      <p>
        <xsl:text>Energy: </xsl:text>
        <xsl:call-template name="full-quantity">
          <xsl:with-param name="quantity"><xsl:copy-of select="."/></xsl:with-param>
        </xsl:call-template>
      </p>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="xsams:Probability">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xsams:TransitionProbabilityA">
    <xsl:call-template name="labelled-quantity">
      <xsl:with-param name="label">Einstein <i>A</i> coefficient</xsl:with-param>
      <xsl:with-param name="quantity" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xsams:Log10WeightedOscillatorStrength">
    <xsl:call-template name="labelled-quantity">
      <xsl:with-param name="label">log<sub>10</sub>(weighted oscillator strength)</xsl:with-param>
      <xsl:with-param name="quantity" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="labelled-quantity">
    <xsl:param name="label"/>
    <xsl:param name="quantity"/>
    <p>
      <xsl:value-of select="$label"/>
      <xsl:text>: </xsl:text>
      <xsl:call-template name="full-quantity"><xsl:with-param name="quantity" select="$quantity"/></xsl:call-template>
    </p>
  </xsl:template>
  
  <xsl:template name="full-quantity">
    <xsl:param name="quantity"/>
    <xsl:value-of select="xsams:Value"/>
    <xsl:choose>
      <xsl:when test="xsams:Accuracy">
        <xsl:text> ± </xsl:text>
        <xsl:choose>
          <xsl:when test="xsams:Accuracy/@relative='true'">
            <xsl:value-of select="xsams:Value * xsams:Accuracy"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="xsams:Accuracy"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(xsams:Value/@units='unitless')">
          <xsl:text> </xsl:text>
          <xsl:value-of select="xsams:Value/@units"/>
        </xsl:if>
        <xsl:if test="xsams:Accuracy/@type">
          <xsl:text> (uncertainty is </xsl:text><xsl:value-of select="xsams:Accuracy/@type"/><xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if test="xsams:Accuracy/@confidenceInterval">
          <xsl:text> (</xsl:text><xsl:value-of select="xsams:Accuracy/@confidenceInterval"/><xsl:text> confidence)</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(xsams:Value/@units='unitless')">
          <xsl:text> </xsl:text>
          <xsl:value-of select="xsams:Value/@units"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="quantity-with-unit">
    <xsl:param name="quantity"/>
    <xsl:value-of select="xsams:Value"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="xsams:Value/@units"/>
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
  
</xsl:stylesheet>