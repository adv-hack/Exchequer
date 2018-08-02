unit HandlerU;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  BTrvU2, GlobVar, VarConst, CustWinU, CustAbsU, Forms, Controls;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;


implementation

Uses
  Dialogs, SysUtils, ChainU, Company, StrUtil, APIUtil,Classes, PISecure, PIMisc, ExchequerRelease;

var
  bHookEnabled : boolean;

Const
  sPlugInName = 'Exchequer Sales Commission Plug-In';
  {$IFDEF EX600}
    sVersionNo = '020';
  {$ELSE}
    sVersionNo = 'v5.71.019';
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

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHSALCOM000017', 'g$faa0,bv56fgdff', sPlugInName
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

      // Enable Change Account Code Hook
      if Copy(classversion,1,4) >= '5.52'
      then begin
        SetHandlerStatus(EnterpriseBase + 1000, 111, EventEnabled);
        SetHandlerStatus(EnterpriseBase + 3000, 111, EventEnabled);
      end;{if}

      // Enable Delete Account Hook
      SetHandlerStatus(EnterpriseBase + 1000, 4, EventEnabled);

    end;

  end;{if}


  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

Procedure TermCustomHandler;
{ Called by Enterprise to End the Customisation }
Begin

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
{ Called by Enterprise whenever a Customised Event happens }
var
  CompanyCode : string;
  iResult : byte;

  procedure SetCompanyRec;
  begin{SetCompanyRec}
    CompanyRec.Path := Eventdata.Setup.ssDataPath;
  end;{SetCompanyRec}

  procedure ChangeSupplierCode(OldCode, NewCode : string);
  var
    iStatus : smallint;
    KeyS : Str255;
    SalesCodeRec : TSalesCodeRec;
  begin{ChangeSupplierCode}
    KeyS := PadString(psRight, OldCode, #0, SizeOf(SalesCodeRec.scEntSupplierCode));
    iStatus := Find_Rec(B_GetGEq, F[SalesCodeF], SalesCodeF, SalesCodeRec, scSupplierIdx, KeyS);
    while (iStatus = 0) and (Trim(SalesCodeRec.scEntSupplierCode) = OldCode) do begin

      // update code
      SalesCodeRec.scEntSupplierCode := PadString(psRight, NewCode, #0, SizeOf(SalesCodeRec.scEntSupplierCode));
      iStatus := Put_Rec(F[SalesCodeF], SalesCodeF, SalesCodeRec, scSupplierIdx);
      ShowBTError(iStatus, 'Put_Rec', FileNames[SalesCodeF]);

      // next record
      KeyS := PadString(psRight, OldCode, #0, SizeOf(SalesCodeRec.scEntSupplierCode));
      iStatus := Find_Rec(B_GetGEq, F[SalesCodeF], SalesCodeF, SalesCodeRec, scSupplierIdx, KeyS);
    end;{while}

    if not (iStatus in [4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[SalesCodeF]);
  end;{ChangeSupplierCode}

  procedure ChangeCustomerCode(OldCode, NewCode : string);
  var
    iStatus : smallint;
    KeyS : Str255;
    CommissionRec : TCommissionRec;
  begin{ChangeCustomerCode}
    KeyS := PadString(psRight, OldCode, #0, SizeOf(CommissionRec.cmCustCode));
    iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
    while (iStatus = 0) and (Trim(CommissionRec.cmCustCode) = OldCode) do begin

      // update code
      CommissionRec.cmCustCode := PadString(psRight, NewCode, #0, SizeOf(CommissionRec.cmCustCode));
      iStatus := Put_Rec(F[CommissionF], CommissionF, CommissionRec, cmReportIdx);
      ShowBTError(iStatus, 'Put_Rec', FileNames[CommissionF]);

      // next record
      KeyS := PadString(psRight, OldCode, #0, SizeOf(CommissionRec.cmCustCode));
      iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
    end;{while}

    if not (iStatus in [4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[CommissionF]);
  end;{ChangeCustomerCode}

  procedure DeleteCustomerCode(Code : string);
  var
    iStatus : smallint;
    KeyS : Str255;
    CommissionRec : TCommissionRec;
  begin{DeleteCustomerCode}
    KeyS := PadString(psRight, Code, #0, SizeOf(CommissionRec.cmCustCode));
    iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
    while (iStatus = 0) and (Trim(CommissionRec.cmCustCode) = Code) do begin

      // delete record
      iStatus := Delete_Rec(F[CommissionF], CommissionF, cmReportIdx);
      ShowBTError(iStatus, 'Delete_Rec', FileNames[CommissionF]);

      // next record
      KeyS := PadString(psLeft, Code, #0, SizeOf(CommissionRec.cmCustCode));
      iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, cmReportIdx, KeyS);
    end;{while}

    if not (iStatus in [4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[CommissionF]);
  end;{DeleteCustomerCode}

  procedure ChangeStockCode(OldCode, NewCode : string; bProductGroup : boolean);
  var
    iIndex : integer;
    iStatus : smallint;
    KeyS : Str255;
    CommissionRec : TCommissionRec;
    sStockCode : string;
  begin{ChangeStockCode}

    if bProductGroup then
    begin
      iIndex := cmProdGroupIdx;
    end else
    begin
      iIndex := cmProductIdx;
    end;{if}

    sStockCode := OldCode;
    KeyS := PadString(psRight, OldCode, #0, SizeOf(sStockCode));
    iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, iIndex, KeyS);
    while (iStatus = 0) and (Trim(sStockCode) = OldCode) do begin

      // update code
      if bProductGroup then CommissionRec.cmPGroupCode := PadString(psRight, NewCode, #0, SizeOf(sStockCode))
      else CommissionRec.cmProductCode := PadString(psRight, NewCode, #0, SizeOf(sStockCode));

      iStatus := Put_Rec(F[CommissionF], CommissionF, CommissionRec, iIndex);
      ShowBTError(iStatus, 'Put_Rec', FileNames[CommissionF]);

      // next record
      KeyS := PadString(psRight, OldCode, #0, SizeOf(sStockCode));
      iStatus := Find_Rec(B_GetGEq, F[CommissionF], CommissionF, CommissionRec, iIndex, KeyS);
    end;{while}

    if not (iStatus in [4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[CommissionF]);
  end;{ChangeStockCode}

Begin
  { Handle Hook Events here }

  if bHookEnabled then begin
    with EventData do begin
      case WinID of
        EnterpriseBase + 1000 : begin
          case HandlerID of
            111 : begin
              // Account Code Has Changed. We must update our database.
              SetCompanyRec;
              OpenFiles;
              if Supplier.AccessRights = NotAvailable
              then ChangeCustomerCode(Trim(Customer.acCode), Trim(StrResult))  // SupplierCode Change
              else ChangeSupplierCode(Trim(Supplier.acCode), Trim(StrResult)); // Customer Code Change
              CloseFiles;
            end;

            4 : begin
              // Account Has Been Deleted. We must update our database.
              SetCompanyRec;
              OpenFiles;
              if Supplier.AccessRights = NotAvailable
              then DeleteCustomerCode(Trim(Customer.acCode))  // Customer Deleted
              else ;//DeleteSupplierCode(Supplier.acCode); // Supplier Deleted
              CloseFiles;
            end;
          end;{case}
        end;

        EnterpriseBase + 3000 : begin
          case HandlerID of
            111 : begin
              // Stock Code Has Changed. We must update our database.
              SetCompanyRec;
              OpenFiles;

              ChangeStockCode(Trim(Stock.stCode), Trim(StrResult), Stock.stStockType = 'G');  // SupplierCode Change
              CloseFiles;
            end;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

end.
