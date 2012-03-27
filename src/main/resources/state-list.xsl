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
  
  
  
  <xsl:template match="xsams:AtomicComposition/xsams:Component">
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
    
    <xsl:template name="value-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="$quantity/xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="@*|text()"/>
    
</xsl:stylesheet>
