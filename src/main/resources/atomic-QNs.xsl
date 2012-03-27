<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3">
          
  <xsl:template match="xsams:TotalAngularMomentum">
    <i>J</i>
    <xsl:text> = </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:Kappa">
    <i>&#954;</i>
    <xsl:text> = </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:Parity">
    <xsl:text>parity = </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:HyperfineMomentum">
    <i>F</i>
    <xsl:text> = </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:MagneticQuantumNumber">
    <i>m</i>
    <xsl:text> = </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:Component">
    <xsl:for-each select="xsams:Configuration/xsams:ConfigurationLabel"><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:for-each>
    <xsl:for-each select="xsams:Configuration/xsams:AtomicCore/xsams:ElementCore"><xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>] </xsl:text></xsl:for-each>
    <xsl:for-each select="xsams:Configuration/xsams:Shells/xsams:Shell">
      <xsl:value-of select="xsams:PrincipalQuantumNumber"/>
      <xsl:choose>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=0"><xsl:text>s</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=1"><xsl:text>p</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=2"><xsl:text>d</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=3"><xsl:text>f</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=4"><xsl:text>g</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=5"><xsl:text>h</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=6"><xsl:text>i</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=7"><xsl:text>k</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=8"><xsl:text>l</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=9"><xsl:text>m</xsl:text></xsl:when>
        <xsl:when test="xsams:OrbitalAngularMomentum/xsams:Value=10"><xsl:text>n</xsl:text></xsl:when>
      </xsl:choose>
      <sup><xsl:value-of select="xsams:NumberOfElectrons"/></sup>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:for-each select="xsams:Term/xsams:LS">
      <sup><xsl:value-of select="(xsams:S*2)+1"/></sup>
      <xsl:choose>
        <xsl:when test="xsams:L/xsams:Value=0"><xsl:text>S</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=1"><xsl:text>P</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=2"><xsl:text>D</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=3"><xsl:text>F</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=4"><xsl:text>G</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=5"><xsl:text>H</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=6"><xsl:text>I</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=7"><xsl:text>K</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=8"><xsl:text>L</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=9"><xsl:text>M</xsl:text></xsl:when>
        <xsl:when test="xsams:L/xsams:Value=10"><xsl:text>N</xsl:text></xsl:when>
      </xsl:choose>
      <sub><xsl:value-of select="../../../../xsams:AtomicQuantumNumbers/xsams:TotalAngularMomentum"/></sub>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:template>
    
</xsl:stylesheet>
