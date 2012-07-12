<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="2.0">
  
  <xsl:template match="/xsams:XSAMSData/xsams:Sources/xsams:Source[1]">
    <p>
      <xsl:if test="matches(xsams:Comments, 'This Source is a self-reference.')">
        <xsl:value-of select="substring(@sourceID,2)"></xsl:value-of>
        <xsl:text> : </xsl:text>
        <xsl:value-of select="substring-after(xsams:Comments, 'Query was: ')"/>  
      </xsl:if>
      <xsl:if test="starts-with(xsams:Comments, 'QUERY')">
        <xsl:value-of select="substring(@sourceID,2)"></xsl:value-of>
        <xsl:text> : </xsl:text>
        <xsl:value-of select="substring-after(xsams:Comments, 'QUERY ')"/>  
      </xsl:if>
    </p>
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
  
</xsl:stylesheet>