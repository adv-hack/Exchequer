<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="pstockcode|mstockcode">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 16)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="deletestat">
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