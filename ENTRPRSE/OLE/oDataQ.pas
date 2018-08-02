unit oDataQ;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, Forms, Registry, StdVcl, SysUtils,
  Windows,
  Enterprise_TLB,      // Data Query Server Type Library
  {$IFDEF EXEVER}
    Enterprise01_TLB;    // COM Toolkit Type Library // DLL Version for .EXE EntDataQ
  {$ELSE}
    Enterprise04_TLB;    // COM Toolkit Type Library // MH 08/09/2008: Switched to .EXE COM Toolkit
  {$ENDIF}

type
  TTypeDescStrings = (tsdDataPlural, tdsDataSingular);

  TAccountTypeSet = Set of Byte;

  TDataQuery = class(TAutoObject, IConnectionPointContainer, IDataQuery)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IDataQueryEvents;

    // Internal reference to COM Toolkit used for data access
    FCOMTK : IToolkit;

    // Internal StringList for Results
    FDataCodes : TStringList;

    // Import Mode
    FMode : TDataQueryMode;

    // Import Direction - how to display results in Excel
    FImportDirection: TDataQueryDirection;

    // Index of Selected Company Data Set within Company Object
    FCompanyIdx : SmallInt;

    // Starting Cell Id within Excel Spreadsheet
    FXLStartCol : Integer;
    FXLStartRow : Integer;

    // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
    FUserName : ShortString;

    // Filter properties
    FFilterByType       : Boolean;
    FFilterByParent     : Boolean;
    FFilterByRange      : Boolean;
    FFilterByStatus     : Boolean;
    FFilterStartStr     : ShortString;
    FFilterEndStr       : ShortString;
    FFilterParentStr    : ShortString;
    FFilterParentLong   : LongInt;
    FFilterGLTypes      : Array[glTypeProfitLoss..glTypeHeading] Of Boolean;
    FFilterJobStatus    : Array[JStatusQuotation..JStatusClosed] Of Boolean;
    FFilterJobTypes     : Array[JTypeContract..JTypeJob] Of Boolean;
    FFilterStockTypes   : Array[stTypeGroup..stTypeDiscontinued] Of Boolean;
    FFilterLevel1Only   : Boolean;
    FIncludeAccountTypes : TAccountTypeSet;
    function GetFilterGLTypes(Index: TGeneralLedgerType): Boolean;
    procedure SetFilterGLTypes(Index: TGeneralLedgerType;
      const Value: Boolean);
    function GetFilterJobTypes(Index: TJobTypeType): Boolean;
    procedure SetFilterJobTypes(Index: TJobTypeType; const Value: Boolean);
    function GetFilterStockTypes(Index: TStockType): Boolean;
    procedure SetFilterStockTypes(Index: TStockType; const Value: Boolean);
    function GetFilterJobStatus(Index: TJobStatusType): Boolean;
    procedure SetFilterJobStatus(Index: TJobStatusType;
      const Value: Boolean);
  protected
    { Protected declarations }

    // IConnectionPointContainer properties/methods
    property ConnectionPoints: TConnectionPoints read FConnectionPoints implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;

    // IDataQuery Methods
    function Get_dqVersion: WideString; safecall;
    function Get_dqMode: TDataQueryMode; safecall;
    function Get_dqExcelStartCol: Integer; safecall;
    procedure Set_dqExcelStartCol(Value: Integer); safecall;
    function Get_dqExcelStartRow: Integer; safecall;
    procedure Set_dqExcelStartRow(Value: Integer); safecall;
    function Get_dqResultCount: Integer; safecall;
    function Get_dqResults(Index: Integer): WideString; safecall;
    function Get_dqImportDirection: TDataQueryDirection; safecall;
    procedure Set_dqImportDirection(Value: TDataQueryDirection); safecall;
    function Execute(DataType: TDataQueryMode): Integer; safecall;

    // Local Methods

    // Property COMTK : IToolkit
    function GetCOMTK: IToolkit;
    // Property TypeDesc [Index : Integer] : ShortString
    function GetTypeDesc (Index : TTypeDescStrings) : ShortString;
    // Property TypeContext : LongInt
    function GetTypeContext : LongInt;

    function  ImportAccountData (oAccount : IAccount; Const SubTypes : TAccountTypeSet) : SmallInt;
    function  ImportCCDeptData (oCCDept : ICCDept) : SmallInt;
    function  ImportGLData (oGL : IGeneralLedger) : SmallInt;
    function  ImportJobData (oJob : IJob) : SmallInt;
    function  ImportLocationData (oLocation : ILocation) : SmallInt;
    function  ImportStockData (oStock : IStock) : SmallInt;
    procedure ExecuteAbout(const AddInVer: WideString); safecall;
    function Get_dqLicencing(Index: TDataQueryLicencing): WordBool; safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;

    // Internal Properties use within the OLE Server
    Property CompanyIdx : SmallInt Read FCompanyIdx Write FCompanyIdx;
    Property COMTK : IToolkit Read GetCOMTK;
    Property DataType : TDataQueryMode Read FMode;
    Property FilterByType : Boolean Read FFilterByType Write FFilterByType;
    Property FilterByParent : Boolean Read FFilterByParent Write FFilterByParent;
    Property FilterByRange : Boolean Read FFilterByRange Write FFilterByRange;
    Property FilterByStatus : Boolean Read FFilterByStatus Write FFilterByStatus;
    Property FilterLevel1Only : Boolean Read FFilterLevel1Only Write FFilterLevel1Only;
    Property FilterGLTypes [Index: TGeneralLedgerType] : Boolean Read GetFilterGLTypes Write SetFilterGLTypes;
    Property FilterJobStatus [Index: TJobStatusType] : Boolean Read GetFilterJobStatus Write SetFilterJobStatus;
    Property FilterJobTypes [Index: TJobTypeType] : Boolean Read GetFilterJobTypes Write SetFilterJobTypes;
    Property FilterStockTypes [Index: TStockType] : Boolean Read GetFilterStockTypes Write SetFilterStockTypes;
    Property FilterParentLong : LongInt Read FFilterParentLong Write FFilterParentLong;
    Property FilterParentStr : ShortString Read FFilterParentStr Write FFilterParentStr;
    Property FilterStartStr : ShortString Read FFilterStartStr Write FFilterStartStr;
    Property FilterEndStr : ShortString Read FFilterEndStr Write FFilterEndStr;
    Property ImportDirection: TDataQueryDirection Read FImportDirection Write FImportDirection;

    // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
    Property IncludeAccountTypes : TAccountTypeSet Read FIncludeAccountTypes Write FIncludeAccountTypes;

    Property TypeDesc [Index: TTypeDescStrings] : ShortString Read GetTypeDesc;
    Property TypeContext : LongInt Read GetTypeContext;

    // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
    Property UserName : ShortString Read FUserName Write FUserName;
  end;

