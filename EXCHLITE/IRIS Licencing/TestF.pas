unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleServer, ELITE_COM_TLB, oIRISLicence, GmXML,
  ComCtrls, StrUtils;

type
  TfrmLicenceTest = class(TForm)
    PageControl1: TPageControl;
    tabshMain: TTabSheet;
    tabshLogging: TTabSheet;
    Label1: TLabel;
    edtCDKey: TEdit;
    btnDecodeCDKey: TButton;
    btnGetLicCodes: TButton;
    Label2: TLabel;
    Label4: TLabel;
    edtCustomerNo: TEdit;
    Label5: TLabel;
    lstComponents: TListBox;
    lstInitialRestrictions: TListBox;
    btnLITEEquiv: TButton;
    Label3: TLabel;
    memLogging: TMemo;
    lstLicenceCodes: TListBox;
    Label6: TLabel;
    edtLITEVersion: TEdit;
    Label7: TLabel;
    lstLicenceRestrictions: TListBox;
    btnAddLicenceKey: TButton;
    btnEditLicenceKey: TButton;
    btnDeleteLicenceKey: TButton;
    btnValidateLicenceKey: TButton;
    btnClearAllKeys: TButton;
    btnEnterLicenceDetails: TButton;
    procedure btnDecodeCDKeyClick(Sender: TObject);
    procedure btnGetLicCodesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLITEEquivClick(Sender: TObject);
    procedure btnAddLicenceKeyClick(Sender: TObject);
    procedure btnEditLicenceKeyClick(Sender: TObject);
    procedure btnDeleteLicenceKeyClick(Sender: TObject);
    procedure btnValidateLicenceKeyClick(Sender: TObject);
    procedure btnClearAllKeysClick(Sender: TObject);
    procedure btnEnterLicenceDetailsClick(Sender: TObject);
  private
    { Private declarations }
    oIRISLicence : TIRISLicence;

    procedure LoadLicenceCodes;
  public
    { Public declarations }
  end;

var
  frmLicenceTest: TfrmLicenceTest;

Procedure AddToLog (LogMsg : ANSIString);
Procedure AddXMLToLog (XMLMsg : ANSIString);

implementation

{$R *.dfm}

Uses LicDetsF;

Procedure AddToLog (LogMsg : ANSIString);
Begin // AddToLog
  frmLicenceTest.memLogging.Lines.Add(LogMsg);
End; // AddToLog

Procedure AddXMLToLog (XMLMsg : ANSIString);
Begin // AddXMLToLog
  If (Pos('<?xml version', XMLMsg) = 1) Then
    With TGmXML.Create(NIL) Do
    Begin
      Try
        Text := XMLMsg;
        frmLicenceTest.memLogging.Lines.Add(Text);
      Finally
        Free;
      End; // Try..Finally
    End // With TGmXML.Create(NIL)
  Else
    frmLicenceTest.memLogging.Lines.Add(XMLMsg);
End; // AddXMLToLog

//=========================================================================

procedure TfrmLicenceTest.FormCreate(Sender: TObject);
begin
  oIRISLicence := TIRISLicence.Create;
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.btnDecodeCDKeyClick(Sender: TObject);
Var
  I : SmallInt;
begin
  AddToLog ('');
  AddToLog ('Decode CD Key (' + edtCDKey.Text + ')');
  AddToLog ('=========================================');

  lstComponents.Clear;
  lstInitialRestrictions.Clear;
  lstLicenceCodes.Clear;
  lstLicenceRestrictions.Clear;

  oIRISLicence.CDKey := edtCDKey.Text;

  edtCustomerNo.Text := oIRISLicence.CustomerNumber;

  If (oIRISLicence.Components.Count > 0) Then
  Begin
    For I := 0 To (oIRISLicence.Components.Count - 1) Do
    Begin
      With oIRISLicence.Components[I] Do
      Begin
        lstComponents.Items.Add (Format('Component%d: Id=%d, Name=%s', [I, ComponentId, ComponentName]));
      End; // With oIRISLicence.Components[I]
    End; // For I
  End; // If (oIRISLicence.Components.Count > 0)

  If (oIRISLicence.InitialRestrictions.Count > 0) Then
  Begin
    For I := 0 To (oIRISLicence.InitialRestrictions.Count - 1) Do
    Begin
      With oIRISLicence.InitialRestrictions[I] Do
      Begin
        lstInitialRestrictions.Items.Add (Format('Restriction%d: Id=%d, Name=%s', [I, RestrictionId, RestrictionName]));
      End; // With oIRISLicence.InitialRestrictions[I]
    End; // For I
  End; // If (oIRISLicence.InitialRestrictions.Count > 0)
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.btnGetLicCodesClick(Sender: TObject);
var
  ErrString : ANSIString;
