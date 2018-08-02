unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Math, ComObj, Enterprise01_TLB, APIUtil, CustWinU, CustAbsU, Classes, Controls
  , PISecure, Weight, SecCodes, MathUtil;

var
  iHookId : integer;
  bHookEnabled : boolean;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Dialogs, SysUtils, ChainU, PIMisc, Forms;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
type
  THookPointRec = record
    WindowID : integer;
    HandlerID : integer;
  end;
const
  NO_OF_HOOK_POINTS = 3;
  sPlugInName = 'Custom Weight Plug-In';
  {$IFDEF EX600}
    sVersionNo = 'v6.00.010';
  {$ELSE}
    sVersionNo = 'v5.71.010';
  {$ENDIF}
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHCSTWGT000016', '437am£21 rD"22$%', sPlugInName
  , sVersionNo + ' (DLL)', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With TAbsCustomHandlers01(CustomHandlers) Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      // Detect if Custom button1 is already in use.
      if (not HookPointEnabled(wiTransaction, 14)) then iHookId := 14
      else iHookId := 24;

      // TX Line Exit Qty set netvalue
      aHookPoints[1].WindowID := wiTransLine;
      aHookPoints[1].HandlerID := 12;

      // TX Line B4 Save
      aHookPoints[2].WindowID := wiTransLine;
      aHookPoints[2].HandlerID := 10;

      // Custom Button Sales Order DayBook
      aHookPoints[3].WindowID := wiTransaction;
      aHookPoints[3].HandlerID := iHookId;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do begin
        SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID, EventEnabled);
      end;{for}

      slAboutText.Free;
    End; { With }
  end;{if}

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);

End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  iPos : integer;
  sString : string;

  procedure UpdatePrices;
  var
    a, b, c : LongInt;
    FuncRes : integer;
    oToolkit : IToolkit;

    procedure DoUpdates;
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
    end;{DoUpdates}

  begin{UpdatePrices}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      With oToolkit Do Begin
        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

        // Open Default Company
        oToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
        FuncRes := OpenToolkit;

        // Check it opened OK
        If (FuncRes = 0) then DoUpdates
        else begin
          // Error opening Toolkit - display error
          ShowMessage ('The following error occured opening the Toolkit:-'#13#13
          + QuotedStr(oToolkit.LastErrorString));
        end;{if}

      End; { With OToolkit }

      oToolkit.CloseToolkit;
      oToolkit := NIL;

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');

  end;{UpdatePrices}

Begin
  if bHookEnabled then begin

    { Handle Hook Events here }
    With EventData Do Begin
      // A 'Hook Event' has occured
      Case WinId Of
        wiTransaction : begin
          // Custom Button Sales Order DayBook
          if HandlerId = iHookId then
          begin
  //          Showmessage('2000.' + IntToStr(iHookId));
            Screen.Cursor := crHourglass;
            UpdatePrices;
            Screen.Cursor := crDefault;
          end;
        end;

        wiTransLine {EnterpriseBase + 4000} : begin
          Case HandlerId Of

            // TX Line B4 Save
            10 : begin
              if (transaction.thInvDocHed = cuSOR)
              and (Transaction.thLines.thCurrentLine.tlQtyPicked > 0)
              and (UpperCase(Stock.stStkUser4) = 'WEIGHT')
              then begin
                with TFrmWeight.Create(application) do begin
                  iSalesDecimals := Setup.ssNoNetDec;
                  lQty.caption := FloatToStrF(Transaction.thLines.thCurrentLine.tlQty, ffFixed, 15, Setup.ssNoQtyDec);
                  lPrice.caption := FloatToStrF(Transaction.thLines.thCurrentLine.tlNetValue, ffFixed, 15, Setup.ssNoNetDec);
                  edWeight.Value := StrToFloatDef(Transaction.thLines.thCurrentLine.tlUserDef1, 0);
                  if ShowModal = mrOK
                  then Transaction.thLines.thCurrentLine.tlUserDef1 := edWeight.Text;
                end;{with}
              end;{if}
            end;

            // TX Line Exit Qty set netvalue
            12 : begin
              if (transaction.thInvDocHed = cuSIN)
              and (UpperCase(Stock.stStkUser4) = 'WEIGHT')
              and (Trim(Transaction.thLines.thCurrentLine.tlUserDef1) <> '')
              and (Trim(Transaction.thLines.thCurrentLine.tlUserDef2) <> '')
              and (not ZeroFloat(Transaction.thLines.thCurrentLine.tlQty))
              then begin
                with TFrmWeight.Create(application) do begin
                  iSalesDecimals := Setup.ssNoNetDec;
                  lQty.caption := FloatToStrF(Transaction.thLines.thCurrentLine.tlQty, ffFixed, 15, Setup.ssNoQtyDec);
//                  lPrice.caption := FloatToStrF(Transaction.thLines.thCurrentLine.tlNetValue, ffFixed, 15, Setup.ssNoNetDec);
                  lPrice.caption := Transaction.thLines.thCurrentLine.tlUserDef2;
                  edWeight.Value := StrToFloatDef(Transaction.thLines.thCurrentLine.tlUserDef1, 0);
                  if ShowModal = mrOK
                  then begin
  //                  Showmessage('4000.12');
                    with Transaction.thLines.thCurrentLine do begin
//                      tlUserDef2 := FloatToStrF(tlNetValue, ffFixed, 15, Eventdata.Setup.ssNoNetDec);
                      tlUserDef1 := edWeight.Text;
  //                    tlNetValue := StrToFloatDef(tlUserDef1, 0) * StrToFloatDef(tlUserDef2, 0);
                      tlNetValue := SimpleRoundTo((StrToFloatDef(tlUserDef1, 0)
                      * StrToFloatDef(tlUserDef2, 0)) / tlQty, -Eventdata.Setup.ssNoNetDec);
                    end;{with}
                  end;{if}
                end;{with}
              end;{if}
            end;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