implementation

uses ComServ,
     SecCodes,    // Security Unit for COMTK Backdoor
     LicRec,      // Enterprise Licence Structures
     EntLic,      // Enterprise Licence Read/Write functions
     ImportF1,    // Select Company dialog
     ImportF2,    // Filter Criterion dialog
     ImportF3,    // Misc Options dialog
     DQAboutF,    // About Dialog
     DQHist,      // Version Number and Project History
     Brand,       // Exchequer/IAO Rebranding Classes
     VAOUtil,     // Virtual Accounts Office info object for pathing and setup info
     ExchequerRelease;

//-----------------------------------------------------------------------------------------

Var
  LicArray : Array [dqlStock..dqlJobCosting] Of Boolean;


//-----------------------------------------------------------------------------------------

procedure TDataQuery.Initialize;
begin
  inherited Initialize;

  // Setup Events Object - not required initially but may be used later
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;

  // Create StringList to hold result sets
  FDataCodes := TStringList.Create;

  // Initialise the COM Toolkit reference for safety
  FCOMTK := NIL;

  // Default to selecting first company
  CompanyIdx := 1;
end;

//-----------------------------------

Destructor TDataQuery.Destroy;
begin
  // Remove any reference to the COM Toolkit
  FCOMTK := NIL;

  // Destroy StringList for Result Sets
  FreeAndNIL(FDataCodes);

  Inherited;
end;

//-----------------------------------------------------------------------------------------

// Dunno what this does - something to do with the Events so don't change it
procedure TDataQuery.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IDataQueryEvents;
end;

