<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsams="http://vamdc.org/xml/xsams/0.3"
  version="1.0">
  
  <!-- Specifies the transition for which to display broadening. -->
  <xsl:param name="id"/>
  <xsl:param name="css-location"/>
  
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>Broadening view of XSAMS</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
      </head>
      <body>
        <h1>Broadening of a single radiative-transition in XSAMS</h1>
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        <xsl:apply-templates select="xsams:Processes/xsams:Radiative/xsams:RadiativeTransition[@id=$id]"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="xsams:RadiativeTransition">
    <p><xsl:text>Transition ID: </xsl:text><xsl:value-of select="@id"/></p>
    <xsl:apply-templates select="xsams:EnergyWavelength"/>
    <table rules="all">
      <tr>
        <th>Type</th>
        <th>Temperature</th>
        <th>Pressure</th>
        <th>Density</th>
        <th>Composition</th>
        <th>Profile</th>
        <th>Parameters</th>
        <th>Comments</th>
      </tr>
      <xsl:for-each select="xsams:Broadening">
        <xsl:variable name="type" select="@name"/>
        <xsl:variable name="envRef" select="@envRef"/>
        <xsl:variable name="environment" select="/xsams:XSAMSData/xsams:Environments/xsams:Environment[@envID=$envRef]"/>
        <xsl:for-each select="xsams:Lineshape">
          <tr>
            <td><xsl:value-of select="$type"/><xsl:text> broadening</xsl:text></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:Temperature"/></xsl:call-template></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:TotalPressure"/></xsl:call-template></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:TotalNumberDensity"/></xsl:call-template></td>
            <td><ul><xsl:apply-templates select="$environment/xsams:Composition/xsams:Species"/></ul></td>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:apply-templates/></td>
            <td><xsl:value-of select="xsams:Comments"/></td>
          </tr>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="xsams:Shifting">
        <xsl:variable name="type" select="@name"/>
        <xsl:variable name="envRef" select="@envRef"/>
        <xsl:variable name="environment" select="/xsams:XSAMSData/xsams:Environments/xsams:Environment[@envID=$envRef]"/>
        <!--<xsl:for-each select="xsams:ShiftingParameter">-->
          <tr>
            <td><xsl:value-of select="$type"/><xsl:text> shifting</xsl:text></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:Temperature"/></xsl:call-template></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:TotalPressure"/></xsl:call-template></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$environment/xsams:TotalNumberDensity"/></xsl:call-template></td>
            <td><ul><xsl:apply-templates select="$environment/xsams:Composition/xsams:Species"/></ul></td>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:apply-templates/></td>
            <td><xsl:value-of select="xsams:Comments"/></td>
          </tr>
        <!--</xsl:for-each>-->
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <xsl:template match="xsams:EnergyWavelength">
    <xsl:if test="xsams:Wavelength">
      <p>
        <xsl:text>Wavelength = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Wavelength"/></xsl:call-template>
      </p> 
    </xsl:if>
    <xsl:if test="xsams:Frequency">
      <p>
        <xsl:text>Frequency = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Frequency"/></xsl:call-template>
      </p>
    </xsl:if>
    <xsl:if test="xsams:Wavenumber">
      <p>
        <xsl:text>Wavenumber = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Wavenumber"/></xsl:call-template>  
      </p>
    </xsl:if>
    <xsl:if test="xsams:Energy">
      <p>
        <xsl:text>Transition energy = </xsl:text>
        <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:Energy"/></xsl:call-template>  
      </p>
    </xsl:if>
  </xsl:template>
  
  
  
  
  <xsl:template match="xsams:Species">
    <li>
      <xsl:value-of select="@name"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="species-by-id"><xsl:with-param name="id" select="@speciesRef"/></xsl:call-template>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="xsams:PartialPressure">
    <xsl:text>partial pressure </xsl:text>
    <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:MoleFraction">
    <xsl:text>fraction </xsl:text>
    <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="xsams:Concentration">
    <xsl:text>concentration</xsl:text>
    <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="."/></xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>
      
      
  <xsl:template match="xsams:LineshapeParameter|xsams:ShiftingParameter">
    <dt><xsl:value-of select="@name"/></dt>
    <xsl:choose>
      <xsl:when test="xsams:Value">
        <dd><xsl:text> = </xsl:text><xsl:value-of select="xsams:Value"/><xsl:text> </xsl:text><xsl:value-of select="xsams:Value/@units"/></dd>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="function-ref" select="xsams:FitParameters/@functionRef"/>
        <xsl:variable name="function" select="/xsams:XSAMSData/xsams:Functions/xsams:Function[@functionID=$function-ref]"/>
        <xsl:variable name="fit-parameters" select="xsams:FitParameters"/>
        <dd>
          <xsl:text>= </xsl:text>
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
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="value-with-unit">
    <xsl:param name="quantity"/>
    <xsl:value-of select="$quantity/xsams:Value"/>
    <xsl:if test="$quantity/xsams:Value/@units and not($quantity/xsams:Value/@units='unitless')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Given the ID code for a species in the document, writes a human-readable identification. -->
  <xsl:template name="species-by-id">
    <xsl:param name="id"/>
    <xsl:variable name="molecule" select="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule[@speciesID=$id]"/>
    <xsl:if test="$molecule">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
      <xsl:variable name="charge" select="$molecule/xsams:IonCharge"/>
      <xsl:choose>
        <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
        <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
        <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
        <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
      </xsl:choose>
      <xsl:text>) </xsl:text>
    </xsl:if>
    <xsl:variable name="ion" select="//xsams:Ion[@speciesID=$id]"/>
    <xsl:if test="$ion">
      <xsl:text>(</xsl:text>
      <xsl:if test="$ion/../xsams:IsotopeParameters/xsams:MassNumber">
        <sup><xsl:value-of select="$ion/../xsams:IsotopeParameters/xsams:MassNumber"/></sup>
      </xsl:if>
      <xsl:value-of select="$ion/../../xsams:ChemicalElement/xsams:ElementSymbol"/>
      <xsl:variable name="charge" select="$ion/xsams:IonCharge"/>
      <xsl:choose>
        <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
        <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
        <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
        <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
      </xsl:choose>
      <xsl:text>) </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="specie">
    <xsl:param name="formula"/>
    <xsl:param name="mass-number"/>
    <xsl:param name="charge"/>
    <xsl:if test="$mass-number">
      <sup>
        <xsl:value-of select="$mass-number"/>
      </sup>
    </xsl:if>
    <xsl:value-of select="$formula"/>
    <xsl:choose>
      <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
      <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
      <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
      <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text() | @*"/>
  
</xsl:stylesheet>