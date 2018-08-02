<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="no" />

<xsl:template match="/">
      <authors> 
	<xsl:for-each select="//author">
		<author><xsl:value-of select="first_name"/><xsl:text> </xsl:text><xsl:value-of select="last_name"/></author>
	</xsl:for-each>
	</authors>
</xsl:template>

</xsl:stylesheet>


