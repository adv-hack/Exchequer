unit cdserf;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, SysUtils, Classes, Forms, Controls, StdCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    lblCDSerNo: TLabel;
    Button1: TButton;
    lblCDIssueNo: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses Dialogs, IssueU, SerialU;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
Var
  DirPath    : ShortString;
  I, IssueNo : SmallInt;
begin
  lblCDSerNo.Caption := lblCDSerNo.Caption + GetDriveSerial (ExtractFilePath(Application.ExeName)[1]);

  DirPath := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));

  { Remove trailing backslash }
  Delete (DirPath, Length(DirPath), 1);

  { Remove directory below current directory }
  For I := Length(DirPath) DownTo 1 Do
    If (DirPath[I] = ':') Then Begin
      { Hit root of drive - delete anything after ':' }
      If (I < Length(DirPath)) Then
        Delete (DirPath, I + 1, Length(DirPath));
      Break;
    End { If (DirPath[I] = ':') }
    Else
      If IsPathDelimiter(DirPath, I) Then Begin
        { Got '\' - delete anything after backslash }
        If (I < Length(DirPath)) Then
          Delete (DirPath, I + 1, Length(DirPath));
        Break;
      End; { If IsPathDelimiter(DirPath, I) }

  { Re-instate trailing backslash }
  DirPath := IncludeTrailingBackslash(DirPath);

  { Read the Issue number from Utils32.Dll and display on screen }
  If FileExists(DirPath + UtilsFName) Then
    Try
      IssueNo := ReadIssueNo (DirPath + UtilsFName);
    Except
      On Exception Do
        IssueNo := -2;
    End
  Else
    IssueNo := -1;
  If (IssueNo >= 0) Then
    lblCDIssueNo.Caption := lblCDIssueNo.Caption + Format('%3.3d', [IssueNo])
  Else
    lblCDIssueNo.Caption := lblCDIssueNo.Caption + IntToStr(IssueNo);
end;

end.
