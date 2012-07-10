<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="2.0">
  
  <xsl:import href="species-name.xsl"/>
  
  <xsl:param name="id"/>
  <xsl:param name="state-list-location"/>
  <xsl:param name="state-location"/>
  <xsl:param name="line-list-location"/>
  <xsl:param name="collision-location"/>
  <xsl:param name="css-location"/>
  
  <!-- These keys are used in the identification of species, below. -->
  <xsl:key name="atomic-states" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
  <xsl:key name="molecular-states" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
  <xsl:key name="atomic-ions" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion" use="@speciesID"/>
  <xsl:key name="molecules" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule" use="@speciesID"/>
  <xsl:key name="particles" match="/xsams:XSAMSData/xsams:Species/xsams:Particles/xsams:Particle" use="@speciesID"/>
  
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Collision list</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
      </head>
      <body>
        <h1>Collisions</h1>
        
        <p>
          <xsl:text>(Switch to view of </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$line-list-location"/></xsl:attribute>
            <xsl:text>radiative transitions</xsl:text>
          </a>
          <xsl:text> or </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$state-list-location"/></xsl:attribute>
            <xsl:text>states</xsl:text>
          </a>
          
          <xsl:text>)</xsl:text>
        </p>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        <table>
          <tr>
            <th>ID</th>
            <th>Species</th>
            <th>Detail</th>
          </tr>
          <xsl:apply-templates select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition"/>  
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:CollisionalTransition">
    <tr>
      <td><xsl:value-of select="@id"/></td>
      <td>
        <xsl:for-each select="xsams:Reactant">
          <xsl:call-template name="participant">
            <xsl:with-param name="participant" select="."/>
          </xsl:call-template>
          <xsl:if test="position() != last()">
            <xsl:text> + </xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text> &#8594; </xsl:text>
        <xsl:for-each select="xsams:Product">
          <xsl:call-template name="participant">
            <xsl:with-param name="participant" select="."/>
          </xsl:call-template>
          <xsl:if test="position() != last()">
            <xsl:text> + </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </td>
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$collision-location"/>
            <xsl:text>?id=</xsl:text>
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <xsl:text>detail</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template name="participant">
    <xsl:param name="participant"/>
    
    <xsl:call-template name="atomic-ion">
      <xsl:with-param name="ion" select="key('atomic-ions', xsams:SpeciesRef)"/>
      <xsl:with-param name="state" select="key('atomic-states', xsams:StateRef)"/>
      <xsl:with-param name="state-location" select="$state-location"/>
    </xsl:call-template>
    
    <xsl:call-template name="molecule">
      <xsl:with-param name="molecule" select="key('molecules', xsams:SpeciesRef)"/>
      <xsl:with-param name="state" select="key('molecular-states', xsams:StateRef)"/>
      <xsl:with-param name="state-location" select="$state-location"/>
    </xsl:call-template>
    
    <xsl:call-template name="particle">
      <xsl:with-param name="particle" select="key('particles', xsams:SpeciesRef)"/>
    </xsl:call-template>
    
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
  
</xsl:stylesheet>