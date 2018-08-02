unit PPayProc;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  CustABSU, Enterprise01_TLB, PromptPayBTFile;

const
  SHF_HELD = 'PP HOLD';

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  function GetToValue(sLCustCode : string; rFromValue : real; bIncludeTo : boolean
  ;bFirst : boolean = FALSE) : string;
  function GetNextFolioNo(iFileNo : integer) : integer;
  procedure SetSecondHoldFlag(TX : ITransaction2; PPSetupRec : TPPSetupRec);
  procedure ReportTXSaveError(iError : integer);
  procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
  function GetSecondHoldFlag(TX : ITransaction2; PPSetupRec : TPPSetupRec) : string;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;

implementation
uses
  SecCodes, Dialogs, BTConst, SysUtils, BTUtil, StrUtil, APIUtil, COMObj;

function GetToValue(sLCustCode : string; rFromValue : real; bIncludeTo : boolean
;bFirst : boolean = FALSE) : string;
var
  PPDebtRec : TPPDebtRec;
  KeyS : TStr255;
  iStatus : integer;
begin{GetToValue}
  Result := 'Upwards';
  if not bFirst then begin
    KeyS := sLCustCode + BT_MinDoubleKey;
    iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
    , ppdValueFromIdx, KeyS);
    while (iStatus = 0) and (sLCustCode = PPDebtRec.ppdCustCode) do begin
      if PPDebtRec.ppdValueFrom > rFromValue then
      begin
        if bIncludeTo then Result := 'to : ' + MoneyToStr(PPDebtRec.ppdValueFrom)
        else Result := MoneyToStr(PPDebtRec.ppdValueFrom);
        iStatus := 4;
      end else
      begin
        iStatus := BTFindRecord(BT_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
        , ppdValueFromIdx, KeyS);
      end;{if}
    end;{while}
  end;{if}
end;{GetToValue}

function GetNextFolioNo(iFileNo : integer) : integer;
var
  KeyS : TStr255;
  PPDebtRec : TPPDebtRec;
  iStatus, iNextFolio : LongInt;
begin
  // get original record
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;
  case iFileNo of
    PPDebtF : begin
      iStatus := BTFindRecord(BT_GetLast, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdFolioNoIdx, KeyS);
      if iStatus = 0 then iNextFolio := PPDebtRec.ppdFolioNo + 1;
    end;
  end;{case}

  Result := iNextFolio;

  if not (iStatus in [0,4,9])
  then BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppCustF]);
end;

procedure SetSecondHoldFlag(TX : ITransaction2; PPSetupRec : TPPSetupRec);

  function UpdateUserDefField(sField : WideString) : string;
  begin{UpdateUserDefField}
    if Trim(sField) = SHF_HELD then Result := ''
    else Result := SHF_HELD;
  end;{UpdateUserDefField}

begin{SetSecondHoldFlag}
  with TX do begin
    case PPSetupRec.ppsHoldFlagField of
      1 : thUserField1 := UpdateUserDefField(thUserField1);
      2 : thUserField2 := UpdateUserDefField(thUserField2);
      3 : thUserField3 := UpdateUserDefField(thUserField3);
      4 : thUserField4 := UpdateUserDefField(thUserField4);
    end;{case}
  end;{with}
end;{setSecondHoldFlag}

procedure ReportTXSaveError(iError : integer);
begin
  if iError <> 0 then
  begin
    MsgBox('The following error has occurred when trying to save an ITransaction2 Object'
    + #13#13 + 'Error ' + IntToStr(iError) + #13#13 + oToolkit.LastErrorString
    , mtError, [mbOK], mbOK, 'ITransaction2 Save Error');
  end;
end;

procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
var
  a, b, c : LongInt;
  FuncRes : integer;

(*    procedure DoUpdates;
  var
    iLine, iStatus : integer;
  begin{DoUpdates}
    with oToolkit, Transaction do begin
      Index := thIdxOurRef;
      iStatus := GetGreaterThanOrEqual(BuildOurRefIndex('SDN000000'));
      while (iStatus = 0) and (Copy(thOurRef,1,3) = 'SDN') do begin
//          showmessage(thOurRef);
        if transaction.thHoldFlag in [0,32,128,160] then begin
          with transaction.Update do begin
            For iLine := 1 to thLines.thLineCount do begin
              if (Trim(thLines.thLine[iLine].tlUserField1) = '') then
              begin
                // update normal prices (no weight)

                // get normal price
                with thLines.add do begin
                  tlStockCode := thLines.thLine[iLine].tlStockCode;
                  tlQty := thLines.thLine[iLine].tlQty;
                  importdefaults;
                  thLines.thLine[iLine].tlNetValue := tlNetValue;
                end;{with}

              end else
              begin
                // update prices for weighted items
                if (not ZeroFloat(thLines.thLine[iLine].tlQty)) then
                begin
                  // get normal price
                  with thLines.add do begin
                    tlStockCode := thLines.thLine[iLine].tlStockCode;
                    tlQty := thLines.thLine[iLine].tlQty;
                    importdefaults;
                    thLines.thLine[iLine].tlUserField2 := FloatToStrF(tlNetValue, ffFixed
                    , 15, Eventdata.Setup.ssNoNetDec);
                  end;{with}

                  // calculate price for a weighted item
                  with thLines.thLine[iLine] do begin
  //                  tlUserField2 := FloatToStrF(tlNetValue, ffFixed
  //                  , 15, Eventdata.Setup.ssNoNetDec);
                    tlNetValue := SimpleRoundTo((StrToFloatDef(tlUserField1, 0)
                    * StrToFloatDef(tlUserField2, 0)) / tlQty, -Eventdata.Setup.ssNoNetDec);
                  end;{with}
                end;{if}
              end;{if}
            end;{for}
            save(TRUE);
          end;{with}
        end;{if}
        iStatus := GetNext;
      end;{while}
    end;
    MsgBox('Update Completed',mtInformation,[mbOK],mbOK,'Update Prices');
  end;{DoUpdates}*)

begin{StartToolkit}
  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    With oToolkit Do Begin
      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);

      // Open Default Company
      oToolkit.Configuration.DataDirectory := LEventData.Setup.ssDataPath;
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      FuncRes := OpenToolkit;

      // Check it opened OK
      If (FuncRes = 0) then {DoUpdates}
      else begin
        // Error opening Toolkit - display error
        ShowMessage ('The following error occured opening the Toolkit:-'#13#13
        + QuotedStr(oToolkit.LastErrorString));
      end;{if}

    End; { With OToolkit }

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');

end;{StartToolkit}

function GetSecondHoldFlag(TX : ITransaction2; PPSetupRec : TPPSetupRec) : string;
begin{GetSecondHoldFlag}
  with TX do begin
    case PPSetupRec.ppsHoldFlagField of
      1 : Result := thUserField1;
      2 : Result := thUserField2;
      3 : Result := thUserField3;
      4 : Result := thUserField4;
    end;{case}
  end;{with}
end;{GetSecondHoldFlag}




end.
