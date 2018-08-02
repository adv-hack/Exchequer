unit EmlDetsF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, TCustom, SpellCheck4Modal;

type
  TEmailDetsObjType = Class (TObject)
    Constructor Create;
  Public
    edType     : Byte;            { Type:- 0=To, 1=CC, 2=BCC }
    edName     : String[50];      { Name }
    edAddress  : String[100];     { Email Address:- Waldo@Bonkers.Com }

    Function ToStr : ShortString;
    Procedure UpdateEmStrings(Var feEmailTo, feEmailCc, feEmailBcc : AnsiString);
  End; { TEmailDetsObjType }


  TfrmEmailDets = class(TForm)
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    edtName: Text8Pt;
    edtAddr: Text8Pt;
    lstTo: TSBSComboBox;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    SpellCheck4Modal1: TSpellCheck4Modal;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameDblClick(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

Function EditEmailDets (Var EmailO : TEmailDetsObjType; Const OwnerForm : TForm) : Boolean;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Uses
  GlobVar,
  VarConst,
  ETStrU,
  BTSupU2,
  BTKeys1U,
  InvListU,
  ThemeFix;

Constructor TEmailDetsObjType.Create;
Begin
  Inherited Create;

  edType     := 0;
  edName     := '';
  edAddress  := '';
End;

Function TEmailDetsObjType.ToStr : ShortString;
Begin { ToStr }
  Case edType Of
    0 : Result := 'To';
    1 : Result := 'CC';
    2 : Result := 'BCC';
  End; { Case }
End; { ToStr }

Procedure TEmailDetsObjType.UpdateEmStrings(Var feEmailTo, feEmailCc, feEmailBcc : AnsiString);
Var
  TmpStr : String;
Begin { UpdateEmStrings }
  { Convert item into string }
  TmpStr := Trim(edName) + ';' + Trim(edAddress) + ';';

  Case edType Of
    0 : feEmailTo := feEmailTo + TmpStr;
    1 : feEmailCc := feEmailCc + TmpStr;
    2 : feEmailBcc := feEmailBcc + TmpStr;
  End; { Case }
End; { UpdateEmStrings }

{----------------------------------------------------------------------------}


Function EditEmailDets (Var EmailO : TEmailDetsObjType; Const OwnerForm : TForm) : Boolean;
Var
  frmEmailDets : TfrmEmailDets;
Begin { EditEmailDets }
  Result := False;

  frmEmailDets := TfrmEmailDets.Create(OwnerForm);
  Try
    With EmailO, frmEmailDets Do Begin
      lstTo.ItemIndex := edType;
      edtName.Text := edName;
      edtAddr.Text := edAddress;

      ShowModal;

      Result := OK;

      If Result Then Begin
        { Copy data out of form }
        edType := lstTo.ItemIndex;
        edName := edtName.Text;
        edAddress := edtAddr.Text;
      End; { If Result }
    End; { With }
  Finally
    frmEmailDets.Free;
  End;
End; { EditEmailDets }


{----------------------------------------------------------------------------}


procedure TfrmEmailDets.FormCreate(Sender: TObject);
begin
  OK := False;

  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);
end;

procedure TfrmEmailDets.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TfrmEmailDets.btnOKClick(Sender: TObject);
begin
  btnOk.SetFocus;

  { Validate - check type is set }
  If (lstTo.ItemIndex >= 0) Then Begin
    { Check name is set }
    If (Trim(edtName.Text) <> '') Then Begin
      { Check Address is set }
      If (Trim(edtAddr.Text) <> '') Then Begin
        OK := True;
        Close;
      End { If }
      Else Begin
        MessageDlg ('The recipients Email Address must be set', mtWarning, [mbOk], 0);
        If edtAddr.Canfocus Then edtAddr.SetFocus;
      End; { Else }
    End { If }
    Else Begin
      MessageDlg ('The recipients Name must be set', mtWarning, [mbOk], 0);
      If edtName.Canfocus Then edtName.SetFocus;
    End; { Else }
  End { If }
  Else Begin
    MessageDlg ('The recipient Type must be set', mtWarning, [mbOk], 0);
    If lstTo.Canfocus Then lstTo.SetFocus;
  End; { Else }
end;

procedure TfrmEmailDets.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TfrmEmailDets.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



procedure TfrmEmailDets.edtNameDblClick(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If {((AltMod) or (FoundCode='')) and} (ActiveControl<>BtnCancel)  {and (ViaSBtn)} then
    Begin
      With Cust do
        If (Text=dbFormatName(CustCode,Company)) then
          FoundCode:=Cust.CustCode;

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,BOn,99));


      If (FoundOk) then
      Begin
        With Cust do
          Text:=dbFormatName(CustCode,Company);

          edtAddr.Text:=Cust.EmailAddr;
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TfrmEmailDets.edtNameExit(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    If (ViaSBtn) then
      edtNameDblClick(Sender);

  end;

end;

end.
