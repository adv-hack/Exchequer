<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/TR/WD-xsl"
  xmlns="http://www.w3.org/TR/REC-html20"
  result-ns="">

<!-- title:			        Exchequer XSL stylesheet for MSXML		-->
<!-- stylesheet version:	1.0						-->
<!-- schema version:		3.00						-->
<!-- created:				18 July 2000				-->
<!-- author:				Graham Postles (TAS)/Eduardo                                  -->
<!-- contact:				support@exchequer.com			-->															-->
<!-- previous version:			        -->
<!-- changes:					-->


<xsl:template match="/">
	<HTML>
		<head>
			<title>BASDA <xsl:value-of select="//Order/OrderHead/OrderType" /><xsl:value-of select="//Invoice/InvoiceHead/InvoiceType" /></title>
			
		</head>
		<body bgcolor="#FFFFFF" text="#000000">
			<xsl:apply-templates select="//Order" />
			<xsl:apply-templates select="//Invoice" />
		</body>
	</HTML>
</xsl:template>

<xsl:template match="Order">
	
		
			<table width="100%" border="0" cellspacing="0" cellpadding="3" bgcolor="#CCCCFF">
				<tr>
					<td width="100%" colspan="3"><font face="Verdana,Helvetica,Arial,sans-serif" size="4" color="#000066"><B>Exchequer Software Ltd</B></font></td>
				</tr>
				<tr>
					<td width="100%" colspan="3"><font face="Verdana,Helvetica,Arial,sans-serif" size="3">Purchase Order</font></td>
				</tr>
				<tr>
					<td width="33%" valign="top"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Order From:-</b></font></td>
					
					<td width="33%" valign="top"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Invoice To:</b></font></td>					
					
					<td width="32%" valign="top"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Deliver To:</b></font></td>
				</tr>
				<tr>
					<td valign="top" bgcolor="#FFFFFF">
					  <font face="Verdana,Helvetica,Arial,sans-serif" size="1"><xsl:value-of select="Supplier/Party" /><br />
					  <xsl:apply-templates select="Supplier/Address" /></font>
					  </td>
					<td valign="top" bgcolor="#FFFFFF">
					  <font face="Verdana,Helvetica,Arial,sans-serif" size="1"><xsl:value-of select="Buyer/Party" /><br />
					  <xsl:apply-templates select="Buyer/Address" /></font>
					</td>
					<td valign="top" bgcolor="#FFFFFF">
					  <font face="Verdana,Helvetica,Arial,sans-serif" size="1"><xsl:value-of select="Delivery/DeliverTo/Party" /><br />
					  <xsl:apply-templates select="Delivery/DeliverTo/Address" /></font>
					</td>
				</tr>
				
			</table>
		  
			<br/>
		  
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr bgcolor="#000000">
					
					<td width="15%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>Date</b></font></td>
					<td width="15%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>Our Ref</b></font></td>
					<td width="25%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>Your Ref</b></font></td>
					<td width="15%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>A/C No</b></font></td>
					<td width="15%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>Ship Method</b></font></td>
					<td width="15%"><font face="Verdana,Helvetica,Arial,sans-serif" size="1" color="#FFFFFF"><b>Page No</b></font></td>
					
				</tr>
				<tr bgcolor="#E8E8E8">
					<td><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><xsl:apply-templates select="OrderDate" /></font></td>
					<td>
						<font face="Verdana,Helvetica,Arial,sans-serif" size="1">
						<xsl:choose>
							<xsl:when test="Buyer/BuyerReferences/SuppliersCodeForBuyer"><xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer" /></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
						</font>
					</td>
					<td>
						<font face="Verdana,Helvetica,Arial,sans-serif" size="1">
						<xsl:choose>
							<xsl:when test="OrderReferences/SuppliersOrderReference"><xsl:value-of select="OrderReferences/SuppliersOrderReference" /></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
						</font>
					</td>
					<td>
						<font face="Verdana,Helvetica,Arial,sans-serif" size="1">
						<xsl:choose>
							<xsl:when test="Supplier/SupplierReferences/BuyersCodeForSupplier"><xsl:value-of select="Supplier/SupplierReferences/BuyersCodeForSupplier" /></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
						</font>
					</td>
					<td>
						<font face="Verdana,Helvetica,Arial,sans-serif" size="1">
						<xsl:choose>
							<xsl:when test="Delivery/Carrier"><xsl:value-of select="Delivery/Carrier" /></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
						</font>
					</td>
					<td>-</td>
				</tr>
			</table>
		  
			<br/>
		  
			<table width="100%" border="0" cellspacing="1" cellpadding="3" bgcolor="#E8E8E8"> 
				<tr bgcolor="#CCCCCC">
					<td width="45%" align="left"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Description</b></font></td>
					<td width="10%" align="right"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Qty</b></font></td>
					<td width="15%" align="right"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Unit Price</b></font></td>
					<td width="15%" align="right"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Discount</b></font></td>
					<td width="15%" align="right"><font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>Total</b></font></td>
				</tr>
		    
				<xsl:apply-templates select="OrderLine" />
		    
			</table>
		  
			<br/>
		  
			<table width="100%" border="0" cellspacing="1" cellpadding="3"> 
				<tr>
					<td width="70%" colspan="5"></td>
					<td width="15%" align="right" bgcolor="#CCCCCC"><font face="Verdana,Helvetica,Arial,sans-serif" size="2"><b>Total</b></font></td>
                    <td width="15%" align="right" bgcolor="#E8E8E8">
					<font face="Verdana,Helvetica,Arial,sans-serif" size="1"><b>
                    <xsl:for-each select="OrderTotal/GoodsValue" >
				      <xsl:eval> 
					    formatnumber(this.nodetypedvalue,"0.00")
                      </xsl:eval>
                    </xsl:for-each>
                    </b></font>
