unit ActivateF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, oIRISLicence, StdCtrls, ComCtrls;

Type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    tabshMain: TTabSheet;
    Label1: TLabel;
    Label4: TLabel;
    edtCDKey: TEdit;
    btnActivateFromWS: TButton;
    edtActivationKey: TEdit;
    tabshLogging: TTabSheet;
    memLogging: TMemo;
    btnActivateCDKey: TButton;
    Button1: TButton;
    Label2: TLabel;
    edtActivationDate: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnActivateFromWSClick(Sender: TObject);
    procedure btnActivateCDKeyClick(Sender: TObject);
  private
    { Private declarations }
    //FLicencingInterface : IIRISLicencing;
    oIRISLicencing : TIRISLicence;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Procedure AddToLog (LogMsg : ANSIString);
Procedure AddXMLToLog (XMLMsg : ANSIString);

implementation

{$R *.dfm}

Uses GmXML;

//=========================================================================

Procedure AddToLog (LogMsg : ANSIString);
Begin // AddToLog
  Form1.memLogging.Lines.Add(LogMsg);
End; // AddToLog

//------------------------------

Procedure AddXMLToLog (XMLMsg : ANSIString);
Begin // AddXMLToLog
  If (Pos('<?xml version', XMLMsg) = 1) Then
    With TGmXML.Create(NIL) Do
    Begin
      Try
        Text := XMLMsg;
        Form1.memLogging.Lines.Add(Text);
      Finally
        Free;
      End; // Try..Finally
    End // With TGmXML.Create(NIL)
  Else
    Form1.memLogging.Lines.Add(XMLMsg);
End; // AddXMLToLog

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
begin
//  // Create IRIS Licencing COM OBject (wrapper of .NET class)
//  FLicencingInterface := CoLicensingInterface.Create;
//
//  If (Not FLicencingInterface.InitialiseLocalDatabase) Then
//  Begin
//    Raise Exception.Create('TIRISLicence.CheckInit: Error Initialising Local Database');
//  End; // If (Not FLicencingInterface.InitialiseLocalDatabase)

  oIRISLicencing := TIRISLicence.Create;
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //FLicencingInterface := NIL;
  FreeAndNIL(oIRISLicencing);
end;

//-------------------------------------------------------------------------

procedure TForm1.btnActivateFromWSClick(Sender: TObject);
Var
  sError : ANSIString;
begin
  AddToLog ('GetActivationKey');
  AddToLog ('================');
  oIRISLicencing.CDKey := edtCDKey.Text;
  If oIRISLicencing.GetActivationKey(sError) Then
  Begin
    edtActivationKey.Text := oIRISLicencing.ActivationKey;
    edtActivationDate.Text := FormatDateTime('DD/MM/YYYY', oIRISLicencing.ActivationDate);
  End // If oIRISLicencing.Activate()
  Else
  Begin
    edtActivationKey.Text := '';
    edtActivationDate.Text := '';
    ShowMessage ('GetActivationKey returned ' + sError);
  End; // Else
end;

//-------------------------------------------------------------------------

procedure TForm1.btnActivateCDKeyClick(Sender: TObject);
Var
  sError : ANSIString;
begin
  AddToLog ('DecodeActivationKey');
  AddToLog ('===================');
  oIRISLicencing.CDKey := edtCDKey.Text;
  If oIRISLicencing.DecodeActivationKey(edtActivationKey.Text, sError) Then
  Begin
    edtActivationKey.Text := oIRISLicencing.ActivationKey;
    edtActivationDate.Text := FormatDateTime('DD/MM/YYYY', oIRISLicencing.ActivationDate);
  End // If oIRISLicencing.Activate()
  Else
  Begin
    edtActivationKey.Text := '';
    edtActivationDate.Text := '';
    ShowMessage ('DecodeActivationKey returned ' + sError);
  End; // Else
end;

end.
