unit HandlerU;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CustWinU, CustAbsU, Forms, Controls, DelPerProc;

Const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
//  BEFORE_STORE_TX_LINE = 10;
  AFTER_STORE_TX = 170;
  INI_FILENAME = 'DPUSERF.INI';

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem04); Export;


implementation

Uses
  Enterprise01_TLB, StrUtil, INIFiles, Dialogs, SysUtils, ChainU, APIUtil, Classes, PISecure,
  PIMisc, ExchequerRelease;

var
  bHookEnabled : boolean;

Const
  sPlugInName = 'Exchequer Delivery Performance Plug-In';
  {$IFDEF EX600}
    sVersionNo = '006';
  {$ELSE}
    sVersionNo = 'v5.70.005';
  {$ENDIF}
  EventDisabled = 0;
  EventEnabled  = 1;


Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
{ Called by Enterprise to initialise the Customisation }
var
  slAboutText : TStringList;
  iPos : integer;
Begin

  CustomOn := True;

  bHookEnabled := PICheckSecurity('EXCHDELPER000045', '"jk£Tr£t4tdzL(65', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    { Enable Hooks and Set About Message here }
    with TAbsCustomHandlers01(CustomHandlers) do
    begin

      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      // open company hooks
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
      SetHandlerStatus(EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
//      SetHandlerStatus(EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);

      // Before store Tx Line
//      SetHandlerStatus(wiTransLine, BEFORE_STORE_TX_LINE, EventEnabled);
      SetHandlerStatus(wiTransaction, AFTER_STORE_TX, EventEnabled);
    end;{with}

  end;{if}

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

Procedure TermCustomHandler;
{ Called by Enterprise to End the Customisation }
Begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem04);
{ Called by Enterprise whenever a Customised Event happens }
type
  TSystemSetupRec = record
    SalesUDF : byte;
    PurchaseUDF : byte;
    UpdateOnce : boolean;
    sUpdateOnce : String;
  end;

var
  SystemSetup : TSystemSetupRec;

  function ReadINIFile : boolean;
  var
    TheInifile : TInifile;
    sFileName : string;
  begin{ReadINIFile}
    sFileName := IncludeTrailingPathDelimiter(EventData.Setup.ssDataPath) + INI_FILENAME;
    Result := FileExists(sFileName);

    if Result then
    begin
      TheInifile := TInifile.Create(sFileName);
      with SystemSetup do
      begin
        SalesUDF := TheInifile.ReadInteger('Settings','SalesUser',0);
        PurchaseUDF := TheInifile.ReadInteger('Settings','PurchUser',0);
        sUpdateOnce := UpperCase(TheInifile.ReadString('Settings','UpdateOnce','NO'));
        UpdateOnce := (sUpdateOnce = 'YES') or (sUpdateOnce = 'TRUE') or (sUpdateOnce = '1');
      end;{with}
      TheInifile.Free;
    end else
    begin
      MsgBox('Error : INI file not found (' + sFilename + ').',mtError, [mbOK], mbOK, sPlugInName);
    end;{if}
  end;{ReadINIFile}

(*  procedure SetDeliveryDateOnLine(iUDF : byte);

    function UpdateUDF(sField : string; sDate : string) : string;
    begin{UpdateUDF}
      if (SystemSetup.UpdateOnce) and (Trim(sField) <> '')
      then Result := sField
      else Result := sDate;
    end;{UpdateUDF}

  begin{SetDeliveryDateOnLine}
    with EventData.Transaction2.thLines.thCurrentLine do
    begin
      case iUDF of
        1 : tlUserDef1 := UpdateUDF(tlUserDef1, Str8ToScreenDate(tlTransDate));
        2 : tlUserDef2 := UpdateUDF(tlUserDef2, Str8ToScreenDate(tlTransDate));
        3 : tlUserDef3 := UpdateUDF(tlUserDef3, Str8ToScreenDate(tlTransDate));
        4 : tlUserDef4 := UpdateUDF(tlUserDef4, Str8ToScreenDate(tlTransDate));
      end;{case}
    end;{with}
  end;{SetDeliveryDateOnLine}
*)
  procedure SetDeliveryDateOnLines(sOurRef : string; iUDF : byte);

    function UpdateUDF(sField : string; sDate : string) : string;
    begin{UpdateUDF}
      if (SystemSetup.UpdateOnce) and (Trim(sField) <> '')
      then Result := sField
      else Result := sDate;
    end;{UpdateUDF}

  var
    iLine, iStatus : integer;
    oTXUpdate : ITransaction;

  begin{SetDeliveryDateOnLines}

    // Open Toolkit
    StartToolkit(EventData);

    iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(sOurRef));
    if iStatus = 0 then
    begin
      oTXUpdate := oToolkit.Transaction.Update;
      if oTXUpdate <> nil then
      begin

        // Update Lines
        For iLine := 1 to oTXUpdate.thLines.thLineCount do
        begin
          with oTXUpdate.thLines.thLine[iLine] do
          begin
            case iUDF of
              1 : tlUserField1 := UpdateUDF(tlUserField1, Str8ToScreenDate(tlLineDate));
              2 : tlUserField2 := UpdateUDF(tlUserField2, Str8ToScreenDate(tlLineDate));
              3 : tlUserField3 := UpdateUDF(tlUserField3, Str8ToScreenDate(tlLineDate));
              4 : tlUserField4 := UpdateUDF(tlUserField4, Str8ToScreenDate(tlLineDate));
            end;{case}
          end;{with}
        end;{for}

        // Save Updates
        iStatus := oTXUpdate.Save(FALSE);
        if iStatus <> 0 then
        begin
          MsgBox('An error occurred whilst attempting to save the transaction : ' + sOurRef
          , mtError, [mbOK], mbOK, 'Save Transaction Error');
        end;{if}
      end else
      begin
        MsgBox('An error occurred whilst attempting to update the transaction : ' + sOurRef
        , mtError, [mbOK], mbOK, 'Update Transaction Error');
      end;{if}
    end else
    begin
      MsgBox('An error occurred whilst attempting to find the transaction : ' + sOurRef
      , mtError, [mbOK], mbOK, 'Find Transaction Error');
    end;{if}

    // Close Toolkit
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;{SetDeliveryDateOnLines}