//-----------------------------------------------------------------------------------------

// Displays the Data Query Wizard
function TDataQuery.Execute(DataType: TDataQueryMode): Integer;
Const
  dlgSelComp = 1;
  dlgFilter = 2;
  dlgOptions = 3;
Var
  AbortWiz, FinishedWiz : Boolean;
  WizNo                 : Byte;
Begin { Execute }
  Result := -1;

  Try
    // Check the DataType is valid
    If (Ord(DataType) <= dqmSupplier) Then
    Begin
      // Setup Default property values
      FMode := DataType;
      FImportDirection := dqoVerticalDown;

      // Setup default filter values
      FFilterByRange  := False;
      FFilterStartStr := '';
      FFilterEndStr   := '';

      FFilterByParent := False;
      FFilterParentStr := '';
      FFilterLevel1Only := False;

      FIncludeAccountTypes := [];

      FFilterByType := False;
      FFilterGLTypes[glTypeProfitLoss] := True;
      FFilterGLTypes[glTypeBalanceSheet] := True;
      FFilterGLTypes[glTypeControl] := True;
      FFilterGLTypes[glTypeCarryFwd] := True;
      FFilterGLTypes[glTypeHeading] := True;
      FFilterJobTypes[JTypeJob] := True;
      FFilterJobTypes[JTypeContract] := True;

      FilterByStatus := False;
      FFilterJobStatus[JStatusQuotation] := False;
      FFilterJobStatus[JStatusActive] := True;
      FFilterJobStatus[JStatusSuspended] := False;
      FFilterJobStatus[JStatusCompleted] := False;
      FFilterJobStatus[JStatusClosed] := False;

      // Clear out any previous results
      FDataCodes.Clear;

      // Display Wizard
      AbortWiz := False;
      FinishedWiz := False;
      WizNo := dlgSelComp;
      While (Not AbortWiz) And (Not FinishedWiz) Do Begin
        Case WizNo Of
          // Select Company
          dlgSelComp : Begin
                         With TfrmSelectCompany.Create (Application.MainForm, Self) Do
                           Try
                             ShowModal;

                             Case ExitCode Of
                               'B'  : ; // N/A
                               'N'  : WizNo := dlgFilter;
                               'X'  : AbortWiz := True;
                             Else
                               ShowMessage (ExitCode);
                             End; { Case ExitCode }
                           Finally
                             Free;
                           End;
                       End;

          // Filter Criteria
         dlgFilter   : Begin
                         With TfrmFilterCritera.Create (Application.MainForm, Self) Do
                           Try
                             ShowModal;

                             Case ExitCode Of
                               'B'  : WizNo := dlgSelComp;
                               'N'  : WizNo := dlgOptions;
                               'X'  : AbortWiz := True;
                             Else
                               ShowMessage (ExitCode);
                             End; { Case ExitCode }
                           Finally
                             Free;
                           End;
                       End;

          // Options
         dlgOptions  : Begin
                         With TfrmMiscOptions.Create (Application.MainForm, Self) Do
                           Try
                             ShowModal;

                             Case ExitCode Of
                               'B'  : WizNo := dlgFilter;
                               'N'  : FinishedWiz := True;
                               'X'  : AbortWiz := True;
                             Else
                               ShowMessage (ExitCode);
                             End; { Case ExitCode }
                           Finally
                             Free;
                           End;
                       End;
        Else
          ShowMessage ('TDataQuery.Execute - Unknown WizNo: ' + IntToStr(WizNo));
          AbortWiz := True;
        End; { Case WizNo }
      End; { While (Not AbortWiz) And (Not FinishedWiz) }

      If FinishedWiz And (Not AbortWiz) Then
        // Import the Data into the FDataCodes String List
        Case FMode Of
          dqmCostCentre  : Result := ImportCCDeptData (FCOMTK.CostCentre);
          // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
          dqmCustomer    : Result := ImportAccountData (FCOMTK.Customer, FIncludeAccountTypes);
          dqmDepartment  : Result := ImportCCDeptData (FCOMTK.Department);
          dqmGLCode      : Result := ImportGLData (FCOMTK.GeneralLedger);
          dqmJob         : Result := ImportJobData (FCOMTK.JobCosting.Job);
          dqmLocation    : Result := ImportLocationData (FCOMTK.Location);
          dqmStock       : Result := ImportStockData (FCOMTK.Stock);
          dqmSupplier    : Result := ImportAccountData (FCOMTK.Supplier, FIncludeAccountTypes);
        Else
          ShowMessage ('TDataQuery.Execute - DataType (' + IntToStr(Ord(FMode)) + ') Import not coded');
        End; { Case DataType }

      // Close COM Toolkit if Open
      If Assigned(FCOMTK) And (FCOMTK.Status = tkOpen) Then
        FCOMTK.CloseToolkit;

        // Return Error Status if process aborted
      If AbortWiz Then
        Result := 1001;
    End // If (Ord(DataType) <= dqmSupplier)
    Else
      // Invalid DataType
      Raise Exception.Create ('TDataQuery.Execute - The specified DataType (' + IntToStr(Ord(DataType)) + ') is invalid');
  Except
    On E:Exception Do Begin
      MessageDlg ('The following error occurred in TDataQuery.Execute:' + #13#13 +
                  QuotedStr(E.Message) + #13#13 +
                  'Please notify your Technical Support', mtError, [mbOk], 0);
      Result := 1002;
    End; { On }
  End;
