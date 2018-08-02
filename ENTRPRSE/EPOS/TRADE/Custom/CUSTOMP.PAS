unit CustomP;

interface
uses
  SysUtils, VarConst, EnterpriseTrade_TLB;

const
  sCustomisationVersion = 'v5.00.001';
  CURRENT_LINE = -1;
  NEW_LINE = -2;

  TKDocTypeVal : Array[DocTypes] of SmallInt =
               //  SIN,   SRC,   SCR,   SJI    SJC,   SRF,   SRI,   SQU,
                  (dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI, dtSQU,
               //  SOR    SDN,   SBT    SDG    NDG    OVT    DEB    PIN,
                   dtSOR, dtSDN, dtSBT, -1,    -1,    -1,    -1,    dtPIN,
               // PPY     PCR    PJI    PJC    PRF    PPI    PQU,   POR,
                  dtPPY,  dtPCR, dtPJI, dtPJC, dtPRF, dtPPI, dtPQU, dtPOR,
               // PDN,    PBT,   SDT,   NDT,   IVT,   CRE,   NOM,   RUN,
                  dtPDN,  dtPBT, -1,    -1,    -1,    -1,    dtNMT, -1,
               // FOL,    AFL,   ADC,   ADJ,   ACQ,   API,   SKF,   JBF,
                  -1,     -1,    -1,    dtADJ, -1,    -1,     -1,    -1,
               // WOR,    TSH,   JRN,   WIN,   SRN,   PRN  ?   ?   ?   ?   ?
                  dtWOR,  dtTSH, -1,    -1,    -1,    -1,  -1, -1, -1, -1, -1);

type
  EUnknownValue = Class(Exception);
  EValidation = Class(Exception);
  ERightsError = Exception;

  Function CustomSetString(sSet : WideString; sValue : WideString; var bDatachanged : boolean) : WideString;
  Function CustomSetReal(rSet : Real; rValue : Real; var bDatachanged : boolean) : Real;
  Function CustomSetInteger(iSet : integer; iValue : integer; var bDatachanged : boolean) : integer;
  Function CustomSetBoolean(bSet : boolean; bValue : boolean; var bDatachanged : boolean) : boolean;
  Function CustomSetVariant(vSet : OleVariant; vValue : OleVariant; var bDatachanged : boolean) : OleVariant;
  Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;

  Function TKDocTypeToTLBDocType(TKDocType : ShortString) : TTradeDocTypes;
  Function TKDocTypeToEntDocType (TKDocType : ShortString) : DocTypes;

implementation
uses
  EPOSProc;

Function CustomSetString(sSet : WideString; sValue : WideString; var bDatachanged : boolean) : WideString;
begin
  if sValue = sSet then Result := sSet
  else begin
    Result := sValue;
    bDatachanged := True;
  end;{if}
end;

Function CustomSetReal(rSet : Real; rValue : Real; var bDatachanged : boolean) : Real;
begin
  if rValue = rSet then Result := rSet
  else begin
    Result := rValue;
    bDatachanged := True;
  end;{if}
end;

Function CustomSetInteger(iSet : integer; iValue : integer; var bDatachanged : boolean) : integer;
begin
  if iValue = iSet then Result := iSet
  else begin
    Result := iValue;
    bDatachanged := True;
  end;{if}
end;

Function CustomSetBoolean(bSet : boolean; bValue : boolean; var bDatachanged : boolean) : boolean;
begin
  if bValue = bSet then Result := bSet
  else begin
    Result := bValue;
    bDatachanged := True;
  end;{if}
end;

Function CustomSetVariant(vSet : OleVariant; vValue : OleVariant; var bDatachanged : boolean) : OleVariant;
begin
  if vValue = vSet then Result := vSet
  else begin
    Result := vValue;
    bDatachanged := True;
  end;{if}
end;

// Extracts a single character from a COM WideString, Returns specified character if ''
Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;
Var
  S : String[1];
Begin { ExtractChar }
  S := Copy (Value, 1, 1) + ReturnChar;
  Result := S[1];
End; { ExtractChar }


Function TKDocTypeToTLBDocType(TKDocType : ShortString) : TTradeDocTypes;
Begin { TKDocTypeToTLBDocType }
  Result := TKDocTypeVal[TKDocTypeToEntDocType (TKDocType)];
End; { TKDocTypeToTLBDocType }

Function TKDocTypeToEntDocType (TKDocType : ShortString) : DocTypes;
Var
  Found : Boolean;
  I     : DocTypes;
Begin { TKDocTypeToEntDocType }
  Found := False;

  // Convert to uppercase, etc... to give comparison best chance
  TKDocType := UpperCase(Trim(TKDocType));

  // Run through Enterprise DocCodes list looking for matching code
  For I := Low(DocCodes) To High(DocCodes) Do
    If (DocCodes[I] = TKDocType) Then Begin
      // Return Enterprise DocType
      Result := I;
      Found := True;
      Break;
    End; { If (DocCodes[I] = TKDocType) }

  If (Not Found) Then
    // No TLB Code found
    Raise EUnknownValue.Create ('Invalid Document Type (' + TKDocType + ')');
End; { TKDocTypeToEntDocType }



end.