begin
  AddToLog ('');
  AddToLog ('Get Licence Codes (' + edtCDKey.Text + ')');
  AddToLog ('============================================');

  oIRISLicence.CDKey := edtCDKey.Text;
  If Not oIRISLicence.GetLicenceCodes(ErrString) Then
    ShowMessage ('Error in GetLicenceCodes - ' + QuotedStr(ErrString));

  LoadLicenceCodes;
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.LoadLicenceCodes;
Var
  I : SmallInt;
begin
  // Load Licence Codes
  lstLicenceCodes.Clear;
  If (oIRISLicence.LicenceCodes.Count > 0) Then
  Begin
    For I := 0 To (oIRISLicence.LicenceCodes.Count - 1) Do
    Begin
      With oIRISLicence.LicenceCodes[I] Do
      Begin
        lstLicenceCodes.Items.Add (Format('LicenceCode%d: %s', [I, LicenceCode]));
      End; // With oIRISLicence.LicenceCodes[I]
    End; // For I
  End; // If (oIRISLicence.LicenceCodes.Count > 0)

  // Load Licence Restrictions
  lstLicenceRestrictions.Clear;
  If (oIRISLicence.LicenceRestrictions.Count > 0) Then
  Begin
    For I := 0 To (oIRISLicence.LicenceRestrictions.Count - 1) Do
    Begin
      With oIRISLicence.LicenceRestrictions[I] Do
      Begin
        lstLicenceRestrictions.Items.Add (Format('LicenceRestriction%d: Id=%d, Desc=%s, ValueId=%d, Value=%s, LicenceCode=%s', [I, RestrictionId, RestrictionDesc, ValueId, Value, ParentLicence.LicenceCode]));
      End; // With oIRISLicence.LicenceRestrictions[I]
    End; // For I
  End; // If (oIRISLicence.LicenceRestrictions.Count > 0)
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.btnAddLicenceKeyClick(Sender: TObject);
Var
  sCode : String;
begin
  sCode := 'KEQWBAWZRTEY5XA';
  If InputQuery('Add Licence Code', 'Enter new Licence Code below (max 25 characters):-', sCode) Then
  Begin
    oIRISLicence.LicenceCodes.Add(sCode);

    LoadLicenceCodes;
  End; // If InputQuery('Add Licence Code', 'Enter new Licence Code', sCode)
end;

//------------------------------

procedure TfrmLicenceTest.btnEditLicenceKeyClick(Sender: TObject);
begin
  //

  LoadLicenceCodes;
end;

//------------------------------

procedure TfrmLicenceTest.btnDeleteLicenceKeyClick(Sender: TObject);
begin
  If (lstLicenceCodes.ItemIndex >= 0) Then
  Begin
    oIRISLicence.LicenceCodes.Delete(lstLicenceCodes.ItemIndex);
    LoadLicenceCodes;
  End; // If (lstLicenceCodes.ItemIndex >= 0)
end;

//------------------------------

procedure TfrmLicenceTest.btnClearAllKeysClick(Sender: TObject);
begin
  oIRISLicence.LicenceCodes.Clear;

  LoadLicenceCodes;
end;

//------------------------------

