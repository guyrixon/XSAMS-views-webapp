<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/1.0"
  version="2.0">
  
  <xsl:include href="cbc.xsl"/>
  
  <xsl:template name="molecule">
    <xsl:param name="molecule"/>
    <xsl:param name="state"/>
    <xsl:param name="state-location"/>
    
    <xsl:choose>
      <xsl:when test="$state">
        <a href="{$state-location}?id={$state/@stateID}">
          <xsl:call-template name="formula">
            <xsl:with-param name="formula" select="$molecule/xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula/xsams:Value"></xsl:with-param>
          </xsl:call-template>
          <xsl:variable name="charge" select="$state/../xsams:MolecularChemicalSpecies/xsams:IonCharge"/>
          <xsl:choose>
            <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
            <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
            <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
            <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
          </xsl:choose>
          <xsl:for-each select="$state/xsams:Case">
              <xsl:text> (</xsl:text>
              <xsl:apply-templates/>
              <xsl:text>)</xsl:text>
          </xsl:for-each>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formula">
          <xsl:with-param name="formula" select="$molecule/xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula/xsams:Value"></xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="charge" select="$molecule/xsams:MolecularChemicalSpecies/xsams:IonCharge"/>
        <xsl:choose>
          <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
          <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
          <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
          <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:template>
  
  <xsl:template name="atomic-ion">
    <xsl:param name="ion"/>
    <xsl:param name="state"/>
    <xsl:param name="state-location"/>
    <xsl:choose>
      <xsl:when test="$state">
        <a href="{$state-location}?id={$state/@stateID}">
          <xsl:if test="$state/../../xsams:IsotopeParameters/xsams:MassNumber">
            <sup>
              <xsl:value-of select="$state/../../xsams:IsotopeParameters/xsams:MassNumber"/>
            </sup>
          </xsl:if>
          <xsl:value-of select="$state/../../../xsams:ChemicalElement/xsams:ElementSymbol"/>
          <xsl:choose>
            <xsl:when test="$state/../xsams:IonCharge=1"><sup>+</sup></xsl:when>
            <xsl:when test="$state/../xsams:IonCharge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
            <xsl:when test="$state/../xsams:IonCharge&gt;0"><sup><xsl:value-of select="$state/../xsams:IonCharge"/>+</sup></xsl:when>
            <xsl:when test="$state/../xsams:IonCharge&lt;0"><sup><xsl:value-of select="$state/../xsams:IonCharge"/>-</sup></xsl:when>
          </xsl:choose>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$state/xsams:Description"/>
          <xsl:text>)</xsl:text>
        </a>
      </xsl:when>
      <xsl:otherwise>
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
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="particle">
    <xsl:param name="particle"/>
    <xsl:if test="$particle">
      <xsl:value-of select="$particle/@name"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="formula">
    <xsl:param name="formula"/>
    <xsl:if test="$formula">
      <xsl:variable name="f" select="translate($formula, '$', '')"/>
      <xsl:analyze-string select="$f" regex="(_)(\d+)|(\^)\d*\+|(\^)\d*\-">
        <xsl:matching-substring>
          <xsl:if test="regex-group(1)='_'">
            <sub><xsl:value-of select="regex-group(2)"/></sub>
          </xsl:if>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>