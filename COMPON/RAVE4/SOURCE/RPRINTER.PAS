{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPrinter;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPDevice, RPCanvas;

type
{*************************************************************************}
{                            class TReportPrinter                         }
{*************************************************************************}

  TReportPrinter = class(TCanvasReport)
  public
  { Report Methods - public }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; override;
    procedure Finish; override;
    procedure NewPage; override;

  published
  { Properties - redeclare as published }
    property FirstPage;
    property LastPage;
    property StatusLabel;
    property StatusFormat;
    property StatusText;
    property LineHeightMethod;
    property LinesPerInch;
    property Units;
    property UnitsFactor;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property MarginBottom;
    property TabShade;
    property Title;
    property TextBKMode;
    property Copies;
    property Orientation;
    property ScaleX;
    property ScaleY;

  { Event Properties - redeclare as published }
    property OnPrint;
    property OnPrintPage;
    property OnBeforePrint;
    property OnAfterPrint;
    property OnNewPage;
    property OnNewColumn;
    property OnPrintHeader;
    property OnPrintFooter;
    property OnEndOfSection;
    property OnDecodeImage;
  end; { TReportPrinter }

implementation
{*************************************************************************}
{                            class TReportPrinter                         }
{*************************************************************************}

  constructor TReportPrinter.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
  end;  { Create }

  destructor TReportPrinter.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

{ Public Methods }

  procedure TReportPrinter.Start;

  begin { Start }
    If NoPrinters then begin
      MessageDlg(Trans('No printers are defined, aborting print job.'),mtError,
       [mbOk],0);
      Exit;
    end; { if }
    CheckNotPrinting;

    FReportDateTime := Now;
    FAborted := false;
    FCurrentPage := 0;
    BeforePrintEvent;

    LocalDevice.Title := FTitle;
    LocalDevice.BeginDocSelect;
    GrabFontOnChange;

  { Begin printing entire report }
    ResetPrinter;
    FPrinting := true;
    PushTabs;
    Reset;
    PopTabs;
    Inc(FCurrentPage);
    FPageInvalid := not PageInRange(FCurrentPage) or FAborted;
    LocalDevice.NewPageSelect(not FPageInvalid);

    UpdateStatus; { Update status for first page }

  { Call OnNewPage and OnPrintHeader for first page }
    If not FAborted then begin
      ExecuteReportEvent(BeginPageList);
    end; { if }
    If not FAborted then begin
      NewPageEvent;
    end; { if }
    If not FAborted then begin
      PrintHeaderEvent;
    end; { if }
  end;  { Start }

  procedure TReportPrinter.Finish;

  begin { Finish }
    try
    { Print the last footer }
      If not FAborted then begin
        PrintFooterEvent;
      end; { if }
      If not FAborted then begin
        ExecuteReportEvent(EndPageList);
      end; { if }
    finally
      try
        ReleaseFontOnChange;
        ClearFontList;
        ClearLineLists;
        If FAborted then begin
          LocalDevice.Abort;
        end else begin
          LocalDevice.EndDoc;
        end; { else }
        FPrinting := false;
      finally
        AfterPrintEvent;
      end; { try }
    end; { try }
  end;  { Finish }

  procedure TReportPrinter.NewPage;

  begin { NewPage }
    PrintFooterEvent;
    ExecuteReportEvent(EndPageList);

    inherited NewPage;

    ExecuteReportEvent(BeginPageList);
    NewPageEvent;
    If FColumns > 1 then begin
      NewColumnEvent;
    end; { if }
    PrintHeaderEvent;
  end;  { NewPage }

end.
