<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="accompany"/>
<xsl:output cdata-section-elements="acvatregno"/>
<xsl:output cdata-section-elements="acstreet1"/>
<xsl:output cdata-section-elements="acstreet2"/>
<xsl:output cdata-section-elements="actown"/>
<xsl:output cdata-section-elements="accounty"/>
<xsl:output cdata-section-elements="acpostcode"/>

<xsl:output cdata-section-elements="accontact"/>

<xsl:output cdata-section-elements="acphone"/>
<xsl:output cdata-section-elements="acfax"/>

<xsl:output cdata-section-elements="acterm1"/>
<xsl:output cdata-section-elements="acterm2"/>

<xsl:output cdata-section-elements="acbanksort"/>

<xsl:output cdata-section-elements="acbankacc"/>

<xsl:output cdata-section-elements="acbankref"/>

<xsl:output cdata-section-elements="acphone2"/>

<xsl:output cdata-section-elements="acuserdef1"/>
<xsl:output cdata-section-elements="acuserdef2"/>

<xsl:output cdata-section-elements="acccname"/>

<xsl:output cdata-section-elements="acemailaddr"/>

<xsl:output cdata-section-elements="acebuspwrd"/>
<xsl:output cdata-section-elements="acaltcode"/>

<xsl:output cdata-section-elements="acuserdef3"/>
<xsl:output cdata-section-elements="acuserdef4"/>

<xsl:output cdata-section-elements="acweblivecatalog"/>
<xsl:output cdata-section-elements="acwebprevcatalog"/>

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

<xsl:template match="acvatregno|acstreet1|acstreet2|actown|accounty|acpostcode|acphone|acfax|acphone2|acuserdef3|acuserdef4">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="accontact">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 25)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acterm1|acterm2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 60)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acbanksort">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 15)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acbankacc|acuserdef1|acuserdef2|acebuspwrd|acpostcode|acaltcode2|acweblivecatalog|acwebprevcatalog">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 20)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acbankref">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 28)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acccname">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 50)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acemailaddr">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 100)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acvatretregc">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 5)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acspare">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 109)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="acspare2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 50)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="acdespaddr|acowntradterm|acecmember|incstat|sopautowoff|emlsndrdr|emlzipatc|emlsndhtml|emluseedz">
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