</td>
					
				</tr>
			</table>


</xsl:template>


<xsl:template match="OrderLine">
	    <tr>
	        <td align="left">
	          <font face="Verdana,Helvetica,Arial,sans-serif" size="1"><xsl:value-of select="Product/Description" /></font>
	        </td>
            <td align="right">
              <font face="Verdana,Helvetica,Arial,sans-serif" size="1">
			  <xsl:choose>
					<xsl:when test="Quantity/Amount"></xsl:when>
					<xsl:otherwise> - </xsl:otherwise>
			  </xsl:choose>
              <xsl:value-of select="Quantity/Amount" />
             </font>
            </td>
            <td align="right">
              <font face="Verdana,Helvetica,Arial,sans-serif" size="1">
			  <xsl:choose>
					<xsl:when test="Price/UnitPrice"></xsl:when>
					<xsl:otherwise> - </xsl:otherwise>
			  </xsl:choose>
              <xsl:for-each select="Price/UnitPrice" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")
              </xsl:eval>
             </xsl:for-each>
              </font>
            </td>
			<td align="right">
				
              <font face="Verdana,Helvetica,Arial,sans-serif" size="1">
			  <xsl:choose>
					<xsl:when test="AmountDiscount/Amount"></xsl:when>
					<xsl:otherwise> - </xsl:otherwise>
			  </xsl:choose>
              <xsl:for-each select="AmountDiscount/Amount" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")</xsl:eval>
               </xsl:for-each>
             </font>
            </td>

            <td align="right">
              <font face="Verdana,Helvetica,Arial,sans-serif" size="1">
              <xsl:choose>
					<xsl:when test="LineTotal"></xsl:when>
					<xsl:otherwise> - </xsl:otherwise>
			  </xsl:choose>
			  <xsl:for-each select="LineTotal" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")
              </xsl:eval>
             </xsl:for-each>
             </font>
            </td>
	      
	    </tr>
</xsl:template>