End; { Execute }

//-----------------------------------------------------------------------------------------

// Customer/Supplier Import
function TDataQuery.ImportAccountData (oAccount : IAccount; Const SubTypes : TAccountTypeSet) : SmallInt;
Var
  WantRec : Boolean;
  FuncRes : LongInt;
Begin { ImportAccountData }
  Result := 0;

  With oAccount Do Begin
    Index := acIdxCode;

    FuncRes := GetFirst;
    While (FuncRes = 0) Do Begin
      If FFilterByRange Then
        // Check Account Code is within the specified range
        WantRec := (Trim(acCode) >= FFilterStartStr) And (Trim(acCode) <= FFilterEndStr)
      Else
        WantRec := True;

      // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
      If WantRec And (SubTypes <> []) Then
        WantRec := (Ord ((oAccount As IAccount7).acSubType) In SubTypes);

      If WantRec Then
        FDataCodes.Add(acCode);

      FuncRes := GetNext;
    End; { While (FuncRes = 0) }
  End; { With oAccount }
End; { ImportAccountData }

//-----------------------------------------------------------------------------------------

// CostCentre/Department Import
function TDataQuery.ImportCCDeptData (oCCDept : ICCDept) : SmallInt;
Var
  WantRec : Boolean;
  FuncRes : LongInt;
Begin { ImportCCDeptData }
  Result := 0;

  With oCCDept Do Begin
    Index := cdIdxCode;

    FuncRes := GetFirst;
    While (FuncRes = 0) Do Begin
      If FFilterByRange Then
        // Check Code is within the specified range
        WantRec := (Trim(cdCode) >= FFilterStartStr) And (Trim(cdCode) <= FFilterEndStr)
      Else
        WantRec := True;

      If WantRec Then
        FDataCodes.Add(cdCode);

      FuncRes := GetNext;
    End; { While (FuncRes = 0) }
  End; { With oCCDept }
End; { ImportCCDeptData }

//-----------------------------------------------------------------------------------------

// Location Import
function TDataQuery.ImportLocationData (oLocation : ILocation) : SmallInt;
Var
  WantRec : Boolean;
  FuncRes : LongInt;
Begin { ImportLocationData }
  Result := 0;

  With oLocation Do Begin
    Index := loIdxCode;

    FuncRes := GetFirst;
    While (FuncRes = 0) Do Begin
      If FFilterByRange Then
        // Check Code is within the specified range
        WantRec := (Trim(loCode) >= FFilterStartStr) And (Trim(loCode) <= FFilterEndStr)
      Else
        WantRec := True;

      If WantRec Then
        FDataCodes.Add(loCode);

      FuncRes := GetNext;
    End; { While (FuncRes = 0) }
  End; { With oLocation }
End; { ImportLocationData }

//-----------------------------------------------------------------------------------------

