<?xml version="1.0" encoding="UTF-8"?>
<!-- Transformation from XSAMS (11.05 VAMDC edition) to atomic spectrum table in HTML.
     Output is based the results page from NIST's site. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <xsl:output method="html"/>
    
    <!-- On finding the start of the XSAMs, write the shell of the HTML page.
         The page contains one table. Other templates fill in rows of the table -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Atomic spectrum from XSAMS data</title>
            </head>
            <body>
                <table>
                    
                    <xsl:apply-templates/>
                    
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="xsams:XSAMSData">
        <p>Boo!</p>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Matches transitions. -->
    <xsl:template match="xsams:Processes/xsams:Radiative">
        <tr>
            <td><xsl:value-of select="xsams:EnergyWavelength/xsams:Wavelength"/></td>
        </tr>
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
