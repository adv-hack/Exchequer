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

<xsl:template match="ccdepcode">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 3)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="ccdepdesc">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>