unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses forms,classes,CustWinU, CustAbsU, inifiles;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;


implementation

Uses Dialogs, SysUtils, ChainU, PIMisc, EntLicence, History, oSettings, srchlist,
     ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

Var
  bPlugInEnabled : Boolean = False;

//=========================================================================

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  // Only enable plug-in for the SQL Edition
  bPlugInEnabled := EnterpriseLicence.IsSQL;

  If bPlugInEnabled Then
  Begin
    CustomOn := False;

    With CustomHandlers Do
    Begin
      // Set help-about message
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText (ExtendedSearchName,                 // sName
                         //ExtendedSearchVer + ' (DLL)',       // sVersionNo : string;
                         ExchequerModuleVersion (emExtendedSearch, ExtendedSearchVer + ' (DLL)'),       // sVersionNo : string;
                         slAboutText);                       // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      // Define hooks based on settings from .INI file
      If Settings.STLinkActive Then
      Begin
        SetHandlerStatus (wiTransLine, 15, EventEnabled); // Exit Stock Code on Detail Line
        SetHandlerStatus (wiTransLine, 58, EventEnabled); // Exit Stock Code on Telesales

        SetHandlerStatus (wiStock, 115, EventEnabled); // Object Find Stock; Any Field option
      End; // If Settings.STLinkActive

      If Settings.CULinkActive Then
      Begin
        SetHandlerStatus (wiTransaction, 6, EventEnabled); // Exit Account Code on Header
        SetHandlerStatus (wiAccount, 100, EventEnabled); // Exit Account Code on Telesales

        SetHandlerStatus (wiAccount, 135, EventEnabled);  // Object Find Customer; Any Field option
        SetHandlerStatus (wiAccount, 137, EventEnabled);  // Object Find Supplier; Any Field option
      End; // If Settings.CULinkActive

      If Settings.JCLinkActive Then // Currently (Oct 2010); no hook point for Set Job Code on transactions...?
      Begin
        SetHandlerStatus (wiJobRec, 85, EventEnabled);  // Object Find Job; Any Field option
      End; // If Settings.JCLinkActive
    End; // With CustomHandlers
  End; // If bPlugInEnabled

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

//-------------------------------------------------------------------------

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
{ CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
const
  CancelMessage = 'EXTSEARCH CANCELLED';
var
  TempStr:ShortString;
  IncludeConsumers: Boolean;
Begin
  If bPlugInEnabled Then
  Begin
    With EventData, TAbsSetup15(EventData.Setup) Do
    Begin
      // Transaction Line - Exist Stock Code
      If (WinID=wiTransLine) and (HandlerID=15) Then
      Begin
        if (Trim(Transaction.thLines.thCurrentLine.tlStockCode)<>'') and (Pos(Copy(Transaction.thLines.thCurrentLine.tlStockCode,1,1),'!?><')=0) then
          begin
            TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Stock', Transaction.thLines.thCurrentLine.tlStockCode);
            if Trim(TempStr)<>Trim(Transaction.thLines.thCurrentLine.tlStockCode) then
              Transaction.thLines.thCurrentLine.tlStockCode:=TempStr;
          end;
      End; // If (WinID=wiTransLine) and (HandlerID=15)

      // Transaction Header - Exit Account Code
      If (WinID=wiTransaction) and (HandlerID=6) then
      Begin
        // CJS 2013-11-27 - MRD1.1.47 - Consumer Support
        IncludeConsumers := TAbsSetup11(EventData.Setup).ssConsumersEnabled;
        // Check OurRef to determine if Customers or Suppliers are required
        // CJS 2014-07-21 - ABSEXCH-15281 - WOR transactions should also use Suppliers
        If (Copy(Transaction.thOurRef, 1, 1) = 'S') Or (Copy(Transaction.thOurRef, 1, 1) = 'W') Then
        Begin
          // Sales
          TempStr := '';
          { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
          TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Customer',Trim(Transaction.thAcCode), IncludeConsumers);
          if TempStr <> '' then
            Transaction.thAcCode := TempStr
          else
            StrResult := CancelMessage;
        End // If (Copy(Transaction.thOurRef, 1, 1) = 'S')
        Else
        Begin
          // Purchase
          TempStr := '';
          { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
          TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Supplier', Trim(Transaction.thAcCode));
          if TempStr <> '' then
            Transaction.thAcCode:=TempStr
          else
            StrResult := CancelMessage;
        End; // Else
      End; // If (WinID=wiTransaction) and (HandlerID=6)

      // Telesales - Exit Account Code
      If (WinID=wiAccount) and (HandlerID=100) Then
      Begin
        TempStr := '';
        // CJS 2013-11-27 - MRD1.1.47 - Consumer Support
        IncludeConsumers := TAbsSetup11(EventData.Setup).ssConsumersEnabled;
        { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
        TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Customer', Trim(Customer.AcCode), IncludeConsumers);
        if TempStr <> '' then
          StrResult:=TempStr
        else
          StrResult := CancelMessage;
      End; // If (WinID=wiAccount) and (HandlerID=100)

      // Telesales - Exit Stock Code
      If (WinID=wiTransLine) and (HandlerID=58) Then
      Begin
        if (Trim(Transaction.thLines.thCurrentLine.tlStockCode)<>'') and (Pos(Copy(Transaction.thLines.thCurrentLine.tlStockCode,1,1),'!?><')=0) then
        begin
          TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Stock',Transaction.thLines.thCurrentLine.tlStockCode);
          if Trim(TempStr)<>Trim(Transaction.thLines.thCurrentLine.tlStockCode) then
            Transaction.thLines.thCurrentLine.tlStockCode:=TempStr;
        end;
      End; // If (WinID=wiTransLine) and (HandlerID=58)

      // Object Find - Stock
      If (WinID=wiStock) and (HandlerID=115) Then
      Begin
        TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Stock', StrResult);
        if Trim(TempStr)<>'' then
        begin
          BoResult:=True;
          StrResult:=trim(tempstr);
        end;
      End; // If (WinID=wiStock) and (HandlerID=115)

      // Object Find - Customer
      If (WinID=wiAccount) and (HandlerID=135) Then
      Begin
        TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Customer', StrResult);
        if Trim(TempStr)<>'' then
          begin
            BoResult:=True;
            StrResult:=Trim(TempStr);
        end;
      End; // If (WinID=wiAccount) and (HandlerID=135)

      // Object Find - Supplier
      If (WinID=wiAccount) and (HandlerID=137) Then
      Begin
        TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Supplier', StrResult);
        if Trim(TempStr)<>'' then
        begin
          BoResult:=True;
          StrResult:=Trim(TempStr);
        end;
      End; // If (WinID=wiAccount) and (HandlerID=137)

      // Object Find - Job
      If (WinID=wiJobRec) and (HandlerID=85) Then
      Begin
        TempStr:=ExtLookupHook(ssConnectionString, ssConnectionPassword, ssCompanyCode, 'Job', StrResult);
        if Trim(TempStr)<>'' then
        begin
          BoResult:=True;
          StrResult:=Trim(TempStr);
        end;
      End; // If (WinID=wiJobRec) and (HandlerID=85)
    End; // With EventData, TAbsSetup7(EventData.Setup)
  End; // If bPlugInEnabled

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

//=========================================================================


end.
