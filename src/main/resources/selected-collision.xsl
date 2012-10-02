<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/1.0"
  version="2.0">
  
  <xsl:include href="species-name.xsl"/>
  <xsl:include href="sources.xsl"/>
  
  <xsl:param name="id"/>
  <xsl:param name="css-location"/>
  <xsl:param name="state-location"/>
  
  <!-- These keys are used in the identification of species, below. -->
  <xsl:key name="atomic-states" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
  <xsl:key name="molecular-states" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
  <xsl:key name="atomic-ions" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion" use="@speciesID"/>
  <xsl:key name="molecules" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule" use="@speciesID"/>
  <xsl:key name="particles" match="/xsams:XSAMSData/xsams:Species/xsams:Particles/xsams:Particle" use="@speciesID"/>
  <xsl:key name="sources" match="/xsams:XSAMSData/xsams:Sources/xsams:Source" use="@sourceID"/>
  
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
        <p>
          <xsl:apply-templates select="xsams:Sources/xsams:Source[1]"/>
        </p>
        
        <!-- Write out the reaction in the form A + B -> C + D, where A,B, C, D are species names.
             The number of reactants and products may vary. -->
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
        
        <ul>
          <xsl:for-each select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition[@id=$id]/xsams:SourceRef">
            <li>
              <xsl:call-template name="source-long">
                <xsl:with-param name="source" select="key('sources', .)"/>
              </xsl:call-template>  
            </li>
          </xsl:for-each>
        </ul>
        
        <xsl:apply-templates select="xsams:Processes/xsams:Collisions/xsams:CollisionalTransition[@id=$id]"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:DataSets/xsams:DataSet">
    <h2><xsl:value-of select="@dataDescription"/></h2>
    <ul>
      <xsl:for-each select="xsams:SourceRef">
        <li>
          <xsl:call-template name="source-long">
            <xsl:with-param name="source" select="key('sources', .)"/>
          </xsl:call-template>  
        </li>
      </xsl:for-each>
    </ul>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xsams:TabulatedData">
    <p><xsl:value-of select="xsams:Description"/></p>
    <table>
      <tr>
        <th>
          <xsl:value-of select="xsams:X/@parameter"/>
          <xsl:if test="xsams:X/@units and not(xsams:X/@units = 'undef')">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="xsams:X/@units"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </th>
        <th>
          <xsl:value-of select="xsams:Y/@parameter"/>
          <xsl:if test="xsams:Y/@units and not(xsams:Y/@units = 'undef')">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="xsams:Y/@units"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </th>
      </tr>
      <xsl:call-template name="x-y-row">
        <xsl:with-param name="x" select="xsams:X/xsams:DataList"/>
        <xsl:with-param name="y" select="xsams:Y/xsams:DataList"/>
      </xsl:call-template>
    </table>
  </xsl:template>
  
  <xsl:template match="xsams:FitData">
    <p><xsl:value-of select="xsams:Description"/></p>
    <xsl:variable name="function-ref" select="xsams:FitParameters/@functionRef"/>
    <xsl:variable name="function" select="/xsams:XSAMSData/xsams:Functions/xsams:Function[@functionID=$function-ref]"/>
    <xsl:variable name="fit-parameters" select="xsams:FitParameters"/>
    
    <xsl:value-of select="$function/xsams:Expression"/>
      <xsl:if test="$function/xsams:Expression/@computerLanguage">
        <xsl:text> (in </xsl:text><xsl:value-of select="$function/xsams:Expression/@computerLanguage"/><xsl:text>)</xsl:text>
      </xsl:if>   
      <xsl:text> where:</xsl:text>
      <ul>
        <xsl:for-each select="$function/xsams:Arguments/xsams:Argument">
          <xsl:variable name="name" select="@name"/>
          <li>
            <xsl:value-of select="@name"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@units"/>
            <xsl:text>; valid from </xsl:text>
            <xsl:value-of select="$fit-parameters/xsams:FitArgument[@name=$name]/xsams:LowerLimit"/>
            <xsl:text> to </xsl:text>
            <xsl:value-of select="$fit-parameters/xsams:FitArgument[@name=$name]/xsams:UpperLimit"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="xsams:Description"/>
          </li>
        </xsl:for-each>
        <xsl:for-each select="$function/xsams:Parameters/xsams:Parameter">
          <xsl:variable name="name" select="@name"/>
          <li>
            <xsl:value-of select="@name"/>
            <xsl:text> = </xsl:text>
            <xsl:value-of select="$fit-parameters/xsams:FitParameter[@name=$name]/xsams:Value"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="xsams:Description"/>
          </li>
        </xsl:for-each>
      </ul>
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