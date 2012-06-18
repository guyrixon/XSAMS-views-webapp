<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="1.0">
  
  <xsl:template name="molecule">
    <xsl:param name="molecule"/>
    <!--
    <xsl:if test="$molecule/xsams:MolecularChemicalSpecies/xsams:ChemicalName">
      <xsl:value-of select="$molecule/xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
      <xsl:text> &#8212; </xsl:text>
    </xsl:if>
    -->
    <xsl:value-of select="$molecule/xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
    <xsl:variable name="charge" select="$molecule/xsams:MolecularChemicalSpecies/xsams:IonCharge"/>
    <xsl:choose>
      <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
      <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
      <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
      <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="atomic-ion">
    <xsl:param name="ion"/>
    <xsl:if test="$ion">
      <xsl:if test="$ion/../xsams:IsotopeParameters/xsams:MassNumber">
        <sup>
          <xsl:value-of select="$ion/../xsams:IsotopeParameters/xsams:MassNumber"/>
        </sup>
      </xsl:if>
      <xsl:value-of select="$ion/../../xsams:ChemicalElement/xsams:ElementSymbol"/>
      <xsl:choose>
        <xsl:when test="$ion/xsams:IonCharge=1"><sup>+</sup></xsl:when>
        <xsl:when test="$ion/xsams:IonCharge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
        <xsl:when test="$ion/xsams:IonCharge&gt;0"><sup><xsl:value-of select="$ion/xsams:IonCharge"/>+</sup></xsl:when>
        <xsl:when test="$ion/xsams:IonCharge&lt;0"><sup><xsl:value-of select="$ion/xsams:IonCharge"/>-</sup></xsl:when>
      </xsl:choose>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="particle">
    <xsl:param name="particle"/>
    <xsl:if test="$particle">
      <xsl:value-of select="$particle/@name"/>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>