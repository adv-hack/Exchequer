unit prnttest;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPrinter, GlobType, RPFPrint, RPreview,
  RPFiler;

type
  RepTypeType = (None, TestPage, TestLabel, PrnForm, PrnLabel, PrevForm, PrevLabel);

  TForm_PrintTest = class(TForm)
    ReportPrinter1: TReportPrinter;
    FilePreview1: TFilePreview;
    ScrollBox1: TScrollBox;
    ReportFiler1: TReportFiler;
    procedure TestSize_Print(Sender: TObject);
    procedure TestSize_BeforePrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RegisterRec : FormRegisterType;
    HeaderRec   : fdHeaderRecType;
    ReportType  : RepTypeType;

    Procedure InitReporting (Const RegRec    : FormRegisterType;
                             Const HedRec    : fdHeaderRecType;
                             Const RepType   : RepTypeType);
    Procedure PrintReport;
  end;

var
  Form_PrintTest: TForm_PrintTest;

Procedure PrintPageBorders (Const RegRec : FormRegisterType;
                            Const HedRec : fdHeaderRecType);


implementation

{$R *.DFM}

procedure TForm_PrintTest.FormCreate(Sender: TObject);
begin
  ReportType :=  None;
end;

procedure TForm_PrintTest.TestSize_BeforePrint(Sender: TObject);
begin
  With Sender as TBaseReport, HeaderRec Do
    If (fhOrientation = fdoPortrait) Then
      Orientation := poPortrait
    Else
      { Landscape }
      Orientation := poLandscape;
end;

procedure TForm_PrintTest.TestSize_Print(Sender: TObject);
Var
  pTop, pLeft, pRight, pBottom : LongInt;
begin
  With Sender as TBaseReport, HeaderRec Do Begin
    If (fhOrientation = fdoPortrait) Then Begin
      pTop    := fhTopWaste;
      pLeft   := fhLeftWaste;
      pBottom := fhPaperHeight - fhBottomWaste;
      pRight  := fhPaperWidth - fhRightWaste;
    End { If }
    Else Begin
      { Landscape }
      ShowMessage ('Landscape');
      pTop    := fhLeftWaste;
      pLeft   := fhPaperHeight - fhBottomWaste;
      pBottom := fhPaperWidth - fhRightWaste;
      pRight  := fhTopWaste;
    End; { If }

    SetPen (clBlack, psSolid, -1, pmCopy);

    MoveTo (pLeft,  pTop);
    LineTo (pRight, pTop);
    LineTo (pRight, pBottom);
    LineTo (pLeft,  pBottom);
    LineTo (pLeft,  pTop);

    SetFont ('Arial', 12);
    YPos := PageHeight * 0.4;
    PrintCenter ('Test Page Size', PageWidth / 2);

    SetFont ('Arial', 12);
    YPos := PageHeight * 0.5;
    PrintCenter ('A complete border should be', PageWidth / 2);
    YPos := PageHeight * 0.55;
    PrintCenter ('visible on this page', PageWidth / 2);
  End; { With }
end;

Procedure TForm_PrintTest.InitReporting (Const RegRec    : FormRegisterType;
                                         Const HedRec    : fdHeaderRecType;
                                         Const RepType   : RepTypeType);
begin
  RegisterRec := RegRec;
  HeaderRec   := HedRec;
  ReportType  := RepType;

  Case RepType Of
    TestPage  : With ReportPrinter1 Do Begin
                  OnPrintPage   := nil;
                  OnPrint       := TestSize_Print;
                  OnBeforePrint := TestSize_BeforePrint;
                  OnAfterPrint  := nil;
                  OnPrintHeader := nil;
                  OnPrintFooter := nil;
                  OnNewPage     := nil;
                  OnNewColumn   := nil;
                End;
    {TestLabel : ;}
    {PrnForm   : ;}
    {PrnLabel  : ;}
    {PrevForm  : ;}
    {PrevLabel : ;}
  Else
    OnPrintPage   := nil;
    OnPrint       := nil;
    OnBeforePrint := nil;
    OnAfterPrint  := nil;
    OnPrintHeader := nil;
    OnPrintFooter := nil;
    OnNewPage     := nil;
    OnNewColumn   := nil;
  End; { Case }
end;

Procedure TForm_PrintTest.PrintReport;
begin
  ReportPrinter1.Execute;
End;

{ Prints the borders of a page }
Procedure PrintPageBorders (Const RegRec    : FormRegisterType;
                            Const HedRec    : fdHeaderRecType);
begin
  Form_PrintTest := TForm_PrintTest.Create (Application);

  Form_PrintTest.InitReporting  (RegRec, HedRec, PrevForm);
  Form_PrintTest.PrintReport;

  Form_PrintTest.Release;
end;

end.