// GLCode Import
function TDataQuery.ImportGLData (oGL : IGeneralLedger) : SmallInt;
Var
  FuncRes : LongInt;

  //------------------------

  // Returns TRUE if the current GL record passes the Range and Type filters
  Function WantGL : Boolean;
  Begin { WantGL }
    Result := True;

    With oGL Do Begin
      // Check Range Filter
      If FFilterByType Then Begin
        // Check the GL Code Type
        Result := ((glType = glTypeProfitLoss) And FFilterGLTypes[glTypeProfitLoss]) Or
                  ((glType = glTypeBalanceSheet) And FFilterGLTypes[glTypeBalanceSheet]) Or
                  ((glType = glTypeControl) And FFilterGLTypes[glTypeControl]) Or
                  ((glType = glTypeCarryFwd) And FFilterGLTypes[glTypeCarryFwd]) Or
                  ((glType = glTypeHeading) And FFilterGLTypes[glTypeHeading]);
      End; { If FFilterByType }
    End; { With oGL }
  End; { WantGL }

  //------------------------

  // Processes the GL Codes of a specified Parent GL Code
  Procedure ImportGLChildren (Const ParentCode : LongInt);
  Var
    FuncRes  : LongInt;
    LocalPos : LongInt;
  Begin { ImportGLChildren }
    With oGL Do Begin
      // Run through the parent index processing children as found
      Index := glIdxParent;
      FuncRes := GetGreaterThanOrEqual(BuildParentIndex(ParentCode, 0));
      While (FuncRes = 0) And (glParent = ParentCode) Do Begin
        If WantGL Then
          FDataCodes.Add(IntToStr(glCode));

        If (glType = glTypeHeading) And (Not FFilterLevel1Only) Then Begin
          // Heading - Save Position and call import function recursively to process it
          SavePosition;
          LocalPos := Position;
          ImportGLChildren (glCode);
          Position := LocalPos;
          RestorePosition;
        End; { If (glType = glTypeHeading) }

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { With oGL }
  End; { ImportGLChildren }

  //------------------------

Begin { ImportGLData }
  Result := 0;

  With oGL Do Begin
    If FFilterByParent Then
      // Run through tree structure importing the children of a specified Parent
      ImportGLChildren (FFilterParentLong)
    Else Begin
      // Run through in Code Order
      Index := glIdxCode;
      FuncRes := GetFirst;
      While (FuncRes = 0) Do Begin
        If WantGL Then
          FDataCodes.Add(IntToStr(glCode));

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { Else }
  End; { With oGL }
End; { ImportGLData }

//-----------------------------------------------------------------------------------------

// Job Import
function TDataQuery.ImportJobData (oJob : IJob) : SmallInt;
Var
  FuncRes : LongInt;

  //------------------------

  // Returns TRUE if the current Job record passes the Range and Type filters
  Function WantJob : Boolean;
  Begin { WantJob }
    With oJob Do Begin
      // Check Range Filter
      If FFilterByRange Then
        // Check Code is within the specified range
        Result := (Trim(jrCode) >= FFilterStartStr) And (Trim(jrCode) <= FFilterEndStr)
      Else
        Result := True;

      // Check Type Filter
      If Result And FFilterByType Then Begin
        // Check the Job Type
        Result := ((jrType = JTypeContract) And FFilterJobTypes[JTypeContract]) Or
                  ((jrType = JTypeJob) And FFilterJobTypes[JTypeJob]);
      End; { If Result And FFilterByType }

      // Check Status Filter
      If Result And FFilterByStatus Then Begin
        // Check the Job Status
        Result := ((jrStatus = JStatusQuotation) And FilterJobStatus[JStatusQuotation]) Or
                  ((jrStatus = JStatusActive) And FilterJobStatus[JStatusActive]) Or
                  ((jrStatus = JStatusSuspended) And FilterJobStatus[JStatusSuspended]) Or
                  ((jrStatus = JStatusCompleted) And FilterJobStatus[JStatusCompleted]) Or
                  ((jrStatus = JStatusClosed) And FilterJobStatus[JStatusClosed]);


      End; { If Result And FFilterByType }
    End; { With oJob }
  End; { WantJob }

  //------------------------

  // Processes the Job Codes of a specified Parent Job Code
  Procedure ImportJobChildren (Const ParentCode : ShortString);
  Var
    FuncRes  : LongInt;
    LocalPos : LongInt;
  Begin { ImportJobChildren }
    With oJob Do Begin
      // Run through the parent index processing children as found
      Index := jrIdxParent;
      FuncRes := GetGreaterThanOrEqual(BuildParentIndex(ParentCode, ''));
      While (FuncRes = 0) And (Trim(jrParent) = Trim(ParentCode)) Do Begin
        If WantJob Then
          FDataCodes.Add(jrCode);

        If (jrType = JTypeContract) And (Not FFilterLevel1Only) Then Begin
          // Heading - Save Position and call import function recursively to process it
          SavePosition;
          LocalPos := Position;
          ImportJobChildren (jrCode);
          Position := LocalPos;
          RestorePosition;
        End; { If (jrType = JTypeContract) And (Not FFilterLevel1Only) }

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { With oJob }
  End; { ImportJobChildren }

  //------------------------

