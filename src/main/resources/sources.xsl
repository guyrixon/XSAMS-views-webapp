<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="2.0">
  
  <xsl:template name="query-source">
    <xsl:param name="source"/>
    <xsl:for-each select="$source">
      <xsl:if test="matches(xsams:Comments, 'This Source is a self-reference.')">
        <xsl:value-of select="substring(@sourceID,2)"></xsl:value-of>
        <xsl:text> : </xsl:text>
        <xsl:value-of select="substring-after(xsams:Comments, 'Query was: ')"/>  
      </xsl:if>
      <xsl:if test="starts-with($source/xsams:Comments, 'QUERY')">
        <xsl:value-of select="substring(@sourceID,2)"></xsl:value-of>
        <xsl:text> : </xsl:text>
        <xsl:value-of select="substring-after(xsams:Comments, 'QUERY ')"/>  
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="sources-short">
    <xsl:param name="sources"/>
    <xsl:for-each select="$sources">
      <xsl:if test="not(position()=1)"><xsl:text>; </xsl:text></xsl:if>
      <xsl:choose>
        <xsl:when test="count(xsams:Authors/xsams:Author) = 1"><xsl:value-of select="xsams:Authors/xsams:Author[1]/xsams:Name"/></xsl:when>
        <xsl:when test="count(xsams:Authors/xsams:Author) = 2"><xsl:value-of select="xsams:Authors/xsams:Author[1]/xsams:Name"/><xsl:text> and </xsl:text><xsl:value-of select="xsams:Authors/xsams:Author[2]/xsams:Name"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="xsams:Authors/xsams:Author[1]/xsams:Name"/><xsl:text> et al. </xsl:text></xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:value-of select="xsams:Year"/>  
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="source-long">
    <xsl:param name="source"/>
    <xsl:for-each select="$source/xsams:Authors/xsams:Author">
      <xsl:choose>
        <xsl:when test="position() = 1"></xsl:when>
        <xsl:when test="position() = last()"><xsl:text> and </xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="xsams:Name"/>
    </xsl:for-each>
    <xsl:text>, </xsl:text>
    <xsl:if test="$source/xsams:Title">
      <i><xsl:value-of select="$source/xsams:Title"/></i>
      <xsl:text>, </xsl:text>  
    </xsl:if>
    <xsl:if test="$source/xsams:SourceName">
      <xsl:value-of select="$source/xsams:SourceName"/>
      <xsl:text>, </xsl:text>  
    </xsl:if>
    <xsl:if test="$source/xsams:Volume">
      <b><xsl:value-of select="$source/xsams:Volume"/></b>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$source/xsams:PageBegin and $source/xsams:PageEnd"><xsl:value-of select="$source/xsams:PageBegin"/><xsl:text>-</xsl:text><xsl:value-of select="$source/xsams:PageEnd"/><xsl:text>, </xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="$source/xsams:PageBegin"/><xsl:text>, </xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$source/xsams:Year"/>  
  </xsl:template>
  
</xsl:stylesheet>