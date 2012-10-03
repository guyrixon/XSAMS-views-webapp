<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0">

  <xsl:output method="text" media-type="text/csv" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
  
  <xsl:strip-space elements="*" />
  
  <xsl:template match="//tr">
    <xsl:for-each select="th|td">
      <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
      <xsl:choose>
        <xsl:when test="position() = last()">
          <xsl:text>&#xd;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>,</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
  
</xsl:stylesheet>