unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CentData, CustWinU, CustAbsU, Classes, LicRec{, TKUtil};

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;
  Procedure LocalMessageDlg(const sMessage : string);

implementation

Uses
  Dialogs, SysUtils, ChainU, PIMisc, ENtLic, Forms, EPOSCnst;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

var
  oCentTillInfo : TCentralTillInfo;
  bIsTCMInstalled : boolean;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iEID : byte;
  iPos : integer;
  slAboutText : TStringList;
const
  sPlugInName = 'Exchequer TCM Printing Plug-In';
  sVersionNo = 'v5.00.003';

  function IsTCMInstalled : boolean;
  var
    LicenceInfo : EntLicenceRecType;
    LicencePath : shortstring;
  begin
    LicencePath := {ExtractFilePath(Application.ExeName) +} EntLicFName;
    if ReadEntLic(LicencePath, LicenceInfo) then Result := LicenceInfo.licModules[modTrade] > 0
    else begin
      ShowMessage('Unable to read licence file in ' + LicencePath);
      Result := FALSE
    end;{if}
  end;{IsTCMInstalled}

begin
  CustomOn := True;

  bIsTCMInstalled := IsTCMInstalled;
  if bIsTCMInstalled then begin
//  if false then begin

    With CustomHandlers Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      // Enable Hook
      SetHandlerStatus(EnterpriseBase + 2000, 104, EventEnabled); // Check with me before printing TX

      sCentralTradePath := ExtractFilePath(Application.ExeName) + 'TRADE\';

      oCentTillInfo := TCentralTillInfo.Load(0);
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
  if bIsTCMInstalled then oCentTillInfo.Unload;
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  iTillNo : integer;
Begin
  { Handle Hook Events here }
  with EventData do begin
    if (WinID = EnterpriseBase + 2000) and (HandlerID = 104) then begin
      BoResult := Copy(Transaction.thUser4,1,4) = 'EPOS';
      if BoResult then begin
        // Get the Form Name to use for this document
        iTillNo := StrToIntDef(Copy(Transaction.thUser4,5,2), 0);
        with oCentTillInfo do begin
          GetTillInfo(iTillNo);
          if LastErrorNo = 0 then begin
            case Transaction.thInvDocHed of
              CUSRF, CUSCR, CUSIN, CUSRI : strResult := SetupRec.InvoiceFormName;
              CUSOR : strResult := SetupRec.OrderFormName;
            end;{case}
          end;{if}
        end;{with}

      end;{if}
    end;{if}
  end;{with}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

{Callback Procedure used to show the error messages}
Procedure LocalMessageDlg(const sMessage : string);
begin
  MessageDlg(sMessage, mtWarning, [mbOK], 0);
end;

end.
