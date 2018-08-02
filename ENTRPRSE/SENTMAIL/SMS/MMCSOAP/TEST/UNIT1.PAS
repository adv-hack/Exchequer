unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, COMObj;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    oSMS : variant;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  sMessage, sNumber, sLabel, sUserName, sPassword, sCompany, sXML, sURL : string;
begin
  try
    oSMS := CreateOleObject('Smscomponent.mmcWrapper');
  except
    ShowMessage('Could not create a Smscomponent.mmcWrapper COM object');
  end;

  sURL := 'http://gateway.mobilemessagecentre.com/soap/mmc.dll';
  sUserName := 'nfrewer';
  sPassword := '77sail2';
  sCompany := '5512';
  sLabel := 'Exchequer';
  sNumber := '447946855132';
  sMessage := 'This is SOAP';

  // Numbers must be specified in their international format:
  // eg: 07768123456 is written 447768123456
  sXml := ' <mmc version=''1.0''>';
  sXml := sXml + #13 + '         <msg>';
  sXml := sXml + #13 + '            <numbers>';
  sXml := sXml + #13 + '               <number operatorid=''0'' model=''0'' country=''0'' make=''0''>' + sNumber + '</number>';
  sXml := sXml + #13 + '            </numbers>';
  sXml := sXml + #13 + '            <contents>';
  sXml := sXml + #13 + '               <text>' + sMessage + '</text>';
  sXml := sXml + #13 + '            </contents>';
  sXml := sXml + #13 + '        </msg>';
  sXml := sXml + #13 + '      </mmc>';

  oSMS.Url(sURL);
  oSMS.UserDetails(sUserName, sPassword, sCompany, sLabel);
  oSMS.Xml(sXML);
  oSMS.Send

{    Username = ''   ' Your username
    Password = ''   ' Your password
    Company = ''    ' Your Company ID
    Label = 'Mobmsgc.com'

    Xml = ' <mmc version=''1.0''>'
    Xml = Xml + '         <msg>'

    ' Numbers must be specified in their international format:
    ' eg: 07768123456 is written 447768123456

    Xml = Xml + '            <numbers>'
    Xml = Xml + '               <number operatorid=''0'' model=''0'' country=''0'' make=''0''>' & txtNum.Text & '</number>'
    Xml = Xml + '            </numbers>'
    Xml = Xml + '            <contents>'
    Xml = Xml + '               <text>' & txtMsg.Text & '</text>'
    Xml = Xml + '            </contents>'
    Xml = Xml + '        </msg>'
    Xml = Xml + '      </mmc>'


    ' Create an instance of the MMC component
    Set myobj = New mmcWrapper

    ' Load the URL for the Gateway
    myobj.Url Url

    ' Load the User Details
    myobj.UserDetails Username, Password, Company, Label

    ' Add the XML built above
    myobj.Xml Xml

    ' Send the message, returning the MMC Code
    Select Case myobj.Send()
        Case 0
            MsgBox 'Message Sent Successfully'
        Case 3
            MsgBox 'You need to enter your correct account details at the top of the VB program'
        Case Else
        ' This section can be used to trap all the error conditions
    End Select

    ' The Text property returns an human readable description of the MMC Code
    Text = myobj.Text

    ' The blockID is a unique GUID associated with the messages submitted.
    ' This is used with a number from Zero to the Count below to Query
    ' the messages status
    BlockId = myobj.BlockId

    ' This is the number of messages sent ( Multipart messages still count as 1 )
    Count = myobj.Count

    ' This returns the MMCCode from the previous send.
    CodeValue = myobj.Code

    lblblockid = BlockId
    lblCount = Count
    lblmmccode = CodeValue
    lbltxt = Text

    Set myobj = Nothing}
end;

end.
