<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
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
  
  <!-- Display rules for the paragraph identifying the data set. -->
  <xsl:include href="query-source.xsl"/>
  
  <!-- Display rules for naming species (inc. charge state). -->
  <xsl:include href="species-name.xsl"/>
  
  <xsl:param name="state-location"/>
  <xsl:param name="state-list-location"/>
  <xsl:param name="broadening-location"/>
  <xsl:param name="collision-list-location"/>
  <xsl:param name="css-location"/>
  <xsl:param name="js-location"/>
    
  <xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
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
        <script type="text/javascript">
          <xsl:text disable-output-escaping="yes">
            <![CDATA[
            function convertAllVacuumToAir() {
            var spans=document.getElementsByTagName("span");
            for (i = 0; i < spans.length; i++) {
              var unit = spans[i].getAttribute("wavelength")
              if (unit != undefined) {
                spans[i].textContent=vacuumToAir(spans[i].textContent, unit)
               }
            }
          }

          function convertAllAirToVacuum() {
            var spans=document.getElementsByTagName("span");
            for (i = 0; i < spans.length; i++) {
              var unit = spans[i].getAttribute("wavelength")
              if (unit != undefined) {
                spans[i].textContent=airToVacuum(spans[i].textContent, unit)
              }
            }
          }

          // Convert wavelength in vacuum to wavelength in air, IAU STP, both values in Angstrom
          function vacuumToAir(lVac, unit) {
            var s = 1.0e4 / toAngstroms(lVac, unit)
            var s2 = s * s
            var n = 1 + 0.0000834254 + (0.02406147 / (130.0 - s2)) + (0.00015998 / (38.9 - s2))
            return lVac / n
          }

          // Convert wavelength in air, IAU STP, to wavelength in vacuum, both values in Angstrom
          function airToVacuum(lAir, unit) {
            var s = 1.0e4 / toAngstroms(lAir, unit)
            var s2 = s * s
            var n = 1 + 0.00008336624212083 + (0.02408926869968 / (130.1065924522 - s2)) + (0.0001599740894897 / (38.92568793293 - s2))
            return lAir * n
          }

          // Convert wavelength in arbitrary unit (allowed by XSAMS) to Angstrom
          function toAngstroms(l, unit) {
            if (unit == "A" || unit == undefined) {
              return  l
            }
            if (unit == "m") {
              return l * 1.0e10
            }
            if (unit == "cm") {
              return l * 1.0e8
            }
            if (unit == "nm") {
              return l * 10
            }
          }
          ]]>
          </xsl:text>
        </script>
        <script type="text/javascript" src="{$js-location}"></script>
      </head>
      <body>
        <h1>Line-list view of XSAMS</h1>
        <p>
          <xsl:text>(Switch to view of </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$state-list-location"/></xsl:attribute>
            <xsl:text>states</xsl:text>
          </a>
          <xsl:text> or </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$state-list-location"/></xsl:attribute>
            <xsl:text>collisions</xsl:text>
          </a>
          <xsl:text>)</xsl:text>
        </p>
        <p>
          <xsl:apply-templates select="xsams:Sources/xsams:Source[1]"/>
        </p>
        <p>Assume<a href="#footnote">*</a> all wavelengths are in vacuum and <input type="button" value="Convert to air" onclick="convertAllVacuumToAir()"/> (at IAU STP).</p>
        <p>Assume all wavelengths are in air (at IAU STP) and <input type="button" value="Convert to vacuum" onclick="convertAllAirToVacuum()"/>.</p>
        <xsl:apply-templates select="xsams:Processes/xsams:Radiative"/>
      </body>
    </html>
  </xsl:template>       
         
  <xsl:template match="/xsams:XSAMSData/xsams:Processes/xsams:Radiative">
    <form action="../csv/line-list.csv" method="post" enctype="multipart/form-data" onsubmit="copyTableToFormField('t1', 't1Content');">
      <p>
        <input id="t1Content" type="hidden" name="content" value="initial"/>
        <input type="submit" value="Show table in CSV format"/>  
      </p>
    </form>
    <table id="t1">
      <tr>
        <th>Species</th>
        <th>&#955;/&#957;/n/E</th>
        <th>Probability</th>
        <th>Upper state</th>
        <th>Lower state</th>
        <th>Broadening/shifting</th>
      </tr>
      <xsl:text>
      </xsl:text>
      <xsl:apply-templates select="xsams:RadiativeTransition"/>
    </table>
    
    <p><a name="footnote">* In XSAMS 0.3 there is no way to tell whether a wavelength is in air or vacuum. In XSAMS 1.0 this will be done better.</a></p>
        
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
            <xsl:call-template name="atomic-ion">
              <xsl:with-param name="ion" select="$lowerState/.."/>
            </xsl:call-template>
          </td>
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
          <td>
            <xsl:call-template name="molecule">
              <xsl:with-param name="molecule" select="$lowerState/.."/>
            </xsl:call-template>
          </td>
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
  
  <xsl:template name="wavelength">
    <xsl:param name="wl"/>
    <xsl:for-each select="$wl/xsams:Wavelength">
      <i> &#955;</i><xsl:text>=</xsl:text>
      <xsl:call-template name="wavelength-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$wl/xsams:Frequency">
      <i> &#957;</i><xsl:text>=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$wl/xsams:Wavenumber">
      <i> n</i><xsl:text>=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$wl/xsams:Energy">
      <i> E</i><xsl:text>=</xsl:text>
      <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template name="probability">
    <xsl:param name="p"/>
    <xsl:for-each select="$p/xsams:TransitionProbabilityA">
      <i> A</i><xsl:text>=</xsl:text>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:for-each select="$p/xsams:OscillatorStrength">
      <i> f</i><xsl:text>=</xsl:text>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:for-each select="$p/xsams:WeightedOscillatorStrength">
      <i> gf</i><xsl:text>=</xsl:text>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:for-each select="$p/xsams:Log10WeightedOscillatorStrength">
      <xsl:text> log</xsl:text><sub>10</sub><i>gf</i><xsl:text>=</xsl:text>
      <xsl:value-of select="."/>
    </xsl:for-each>
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
      <xsl:if test="not($state/xsams:AtomicComposition/xsams:Component/xsams:Term)">
        <xsl:apply-templates select="$state/xsams:AtomicQuantumNumbers"/>
      </xsl:if>
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
    <span class="wavelength"><xsl:value-of select="$quantity/xsams:Value"/></span>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$quantity/xsams:Value/@units"/>
  </xsl:template>
  
  <xsl:template name="wavelength-with-unit">
    <xsl:param name="quantity"/>
    <xsl:element name="span">
      <xsl:attribute name="wavelength"><xsl:value-of select="$quantity/xsams:Value/@units"/></xsl:attribute>
      <xsl:value-of select="$quantity/xsams:Value"/>
    </xsl:element>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$quantity/xsams:Value/@units"/>
  </xsl:template>

  <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
