unit EntREND;

interface
uses
  RPRender, RPSystem;

type

  TRenderTo = (rtExcel, rtPDF, rtHTML, rtText, rtGIF, rtJPEG, rtBMP, rtEMF, rtWMF);

  TEntRender = class
    private
      TheReportSystem: TReportSystem;
      procedure ResetNativeOutput(Sender: TObject);
    public
      RenderTo : TRenderTo;
      sFilename : string;
      sRepTempFilename : string;
      iNoOfCopies : integer;
      procedure EntRender;
      constructor create;
      destructor destroy; override;
  end;


implementation
uses
  rpDefine, Dialogs, gtRPRRoutines, forms;


constructor TEntRender.create;
begin
  inherited create;
  TheReportSystem := TReportSystem.Create(application.mainform);
  with TheReportSystem do begin
    DefaultDest := rdFile;
    SystemFiler.StreamMode := smFile;
    SystemOptions := [soPreviewModal, soNoGenerate];
    SystemPrinter.Units := unMM;
    SystemSetups := [ssAllowDestFile];
  end;{with}
  iNoOfCopies := 1;
end;

destructor TEntRender.destroy;
begin
  TheReportSystem.Free;
  inherited destroy;
end;

procedure TEntRender.EntRender;
begin
  with TheReportSystem do begin
    SystemFiler.FileName := sRepTempFilename;
    SystemPrinter.Copies := iNoOfCopies;

    ReportDest := rdPrinter;
    OnAfterPrint := ResetNativeOutput;

    Case RenderTo of
      rtExcel : RenderToExcel(TheReportSystem, sFilename);
      rtPDF : RenderToPDF(TheReportSystem, sFilename);
      rtHTML : RenderToHTML(TheReportSystem, sFilename);
      rtText : RenderToText(TheReportSystem, sFilename);
      rtGIF : RenderToGIF(TheReportSystem, sFilename);
      rtJPEG : RenderToJPEG(TheReportSystem, sFilename);
      rtBMP : RenderToBMP(TheReportSystem, sFilename);
      rtEMF : RenderToEMF(TheReportSystem, sFilename);
      rtWMF : RenderToWMF(TheReportSystem, sFilename);
    end;{case}
    OnAfterPrint := nil;
  end;{with}
end;

procedure TEntRender.ResetNativeOutput(Sender: TObject);
begin
  TheReportSystem.DoNativeOutput := FALSE;
end;


end.