<xsl:template match="Invoice">
	


			<table border="0" width="100%">
				<tr>
						<td width="70%" valign="top">
							<font color="darkblue" face="Arial" size="6"><b>Exchequer</b></font><font color="darkblue" face="Arial" size="6"> Software Ltd</font>
							<DIV Class="ourAddress"><br/>Exchequer Software Ltd,Exchequer Grange, Wootton Gardens,Bournemouth, BH1 1PW<br/>Tel:01202 - 298008   Fax:01202 298001<br/>VAT No: GB - 432 4532 58</DIV>
						</td>
						<td width="30%" valign="top">
							<DIV Class="invHeader">
							Invoice No:
							<xsl:choose>
								<xsl:when test="InvoiceReferences/SuppliersInvoiceNumber"><xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber" /></xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose><br/>
							Invoice Date:
							<xsl:apply-templates select="InvoiceDate" />
							<br/>
							Page: 1<br/>
							</DIV>
						</td>
				</tr>
			</table>			
			<table border="1" bordercolor="white" width="100%">

				<tr>
					<td width="100%" height="21" colspan="5"></td>
				</tr>
				<tr>

					<td width="7%" height="150" valign="top" rowspan="2"></td>
					<td width="38%" height="23" valign="top"><DIV Class="addressHeader">INVOICE TO:</DIV></td>					
					<td width="7%" height="150" valign="top" rowspan="2"></td>
					<td width="38%" height="23" valign="top"><DIV Class="addressHeader">DELIVER TO:</DIV></td>
					<td width="7%" height="150" valign="top" rowspan="2"></td>
				</tr>
				<tr>
					<td valign="top"  bordercolor="darkblue">
					<DIV Class="address">
					<xsl:value-of select="Buyer/Party" /><br/>
					<xsl:apply-templates select="Buyer/Address" /></DIV></td>
					<td valign="top"  bordercolor="darkblue">
					<DIV Class="address">
					<xsl:value-of select="Delivery/DeliverTo/Party" /><br/>
					<xsl:apply-templates select="Delivery/DeliverTo/Address" /></DIV></td>
				</tr>
			</table>
		  
			<br/>
		  
			<table border="1" width="100%" height="38" bordercolor="darkblue">
				<tr  style="color:black;font-size:6pt;font-family:Arial">
					<td width="17%" align="right"><DIV Class="generalHeader">Your Ref:</DIV></td>
					<td width="17%">
						<DIV Class="general">
						<xsl:choose>
							<xsl:when test="InvoiceReferences/BuyersOrderNumber"><xsl:apply-templates select="InvoiceReferences/BuyersOrderNumber" /></xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
						</DIV>
					</td>
					<td width="17%" bordercolor="white" align="right"><DIV Class="generalHeader">Desc:</DIV></td>
					<td width="17%" bordercolor="white">
						<DIV Class="general">
						<xsl:choose>
							<xsl:when test="INVOICEHEAD/INVOICEDESC"><xsl:value-of select="INVOICEHEAD/INVOICEDESC" /></xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
						</DIV>
					</td>
					<td width="16%" bordercolor="white" align="right"><DIV Class="generalHeader">Customer Code:</DIV></td>
					<td width="16%" bordercolor="white">
						<DIV Class="general">
						<xsl:choose>
							<xsl:when test="Buyer/BuyerReferences/SuppliersCodeForBuyer"><xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer" /></xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
						</DIV>
					</td>
				</tr>
				<tr  style="color:black;font-size:8pt;font-family:Arial">
					<td bordercolor="white" align="right"><DIV Class="generalHeader">Our Ref:</DIV></td>
					<td bordercolor="white">
						<DIV Class="general">
						<xsl:choose>
							<xsl:when test="SuppliersOrderReference"><xsl:apply-templates select="SuppliersOrderReference" /></xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
						</DIV>
					</td>
					<td bordercolor="white">
					</td>
					<td bordercolor="white">
					</td>
					<td bordercolor="white" align="right"><DIV Class="generalHeader">Order Date:</DIV></td>
					<td bordercolor="white"><DIV Class="general"><xsl:apply-templates select="InvoiceDate" /></DIV></td>
				</tr>
			</table>
		  

			<br/>
		  
			<table border="0" width="100%" height="60" bordercolor="darkblue"> 
				<tr bgcolor="darkblue">
					<td width="50%" align="centre"><DIV Class="linesHeader">DESCRIPTION</DIV></td>
					<td width="10%" align="left"><DIV Class="linesHeader">QUANTITY</DIV></td>
					<td width="15%" align="right"><DIV Class="linesHeader">PRICE</DIV></td>
					<td width="10%" align="right"><DIV Class="linesHeader">DISCOUNT</DIV></td>
					<td width="15%" align="right"><DIV Class="linesHeader">TOTAL</DIV></td>
				</tr>
		    
				<xsl:apply-templates select="InvoiceLine" />
		    
			</table>

			<table border="0" width="100%">
				<tr>
					<td width="70%">
		 				<table border="0" width="100%" height="33"> 
							<tr>
								<td width="10%" bgcolor="#99CCFF" style="background-color:darkblue"><DIV Class="vatHeader">VAT Rate</DIV></td>
								<td width="10%" bgcolor="#99CCFF" style="background-color:darkblue"><DIV Class="vatHeader">Net Amt</DIV></td>
								<td width="10%" bgcolor="#99CCFF" style="background-color:darkblue"><DIV Class="vatHeader">VAT Amt</DIV></td>
								<td width="40%" colspan="5"  bgcolor="#99CCFF"></td>
							</tr>
							<xsl:for-each select="TaxSubTotal">
							<tr>
								<td width="10%" bgcolor="#99CCFF">
									<DIV Class="vat">
										<xsl:value-of select="TaxRate" />	
									</DIV>
								</td>
								<td width="10%" bgcolor="#99CCFF">
									<DIV Class="vat">
										<xsl:value-of select="TotalValueAtRate" />
									</DIV>
								</td>
								<td width="10%" bgcolor="#99CCFF">
									<DIV Class="vat">
										<xsl:value-of select="TaxAtRate" />
									</DIV>
								</td>
								<td width="40%" colspan="5"  bgcolor="#99CCFF"></td>
							</tr>
							</xsl:for-each>
						  </table>
					</td>
					<td width="30%">
						<table border="0" width="100%">
							<tr>
								<td width="15%" align="right" style="background-color:darkblue">
								  <DIV Class="totalsHeader">NET</DIV>
								</td>
						        <td align="right" width="15%" style="font-weight:bold" bgcolor="#99CCFF">	
						        	<DIV Class="totals">			
									<xsl:for-each select="InvoiceTotal">
										<xsl:value-of select="LineValueTotal" />
									</xsl:for-each>
									</DIV>
						        </td>
							</tr>
							<tr>
								<td width="15%" align="right" style="background-color:darkblue">
								  <DIV Class="totalsHeader">VAT</DIV>
								</td>
						        <td align="right" width="15%" style="font-weight:bold" bgcolor="#99CCFF">
								  <DIV Class="totals">
								  <xsl:for-each select="InvoiceTotal">
								    <xsl:value-of select="TaxTotal" />
								  </xsl:for-each>
						          </DIV>
						        </td>
							</tr>
							<tr>
								<td width="15%" align="right" style="background-color:darkblue">
								  <DIV Class="totalsHeader">TOTAL</DIV>
								</td>
						        	<td align="right" width="15%" style="font-weight:bold" bgcolor="#99CCFF">
									<DIV Class="totals">
									<xsl:for-each select="InvoiceTotal">
										<xsl:value-of select="GrossPaymentTotal" />
									</xsl:for-each>
						        	</DIV>
						        	</td>			
							</tr>
						</table>
					</td>
				</tr>
			</table>
	

	
