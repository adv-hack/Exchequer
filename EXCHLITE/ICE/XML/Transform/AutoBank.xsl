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

<xsl:template match="bankref">
  <bankref>
    <xsl:value-of select="substring(., 1, 45)"/>
  </bankref>
</xsl:template>

<xsl:template match="entryopo">
  <entryopo>
    <xsl:value-of select="substring(., 1, 10)"/>
  </entryopo>
</xsl:template>

<xsl:template match="entrydate|accountcode">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 8)"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>