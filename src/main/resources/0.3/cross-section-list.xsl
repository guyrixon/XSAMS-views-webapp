<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3">
  
  <xsl:include href="species-name.xsl"/>
  
  <!-- Display rules for molecular states in the case-by-case framework. -->
  <xsl:include href="cbc.xsl"/>
  
  <!-- Display rules for atomic states. -->
  <xsl:include href="atomic-QNs.xsl"/>
  
  <xsl:param name="state-location"/>
  
  
  <!-- These keys are used in the identification of species, below. -->
  <xsl:key name="atomic-states" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
  <xsl:key name="molecular-states" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
  <xsl:key name="atomic-ions" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion" use="@speciesID"/>
  <xsl:key name="molecules" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule" use="@speciesID"/>
  <xsl:key name="particles" match="/xsams:XSAMSData/xsams:Species/xsams:Particles/xsams:Particle" use="@speciesID"/>
  <xsl:key name="sources" match="/xsams:XSAMSData/xsams:Sources/xsams:Source" use="@sourceID"/>
  
  <xsl:template match="xsams:XSAMSData">
    <html>
      <head>
        <title>Absorption cross-sections</title>
      </head>
      <body>
        <h1>Absorption cross-sections</h1>
        <table>
          <tr>
            <th>ID</th>
            <th>Species</th>
            <th>State</th>
            <th>Detail</th>
          </tr>
          <xsl:for-each select="xsams:Processes/xsams:Radiative/xsams:AbsorptionCrossSection">
            <tr>
              <td><xsl:value-of select="@id"/></td>
              <td>
                <xsl:call-template name="atomic-ion">
                  <xsl:with-param name="ion" select="key('atomic-ions', xsams:Species/xsams:SpeciesRef)"/>
                  <xsl:with-param name="state" select="key('atomic-states', xsams:Species/xsams:StateRef)"/>
                  <xsl:with-param name="state-location" select="$state-location"/>
                </xsl:call-template>
                
                <xsl:call-template name="molecule">
                  <xsl:with-param name="molecule" select="key('molecules', xsams:Species/xsams:SpeciesRef)"/>
                  <xsl:with-param name="state" select="key('molecular-states', xsams:Species/xsams:StateRef)"/>
                  <xsl:with-param name="state-location" select="$state-location"/>
                </xsl:call-template>
                
                <xsl:call-template name="particle">
                  <xsl:with-param name="particle" select="key('particles', xsams:Species/xsams:SpeciesRef)"/>
                </xsl:call-template>  
              </td>
              
              <td><xsl:apply-templates select="key('atomic-states', xsams:Species/xsams:StateRef)"/><xsl:value-of select="xsams:Species/xsams:StateRef"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="@*|text()"/>
</xsl:stylesheet>