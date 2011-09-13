<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <!-- Sets the URL for the page listing radiative transitions. -->
    <xsl:param name="lineListUrl"/>
    
    <!-- Sets the URL for the page showing a selected state. -->
    <xsl:param name="selectedStateUrl"/>
    
    <xsl:output method="html" encoding="UTF-8"/>
    
    <xsl:template match="xsams:XSAMSData">
        <html>
            <head>
                <title>VAMDC results: atomic and molecular states</title>
            </head>
            <body>
                <h1>Query results: atomic and molecular states</h1>
                
                <p>
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="$lineListUrl"/></xsl:attribute>
                        <xsl:text>(Switch to display of radiative transitions.)</xsl:text>
                    </a>
                </p>
                
                <table>
                    <tr>
                        <th>Specie</th>
                        <th>Ion charge</th>
                        <th>State energy</th>
                        <th>Description</th>
                        <th>More information</th>
                    </tr>
                    <xsl:apply-templates/>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="xsams:Molecule">
        <xsl:variable name="specie">
            <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
        </xsl:variable>
        
        <xsl:for-each select="xsams:MolecularState">
            <xsl:call-template name="molecular-state">
                <xsl:with-param name="specie" select="$specie"/>
                <xsl:with-param name="state" select="."/>
                <xsl:with-param name="charge" select="xsams:MolecularChemicalSpecies/xsams:IonCharge"/>
            </xsl:call-template>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="xsams:Ion">
        <xsl:variable name="specie">
            <sup><xsl:value-of select="ancestor::xsams:Isotope/xsams:IsotopeParameters/xsams:MassNumber"/></sup>
            <xsl:value-of select="ancestor::xsams:Atom/xsams:ChemicalElement/xsams:ElementSymbol"/>
        </xsl:variable>
        
        <xsl:for-each select="xsams:AtomicState">
            <xsl:call-template name="atomic-state">
                <xsl:with-param name="specie" select="$specie"/>
                <xsl:with-param name="state" select="."/>
                <xsl:with-param name="charge" select="xsams:IonCharge"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="molecular-state">
        <xsl:param name="specie"/>
        <xsl:param name="state"/>
        <xsl:param name="charge"/>
        <tr>
            <td><xsl:value-of select="$specie"/></td>
            <td><xsl:value-of select="$charge"/></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:MolecularStateCharacterisation/xsams:StateEnergy"></xsl:with-param></xsl:call-template></td>
            <td><xsl:value-of select="$state/Description"/></td>
            <td><xsl:call-template name="state-link"><xsl:with-param name="state" select="$state"></xsl:with-param></xsl:call-template></td>
        </tr>
    </xsl:template>
    
    <xsl:template name="atomic-state">
        <xsl:param name="specie"/>
        <xsl:param name="state"/>
        <xsl:param name="charge"/>
        <tr>
            <td><xsl:value-of select="$specie"/></td>
            <td><xsl:value-of select="$charge"/></td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:AtomicNumericalData/xsams:StateEnergy"></xsl:with-param></xsl:call-template></td>
            <td><xsl:value-of select="$state/Description"/></td>
            <td><xsl:call-template name="state-link"><xsl:with-param name="state" select="$state"></xsl:with-param></xsl:call-template></td>
        </tr>
    </xsl:template>
    
    <!-- Writes a hyperlink to the page for the given state. -->
    <xsl:template name="state-link">
        <xsl:param name="state"/>
        <a>
            <xsl:attribute name="href"><xsl:value-of select="$selectedStateUrl"/><xsl:text>&amp;stateID=</xsl:text><xsl:value-of select="$state/@stateID"/></xsl:attribute>
            <xsl:text>Detail</xsl:text>
        </a>    
    </xsl:template>
    
    <xsl:template name="value-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="$quantity/xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="@*|text()"/>
    
</xsl:stylesheet>
