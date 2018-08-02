<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="loname"/>
<xsl:output cdata-section-elements="loaddr1"/>
<xsl:output cdata-section-elements="loaddr2"/>
<xsl:output cdata-section-elements="loaddr3"/>
<xsl:output cdata-section-elements="loaddr4"/>
<xsl:output cdata-section-elements="loaddr5"/>

<xsl:output cdata-section-elements="lotel"/>
<xsl:output cdata-section-elements="lofax"/>
<xsl:output cdata-section-elements="loemail"/>
<xsl:output cdata-section-elements="lomodem"/>
<xsl:output cdata-section-elements="locontact"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="loaddr1|loaddr2|loaddr3|loaddr4|loaddr5|locontact">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="loname">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 45)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="loemail">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 100)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="lotag|louseprice|lousenom|louseccdep|lousesupp|lousebinloc|lousecprice|louserprice">
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