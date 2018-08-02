<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="jobdesc"/>
<xsl:output cdata-section-elements="contact"/>
<xsl:output cdata-section-elements="jobman"/>
<xsl:output cdata-section-elements="userdef1"/>
<xsl:output cdata-section-elements="userdef2"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="jobdesc">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="contact|jobman">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 25)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="userdef1|userdef2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 20)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="completed">
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