Begin { ImportJobData }
  Result := 0;

  With oJob Do Begin
    If FFilterByParent Then
      // Run through tree structure importing the children of a specified Parent
      ImportJobChildren (FFilterParentStr)
    Else Begin
      // Run through in Code Order
      Index := jrIdxCode;
      FuncRes := GetFirst;
      While (FuncRes = 0) Do Begin
        If WantJob Then
          FDataCodes.Add(jrCode);

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { Else }
  End; { With oJob }
End; { ImportJobData }

//-----------------------------------------------------------------------------------------

// Stock Import
function TDataQuery.ImportStockData (oStock : IStock) : SmallInt;
Var
  FuncRes : LongInt;

  //------------------------

  // Returns TRUE if the current Job record passes the Range and Type filters
  Function WantStock : Boolean;
  Begin { WantStock }
    With oStock Do Begin
      // Check Range Filter
      If FFilterByRange Then
        // Check Code is within the specified range
        Result := (Trim(stCode) >= FFilterStartStr) And (Trim(stCode) <= FFilterEndStr)
      Else
        Result := True;

      // Check Type Filter
      If Result And FFilterByType Then Begin
        // Check the Stock Code Type
        Result := ((stType = stTypeProduct) And FilterStockTypes[stTypeProduct]) Or
                  ((stType = stTypeGroup) And FilterStockTypes[stTypeGroup]) Or
                  ((stType = stTypeDescription) And FilterStockTypes[stTypeDescription]) Or
                  ((stType = stTypeBillOfMaterials) And FilterStockTypes[stTypeBillOfMaterials]) Or
                  ((stType = stTypeDiscontinued) And FilterStockTypes[stTypeDiscontinued]);
      End; { If Result And FFilterByType }
    End; { With oStock }
  End; { WantStock }

  //------------------------

  // Processes the Stock Codes of a specified Parent Stock Code
  Procedure ImportStockChildren (Const ParentCode : ShortString);
  Var
    FuncRes  : LongInt;
    LocalPos : LongInt;
  Begin { ImportStockChildren }
    With oStock Do Begin
      // Run through the parent index processing children as found
      Index := stIdxParent;
      FuncRes := GetGreaterThanOrEqual(BuildParentIndex(ParentCode, ''));
      While (FuncRes = 0) And (Trim(stParentCode) = Trim(ParentCode)) Do Begin
        If WantStock Then
          FDataCodes.Add(stCode);

        If (stType = stTypeGroup) And (Not FFilterLevel1Only) Then Begin
          // Heading - Save Position and call import function recursively to process it
          SavePosition;
          LocalPos := Position;
          ImportStockChildren (stCode);
          Position := LocalPos;
          RestorePosition;
        End; { If (stType = stTypeGroup) And (Not FFilterLevel1Only) }

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { With oStock }
  End; { ImportStockChildren }

  //------------------------

Begin { ImportStockData }
  Result := 0;

  With oStock Do Begin
    If FFilterByParent Then
      // Run through tree structure importing the children of a specified Parent
      ImportStockChildren (FFilterParentStr)
    Else Begin
      // Run through in Code Order
      Index := stIdxCode;
      FuncRes := GetFirst;
      While (FuncRes = 0) Do Begin
        If WantStock Then
          FDataCodes.Add(stCode);

        FuncRes := GetNext;
      End; { While (FuncRes = 0) }
    End; { Else }
  End; { With oStock }
