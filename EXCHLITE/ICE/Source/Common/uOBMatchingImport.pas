unit uOBMatchingImport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  EntLicence,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass,
  uOpeningBalanceDB
  ;

{$I ice.inc}

type
  TOBMatchingImport = class(_ImportBase)
  private
    oTrans: ITransaction3;
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    oToolkit: IToolkit;
    OBCrossRef: TOBCrossReference;
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  GlobVar,
  VarConst,
  BtrvU2,
  EtStrU,
  BtKeys1U
  ;

{ TOBMatchingImport }

procedure TOBMatchingImport.AddRecord(pNode: IXMLDOMNode);
var
  FuncRes: LongInt;
  ErrorCode: LongInt;
  ErrorMsg: string;
begin
  FuncRes   := 0;
  ErrorCode := 0;

  if not isFileOpen then
  begin
    oTrans := oToolkit.Transaction as ITransaction3;
    if Assigned(oTrans) then
      isFileOpen := True
    else
    begin
      ErrorCode := cCONNECTINGDBERROR;
      ErrorMsg  := 'Cannot connect to Toolkit';
    end;
    SetDrive := DataPath;
    { Open the Matching file. }
    FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    if (FuncRes = 0) then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
    if (Errorcode = 0) then
    begin
      { Open the Opening Balance Cross-Reference file }
      FuncRes := Open_File(F[OBRefF], DataPath + FileNames[OBRefF], 0);
      if (FuncRes <> 0) then
        ErrorCode := cCONNECTINGDBERROR;
    end;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TOBMatchingImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TOBMatchingImport.AddRecord', ErrorCode);
  end;
end;

constructor TOBMatchingImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

destructor TOBMatchingImport.Destroy;
begin
  OBCrossRef := nil;
  oToolkit := nil;
  oTrans := nil;
  inherited;
end;

function TOBMatchingImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

function TOBMatchingImport.WriteDetails(Node: IXMLDOMNode): Boolean;

  function MatchingSubType(MatchType: Integer): Char;
  begin
    case MatchType of
      maTypeFinancial:          Result := 'P';
      maTypeSPOP:               Result := 'P';
      maTypeCIS:                Result := 'C';
      maTypeCostApportionment:  Result := '0';
      maTypeUser1:              Result := '1';
      maTypeUser2:              Result := '2';
      maTypeUser3:              Result := '3';
      maTypeUser4:              Result := '4';
    else
      Result := 'P';
    end;
  end;

var
  FuncRes: Integer;
  ActualDocCode, ActualPayRef: Str10;
  OBDocCode, OBPayRef: Str10;
  OBDocValue, OBPayValue: Double;
  OBBaseValue: Double;
  InvTrans: ITransaction;
  Match: IMatching;
begin
  Result := False;
  { Read the Opening Balance Codes, and locate the correct new OurRef values
    from the Opening Balance Cross-Reference file }
  OBDocCode := _GetNodeValue(Node, 'maDocRef');
  OBPayRef  := _GetNodeValue(Node, 'maPayRef');

  OBDocValue := _GetNodeValue(Node, 'maDocValue');
  OBPayValue := _GetNodeValue(Node, 'maPayValue');
  OBBaseValue := _GetNodeValue(Node, 'maBaseValue');

  ActualDocCode := OBCrossRef.OurRef(OBDocCode);
  ActualPayRef  := OBCrossRef.OurRef(OBPayRef);

  if (ActualDocCode <> '') and (ActualPayRef <> '') then
  begin
    // Find invoice transaction
    oTrans.Index := thIdxOurRef;
    FuncRes := oTrans.GetEqual(oTrans.BuildOurRefIndex(ActualDocCode));
    if (FuncRes = 0) then
    begin
      // Take a copy of the invoice transaction
      InvTrans := oTrans.Clone;
      // Find payment transaction
      FuncRes := oTrans.GetEqual(oTrans.BuildOurRefIndex(ActualPayRef));
      if (FuncRes = 0) then
      begin
        // Got payment - match the invoice with the payment
        Match := oTrans.thMatching.Add;
        with Match do
        begin
          begin
            // Copy details from invoice
            maDocRef := InvTrans.thOurRef;
            maDocCurrency := InvTrans.thCurrency;
            maDocValue := OBDocValue; // InvTrans.thTotals[TransTotInCcy];

            // Copy details from payment
            maPayRef := oTrans.thOurRef;
            maPayCurrency := oTrans.thCurrency;
            maPayValue := OBPayValue; // oTrans.thTotals[TransTotInCcy];

            // Generate Base Equivalent of matched amount
            maBaseValue := OBBaseValue; // oToolkit.Functions.entConvertAmount(OBPayValue, maPayCurrency, 0, 0);
          end;
          with Match as IBetaMatching do
            maAllowOverSettling := True;
          FuncRes := Save;
          if (FuncRes <> 0) then
            DoLogMessage('TOBMatchingImport.WriteDetails: ' +
                         OBDocCode + ', ' + OBPayRef + ': ' +
                         'Error matching invoice and payment - ' +
                         oToolkit.LastErrorString,
                         cUPDATINGDBERROR);
        end; { with oTrans.thMatching.Add do... }
      end { if (FuncRes = 0) then... }
      else
        DoLogMessage('TOBMatchingImport.WriteDetails: ' +
                     OBDocCode + ', ' + OBPayRef + ': ' +
                     'Error loading payment details - ' + oToolkit.LastErrorString,
                     cUPDATINGDBERROR);

      // Remove reference to object
      InvTrans := NIL;
    end { if (FuncRes = 0) then... }
    else
      DoLogMessage('TOBMatchingImport.WriteDetails: ' +
                   OBDocCode + ', ' + OBPayRef + ': ' +
                   'Error loading invoice details - ' + oToolkit.LastErrorString,
                   cUPDATINGDBERROR);
  end
  else
    DoLogMessage('TOBMatchingImport.WriteDetails: ' +
                 'Could not locate matching entries for ' +
                 OBDocCode + ', ' + OBPayRef + ' ' +
                 'in Opening Balance Cross Reference file',
                 cUPDATINGDBERROR);
end;

end.
