<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- fields with cdata  -->
  <xsl:output cdata-section-elements="yourref"/>
  <xsl:output cdata-section-elements="longyrref"/>
  <xsl:output cdata-section-elements="daddr1"/>
  <xsl:output cdata-section-elements="daddr2"/>
  <xsl:output cdata-section-elements="daddr3"/>
  <xsl:output cdata-section-elements="daddr4"/>
  <xsl:output cdata-section-elements="daddr5"/>
  <xsl:output cdata-section-elements="docuser1"/>
  <xsl:output cdata-section-elements="docuser2"/>
  <xsl:output cdata-section-elements="docuser3"/>
  <xsl:output cdata-section-elements="docuser4"/>

  <xsl:template match="@*| node()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()">
  <!-- get rid off comments -->
  </xsl:template>
  
  <xsl:template match="transdoched|delterms|cc|dep|item|mlocstk">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 3)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ssdcountry">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 5)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="custcode|empcode|timecreate|timechange">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 6)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="postdate|linedate|cisdate|autoenddate|ssdcommod|tlreconciliationdate|duedate|transdate">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 8)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ourref">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 9)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="yourref|opname|djobcode|djobanal|cisempl|thdeliverynoteref|jobcode|analcode">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 10)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="thdeliveryrunno">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 12)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="stockcode">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 16)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="longyrref|docuser1|docuser2">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 20)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="daddr1|daddr2|daddr3|daddr4|daddr5|docuser3|docuser4">
    <xsl:copy>
      <xsl:value-of select="substring(., 1, 30)"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- boolean fields -->
  <xsl:template match="disctaken|printeddoc|manvat|porpicksor|sopkeeprate|cismanualtax|autopost|thautotransaction|thexternal|thpostdisctaken">
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