unit IssueF;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses IssueU;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  DummyFile, UtilsFile   : ANSIString;
  Err, hFile, Issue, Res, Attr : LongInt;
  FileTime               : TDateTime;
  OK                     : Boolean;
begin
  { Validate Issue Number }
  OK := (Trim(MaskEdit1.Text) <> '');
  If OK Then Begin
    Val (Trim(MaskEdit1.Text), Issue, Err);
    OK := (Err = 0) And (Issue > 0) And (Issue <= 999);
  End; { If OK }

  If OK Then Begin
    DummyFile := ExtractFilePath (Application.ExeName) + 'DummyDll.Dll';
    UtilsFile := ExtractFilePath (Application.ExeName) + 'Utils32.Dll';

    { Delete any pre-existing Utils32.DLL }
    If FileExists (UtilsFile) Then SysUtils.DeleteFile (UtilsFile);

    { Copy DUMMYDLL.DLL to UTILS32.DLL overwriting any pre-existing DLL just in-case the delete failed }
    CopyFile (PCHAR(DummyFile), PCHAR(UtilsFile), False);

    // MH 22/06/2012 v7.0: Modified to remove Read-Only attribute caused by TFS
    If FileExists (UtilsFile) Then
    Begin
      Attr := FileGetAttr(UtilsFile);
      If ((Attr And faReadOnly) = faReadOnly) Then
      Begin
        FileSetAttr(UtilsFile, Attr - faReadOnly);
      End; // If ((Attr And faReadOnly) = faReadOnly)
    End; // If FileExists (UtilsFile)

    If FileExists (UtilsFile) Then Begin
      { Writes the Issue Number details to the specified file }
      WriteIssueNo (UtilsFile, Issue);

      { Reset Date/Time of UTILS32.DLL }
      hFile := FileOpen(UtilsFile, fmOpenReadWrite Or fmShareExclusive);
      If (hFile >= 0) Then Begin
        FileTime := EncodeTime(5, 0, 0, 0);
        ReplaceDate (FileTime, EncodeDate(2001, 5, 21));
        Res := FileSetDate(hFile, DateTimeToFileDate(FileTime));
        If (Res <> 0) Then ShowMessage ('Error ' + IntToStr(Res) + ' in FileSetDate');

        FileClose (hFile);
      End { If (FileOpen(... }
      Else
        ShowMessage ('Error ' + IntToStr(hFile) + ' in FileOpen(' + UtilsFile + ')');

      { Re-Reads the Issue Number from the DLL }
      ShowMessage ('Issue Number ' + Format('%3.3d',[ReadIssueNo (UtilsFile)]) + ' set');
    End { If }
    Else
      ShowMessage (UtilsFile + ' not found');
  End { If OK }
  Else
    ShowMessage ('The Issue Number must be set to a whole number between 1 and 999');
end;

end.