End; { ImportStockData }

//-----------------------------------------------------------------------------------------

function TDataQuery.Get_dqResultCount: Integer;
begin
  Result := FDataCodes.Count;
end;

//-----------------------------------

function TDataQuery.Get_dqResults(Index: Integer): WideString;
begin
  If (Index >= 0) And (Index < FDataCodes.Count) Then
    Result := FDataCodes[Index]
  Else
    Raise Exception.Create ('Invalid Index (' + IntToStr(Index) + ') accessing DataCodes');
end;

//-----------------------------------

function TDataQuery.Get_dqMode: TDataQueryMode;
begin
  Result := FMode;
end;

//-----------------------------------

function TDataQuery.Get_dqVersion: WideString;
begin
  Result := DataQueryVersion;
end;

//-----------------------------------

function TDataQuery.Get_dqExcelStartCol: Integer;
begin
  Result := FXLStartCol;
end;

procedure TDataQuery.Set_dqExcelStartCol(Value: Integer);
begin
  FXLStartCol := Value;
end;

//-----------------------------------

function TDataQuery.Get_dqExcelStartRow: Integer;
begin
  Result := FXLStartRow;
end;

procedure TDataQuery.Set_dqExcelStartRow(Value: Integer);
begin
  FXLStartRow := Value;
end;

//-----------------------------------

function TDataQuery.Get_dqImportDirection: TDataQueryDirection;
begin
  Result := FImportDirection
end;

procedure TDataQuery.Set_dqImportDirection(Value: TDataQueryDirection);
begin
  FImportDirection := Value;
end;

//-----------------------------------

function TDataQuery.GetFilterGLTypes(Index: TGeneralLedgerType): Boolean;
begin
  Result := FFilterGLTypes[Index];
end;

procedure TDataQuery.SetFilterGLTypes(Index: TGeneralLedgerType; const Value: Boolean);
begin
  FFilterGLTypes[Index] := Value;
end;

//-----------------------------------

function TDataQuery.GetFilterJobStatus(Index: TJobStatusType): Boolean;
begin
  Result := FFilterJobStatus[Index];
end;

procedure TDataQuery.SetFilterJobStatus(Index: TJobStatusType;
  const Value: Boolean);
begin
  FFilterJobStatus[Index] := Value;
end;

//-----------------------------------

function TDataQuery.GetFilterJobTypes(Index: TJobTypeType): Boolean;
begin
  Result := FFilterJobTypes[Index];
end;

procedure TDataQuery.SetFilterJobTypes(Index: TJobTypeType; const Value: Boolean);
begin
  FFilterJobTypes[Index] := Value;
end;

//-----------------------------------

function TDataQuery.GetFilterStockTypes(Index: TStockType): Boolean;
begin
  Result := FFilterStockTypes[Index];
end;

procedure TDataQuery.SetFilterStockTypes(Index: TStockType; const Value: Boolean);
begin
  FFilterStockTypes[Index] := Value;
end;

//-----------------------------------------------------------------------------------------------

function TDataQuery.GetTypeDesc (Index : TTypeDescStrings) : ShortString;
begin
  If (Index = tsdDataPlural) Then
    Case FMode Of
      dqmCostCentre : Result := 'Cost Centres';
      dqmCustomer   : Result := 'Customers';
      dqmDepartment : Result := 'Departments';
      dqmGLCode     : Result := 'GL Codes';
      dqmJob        : Result := 'Jobs';
      dqmLocation   : Result := 'Locations';
      dqmStock      : Result := 'Stock';
      dqmSupplier   : Result := 'Suppliers';
    Else
      Result := 'Data';
    End { Else }
  Else
    If (Index = tdsDataSingular) Then
      Case FMode Of
        dqmCostCentre : Result := 'Cost Centre';
        dqmCustomer   : Result := 'Customer';
        dqmDepartment : Result := 'Department';
        dqmGLCode     : Result := 'GL Code';
        dqmJob        : Result := 'Job';
        dqmLocation   : Result := 'Location';
        dqmStock      : Result := 'Stock';
        dqmSupplier   : Result := 'Supplier';
      Else
        Result := 'Data';
      End { Else }
    Else
      Result := 'Data';
