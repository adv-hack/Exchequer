unit HandlerU;

{ nfrewer440 09:41 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

uses
  SQLUtils, CustWinU, CustAbsU, Classes, Forms, Windows, APIUtil, FileUtil;

{ Following functions required to be Exported by Enterprise }
procedure InitCustomHandler(var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); export;
procedure TermCustomHandler; export;
procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem03); export;

implementation

uses
  UDefProc, Dialogs, SysUtils, ChainU, {PopupF,} PISecure, PIMisc, ExchequerRelease;

{EXTERNAL FUNCTIONS LOCATED IN USRFDLG.DLL}
function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE)
: string; stdCall; external 'USRFDLG.DLL';

// v6.30.050
function ExecutePlugIn_V63(sUserDefField, sField, sFieldName, sDataPath, sCompanyCode, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string; stdcall; external 'USRFDLG.DLL';

function ExecuteTXPlugIn(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string; stdcall; external 'USRFDLG.DLL';

// v6.30.050
function ExecuteTXPlugIn_V63(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sCompanyCode, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string; stdcall; external 'USRFDLG.DLL';

function OpenFiles(asPath : ANSIString) : boolean; stdcall; external 'USRFDLG.DLL';

function OpenFiles_V63(sPath, sCompanyCode : ANSIString) : boolean; stdcall; external 'USRFDLG.DLL';

procedure CloseFiles; stdcall; external 'USRFDLG.DLL';

procedure RunConversion; stdcall; external 'USRFDLG.DLL';

procedure RunConversion_V63(sCompanyCode : ANSIString); stdcall; external 'USRFDLG.DLL';

procedure DisconnectADO; stdcall; external 'USRFDLG.DLL';

Const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
  CLOSE_COMPANY = 8;

  {$IFDEF EX600}
    // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    // CJS 2013-09-23 - ABSEXGENERIC-341 - discrepancy between UDF field-names in SQL and Btrieve
    // MH 09/06/2014 v7.0.11 ABSEXGENERIC-326: Fixed validation to look at correct UDef fields
    sVersionNo = '065';
  {$ELSE}
    sVersionNo = 'v5.70.057';
  {$ENDIF}
  sPlugInName = 'Exchequer User Defined Field Plug-In';
  EventDisabled = 0;
  EventEnabled  = 1;

var
  {bUsingSQL, }bTXHeaderValidation, bHookEnabled : boolean;
  sDataPath : string;

{ Called by Enterprise to initialise the Customisation }
procedure InitCustomHandler(var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
var
  iPos : integer;
  slAboutText : TStringList;
  iField : byte;

Begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHUSERPI000001', 'XktshKYRuUTRWYHG', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then
  begin

//    sDataPath := ExtractFilePath(Application.EXEName);
    sDataPath := GetEnterpriseDirectory;

    with CustomHandlers do
    begin

      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      // Enable Hooks

      // Exit User Defined Fields for :
      for iField := 1 to 4 do
      begin
        // Customer
        {if TAbsEnterpriseSystem01(CustomHandlers).Setup.ssUserFields.ufCustEnabled[iField]
        then} SetHandlerStatus (EnterpriseBase + 1000, iField + 30, EventEnabled);

        // Job
        {if TAbsEnterpriseSystem01(CustomHandlers).Setup.ssUserFields.ufJobEnabled[iField]
        then} SetHandlerStatus (EnterpriseBase + 5000, iField + 30, EventEnabled);

        // Employee
        {if TAbsEnterpriseSystem01(CustomHandlers).Setup.ssUserFields.ufEmployeeEnabled[iField]
        then} SetHandlerStatus (EnterpriseBase + 5000, iField + 40, EventEnabled);

        // TX Lines
        SetHandlerStatus (EnterpriseBase + 4000, iField + 30, EventEnabled);

        // Stock Record
        {if TAbsEnterpriseSystem01(CustomHandlers).Setup.ssUserFields.ufStockEnabled[iField]
        then} SetHandlerStatus (EnterpriseBase + 3000, iField + 30, EventEnabled);

        // Supplier
        {if TAbsEnterpriseSystem01(CustomHandlers).Setup.ssUserFields.ufSuppEnabled[iField]
        then} SetHandlerStatus (EnterpriseBase + 1000, iField + 40, EventEnabled);

        // TX Header
        SetHandlerStatus (EnterpriseBase + 2000, iField + 60, EventEnabled);

        // MuBin Hook
        if CustomHandlers.ClassVersion >= '5.52'
        then SetHandlerStatus(EnterpriseBase + 3100, 2, EventEnabled);

        // open close company hooks
        SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
        SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
        SetHandlerStatus (EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);
      end;{for}

      //TW 10/11/11: Added code to enable new hooks.
      //SetHandlerStatus (EnterpriseBase + 1000, 211, EventEnabled);
      for iField := 1 to 6 do
      begin
        // Customer
        SetHandlerStatus (EnterpriseBase + 1000, iField + 210, EventEnabled);

        // Job
        SetHandlerStatus (EnterpriseBase + 5000,  iField + 210, EventEnabled);

        // Employee
        SetHandlerStatus (EnterpriseBase + 5000,  iField + 210, EventEnabled);

        // TX Lines
        SetHandlerStatus (EnterpriseBase + 4000,  iField + 210, EventEnabled);

        // Stock Record
        SetHandlerStatus (EnterpriseBase + 3000,  iField + 210, EventEnabled);

        // Supplier
        SetHandlerStatus (EnterpriseBase + 1000,  iField + 230, EventEnabled);

        // TX Header
        SetHandlerStatus (EnterpriseBase + 2000,  iField + 210, EventEnabled);
      end;

      //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
      // TX Header
      SetHandlerStatus (EnterpriseBase + 2000,  217, EventEnabled);
      SetHandlerStatus (EnterpriseBase + 2000,  218, EventEnabled);

      // MuBin Hook
      if CustomHandlers.ClassVersion >= '5.52' then
        SetHandlerStatus(EnterpriseBase + 3100, 2, EventEnabled);

      // open close company hooks
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);

      // Validation Hooks (on click OK)
      SetHandlerStatus (EnterpriseBase + 1000, 60, EventEnabled); // Supplier
      SetHandlerStatus (EnterpriseBase + 1000, 61, EventEnabled); // Customer

      bTXHeaderValidation := HookPointEnabled(EnterpriseBase + 2000, 82);
      SetHandlerStatus (EnterpriseBase + 2000, 82, EventEnabled); // TX Header Validation

      SetHandlerStatus (EnterpriseBase + 3000, 40, EventEnabled); // Stock Record Validation
      SetHandlerStatus (EnterpriseBase + 5000, 40, EventEnabled); // Job Record Validation
      SetHandlerStatus (EnterpriseBase + 5000, 50, EventEnabled); // Employee Record Validation

      // TX Lines Validation (on click OK)
      SetHandlerStatus (EnterpriseBase + 4000, 18, EventEnabled); // General Transaction Line
      SetHandlerStatus (EnterpriseBase + 4000, 19, EventEnabled); // Nominal Transfer
      SetHandlerStatus (EnterpriseBase + 4000, 20, EventEnabled); // Stock Adjustment
//      SetHandlerStatus (EnterpriseBase + 4000, 21, EventEnabled); // Telesales
      SetHandlerStatus (EnterpriseBase + 4000, 22, EventEnabled); // Batch
      SetHandlerStatus (EnterpriseBase + 4000, 23, EventEnabled); // Timesheet
      SetHandlerStatus (EnterpriseBase + 4000, 24, EventEnabled); // General Payment

    End; { With CustomHandlers }
  end;{if}

//  bUsingSQL := UsingSQL;

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  CloseFiles;

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  DisconnectADO;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
procedure ExecCustomHandler(const EventData : TAbsEnterpriseSystem03);
var

//  FieldText    : ShortString;
  WantActivate : Boolean;
  WinPos       : TWinPos;
  WinPoint     : TPoint;
  bResult, bReverseFlags, bShown : boolean;
  sFieldName, sError : string;
  DocType : cuDocTypes;

  // v6.30.050
  bV63 : boolean;
  sCompanyCode : string;

  function ExecutePlugIn_V(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos
  ; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string;
  begin{ExecutePlugIn_V}
    if bV63
    then Result := ExecutePlugIn_V63(sUserDefField, sField, sFieldName, sDataPath, sCompanyCode
    , sUserName, WinPos, bResult, bShown, bValidate)
    else Result := ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName
    , WinPos, bResult, bShown, bValidate);
  end;{ExecutePlugIn_V}

  function ExecuteTXPlugIn_V(dtDocType : cuDocTypes; sHeadLine : string
  ; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
  ; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
  ; bReverseFlags : boolean; bValidate : boolean) : string;
  begin{ExecuteTXPlugIn_V}
    if bV63
    then Result := ExecuteTXPlugIn_V63(dtDocType, sHeadLine, iFieldNo, sField, sFieldName
    , sDataPath, sCompanyCode, sUserName, bResult, WinPos, UserFields, bReverseFlags, bValidate)
    else Result := ExecuteTXPlugIn(dtDocType, sHeadLine, iFieldNo, sField, sFieldName
    , sDataPath, sUserName, bResult, WinPos, UserFields, bReverseFlags, bValidate);
  end;{ExecuteTXPlugIn_V}

  function SetTXDocType(TheTransaction : TAbsInvoice) : cuDocTypes;
  const
    BATCH_TX_RUN_NO = -10;
  begin{SetTXDocType}
    Result := TheTransaction.thInvDocHed;

    // Make payment lines get their fields from the payment transaction type
    if Uppercase(TheTransaction.thLines.thCurrentLine.tlPayStatus) = 'Y' then
    begin
      case TheTransaction.thInvDocHed of
        cuSRI : Result := cuSRC;
        cuPRF : Result := cuPPY;
      end;{case}
    end
    else
    begin
      case TheTransaction.thInvDocHed of
        cuSRF : Result := cuSRC;
        cuPPI : Result := cuPPY;
      end;{case}
    end;{if}

    // {.039}
    // Find Batch Transactions.
    // They don't have visible UDFs so no point in enforcing them
    if (TheTransaction.thRunNo = BATCH_TX_RUN_NO)
    {and (EventData.IntResult = 0)} and (EventData.WinId = 104000)
    and (EventData.HandlerID = 22) then
    begin
      if (UpperCase(Copy(TheTransaction.thOurRef,1,1)) = 'S')
      then Result := cuSBT
      else Result := cuPBT;
    end;{if}
  end;{SetTXDocType}

  function ValidateTXHead(Transaction : TAbsInvoice) : boolean;
  var
    bResult : boolean;
    fieldNo : integer;
    sFieldName, tempStr : string;
  begin
    bResult := TRUE;
    sError := '';
    fieldNo := 1;

    with EventData, Setup, ssUserFields, TAbsInvoice13(Transaction) do
    begin
      while (bResult) and (fieldNo <= 12) do
      begin
        case fieldNo of
          1 : tempStr := thUser1;
          2 : tempStr := thUser2;
          3 : tempStr := thUser3;
          4 : tempStr := thUser4;
          5 : tempStr := thUser5;
          6 : tempStr := thUser6;
          7 : tempStr := thUser7;
          8 : tempStr := thUser8;
          9 : tempStr := thUser9;
          10 : tempStr := thUser10;
          11 : tempStr := thUser11; //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
          12 : tempStr := thUser12;
        end;

        ExecuteTXPlugIn_V(thInvDocHed, 'Head', fieldNo, tempStr, sFieldName, sDataPath, UserProfile.upUserId, bResult, WinPos, ssUserFields, bReverseFlags, TRUE);
        fieldNo := fieldNo + 1;
      end;
      if(not bResult) then
        sError := 'Error in User Field: ' + sFieldName;
    end;

    Result := bResult;
  end;

  function ValidateTXLine(Transaction : TAbsInvoice) : boolean;
  var
    bResult : boolean;
    fieldNo : integer;
    sFieldName, tempStr : string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote TXLine validation to something more readable.
    with EventData, Setup, ssUserFields, Transaction, thLines, thLines, TAbsInvLine9(thCurrentLine) do
    begin
      while (bResult) and (fieldNo <= 10) do
      begin
        case fieldNo of
          1 : tempStr := tlUserDef1;
          2 : tempStr := tlUserDef2;
          3 : tempStr := tlUserDef3;
          4 : tempStr := tlUserDef4;
          5 : tempStr := tlUserDef5;
          6 : tempStr := tlUserDef6;
          7 : tempStr := tlUserDef7;
          8 : tempStr := tlUserDef8;
          9 : tempStr := tlUserDef9;
          10 : tempStr := tlUserDef10;
        end;
        
        ExecuteTXPlugIn_V(DocType, 'Line', fieldNo, tempStr, sFieldName, sDataPath, UserProfile.upUserId, bResult, WinPos, ssUserFields, bReverseFlags, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + sFieldName;
    end;         
    Result := bResult;
  end;

  function ValidateStock : boolean;
  var
    bTemp, bResult : boolean;
    fieldNo : integer;
    tempStr, fieldDescription : string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote Stock validation to something more readable.
    with EventData, Setup, TAbsUserFields2(Setup.ssUserFields), TAbsStock4(Stock) do
    begin
      while (bResult) and (fieldNo <= 10) do
      begin
        case fieldNo of
          1 : tempStr := stStkUser1;
          2 : tempStr := stStkUser2;
          3 : tempStr := stStkUser3;
          4 : tempStr := stStkUser4;
          5 : tempStr := stStkUser5;
          6 : tempStr := stStkUser6;
          7 : tempStr := stStkUser7;
          // MH 09/06/2014 v7.0.11 ABSEXGENERIC-326: Fixed validation to look at correct UDef fields
          8 : tempStr := stStkUser8;
          9 : tempStr := stStkUser9;
          10 : tempStr := stStkUser10;
        end;
        fieldDescription := ufStockDesc10[fieldNo];

        ExecutePlugIn_V(Format('StockUser%d', [fieldNo]), tempStr, fieldDescription, sDataPath, UserProfile.upUserId, WinPos, bResult, bTemp, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + fieldDescription;
    end;         
    Result := bResult;
  end;

  function ValidateJob : boolean;
  var
    bTemp, bResult : boolean;
    fieldNo : integer;
    tempStr, fieldDescription : string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote Job validation to something more readable.
    with EventData, TAbsUserFields2(Setup.ssUserFields), TAbsJob4(Job) do
    begin
      while (bResult) and (fieldNo <= 10) do
      begin
        case fieldNo of
          1 : tempStr := jrUserDef1;
          2 : tempStr := jrUserDef2;
          3 : tempStr := jrUserDef3;
          4 : tempStr := jrUserDef4;
          5 : tempStr := jrUserDef5;
          6 : tempStr := jrUserDef6;
          7 : tempStr := jrUserDef7;
          8 : tempStr := jrUserDef8;
          9 : tempStr := jrUserDef9;
          10 : tempStr := jrUserDef10;
	end;
        fieldDescription := ufJobDesc10[fieldNo];

        ExecutePlugIn_V(Format('JobUser%d', [fieldNo]), tempStr, fieldDescription, sDataPath, UserProfile.upUserId, WinPos, bResult, bTemp, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + fieldDescription;
    end;
    Result := bResult;
  end;


 function ValidateEmployee : boolean;
  var
    bTemp, bResult : boolean;
    fieldNo : integer;
    tempStr, fieldDescription : string;
    // CJS 2013-09-23 - ABSEXGENERIC-341 - discrepancy between UDF field-names in SQL and Btrieve
    FieldName: string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote Employee validation to something more readable.
    with EventData, Setup, ssUserFields, Job  do
    begin
      // CJS 2013-08-15 - ABSEXGENERIC-331 - Range-check error caused by trying
      // to check missing UserDef field (Employees do not have field 5 - 10)
      while (bResult) and (fieldNo <= 4) do
      begin
        case fieldNo of
          1 : tempStr := jrUserDef1;
          2 : tempStr := jrUserDef2;
          3 : tempStr := jrUserDef3;
          4 : tempStr := jrUserDef4;
        end;
        fieldDescription := ufEmployeeDesc[fieldNo];

        // CJS 2013-09-23 - ABSEXGENERIC-341 - discrepancy between UDF field-names in SQL and Btrieve
        if SQLUtils.UsingSQL then
          FieldName := 'EmployeeUser%d'
        else
          FieldName := 'EmpUser%d';
        ExecutePlugIn_V(Format(FieldName, [fieldNo]), tempStr, fieldDescription, sDataPath, UserProfile.upUserId, WinPos, bResult, bTemp, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + fieldDescription;
    end;
    Result := bResult;
  end;

  function ValidateCust : boolean;
  var
    bTemp, bResult : boolean;
    fieldNo : integer;
    tempStr, fieldDescription : string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote Supplier validation to something more readable.
    with EventData, TAbsUserFields2(Setup.ssUserFields), TAbsCustomer3(Customer) do
    begin
      while (bResult) and (fieldNo <= 10) do
      begin
        case fieldNo of
          1 : tempStr := acUserDef1;
          2 : tempStr := acUserDef2;
          3 : tempStr := acUserDef3;
          4 : tempStr := acUserDef4;
          5 : tempStr := acUserDef5;
          6 : tempStr := acUserDef6;
          7 : tempStr := acUserDef7;
          8 : tempStr := acUserDef8;
          9 : tempStr := acUserDef9;
          10 : tempStr := acUserDef10;
        end;
        fieldDescription := ufCustDesc10[fieldNo];

        ExecutePlugIn_V(Format('CustUser%d', [fieldNo]), tempStr, fieldDescription, sDataPath, UserProfile.upUserId, WinPos, bResult, bTemp, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + fieldDescription;
    end;
    Result := bResult;
  end;

  function ValidateSupp : boolean;
  var
    bTemp, bResult : boolean;
    fieldNo : integer;
    tempStr, fieldDescription : string;
  begin
     bResult := TRUE;
     sError := '';
     fieldNo := 1;

    //TW 09/11/2011: Rewrote Supplier validation to something more readable.
    with EventData, TAbsUserFields2(Setup.ssUserFields), TAbsCustomer3(Supplier) do
    begin
      while (bResult) and (fieldNo <= 10) do
      begin
        case fieldNo of
          1 : tempStr := acUserDef1;
          2 : tempStr := acUserDef2;
          3 : tempStr := acUserDef3;
          4 : tempStr := acUserDef4;
          5 : tempStr := acUserDef5;
          6 : tempStr := acUserDef6;
          7 : tempStr := acUserDef7;
          8 : tempStr := acUserDef8;
          9 : tempStr := acUserDef9;
          10 : tempStr := acUserDef10;
        end;
        fieldDescription := ufSuppDesc10[fieldNo];

        ExecutePlugIn_V(Format('SuppUser%d', [fieldNo]), tempStr, fieldDescription, sDataPath, UserProfile.upUserId, WinPos, bResult, bTemp, TRUE);
        fieldNo := fieldNo + 1;
      end;

      if(not bResult) then
        sError := 'Error in User Field: ' + fieldDescription;
    end;         
    Result := bResult;
  end;

  function WinIDHandlerIDOK : boolean;
  begin
    Result := FALSE;

    //TW 09/11/2011: Extended handler ID range for new User fields
    //               1000 = Customer/Supplier, 2000 = Transaction header,
    //               3000 = Stock Record, 4000 = Transaction Line,
    //               5000 = Job Record
    with EventData do
    begin
      case WinId of
        101000 : Result := HandlerId in [31, 32, 33, 34, 41, 42, 43, 44, 60, 61,
                                         211, 212, 213, 214, 215, 216, 231, 232,
                                         233, 234, 235, 236];
        102000 : Result := HandlerId in [61, 62, 63, 64, 82, 211, 212, 213, 214,
                                         215, 216, 217, 218]; //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
        103000 : Result := HandlerId in [31, 32, 33, 34, 40, 211, 212, 213, 214,
                                         215, 216];
        103100 : Result := HandlerId = 2;
        104000 : Result := HandlerId in [31, 32, 33, 34, 18, 19, 20, 22, 23, 24,
                                         211, 212, 213, 214, 215, 216];
        105000 : Result := HandlerId in [31, 32, 33, 34, 41, 42, 43, 44, 40, 50,
                                         211, 212, 213, 214, 215, 216];
        EnterpriseBase + MiscBase + 2 : Result := HandlerId in [OPEN_INITIAL_COMPANY, OPEN_NEW_COMPANY, CLOSE_COMPANY];
      end;
    end;
  end;

  function OpenFiles_V(sDataPath : ANSIString) : boolean;
  begin{OpenFiles_V}
    if bV63
    then Result := OpenFiles_V63(sDataPath, sCompanyCode)
    else Result := OpenFiles(sDataPath);
  end;{OpenFiles_V}

  procedure RunConversion_V;
  begin{RunConversion_V}
    if bV63
    then RunConversion_V63(sCompanyCode)
    else RunConversion;
  end;{RunConversion_V}

{var
  SQLDataModule : TSQLDataModule;}

Begin
   if bHookEnabled and WinIDHandlerIDOK then
  begin
    WantActivate := False;

    bReverseFlags := (StrToInt(Copy(EventData.ClassVersion,6,3)) < 27);

    // Supply details of active window in Enterprise for better positioning of popup list
    if Screen.ActiveForm <> nil then
    begin
      WinPoint := Application.MainForm.ClientToScreen(Point(Screen.ActiveForm.Left, Screen.ActiveForm.Top));
      with WinPos do
      begin
        wpLeft   := WinPoint.X;
        wpTop    := WinPoint.Y;
        wpWidth  := Screen.ActiveForm.Width;
        wpHeight := Screen.ActiveForm.Height;
      end; { With }
    end;{if}

    if sDataPath <> EventData.Setup.ssDataPath then sDataPath := EventData.Setup.ssDataPath;

    // v6.30.050 - In v6.3 we have access to the company code in the customisation object model
    bV63 := EventData.ClassVersion >= '6.3.048';
    if bV63
    then sCompanyCode := TAbsSetup7(EventData.Setup).ssCompanyCode
    else sCompanyCode := '';

    // A 'Hook Event' has occured
    case EventData.WinId Of

      // Customer / Supplier
      101000 :
      begin
        with EventData, Setup, TAbsUserFields2(ssUserFields) do
        begin
           with TABSCustomer3(Customer) do
           begin
              case HandlerId Of
                //TW 09/11/2011 Extended to call plugins for new fields.
                31 : acUserDef1 := ExecutePlugIn_V('CustUser1', Customer.acUserDef1, ufAccount1, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                32 : acUserDef2 := ExecutePlugIn_V('CustUser2', Customer.acUserDef2, ufAccount2, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                33 : acUserDef3 := ExecutePlugIn_V('CustUser3', Customer.acUserDef3, ufAccount3, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                34 : acUserDef4 := ExecutePlugIn_V('CustUser4', Customer.acUserDef4, ufAccount4, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                61 : begin
                       BoResult := ValidateCust;
                       if not BoResult then
                       begin
                         MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                         , mtError, [mbOK], mbOK, 'Customer User Field Error');
                       end;{if}
                     end;
                211 : acUserDef5 := ExecutePlugIn_V('CustUser5', acUserDef5, ufCustDesc10[5], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                212 : acUserDef6 := ExecutePlugIn_V('CustUser6', acUserDef6, ufCustDesc10[6], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                213 : acUserDef7 := ExecutePlugIn_V('CustUser7', acUserDef7, ufCustDesc10[7], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                214 : acUserDef8 := ExecutePlugIn_V('CustUser8', acUserDef8, ufCustDesc10[8], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                215 : acUserDef9 := ExecutePlugIn_V('CustUser9', acUserDef9, ufCustDesc10[9], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                216 : acUserDef10 := ExecutePlugIn_V('CustUser10', acUserDef10, ufCustDesc10[10], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
              end;
           end;

           with TABSCustomer3(Supplier) do
           begin
              case HandlerId Of
                41 : acUserDef1 := ExecutePlugIn_V('SuppUser1', Supplier.acUserDef1, ufAccount1, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                42 : acUserDef2 := ExecutePlugIn_V('SuppUser2', Supplier.acUserDef2, ufAccount2, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                43 : acUserDef3 := ExecutePlugIn_V('SuppUser3', Supplier.acUserDef3, ufAccount3, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                44 : acUserDef4 := ExecutePlugIn_V('SuppUser4', Supplier.acUserDef4, ufAccount4, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                60 : begin
                       BoResult := ValidateSupp;
                       if not BoResult then
                       begin
                          MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                          , mtError, [mbOK], mbOK, 'Supplier User Field Error');
                       end;{if}
                     end;
                231 : acUserDef5 := ExecutePlugIn_V('SuppUser5', acUserDef5, ufCustDesc10[5], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                232 : acUserDef6 := ExecutePlugIn_V('SuppUser6', acUserDef6, ufCustDesc10[6], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                233 : acUserDef7 := ExecutePlugIn_V('SuppUser7', acUserDef7, ufCustDesc10[7], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                234 : acUserDef8 := ExecutePlugIn_V('SuppUser8', acUserDef8, ufCustDesc10[8], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                235 : acUserDef9 := ExecutePlugIn_V('SuppUser9', acUserDef9, ufCustDesc10[9], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
                236 : acUserDef10 := ExecutePlugIn_V('SuppUser10', acUserDef10, ufCustDesc10[10], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
               end;
           end;
        end;
      end;{101000}

      // Transaction Header
      102000 :
      begin
        if bV63 then
        begin
          // v6.30.050
          with EventData, Setup, ssUserFields, TAbsInvoice13(Transaction) do
          begin
            case HandlerId Of

              61 : thUser1 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 1, thUser1, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              62 : thUser2 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 2, thUser2, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              63 : thUser3 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 3, thUser3, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              64 : thUser4 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 4, thUser4, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              211 : thUser5 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 5, thUser5, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              212 : thUser6 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 6, thUser6, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              213 : thUser7 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 7, thUser7, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              214 : thUser8 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 8, thUser8, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              215 : thUser9 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 9, thUser9, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              216 : thUser10 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 10, thUser10, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)              
              217 : thUser11 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 11, thUser11, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              218 : thUser12 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 12, thUser12, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              82 : begin
                if not bTXHeaderValidation then
                BoResult := TRUE;
                bResult := ValidateTXHead(Transaction);
  //              BoResult := ValidateTXHead(Transaction);  // Validate TX Header Before saving
                if (not bResult) then
                begin
                  BoResult := FALSE;
                  MsgBox(sError + #13#13 + 'You must enter a valid value into this field.',
                         mtError, [mbOK], mbOK, 'Header User Field Error');
                end;{if}
              end;
            end; { case HandlerId }
          end;{with}                            
        end
        else
        begin
          // pre v6.3 Exch
          with EventData, Setup, ssUserFields, TAbsInvoice13(Transaction) do
          begin
            case HandlerId Of

              61 : thUser1 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 1, thUser1, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              62 : thUser2 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 2, thUser2, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              63 : thUser3 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 3, thUser3, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              64 : thUser4 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 4, thUser4, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              211 : thUser5 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 5, thUser5, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              212 : thUser6 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 6, thUser6, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              213 : thUser7 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 7, thUser7, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              214 : thUser8 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 8, thUser8, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              215 : thUser9 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 9, thUser9, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              216 : thUser10 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 10, thUser10, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)              
              217 : thUser11 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 11, thUser11, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
              218 : thUser12 := ExecuteTXPlugIn_V(thInvDocHed, 'Head', 12, thUser12, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
           82 : begin
                if not bTXHeaderValidation then BoResult := TRUE;
                bResult := ValidateTXHead(Transaction);
  //              BoResult := ValidateTXHead(Transaction);  // Validate TX Header Before saving
                if (not bResult) then
                begin
                  BoResult := FALSE;
                  MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                  , mtError, [mbOK], mbOK, 'Header User Field Error');
                end;{if}
              end;
            end; { case HandlerId }
          end;{with}
        end;{if}
      end;{102000}

      // Stock
      103000 : begin
        with EventData, Setup, TAbsUserFields2(ssUserFields), TAbsStock4(Stock) do
        begin
          case HandlerId Of
            31 : stStkUser1 := ExecutePlugIn_V('StockUser1', stStkUser1, ufStock1, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            32 : stStkUser2 := ExecutePlugIn_V('StockUser2', stStkUser2, ufStock2, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            33 : stStkUser3 := ExecutePlugIn_V('StockUser3', stStkUser3, ufStock3, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            34 : stStkUser4 := ExecutePlugIn_V('StockUser4', stStkUser4, ufStock4, sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            211 : stStkUser5 := ExecutePlugIn_V('StockUser5', stStkUser5, ufStockDesc10[5], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            212 : stStkUser6 := ExecutePlugIn_V('StockUser6', stStkUser6, ufStockDesc10[6], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            213 : stStkUser7 := ExecutePlugIn_V('StockUser7', stStkUser7, ufStockDesc10[7], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            214 : stStkUser8 := ExecutePlugIn_V('StockUser8', stStkUser8, ufStockDesc10[8], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            215 : stStkUser9 := ExecutePlugIn_V('StockUser9', stStkUser9, ufStockDesc10[9], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            216 : stStkUser10 := ExecutePlugIn_V('StockUser10', stStkUser10, ufStockDesc10[10], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);

            40 : begin
              // Validate Stock Record
              BoResult := ValidateStock;  // Validate Stock Before saving
              if not BoResult then
              begin
                MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                , mtError, [mbOK], mbOK, 'Stock User Field Error');
              end;{if}
            end;
          end;{case}
        end;{with}
      end;{103000}

      EnterpriseBase + 3100 :
      begin
        with EventData, Bin do
        begin
          case EventData.HandlerId of
            2 : brBinCode := ExecutePlugIn_V('MuBinCode', brBinCode, 'Multi-Bin Code', sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
//            2 : StrResult := ExecutePlugIn_V('MuBinCode', brBinCode, 'Multi-Bin Code', sDataPath, WinPos, ValidStatus, bShown);
          end;{case}
        end;
{        showmessage(IntToStr(EventData.WinId) + '.' + IntToStr(EventData.HandlerId) + ' - '
        + EventData.Bin.brBinCode);
        EventData.ValidStatus := TRUE;
        EventData.StrResult := 'NFBIN1';}
      end;

      // Transaction Line
      104000 :
      begin
        with EventData, Setup, ssUserFields, Transaction, thLines, TAbsInvLine9(thCurrentLine) do
        begin
          DocType := SetTXDocType(Transaction);
         //   211 : TAbsInvLine9(thLines.thCurrentLine).tlUserDef5 := ExecuteTXPlugIn_V(DocType, 'Line', 5, TAbsInvLine9(thLines.thCurrentLine).tlUserDef5, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);

          case HandlerId Of
            31 : tlUserDef1 := ExecuteTXPlugIn_V(DocType, 'Line', 1, tlUserDef1, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            32 : tlUserDef2 := ExecuteTXPlugIn_V(DocType, 'Line', 2, tlUserDef2, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            33 : tlUserDef3 := ExecuteTXPlugIn_V(DocType, 'Line', 3, tlUserDef3, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            34 : tlUserDef4 := ExecuteTXPlugIn_V(DocType, 'Line', 4, tlUserDef4, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            211 : tlUserDef5 := ExecuteTXPlugIn_V(DocType, 'Line', 5, tlUserDef5, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            212 : tlUserDef6 := ExecuteTXPlugIn_V(DocType, 'Line', 6, tlUserDef6, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            213 : tlUserDef7 := ExecuteTXPlugIn_V(DocType, 'Line', 7, tlUserDef7, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            214 : tlUserDef8 := ExecuteTXPlugIn_V(DocType, 'Line', 8, tlUserDef8, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            215 : tlUserDef9 := ExecuteTXPlugIn_V(DocType, 'Line', 9, tlUserDef9, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            216 : tlUserDef10 := ExecuteTXPlugIn_V(DocType, 'Line', 10, tlUserDef10, sFieldName, sDataPath, UserProfile.upUserId, ValidStatus, WinPos, ssUserFields, bReverseFlags, FALSE);
            18, 19, 20, {21,} 22, 23, 24 :
            begin
              BoResult := FALSE;

              if (Transaction.thLines.thCurrentLine.tlBOMKitLink <> 0)
              and (Transaction.thLines.thCurrentLine.tlQty = 0)
              then BoResult := TRUE; // do not validate description only line

              if (Transaction.thLines.thCurrentLine.tlQtyInPack = 0)
              and (Transaction.thLines.thCurrentLine.tlQty = 0)
              then BoResult := TRUE; // do not validate lines added by enterprise : for instance "SDN000898", and other cryptic lines

              if not BoResult then
              begin
                BoResult := ValidateTXLine(Transaction);  // Validate TX Line Before saving
                if not BoResult then
                begin
                  MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                  , mtError, [mbOK], mbOK, 'Line User Field Error');
                end;{if}
              end;{if}
            end;

//            21 : BoResult := TRUE;

          end;{case}
        End;{with}
      end;{104000}

      // Job / Employee Records
      105000 : begin
        with EventData, Setup, TAbsUserFields2(ssUserFields), TAbsJob4(Job) do
        begin
          case HandlerId of
            // Job Records - User defined field OnExit
            31 : jrUserDef1 := ExecutePlugIn_V('JobUser1', jrUserDef1, ufJobDesc[1], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            32 : jrUserDef2 := ExecutePlugIn_V('JobUser2', jrUserDef2, ufJobDesc[2], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            33 : jrUserDef3 := ExecutePlugIn_V('JobUser3', jrUserDef3, ufJobDesc[3], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            34 : jrUserDef4 := ExecutePlugIn_V('JobUser4', jrUserDef4, ufJobDesc[4], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            211 : jrUserDef5 := ExecutePlugIn_V('JobUser5', jrUserDef5, ufJobDesc10[5], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            212 : jrUserDef6 := ExecutePlugIn_V('JobUser6', jrUserDef6, ufJobDesc10[6], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            213 : jrUserDef7 := ExecutePlugIn_V('JobUser7', jrUserDef7, ufJobDesc10[7], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            214 : jrUserDef8 := ExecutePlugIn_V('JobUser8', jrUserDef8, ufJobDesc10[8], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            215 : jrUserDef9 := ExecutePlugIn_V('JobUser9', jrUserDef9, ufJobDesc10[9], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            216 : jrUserDef10 := ExecutePlugIn_V('JobUser10', jrUserDef10, ufJobDesc10[10], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);

            // Employee Records - User defined field OnExit
            41 : jrUserDef1 := ExecutePlugIn_V('EmpUser1', jrUserDef1, ufEmployeeDesc[1], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            42 : jrUserDef2 := ExecutePlugIn_V('EmpUser2', jrUserDef2, ufEmployeeDesc[2], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            43 : jrUserDef3 := ExecutePlugIn_V('EmpUser3', jrUserDef3, ufEmployeeDesc[3], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);
            44 : jrUserDef4 := ExecutePlugIn_V('EmpUser4', jrUserDef4, ufEmployeeDesc[4], sDataPath, UserProfile.upUserId, WinPos, ValidStatus, bShown);

            40 : begin
              // Validate Job Record
              BoResult := ValidateJob;  // Validate Job Before saving
              if not BoResult then
              begin
                MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                , mtError, [mbOK], mbOK, 'Job User Field Error');
              end;{if}
            end;

            50 : begin
              // Validate Employee Record
              BoResult := ValidateEmployee;  // Validate Employee Before saving
              if not BoResult then
              begin
                MsgBox(sError + #13#13 + 'You must enter a valid value into this field.'
                , mtError, [mbOK], mbOK, 'Employee User Field Error');
              end;{if}
            end;
          end; {case}
        end; {with}
      end;{105000}

      EnterpriseBase + MiscBase + 2 :
      begin
        case EventData.HandlerId of
          OPEN_NEW_COMPANY, OPEN_INITIAL_COMPANY :
          begin
            // SQL
{            if bUsingSQL then
            begin
              SQLDataModule := TSQLDataModule.Create(nil);
              SQLDataModule.Connect(sDataPath);
            end;}

            if OpenFiles_V(sDataPath) then
            begin
              RunConversion_V;
            end
            else
            begin
              MsgBox('The call to OpenFiles(' + sDataPath
              + ') in UsrFDlg.Dll Failed.', mtError, [mbOK], mbOK, 'EntUserF.Dll error');
            end;{if}
          end;

          CLOSE_COMPANY :
          begin
            CloseFiles;
            DisconnectADO;

            // SQL
{            if bUsingSQL then
            begin
              SQLDataModule.Disconnect;
              SQLDataModule.Free;
            end;}
          end;
        end;{case}
      end;
    end;{case}

    if WantActivate then EventData.entActivate; // Reset focus back to Enterprise

  end;{if}

  { Pass onto other Hook DLL's }
   DLLChain.ExecCustomHandler(EventData);
end;


end.
