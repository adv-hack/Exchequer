unit oPrinters;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, oStrList;

type
  TEFPrinterDetail = class(TAutoIntfObject, IEFPrinterDetail)
  private
    // Printer Index within RPDev for this set of Printer Details
    FPrinterIndex   : Integer;
    FPrinterName    : ShortString;
    FDefaultPaper   : Integer;
    FDefaultBin     : Integer;
    FSupportsPapers : Boolean;
    FSupportsBins   : Boolean;

    // Papers sub-object
    FPapersList     : TStringList;
    FPapersO        : TEFStringListReadOnly;
    FPapersI        : IEFStringListReadOnly;

    // bins sub-object
    FBinsList       : TStringList;
    FBinsO          : TEFStringListReadOnly;
    FBinsI          : IEFStringListReadOnly;
  protected
    // IEFPrinterDetail
    function Get_pdName: WideString; safecall;
    function Get_pdDefaultPaper: Integer; safecall;
    function Get_pdDefaultBin: Integer; safecall;
    function Get_pdSupportsPapers: WordBool; safecall;
    function Get_pdSupportsBins: WordBool; safecall;
    function Get_pdPapers: IEFStringListReadOnly; safecall;
    function Get_pdBins: IEFStringListReadOnly; safecall;

    // Local Methods
    Procedure InitObjs;
  public
    Constructor Create (Const PrinterIndex : Integer);
    Destructor Destroy; override;
  End; { TEFPrinterDetail }

  //-----------------------------------------------------------

  TEFPrinters = class(TAutoIntfObject, IEFPrinters)
  private
    FPrinterDetail  : TList;
    FDefaultPrinter : Integer;
  protected
    // IEFPrinters
    function Get_prPrinters(Index: Integer): IEFPrinterDetail; safecall;
    function Get_prCount: Integer; safecall;
    function Get_prDefaultPrinter: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
  public
    Constructor Create;
    Destructor Destroy; override;
  End; { TEFPrinters }

implementation

uses ComServ, MiscFunc, RPDevice, LogUtil;

Type
  TPrinterDetailRecType = Record
    oPrinterDetail  : TEFPrinterDetail;
    iPrinterDetail  : IEFPrinterDetail;
  End; { TPrinterDetailRecType }

//-----------------------------------------------------------------------------