</xsl:template>

<xsl:template match="InvoiceLine">
	    <tr>
	        <td align="left" bgcolor="#99CCFF">
	          <DIV Class="lines">
	          <xsl:value-of select="Product/Description" />
			  </DIV>
	        </td>
            <td align="right" bgcolor="#99CCFF">
              <DIV Class="lines">
              <xsl:for-each select="Quantity/Amount" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")</xsl:eval>
              </xsl:for-each>
             </DIV>
            </td>
            <td align="right" bgcolor="#99CCFF">
              <DIV Class="lines">
              <xsl:for-each select="Price/UnitPrice" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")</xsl:eval>
              </xsl:for-each>
             </DIV>
            </td>
            <td align="right" bgcolor="#99CCFF">
              <DIV Class="lines">
              <xsl:for-each select="AmountDiscount/Amount" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")</xsl:eval>
               </xsl:for-each>
             </DIV>
            </td>
            <td align="right" bgcolor="#99CCFF">
			  <DIV Class="lines">
              <xsl:for-each select="LineTotal" >
                <xsl:eval> formatnumber(this.nodetypedvalue,"0.00")</xsl:eval>
               </xsl:for-each>
             </DIV>
            </td>
	    </tr>
</xsl:template>

<xsl:template match="InvoiceDate"><xsl:eval>dateToString(this.text)</xsl:eval></xsl:template>

<xsl:template match="OrderDate"><xsl:apply-templates select="OrderDate" /></xsl:template>

<xsl:template match="OrderDate"><xsl:eval>dateToString(this.text)</xsl:eval></xsl:template>

<xsl:template match="Address">
	<xsl:if test="NAME"><xsl:value-of select="Party" /></xsl:if>
	<xsl:for-each select="AddressLine">
		<xsl:value-of select="." /><br/>
    </xsl:for-each>
    <xsl:for-each select="Street">
		<xsl:value-of select="." /><br/>
    </xsl:for-each>
	<xsl:if test="CITY"><xsl:value-of select="City" /></xsl:if>
	<xsl:if test="STATE"><br/><xsl:value-of select="State" /></xsl:if>
	<xsl:if test="POSTCODE"><br/><xsl:value-of select="PostCode" /></xsl:if>
	<xsl:if test="COUNTRY"><br/><xsl:value-of select="Country" /></xsl:if>
</xsl:template>

<xsl:script><![CDATA[
	function dateToString(strInput)
	{
		var strYear = strInput.substr(0,4);
		var strMonth = strInput.substr(5,2);
		var strDay = strInput.substr(8,2);
		return(strDay + "/" + strMonth + "/" + strYear);
	}
]]></xsl:script>



</xsl:stylesheet>

