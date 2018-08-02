unit oPrntJo2;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, EnterpriseForms_TLB,
     ExceptIntf;

Type
  TPrinterStringArray = class(TAutoIntfObjectEx, IStringArray)
  private
    FFTKPrinterStrings : IEFStringList;
  protected
    // IStringArray
    function Get_Strings(Index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
  public
    Constructor Create (Const FTKPrinterStrings : IEFStringList);
    Destructor Destroy; override;
  End; { TPrinterStringArray }

  //--------------------------------------------------------------

  TPrinterDetail = class(TAutoIntfObjectEx, IPrinterDetail)
  private
    // Printer Detail Interface from Form Printing Toolkit
    FFTKPrinterDetail : IEFPrinterDetail;

    // Sub-object wrapper for Papers string list
    FPapersO : TPrinterStringArray;
    FPapersI : IStringArray;

    // Sub-object wrapper for Bins string list
    FBinsO   : TPrinterStringArray;
    FBinsI   : IStringArray;
  protected
    // IPrinterDetail
    function Get_pdName: WideString; safecall;
    function Get_pdDefaultPaper: Integer; safecall;
    function Get_pdDefaultBin: Integer; safecall;
    function Get_pdSupportsPapers: WordBool; safecall;
    function Get_pdSupportsBins: WordBool; safecall;
    function Get_pdPapers: IStringArray; safecall;
    function Get_pdBins: IStringArray; safecall;
  public
    Constructor Create (Const FTKPrinterDetail : IEFPrinterDetail);
    Destructor Destroy; override;
  End; { TPrinterDetail }

  //--------------------------------------------------------------

  TPrintJobPrinterInfo = class(TAutoIntfObjectEx, IPrintJobPrinterInfo)
  private
    // Printers Interface from Form Printing Toolkit
    FFTKPrinters : IEFPrinters;
    FFTKPrintJob : IEFPrintJobDetails;

    // Printers List
    FPrinterDetail : TList;
  protected
    // IPrintJobPrinterInfo
    function Get_prCount: Integer; safecall;
    function Get_prPrinters(Index: Integer): IPrinterDetail; safecall;
    function Get_prDefaultPrinter: Integer; safecall;
    function Get_prPrinterIndex: Integer; safecall;
    procedure Set_prPrinterIndex(Value: Integer); safecall;
    function Get_prBinIndex: Integer; safecall;
    procedure Set_prBinIndex(Value: Integer); safecall;
    function Get_prPaperIndex: Integer; safecall;
    procedure Set_prPaperIndex(Value: Integer); safecall;
    function PrinterSetupDialog: WordBool; safecall;
  public
    Constructor Create (Const FTKPrintJob : IEFPrintJobDetails; Const FTKPrinters : IEFPrinters);
    Destructor Destroy; override;
  End; { TPrintJobPrinterInfo }

implementation

Uses ComServ, MiscFunc;

Type
  TPrinterDetailRecType = Record
    iPrinterDetail  : IPrinterDetail;
    oPrinterDetail  : TPrinterDetail;
  End; { TPrinterDetailRecType }

//------------------------------------------------------------------------

Constructor TPrinterStringArray.Create (Const FTKPrinterStrings : IEFStringList);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IStringArray);

  FFTKPrinterStrings := FTKPrinterStrings;
End; { Create }

//----------------------------------------

Destructor TPrinterStringArray.Destroy;
Begin { Destroy }
  FFTKPrinterStrings := NIL;

  inherited Destroy;
End; { Destroy }

//----------------------------------------

function TPrinterStringArray.Get_Strings(Index: Integer): WideString;
Begin
  Result := FFTKPrinterStrings.Strings[Index];
End;

//----------------------------------------

function TPrinterStringArray.Get_Count: Integer; safecall;
Begin
  Result := FFTKPrinterStrings.Count;
End;

//------------------------------------------------------------------------

Constructor TPrinterDetail.Create (Const FTKPrinterDetail : IEFPrinterDetail);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrinterDetail);

  // Printer Detail Interface from Form Printing toolkit
  FFTKPrinterDetail := FTKPrinterDetail;

  // Sub-object wrapper for Papers string list
  FPapersO := TPrinterStringArray.Create(FTKPrinterDetail.pdPapers);
  FPapersI := FPapersO;

  // Sub-object wrapper for Bins string list
  FBinsO   := TPrinterStringArray.Create(FTKPrinterDetail.pdBins);
  FBinsI   := FBinsO;
End; { Create }

//----------------------------------------

Destructor TPrinterDetail.Destroy;
Begin { Destroy }
  // Sub-object wrapper for Papers string list
  FPapersO := NIL;
  FPapersI := NIL;

  // Sub-object wrapper for Bins string list
  FBinsO   := NIL;
  FBinsI   := NIL;

  // Printer Detail Interface from Form Printing toolkit
  FFTKPrinterDetail := NIL;

  inherited Destroy;
End; { Destroy }

//------------------------------------------------------------------------

