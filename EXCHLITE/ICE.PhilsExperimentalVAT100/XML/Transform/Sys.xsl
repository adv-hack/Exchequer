<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<!-- fields with cdata  -->
<xsl:output cdata-section-elements="username"/>
<xsl:output cdata-section-elements="useraddr1"/>
<xsl:output cdata-section-elements="useraddr2"/>
<xsl:output cdata-section-elements="useraddr3"/>
<xsl:output cdata-section-elements="useraddr4"/>
<xsl:output cdata-section-elements="useraddr5"/>
<xsl:output cdata-section-elements="userref"/>
<xsl:output cdata-section-elements="userbank"/>

<xsl:output cdata-section-elements="traderudflabel1"/>
<xsl:output cdata-section-elements="traderudflabel2"/>
<xsl:output cdata-section-elements="traderudflabel3"/>
<xsl:output cdata-section-elements="traderudflabel4"/>
<xsl:output cdata-section-elements="stockudflabel1"/>
<xsl:output cdata-section-elements="stockudflabel2"/>
<xsl:output cdata-section-elements="stockudflabel3"/>
<xsl:output cdata-section-elements="stockudflabel4"/>
<xsl:output cdata-section-elements="transheadudflabel1"/>
<xsl:output cdata-section-elements="transheadudflabel2"/>
<xsl:output cdata-section-elements="transheadudflabel3"/>
<xsl:output cdata-section-elements="transheadudflabel4"/>
<xsl:output cdata-section-elements="translineudflabel1"/>
<xsl:output cdata-section-elements="translineudflabel2"/>
<xsl:output cdata-section-elements="translineudflabel3"/>
<xsl:output cdata-section-elements="translineudflabel4"/>
<xsl:output cdata-section-elements="translinetypelabel1"/>
<xsl:output cdata-section-elements="translinetypelabel2"/>
<xsl:output cdata-section-elements="translinetypelabel3"/>
<xsl:output cdata-section-elements="translinetypelabel4"/>
<xsl:output cdata-section-elements="jobcostudflabel1"/>
<xsl:output cdata-section-elements="jobcostudflabel2"/>

<xsl:template match="@*| node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()">
<!-- get ride off comments -->
</xsl:template>

<xsl:template match="username">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 45)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="useraddr1|useraddr2|useraddr3|useraddr4|useraddr5|uservatreg">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 30)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="userref">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 18)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="userbank">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 25)"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="traderudflabel1|traderudflabel2|traderudflabel3|traderudflabel4|stockudflabel1|stockudflabel2|stockudflabel3|stockudflabel4|transheadudflbel1|transheadudflabel2|transheadudflabel3|transheadudflabel4|translineudflabel1|translineudflabel2|translineudflabel3|translineudflabel4|translinetypelabel1|translinetypelabel2|translinetypelabel3|translinetypelabel4|jobcostudflabel1|jobcostudflabel2">
  <xsl:copy>
    <xsl:value-of select="substring(., 1, 15)"/>
  </xsl:copy>
</xsl:template>

<!-- boolean fields -->
<xsl:template match="ccdepts|intrastat|orderallocstock|calprfromdate|usecrlimitchk|usecreditchk|stopbaddr|usepick4all|freeexall|deductbomcomponents|filtersnobybinloc|keepbinhistory|inputpackqtyonline|percentagediscounts|transheadudfhide1|transheadudfhide2|transheadudfhide3|transheadudfhide4|translineudfhide1|translineudfhide2|translineudfhide3|translineudfhide4|translinetypehide1|translinetypehide2|translinetypehide3|translinetypehide4">
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