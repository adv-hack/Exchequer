unit AnalyseF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtBtrieveFile: TEdit;
    btnAnalyse: TButton;
    btnBrowse: TButton;
    memFileDets: TMemo;
    OpenDialog1: TOpenDialog;
    chkIrfanMode: TCheckBox;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnAnalyseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses oBtrieveFile;

//-------------------------------------------------------------------------

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  OpenDialog1.FileName := edtBtrieveFile.Text;
  If OpenDialog1.Execute Then
    edtBtrieveFile.Text := OpenDialog1.FileName;
end;

//-------------------------------------------------------------------------

procedure TForm1.btnAnalyseClick(Sender: TObject);
Var
  oBtrieveFile : TBaseBtrieveFile;
  I : Byte;
  lRes : LongInt;
begin
  If FileExists(edtBtrieveFile.Text) Then
  Begin
    oBtrieveFile := TBaseBtrieveFile.Create;
    Try
      lRes := oBtrieveFile.OpenFile (edtBtrieveFile.Text);
      If (lRes = 0) Then
      Begin

        memFileDets.Clear;
        memFileDets.Lines.Add ('Btrieve File: ' + edtBtrieveFile.Text);

        memFileDets.Lines.Add ('Idx#'#9'Seg#'#9'Pos'#9'Len'#9'ACS'#9'Type'#9'Overlaps');

        If (oBtrieveFile.LoadKeySegs > 0) Then
        Begin
          For I := 0 To (oBtrieveFile.KeySegmentCount - 1) Do
          Begin
            With oBtrieveFile.KeySegments[I] Do
            Begin
              If chkIrfanMode.Checked Then
              Begin
                If isAltColSeq Or (Pos('<',isOverlaps) > 0) Then
                  memFileDets.Lines.Add (Format('%d'#9'%d'#9'%d'#9'%d'#9'%s'#9'%s'#9'%s', [isIndex, isIndexSegment, isPosition, isLength, IfThen(isAltColSeq, 'Y', ''), isDataType, isOverlaps]));
              End // If chkIrfanMode.Checked
              Else
                memFileDets.Lines.Add (Format('%d'#9'%d'#9'%d'#9'%d'#9'%s'#9'%s'#9'%s', [isIndex, isIndexSegment, isPosition, isLength, IfThen(isAltColSeq, 'Y', ''), isDataType, isOverlaps]));
            End; // If (oBtrieveFile.KeySegments[I].KeyLen > 0)
          End; // For I
        End; // If (oBtrieveFile.LoadKeySegs > 0)

        oBtrieveFile.CloseFile;
      End // If (lRes = 0)
      Else
        ShowMessage ('OpenFile: ' + IntToStr(lRes));
    Finally
      oBtrieveFile.Free;
    End; // Try..Finally
  End; // If FileExists(edtBtrieveFile.Text)
end;

//-------------------------------------------------------------------------

end.
