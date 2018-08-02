unit ConvDirF;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls, FileCtrl, TReg2;

type
  TfrmConvertDir = class(TSetupTemplate)
    btnFindEnt: TButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    procedure FormCreate(Sender: TObject);
    procedure btnFindEntClick(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses CompUtil, FindDlg;

Const
  {$I x:\entrprse\r&d\filepath.inc}


procedure TfrmConvertDir.FormCreate(Sender: TObject);
var
  RegObj    : TEntRegistry;
  LastDir   : String;
begin
  inherited;

  ExitMsg := 3;

  { Create registry access object }
  RegObj := TEntRegistry.Create;
  Try
    RegObj.RootKey := HKEY_LOCAL_MACHINE;

    If RegObj.KeyExists('Software\Exchequer\Enterprise') Then Begin
      If RegObj.OpenKey('Software\Exchequer\Enterprise', False) Then Begin
        { Key opened ok }
        LastDir := Trim(RegObj.ReadString ('LastDir'));

        If DirectoryExists(LastDir) Then
          DirectoryListBox1.Directory := LastDir;
      End; { If }
    End; { If }
  Finally
    RegObj.CloseKey;
    RegObj.Free;
  End;
end;


procedure TfrmConvertDir.btnFindEntClick(Sender: TObject);
var
  frmFindDlg : TfrmFindDlg;
  I          : SmallInt;
  TmpStr     : ShortString;
begin
  inherited;

  If btnFindEnt.Visible Then Begin
    { Setup dialog }
    frmFindDlg := TfrmFindDlg.Create(Self);
    Try
      frmFindDlg.DriveComboBox1.Drive := DriveComboBox1.Drive;
      frmFindDlg.FindMode := 4;
      frmFindDlg.CurrMode := 'S';  { Not Used in FindMode 4 }
      frmFindDlg.PathList := Nil;
      frmFindDlg.Title    := 'Find System Directory';

      frmFindDlg.ShowModal;

      Case frmFindDlg.ExitCode Of
        'N' : Begin
                { A path was selected - setup drive/dir to look at it }
                DirectoryListBox1.Directory := frmFindDlg.lstDirs.Items[frmFindDlg.lstDirs.ItemIndex];
              End;
        'X' : Begin
                ExitCode := 'X';
                Close;
              End;
      End; { If }
    Finally
      frmFindDlg.Free;
    End;
  End; { If }
end;

Function TfrmConvertDir.ValidOk(VCode : Char) : Boolean;
Var
  TmpPath : String;
Begin { ValidOK }
  Result := True;

  If (VCode = 'N') Then Begin
    { Check its a valid drive letter path }
    TmpPath := UpperCase(Trim(DirectoryListBox1.Directory));
    FixPath (TmpPath);

    Result := (TmpPath[1] In ['C'..'Z']) And (TmpPath[2] = ':');
    If (Not Result) Then
      MessageDlg ('The path must be a valid drive and path combination', mtWarning, [mbOk], 0)
    Else Begin
      { Check directory exists - how paranoid can I get (its coming from a directory list box!) }
      Result := DirectoryExists(TmpPath);

      If Result Then Begin
        { Check for data files }
        Result := FileExists (TmpPath + PathSys) And               { ExchQss.Dat }
                  FileExists (TmpPath + Path1 + CustName) And      { Cust\CustSupp.Dat }
                  FileExists (TmpPath + Path4 + StockNam) And      { Stock\Stock.Dat }
                  FileExists (TmpPath + Path2 + DocName) And       { Trans\Document.Dat }
                  FileExists (TmpPath + Path2 + DetailName);       { Trans\Details.Dat }

        If Not Result Then 
          MessageDlg ('This directory does not contain a valid system', mtWarning, [mbOk], 0);
      End; { If Result }
    End; { Else }
  End; { If (VCode = 'N') }
End; { ValidOK }

end.
