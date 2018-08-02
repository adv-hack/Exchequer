<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" omit-xml-declaration="no" />

<xsl:template match="/">
<html>
  <head>
     <title>our credit card slip</title>
  </head>
  <body>
      <p><b>Hello Everyone</b></p>
	<p><xsl:value-of select="biztalk_1/body/Order/OrderDate"/></p>
	<xsl:apply-templates select="//Order"/>
  </body>
</html>
 
</xsl:template>


<xsl:template match="Order">
      <p><b>Hello Everyone</b></p>
	<p><xsl:value-of select="OrderDate"/></p>
</xsl:template>

</xsl:stylesheet>