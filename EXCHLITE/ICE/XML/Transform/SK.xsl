<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->

<xsl:output cdata-section-elements="desc1"/>
<xsl:output cdata-section-elements="desc2"/>
<xsl:output cdata-section-elements="desc3"/>
<xsl:output cdata-section-elements="desc4"/>
<xsl:output cdata-section-elements="desc5"/>
<xsl:output cdata-section-elements="desc6"/>

<xsl:output cdata-section-elements="stbarcode"/>
<xsl:output cdata-section-elements="ststkuser1"/>
<xsl:output cdata-section-elements="ststkuser2"/>
<xsl:output cdata-section-elements="weblivecat"/>
<xsl:output cdata-section-elements="webprevcat"/>

<xsl:output cdata-section-elements="stkuser3"/>
<xsl:output cdata-section-elements="stkuser4"/>
<xsl:output cdata-section-elements="imagefile"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="desc1|desc2|desc3|desc4|desc5|desc6">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 35)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="stbarcode|ststkuser1|ststkuser2|weblivecat|webprevcat">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 20)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="stkuser3|stkuser4|imagefile">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="minflg|usecover|stpricepack|stdpackqty|stkitprice|stkitonpurch|pricebystkunit|showaskit|usesbins|wopcalcprodtime|qtystocktakechanged">
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