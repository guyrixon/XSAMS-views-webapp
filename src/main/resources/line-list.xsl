<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Transformation from XSAMS (11.05 VAMDC edition) to list of atomic lines.
    This is a flattening and denormalization of the XSAMS structure to simplify
    the subsequent transformation to a tabular representation.
    
    The output has root element line-list (default name-space) which contains
    zero or more atomic-line elements (default namespace) followed by 
    zero or more molecular-line elements (default namespace).    
    
    In an atomic-line element there is, in order:
    - exactly one RadiativeTransition element;
    - exactly two xsams:AtomicState elements for the initial and final states, in that order;
    - zero or one xsams:IonCharge;
    - zero or one xsams:IsoElectronicSequence;
    - zero or one xsams:Inchi;
    - zero or one xsams:InchiKey;
    - zero or one xsams:IsotopeParameters;
    - zero or one xsams:ChemicalElement.
    
    In an molecular-line element there is, in order:
    - exactly one RadiativeTransition element;
    - exactly two xsams:MolecularState elements for the initial and final states, in that order;
    - zero or one xsams:MolecularChemicalSpecies.
    
    All the XSAMS elements are copied from the description of the specie owning the states.

    Wherever an XSAMS element appears in the output, it is a complete copy from the input and
    subsequent transformations may depend on the correct XSAM structure within that element.
    
    Comments and source references are discarded in this transformation.
