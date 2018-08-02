unit EmailUtil;

interface
uses
  Classes;

procedure AddStandardHTMLEmailHeader(EmailText : TStringList);
procedure AddStandardHTMLEmailFooter(EmailText : TStringList);

implementation

procedure AddStandardHTMLEmailHeader(EmailText : TStringList);
begin
  with EmailText do
  begin
    Add('<HTML><!-- InstanceBegin template="/Templates/IRISCustomerNewswire.dwt" codeOutsideHTMLIsLocked="false" --><HEAD>');
    Add('<!-- InstanceBeginEditable name="doctitle" -->');
    Add('<TITLE>IRIS Enterprise Software : WebRel</TITLE>');
    Add('<!-- InstanceEndEditable --><style type="text/css">');
    Add('.style2 {');
    Add('	font-family: Verdana, Arial, Helvetica, sans-serif;');
    Add('	font-size: 9px;');
    Add('	color: #999999;');
    Add('}');
    Add('body {');
    Add('	margin-left: 0px;');
    Add('	margin-top: 0px;');
    Add('}');
    Add('.style18 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000080; }');
    Add('.style10 {	font-family: Verdana, Arial, Helvetica, sans-serif;');
    Add('	font-size: 9px;');
    Add('	color: #003366;');
    Add('}');
    Add('-->');
    Add('</style>');
    Add('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');
    Add('<!-- InstanceBeginEditable name="head" -->');
    Add('<style type="text/css">');
    Add('<!--');
    Add('.style19 {	font-size: 10px;');
    Add('	font-family: "Gill Sans MT", Verdana, Arial;');
    Add('	color: #003366;');
    Add('}');
    Add('.style30 {color: #003366}');
    Add('.style43 {	font-size: 12px;');
    Add('	color: #CC0000;');
    Add('}');
    Add('.style49 {font-family: "Gill Sans MT", Verdana, Arial; font-weight: bold;}');
    Add('.style51 {font-family: "Gill Sans MT", Verdana, Arial; font-weight: bold; color: #FF0000; }');
    Add('.style52 {font-family: "Gill Sans MT", Verdana, Arial}');
    Add('.style53 {color: #CC0000}');
    Add('-->');
    Add('</style>');
    Add('<!-- InstanceEndEditable -->');
    Add('</HEAD>');
    Add('<BODY>');
    Add('<TABLE cellSpacing=0 cellPadding=0 width=780 border=0>');
    Add('  <TBODY>');
    Add('    <TR vAlign=top>');
    Add('      <TD height="20" colspan="5">');
    Add('      <div align="center"><img src="http://www.iris.co.uk/images/blueTop.jpg" width="749" height="7"></div>');
    Add('    </TD>');
    Add('    </TR>');
    Add('    <TR vAlign=top>');
    Add('      <TD width=9>&nbsp;</TD>');
    Add('      <TD width=137>');
    Add('      <P><img height=64 alt="IRIS Enterprise Software"');
    Add('      src="http://www.iris.co.uk/images/exchequer_logo.gif" width=137> </P>');
    Add('    </TD>');
    Add('      <TD width=25');
    Add('    background="http://www.iris.co.uk/images/page_structure/grey_vert_dot.gif">&nbsp;</TD>');
    Add('      <!-- Start Main Body -->');
    Add('    <TD><img height=66 alt=Montage src="http://www.iris.co.uk/images/strapImages/finance.jpg"');
    Add('      width=429><img height=66 alt="Iris picture"');
    Add('      src="http://www.iris.co.uk/images/strapImages/plain_blue_right.jpg" width=158>');
    Add('      <TABLE cellSpacing=0 cellPadding=0 width=587 border=0>');
    Add('            <TBODY>');
    Add('              <TR vAlign=top>');
    Add('          <TD width=404>');
    Add('            <!-- InstanceBeginEditable name="Main Copy Area" -->');
    Add('            <p align="left" class="style20 style44">&nbsp;</p>');
    Add('            <p align="left" class="style20 style44">&nbsp;</p>');
    Add('            <font face="Arial, Helvetica, sans-serif" size="2" color="#666666">');
    Add('            <table width="500" border="0" cellspacing="0" cellpadding="2">');
  end;{with}
end;

procedure AddStandardHTMLEmailFooter(EmailText : TStringList);
begin
  with EmailText do
  begin
    Add('            <p align="left" class="style20 style44">&nbsp;</p>');
    Add('            <p align="left" class="style20 style44">&nbsp;</p>');
    Add('            <p align="left" class="style20 style44">&nbsp;</p>');
    Add('                <tr>&nbsp</tr>');
    Add('                <tr>&nbsp</tr>');
    Add('              </tr>');
    Add('            </table>');
    Add('            </font>');
    Add('                  <!-- InstanceEndEditable --> </TD>');
    Add('                <TD width=25>&nbsp;</TD>');
    Add('');
    Add('          <TD id=xAtBottom width=158>');
    Add('            <p><BR>');
    Add('                </p>                  </TD>');
    Add('              </TR>');
    Add('            </TBODY>');
    Add('        </TABLE></TD>');
    Add('      <TD width=22>&nbsp;</TD>');
    Add('    </TR>');
    Add('    <TR vAlign=top>');
    Add('');
    Add('    <TD><IMG height=12 src="http://www.iris.co.uk/images/page_structure/spacer.gif"');
    Add('      width=12></TD>');
    Add('');
    Add('    <TD><IMG height=12 src="http://www.iris.co.uk/images/page_structure/spacer.gif"');
    Add('      width=12></TD>');
    Add('');
    Add('    <TD><IMG height=12 src="http://www.iris.co.uk/images/page_structure/spacer.gif"');
    Add('      width=12></TD>');
    Add('');
    Add('    <TD><IMG height=12 src="http://www.iris.co.uk/images/page_structure/spacer.gif"');
    Add('      width=12></TD>');
    Add('');
    Add('    <TD><IMG height=12 src="http://www.iris.co.uk/images/page_structure/spacer.gif"');
    Add('      width=12></TD>');
    Add('    </TR>');
    Add('    <TR vAlign=top>');
    Add('      <TD>&nbsp;</TD>');
    Add('      <TD>&nbsp;</TD>');
    Add('      <TD>&nbsp;</TD>');
    Add('');
    Add('    <TD><font face="Arial, Helvetica, sans-serif" size="1" color="#666666">IRIS');
    Add('      Enterprise Software Ltd are members of BASDA, the Business<br>');
    Add('      Application Software Developers'' Association.&copy; 2006 IRIS Enterprise');
    Add('      Software Ltd.</font></TD>');
    Add('      <TD>&nbsp;</TD>');
    Add('    </TR>');
    Add('  </TBODY>');
    Add('</TABLE>');
    Add('</BODY><!-- InstanceEnd --></HTML>');
  end;{with}
end;

end.
