unit uMatchingImport;

interface

uses
  SysUtils,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
  Enterprise01_TLB,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TMatchingImport = class(_ImportBase)
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
    procedure WriteDetails(pNode: IXMLDOMNode);
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  VarRec2U,
  BtKeys1U,
  EtStrU
  ;

// ============================================================================
// TMatchingImport
// ============================================================================

procedure TMatchingImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes: LongInt;
  ErrorCode: Integer;
begin
  ErrorCode := 0;
  FuncRes   := 0;
  Clear;
(*
  if not isFileOpen then
  begin
    SetDrive := DataPath;
    Clear;
    { Open the file. }
    FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    if (FuncRes = 0) then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
  end;
*)
  if (ErrorCode = 0) then
  begin
    { Import the details from the XML file. }
    WriteDetails(pNode);
  end;

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TMatchingImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TMatchingImport.AddRecord', ErrorCode);
  end;
end;

// ----------------------------------------------------------------------------

constructor TMatchingImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ----------------------------------------------------------------------------

destructor TMatchingImport.Destroy;
begin
  inherited;
end;

function TMatchingImport.SaveListToDB: Boolean;
begin
  Result := True;
end;

// ----------------------------------------------------------------------------

procedure TMatchingImport.WriteDetails(pNode: IXMLDOMNode);

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

  function BuildSearchKey: ShortString;
  begin
    Result := FullMatchKey('T',
                           MatchingSubType(_GetNodeValue(pNode, 'maType')),
                           _GetNodeValue(pNode, 'maDocRef'));
  end;

  function FindMatching(BaseKey, PayRef: ShortString): Boolean;
  var
    FuncRes: LongInt;
    SearchKey: ShortString;
  begin
    Result := False;
    SearchKey := BaseKey;
    PayRef := LJVar(PayRef, 10);
    FuncRes := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, SearchKey);
    while (FuncRes = 0) and (Copy(SearchKey, 1, Length(BaseKey)) = BaseKey) do
    begin
      if (PayRef = Password.MatchPayRec.PayRef) then
      begin
        Result := True;
        break;
      end;
      FuncRes := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, SearchKey);
    end;
  end;

var
  Key: ShortString;
  RecordExists: Boolean;
  MatchingType: Integer;
  FuncRes: Integer;
begin
  { Build a search key. }
  Key := BuildSearchKey;

  { Try to locate a matching record. }
  RecordExists := FindMatching(Key, LJVar(_GetNodeValue(pNode, 'maPayRef'), 12));

  { Fill in the details. }
  Password.RecPfix := 'T';
  MatchingType := _GetNodeValue(pNode, 'maType');
  Password.SubType := MatchingSubType(MatchingType);
  with Password.MatchPayRec do
  begin
    DocCode    := LJVar(_GetNodeValue(pNode, 'maDocRef'), 12);
    PayRef     := LJVar(_GetNodeValue(pNode, 'maPayRef'), 10);
    SettledVal := _GetNodeValue(pNode, 'maBaseValue');
    OwnCVal    := _GetNodeValue(pNode, 'maDocValue');
    MCurrency  := _GetNodeValue(pNode, 'maDocCurrency');
    AltRef     := _GetNodeValue(pNode, 'maDocYourRef');
    RCurrency  := _GetNodeValue(pNode, 'maPayCurrency');
    RecOwnCVal := _GetNodeValue(pNode, 'maPayValue');
    case MatchingType of
      maTypeFinancial: MatchType := 'A';
      maTypeSPOP:      MatchType := 'O';
    else
      MatchType := Password.SubType;
    end;
  end;

  if (RecordExists) then
    { If a record was found, update the existing details... }
    FuncRes := Put_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0)
  else
    { ...otherwise add a new record. }
    FuncRes := Add_Rec(F[PwrdF], Pwrdf, RecPtr[PwrdF]^, 0);

end;

// ----------------------------------------------------------------------------

end.