-->
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
  
  <xsl:param name="state-location"/>
  <xsl:param name="state-list-location"/>
  <xsl:param name="broadening-location"/>
  <xsl:param name="css-location"/>
    
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
  <xsl:key name="atomicState" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
  <xsl:key name="molecularState" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
    
    <!-- On finding the start of the XSAMs, write the shell of the HTML page.
         The page contains one table. Other templates fill in rows of the table -->
  <xsl:template match="/xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Line-list view of XSAMS</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
      </head>
      <body>
        <h1>Line-list view of XSAMS</h1>
        <p>
          <xsl:text>(</xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$state-list-location"/></xsl:attribute>
            <xsl:text>Switch to view of states</xsl:text>
          </a>
          <xsl:text>)</xsl:text>
        </p>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        <xsl:apply-templates select="xsams:Processes/xsams:Radiative"/>
      </body>
    </html>
  </xsl:template>       
         
  <xsl:template match="/xsams:XSAMSData/xsams:Processes/xsams:Radiative">
    <table rules="all">
      <tr>
        <th>Species</th>
        <th>&#955;/&#957;/n/E</th>
        <th>Probability</th>
        <th>Upper state</th>
        <th>Lower state</th>
        <th>Broadening</th>
      </tr>
      <xsl:text>
      </xsl:text>
      <xsl:apply-templates select="xsams:RadiativeTransition"/>
    </table>
        
  </xsl:template>
  
  
    
    
    <!-- Matches transitions. -->
    <xsl:template match="xsams:RadiativeTransition">
      <!-- These variables hold ID strings for the states. -->
      <xsl:variable name="upperStateId" select="xsams:UpperStateRef"/>
      <xsl:variable name="lowerStateId" select="xsams:LowerStateRef"/>
      
      <!-- These variables contain the node-sets for the XML representing the states. --> 
      <xsl:if test="key('atomicState', $lowerStateId)">
        <xsl:variable name="lowerState" select="key('atomicState', $lowerStateId)"/>
        <xsl:variable name="upperState" select="key('atomicState', $upperStateId)"/>
        
        <tr>
          <td>
            <xsl:call-template name="specie">
              <xsl:with-param name="specie" select="$lowerState/../../../xsams:ChemicalElement/xsams:ElementSymbol"/>
              <xsl:with-param name="mass-number" select="$lowerState/../../xsams:IsotopeParameters/xsams:MassNumber"/>
              <xsl:with-param name="charge" select="$lowerState/../xsams:IonCharge"/>
            </xsl:call-template></td>
          <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:Probability"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="$upperState"/></xsl:call-template></td>
          <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="$lowerState"/></xsl:call-template></td>
          <td><xsl:call-template name="broadening"><xsl:with-param name="transition" select="."/></xsl:call-template></td>
        </tr>
      </xsl:if>
      
      
      <xsl:if test="key('molecularState', $upperStateId)">
        <xsl:variable name="upperState" select="key('molecularState', $upperStateId)"/>
        <xsl:variable name="lowerState" select="key('molecularState', $lowerStateId)"/>
        
        <tr>
          <xsl:variable name="specie">
            <xsl:if test="$lowerState/../xsams:MolecularChemicalSpecies/xsams:ChemicalName">
              <xsl:value-of select="$lowerState/../xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
              <xsl:text> &#8212; </xsl:text>
            </xsl:if>
            <xsl:value-of select="$lowerState/../xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
          </xsl:variable>
          <td>
            <xsl:call-template name="specie">
              <xsl:with-param name="specie" select="$specie"/>
              <xsl:with-param name="charge" select="$lowerState/../xsams:MolecularChemicalSpecies/xsams:IonCharge"/>
            </xsl:call-template></td>
          <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:Probability"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="molecular-state"><xsl:with-param name="state" select="$upperState"/></xsl:call-template></td>
          <td><xsl:call-template name="molecular-state"><xsl:with-param name="state" select="$lowerState"/></xsl:call-template></td>
          <td><xsl:call-template name="broadening"><xsl:with-param name="transition" select="."/></xsl:call-template></td>
        </tr>
        
      </xsl:if>
      
      <xsl:if test="not(xsams:UpperStateRef)">
        <tr>
          <td/>
          <td/>
          <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:Probability"></xsl:with-param></xsl:call-template></td>
          <td/>
          <td/>
          <td><xsl:call-template name="broadening"><xsl:with-param name="transition" select="."/></xsl:call-template></td>
        </tr>
      </xsl:if>
        
    </xsl:template>
  
  
  <xsl:template name="specie">
    <xsl:param name="specie"/>
    <xsl:param name="mass-number"/>
    <xsl:param name="charge"/>
    <xsl:if test="$mass-number">
      <sup>
        <xsl:value-of select="$mass-number"/>
      </sup>
    </xsl:if>
    <xsl:value-of select="$specie"/>
    <xsl:choose>
      <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
      <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
      <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
      <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="wavelength">
    <xsl:param name="wl"/>
    <xsl:if test="$wl/xsams:Wavelength">
      <xsl:text> &#955;=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Wavelength"/></xsl:call-template>
    </xsl:if>
    <xsl:if test="$wl/xsams:Frequency">
      <xsl:text> &#957;=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Frequency"/></xsl:call-template>
    </xsl:if>
    <xsl:if test="$wl/xsams:Wavenumber">
      <xsl:text> n=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Wavenumber"/></xsl:call-template>
    </xsl:if>
    <xsl:if test="$wl/xsams:Energy">
      <xsl:text> E=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Energy"/></xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="probability">
    <xsl:param name="p"/>
    <xsl:if test="$p/xsams:TransitionProbabilityA">
      <xsl:text> A=</xsl:text>
      <xsl:value-of select="$p/xsams:TransitionProbabilityA/xsams:Value"/>
    </xsl:if>
    <xsl:if test="$p/xsams:OscillatorStrength">
      <xsl:text> f=</xsl:text>
      <xsl:value-of select="$p/xsams:OscillatorStrength/xsams:Value"/>
    </xsl:if>
    <xsl:if test="$p/xsams:WeightedOscillatorStrength">
      <xsl:text> gf=</xsl:text>
      <xsl:value-of select="$p/xsams:WeightedOscillatorStrength/xsams:Value"/>
    </xsl:if>
    <xsl:if test="$p/xsams:Log10WeightedOscillatorStrength">
      <xsl:text> log</xsl:text><sub>10</sub><xsl:text>gf=</xsl:text>
      <xsl:value-of select="$p/xsams:Log10WeightedOscillatorStrength/xsams:Value"/>
    </xsl:if>
  </xsl:template>
  
  
  <!-- Writes a hyperlink to the page for the given state. 
    The text of the link shows the description and state energy. -->
  <xsl:template name="molecular-state">
    <xsl:param name="state"/>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$state-location"/>
        <xsl:text>?id=</xsl:text>
        <xsl:value-of select="$state/@stateID"/>
      </xsl:attribute>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:MolecularStateCharacterisation/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
      <xsl:text> &#8212; </xsl:text>
      <xsl:apply-templates select="$state/xsams:Case"/>
    </a>
  </xsl:template>
  
  <!-- Writes a hyperlink to the page for the given state. 
    The text of the link shows the description and state energy. -->
  <xsl:template name="atomic-state">
    <xsl:param name="state"/>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$state-location"/>
        <xsl:text>?id=</xsl:text>
        <xsl:value-of select="$state/@stateID"/>
      </xsl:attribute>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:AtomicNumericalData/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
      <xsl:text> &#8212; </xsl:text>
      <xsl:apply-templates select="$state/xsams:AtomicComposition/xsams:Component"/>
      <xsl:apply-templates select="$state/xsams:AtomicQuantumNumbers"/>
    </a>  
  </xsl:template>
  
  
  <xsl:template name="broadening">
    <xsl:param name="transition"/>
    <xsl:if test="$transition/xsams:Broadening">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$broadening-location"/>
          <xsl:text>?id=</xsl:text>
          <xsl:value-of select="$transition/@id"/>
        </xsl:attribute>
        <xsl:text>Detail </xsl:text>
      </a>
    </xsl:if>
  </xsl:template>
  
  
  
  <xsl:template name="value-with-unit">
    <xsl:param name="quantity"/>
    <xsl:value-of select="$quantity/xsams:Value"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$quantity/xsams:Value/@units"/>
  </xsl:template>
  
  
  <!-- The following templates generate parts of the state description for atomic states. -->
  
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
    </xsl:for-each>
  </xsl:template>
  
  
  

  <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
