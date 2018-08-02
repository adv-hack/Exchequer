unit uVATImport;

interface

uses
  SysUtils,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TVATImport = class(_ImportBase)
  protected
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    function SaveListToDB: Boolean; override;
  end;

implementation

// ===========================================================================
// TVATImport
// ===========================================================================

procedure TVATImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. There is only one
  actual record in the VAT file, but it contains multiple sub-records, one
  for each VAT code. These are combined into a single array in the System
  Settings table. }
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  TempStr: string;
  lVATNode: IXMLDomNode;
  iChild: Integer;
  iArrayElement: VATType;
begin
  ErrorCode := 0;

  { Get the identifier for the VAT record (the System Settings tables holds
    multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[VATR];

  SetDrive := DataPath;

  Clear;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the VAT record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);

    if (FuncRes = 0) then
    begin
      FuncRes := GetPos(F[SysF], SysF, SysAddr[VATR]);
      if (FuncRes = 0) then
      begin
        { Copy the VAT details from the System Settings database buffer into
          the System Settings record structure... }
        Move(Syss, SyssVAT^, Sizeof(SyssVAT^));

        { Read the basic VAT details from the XML node. }
        SyssVAT.IDCode                    := SysNames[VATR];
        SyssVAT.VATRates.VATInterval      := _GetNodeValue(pNode, 'svintervalmonths');
        TempStr := _GetNodeValue(pNode, 'svscheme');
        if (Length(TempStr) > 0) then
          SyssVAT.VATRates.VATScheme        := TempStr[1];
        SyssVAT.VATRates.VATReturnDate    := _GetNodeValue(pNode, 'svlastreturndate');
        SyssVAT.VATRates.CurrPeriod       := _GetNodeValue(pNode, 'svcurrentperiod');
        SyssVAT.VATRates.LastECSalesDate  := _GetNodeValue(pNode, 'svlastecsalesdate');
        SyssVAT.VATRates.OLastECSalesDate := _GetNodeValue(pNode, 'svolastecsalesdate');

        { Copy the VAT rate details from the child nodes to the VAT array,
          overwriting any existing details. If we run out of array elements,
          log this as an error. }
        iArrayElement := Low(SyssVAT.VATRates.VAT);
        for iChild := 0 to pNode.childNodes.length - 1 do
        begin
          lVATNode := pNode.childNodes[iChild];
          if (lVATNode.nodeName = 'vatrate') then
          begin
            TempStr := _GetNodeValue(lVATNode, 'svcode');
            if (Length(TempStr) > 0) then
              SyssVAT.VATRAtes.VAT[iArrayElement].Code := TempStr[1];
            SyssVAT.VATRAtes.VAT[iArrayElement].Desc := _GetNodeValue(lVATNode, 'svdesc');
            SyssVAT.VATRAtes.VAT[iArrayElement].Rate := _GetNodeValue(lVATNode, 'svrate');
            if (iArrayElement = High(SyssVAT.VATRates.VAT)) then
            begin
              if (iChild < pNode.childNodes.length - 1) then
              begin
                ErrorCode := cXMLDATAMISMATCH;
                break;
              end;
            end
            else
              inc(iArrayElement);
          end;
        end;

      end
      else
        ErrorCode := cEXCHLOADINGVALUEERROR;
    end
    else
      ErrorCode := cEXCHLOADINGVALUEERROR;

  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TVATExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));


end;

// ---------------------------------------------------------------------------

function TVATImport.SaveListToDB: Boolean;
var
  FuncRes: LongInt;
begin
  Result := True;
  { Write the System Settings VAT details back to the database. }
  Move(SyssVAT^, Syss, Sizeof(Syss));
  FuncRes := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TVATImport.WriteDetails', cUPDATINGDBERROR);
    Result := False;
  end;
end;

// ---------------------------------------------------------------------------

end.
