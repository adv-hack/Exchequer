unit BrowseF;

interface

{$Warn Unit_Platform Off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, StrUtils, FilCtl95, EntLicence;

type
  TfrmBrowseForLITE = class(TForm)
    DriveComboBox1: TDrive95ComboBox;
    DirectoryListBox1: TDirectory95ListBox;
    btnOK: TButton;
    btnCancel: TButton;
    lblSelectedDir: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
  private
    { Private declarations }
    FMinSizeX, FMinSizeY : LongInt;
    FDirectory : ShortString;
    FExchLicence : TEnterpriseLicence;
    Procedure SetDirectory (Value : ShortString);
    Procedure SetLicence (Value : TEnterpriseLicence);
    // Control the minimum size that the form can resize to - works better than constraints
    Procedure WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property Directory : ShortString Read FDirectory Write SetDirectory;
    Property Licence : TEnterpriseLicence Read FExchLicence Write SetLicence;
  end;


implementation

{$R *.dfm}

Uses Brand, EntLic;

procedure TfrmBrowseForLITE.FormCreate(Sender: TObject);
begin
  FMinSizeX := Width;
  FMinSizeY := Height;

  // Update Branding
  Self.Caption := ANSIReplaceStr(Self.Caption, '<APPTITLE>', Branding.pbProductName);

  Self.Color := (Owner As TFrame).Color;

  FormResize(Sender);
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
Procedure TfrmBrowseForLITE.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  If (FMinSizeX > 0) Then
  Begin
    Message.MinMaxInfo^.ptMinTrackSize.X := FMinSizeX;
    Message.MinMaxInfo^.ptMinTrackSize.Y := FMinSizeY;

    Message.MinMaxInfo^.ptMaxTrackSize.X := FMinSizeX;
    Message.MinMaxInfo^.ptMaxTrackSize.Y := Trunc(Screen.Height * 0.9);

    Message.Result:=0;
  End; // If (FMinSizeX > 0)

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

procedure TfrmBrowseForLITE.FormResize(Sender: TObject);
begin
  DriveComboBox1.Left := 4;
  DriveComboBox1.Top := 4;

  DriveComboBox1.Width := ClientWidth - (2 * DriveComboBox1.Left);
  DirectoryListBox1.Width := DriveComboBox1.Width;

  btnOK.Top := ClientHeight - btnOK.Height - DriveComboBox1.Top;
  btnCancel.Top := btnOK.Top;

  btnOK.Left := (ClientWidth - (2 * btnOK.Width) - DriveComboBox1.Left) Div 2;
  btnCancel.Left := btnOK.Left + btnOK.Width + DriveComboBox1.Left;

  lblSelectedDir.Top := btnOK.Top - 18;
  Label1.Top := lblSelectedDir.Top;


  DirectoryListBox1.Height := lblSelectedDir.Top - DirectoryListBox1.Top - DriveComboBox1.Top;
end;

//-------------------------------------------------------------------------

procedure TfrmBrowseForLITE.SetDirectory(Value : ShortString);
begin
  FDirectory := Value;
  if DirectoryExists(Value) Then
    DirectoryListBox1.Directory := Value;
end;

//------------------------------

Procedure TfrmBrowseForLITE.SetLicence (Value : TEnterpriseLicence);
Begin // SetLicence
  FExchLicence := Value;
End; // SetLicence

//-------------------------------------------------------------------------

procedure TfrmBrowseForLITE.DirectoryListBox1Change(Sender: TObject);
Var
  LITEDir  : ShortString;
  OK       : Boolean;
begin
  OK := False;

  If DirectoryExists(DirectoryListBox1.Directory) Then
  Begin
    LITEDir := IncludeTrailingPathDelimiter(DirectoryListBox1.Directory);

    // Validate selected directory as LITE directory
    If FileExists(LITEDIR + EntLicFName) Then
    Begin
      Try
        // Check it is LITE and not Exchequer - don't want to accidentally downgrade Exchequer
        FExchLicence := EnterpriseLicenceFromDir (LITEDir);
        If (FExchLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
        Begin
          FDirectory := LITEDir;
          OK := True;
        End // If (FExchLicence.elProductType In [ptLITECust, ptLITEAcct])
        Else
          FreeAndNIL(FExchLicence);
      Except
        FreeAndNIL(FExchLicence);
      End; // Try..ExceptTry
    End; // If FileExists(LITEDIR + 'EnterOLE.Exe')
  End; // If DirectoryExists(DirectoryListBox1.Directory)

  btnOK.Enabled := OK;
end;

end.
