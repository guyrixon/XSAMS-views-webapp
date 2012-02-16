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
    xmlns:xsams="http://vamdc.org/xml/xsams/0.3">
  
  <xsl:param name="state-location"/>
  <xsl:param name="state-list-location"/>
  <xsl:param name="broadening-location"/>
    
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
  <xsl:key name="atomicState" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
  <xsl:key name="molecularState" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
    
    <!-- On finding the start of the XSAMs, write the shell of the HTML page.
         The page contains one table. Other templates fill in rows of the table -->
  <xsl:template match="/xsams:XSAMSData/xsams:Processes/xsams:Radiative">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Line-list view of XSAMS</title>    
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
        <table rules="all">
          <tr>
            <th>Species</th>
            <th>Ion charge</th>
            <th>&#955;/&#957;/n/E</th>
            <th>Probability</th>
            <th>Upper state</th>
            <th>Lower state</th>
            <th>Broadening</th>
          </tr>
          <xsl:text>
          </xsl:text>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
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
          <td><xsl:call-template name="atomic-specie"><xsl:with-param name="element" select="$lowerState/../../../xsams:ChemicalElement"/><xsl:with-param name="isotope-parameters" select="$lowerState/../../xsams:IsotopeParameters"/></xsl:call-template></td>
          <td><xsl:value-of select="$lowerState/../xsams:IonCharge"/></td>
          <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:Probability"></xsl:with-param></xsl:call-template></td>
          <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="$upperState"/></xsl:call-template></td>
          <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="$lowerState"/></xsl:call-template></td>
          <td><xsl:call-template name="broadening"><xsl:with-param name="transition" select="."/></xsl:call-template></td>
        </tr>
      </xsl:if>
      
      
      <xsl:if test="key('molecularState', $upperStateId)">
        <xsl:variable name="upperState" select="key('molecularState', $upperStateId)"/>
        <xsl:variable name="lowerState" select="key('molecularState', $upperStateId)"/>
        
        <tr>
          <td><xsl:call-template name="molecular-specie"><xsl:with-param name="species" select="$lowerState/../xsams:MolecularChemicalSpecies"></xsl:with-param></xsl:call-template></td>
          <td><xsl:value-of select="xsams:IonCharge"/></td>
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
  
  
  <xsl:template name="atomic-specie">
    <xsl:param name="element"/>
    <xsl:param name="isotope-parameters"/>
    <xsl:if test="$isotope-parameters/xsams:MassNumber">
      <sup>
        <xsl:value-of select="$isotope-parameters/xsams:MassNumber"/>
      </sup>
    </xsl:if>
    
    <xsl:value-of select="$element/xsams:ElementSymbol"/>
  </xsl:template>
  
  <xsl:template name="molecular-specie">
    <xsl:param name="species"/>
    <xsl:value-of select="$species/xsams:ChemicalName"/>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="$species/xsams:OrdinaryStructuralFormula"/>
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
      <xsl:choose>
        <xsl:when test="$state/xsams:Description or $state/xsams:MolecularStateCharacterisation/xsams:StateEnergy">
          <xsl:value-of select="$state/xsams:Description"/>
          <xsl:text> </xsl:text>
          <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:MolecularStateCharacterisation/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>?</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </a>    
  </xsl:template>
  
  <!-- Writes a hyperlink to the page for the given state. 
    The text of the link shows the description and state energy. -->
  <xsl:template name="atomic-state">
    <xsl:param name="state"/>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$state-location"/>
        <xsl:text>?stateID=</xsl:text>
        <xsl:value-of select="$state/@stateID"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$state/xsams:Description or $state/xsams:AtomicNumericalData/xsams:StateEnergy">
          <xsl:value-of select="$state/xsams:Description"/>
          <xsl:text> </xsl:text>
          <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:AtomicNumericalData/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>?</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
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
        <xsl:for-each select="$transition/xsams:Broadening">
          <xsl:value-of select="@name"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </a>
    </xsl:if>
  </xsl:template>
  
  
  
  <xsl:template name="value-with-unit">
    <xsl:param name="quantity"/>
    <xsl:value-of select="$quantity/xsams:Value"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$quantity/xsams:Value/@units"/>
  </xsl:template>
  
  
  
  
  
  
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
