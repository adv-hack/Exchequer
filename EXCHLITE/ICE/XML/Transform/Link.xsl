<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="lkletterdescription"/>
<xsl:output cdata-section-elements="lkletterfilename"/>
<xsl:output cdata-section-elements="lklinkdescription"/>
<xsl:output cdata-section-elements="lklinkfilename"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="lkletterdescription">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 100)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="lkletterfilename">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 12)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="lklinkdescription">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 60)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="lklinkfilename">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 84)"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>