Begin{ExecCustomHandler}
  { Handle Hook Events here }

  if bHookEnabled then
  begin
    with EventData do
    begin
      case WinID of
(*        wiTransLine : begin {4000}
          case HandlerID of
            BEFORE_STORE_TX_LINE : begin
              if ReadINIFile then
              begin
                if (EventData.Transaction2.thInvDocHed in [CUSOR, CUSDN]) and (SystemSetup.SalesUDF > 0) then
                begin
                  SetDeliveryDateOnLine(SystemSetup.SalesUDF);
                end;{if}

                if (EventData.Transaction2.thInvDocHed in [CUPOR, CUPDN]) and (SystemSetup.PurchaseUDF > 0) then
                begin
                  SetDeliveryDateOnLine(SystemSetup.PurchaseUDF);
                end;{if}
              end;{if}
            end;
          end;{case}
        end;*)

        wiTransaction : begin {2000}
          case HandlerID of
            AFTER_STORE_TX : begin

              if (EventData.Transaction2.thInvDocHed in [CUSOR, CUSDN, CUPOR, CUPDN]) then
              begin
                if ReadINIFile then
                begin
                  if (EventData.Transaction2.thInvDocHed in [CUSOR, CUSDN]) and (SystemSetup.SalesUDF > 0) then
                  begin
                    SetDeliveryDateOnLines(EventData.Transaction2.thOurRef, SystemSetup.SalesUDF);
                  end;{if}

                  if (EventData.Transaction2.thInvDocHed in [CUPOR, CUPDN]) and (SystemSetup.PurchaseUDF > 0) then
                  begin
                    SetDeliveryDateOnLines(EventData.Transaction2.thOurRef, SystemSetup.PurchaseUDF);
                  end;{if}
                end;{if}
              end;{if}
            end;
          end;{case}
        end;

        EnterpriseBase + MiscBase + 2 : begin
          case EventData.HandlerId of
            OPEN_INITIAL_COMPANY, OPEN_NEW_COMPANY : CompanyRec.Path := EventData.Setup3.ssDataPath;
//            CLOSE_COMPANY : oSettings.Free;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

end.
