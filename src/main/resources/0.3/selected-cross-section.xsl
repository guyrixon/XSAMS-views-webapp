<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3">
  
  <xsl:param name="id"/>
  
  <xsl:template match="xsams:XSAMSData">
    <html>
      <head>
        <title>Absorption cross-section</title>
      </head>
      <body>
        <h1>Absorption cross-section</h1>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:AbsorptionCrossSection[@id=$id]">
    <p><xsl:value-of select="xsams:id"/></p>
    <p><xsl:value-of select="xsams:Description"/></p>
    
    <xsl:apply-templates select="xsams:Species"/>
    
    <table>
      <tr>
        <th>
          <xsl:value-of select="xsams:X/@parameter"/>
          <xsl:if test="xsams:X/@units and not(xsams:X/@units = 'undef')">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="xsams:X/@units"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </th>
        <th>
          <xsl:value-of select="xsams:Y/@parameter"/>
          <xsl:if test="xsams:Y/@units and not(xsams:Y/@units = 'undef')">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="xsams:Y/@units"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </th>
      </tr>
      <xsl:call-template name="x-y-row">
        <xsl:with-param name="x" select="xsams:X/xsams:DataList"/>
        <xsl:with-param name="y" select="xsams:Y/xsams:DataList"/>
      </xsl:call-template>
    </table>
  </xsl:template>
  
  <!-- Adapted from Stack Overflow: http://stackoverflow.com/questions/136500/does-xslt-have-a-split-function -->
  <xsl:template name="x-y-row">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:variable name="new-x" select="concat(normalize-space($x), ' ')"/> 
    <xsl:variable name="first-x" select="substring-before($new-x, ' ')"/> 
    <xsl:variable name="remaining-x" select="substring-after($new-x, ' ')"/>
    <xsl:variable name="new-y" select="concat(normalize-space($y), ' ')"/> 
    <xsl:variable name="first-y" select="substring-before($new-y, ' ')"/> 
    <xsl:variable name="remaining-y" select="substring-after($new-y, ' ')"/> 
    <tr>
      <td><xsl:value-of select="$first-x"/></td>
      <td><xsl:value-of select="$first-y"/></td>
    </tr>
    <xsl:if test="$remaining-x">
      <xsl:call-template name="x-y-row">
        <xsl:with-param name="x" select="$remaining-x"/>
        <xsl:with-param name="y" select="$remaining-y"/> 
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="xsamsSpecies">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="@xsams:StateRef">
    <p><xsl:text>State: </xsl:text><xsl:value-of select="."/></p>
  </xsl:template>
  
  <xsl:template match="@xsams:SpeciesRef">
    <p><xsl:text>Species: </xsl:text><xsl:value-of select="."/></p>
  </xsl:template>
  
  <xsl:template match="@*|text()"/>
</xsl:stylesheet>