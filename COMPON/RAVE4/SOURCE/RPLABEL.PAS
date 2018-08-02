{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPLabel;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPSect, RPShell;

type
  TLabelShell = class;

  TLabelShape = (lsRoundRect,lsRect,lsRound);

  TLabelEvent = procedure(ReportPrinter: TBaseReport;
                          LabelShell: TLabelShell) of object;

  TLabelValidEvent = procedure(    ReportPrinter: TBaseReport;
                                   LabelShell: TLabelShell;
                               var Valid: boolean) of object;

{*************************************************************************}
{                             class TLabelShell                           }
{*************************************************************************}

  TLabelBrand = (lbAV5167,lbAV5267,lbAV5927,lbAV5160,lbAV5260,lbAV5920,lbAV5161,
   lbAV5261,lbAV5162,lbAV5262,lbAV5922,lbAV5163,lbAV5263,lbAV5923,lbAV5963,
   lbAV5164,lbAV5264,lbAV5667,lbAV5660,lbAV5930,lbAV5661,lbAV5662,lbAV5932,
   lbAV5663,lbAV5664,lbAV5165,lbAV5265,lbAV5266,lbAV5066,lbAV5766,lbAV5866,
   lbAV5966,lbAV5366,lbAV5293,lbAV5294,lbAV5295,lbAV5196,lbAV5096,lbAV5896,
   lbAV5197,lbAV5097,lbAV5897,lbAV5198,lbAV5199FACE,lbAV5199SPINE,lbAV5395,
   lbAV5095,lbAV5895BADGE,lbAV5895SPINE,lbAV5371,lbAV5376,lbAV5377,lbAV5372,
   lbAV5911,lbAV5383,lbAV5390,lbAV5883,lbAV5384,lbAV5392,lbAV5385,lbAV5386,
   lbAV5388,lbAV5389,lbAV12_294,lbAV12_295,lbAV12_296,lbAV12_297,lbAV5305,
   lbAV5309,lbAV5315,lbAV5361,lbAV5362,lbAV5361SINGLE,lbAV5362SINGLE,lbAV5364,
   lbAV5364S,lbAV8160,lbAV8460,lbAV8920,lbAV8161,lbAV8162,lbAV8462,lbAV8922,
   lbAV8163,lbAV8463,lbAV8923,lbAV8164,lbAV8165,lbAV8166,lbAV8167,lbAV8927,
   lbAV8196,lbAV8315,lbAV8316PORTRAIT,lbAV8316LANDSCAPE,lbAV8371,lbAV8376,
   lbAV8377,lbAV8372,lbAV8660,lbAV8930,lbAV8662,lbAV8932,lbAV8663,lbAV6460,
   lbAV6464,lbAV6466,lbAV6490,lbAV2160,lbAV2162,lbAV2163,lbAV2660,lbAV2662,
   lbAV2663,lbAV2180,lbAV2181,lbAV2186,lbAV5824,lbAV5836LABEL,lbAV5836TAB,
   lbAV5837LABEL,lbAV5837TAB,lbAV5838LABEL,lbAV5838TAB,lbAV5848LABEL,
   lbAV5848TAB,lbAV5849LABEL,lbAV5849TAB,lbAV5855LABEL,lbAV5855TAB,lbAV5839,
   lbAV5840,lbAV5841,lbAV5842,lbAV5843,lbAV5844,lbAV5845,lbCustom);

  TLabelShell = class(TBaseShell)
  protected
    FNumAcross: integer;
    FNumDown: integer;
    FLabelWidth: double;
    FLabelHeight: double;
    FSpacingLeft: double;
    FSpacingTop: double;
    FSpacingWidth: double;
    FSpacingHeight: double;
    FDrawExtents: boolean;
    FDrawPen: TPen;
    FDrawPreviewOnly: boolean;
    FPrintByRow: boolean;
    FLabelBrand: TLabelBrand;
    FBorder: double;
    FLabelShape: TLabelShape;

    FRow: integer;
    FCol: integer;
    FStartRow: integer;
    FStartCol: integer;
    FSkipNum: integer;

  { Event properties }
    FOnReportBefore: TLabelEvent;
    FOnPageBefore: TLabelEvent;
    FOnLabelBefore: TLabelValidEvent;
    FOnLabelPrint: TLabelValidEvent;
    FOnLabelAfter: TLabelValidEvent;
    FOnPageAfter: TLabelEvent;
    FOnReportAfter: TLabelEvent;

    procedure ReportBeforeEvent; virtual;
    procedure PageBeforeEvent; virtual;
    procedure LabelBeforeEvent(var Valid: boolean); virtual;
    procedure LabelPrintEvent(var Valid: boolean); virtual;
    procedure LabelAfterEvent(var Valid: boolean); virtual;
    procedure PageAfterEvent; virtual;
    procedure ReportAfterEvent; virtual;

    procedure SetDrawPen(Value: TPen);
    procedure SetLabelBrand(Value: TLabelBrand);
    procedure SetLabelDims(MT,ML,SH,SW,LH,LW: double;
                           LA,LD: integer);
    procedure SetNumAcross(Value: integer);
    procedure SetNumDown(Value: integer);
    procedure SetLabelWidth(Value: double);
    procedure SetLabelHeight(Value: double);
    procedure SetSpacingLeft(Value: double);
    procedure SetSpacingTop(Value: double);
    procedure SetSpacingWidth(Value: double);
    procedure SetSpacingHeight(Value: double);
    procedure SetLabelShape(Value: TLabelShape);
    procedure BeginPage(Sender: TObject);
    procedure EndPage(Sender: TObject);

    function PrintLabel(Row: integer;
                        Col: integer): boolean;
    procedure PrintReport;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(Report: TBaseReport); override;

    property Row: integer read FRow;
    property Col: integer read FCol;
    property StartRow: integer read FStartRow write FStartRow;
    property StartCol: integer read FStartCol write FStartCol;
    property SkipNum: integer read FSkipNum write FSkipNum;
  published
    property NumAcross: integer read FNumAcross write SetNumAcross default 3;
    property NumDown: integer read FNumDown write SetNumDown default 10;
    property LabelWidth: double read FLabelWidth write SetLabelWidth;
    property LabelHeight: double read FLabelHeight write SetLabelHeight;
    property SpacingLeft: double read FSpacingLeft write SetSpacingLeft;
    property SpacingTop: double read FSpacingTop write SetSpacingTop;
    property SpacingWidth: double read FSpacingWidth write SetSpacingWidth;
    property SpacingHeight: double read FSpacingHeight write SetSpacingHeight;
    property DrawExtents: boolean read FDrawExtents write FDrawExtents
     default false;
    property DrawPen: TPen read FDrawPen write SetDrawPen;
    property DrawPreviewOnly: boolean read FDrawPreviewOnly write FDrawPreviewOnly
     default true;
    property PrintByRow: boolean read FPrintByRow write FPrintByRow
     default true;
    property LabelBrand: TLabelBrand read FLabelBrand write SetLabelBrand
     default lbCustom;
    property Border: double read FBorder write FBorder;
    property LabelShape: TLabelShape read FLabelShape write SetLabelShape
     default lsRoundRect;

    property OnReportBefore: TLabelEvent read FOnReportBefore write FOnReportBefore;
    property OnPageBefore: TLabelEvent read FOnPageBefore write FOnPageBefore;
    property OnLabelBefore: TLabelValidEvent read FOnLabelBefore write FOnLabelBefore;
    property OnLabelPrint: TLabelValidEvent read FOnLabelPrint write FOnLabelPrint;
    property OnLabelAfter: TLabelValidEvent read FOnLabelAfter write FOnLabelAfter;
    property OnPageAfter: TLabelEvent read FOnPageAfter write FOnPageAfter;
    property OnReportAfter: TLabelEvent read FOnReportAfter write FOnReportAfter;
  end; { TLabelShell }

implementation

{*************************************************************************}
{                             class TLabelShell                           }
{*************************************************************************}

  constructor TLabelShell.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    FDrawPen := TPen.Create;
    FPrintByRow := true;
    LabelBrand := lbAV5160;
    FDrawPreviewOnly := true;
  end;  { Create }

  destructor TLabelShell.Destroy;

  begin { Destroy }
    FDrawPen.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TLabelShell.ReportBeforeEvent;

  begin { ReportBeforeEvent }
    If Assigned(FOnReportBefore) then begin
      FOnReportBefore(ReportPrinter,self);
    end; { if }
  end;  { ReportBeforeEvent }

  procedure TLabelShell.PageBeforeEvent;

  begin { PageBeforeEvent }
    If Assigned(FOnPageBefore) then begin
      FOnPageBefore(ReportPrinter,self);
    end; { if }
  end;  { PageBeforeEvent }

  procedure TLabelShell.LabelBeforeEvent(var Valid: boolean);

  begin { LabelBeforeEvent }
    If Assigned(FOnLabelBefore) then begin
      FOnLabelBefore(ReportPrinter,self,Valid);
    end; { if }
  end;  { LabelBeforeEvent }

  procedure TLabelShell.LabelPrintEvent(var Valid: boolean);

  begin { LabelPrintEvent }
    If Assigned(FOnLabelPrint) then begin
      FOnLabelPrint(ReportPrinter,self,Valid);
    end; { if }
  end;  { LabelPrintEvent }

  procedure TLabelShell.LabelAfterEvent(var Valid: boolean);

  begin { LabelAfterEvent }
    If Assigned(FOnLabelAfter) then begin
      FOnLabelAfter(ReportPrinter,self,Valid);
    end; { if }
  end;  { LabelAfterEvent }

  procedure TLabelShell.PageAfterEvent;

  begin { PageAfterEvent }
    If Assigned(FOnPageAfter) then begin
      FOnPageAfter(ReportPrinter,self);
    end; { if }
  end;  { PageAfterEvent }

  procedure TLabelShell.ReportAfterEvent;

  begin { ReportAfterEvent }
    If Assigned(FOnReportAfter) then begin
      FOnReportAfter(ReportPrinter,self);
    end; { if }
  end;  { ReportAfterEvent }

  procedure TLabelShell.SetDrawPen(Value: TPen);

  begin { SetDrawPen }
    DrawPen.Assign(Value);
  end;  { SetDrawPen }

  procedure TLabelShell.SetLabelDims(MT,ML,SH,SW,LH,LW: double;
                                     LA,LD: integer);

  begin { SetLabelDims }
    NumAcross := LA;
    NumDown := LD;
    LabelWidth := LW;
    LabelHeight := LH;
    SpacingTop := MT;
    SpacingLeft := ML;
    SpacingWidth := SW;
    SpacingHeight := SH;
  end;  { SetLabelDims }

  procedure TLabelShell.SetLabelBrand(Value: TLabelBrand);

  begin { SetLabelBrand }
    FLabelShape := lsRoundRect;
    Case Value of
      lbAV5167,lbAV5267,lbAV5927: begin
        SetLabelDims(0.5,0.281,0.5,2.063,0.5,1.75,4,20);
      end;
      lbAV5160,lbAV5260,lbAV5920: begin
        SetLabelDims(0.5,0.188,1.0,2.75,1.0,2.625,3,10);
      end;
      lbAV5161,lbAV5261: begin
        SetLabelDims(0.5,0.156,1.0,4.188,1.0,4.0,2,10);
      end;
      lbAV5162,lbAV5262,lbAV5922: begin
        SetLabelDims(0.833,0.156,1.333,4.188,1.333,4.0,2,7);
      end;
      lbAV5163,lbAV5263,lbAV5923,lbAV5963: begin
        SetLabelDims(0.5,0.156,2.0,4.188,2.0,4.0,2,5);
      end;
      lbAV5164,lbAV5264: begin
        SetLabelDims(0.5,0.156,3.333,4.188,3.333,4.0,2,3);
      end;
      lbAV5667: SetLabelDims(0.5,0.3,0.5,2.06,0.5,1.75,4,20);
      lbAV5660,lbAV5930: begin
        SetLabelDims(0.5,0.0,1.0,2.833,1.0,2.833,3,10);
      end;
      lbAV5661: SetLabelDims(0.5,0.0,1.0,4.25,1.0,4.25,2,10);
      lbAV5662,lbAV5932: begin
        SetLabelDims(0.835,0.0,1.333,4.25,1.333,4.25,2,7);
      end;
      lbAV5663: SetLabelDims(0.5,0.0,2.0,4.25,2.0,4.25,2,5);
      lbAV5664: SetLabelDims(0.5,0.0,3.333,4.25,3.333,4.25,2,3);
      lbAV5165,lbAV5265: begin
        SetLabelDims(0.0,0.0,11.0,8.5,11.0,8.5,1,1);
      end;
      lbAV5266,lbAV5066,lbAV5766,lbAV5866,lbAV5966: begin
        SetLabelDims(0.5,0.531,0.675,4.0,0.541,3.438,2,15);
      end;
      lbAV5366: SetLabelDims(0.5,0.531,0.666,4.0,0.666,3.438,2,15);
      lbAV5293: begin
        SetLabelDims(0.5,0.438,1.667,2.0,1.625,1.625,4,6);
        FLabelShape := lsRound;
      end;
      lbAV5294: begin
        SetLabelDims(0.5,0.25,2.5,2.75,2.5,2.5,3,4);
        FLabelShape := lsRound;
      end;
      lbAV5295: begin
        SetLabelDims(0.5,0.625,3.333,3.937,3.333,3.333,2,3);
        FLabelShape := lsRound;
      end;
      lbAV5196: SetLabelDims(0.5,0.125,3.0,2.75,2.75,2.75,3,3);
      lbAV5096,lbAV5896: begin
        SetLabelDims(1.5,0.125,3.0,2.75,1.75,2.75,3,3);
      end;
      lbAV5197: SetLabelDims(1.0,0.156,1.5,4.188,1.5,4.0,2,6);
      lbAV5097,lbAV5897: begin
        SetLabelDims(1.25,0.156,1.5,4.188,1.25,4.0,2,6);
      end;
      lbAV5198: SetLabelDims(0.5,0.5,1.667,4.0,1.667,3.5,2,6);
      lbAV5199FACE: SetLabelDims(0.917,1.069,1.833,3.3,1.833,3.063,2,5);
      lbAV5199SPINE: SetLabelDims(0.5,1.344,0.667,5.813,0.667,5.813,1,15);
      lbAV5395: SetLabelDims(0.583,0.688,2.5,3.75,2.333,3.375,2,4);
      lbAV5095,lbAV5895BADGE: begin
        SetLabelDims(0.813,0.875,2.5,3.75,2.02,3.063,2,4);
      end;
      lbAV5895SPINE: SetLabelDims(0.75,0.25,0.5,3.75,0.5,3.75,1,17);
      lbAV5371,lbAV5376,lbAV5377,lbAV5372,lbAV5911: begin
        SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      end;
      lbAV5383,lbAV5390: begin
        SetLabelDims(1.167,0.75,2.167,3.5,2.167,3.5,2,4);
      end;
      lbAV5883: SetLabelDims(1.438,1.0,2.188,3.5,1.688,3.0,2,4);
      lbAV5384,lbAV5392: begin
        SetLabelDims(1.0,0.25,3.0,4.0,3.0,4.0,2,3);
      end;
      lbAV5385: SetLabelDims(1.167,0.25,2.167,4.0,2.167,4.0,2,4);
      lbAV5386: SetLabelDims(1.0,1.75,3.0,5.0,3.0,5.0,1,3);
      lbAV5388: SetLabelDims(1.0,1.75,3.0,5.0,3.0,5.0,1,3);
      lbAV5389: SetLabelDims(1.5,1.25,4.0,6.0,4.0,6.0,1,2);
      lbAV12_294,lbAV12_295: begin
        SetLabelDims(0.5,1.0,2.5,4.125,2.5,3.375,2,4);
      end;
      lbAV12_296,lbAV12_297: begin
        SetLabelDims(1.0,1.675,3.0,5.375,3.0,5.375,1,3);
      end;
      lbAV5305: SetLabelDims(0.875,0.375,5.0,8.5,4.25,7.75,1,2);
      lbAV5309: SetLabelDims(1.125,0.375,5.0,8.5,4.25,7.75,1,2);
      lbAV5315: SetLabelDims(0.0,0.0,0.0,5.5,8.5,5.5,2,1);
      lbAV5361,lbAV5362:  begin
        SetLabelDims(0.833,4.321,3.666,3.25,2.0,3.25,1,3);
      end;
      lbAV5361SINGLE,lbAV5362SINGLE:  begin
        SetLabelDims(0.833,4.321,2.0,3.25,2.0,3.25,1,1);
      end;
      lbAV5364: SetLabelDims(0.813,4.321,3.666,3.875,2.063,3.875,1,3);
      lbAV5364S: SetLabelDims(0.813,4.321,3.666,2.063,2.063,3.875,1,1);
      lbAV8160,lbAV8460,lbAV8920: begin
        SetLabelDims(0.5,0.188,1.0,2.75,1.0,2.625,3,10);
      end;
      lbAV8161: SetLabelDims(0.5,0.156,1.0,4.188,1.0,4.0,2,10);
      lbAV8162,lbAV8462,lbAV8922: begin
        SetLabelDims(0.833,0.156,1.333,4.188,1.333,4.0,2,7);
      end;
      lbAV8163,lbAV8463,lbAV8923: begin
        SetLabelDims(0.5,0.156,2.0,4.188,2.0,4.0,2,5);
      end;
      lbAV8164: SetLabelDims(0.5,0.156,3.333,4.188,3.333,4.0,2,3);
      lbAV8165: SetLabelDims(0.0,0.0,11.0,8.5,11.0,8.5,1,1);
      lbAV8166: SetLabelDims(0.5,0.531,0.675,4.0,0.541,3.438,2,15);
      lbAV8167,lbAV8927: begin
        SetLabelDims(0.5,0.281,0.5,2.063,0.5,1.75,4,20);
      end;
      lbAV8196: SetLabelDims(0.5,0.125,3.0,2.75,2.75,2.75,3,3);
      lbAV8315: SetLabelDims(0.0,0.0,0.0,5.5,8.5,5.5,2,1);
      lbAV8316PORTRAIT: SetLabelDims(0.0,0.0,5.5,8.5,5.5,8.5,1,2);
      lbAV8316LANDSCAPE: SetLabelDims(0.0,0.0,8.5,5.5,8.5,5.5,2,1);
      lbAV8371,lbAV8376,lbAV8377,lbAV8372: begin
        SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      end;
      lbAV8660,lbAV8930:  begin
        SetLabelDims(0.5,0.188,1.0,2.75,1.0,2.625,3,10);
      end;
      lbAV8662,lbAV8932:  begin
        SetLabelDims(0.833,0.156,1.333,4.188,1.333,4.0,2,7);
      end;
      lbAV8663: SetLabelDims(0.5,0.156,2.0,4.188,2.0,4.0,2,5);
      lbAV6460: SetLabelDims(0.5,0.188,1.0,2.75,1.0,2.625,3,10);
      lbAV6464: SetLabelDims(0.5,0.156,3.333,4.188,3.333,4.0,2,3);
      lbAV6466: SetLabelDims(0.5,0.531,0.667,4.0,0.667,3.438,2,15);
      lbAV6490: SetLabelDims(0.5,0.125,2.0,2.782,2.0,2.688,3,5);
      lbAV2160:SetLabelDims(0.5,0.810,1.0,2.63,1.0,2.63,1,8);
      lbAV2162:SetLabelDims(0.5,0.12,1.33,4.0,1.33,4.0,1,6);
      lbAV2163:SetLabelDims(0.5,0.12,2.0,4.0,2.0,4.0,1,4);
      lbAV2660:SetLabelDims(0.5,0.81,1.0,2.63,1.0,2.63,1,8);
      lbAV2662:SetLabelDims(0.5,0.0,1.33,4.25,1.33,4.25,1,6);
      lbAV2663:SetLabelDims(0.5,0.0,2.0,4.25,2.0,4.25,1,4);
      lbAV2180:SetLabelDims(0.5,0.405,0.675,3.44,0.541,3.44,1,12);
      lbAV2181:SetLabelDims(0.5,0.405,0.675,3.44,0.666,3.44,1,12);
      lbAV2186:SetLabelDims(0.5,0.75,2.0,2.75,2.0,2.75,1,4);
      lbAV5824:SetLabelDims(0.5,2.0,5.5,4.5,4.5,4.5,1,2);
      lbAV5836LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5836TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5837LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5837TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5838LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5838TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5848LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5848TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5849LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5849TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5855LABEL:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5855TAB:SetLabelDims(0.5,0.3,0.5,2.05,0.5,1.75,4,20);
      lbAV5839:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5840:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5841:SetLabelDims(0.5,0.75,2.0,3.5,2.0,3.5,2,5);
      lbAV5842:SetLabelDims(1.167,0.75,2.167,3.5,2.167,3.5,2,4);
      lbAV5843:SetLabelDims(0.875,0.375,5.0,8.5,4.25,7.75,1,2);
      lbAV5844:SetLabelDims(0.5,0.0,1.0,2.833,1.0,2.833,3,10);
      lbAV5845:SetLabelDims(0.0,0.0,0.0,5.5,8.5,5.5,2,1);
      lbCustom: begin end; { Don't do anything }
    end; { case }
    FLabelBrand := Value;
  end;  { SetLabelBrand }

  procedure TLabelShell.SetNumAcross(Value: integer);

  begin { SetNumAcross }
    FNumAcross := Value;
    FLabelBrand := lbCustom;
  end;  { SetNumAcross }

  procedure TLabelShell.SetNumDown(Value: integer);

  begin { SetNumDown }
    FNumDown := Value;
    FLabelBrand := lbCustom;
  end;  { SetNumDown }

  procedure TLabelShell.SetLabelWidth(Value: double);

  begin { SetLabelWidth }
    If Value <> 0.0 then begin
      FLabelWidth := Value;
      FLabelBrand := lbCustom;
    end; { if }
  end;  { SetLabelWidth }

  procedure TLabelShell.SetLabelHeight(Value: double);

  begin { SetLabelHeight }
    If Value <> 0.0 then begin
      FLabelHeight := Value;
      FLabelBrand := lbCustom;
    end; { if }
  end;  { SetLabelHeight }

  procedure TLabelShell.SetSpacingLeft(Value: double);

  begin { SetSpacingLeft }
    If Value = 0.0 then begin
      Value := 0.0001;
    end; { if }
    FSpacingLeft := Value;
    FLabelBrand := lbCustom;
  end;  { SetSpacingLeft }

  procedure TLabelShell.SetSpacingTop(Value: double);

  begin { SetSpacingTop }
    If Value = 0.0 then begin
      Value := 0.0001;
    end; { if }
    FSpacingTop := Value;
    FLabelBrand := lbCustom;
  end;  { SetSpacingTop }

  procedure TLabelShell.SetSpacingWidth(Value: double);

  begin { SetSpacingWidth }
    If Value = 0.0 then begin
      Value := 0.0001;
    end; { if }
    FSpacingWidth := Value;
    FLabelBrand := lbCustom;
  end;  { SetSpacingWidth }

  procedure TLabelShell.SetSpacingHeight(Value: double);

  begin { SetSpacingHeight }
    If Value = 0.0 then begin
      Value := 0.0001;
    end; { if }
    FSpacingHeight := Value;
    FLabelBrand := lbCustom;
  end;  { SetSpacingHeight }

  procedure TLabelShell.SetLabelShape(Value: TLabelShape);

  begin { SetLabelShape }
    FLabelShape := Value;
  end;  { SetLabelShape }

  procedure TLabelShell.BeginPage(Sender: TObject);

  begin { BeginPage }
    ReportPrinter := Sender as TBaseReport;
    PageBeforeEvent;
  end;  { BeginPage }

  procedure TLabelShell.EndPage(Sender: TObject);

  begin { EndPage }
    ReportPrinter := Sender as TBaseReport;
    PageAfterEvent;
  end;  { EndPage }

  function TLabelShell.PrintLabel(Row: integer;
                                  Col: integer): boolean;

  var
    Printed: boolean;

  begin { PrintLabel }
    FRow := Row;
    FCol := Col;
    Result := true;
    Printed := false;
    If (StartRow = Row) and (StartCol = Col) then begin
      StartRow := 0;
      StartCol := 0;
    end; { if }
    If (SkipNum > 0) or ((StartRow > 0) and (StartCol > 0)) then begin
      If SkipNum > 0 then begin
        SkipNum := SkipNum - 1;
      end; { if }
      Exit;
    end; { if }
    Repeat
      LabelBeforeEvent(Result);
      try
      { Setup Section and Origins for current label }
        If Result then begin
          Printed := true;
          With ReportPrinter do begin
            OriginX := XI2U((Col - 1) * SpacingWidth + SpacingLeft);
            OriginY := YI2U((Row - 1) * SpacingHeight + SpacingTop);
            SectionLeft := XI2U(Border);
            SectionRight := XI2U(LabelWidth - Border);
            SectionTop := YI2U(Border);
            SectionBottom := YI2U(LabelHeight - Border);
            Home;
          end; { with }
          LabelPrintEvent(Result);
        end; { if }
      finally
        LabelAfterEvent(Result);
      end; { tryf }
    until not Result or Printed;
  end;  { PrintLabel }

  procedure TLabelShell.PrintReport;

  var
    EndReport: boolean;
    SavePen: TPen;
    SaveBrush: TBrush;
    I1: integer;
    I2: integer;

  begin { PrintReport }
    If StartRow > NumDown then begin
      StartRow := NumDown;
    end; { if }
    If StartCol > NumAcross then begin
      StartCol := NumAcross;
    end; { if }

  { Add the page event handlers }
    ReportPrinter.AddReportEvent(reBeginPage,BeginPage);
    ReportPrinter.AddReportEvent(reEndPage,EndPage);
    SavePen := TPen.Create;
    SaveBrush := TBrush.Create;
    try
      ReportBeforeEvent;
      try
      { Call BeginPage for first page }
        BeginPage(ReportPrinter);

      { Print each label until no more }
        EndReport := false;
        While not EndReport do begin
          If DrawExtents then begin { Draw label extents for preview }
            With ReportPrinter do begin
              If DrawPreviewOnly then begin
                AllowPreviewOnly;
              end; { if }
              SavePen.Assign(Canvas.Pen);
              SaveBrush.Assign(Canvas.Brush);
              try
                Canvas.Pen.Assign(FDrawPen);
                SetBrush(clWhite,bsClear,nil);
                For I1 := 1 to NumDown do begin
                  For I2 := 1 to NumAcross do begin
                    OriginY := YI2U((I1 - 1) * SpacingHeight + SpacingTop);
                    OriginX := XI2U((I2 - 1) * SpacingWidth + SpacingLeft);
                    Case LabelShape of
                      lsRoundRect: begin
                        RoundRect(0,0,XI2U(LabelWidth),YI2U(LabelHeight),
                         XI2U(0.2),YI2U(0.2));
                      end;
                      lsRect: begin
                        Rectangle(0,0,XI2U(LabelWidth),YI2U(LabelHeight));
                      end;
                      lsRound: begin
                        Ellipse(0,0,XI2U(LabelWidth),YI2U(LabelHeight));
                      end;
                    end; { case }
                  end; { for }
                end; { for }
              finally
                If DrawPreviewOnly then begin
                  AllowAll;
                end; { if }
                Canvas.Pen.Assign(SavePen);
                Canvas.Brush.Assign(SaveBrush);
              end; { tryf }
            end; { with }
          end; { if }

          If PrintByRow then begin
            For I1 := 1 to NumDown do begin
              For I2 := 1 to NumAcross do begin
                EndReport := not PrintLabel(I1,I2);
                If EndReport then Break;
              end; { for }
              If EndReport then Break;
            end; { for }
          end else begin
            For I2 := 1 to NumAcross do begin
              For I1 := 1 to NumDown do begin
                EndReport := not PrintLabel(I1,I2);
                If EndReport then Break;
              end; { for }
              If EndReport then Break;
            end; { for }
          end; { else }
          SkipNum := 0;
          StartRow := 0;
          StartCol := 0;

          If not EndReport then begin
            ReportPrinter.NewPage;
          end; { if }
        end; { while }

      { Call EndPage for last page }
        EndPage(ReportPrinter);
      finally
        ReportAfterEvent;
      end; { tryf }
    finally
      SaveBrush.Free;
      SavePen.Free;
    { Remove the page event handlers }
      ReportPrinter.RemoveReportEvent(reBeginPage,BeginPage);
      ReportPrinter.RemoveReportEvent(reEndPage,EndPage);
    end; { tryf }
  end;  { PrintReport }

  procedure TLabelShell.Execute(Report: TBaseReport);

  begin { Execute }
    If InitEngine(Report) then begin
      try
        PrintReport;
      finally
        ReportPrinter := nil;
      end; { tryf }
    end; { if }
  end;  { Execute }

end.
