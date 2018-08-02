unit EmailSig;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

                
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bkgroup, TEditVal;

type
  TfrmSignatures = class(TForm)
    Label81: Label8;
    memEmailSig: TMemo;
    memFaxSig: TMemo;
    btnClose: TButton;
    btnEdit: TButton;
    SBSBackGroup1: TSBSBackGroup;
    lstUsers: TComboBox;
    Label82: Label8;
    Label83: Label8;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lstUsersClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FFiles   : Array [1..2] Of String;
    FStrings : TStrings;

    Procedure LoadText (Const Idx : Byte; FName1, FName2 : ShortString; TheMemo : TMemo);
  public
    { Public declarations }
    procedure LoadUserList;
  end;

Procedure MaintainSignatures; StdCall; Export;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, BtrvU2, BtSupU1, EntLicence;

Const
  EditCaption = '&Edit';


  {$I FilePAth.Inc}

{----------------------------------------------------------------------------}

Procedure MaintainSignatures;
Begin { MaintainSignatures }

  With TfrmSignatures.Create(Application.MainForm) Do
    Try
      LoadUserList;

      ShowModal;

    Finally
      Free;
    End;
End; { MaintainSignatures }

{----------------------------------------------------------------------------}

procedure TfrmSignatures.FormCreate(Sender: TObject);
Var
  IncDiff : SmallInt;
begin
  // Initialise all the local variables
  FFiles[1] := '';
  FFiles[2] := '';
  FStrings := TStringList.Create;

  btnEdit.Caption := EditCaption;

  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
  Begin
    // IRIS Accounts Office / LITE
    Caption := 'System Setup - Email Signatures';

    Label83.Visible := False;
    memFaxSig.Visible := False;

    IncDiff := (memFaxSig.Top + memFaxSig.Height) - (memEmailSig.Top + memEmailSig.Height);

    SBSBackGroup1.Height := SBSBackGroup1.Height - IncDiff;
    ClientHeight := ClientHeight - IncDiff;
  End; // If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct])
end;

{--------------------------}

procedure TfrmSignatures.FormDestroy(Sender: TObject);
begin
  FStrings.Destroy;
end;

{--------------------------}

// Load list of users
procedure TfrmSignatures.LoadUserList;
Var
  KeyS, KeyFind : Str255;
  lStatus       : SmallInt;
begin
  // Clear List and add in Company Default
  lstUsers.Clear;
  lstUsers.Items.Add ('Company Default (' + Trim(Syss.UserName) + ')');
  lstUsers.ItemIndex := 0;
  lstUsersClick(Self);

  // Find first user record
  KeyFind := PassUCode + C0;
  KeyS := KeyFind;
  lStatus:=Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);

  While (lStatus = 0) And CheckKey(KeyFind, KeyS, Length(KeyFind), BOn) Do Begin
    // Add code into list
    lstUsers.Items.Add (Password.PassEntryRec.Login);

    lStatus:=Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);
  End; { While }
end;

{--------------------------}

Procedure TfrmSignatures.LoadText (Const Idx : Byte; FName1, FName2 : ShortString; TheMemo : TMemo);
Begin { LoadText }
  FName1 := SetDrive + PathMaster + FName1;

  // Take copy of filename for later save operation
  FFiles[Idx] := FName1;

  If Not FileExists (FName1) Then
    FName1 := SetDrive + PathMaster + FName2;

  If FileExists (FName1) Then Begin
    // Load Text
    TheMemo.Lines.LoadFromFile (FName1);
  End { If FileExists (FName) }
  Else
    TheMemo.Clear;
End; { LoadText }

{--------------------------}

// Load signatures
procedure TfrmSignatures.lstUsersClick(Sender: TObject);
Var
  UCode : String[8];
begin
  If (lstUsers.ItemIndex = 0) Then Begin
    // Load Company Defaults
    LoadText (1, 'COMPANY.TXT', 'COMPANY.TXT', memEmailSig);
    LoadText (2, 'COMPANY.TX2', 'COMPANY.TX2', memFaxSig);
  End { If (lstUsers.ItemIndex = 0) }
  Else Begin
    // Extract User Code from list and load text files
    UCode := Uppercase(Trim(Copy (lstUsers.Text, 1, 8)));
    LoadText (1, UCode + '.TXT', 'COMPANY.TXT', memEmailSig);
    LoadText (2, UCode + '.TX2', 'COMPANY.TX2', memFaxSig);
  End; { Else }

end;

{--------------------------}


procedure TfrmSignatures.btnEditClick(Sender: TObject);
begin
  If (btnEdit.Caption = EditCaption) Then Begin
    // Edit -
    lstUsers.Enabled := False;
    btnClose.Enabled := False;

    btnEdit.Caption := '&Save';
    btnCancel.Visible := True;

    memFaxSig.ReadOnly := False;
    memEmailSig.ReadOnly := False;
  End { If }
  Else Begin
    // Save
    memFaxSig.ReadOnly := True;
    memFaxSig.Lines.SaveToFile (FFiles[2]);

    memEmailSig.ReadOnly := True;
    memEmailSig.Lines.SaveToFile (FFiles[1]);

    btnCancel.Visible := False;
    btnEdit.Caption := EditCaption;

    btnClose.Enabled := True;
    lstUsers.Enabled := True;
  End; { Else }
end;

procedure TfrmSignatures.btnCancelClick(Sender: TObject);
begin
  btnCancel.Visible := False;
  btnEdit.Caption := EditCaption;

  memFaxSig.ReadOnly := True;
  memEmailSig.ReadOnly := True;

  btnClose.Enabled := True;
  lstUsers.Enabled := True;
end;

end.
