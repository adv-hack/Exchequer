<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="company"/>
<xsl:output cdata-section-elements="vatregno"/>
<xsl:output cdata-section-elements="addr1"/>
<xsl:output cdata-section-elements="addr2"/>
<xsl:output cdata-section-elements="addr3"/>
<xsl:output cdata-section-elements="addr4"/>
<xsl:output cdata-section-elements="addr5"/>

<xsl:output cdata-section-elements="daddr1"/>
<xsl:output cdata-section-elements="daddr2"/>
<xsl:output cdata-section-elements="daddr3"/>
<xsl:output cdata-section-elements="daddr4"/>
<xsl:output cdata-section-elements="daddr5"/>

<xsl:output cdata-section-elements="contact"/>

<xsl:output cdata-section-elements="phone"/>
<xsl:output cdata-section-elements="fax"/>

<xsl:output cdata-section-elements="sterms1"/>
<xsl:output cdata-section-elements="sterms2"/>

<xsl:output cdata-section-elements="banksort"/>

<xsl:output cdata-section-elements="bankacc"/>

<xsl:output cdata-section-elements="bankref"/>

<xsl:output cdata-section-elements="phone2"/>

<xsl:output cdata-section-elements="userdef1"/>
<xsl:output cdata-section-elements="userdef2"/>

<xsl:output cdata-section-elements="ccdname"/>

<xsl:output cdata-section-elements="emailaddr"/>

<xsl:output cdata-section-elements="ebuspwrd"/>
<xsl:output cdata-section-elements="postcode"/>
<xsl:output cdata-section-elements="custcode2"/>

<xsl:output cdata-section-elements="userdef3"/>
<xsl:output cdata-section-elements="userdef4"/>

<xsl:output cdata-section-elements="weblivecat"/>
<xsl:output cdata-section-elements="webprevcat"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="company">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 45)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="vatregno|addr1|addr2|addr3|addr4|addr5|daddr1|daddr2|daddr3|daddr4|daddr5|phone|fax|phone2|userdef3|userdef4">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="contact">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 25)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="sterms1|sterms2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 60)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="banksort">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 15)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="bankacc|userdef1|userdef2|ebuspwrd|postcode|custcode2|weblivecat|webprevcat">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 20)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="bankref">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 28)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="ccdname">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 50)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="emailaddr">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 100)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="vatretregc">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 5)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="spare">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 109)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="spare2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 50)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="despaddr|tradterm|eecmember|incstat|sopautowoff|emlsndrdr|emlzipatc|emlsndhtml|emluseedz">
  <xsl:copy>
    <xsl:choose>
      <xsl:when test="starts-with(., 'T') or starts-with(., 't')">
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:when test="starts-with(., 'F') or starts-with(., 'f')">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:when test=".='0' or .='1'">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>