function TPrinterDetail.Get_pdBins: IStringArray;
begin
  Result := FBinsI;
end;

function TPrinterDetail.Get_pdDefaultBin: Integer;
begin
  Result := FFTKPrinterDetail.pdDefaultBin;
end;

function TPrinterDetail.Get_pdDefaultPaper: Integer;
begin
  Result := FFTKPrinterDetail.pdDefaultPaper;
end;

function TPrinterDetail.Get_pdName: WideString;
begin
  Result := FFTKPrinterDetail.pdName;
end;

function TPrinterDetail.Get_pdPapers: IStringArray;
begin
  Result := FPapersI;
end;

function TPrinterDetail.Get_pdSupportsBins: WordBool;
begin
  Result := FFTKPrinterDetail.pdSupportsBins;
end;

function TPrinterDetail.Get_pdSupportsPapers: WordBool;
begin
  Result := FFTKPrinterDetail.pdSupportsPapers;
end;

//------------------------------------------------------------------------

Constructor TPrintJobPrinterInfo.Create (Const FTKPrintJob : IEFPrintJobDetails; Const FTKPrinters : IEFPrinters);
Var
  PrinterDets : ^TPrinterDetailRecType;
  I           : SmallInt;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobPrinterInfo);

  FFTKPrinters := FTKPrinters;
  FFTKPrintJob := FTKPrintJob;

  // Create sub-objects for Printers/Bins/Papers
  FPrinterDetail := TList.Create;
  If (FTKPrinters.prCount > 0) Then
    For I := 1 To FTKPrinters.prCount Do Begin
      New(PrinterDets);
      With PrinterDets^ Do Begin
        oPrinterDetail := TPrinterDetail.Create(FTKPrinters.prPrinters[I]);
        iPrinterDetail := oPrinterDetail;
      End; { With PrinterDets^ }

      FPrinterDetail.Add(PrinterDets);
    End; { For I }


End; { Create }

//----------------------------------------

Destructor TPrintJobPrinterInfo.Destroy;
Var
  PrinterDets : ^TPrinterDetailRecType;
Begin { Destroy }
  FFTKPrinters := NIL;
  FFTKPrintJob := NIL;

  If Assigned(FPrinterDetail) Then
    While (FPrinterDetail.Count > 0) Do Begin
      // Extract details from list and free all objects/memory
      PrinterDets := Pointer(FPrinterDetail.Items[0]);
      PrinterDets^.iPrinterDetail := NIL;
      Dispose(PrinterDets);

      FPrinterDetail.Delete (0);
    End; { While (FPrinterDetail.Count > 0) }
  FreeAndNIL(FPrinterDetail);

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TPrintJobPrinterInfo.Get_prPrinterIndex: Integer;
begin
  Result := FFTKPrintJob.pjPrinterIndex;
end;

procedure TPrintJobPrinterInfo.Set_prPrinterIndex(Value: Integer);
begin
  FFTKPrintJob.pjPrinterIndex := Value;
end;

//----------------------------------------

function TPrintJobPrinterInfo.Get_prPrinters(Index: Integer): IPrinterDetail;
Var
  PrinterDets : ^TPrinterDetailRecType;
begin
  If Assigned(FPrinterDetail) Then Begin
    // Check Index is within valid range
    If (Index >= 1) And (Index <= FPrinterDetail.Count) Then Begin
      // Extract printer details from list and return interface
      PrinterDets := Pointer(FPrinterDetail.Items[Index - 1]);
      Result := PrinterDets^.iPrinterDetail;
    End { If (Index >= 1) And ... }
    Else
      // Error - Index out of valid range
      Raise EInvalidIndex.Create ('Invalid prPrinter Index (' + IntToStr(Index) + ')');
  End; { If Assigned(FPrinterDetail) }
end;

//----------------------------------------

function TPrintJobPrinterInfo.Get_prBinIndex: Integer;
begin
  Result := FFTKPrintJob.pjBinIndex;
end;

procedure TPrintJobPrinterInfo.Set_prBinIndex(Value: Integer);
begin
  FFTKPrintJob.pjBinIndex := Value;
end;

//----------------------------------------

function TPrintJobPrinterInfo.Get_prPaperIndex: Integer;
begin
  Result := FFTKPrintJob.pjPaperIndex;
end;

procedure TPrintJobPrinterInfo.Set_prPaperIndex(Value: Integer);
begin
  FFTKPrintJob.pjPaperIndex := Value;
end;

//----------------------------------------

function TPrintJobPrinterInfo.PrinterSetupDialog: WordBool;
begin
  Result := FFTKPrintJob.PrinterSetupDialog;
end;

//----------------------------------------

function TPrintJobPrinterInfo.Get_prCount: Integer;
begin
  Result := FPrinterDetail.Count;
end;

//----------------------------------------

function TPrintJobPrinterInfo.Get_prDefaultPrinter: Integer;
begin
  Result := FFTKPrinters.prDefaultPrinter;
end;

//----------------------------------------

end.
