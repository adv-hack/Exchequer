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

<xsl:template match="id">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 6)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="date">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 8)"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>