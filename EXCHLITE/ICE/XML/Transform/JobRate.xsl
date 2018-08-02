<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="jratedesc"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="jratedesc">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>