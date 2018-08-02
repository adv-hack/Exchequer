{.$DEFINE UNREGISTERED}
{This must be disabled with registered version}

{$DEFINE VCL}
{
 Disable above define if you are planning to use IMS components in
 DLLs, CGI applications, cosole applications.  In this case you will
 be not able to install the components onto Component palette, also
 all component editors will be unaccessible, but your programs will
 be much smaller, since IMS will not include in itself Forms,
 Controls and ExtCtrls units.

 If you are using IMS with above define disabled, please keep in
 mind that all components will descend not from TComponent, but
 from TObject, it means when you are creting the instance of IMS
 components, you should not pass any parameters to the Create
 constructor, like MySMTP:=TmsSMTPClient1.Create;  Also, all
 windows sockets will be blocking and there will be no external
 timeout checking, and there will be no way to cancel the operation.
 Anyway, if there is no User Interface, you can't have cancel button,
 so it should be OK :-)
}


{$DEFINE DECODEHEADERS}
{
 Decodes the mail headers when they contain high characters}

{.$DEFINE STATICWINSOCK}
{
  Winsock will be not loaded dynamically}

{.$DEFINE ActiveX}  {Currently not used}

{Compiler Directives}

{$A+}  {Aligned record fields on}
{$B-}  {Complete boolean evaluation off}
{$H+}  {Huge strings on}
{$P+}  {Open strings on}
{$T-}  {Typed @ operator off}
{$W-}  {Stack frames off}
{$X+}  {Extended syntax on}

