unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure RunApplication;
    Procedure ReconnectDrive;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses ComObj, ShlObj, APIUtil;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  For I := 0 To ParamCount Do
    Memo1.Lines.Add ('ParamStr( ' + IntToStr(I) + '): ' + ParamStr(I));

  If (ParamStr(1) <> '') Then
  Begin
    // Extract drive/path from 1 command line parameter and check whether it exists
    If (Not DirectoryExists(ExtractFilePath(ParamStr(1)))) Then
    Begin
      // Bugger
      ReconnectDrive;

      If (Not DirectoryExists(ExtractFilePath(ParamStr(1)))) Then
        MessageDlg(ExtractFileName(ParamStr(0)) + ': Unable to see mapped drive, please contact your technical support', mtError, [mbOK], 0)
      Else
        RunApplication;
    End // If (Not DirectoryExists(ExtractFilePath(ParamStr(0))))
    Else
      // AOK - go for it
      RunApplication;
  End // If (ParamStr(1) <> '')
  Else
    MessageDlg(ExtractFileName(ParamStr(0)) + ': Invalid Path, please contact your technical support', mtError, [mbOK], 0);
end;

//-------------------------------------------------------------------------

Procedure TForm1.ReconnectDrive;
Var
  P: PWideChar;
  Flags, NumChars, HR: LongWord;
  NewPIDL: PItemIDList;
  SF: IShellFolder;
  EnumList: IEnumIDList;

  function DesktopShellFolder: IShellFolder;
  begin
    OleCheck(SHGetDesktopFolder(Result));
  end;

Begin // ReconnectDrive
  Flags := 0;

  NumChars := 3;
  P := StringToOleStr(ExtractFileDrive(ParamStr(1)));

  HR := DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags);
  if HR = S_OK then
  Begin
    // Get IShellFolder object
    HR := DesktopShellFolder.BindToObject(NewPIDL, nil, IID_IShellFolder, Pointer(SF));
    if HR = S_OK then
    Begin
      HR := SF.EnumObjects(Application.Handle, (SHCONTF_FOLDERS Or SHCONTF_NONFOLDERS Or SHCONTF_INCLUDEHIDDEN), EnumList);
      if HR = S_OK then
      Begin

      End // if HR = S_OK
      Else
        ShowMessage ('EnumObjects Error ' + IntToStr(HR));
    End // if HR = S_OK
    Else
      ShowMessage ('DesktopShellFolder.BindToObject Error ' + IntToStr(HR));
  End // if HR = S_OK
  Else
    ShowMessage ('DesktopShellFolder.ParseDisplayName Error ' + IntToStr(HR));
End; // ReconnectDrive

//-------------------------------------------------------------------------

Procedure TForm1.RunApplication;
Var
  AppPath : ShortString;
Begin // RunApplication
  // Build path based on the Drive\Dir path passed in as parameter 1 and the name of this .EXE
  AppPath := IncludeTrailingPathDelimiter(ParamStr(1)) + ExtractFileName(ParamStr(0));

  // Modify the name of the .EXE to run the next .EXE in the chain
  AppPath := StringReplace(AppPath, 'V.Exe', 'X.Exe', [rfIgnoreCase, rfReplaceAll]);

  RunApp (AppPath, False);
End; // RunApplication

//=========================================================================

end.
