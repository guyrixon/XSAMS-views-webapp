<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="1.0">
  
  <xsl:include href="species-name.xsl"/>
  
  <xsl:param name="id"/>
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
        <title>Selected collision</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
      </head>
      <body>
        <h1>Data for single collision</h1>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        
        <!-- Write out the reaction in the form A + B -> C + D, where A,B, C, D are species names.
             The number of reactants and priducts may vary. -->
        <p>
          <xsl:for-each select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition[@id=$id]/xsams:Reactant">
            <xsl:call-template name="participant">
              <xsl:with-param name="participant" select="."/>
            </xsl:call-template>
            <xsl:if test="position() != last()">
              <xsl:text> + </xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:text> &#8594; </xsl:text>
          <xsl:for-each select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition[@id=$id]/xsams:Product">
            <xsl:call-template name="participant">
              <xsl:with-param name="participant" select="."/>
            </xsl:call-template>
            <xsl:if test="position() != last()">
              <xsl:text> + </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </p>
        
        <xsl:apply-templates select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition[@id=$id]"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:DataSets/xsams:DataSet">
    <h2><xsl:value-of select="@dataDescription"/></h2>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xsams:TabulatedData">
    <p><xsl:value-of select="xsams:Description"/></p>
    <table>
      <tr>
        <th>
          <xsl:value-of select="xsams:X/@parameter"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="xsams:X/@units"/>
          <xsl:text>)</xsl:text>
        </th>
        <th>
          <xsl:value-of select="xsams:Y/@parameter"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="xsams:Y/@units"/>
          <xsl:text>)</xsl:text>
        </th>
      </tr>
      <xsl:call-template name="x-y-row">
        <xsl:with-param name="x" select="xsams:X/xsams:DataList"/>
        <xsl:with-param name="y" select="xsams:Y/xsams:DataList"/>
      </xsl:call-template>
    </table>
  </xsl:template>
  
  <!-- Adapted from Stack Overflow: http://stackoverflow.com/questions/136500/does-xslt-have-a-split-function -->
  <xsl:template name="x-y-row">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:variable name="new-x" select="concat(normalize-space($x), ' ')"/> 
    <xsl:variable name="first-x" select="substring-before($new-x, ' ')"/> 
    <xsl:variable name="remaining-x" select="substring-after($new-x, ' ')"/>
    <xsl:variable name="new-y" select="concat(normalize-space($y), ' ')"/> 
    <xsl:variable name="first-y" select="substring-before($new-y, ' ')"/> 
    <xsl:variable name="remaining-y" select="substring-after($new-y, ' ')"/> 
    <tr>
      <td><xsl:value-of select="$first-x"/></td>
      <td><xsl:value-of select="$first-y"/></td>
    </tr>
    <xsl:if test="$remaining-x">
      <xsl:call-template name="x-y-row">
        <xsl:with-param name="x" select="$remaining-x"/>
        <xsl:with-param name="y" select="$remaining-y"/> 
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="participant">
    <xsl:param name="participant"/>
    
    <xsl:call-template name="atomic-ion">
      <xsl:with-param name="ion" select="key('atomic-states', xsams:StateRef)/.."/>
    </xsl:call-template>
    
    <xsl:call-template name="atomic-ion">
      <xsl:with-param name="ion" select="key('atomic-ions', xsams:SpeciesRef)"/>
    </xsl:call-template>
    
    <xsl:call-template name="molecule">
      <xsl:with-param name="molecule" select="key('molecular-states', xsams:StateRef)/.."/>
    </xsl:call-template>
    
    <xsl:call-template name="molecule">
      <xsl:with-param name="molecule" select="key('molecules', xsams:SpeciesRef)"/>
    </xsl:call-template>
    
    <xsl:call-template name="particle">
      <xsl:with-param name="particle" select="key('particles', xsams:SpeciesRef)"/>
    </xsl:call-template>
    
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
  
</xsl:stylesheet>