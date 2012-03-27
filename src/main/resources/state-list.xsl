<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
    xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
    xmlns:nltcs="http://vamdc.org/xml/xsams/0.3/cases/nltcs"
    xmlns:ltcs="http://vamdc.org/xml/xsams/0.3/cases/ltcs"
    xmlns:dcs="http://vamdc.org/xml/xsams/0.3/cases/dcs"
    xmlns:hunda="http://vamdc.org/xml/xsams/0.3/cases/hunda"
    xmlns:hundb="http://vamdc.org/xml/xsams/0.3/cases/hundb"
    xmlns:stcs="http://vamdc.org/xml/xsams/0.3/cases/stcs"
    xmlns:lpcs="http://vamdc.org/xml/xsams/0.3/cases/lpcs"
    xmlns:asymcs="http://vamdc.org/xml/xsams/0.3/cases/asymcs"
    xmlns:asymos="http://vamdc.org/xml/xsams/0.3/cases/asymos"
    xmlns:sphcs="http://vamdc.org/xml/xsams/0.3/cases/sphcs"
    xmlns:sphos="http://vamdc.org/xml/xsams/0.3/cases/sphos"
    xmlns:ltos="http://vamdc.org/xml/xsams/0.3/cases/ltos"
    xmlns:lpos="http://vamdc.org/xml/xsams/0.3/cases/lpos"
    xmlns:nltos="http://vamdc.org/xml/xsams/0.3/cases/nltos">
        
  <!-- Display rules for molecular states in the case-by-case framework. -->
  <xsl:include href="cbc.xsl"/>
  
  <!-- Display rules for atomic states. -->
  <xsl:include href="atomic-QNs.xsl"/>
    
  <xsl:param name="line-list-location"/>
  <xsl:param name="state-location"/>
  <xsl:param name="css-location"/>
    
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>State-list view of XSAMS</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
      </head>
      <body>
        <h1>State-list view of XSAMS</h1>
        <p>
          <xsl:text>(</xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$line-list-location"/></xsl:attribute>
            <xsl:text>Switch to view of radiative transitions</xsl:text>
          </a>
          <xsl:text>)</xsl:text>
        </p>
        
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        
        
        <table rules="all">
          <tr>
            <th>Species</th>
            <th>State</th>
            <th>Energy</th>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
    
  <xsl:template match="xsams:Molecule">
    <xsl:variable name="specie">
      <xsl:if test="xsams:MolecularChemicalSpecies/xsams:ChemicalName">
        <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
        <xsl:text> - </xsl:text>
      </xsl:if>
      <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
    </xsl:variable>
    <xsl:variable name="charge"><xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:IonCharge"/></xsl:variable>
    <xsl:for-each select="xsams:MolecularState">
      <xsl:sort select="xsams:MolecularStateCharacterisation/xsams:StateEnergy/xsams:Value"/>
      <xsl:call-template name="state">
        <xsl:with-param name="specie" select="$specie"/>
        <xsl:with-param name="charge" select="$charge"/>
        <xsl:with-param name="state" select="."/>
        <xsl:with-param name="energy" select="xsams:MolecularStateCharacterisation/xsams:StateEnergy"/>
      </xsl:call-template>
    </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="xsams:Ion">
      <xsl:for-each select="xsams:AtomicState">
        <xsl:sort select="xsams:AtomicNumericalData/xsams:StateEnergy/xsams:value"/>
        <xsl:call-template name="state">
          <xsl:with-param name="specie" select="ancestor::xsams:Atom/xsams:ChemicalElement/xsams:ElementSymbol"/>
          <xsl:with-param name="mass-number" select="ancestor::xsams:Isotope/xsams:IsotopeParameters/xsams:MassNumber"/>
          <xsl:with-param name="state" select="."/>
          <xsl:with-param name="charge" select="../xsams:IonCharge"/>
          <xsl:with-param name="energy" select="xsams:AtomicNumericalData/xsams:StateEnergy"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:template>
  
  <!-- Write the ionic charge as a super-scripted string: ... 3-, 2-, -, +, 2+, 3+ etc.
       Nothing is written for neutral ions. -->
  <xsl:template name="ion-charge">
    <xsl:param name="charge"/>
    <xsl:choose>
      <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
      <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
      <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
      <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- Writes a table row for an atomic or molecular state.
       The species column covers the given species-name, isotope (for atomic ions) and charge.
       The state column includes the description from the XSAMS and a Q-M summary generated by other templates.
       The energy column includes the value and unit of the state energy.
       The state column is hyperlinked to the page for the state details. -->
  <xsl:template name="state">
    <xsl:param name="specie"/>
    <xsl:param name="mass-number"/>
    <xsl:param name="charge"/>
    <xsl:param name="state"/>
    <xsl:param name="energy"/>
    <tr>
      <td>
        <xsl:if test="$mass-number">
          <sup><xsl:value-of select="$mass-number"/></sup>
        </xsl:if>
        <xsl:value-of select="$specie"/>
        <xsl:call-template name="ion-charge"><xsl:with-param name="charge"><xsl:value-of select="$charge"/></xsl:with-param></xsl:call-template>
      </td>
      <td>
        <xsl:value-of select="$state/xsams:Description"/>
        <xsl:text> &#8212; </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> &#8212; </xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$state-location"/>
            <xsl:text>?id=</xsl:text>
            <xsl:value-of select="$state/@stateID"/>
          </xsl:attribute>
          <xsl:text>detail</xsl:text>
        </a>    
      </td>
      <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$energy"/></xsl:call-template></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xsams:AtomicComposition">
    <xsl:apply-templates/>
  </xsl:template>
 
 <xsl:template name="value-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="$quantity/xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="@*|text()"/>
    
</xsl:stylesheet>