constructor TEFPrinterDetail.Create (Const PrinterIndex : Integer);
begin
  OutputDebug('TEFPrinterDetail.Create Start PrinterIndex=' + IntToStr(PrinterIndex));
  Inherited Create (ComServer.TypeLib, IEFPrinterDetail);

  InitObjs;

  With RpDev Do Begin
    FPrinterIndex := PrinterIndex;
    FPrinterName  := Printers[PrinterIndex];
    OutputDebug('TEFPrinterDetail.Create PrinterName=' + FPrinterName);
    // Change active printer to load the correct paper/bin details
    DeviceIndex := PrinterIndex;

    // MH 16/02/2016 2016-R1 ABSEXCH-17241: Copied ABSEXCH-17237 mods to handle a NIL DevMode
    FBinsList := TStringList.Create;
    FPapersList := TStringList.Create;

    // MH 16/02/2016 2016-R1 ABSEXCH-17241: Copied ABSEXCH-17237 mods to handle a NIL DevMode
    If Assigned (DevMode) Then
    Begin
      FSupportsPapers := ((DevMode.dmFields And DM_PAPERSIZE) = DM_PAPERSIZE);
      FSupportsBins   := ((DevMode.dmFields And DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE);

      // Get default Paper and Bin
      If FSupportsPapers Then
      Begin
        OutputDebug('TEFPrinterDetail.Create SupportsPapers');

        // HM 11/11/03: Extended to detect no default
        FDefaultPaper := WalkListIdx(Papers, DevMode^.dmPaperSize) + 1;
        If (FDefaultPaper = 0) And (Papers.Count > 0) Then
        Begin
          FDefaultPaper := 1;
        End; // If (FDefaultPaper = 0) And (Papers.Count > 0)
      End // If FSupportsPapers
      Else
        FDefaultPaper := 0;

      If FSupportsBins Then
      Begin
        OutputDebug('TEFPrinterDetail.Create SupportsBins');
        // HM 11/11/03: Extended to detect no default
        FDefaultBin := WalkListIdx(Bins, DevMode.dmDefaultSource) + 1;
        If (FDefaultBin = 0) And (Bins.Count > 0) Then
        Begin
          FDefaultBin := 1;
        End; // If (FDefaultBin = 0) And (Papers.Count > 0)
      End // If FSupportsBins
      Else
        FDefaultBin := 0;

      // Copy Bins
      FBinsList.Assign (Bins);

      // Copy Papers
      FPapersList.Assign (Papers);
    End // If Assigned (DevMode)
    Else
    Begin
      FSupportsPapers := False;
      FSupportsBins   := False;
      FDefaultPaper := 0;
      FDefaultBin := 0;
    End; // Else
  End; { With RpDev }
  OutputDebug('TEFPrinterDetail.Create End');
end;

//----------------------------------------

destructor TEFPrinterDetail.Destroy;
begin
  InitObjs;

  FreeAndNIL(FBinsList);
  FreeAndNIL(FPapersList);

  inherited;
end;

//----------------------------------------

Procedure TEFPrinterDetail.InitObjs;
Begin { InitObjs }
  // Papers sub-object
  FPapersO := NIL;
  FPapersI := NIL;

  // Bins sub-object
  FBinsO := NIL;
  FBinsI := NIL;
End; { InitObjs }

//----------------------------------------

function TEFPrinterDetail.Get_pdBins: IEFStringListReadOnly;
begin
  If (Not Assigned(FBinsO)) Then Begin
    // Create and initialise the Bins StringList sub-object
    FBinsO := TEFStringListReadOnly.Create(FBinsList);

    FBinsI := FBinsO;
  End; { If (Not Assigned(FBinsO)) }

  Result := FBinsI;
end;

//----------------------------------------

function TEFPrinterDetail.Get_pdName: WideString;
begin
  Result := FPrinterName;
end;

//----------------------------------------

function TEFPrinterDetail.Get_pdPapers: IEFStringListReadOnly;
begin
  If (Not Assigned(FPapersO)) Then Begin
    // Create and initialise the Bins StringList sub-object
    FPapersO := TEFStringListReadOnly.Create(FPapersList);

    FPapersI := FPapersO;
  End; { If (Not Assigned(FPapersO)) }

  Result := FPapersI;
end;

//----------------------------------------

function TEFPrinterDetail.Get_pdDefaultBin: Integer;
begin
  Result := FDefaultBin
end;

//----------------------------------------

function TEFPrinterDetail.Get_pdDefaultPaper: Integer;
begin
  Result := FDefaultPaper;
end;

//----------------------------------------

function TEFPrinterDetail.Get_pdSupportsBins: WordBool;
begin
  Result := FSupportsBins;
end;

function TEFPrinterDetail.Get_pdSupportsPapers: WordBool;
begin
  Result := FSupportsPapers;
end;

//-----------------------------------------------------------------------------

Constructor TEFPrinters.Create;
Var
  PrinterDets : ^TPrinterDetailRecType;
  I           : SmallInt;
Begin { Create }
  OutputDebug('TEFPrinters.Create Start');

  Inherited Create (ComServer.TypeLib, IEFPrinters);

  // Create a TList to store the printer detail objects
  FPrinterDetail := TList.Create;

  // Check at leat one printer installed on workstation
  If (RpDev.Printers.Count > 0) Then
  Begin
    // MH 11/09/2015 2016R1 ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9
    //Try
      // Identify default printer
      RpDev.DeviceIndex := -1;
      FDefaultPrinter := RpDev.DeviceIndex + 1;

      // Run through the list of printers creating the sub-objects
      For I := 0 To Pred(RpDev.Printers.Count) Do
      Begin
        // MH 11/09/2015 2016R1 ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9
        //Try
          New(PrinterDets);
          With PrinterDets^ Do
          Begin
            oPrinterDetail := TEFPrinterDetail.Create(I);
            iPrinterDetail := oPrinterDetail;
          End; { With PrinterDets^ }

          FPrinterDetail.Add(PrinterDets);
        // MH 11/09/2015 2016R1 ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9
        //Except
        //  On E:Exception Do
        //    ShowMessage ('The following error occurred whilst loading the details for printer ' + IntToStr(I + 1) +
        //                 ':-'#13#13 + E.Message);
        //End;
      End; { For I }
    // MH 11/09/2015 2016R1 ABSEXCH-16847: Copied ABSEXCH-16828 mods to removed popup error message from v7.0.9
    //Except
    //  On E:Exception Do
    //    ShowMessage ('The following error occurred whilst loading the list of printers:-'#13#13 + E.Message);
    //End;
    OutputDebug('TEFPrinters.Create End');
  End { If (RpDev.Printers.Count > 0) }
  Else
    Raise Exception.Create ('The Exchequer Form Printing Toolkit requires at least one printer to be installed on the workstation');
End; { Create }

//----------------------------------------

Destructor TEFPrinters.Destroy;
Var
  PrinterDets : ^TPrinterDetailRecType;
Begin { Destroy }
  If Assigned(FPrinterDetail) Then
    While (FPrinterDetail.Count > 0) Do Begin
      // Extract details from list and free all objects/memory
      PrinterDets := Pointer(FPrinterDetail.Items[0]);
      With PrinterDets^ Do Begin
        oPrinterDetail := NIL;
        iPrinterDetail := NIL;
      End; { With PrinterDets^ }
      Dispose(PrinterDets);

      FPrinterDetail.Delete (0);
    End; { While (FPrinterDetail.Count > 0) }

  FreeAndNIL(FPrinterDetail);

  inherited Destroy;
End; { Destroy }

//----------------------------------------

function TEFPrinters.Get_prCount: Integer;
begin
  If Assigned(FPrinterDetail) Then
    Result := FPrinterDetail.Count
  Else
    Result := 0;
end;

//----------------------------------------

function TEFPrinters.Get_prDefaultPrinter: Integer;
begin
  Result := FDefaultPrinter;
end;

//----------------------------------------

function TEFPrinters.Get_prPrinters(Index: Integer): IEFPrinterDetail;
Var
  PrinterDets : ^TPrinterDetailRecType;
begin
  If Assigned(FPrinterDetail) Then Begin
    // Check Index is whithin valid range
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

Function TEFPrinters.IndexOf(const SearchText: WideString): Integer;
Var
  PrinterDets : ^TPrinterDetailRecType;
  sText       : ShortString;
  I           : SmallInt;
Begin { IndexOf }
  Result := 0;  // Not found

  // Convert search string to uppercase removing any spaces
  sText := UpperCase(Trim(SearchText));

  If Assigned(FPrinterDetail) Then
    If (FPrinterDetail.Count > 0) Then
      For I := 0 To Pred(FPrinterDetail.Count) Do Begin
        // Extract details from list and free all objects/memory
        PrinterDets := Pointer(FPrinterDetail.Items[I]);
        // Check to see if printer name starts with the specified text
        If (Pos (sText, UpperCase(PrinterDets^.iPrinterDetail.pdName)) = 1) Then Begin
          Result := I + 1;
          Break;
        End ; { If (Pos(... }
      End; { For I }
End; { IndexOf }

//-----------------------------------------------------------------------------


end.
