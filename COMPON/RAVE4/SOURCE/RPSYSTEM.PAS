{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPSystem;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QButtons,
  {$ELSE}
  WinTypes, WinProcs, Messages, Forms, Graphics, Controls, Dialogs,
  StdCtrls, ExtCtrls, Buttons,
  {$ENDIF}
  SysUtils, Classes, RPDefine, RPBase, RPFiler,
  {$IFNDEF Server}RPrinter, RPFPrint, RPreview,{$ENDIF} RPDevice, RPRender;

type
  TOverrideMode = (omCreate,omShow,omWait,omFree);
  TReportSystem = class;
  TReportSystemEvent = procedure(    ReportSystem: TReportSystem;
                                     OverrideMode: TOverrideMode;
                                 var OverrideForm: TForm) of object;

{*************************************************************************}
{                            class TSystemPrinter                         }
{*************************************************************************}

  TSystemPrinter = class(TPersistent)
  protected
    FCopies: integer;
    FFirstPage: integer;
    FLastPage: integer;
    FLineHeightMethod: TLineHeightMethod;
    FLinesPerInch: integer;
    FMarginBottom: double;
    FMarginLeft: double;
    FMarginRight: double;
    FMarginTop: double;
    FOrientation: TOrientation;
    FScaleX: double;
    FScaleY: double;
    FStatusFormat: TFormatString;
    FStatusText: TStrings;
    FTabShade: integer;
    FTextBKMode: TBKMode;
    FTitle: TTitleString;
    FUnits: TPrintUnits;
    FUnitsFactor: double;

    procedure SetStatusText(Value: TStrings);
    procedure SetTabShade(Value: integer);
    procedure SetUnits(Value: TPrintUnits);
    procedure SetUnitsFactor(Value: double);
  public
    FCollate: boolean;
    FDuplex: TDuplex;

    constructor Create;
    destructor Destroy; override;
    procedure InitPrinter(BaseReport: TBaseReport);
  published
    property Copies: integer read FCopies write FCopies default 1;
    property FirstPage: integer read FFirstPage write FFirstPage default 1;
    property LastPage: integer read FLastPage write FLastPage default 9999;
    property LineHeightMethod: TLineHeightMethod read FLineHeightMethod write
     FLineHeightMethod default lhmFont;
    property LinesPerInch: integer read FLinesPerInch write FLinesPerInch
     default 6;
    property MarginBottom: double read FMarginBottom write FMarginBottom;
    property MarginLeft: double read FMarginLeft write FMarginLeft;
    property MarginRight: double read FMarginRight write FMarginRight;
    property MarginTop: double read FMarginTop write FMarginTop;
    property Orientation: TOrientation read FOrientation write
     FOrientation default poPortrait;
    property ScaleX: double read FScaleX write FScaleX;
    property ScaleY: double read FScaleY write FScaleY;
    property StatusFormat: TFormatString read FStatusFormat write FStatusFormat;
    property StatusText: TStrings read FStatusText write SetStatusText;
    property TabShade: integer read FTabShade write SetTabShade default 0;
    property TextBKMode: TBKMode read FTextBKMode write FTextBKMode
     default bkTransparent;
    property Title: TTitleString read FTitle write FTitle;
    property Units: TPrintUnits read FUnits write SetUnits default unInch;
    property UnitsFactor: double read FUnitsFactor write SetUnitsFactor;
  end; { TSystemPrinter }

{*************************************************************************}
{                            class TSystemPreview                         }
{*************************************************************************}

  TSystemPreview = class(TPersistent)
  protected
    FGridHoriz: double;
    FGridPen: TPen;
    FGridVert: double;
    FMarginMethod: TMarginMethod;
    FMarginPercent: double;
    FMonochrome: boolean;
    FPagesWide: integer;
    FPagesHigh: integer;
    FPageInc: integer;
    FRulerType: TRulerType;
    FShadowDepth: integer;
    FZoomFactor: double;
    FZoomInc: integer;
    FFormWidth: integer;
    FFormHeight: integer;
    FFormState: TWindowState;

    procedure SetMonochrome(Value: boolean);
    procedure SetShadowDepth(Value: integer);
    procedure SetZoomFactor(Value: double);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitPreview(BaseReport: TBaseReport);
  published
    property FormWidth: integer read FFormWidth write FFormWidth default 615;
    property FormHeight: integer read FFormHeight write FFormHeight default 450;
    property FormState: TWindowState read FFormState write FFormState default wsNormal;
    property GridHoriz: double read FGridHoriz write FGridHoriz;
    property GridPen: TPen read FGridPen write FGridPen;
    property GridVert: double read FGridVert write FGridVert;
    property MarginMethod: TMarginMethod read FMarginMethod write FMarginMethod
     default mmFixed;
    property MarginPercent: double read FMarginPercent write FMarginPercent;
    property Monochrome: boolean read FMonochrome write SetMonochrome default
     false;
    property PagesWide: integer read FPagesWide write FPagesWide default 1;
    property PagesHigh: integer read FPagesHigh write FPagesHigh default 1;
    property PageInc: integer read FPageInc write FPageInc default 1;
    property RulerType: TRulerType read FRulerType write FRulerType default
     rtNone;
    property ShadowDepth: integer read FShadowDepth write SetShadowDepth default 0;
    property ZoomFactor: double read FZoomFactor write SetZoomFactor;
    property ZoomInc: integer read FZoomInc write FZoomInc default 10;
  end; { TSystemPreview }

{*************************************************************************}
{                            class TSystemFiler                           }
{*************************************************************************}

  TSystemFiler = class(TPersistent)
  protected
    FAccuracyMethod: TAccuracyMethod;
    FFileName: TFileName;
    FStatusFormat: TFormatString;
    FStatusText: TStrings;
    FStreamMode: TStreamMode;
    FStream: TStream;
    FIgnoreRPTF: boolean;

    procedure SetStatusText(Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitFiler(BaseReport: TBaseReport);

    property Stream: TStream read FStream write FStream;
    property IgnoreRPTF: boolean read FIgnoreRPTF write FIgnoreRPTF;
  published
    property AccuracyMethod: TAccuracyMethod read FAccuracyMethod write
     FAccuracyMethod default amPositioning;
    property FileName: TFileName read FFileName write FFileName;
    property StatusFormat: TFormatString read FStatusFormat write FStatusFormat;
    property StatusText: TStrings read FStatusText write SetStatusText;
    property StreamMode: TStreamMode read FStreamMode write FStreamMode
     default smMemory;
  end; { TSystemFiler }

{*************************************************************************}
{                            class TReportSystem                          }
{*************************************************************************}

  TReportSystem = class(TRPBaseComponent)
  protected
    FDoNativeOutput: boolean;
    FAborted: boolean;
    FBaseReport: TBaseReport;
    SaveLabel: TLabel;
    FDefaultDest: TReportDest;
    FReportDest: TReportDest;
    FOutputFileName: TFileName;
    ForceMultiPrint: boolean;

    FSystemSetups: TSystemSetups;
    FSystemOptions: TSystemOptions;

    FSystemFiler: TSystemFiler;
    FSystemPreview: TSystemPreview;
    FSystemPrinter: TSystemPrinter;
    FTitleSetup: TFormatString;
    FTitleStatus: TFormatString;
    FTitlePreview: TFormatString;
    FStorageMacroData: TStrings;
    FRenderObject: TRPRender;

  { Event methods }
    FOnPrint: TNotifyEvent;
    FOnPrintPage: TPrintPageEvent;
    FOnBeforePrint: TNotifyEvent;
    FOnAfterPrint: TNotifyEvent;
    FOnNewPage: TNotifyEvent;
    FOnNewColumn: TNotifyEvent;
    FOnPrintHeader: TNotifyEvent;
    FOnPrintFooter: TNotifyEvent;
    FOnEndOfSection: TNotifyEvent;
    FOnDecodeImage: TDecodeImageEvent;
    FOnPreviewSetup: TNotifyEvent;
    FOnPreviewShow: TNotifyEvent;
    FOnOverrideSetup: TReportSystemEvent;
    FOnOverrideStatus: TReportSystemEvent;
    FOnOverridePreview: TReportSystemEvent;

    procedure SetRenderObject(const Value: TRPRender);
    procedure InitEvents(BaseReport: TBaseReport);
    function GetStream: TStream;
    procedure SetStream(Value: TStream);
    procedure OverrideSetupProc(    ReportSystem: TReportSystem;
                                    OverrideMode: TOverrideMode;
                                var OverrideForm: TForm); virtual;
    procedure OverrideStatusProc(    ReportSystem: TReportSystem;
                                     OverrideMode: TOverrideMode;
                                 var OverrideForm: TForm); virtual;
    procedure OverridePreviewProc(    ReportSystem: TReportSystem;
                                      OverrideMode: TOverrideMode;
                                  var OverrideForm: TForm); virtual;
    procedure SetupReport(var SetupForm: TForm);
    procedure GenerateReport(var StatusForm: TForm);
    procedure PrintReport(var StatusForm: TForm);
    procedure PreviewReport(var PreviewForm: TForm);
    procedure SetStorageMacroData(Value: TStrings);
    procedure InitRenderStream(var RenderStream: TStream);
    procedure PrintRender(var StatusForm: TForm);

  public
  { Report Methods - public }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Execute;
    procedure PreviewShowEvent(Sender: TObject);

    property Stream: TStream read GetStream write SetStream;
    property ReportDest: TReportDest read FReportDest write FReportDest;
    property OutputFileName: TFileName read FOutputFileName write FOutputFileName;
    property BaseReport: TBaseReport read FBaseReport write FBaseReport;
    property Aborted: boolean read FAborted write FAborted;
    property StorageMacroData: TStrings read FStorageMacroData write SetStorageMacroData;
    property RenderObject: TRPRender read FRenderObject write SetRenderObject;
    property DoNativeOutput: boolean read FDoNativeOutput write FDoNativeOutput default true;
  published
    property TitleSetup: TFormatString read FTitleSetup write FTitleSetup;
    property TitleStatus: TFormatString read FTitleStatus write FTitleStatus;
    property TitlePreview: TFormatString read FTitlePreview write FTitlePreview;
    property SystemSetups: TSystemSetups read FSystemSetups write FSystemSetups
     default [ssAllowSetup,ssAllowCopies,ssAllowCollate,ssAllowDuplex,
      ssAllowDestPreview,ssAllowDestPrinter,ssAllowDestFile,ssAllowPrinterSetup,
      ssAllowPreviewSetup];
    property SystemOptions: TSystemOptions read FSystemOptions write FSystemOptions
     default [soShowStatus,soAllowPrintFromPreview,soPreviewModal];
    property DefaultDest: TReportDest read FDefaultDest write FDefaultDest
     default rdPreview;

  { System properties }
    property SystemFiler: TSystemFiler read FSystemFiler write FSystemFiler;
    property SystemPreview: TSystemPreview read FSystemPreview write FSystemPreview;
    property SystemPrinter: TSystemPrinter read FSystemPrinter write FSystemPrinter;

  { Event Properties - redeclare as published }
    property OnPrint: TNotifyEvent read FOnPrint write FOnPrint;
    property OnPrintPage: TPrintPageEvent read FOnPrintPage write FOnPrintPage;
    property OnBeforePrint: TNotifyEvent read FOnBeforePrint write
     FOnBeforePrint;
    property OnAfterPrint: TNotifyEvent read FOnAfterPrint write FOnAfterPrint;
    property OnNewPage: TNotifyEvent read FOnNewPage write FOnNewPage;
    property OnNewColumn: TNotifyEvent read FOnNewColumn write FOnNewColumn;
    property OnPrintHeader: TNotifyEvent read FOnPrintHeader write
     FOnPrintHeader;
    property OnPrintFooter: TNotifyEvent read FOnPrintFooter write
     FOnPrintFooter;
    property OnEndOfSection: TNotifyEvent read FOnEndOfSection write
     FOnEndOfSection;
    property OnDecodeImage: TDecodeImageEvent read FOnDecodeImage write
     FOnDecodeImage;

    property OnPreviewSetup: TNotifyEvent read FOnPreviewSetup write
     FOnPreviewSetup;
    property OnPreviewShow: TNotifyEvent read FOnPreviewShow write
     FOnPreviewShow;
    property OverrideSetup: TReportSystemEvent read FOnOverrideSetup write
     FOnOverrideSetup;
    property OverrideStatus: TReportSystemEvent read FOnOverrideStatus write
     FOnOverrideStatus;
    property OverridePreview: TReportSystemEvent read FOnOverridePreview write
     FOnOverridePreview;
  end; { TReportSystem }

implementation

{$IFNDEF Server}
uses
  RPSetFrm, RPStaFrm, RPPreFrm;
{$ENDIF}

{*************************************************************************}
{                            class TReportSystem                          }
{*************************************************************************}

constructor TReportSystem.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);

  If (AOwner <> nil) and (csDesigning in ComponentState) and not (csReading in AOwner.ComponentState) then begin
    FTitleSetup := Trans('Output Options');
    FTitleStatus := Trans('Report Status');
    FTitlePreview := Trans('Report Preview');
  end; { if }
  FSystemSetups := [ssAllowSetup,ssAllowCopies,ssAllowCollate,ssAllowDuplex,
   ssAllowDestPreview,ssAllowDestPrinter,ssAllowDestFile,ssAllowPrinterSetup,
   ssAllowPreviewSetup];
  FSystemOptions := [soShowStatus,soAllowPrintFromPreview,soPreviewModal];
  FDefaultDest := rdPreview;
  BaseReport := nil;
  FSystemFiler := TSystemFiler.Create;
  FSystemPreview := TSystemPreview.Create;
  FSystemPrinter := TSystemPrinter.Create;
  FStorageMacroData := TStringList.Create;
  FOutputFileName := '';
  FRenderObject := nil;
  FDoNativeOutput := true;
end;  { Create }

destructor TReportSystem.Destroy;

begin { Destroy }
  FSystemPrinter.Free;
  FSystemPreview.Free;
  FSystemFiler.Free;
  FStorageMacroData.Free;

  inherited Destroy;
end;  { Destroy }

procedure TReportSystem.InitEvents(BaseReport: TBaseReport);

begin { InitEvents }
  With BaseReport do begin
    OnPrint := FOnPrint;
    OnPrintPage := FOnPrintPage;
    OnBeforePrint := FOnBeforePrint;
    OnAfterPrint := FOnAfterPrint;
    OnNewPage := FOnNewPage;
    OnNewColumn := FOnNewColumn;
    OnPrintHeader := FOnPrintHeader;
    OnPrintFooter := FOnPrintFooter;
    OnEndOfSection := FOnEndOfSection;
    OnDecodeImage := FOnDecodeImage;
  end; { with }
end;  { InitEvents }

procedure TReportSystem.PreviewShowEvent(Sender: TObject);

begin { PreviewShowEvent }
  If Assigned(FOnPreviewShow) then begin
    FOnPreviewShow(Sender);
  end; { if }
end;  { PreviewShowEvent }

procedure TReportSystem.SetStream(Value: TStream);

begin { SetStream }
  SystemFiler.FStream := Value;
end;  { SetStream }

procedure TReportSystem.SetStorageMacroData(Value: TStrings);

begin { SetStorageMacroData }
  FStorageMacroData.Assign(Value);
end;  { SetStorageMacroData }

function TReportSystem.GetStream: TStream;

begin { GetStream }
  Result := SystemFiler.FStream;
end;  { GetStream }

procedure TReportSystem.OverrideSetupProc(    ReportSystem: TReportSystem;
                                              OverrideMode: TOverrideMode;
                                          var OverrideForm: TForm);

begin { OverrideSetupProc }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Case OverrideMode of
    omCreate: begin
      OverrideForm := TRPSetupForm.Create(self);
      OverrideForm.Caption := FTitleSetup;
      (OverrideForm as TRPSetupForm).ReportSystem := ReportSystem;
    end;
    omShow: begin
      With OverrideForm as TRPSetupForm,ReportSystem do begin
        PreviewSetup := false;
        Aborted := ShowModal = mrCancel;
      end; { with }
    end;
    omWait: begin
    { No need to wait since we always ShowModal }
    end;
    omFree: begin
      OverrideForm.Free;
    end;
  end; { case }
  {$ENDIF}
end;  { OverrideSetupProc }

procedure TReportSystem.OverrideStatusProc(    ReportSystem: TReportSystem;
                                               OverrideMode: TOverrideMode;
                                           var OverrideForm: TForm);

begin { OverrideStatusProc }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If not (soShowStatus in ReportSystem.SystemOptions) then Exit;

  Case OverrideMode of
    omCreate: begin
      OverrideForm := TRPStatusForm.Create(self);
      OverrideForm.Caption := FTitleStatus;
      (OverrideForm as TRPStatusForm).ReportSystem := ReportSystem;
    end;
    omShow: begin
      With OverrideForm as TRPStatusForm,ReportSystem do begin
        BaseReport.StatusLabel := StatusLabel;
        CancelButton.Caption := 'Cancel';
        Show;
      end; { with }
    end;
    omWait: begin
      With OverrideForm as TRPStatusForm,ReportSystem do begin
        If soWaitForOK in SystemOptions then begin
        CancelButton.Caption := 'Ok';
          FormClosed := false;
          Repeat
            Application.ProcessMessages;
          until FormClosed;
        end; { if }
      end; { with }
    end;
    omFree: begin
      OverrideForm.Free;
    end;
  end; { case }
  {$ENDIF}
end;  { OverrideStatusProc }

procedure TReportSystem.OverridePreviewProc(    ReportSystem: TReportSystem;
                                                OverrideMode: TOverrideMode;
                                            var OverrideForm: TForm);

begin { OverridePreviewProc }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Case OverrideMode of
    omCreate: begin
      OverrideForm := TRPPreviewForm.Create(self);
      (OverrideForm as TRPPreviewForm).ReportSystem := ReportSystem;
      With OverrideForm as TRPPreviewForm,ReportSystem do begin
        Caption := FTitlePreview;
        Width := SystemPreview.FFormWidth;
        Height := SystemPreview.FFormHeight;
        WindowState := SystemPreview.FFormState;
      end; { with }
    end;
    omShow: begin
      With OverrideForm as TRPPreviewForm,ReportSystem do begin
        SystemFiler.InitFiler(FilePrinter1);
        SystemFiler.InitFiler(FilePreview1);
        SystemPreview.InitPreview(FilePreview1);
        FilePrinter1.MacroData := StorageMacroData;
        FilePreview1.MacroData := StorageMacroData;
        FilePrinter1.OnDecodeImage := FOnDecodeImage;
        FilePreview1.OnDecodeImage := FOnDecodeImage;
        If Assigned(FOnPreviewSetup) then begin
          FOnPreviewSetup(FilePreview1);
        end; { if }
        InitFromRPSystem;
        if soPreviewModal in SystemOptions then begin
          ShowModal;
        end else begin
          Show;
        end; { else }
      end; { with }
    end;
    omWait: begin
      With OverrideForm as TRPPreviewForm,ReportSystem do begin
        If not (soPreviewModal in SystemOptions) then begin { Wait for close }
          FormClosed := false;
          Repeat
            Application.ProcessMessages;
          until FormClosed;
        end; { if }
      end; { with }
    end;
    omFree: begin
      OverrideForm.Free;
    end;
  end; { case }
  {$ENDIF}
end;  { OverridePreviewProc }

procedure TReportSystem.SetupReport(var SetupForm: TForm);

begin { SetupReport }
  ReportDest := DefaultDest;
  Aborted := false;
  If ssAllowSetup in SystemSetups then begin
    If not Assigned(FOnOverrideSetup) then begin
      FOnOverrideSetup := OverrideSetupProc;
    end; { if }
    FOnOverrideSetup(self,omCreate,SetupForm);
    try
      FOnOverrideSetup(self,omShow,SetupForm);
      FOnOverrideSetup(self,omWait,SetupForm);
    finally
      FOnOverrideSetup(self,omFree,SetupForm);
    end; { tryf }
  end; { if }
end;  { SetupReport }

procedure TReportSystem.GenerateReport(var StatusForm: TForm);

begin { GenerateReport }
  If soNoGenerate in SystemOptions then Exit;

  Aborted := true;
  If not Assigned(FOnOverrideStatus) then begin
    FOnOverrideStatus := OverrideStatusProc;
  end; { if }
  FOnOverrideStatus(self,omCreate,StatusForm);
  BaseReport := nil;
  try
  { Create and init ReportFiler }
    BaseReport := TReportFiler.Create(Owner);
    SystemPrinter.InitPrinter(BaseReport);
    SystemFiler.InitFiler(BaseReport);
    If (ReportDest = rdFile) and not Assigned(RenderObject) then begin
      If DoNativeOutput then begin
      // Output printer native
        BaseReport.OutputName := OutputFileName;
      end else begin
      // Output NDR
        TReportFiler(BaseReport).StreamMode := smFile;
        TReportFiler(BaseReport).FileName := OutputFileName;
      end; { else }
    end; { if }
    InitEvents(BaseReport);
    FOnOverrideStatus(self,omShow,StatusForm);
    BaseReport.Execute;
    StorageMacroData := BaseReport.MacroData;
    Aborted := BaseReport.Aborted;
  finally
    If BaseReport <> nil then begin
      SaveLabel := BaseReport.StatusLabel;
      SystemFiler.FileName := (BaseReport as TReportFiler).FileName;
      BaseReport.Free;
      BaseReport := nil;
    end; { if }
    If ReportDest = rdPreview then begin
      FOnOverrideStatus(self,omFree,StatusForm);
    end; { if }
  end; { try }
end;  { GenerateReport }

procedure TReportSystem.PrintReport(var StatusForm: TForm);

var
  I1: integer;
  ForceCopies: integer;

begin { PrintReport }
  Aborted := true;
  If not Assigned(FOnOverrideStatus) then begin
    FOnOverrideStatus := OverrideStatusProc;
  end; { if }
  BaseReport := nil;
  try
    If (soUseFiler in SystemOptions) or ForceMultiPrint then begin
      If soNoGenerate in SystemOptions then begin
        FOnOverrideStatus(self,omCreate,StatusForm);
      end; { if }
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      BaseReport := TFilePrinter.Create(Owner);
      BaseReport.MacroData := StorageMacroData;
      BaseReport.OnDecodeImage := FOnDecodeImage;
      If soNoGenerate in SystemOptions then begin
        (BaseReport as TFilePrinter).IgnoreFileSettings := true;
      end; { if }
      SystemPrinter.InitPrinter(BaseReport);
      BaseReport.Units := unInch;
      SystemFiler.InitFiler(BaseReport);
      BaseReport.StatusLabel := SaveLabel; { Restore StatusLabel }
      If soNoGenerate in SystemOptions then begin
        FOnOverrideStatus(self,omShow,StatusForm);
      end; { if }
      {$ENDIF}
    end else begin
      FOnOverrideStatus(self,omCreate,StatusForm);
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      BaseReport := TReportPrinter.Create(Owner);
      SystemPrinter.InitPrinter(BaseReport);
      InitEvents(BaseReport);
      BaseReport.OutputName := OutputFileName;
      FOnOverrideStatus(self,omShow,StatusForm);
      {$ENDIF}
    end; { else }

    If ForceMultiPrint then begin
      ForceCopies := BaseReport.Copies;
      BaseReport.Copies := 1;
    end else begin
      ForceCopies := 1;
    end; { else }
    BaseReport.TotalPasses := ForceCopies;
    For I1 := 1 to ForceCopies do begin
      BaseReport.CurrentPass := I1;
      BaseReport.Execute;
    end; { for }
    Aborted := BaseReport.Aborted;
    If not Aborted then begin
      FOnOverrideStatus(self,omWait,StatusForm);
    end; { if }
  finally
    If BaseReport <> nil then begin
      BaseReport.Free;
      BaseReport := nil;
    end; { if }
    FOnOverrideStatus(self,omFree,StatusForm);
  end; { try }
end;  { PrintReport }

procedure TReportSystem.PreviewReport(var PreviewForm: TForm);

begin { PreviewReport }
  If not Assigned(FOnOverridePreview) then begin
    FOnOverridePreview := OverridePreviewProc;
  end; { if }
  FOnOverridePreview(self,omCreate,PreviewForm);
  try
    FOnOverridePreview(self,omShow,PreviewForm);
    FOnOverridePreview(self,omWait,PreviewForm);
  finally
    FOnOverridePreview(self,omFree,PreviewForm);
  end; { tryf }
end;  { PreviewReport }

procedure TReportSystem.Execute;

var
  ReportStream: TMemoryStream;
  SetupForm: TForm;
  StatusForm: TForm;
  PreviewForm: TForm;
  TempFile: file;

  function CreateNDR: boolean;
  begin
    Result := (ReportDest = rdPreview) or (soUseFiler in SystemOptions) or
     ForceMultiPrint or ((ReportDest = rdFile) and not DoNativeOutput
     and not (soNoGenerate in SystemOptions));
  end;

begin { Execute }
  SetupForm := nil;
  StatusForm := nil;
  PreviewForm := nil;

  SetupReport(SetupForm);
  If not Aborted then begin
    ForceMultiPrint := (GlobalDevice.MaxCopies <= 1) and (SystemPrinter.Copies > 1);

    If CreateNDR and (SystemFiler.StreamMode = smMemory) then begin
      ReportStream := TMemoryStream.Create;
      Stream := ReportStream;
    end else begin
      ReportStream := nil;
    end; { else }

    try
      If CreateNDR then begin
        GenerateReport(StatusForm);
      end; { if }

      If not Aborted then begin
        If ReportDest in [rdPrinter,rdFile] then begin
          If (ReportDest = rdPrinter) or DoNativeOutput then begin // Printer or Native output
            PrintReport(StatusForm);
          end else if Assigned(RenderObject) then begin // Rendered output
            PrintRender(StatusForm);
          end else begin // NDR output only
            If Assigned(FOnOverrideStatus) then begin
              FOnOverrideStatus(self,omFree,StatusForm);
            end; { if }
          end; { else }
        end else if ReportDest = rdPreview then begin
          PreviewReport(PreviewForm);
        end; { else }
      end; { if }
    finally
      If ReportStream <> nil then begin
        ReportStream.Free;
      end; { if }
      If ((ReportDest = rdPreview) or (soUseFiler in SystemOptions) or
       ForceMultiPrint) and
       (SystemFiler.StreamMode = smTempFile) then begin { Erase temp file }
        AssignFile(TempFile,SystemFiler.FileName);
        try
          Erase(TempFile);
        except
        end; { tryx }
      end; { if }
    end; { tryf }
  end; { if }
end;  { Execute }

procedure TReportSystem.SetRenderObject(const Value: TRPRender);
begin
  FRenderObject := Value;
end;

procedure TReportSystem.InitRenderStream(var RenderStream: TStream);
begin
  Case SystemFiler.StreamMode of
    smMemory: begin
      RenderStream := TMemoryStream.Create;
      With RenderStream as TMemoryStream do begin
        SystemFiler.Stream.Position := 0;
        LoadFromStream(SystemFiler.Stream);
      end; { with }
    end;
    smFile,smTempFile: begin
      RenderStream := TFileStream.Create(SystemFiler.Filename,fmOpenRead or
       fmShareDenyWrite);
    end;
    smUser: begin
      If SystemFiler.Stream = nil then begin
        RaiseError(Trans('StreamMode is smUser but Stream is nil'));
      end; { if }
      RenderStream := SystemFiler.Stream;
      RenderStream.Position := 0;
    end;
  end; { case }
  RenderStream.Position := 0;
end;

procedure TReportSystem.PrintRender(var StatusForm: TForm);

var
  NDRStream: TStream;

begin
//!!! Add calls to OnOverrideStatus similar to PrintReport
  If Assigned(FOnOverrideStatus) and Assigned(StatusForm) then begin
    FOnOverrideStatus(self,omFree,StatusForm);
  end; { if }
  NDRStream := nil;
  try
    InitRenderStream(NDRStream);
    RenderObject.PrintRender(NDRStream, OutputFileName);
  finally
    If SystemFiler.StreamMode <> smUser then begin
      NDRStream.Free;
    end; { if }
  end;
end;

{*************************************************************************}
{                            class TSystemPrinter                         }
{*************************************************************************}

constructor TSystemPrinter.Create;

begin { Create }
  inherited Create;

  FCopies := 1;
  FFirstPage := 1;
  FLastPage := 9999;
  FLineHeightMethod := lhmFont;
  FLinesPerInch := 6;
  FMarginBottom := 0.0;
  FMarginLeft := 0.0;
  FMarginRight := 0.0;
  FMarginTop := 0.0;
  FOrientation := poPortrait;
  FScaleX := 100.0;
  FScaleY := 100.0;
  FStatusFormat := Trans('Printing page %p');
  FStatusText := TStringList.Create;
  FTabShade := 0;
  FTextBKMode := bkTransparent;
  FTitle := Trans('ReportPrinter Report');
  FUnits := unInch;
  FUnitsFactor := 1.0;
  FCollate := false;
  FDuplex := GlobalDevice.Duplex;
end;  { Create }

destructor TSystemPrinter.Destroy;

begin { Destroy }
  FStatusText.Free;

  inherited Destroy;
end;  { Destroy }

procedure TSystemPrinter.SetStatusText(Value: TStrings);

begin { SetStatusText }
  FStatusText.Assign(Value);
end;  { SetStatusText }

procedure TSystemPrinter.SetTabShade(Value: integer);

begin { SetTabShade }
  If Value >= 100 then begin
    FTabShade := 100;
  end else if Value <= 0 then begin
    FTabShade := 0;
  end else begin
    FTabShade := Value;
  end; { else }
end;  { SetTabShade }

procedure TSystemPrinter.SetUnits(Value: TPrintUnits);

begin { SetUnits }
  FUnits := Value;
  Case FUnits of
    unInch: begin
      FUnitsFactor := 1.0;
    end;
    unMM: begin
      FUnitsFactor := 25.4;
    end;
    unCM: begin
      FUnitsFactor := 2.54;
    end;
    unPoint: begin
      FUnitsFactor := 72.0;
    end;
    unUser: begin
    { Don't change FUnitsFactor }
    end;
  end; { case }
end;  { SetUnits }

procedure TSystemPrinter.SetUnitsFactor(Value: double);

var
  R1: array [1..4] of double;

begin { SetUnitsFactor }
  If Value > 0.0 then begin
    FUnitsFactor := Value;
    R1[1] := 1.0;
    R1[2] := 25.4;
    R1[3] := 2.54;
    R1[4] := 72.0;
    If (FUnitsFactor = R1[1]) then begin
      FUnits := unInch;
    end else if (FUnitsFactor = R1[2]) then begin
      FUnits := unMM;
    end else if (FUnitsFactor = R1[3]) then begin
      FUnits := unCM;
    end else if (FUnitsFactor = R1[4]) then begin
      FUnits := unPoint;
    end else begin
      FUnits := unUser;
    end; { else }
  end; { if }
end;  { SetUnitsFactor }

procedure TSystemPrinter.InitPrinter(BaseReport: TBaseReport);

begin { InitPrinter }
  With BaseReport do begin
    Copies := FCopies;
    FirstPage := FFirstPage;
    LastPage := FLastPage;
    LineHeightMethod := FLineHeightMethod;
    LinesPerInch := FLinesPerInch;
    MarginBottom := FMarginBottom;
    MarginLeft := FMarginLeft;
    MarginRight := FMarginRight;
    MarginTop := FMarginTop;
    Orientation := FOrientation;
    ScaleX := FScaleX;
    ScaleY := FScaleY;
    StatusFormat := FStatusFormat;
    StatusText := FStatusText;
    TabShade := FTabShade;
    TextBKMode := FTextBKMode;
    Title := FTitle;
    Units := FUnits;
    If FUnits = unUser then begin
      UnitsFactor := FUnitsFactor;
    end; { if }
    If (RPDev = nil) or not RPDev.InvalidPrinter then begin
      Collate := FCollate;
      Duplex := FDuplex;
    end; { if }
  end; { with }
end;  { InitPrinter }

{*************************************************************************}
{                            class TSystemPreview                         }
{*************************************************************************}

constructor TSystemPreview.Create;

begin { Create }
  inherited Create;

  FFormWidth := 615;
  FFormHeight := 450;
  FFormState := wsNormal;
  FGridHoriz := 0.0;
  FGridPen := TPen.Create;
  FGridVert := 0.0;
  FMarginMethod := mmFixed;
  FMarginPercent := 0.0;
  FMonochrome := false;
  FRulerType := rtNone;
  FShadowDepth := 0;
  FZoomFactor := 100.0;
  FZoomInc := 10;
  FPagesWide := 1;
  FPagesHigh := 1;
  FPageInc := 1;
end;  { Create }

destructor TSystemPreview.Destroy;

begin { Destroy }
  FGridPen.Free;

  inherited Destroy;
end;  { Destroy }

procedure TSystemPreview.SetMonochrome(Value: boolean);

begin { SetMonochrome }
  If (ShadowDepth > 0) and Value then begin { Warn programmer }
    ShowMessage({Trans-}'Monochrome not allowed while shadows are in effect.'#13 +
     {Trans-}'Change ShadowDepth to 0 first');
  end else begin
    FMonochrome := Value;
  end; { else }
end;  { SetMonochrome }

procedure TSystemPreview.SetShadowDepth(Value: integer);

begin { SetShadowDepth }
  If (Value > 0) and Monochrome then begin { Warn programmer }
    ShowMessage({Trans-}'Shadows not allowed while monochrome in effect.'#13 +
     {Trans-}'Change Monochrome to false first');
  end else begin
    FShadowDepth := Value;
  end; { else }
end;  { SetShadowDepth }

procedure TSystemPreview.SetZoomFactor(Value: double);

begin { SetZoomFactor }
  If Value < 10.0 then begin
    FZoomFactor := 10.0;
  end else if Value > 200.0 then begin
    FZoomFactor := 200.0;
  end else begin
    FZoomFactor := Value;
  end; { else }
end;  { SetZoomFactor }

procedure TSystemPreview.InitPreview(BaseReport: TBaseReport);

begin { InitPreview }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If BaseReport is TFilePreview then begin
    With BaseReport as TFilePreview do begin
      GridHoriz := FGridHoriz;
      GridPen := FGridPen;
      GridVert := FGridVert;
      MarginMethod := FMarginMethod;
      MarginPercent := FMarginPercent;
      Monochrome := FMonochrome;
      PagesWide := FPagesWide;
      PagesHigh := FPagesHigh;
      PageInc := FPageInc;
      RulerType := FRulerType;
      ShadowDepth := FShadowDepth;
      ZoomFactor := FZoomFactor;
      ZoomInc := FZoomInc;
    end; { with }
  end; { if }
  {$ENDIF}
end;  { InitPreview }

{*************************************************************************}
{                            class TSystemFiler                           }
{*************************************************************************}

constructor TSystemFiler.Create;

begin { Create }
  inherited Create;

  FAccuracyMethod := amPositioning;
  FFileName := '';
  FStatusFormat := Trans('Generating page %p');
  FStatusText := TStringList.Create;
  FStreamMode := smMemory;
  FStream := nil;
end;  { Create }

destructor TSystemFiler.Destroy;

begin { Destroy }
  FStatusText.Free;

  inherited Destroy;
end;  { Destroy }

procedure TSystemFiler.SetStatusText(Value: TStrings);

begin { SetStatusText }
  FStatusText.Assign(Value);
end;  { SetStatusText }

procedure TSystemFiler.InitFiler(BaseReport: TBaseReport);

begin { InitFiler }
  BaseReport.IgnoreRPTF := IgnoreRPTF;
  If BaseReport is TReportFiler then begin
    With BaseReport as TReportFiler do begin
      AccuracyMethod := FAccuracyMethod;
      FileName := FFileName;
      StatusFormat := FStatusFormat;
      StatusText := FStatusText;
      If FStreamMode = smMemory then begin
        StreamMode := smUser;
      end else begin
        StreamMode := FStreamMode;
      end; { else }
      Stream := FStream;
    end; { with }
  end
    {$IFDEF Linux}
    ;//!!PORT!!
    {$ELSE}
     else if BaseReport is TFilePrinter then begin
    With BaseReport as TFilePrinter do begin
      FileName := FFileName;
      If FStreamMode = smMemory then begin
        StreamMode := smUser;
      end else begin
        StreamMode := FStreamMode;
      end; { else }
      Stream := FStream;
    end; { with }
  end; { else }
  {$ENDIF}
end;  { InitFiler }

end.