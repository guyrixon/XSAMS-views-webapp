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
    
  <xsl:param name="line-list-location"/>
  <xsl:param name="state-location"/>
    
  <xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    
  <xsl:template match="xsams:XSAMSData">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
        <title>State-list view of XSAMS</title>
        <link rel="stylesheet" href="../QN-list.css" type="text/css"/>
      </head>
      <body>
        <h1>State-list view of XSAMS</h1>
        <p>
          <xsl:text>(</xsl:text>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$line-list-location"/></xsl:attribute>
            <xsl:text>Switch to view of radiative transitions</xsl:text>
          </a>
          <xsl:text>)</xsl:text>
        </p>
        
        <xsl:if test="xsams:Sources/xsams:Source[1]/xsams:Comments">
          <p><xsl:value-of select="xsams:Sources/xsams:Source[1]/@sourceID"/></p>
        </xsl:if>
        
        
        <table rules="all">
          <tr>
            <th>Species</th>
            <th>Description</th>
            <th>State energy</th>
            <th>More information</th>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
    
  <xsl:template match="xsams:Molecule">
    <xsl:variable name="specie">
      <xsl:if test="xsams:MolecularChemicalSpecies/xsams:ChemicalName">
        <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
        <xsl:text> - </xsl:text>
      </xsl:if>
      <xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
    </xsl:variable>
    <xsl:variable name="charge"><xsl:value-of select="xsams:MolecularChemicalSpecies/xsams:IonCharge"/></xsl:variable>
    <xsl:for-each select="xsams:MolecularState">
      <xsl:sort select="MolecularStateCharacterisation/StateEnergy/Value"/>
      <xsl:call-template name="molecular-state">
        <xsl:with-param name="specie" select="$specie"/>
        <xsl:with-param name="charge" select="$charge"/>
        <xsl:with-param name="state" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="xsams:Ion">
      <xsl:for-each select="xsams:AtomicState">
        <xsl:call-template name="atomic-state">
          <xsl:with-param name="element" select="ancestor::xsams:Atom/xsams:ChemicalElement/xsams:ElementSymbol"/>
          <xsl:with-param name="mass-number" select="ancestor::xsams:Isotope/xsams:IsotopeParameters/xsams:MassNumber"/>
          <xsl:with-param name="state" select="."/>
          <xsl:with-param name="charge" select="../xsams:IonCharge"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:template>
  
   <xsl:template name="ion-charge">
     <xsl:param name="charge"/>
     <xsl:choose>
       <xsl:when test="$charge=1"><sup>+</sup></xsl:when>
       <xsl:when test="$charge=-1"><sup><xsl:text>-</xsl:text></sup></xsl:when>
       <xsl:when test="$charge&gt;0"><sup><xsl:value-of select="$charge"/>+</sup></xsl:when>
       <xsl:when test="$charge&lt;0"><sup><xsl:value-of select="$charge"/>-</sup></xsl:when>
     </xsl:choose>
   </xsl:template>
    
    <xsl:template name="molecular-state">
        <xsl:param name="specie"/>
        <xsl:param name="charge"/>
        <xsl:param name="state"/>
        <tr>
          <td>
            <xsl:value-of select="$specie"/>
            <xsl:call-template name="ion-charge"><xsl:with-param name="charge"><xsl:value-of select="$charge"/></xsl:with-param></xsl:call-template>
          </td>
          <td>
            <xsl:value-of select="$state/xsams:Description"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
          </td>
          <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:MolecularStateCharacterisation/xsams:StateEnergy"></xsl:with-param></xsl:call-template></td>  
          <td><xsl:call-template name="state-link"><xsl:with-param name="state" select="$state"></xsl:with-param></xsl:call-template></td>
        </tr>
    </xsl:template>
    
    <xsl:template name="atomic-state">
      <xsl:param name="element"/>
      <xsl:param name="mass-number"/>
      <xsl:param name="state"/>
      <xsl:param name="charge"/>
        <tr>
          <td>
            <xsl:if test="$mass-number">
              <sup><xsl:value-of select="$mass-number"/></sup>
            </xsl:if>
            <xsl:value-of select="$element"/>
            <xsl:call-template name="ion-charge"><xsl:with-param name="charge"><xsl:value-of select="$charge"/></xsl:with-param></xsl:call-template>
          </td>
          <td>
            <xsl:value-of select="$state/xsams:Description"/>
            <xsl:text> </xsl:text>
            <dl class="QN-list-inline"><xsl:apply-templates/></dl>
          </td>
            <td><xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:AtomicNumericalData/xsams:StateEnergy"></xsl:with-param></xsl:call-template></td>
            
            <td><xsl:call-template name="state-link"><xsl:with-param name="state" select="$state"></xsl:with-param></xsl:call-template></td>
        </tr>
    </xsl:template>
    
    
    <xsl:template match="xsams:TotalAngularMomentum">
      <dt>J</dt>
      <dd><xsl:value-of select="."/></dd>
    </xsl:template>
  
    <xsl:template match="xsams:Kappa">
      <dt>&#954;</dt>
      <dd><xsl:value-of select="."/></dd>
    </xsl:template>
  
  <xsl:template match="xsams:Parity">
    <dt>parity</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
  <xsl:template match="xsams:HyperfineMomentum">
    <dt>F</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
  <xsl:template match="xsams:MagneticQuantumNumber">
    <dt>m</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
    
    <!-- Writes a hyperlink to the page for the given state. -->
    <xsl:template name="state-link">
        <xsl:param name="state"/>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$state-location"/>
            <xsl:text>?id=</xsl:text>
            <xsl:value-of select="$state/@stateID"/>
          </xsl:attribute>
          <xsl:text>Detail</xsl:text>
        </a>    
    </xsl:template>
    
    
    <xsl:template match="xsams:Case[@caseID='nltcs']">
      <dl class="QN-list-inline">
        <dt>Label</dt><dd><xsl:value-of select="nltcs:QNs/nltcs:ElecStateLabel"/></dd>
        <dt>v<sub>1</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:v1"/></dd>
        <dt>v<sub>2</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:v2"/></dd>
        <dt>v<sub>3</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:v3"/></dd>
        <dt>J</dt><dd><xsl:value-of select="nltcs:QNs/nltcs:J"/></dd>
        <dt>K<sub>a</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:Ka"/></dd>
        <dt>K<sub>c</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:Kc"/></dd>
        <dt>F<sub>1</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:F1"/></dd>
        <dt>F<sub>2</sub></dt><dd><xsl:value-of select="nltcs:QNs/nltcs:F2"/></dd>
        <dt>F</dt><dd><xsl:value-of select="nltcs:QNs/nltcs:F"/></dd>
        <dt>parity</dt><dd><xsl:value-of select="nltcs:QNs/nltcs:parity"/></dd>
        <dt>symmetry</dt><dd><xsl:value-of select="nltcs:QNs/nltcs:asSym"/></dd>
      </dl>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='ltcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:ElecStateLabel"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of  select="ltcs:QNs/ltcs:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of  select="ltcs:QNs/ltcs:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:v3"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:l"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:J"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:Kc"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='dcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="dcs:QNs/dcs:ElecStateLabel"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="dcs:QNs/dcs:v"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="dcs:QNs/dcs:J"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="dcs:QNs/dcs:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="dcs:QNs/dcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="dcs:QNs/dcs:parity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="dcs:QNs/dcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='hunda']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="hunda:QNs/hunda:ElecStateLabel"/>
            <xsl:text>, inversion parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:elecInv"/>
            <xsl:text>, reflection parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:reflecInv"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="hunda:QNs/hunda:J"/>
            <xsl:text>, |Λ|=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Lambda"/>
            <xsl:text>, |Σ|=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Sigma"/>
            <xsl:text>, Ω=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Omega"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="hunda:QNs/hunda:S"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="hunda:QNs/hunda:v"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="hunda:QNs/hunda:F"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="hunda:QNs/hunda:F1"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="hunda:QNs/hunda:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='hundb']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="hundb:QNs/hundb:ElecStateLabel"/>
            <xsl:text>, inversion parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:elecInv"/>
            <xsl:text>, reflection parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:reflecInv"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="hundb:QNs/hundb:J"/>
            <xsl:text>, |Λ|=</xsl:text><xsl:value-of select="hundb:QNs/hundb:Lambda"/>
            <xsl:text>, Ω=</xsl:text><xsl:value-of select="hundb:QNs/hundb:Omega"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="hundb:QNs/hundb:S"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="hundb:QNs/hundb:v"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="hundb:QNs/hundb:N"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="hundb:QNs/hundb:F"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="hundb:QNs/hundb:F1"/>
            <xsl:text>, spin component=</xsl:text><xsl:value-of select="hundb:QNs/hundb:SpinComponentLabel"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="hundb:QNs/hundb:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='stcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="stcs:QNs/stcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="stcs:QNs/stcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="stcs:QNs/stcs:li"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="stcs:QNs/stcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="stcs:QNs/stcs:vibSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="stcs:QNs/stcs:J"/>
            <xsl:text>, K=</xsl:text><xsl:value-of select="stcs:QNs/stcs:K"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="stcs:QNs/stcs:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="stcs:QNs/stcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="stcs:QNs/stcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="stcs:QNs/stcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="stcs:QNs/stcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='lpcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:li"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:l"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vibRefl"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:J"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='asymcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vi"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vibRefl"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:J"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Kc"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='asymos']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="asymos:QNs/asymos:ElecStateLabel"/>
            <xsl:text>, electronic symmetry=</xsl:text><xsl:value-of select="asymos:QNs/asymos:elecSym"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="asymos:QNs/asymos:elecInv"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="asymos:QNs/asymos:S"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="asymos:QNs/asymos:vi"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="asymos:QNs/asymos:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="asymos:QNs/asymos:vibRefl"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="asymos:QNs/asymos:N"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Kc"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="asymos:QNs/asymos:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="asymos:QNs/asymos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="asymos:QNs/asymos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="asymos:QNs/asymos:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='sphcs']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:li"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:J"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='sphos']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="sphos:QNs/sphos:ElecStateLabel"/>
            <xsl:text>, electronic symmetry=</xsl:text><xsl:value-of select="sphos:QNs/sphos:elecSym"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="sphos:QNs/sphos:elecInv"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="sphos:QNs/sphos:S"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="sphos:QNs/sphos:vi"/>
            <xsl:text>, l1=</xsl:text><xsl:value-of select="sphos:QNs/sphos:li"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="sphos:QNs/sphos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="sphos:QNs/sphos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="sphos:QNs/sphos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="sphos:QNs/sphos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="sphos:QNs/sphos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="sphos:QNs/sphos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="sphos:QNs/sphos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="sphos:QNs/sphos:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='ltos']">
        <p>
            <xsl:text>Label=</xsl:text><xsl:value-of select="ltos:QNs/ltos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="ltos:QNs/ltos:S"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="ltos:QNs/ltos:N"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v3"/>
            <xsl:text>, l2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:l2"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="ltos:QNs/ltos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="ltos:QNs/ltos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="ltos:QNs/ltos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="ltos:QNs/ltos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="ltos:QNs/ltos:I"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="ltos:QNs/ltos:asSym"/>
        </p>
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
    
    <xsl:template name="value-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="$quantity/xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="@*|text()"/>
    
</xsl:stylesheet>