procedure TfrmLicenceTest.btnValidateLicenceKeyClick(Sender: TObject);
begin
  If (lstLicenceCodes.ItemIndex >= 0) Then
  Begin
    If oIRISLicence.LicenceCodes[lstLicenceCodes.ItemIndex].Validate Then
      ShowMessage ('Computer says Yes')
    Else
      ShowMessage ('Computer says No');
  End; // If (lstLicenceCodes.ItemIndex >= 0)
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.btnEnterLicenceDetailsClick(Sender: TObject);
Var
  frmLicenceDetails : TfrmLicenceDetails;
begin
  frmLicenceDetails := TfrmLicenceDetails.Create(Self);
  Try
    frmLicenceDetails.IRISLicence := oIRISLicence;

    If (frmLicenceDetails.ShowModal = mrOK) Then
    Begin


      LoadLicenceCodes;
    End; // If (frmLicenceDetails.ShowModal = mrOK)
  Finally
    frmLicenceDetails.Free;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmLicenceTest.btnLITEEquivClick(Sender: TObject);
Var
  sInfo : ShortString;
  Count : Smallint;
  Idx : SmallInt;
begin
  sInfo := '[';

  // Country
  Idx := oIRISLicence.LicenceRestrictions.IndexOf('Country Code');
  If (Idx >= 0) Then
    sInfo := sInfo + oIRISLicence.LicenceRestrictions[Idx].Value + ' '
  Else
    sInfo := sInfo + '?? ';

  // Type
  Idx := oIRISLicence.LicenceRestrictions.IndexOf('Customer Or Accountant');
  If (Idx >= 0) Then
    sInfo := sInfo + oIRISLicence.LicenceRestrictions[Idx].Value + ' '
  Else
    sInfo := sInfo + 'UnknownType ';

  // Demo/Live
  sInfo := sInfo + IfThen(oIRISLicence.InitialRestrictions.IndexOf('Demo Or Live') >= 0, 'Demo', 'Live');
  sInfo := sInfo + '] ';

  // Base Package
  If (oIRISLicence.Components.IndexOf('Exchequer LITE SPOP Module') >= 0) Then
    sInfo := sInfo + 'LITE SPOP'
  Else If (oIRISLicence.Components.IndexOf('Exchequer LITE Stock Module') >= 0) Then
    sInfo := sInfo + 'LITE Stock'
  Else If (oIRISLicence.Components.IndexOf('Exchequer LITE Core Module') >= 0) Then
    sInfo := sInfo + 'LITE Core';

  // Multi-Currency
  If (oIRISLicence.Components.IndexOf('Exchequer LITE Multi-Currency Module') >= 0) Then
    sInfo := sInfo + '/Multi-Currency'
  Else
    sInfo := sInfo + '/Single-Currency';

  // User Count
  Count := 1;
  Idx := oIRISLicence.LicenceRestrictions.IndexOf('User Count');
  If (Idx >= 0) Then Count := oIRISLicence.LicenceRestrictions[Idx].ValueAsInt;
  sInfo := sInfo + '-' + IntToStr(Count) + ' User';

  // Company Count
  Count := 1;
  Idx := oIRISLicence.LicenceRestrictions.IndexOf('Client Count');
  If (Idx >= 0) Then Count := oIRISLicence.LicenceRestrictions[Idx].ValueAsInt;
  sInfo := sInfo + '-' + IntToStr(Count) + ' Company';

  // Perverted Squirrel - check for the key
  Idx := oIRISLicence.LicenceRestrictions.IndexOf('Pervasive Key');
  If (Idx >= 0) Then
  Begin
    sInfo := sInfo + ' [' + oIRISLicence.LicenceRestrictions[Idx].Value + ', Ver ';

    Idx := oIRISLicence.LicenceRestrictions.IndexOf('Pervasive Version');
    If (Idx >= 0) Then
      sInfo := sInfo + oIRISLicence.LicenceRestrictions[Idx].Value + ']'
    Else
      sInfo := sInfo + '?]';
  End; // If (Idx >= 0)

  edtLITEVersion.Text := sInfo;
end;

//-------------------------------------------------------------------------

end.

