<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
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

  <!-- The formatting rules for the quantum numbers (QNs) in all the molecular
       cases. Each QN generates text in the form x=y, where x may contain
       mark-up. No surronding element is written, so these templates can only
       be used in the context of an element written by another stylesheet. -->
       
  <xsams:Case>
    <xsl:apply-templates/>
  </xsams:Case>
       
  <xsl:template match="nltcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="nltcs:ElecStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:v1">
    <i>v</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:v2">
    <i>v</i><sub>2</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:v3">
    <i>v</i><sub>3</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:J">
    <i>J</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:Ka">
    <i>K</i><sub>a</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:Kc">
    <i>K</i><sub>c</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:F1">
    <i>F</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:F2">
    <i>F</i><sub>2</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:F">
    <i>F</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:parity">
    <xsl:text>parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="nltcs:asSym">
    <xsl:text>symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="ltcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ltcs:ElecStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:v1">
    <i>v</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:v2">
    <i>v</i><sub>2</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:v3">
    <i>v</i><sub>3</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:l2">
    <i>l</i><sub>2</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:J">
    <i>J</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:Ka">
    <i>K</i><sub>a</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:Kc">
    <i>K</i><sub>c</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:F1">
    <i>F</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:F2">
    <i>F</i><sub>2</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:F">
    <i>F</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:parity">
    <xsl:text>parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:kronigParity">
    <xsl:text>Kronig parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltcs:asSym">
    <xsl:text>symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="dcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="dcs:ElecStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:v">
    <i>v</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:l">
    <i>l</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:J">
    <i>J</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:F1">
    <i>F</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:parity">
    <xsl:text>parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="dcs:asSym">
    <xsl:text>symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="hunda:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="hunda:ElecStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:v">
    <i>v</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:Lambda">
    <xsl:text>|Λ|</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:Sigma">
    <xsl:text>|Σ|</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:Omega">
    <xsl:text>Ω</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:J">
    <i>J</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:S">
    <i>S</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:F1">
    <i>F</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:F">
    <i>F</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:parity">
    <xsl:text>parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:kronigParity">
    <xsl:text>Kronig parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:elecInv">
    <xsl:text>inversion parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:reflectInv">
    <xsl:text>reflection parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hunda:asSym">
    <xsl:text>symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="hundb:QNs">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="hundb:ElecStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:v">
    <i>v</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:Lambda">
    <xsl:text>|Λ|</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:Omega">
    <xsl:text>Ω</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:J">
    <i>J</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:S">
    <i>S</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:N">
    <i>N</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:F1">
    <i>F</i><sub>1</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:F">
    <i>F</i><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:SpinComponentLabel">
    <xsl:text>spin component</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:parity">
    <xsl:text>parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:kronigParity">
    <xsl:text>Kronig parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:elecInv">
    <xsl:text>inversion parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:reflectInv">
    <xsl:text>reflection parity</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="hundb:asSym">
    <xsl:text>symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
    
  <xsl:template match="stcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="stcs:ElectStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:li">
    <i>l</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:vibInv">
    <i>vibInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:J">
    <i>J</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:K">
    <i>K</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:r">
    <i>r</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="stcs:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="lpcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="lpcs:ElectStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:li">
    <i>l</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:l">
    <i>l</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:vibInv">
    <i>vibInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:J">
    <i>J</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:kronigParity">
    <xsl:text>Kronig parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="lpcs:asSym">
    <xsl:text>as-symmetry</xsl:text><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="asymcs:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="asymcs:ElectStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:vibInv">
    <i>vibInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:J">
    <i>J</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:Ka">
    <i>K</i><sub>a</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:Kc">
    <i>K</i><sub>c</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymcs:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="asymos:QNs">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="asymos:ElectStateLabel">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:vibInv">
    <i>vibInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:S">
    <i>S</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:Ka">
    <i>K</i><sub>a</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:Kc">
    <i>K</i><sub>c</sub><xsl:text> = </xsl:text> <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="asymos:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
    
  <xsl:template match="sphcs:ElecStateLabel">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="sphcs:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:li">
    <i>l</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:J">
    <i>J</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphcs:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  
  <xsl:template match="sphos:ElecStateLabel">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="sphos:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:li">
    <i>l</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:elecInv">
    <i>elecInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:N">
    <i>N</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="sphos:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
  
  <xsl:template match="ltos:ElecStateLabel">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="ltos:vi">
    <i>v</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:li">
    <i>l</i><sub><xsl:value-of select="@mode"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:vibSym">
    <i>vibSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:rotSym">
    <i>rotSym</i><sub><xsl:value-of select="@group"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:elecRefl">
    <i>elecRefl</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:elecInv">
    <i>elecInv</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:S">
    <i>S</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:N">
    <i>N</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:I">
    <i>I</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:J">
    <i>J</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:F">
    <i>F</i><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:Fj">
    <i>F</i><sub><xsl:value-of select="@j"/></sub><xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ltos:parity">
    <xsl:text>parity = </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>
  
    
    <xsl:template match="xsams:Case[@caseID='lpos']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="lpos:QNs/lpos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="lpos:QNs/lpos:S"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="lpos:QNs/lpos:N"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="lpos:QNs/lpos:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="lpos:QNs/lpos:li"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="lpos:QNs/lpos:l"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="lpos:QNs/lpos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="lpos:QNs/lpos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="lpos:QNs/lpos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="lpos:QNs/lpos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="lpos:QNs/lpos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="lpos:QNs/lpos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="lpos:QNs/lpos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="lpos:QNs/lpos:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='nltos']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="nltos:QNs/nltos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="nltos:QNs/nltos:S"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v3"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="nltos:QNs/nltos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="nltos:QNs/nltos:N"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="nltos:QNs/nltos:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="nltos:QNs/nltos:Kc"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:parity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="nltos:QNs/nltos:asSym"/>
        </p>
    </xsl:template>

</xsl:stylesheet>
