unit PCCToEFP;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPDefine, RPBase, RPFiler;

type
  TPageRef = Class(TObject)
    PrevPBreak : LongInt;
    Position   : LongInt;
  End; { TPageRef }

  { Info on print job }
  TJobInfo = Record
    jiFontName  : String[50];
    jiFontSize  : SmallInt;
  End; { TJobInfo }

  TfrmConvertPCC = class(TForm)
    ReportFiler1: TReportFiler;
    procedure ReportFiler1BeforePrint(Sender: TObject);
    procedure ReportFiler1Print(Sender: TObject);
  private
    { Private declarations }
    PrnF        : TFileStream;
  public
    { Public declarations }
    InfoRec     : TJobInfo;
    PagePosList : TList;
  end;

Function ConvertPCCToEFP (Const PCCTextName : ShortString;
                          Const JobInfo     : TJobInfo;
                          Const PageList    : TList;
                          Const DelText     : Boolean;
                          Const PJobTitle   : ShortString) : ShortString;

implementation

{$R *.DFM}


Uses PrntPrev;

Function ConvertPCCToEFP (Const PCCTextName : ShortString;
                          Const JobInfo     : TJobInfo;
                          Const PageList    : TList;
                          Const DelText     : Boolean;
                          Const PJobTitle   : ShortString) : ShortString;
Var
  frmConvertPCC : TfrmConvertPCC;
Begin { ConvertPCCToEFP }
  Result := PCCTextName;

  frmConvertPCC := TfrmConvertPCC.Create(Application);
  Try
    With frmConvertPCC Do Begin
      InfoRec := JobInfo;
      PagePosList := PageList;

      PrnF := TFileStream.Create(PCCTextName, (fmOpenRead Or fmShareDenyNone{Exclusive}));
      Try
        With ReportFiler1 Do Begin
          MarginTop    := TopWaste;
          MarginLeft   := LeftWaste;
          MarginRight  := RightWaste;
          MarginBottom := BottomWaste;
          
          FileName := ChangeFileExt (PCCTextName, '.EDF');
          Title := PJobTitle;

          Execute;

          Result := FileName;
        End; { With ReportFiler1 }
      Finally
        PrnF.Free;
      End;
    End; { With frmConvertPCC }
  Finally
    frmConvertPCC.Free;
  End;

  If DelText Then Begin
    DeletePrintFile (PCCTextName);
  End; { If DelText }
End; { ConvertPCCToEFP }


procedure TfrmConvertPCC.ReportFiler1BeforePrint(Sender: TObject);
begin
  With ReportFiler1 Do Begin
    {
    Orientation := ??;
    }

    { set the margins }
    If (Orientation = poPortrait) Then Begin
      MarginLeft   := LeftWaste;
      MarginRight  := RightWaste;
      MarginTop    := TopWaste;
      MarginBottom := BottomWaste;
    End { If }
    Else Begin
      MarginLeft   := TopWaste;
      MarginRight  := BottomWaste;
      MarginTop    := RightWaste;
      MarginBottom := LeftWaste;
    End; { Else }
  End; { With }
end;

procedure TfrmConvertPCC.ReportFiler1Print(Sender: TObject);
Var
  PageRef    : TPageRef;
  FPos, LPos : LongInt;
  Cont       : Boolean;
  Ch         : Char;
  Line       : ShortString;
  PrnPageNo  : SmallInt;
begin
  With ReportFiler1 Do Begin
    { Setup basic report stuff, etc... }
    FontColor := clBlack;
    FontName := InfoRec.jiFontName;
    FontSize := InfoRec.jiFontSize;
  End; { With ReportFiler1 }

  { Move to start of page 1 }
  FPos := 0;
  PrnF.Position := 0;
  PrnPageNo := 1;

  { Read page character by character }
  Line := '';
  Cont := True;
  While Cont And (FPos < PrnF.Size) Do Begin
    { Calculate last char of page }
    If (PrnPageNo < PagePosList.Count) Then Begin
      PageRef := PagePosList[PrnPageNo];
      LPos := Pred(PageRef.Position);
    End { If }
    Else
      LPos := PrnF.Size;

    { Print the current page }
    While (PrnF.Read (Ch, 1) = 1) And (FPos < LPos) And Cont Do Begin
      Inc (FPos);

      If (Ord(Ch) = 12) Then Begin
        Cont := False;
      End { If }
      Else
        If (Ord(Ch) = 13) Then Begin
          ReportFiler1.PrintLn (Line);
          Line := '';
        End { If }
        Else
          If (Ord(Ch) >= 32) Then Begin
            Line := Line + Ch;
          End; { If }
    End; { While }

    If (PrnPageNo < PagePosList.Count) Then Begin
      { Do page break }
      ReportFiler1.NewPage;

      Inc(PrnPageNo);
    End { If }
    Else
      { Finished last page }
      Cont := False;
  End; { While }
end;

end.