end;

//------------------------------

function TDataQuery.GetTypeContext : LongInt;
Begin // GetTypeContext
  Case FMode Of
    dqmCostCentre : Result := 100;
    dqmCustomer   : Result := 101;
    dqmDepartment : Result := 100;
    dqmGLCode     : Result := 102;
    dqmJob        : Result := 103;
    dqmLocation   : Result := 104;
    dqmStock      : Result := 105;
    dqmSupplier   : Result := 101;
  Else
    Result := 0;
  End { Else }
End; // GetTypeContext


//-----------------------------------

function TDataQuery.GetCOMTK: IToolkit;
Var
  A, B, C : longint;
begin
  If (Not Assigned(FCOMTK)) Then Begin
    FCOMTK := CoToolkit.Create;
    With FCOMTK.Configuration Do Begin
      // Setup Backdoor to avoid licencing
      EncodeOpCode(97, A, B, C);
      SetDebugMode (A, B, C);

      // Any other configuration details ?

    End; { With FCOMTK.Configuration }
  End; { If (Not Assigned(FCOMTK)) }

  Result := FCOMTK;
end;

//-----------------------------------------------------------------------------------------------

procedure TDataQuery.ExecuteAbout(const AddInVer: WideString);
begin
  With TfrmAbout.Create (Application.MainForm) Do
    Try
      lblExcelAddInVer.Caption := ExchequerModuleVersion (emExcelDataQueryAddIn, AddInVer);
      lblCOMServerVer.Caption := DataQueryVersion;

      ShowModal;
    Finally
      Free;
    End;
end;

//-----------------------------------------------------------------------------------------------

function TDataQuery.Get_dqLicencing(Index: TDataQueryLicencing): WordBool;
begin
  If (Index <= High(LicArray)) Then
    Result := LicArray[Index]
  Else
    Raise Exception.Create ('TDataQuery.dqLicencing - Invalid Index (' + IntToStr(Ord(Index)) + ')');
end;

//-----------------------------------------------------------------------------------------------

Procedure LoadLicencing;
Const
  ServerName = 'Enterprise.DataQuery';
Var
  LicR    : EntLicenceRecType;
Begin { LoadLicencing }
  // Initialise all licences to OFF
  FillChar (LicArray, SizeOf (LicArray), #0);

(*** HM 09/08/04: Rewrote for VAO awareness
  // Identify directory containing Exchequer from Registry
  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      SvrPath := '';
      If KeyExists ('Clsid\'+GUIDToString(CLASS_DataQuery)+'\InprocServer32') Then
        If OpenKey('Clsid\'+GUIDToString(CLASS_DataQuery)+'\InprocServer32', False) Then
          SvrPath := ReadString ('');

      CloseKey;
    Finally
      Free;
    End;

  If (SvrPath <> '') And FileExists (SvrPath) Then
    If FileExists (ExtractFilePAth(SvrPath) + EntLicFName) Then
      If ReadEntLic (ExtractFilePAth(SvrPath) + EntLicFName, LicR) Then Begin
        LicArray [dqlStock] := (LicR.licEntModVer >= 1);
        LicArray [dqlJobCosting] := (LicR.licModules[modJobCost] >= 1);
      End; { If ReadEntLic }
***)

  // Startup the branding engine
  InitBranding (VAOInfo.vaoAppsDir);

  // VAO - Load licence from directory containing main company
  If FileExists (VAOInfo.vaoCompanyDir + EntLicFName) Then
  Begin
    If ReadEntLic (VAOInfo.vaoCompanyDir + EntLicFName, LicR) Then
    Begin
      LicArray [dqlStock] := (LicR.licEntModVer >= 1);
      LicArray [dqlJobCosting] := (LicR.licModules[modJobCost] >= 1);
    End; // If ReadEntLic (VAOInfo.vaoCompanyDir + EntLicFName, LicR)
  End; // If FileExists (VAOInfo.vaoCompanyDir + EntLicFName)
End; { LoadLicencing }

//-----------------------------------------------------------------------------------------------


initialization
  TAutoObjectFactory.Create(ComServer, TDataQuery, Class_DataQuery,
    ciSingleInstance, tmApartment);

  LoadLicencing;
end.
