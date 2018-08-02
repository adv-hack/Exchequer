unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    btnSetup: TButton;
    Button3: TButton;
    memMessage: TMemo;
    btnSendx3: TButton;
    edNo: TEdit;
    mErrors: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button5: TButton;
    lVersion: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnSendx3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    oSMS : Variant;
{    oSMS : Variant;}
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  ComObj, Variants;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
{  try
    oSMS := CreateOleObject('EnterpriseSMS.SMSSender');
  except
    ShowMessage('Could not create a EnterpriseSMS.SMSSender COM object');
  end;

  oSMS.reset;
  lVersion.Caption := 'SMS Sender Version : ' + oSMS.Version;}
end;

procedure TForm1.btnSendClick(Sender: TObject);
var
  iStatus, iPos : integer;
  sMessage : string;
begin
//  with oSMS do begin
//  Debug := TRUE;
  try
    oSMS := CreateOleObject('EnterpriseSMS.SMSSender');
  except
    ShowMessage('Could not create a EnterpriseSMS.SMSSender COM object');
  end;

  Try
  oSMS.reset;
 lVersion.Caption := 'SMS Sender Version : ' + oSMS.Version;

    oSMS.Number := edNo.Text;

    for iPos := 0 to memMessage.Lines.Count - 1 do begin
      if trim(memMessage.Lines[iPos]) <> '' then sMessage := sMessage + memMessage.Lines[iPos] + #13
    end;{for}
    oSMS.Message := Copy(sMessage,1,Length(sMessage) - 1);

    mErrors.Lines.Add('Send : ' + edNo.Text);


    btnSend.Enabled := FALSE;
    btnSendx3.Enabled := FALSE;
    btnSetup.Enabled := FALSE;
    edNo.Enabled := FALSE;
    memMessage.Enabled := FALSE;

    iStatus := oSMS.Send;
//    iStatus := 0;

    btnSend.Enabled := TRUE;
    btnSendx3.Enabled := TRUE;
    btnSetup.Enabled := TRUE;
    edNo.Enabled := TRUE;
    memMessage.Enabled := TRUE;

    if iStatus <> 0 then mErrors.Lines.Add(oSms.GetErrorDesc(iStatus))
    else mErrors.Lines.Add('SMS Sent OK');
  Finally
    oSMS := Unassigned;
  End;

//  end;{with}
end;

procedure TForm1.btnSetupClick(Sender: TObject);
begin
  oSMS.Setup;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  oSMS.Abort;
end;

procedure TForm1.btnSendx3Click(Sender: TObject);
var
{  iPos : integer;
  sMessage : string;}
  i : integer;
begin
{0  with oSMS do begin
    Debug := TRUE;
    Caption := Version;
    CountryCode := '44';
    AreaCode := '07946';
    Number := '855132';

    Message := 'Message 1';
    Send;
    Message := 'Message 2';
    Send;
    Message := 'Message 3';
    Send;

  end;{with}


  for i := 1 to 3 do
  begin
//    mErrors.Lines.Add('Try ' + IntToStr(i));
//    mErrors.Repaint;
//    Application.ProcessMessages;
    while not oSMS.AreYouReady do SleepEx(100, True);
    btnSendClick(Self);

  end;


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  oSMS := unassigned;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s : string;
begin
  try
    oSMS := CreateOleObject('EnterpriseSMS.SMSSender');
  except
    ShowMessage('Could not create a EnterpriseSMS.SMSSender COM object');
    Exit;
  end;

  Try
    s := oSMS.GetErrorDesc(3333);
    ShowMessage(s);
  Finally
    oSMS := Unassigned;
  End;


end;

end.
