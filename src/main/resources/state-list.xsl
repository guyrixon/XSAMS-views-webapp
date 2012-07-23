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
  
  <!-- Display rules for the paragraph naming the data set. -->
  <xsl:include href="query-source.xsl"/>
  
  <!-- Display rules for species names (inc. charge state). -->
  <xsl:include href="species-name.xsl"/>
    
  <xsl:param name="line-list-location"/>
  <xsl:param name="collision-list-location"/>
  <xsl:param name="state-location"/>
  <xsl:param name="css-location"/>
  <xsl:param name="js-location"/>
    
  <xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
  <xsl:template match="xsams:XSAMSData">
    <html>
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>State-list view of XSAMS</title>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href"><xsl:value-of select="$css-location"/></xsl:attribute>
        </link>
        <script type="text/javascript" src="{$js-location}"/>
      </head>
      <body>
        <h1>State-list view of XSAMS</h1>
        <p>
          <xsl:text>(Switch to view of </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$line-list-location"/></xsl:attribute>
            <xsl:text>radiative transitions</xsl:text>
          </a>
          <xsl:text> or </xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$collision-list-location"/></xsl:attribute>
            <xsl:text>collisions</xsl:text>
          </a>
          <xsl:text>)</xsl:text>
        </p>
        
        <xsl:apply-templates select="xsams:Sources/xsams:Source[1]"/>
        
        <form action="../csv/state-list.csv" method="post" enctype="application/x-www-form-urlencoded" onsubmit="copyTableToFormField('t1', 't1Content');">
          <p>
            <input id="t1Content" type="hidden" name="content" value="initial"/>
            <input type="submit" value="Show table in CSV format"/>  
          </p>
        </form>
            
        <table ID="t1" rules="all">
          <thead>
            <tr>
              <th>Species</th>
              <th>State</th>
              <th>Energy</th>
            </tr>  
          </thead>
          
          <tbody>
            <xsl:for-each select="xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState">
              <xsl:sort select="xsams:AtomicNumericalData/xsams:StateEnergy/xsams:value"/>
              <tr>
                <td>
                  <xsl:call-template name="atomic-ion">
                    <xsl:with-param name="ion" select=".."/>
                  </xsl:call-template>
                </td>
                <td>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$state-location"/>
                      <xsl:text>?id=</xsl:text>
                      <xsl:value-of select="@stateID"/>
                    </xsl:attribute>
                    <xsl:value-of select="@stateID"/>
                    <xsl:text>: </xsl:text>
                    <xsl:if test="xsams:Description">
                      <xsl:value-of select="xsams:Description"/>
                      <xsl:text> &#8212; </xsl:text>  
                    </xsl:if>
                    <xsl:apply-templates/>
                  </a>    
                </td>
                <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:AtomicNumericalData/xsams:StateEnergy"/></xsl:call-template></td>
              </tr>
            </xsl:for-each>
            
            <xsl:for-each select="xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState">
              <xsl:sort select="xsams:MolecularStateCharacterisation/xsams:StateEnergy"/>
              <tr>
                <td>
                  <xsl:call-template name="molecule">
                    <xsl:with-param name="molecule" select=".."/>
                  </xsl:call-template>
                </td>
                <td>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$state-location"/>
                      <xsl:text>?id=</xsl:text>
                      <xsl:value-of select="@stateID"/>
                    </xsl:attribute>
                    <xsl:value-of select="@stateID"/>
                    <xsl:text>: </xsl:text>
                    <xsl:if test="xsams:Description">
                      <xsl:value-of select="xsams:Description"/>
                      <xsl:text> &#8212; </xsl:text>  
                    </xsl:if>
                    <xsl:apply-templates/>
                  </a> 
                </td>
                <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="xsams:MolecularStateCharacterisation/xsams:StateEnergy"/></xsl:call-template></td>
              </tr>
            </xsl:for-each>  
          </tbody>
          
        </table>
      </body>
    </html>
  </xsl:template>
  
  <!-- Writes a table row for an atomic or molecular state.
       The species column covers the given species-name, isotope (for atomic ions) and charge.
       The state column includes the description from the XSAMS and a Q-M summary generated by other templates.
       The energy column includes the value and unit of the state energy.
       The state column is hyperlinked to the page for the state details. -->
  <xsl:template name="state">
    <xsl:param name="molecule"/>
    <xsl:param name="atomic-ion"/>
    <xsl:param name="state"/>
    <xsl:param name="energy"/>
    <tr>
      <td>
        <xsl:if test="$molecule">
          <xsl:call-template name="molecule">
            <xsl:with-param name="molecule" select="$molecule"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$atomic-ion">
          <xsl:call-template name="atomic-ion">
            <xsl:with-param name="ion" select="$atomic-ion"/>
          </xsl:call-template>
        </xsl:if>
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
