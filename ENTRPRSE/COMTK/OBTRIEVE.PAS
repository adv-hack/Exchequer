unit oBtrieve;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, BtrvU2, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, ExWrap1U,
     ExBtTh1U, GlobList, EnterpriseBeta_TLB, CacheStat, TKSQL, MultiBuyVar, QtyBreakVar, ExceptIntf;

//===========================================================================
//
//  Btrieve Client-Id List
//  ======================
//
//   CId  Objects using Client-Id        Opened Files
//  ----+------------------------------+--------------------------------------
//   1    TAccount (Customer)            CustF
//        TNotes (Customer)              PwrdF
//        TAccountDiscount (Customer)    MiscF, StockF
//
//   2    TAccount (Supplier)            CustF
//        TNotes (Supplier)              PwrdF
//        TAccountDiscount (Supplier)    MiscF, StockF
//
//   3    TStock                         StockF
//        TNotes (Stock)                 PwrdF
//        TQuantityBreak (Stock)         MiscF
//
//   4    TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//   5    TGeneralLedger                 NomF
//
//   6    TLocation                      MLocF
//        TNotes (Location)              PwrdF
//
//   7    TCCDept (Cost Centre)          PwrdF
//
//   8    TCCDept (Department)           PwrdF
//
//   9    TStockLocation (Location)      MLocF
//
//   10   TStockLocation (Stock)         MLocF
//
//   11   TJob                           JobF
//        TNotes (Job)                   PwrdF
//        TLinks (Job)                   MiscF
//        TTimeRates (Job)               JCtrlF
//
//   12   TMatching                      PwrdF
//
//   13   TQuantityBreak (Customer)      MiscF
//
//   14   TQuantityBreak (Supplier)      MiscF
//
//   15   TJobType                       JMiscF
//
//   16   TJobAnalysis                   JMiscF
//
//   17   TStockBOM (Where Used)         StockF, PwrdF
//
//   18   TStockBOM (Bill Of Materials)  StockF, PwrdF
//
//   19   TEmployee                      JMiscF
//        TTimeRates (Employee)          JCtrlF
//        TNotes (Employee)              PwrdF
//
//   20   TTimeRates  (Global)           JCtrlF
//
//   21   TSerialBatch (Stock)           MiscF
//        TNotes (Serial)                PwrdF
//
//   22   TTransLineSerialBatch          StockF, MiscF
//        TNotes (Serial)                PwrdF
//
//   23   TUserProfile                   MLocF
//
//   24   TTransactionDetails            IDetailF
//
//   25   TSystemSetupFormDefinitions    SysF
//
//   26   TJobRetention (Sales - Job)    JDetlF, JobF, JobMiscF, CustF, InvF, IDetailF, PwrdF
//
//   27   TJobRetention (Purchase - Job) JDetlF, JobF, JobMiscF, CustF, InvF, IDetailF, PwrdF
//
//   28   TJobRetention (Sales - Global) JDetlF, JobF, JobMiscF, CustF, InvF, IDetailF, PwrdF
//
//   29   TJobRetention (Purch - Global) JDetlF, JobF, JobMiscF, CustF, InvF, IDetailF, PwrdF
//
//   30   TSummaryJobBudget              JCtrlF
//
//   31   TAnalysisJobBudget             JCtrlF, JMiscF
//
//   32   TStockOrRateJobBudget          JCtrlF, JMiscF, StockF
//
//   33   TCISVoucher                    JDetlF, MiscF
//
//   34   TJobInvoice                    CustF, InvF, IDetailF, JDetlf, JobF, MiscF, JMiscF, IncF, NHistF
//
//   35   TJobActual                     JDetlF
//
//   36   TAltStockCode                  MLocF
//        TNotes(AltStockCode)           PWrdF
//
//   37   TMultiBin                      MLocF
//
//   38   TTransactionLineMultiBin       MLocF
//
//   39   TSalesAnalysis                 MLocF
//
//   40   JobApplications - ContractTerms
//        TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//   41   JobApplications - SalesTerms
//        TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//   42   JobApplications - PurchaseApplications
//        TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//   43   JobApplications - SalesApplications
//        TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//   44   JobApplications - PurchaseTerms & MasterSalesTerms
//        TTransaction                   CustF, InvF, IDetailF, StockF, MLocF, JCtrlF, JMiscF,
//        TNotes (Transaction)           PwrdF
//        TLinks (Transaction)           MiscF
//
//
//   45   TAltStockCode     (Equivalent) MLocF
//        TNotes                  "      PWrdF
//
//
//   46   TAltStockCode     (Superseded) MLocF
//        TNotes                  "      PWrdF
//
//
//   47   TAltStockCode   (Opportunity)  MLocF
//        TNotes                "        PWrdF
//
//
//   48   TSystemSetupReturnLinereason   MiscF
//
//
//   49   TBankAccount                   MLocF
//
//
//   50   TBankStatement                 MLocF
//
//
//   51   TBankStatementLine             MLocF
//
//   52   TBankReconciliation            MLocF
//
//
//   53   TBankReconciliationLine        MLocF
//
//
//   54   This is used by Check_SOPLink in BTS1.pas to lock InvF
//
//
//   55   TVAT100                        VAT100 (uses oBtrieveFile)
//   56   TVAT100 - Add                  VAT100 'Add' object
//   57   TVAT100 - Update               VAT100 'Update' object
//   58   TVAT100 - Clone                VAT100 'Clone' object
//
//
//  NOTE: ClientId's cannot be shared across objects as the
//  files will be closed whenever an object is destroyed.
//
//===========================================================================

//Constants for dealing with SQL fieldnames for PreFill Cache
const
  tkoCustomer         = 1;
  tkoSupplier         = 2;
  tkoDocument         = 3;
  tkoDetail           = 4;
  tkoStock            = 5;
  tkoNominal          = 6;

  tkoNotes            = 7;
  tkoMatching         = 8;
  tkoBOM              = 9;
//  tkoCCDept           = 10;
  tkoCustDisc         = 11;
  tkoSuppDisc         = 12;
  tkoMLoc             = 13;
  tkoQtyBreak         = 14;

  tkoJob              = 15;

  tkoStockLocation    = 16;
  tkoCostCentre       = 17;
  tkoDepartment       = 18;
  tkoUserProfile      = 19;
  tkoSerialBatch      = 20;
  tkoMultiBin         = 21;
  tkoJobActual        = 22;
  tkoSalesRet         = 23;
  tkoPurchRet         = 24;
  tkoBankAccount      = 25;
  tkoBankStatHead     = 26;
  tkoBankStatLine     = 27;
  tkoAltStock         = 28;
  tkoEmployee         = 29;
  tkoLink             = 30;
  tkoJobAnalysis      = 31;
  tkoJobType          = 32;
  tkoStockSalesAnal   = 33;
  tkoCustSalesAnal    = 34;

  //Set of files which don't have variant records
  //PR: 21/05/2014 ABSEXCH-15238 Add SysF to non-variant set. Also add MultiBuy & QtyBreak
  NonVariantSet = [CustF, InvF, IdetailF, NomF, StockF, JobF, SysF, MultiBuyF, QtyBreakF];

Type
  RecDataArrayType = Array [1..10000] Of Byte;

  TBtrieveFileSavePos = Record
    fsFileNo   : SmallInt;
    fsKeyPath  : Integer;
    fsStatus   : SmallInt;
    fsRecAddr  : LongInt;

    // HM 09/03/01: Added support for savng record contents as well as position
    fsRecData  : Pointer;
    fsRecSize  : LongInt;
  End; { TBtrieveFileSavePos }

  // Structure used when saving positions of global files
  TBtrieveSavePosType = Record
    spSaved      : Array [1..MaxFiles] Of Boolean;  // Position Saved Y/N
    spStatus     : Array [1..MaxFiles] Of SmallInt; // Status
    spRecAddr    : Array [1..MaxFiles] Of LongInt;  // Record Address
    spKeyPath    : Array [1..MaxFiles] Of Integer; // KeyPath
  End; { TBtrieveSavePosType }

  FileSet = Set Of Byte;

  // Basic Btrieve Functions to be inherited by classes
  TBtrieveFunctions = class(TAutoIntfObjectEx, IBtrieveFunctions, IBtrieveFunctions2, IDatabaseFunctions, ISQLFunctions,
                            ICacheStatus)
  protected
    FFileNo        : Byte;             // File Index
    FIndex         : Byte;             // Current Index
    FLockCount     : SmallInt;         // Number of record locks
    FLockPosition  : LongInt;          // Last Lock Position
    FRecPosition   : LongInt;          // Saved Record Position
    FKeyString     : ShortString;      // Current Key Value

    FBtrIntf       : TCtkTdPostExLocalPtr;

    //Fields for handling Pre-fill cache in SQL version
    FCacheID : longint;                // Id of cache
    FCacheClientID :  ^ClientIdType;   // ClientID for cache - a copy of FBtrIntf.ExClientID
    FColumns : AnsiString;             // List of columns to be returned
    FWhereClause : AnsiString;         // SQL condition for selecting records
    FCacheLastReloaded : TDateTime;    // Time that custom cache was last reloaded
    FObjectID : Integer;               // Identifies the type of object
    FUseCache : Boolean;               // When true Get calls go to the cache
    FAutoRefreshCache : Boolean;       // If true then we automatically refresh the cache
    FCustomCacheRefreshInterval : longint; // Interval for reloading custom cache
    FSQLParentKey : string;            // String to add to the query for limiting rows returned to those for parent object
    FRecordSubType : Char;
    FFilesUsed : Set of Byte;
    FSQLRedirect : TSQLRedirect;

    function  GetFirst: Integer; safecall;
    function  GetPrevious: Integer; safecall;
    function  GetNext: Integer; safecall;
    function  GetLast: Integer; safecall;

    function  Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;

    function  Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;

    function  RestorePosition: Integer; safecall;
    function  SavePosition: Integer; safecall;

    function  StepFirst: Integer; safecall;
    function  StepPrevious: Integer; safecall;
    function  StepNext: Integer; safecall;
    function  StepLast: Integer; safecall;

    function  Lock: Integer; Virtual; safecall;
    function  Unlock: Integer; Virtual; safecall;
    function  LockCID: Integer; Virtual; safecall;
    function  UnlockCID: Integer; Virtual; safecall;
    function  DummyLock : Integer; Virtual; safecall;

    function  Get_KeyString: WideString; safecall;
    function Get_KeyString2: WideString; Virtual; safecall;

    function  GetLessThan(const SearchKey: WideString): Integer; safecall;
    function  GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function  GetEqual(const SearchKey: WideString): Integer; safecall;
    function  GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function  GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;

    Function  PositionOnLock : SmallInt;

    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Virtual;
    procedure  AuthoriseSQLFuncs; virtual;

    Procedure CopyDataRecord; Virtual; Abstract;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Virtual; Abstract;
    Function  TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; Virtual;

    Procedure SaveExLocalPosFile (Const FileNo : SmallInt; Var SaveInfo : TBtrieveFileSavePos);
    Procedure SaveExLocalPos (Var SaveInfo : TBtrieveFileSavePos);
    Procedure RestoreExLocalPos (SaveInfo : TBtrieveFileSavePos);

    Procedure SaveMainPos(Var SaveInfo : TBtrieveFileSavePos);
    Procedure RestoreMainPos(SaveInfo : TBtrieveFileSavePos);

    // HM 09/03/01: Added support for savng record contents as well as position
    Procedure SaveExLocalPosRec(Var   SaveInfo : TBtrieveFileSavePos;
                                Const RecPtr   : Pointer;
                                Const RecSize  : LongInt);

    Procedure RestoreExLocalPosRec (Var   SaveInfo : TBtrieveFileSavePos;
                                    Const RecPtr   : Pointer;
                                    Const RecSize  : LongInt);
    function SetKeyString(BtrOp: SmallInt; const NewKey: string) : string;

    // ISQLFunctions
    function LoadCache: Integer; safecall;
    function UnloadCache: Integer; safecall;
    function Get_sqlUseCache: WordBool; safecall;
    procedure Set_sqlUseCache(Value: WordBool); safecall;
    function Get_sqlQuery: WideString; safecall;
    procedure Set_sqlQuery(const Value: WideString); safecall;
    function Get_sqlRequiredFields: WideString; safecall;
    procedure Set_sqlRequiredFields(const Value: WideString); safecall;
    function Get_sqlAutoRefreshCache: WordBool; safecall;
    procedure Set_sqlAutoRefreshCache(Value: WordBool); safecall;
    function Get_sqlCacheRefreshInterval: Integer; safecall;
    procedure Set_sqlCacheRefreshInterval(Value: Integer); safecall;
    function TranslateFieldNames(const FieldNames: WideString): WideString; safecall;
    function Get_sqlDefaultQuery: WideString; safecall;

    //Internal functions for using Prefill Cache
    function LoadTheCache : Integer; virtual;
    procedure UseCache;
    function UnloadTheCache : Integer;
    procedure ReloadCache;
    function NeedToReloadCache : Boolean;

    procedure SetSQLCaching(SubType : Char = ' '); virtual;
    function FullQuery : WideString;

    function UsingRedirectCache : Boolean;

    //ICacheStatus
    procedure SetFileChanged(FileNo, ClientID : Integer);
  public
    constructor Create(Const TypeLib  : ITypeLib;
                       Const DispIntf : TGUID;
                       Const BtrIntf  : TCtkTdPostExLocalPtr);
    Destructor Destroy; Override;

    Procedure RestoreSystemFilePos (Var PrevPos : TBtrieveSavePosType);
    Function SaveSystemFilePos (IncSet : FileSet) : TBtrieveSavePosType;
    procedure SetFileNos(const FileNos : Array of Byte);


    Property LockCount : SmallInt Read FLockCount Write FLockCount;
    Property LockPosition : LongInt Read FLockPosition Write FLockPosition;

  End; { TBtrieveFunctions }

var
  SQLBeingUsed : Boolean;

implementation

Uses BtSupU1, DLLTH_Up, SQLUtils, SQLFields, VarCnst3, DateUtils, MiscFunc;

{-------------------------------------------------------------------------------------------------}

constructor TBtrieveFunctions.Create(Const TypeLib  : ITypeLib;
                                     Const DispIntf : TGUID;
                                     Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  Inherited Create (TypeLib, DispIntF);

  { Create EXLocal object }
  FBtrIntf := BtrIntf;
  {New (FBtrIntf, Create(FClientId));
  FBtrIntf^.Open_System(CustF, CustF);}
  New(FCacheClientID);
  // File Index - Overridden by descendant classes
  FFileNo := 1;
  // Current Index
  FIndex  := 0;
  // Number of record locks performed
  FLockCount := 0;
  // Last Lock Position
  FLockPosition := 0;
  // Saved Record Position
  FRecPosition  := 0;
  // Current Key Value
  FKeyString := '';

  FCacheID := 0;
  FAutoRefreshCache := True;
  FCustomCacheRefreshInterval := 15;
  FSQLParentKey := '';
  FRecordSubType := ' ';
  FUseCache := False;

end;

Destructor TBtrieveFunctions.Destroy;
Begin { Destroy }
  // Unlocak any locked records
  If (FLockCount > 0) Then Unlock;

  //Release any Prefill cache
  if FCacheID > 0 then
    UnloadTheCache;

  Dispose(FCacheClientID);

  if Assigned(FSQLRedirect) then
  begin
    FSQLRedirect.Close;
    FSQLRedirect.Free;
  end;
  Inherited Destroy;
End; { Destroy }

{-------------------------------------------------}

function TBtrieveFunctions.GetFirst: Integer;
begin
  AuthoriseFunction(5, 'GetFirst');
  SetSQLCaching;

  Result := GetDataRecord (B_GetFirst);
end;

function TBtrieveFunctions.GetPrevious: Integer;
begin
  AuthoriseFunction(6, 'GetPrevious');
  SetSQLCaching;
  Result := GetDataRecord (B_GetPrev);
end;

function TBtrieveFunctions.GetNext: Integer;
begin
  AuthoriseFunction(7, 'GetNext');
  SetSQLCaching;
  Result := GetDataRecord (B_GetNext);
end;

function TBtrieveFunctions.GetLast: Integer;
begin
  AuthoriseFunction(8, 'GetLast');
  SetSQLCaching;
  Result := GetDataRecord (B_GetLast);
end;

{-------------------------------------------------}

Function TBtrieveFunctions.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
begin
  Result := IdxNo;
end;

function TBtrieveFunctions.Get_Index : Integer;
begin
  AuthoriseFunction(14, 'Index', 1);
  Result := TranslateIndex (FIndex, False);
end;

procedure TBtrieveFunctions.Set_Index(Value: Integer);
Var
  {lStatus,} NewIdx : Integer;
  CurrPos         : LongInt;
begin
  AuthoriseFunction(14, 'Index', 1);

  { Convert Index to Enterprise Index Number }
  NewIdx := TranslateIndex (Value, True);

  { Check value has changed }
  If (NewIdx <> FIndex) Then
    With FBtrIntf^ Do Begin
      { Get current record position}
      lStatus := LGetPos(FFileNo, CurrPos);

      { Change Index }
      FIndex := NewIdx;

      // HM 16/02/04: Added missing Begin..End
      If (lStatus = 0) Then Begin
        { Restore position in file under new index }
        LSetDataRecOfs(FFileNo, CurrPos);
        lStatus := LGetDirect(FFileNo, FIndex, 0);
      End; // If (lStatus = 0)
    End; { With FBtrIntf^ }
end;

{-------------------------------------------------}

function TBtrieveFunctions.Get_Position: Integer;
begin
  AuthoriseFunction(15, 'Position', 1);

  Result := FRecPosition;
end;

procedure TBtrieveFunctions.Set_Position(Value: Integer);
begin
  AuthoriseFunction(15, 'Position', 1);

  FRecPosition := Value;
end;

function TBtrieveFunctions.SavePosition: Integer;
begin
  AuthoriseFunction(16, 'SavePosition');

  // Get Record Position
  Result := FBtrIntf^.LGetPos(FFileNo, FRecPosition);
  If (Result <> 0) Then Inc (Result, 30000);
end;

function TBtrieveFunctions.RestorePosition: Integer;
Var
  KeyS : Str255;
  lRes : LongInt;
begin
  AuthoriseFunction(17, 'RestorePosition');

  With FBtrIntf^ Do Begin
    // Copy Record Position into Data Record
    LSetDataRecOfs(FFileNo, FRecPosition);

    // Read Record
    // HM 29/01/01: Modified to allow the return of the KeyString
    //Result := LGetDirect(FFileNo, FIndex, 0);
    KeyS := '';
    Result := CTK_GetDirectCId(LocalF^[FFileNo], FFileNo, LRecPtr[FFileNo]^, FIndex, 0, KeyS, ExClientId);
    If (Result <> 0) Then Inc (Result, 30000);

    // HM 29/01/01: Added Copy Data Record to update object properties
    If (Result = 0) Then Begin
      // Get object to update itself
      CopyDataRecord;

      // Update KeyString
      FKeyString := KeyS;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }
end;

{-------------------------------------------------}

// Locks the current record in the global file
function TBtrieveFunctions.Lock : Integer;
Var
  SaveInfo : TBtrieveFileSavePos;
  lRes     : LongInt;
begin
  With FBtrIntf^ Do Begin
    // Save position in global file
    SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (FFileNo, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
      SetDataRecOfsPtr (FFileNo, FLockPosition, RecPtr[FFileNo]^);

      // Reread and lock record
      Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, B_SingLock + B_SingNWLock);
      If (Result = 0) Then
      begin
        {PR 22/08/2008 - Need to refresh object's data record from the record we've just read - otherwise the
         Update object may have old data.}
        // Record Locked
        Inc (FLockCount);
        Move(RecPtr[FFileNo]^, LRecPtr[FFileNo]^, FileRecLen[FFileNo]);
        CopyDataRecord;
      end
      Else
        // Error
        Inc (Result, 31000);
    End { If (Result = 0) }
    Else
      // Error getting current record position
      Inc (Result, 30000);

    // restore position in global file
    RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;

// Unlocks a previously locked record
function TBtrieveFunctions.Unlock: Integer;
Var
  KeyS : Str255;
begin
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(FFileNo, FLockPosition, RecPtr[FFileNo]^);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^, 0, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;

{-------------------------------------------------}

// Locks the current record in the global file using the client ID
function TBtrieveFunctions.LockCID : Integer;
Var
  SaveInfo : TBtrieveFileSavePos;
  lRes     : LongInt;
  KeyS     : Str255;
begin
  With FBtrIntf^ Do Begin
    // Save position in global file
    SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (FFileNo, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
      LSetDataRecOfs (FFileNo, FLockPosition);

      // Reread and lock record
      Result := LGetDirect(FFileNo, FIndex, B_SingLock + B_SingNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount)
      Else
        // Error
        Inc (Result, 31000);
    End { If (Result = 0) }
    Else
      // Error getting current record position
      Inc (Result, 30000);

    // restore position in global file
    RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;

// Unlocks a previously locked record using the client id
function TBtrieveFunctions.UnlockCID: Integer;
Var
  KeyS : Str255;
begin
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    FBtrIntf^.LSetDataRecOfs(FFileNo, FLockPosition);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
//    Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^, 0, KeyS);
    Result := FBtrIntf^.LFind_Rec(B_Unlock, FFileNo, FIndex, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;

{-------------------------------------------------}


function TBtrieveFunctions.DummyLock : Integer;
Var
  SaveInfo : TBtrieveFileSavePos;
  lRes     : LongInt;
begin
  With FBtrIntf^ Do Begin
    // Save position in global file
    SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (FFileNo, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
      SetDataRecOfsPtr (FFileNo, FLockPosition, RecPtr[FFileNo]^);

      // Reread and lock record
      Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, 0);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount)
      Else
        // Error
        Inc (Result, 31000);
    End { If (Result = 0) }
    Else
      // Error getting current record position
      Inc (Result, 30000);

    // restore position in global file
    RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;


{-------------------------------------------------}

function TBtrieveFunctions.Get_KeyString: WideString;
begin { Get_KeyString }
  AuthoriseFunction(18, 'KeyString', 1);
  Result := FKeyString;
end; { Get_KeyString }

function TBtrieveFunctions.Get_KeyString2: WideString;
begin
  AuthoriseFunction(18, 'KeyString', 1);
  Result := FKeyString;
end;

{-------------------------------------------------}

function TBtrieveFunctions.StepFirst: Integer;
begin
  AuthoriseFunction(1, 'StepFirst');
  Result := GetDataRecord (B_StepFirst);
end;

function TBtrieveFunctions.StepPrevious: Integer;
begin
  AuthoriseFunction(2, 'StepPrevious');
  Result := GetDataRecord (B_StepPrev);
end;

function TBtrieveFunctions.StepNext: Integer;
begin
  AuthoriseFunction(3, 'StepNext');
  Result := GetDataRecord (B_StepNext);
end;

function TBtrieveFunctions.StepLast: Integer;
begin
  AuthoriseFunction(4, 'StepLast');
  Result := GetDataRecord (B_StepLast);
end;

{-------------------------------------------------}

function TBtrieveFunctions.GetLessThan(const SearchKey: WideString): Integer;
begin
  AuthoriseFunction(9, 'GetLessThan');
  SetSQLCaching;
  Result := GetDataRecord (B_GetLess, SearchKey);
end;

function TBtrieveFunctions.GetLessThanOrEqual(const SearchKey: WideString): Integer;
begin
  AuthoriseFunction(10, 'GetLessThanOrEqual');
  SetSQLCaching;
  Result := GetDataRecord (B_GetLessEq, SearchKey);
end;

function TBtrieveFunctions.GetEqual(const SearchKey: WideString): Integer;
begin
  AuthoriseFunction(11, 'GetEqual');
//  if not FUseCache then
    SetSQLCaching;
  Result := GetDataRecord (B_GetEq, SearchKey);
end;

function TBtrieveFunctions.GetGreaterThan(const SearchKey: WideString): Integer;
begin
  AuthoriseFunction(12, 'GetGreaterThan');
  SetSQLCaching;
  Result := GetDataRecord (B_GetGretr, SearchKey);
end;

function TBtrieveFunctions.GetGreaterThanOrEqual(const SearchKey: WideString): Integer;
begin
  AuthoriseFunction(13, 'GetGreaterThanOrEqual');
  SetSQLCaching;
  Result := GetDataRecord (B_GetGEq, SearchKey);
end;

{-------------------------------------------------}

// Called to Authorise a TBtrieveFunctions method call or property access
//
// FuncNo:
//  StepFirst (1), StepPrevious (2), StepNext (3), StepLast (4),
//  GetFirst (5), GetPrevious (6), GetNext (7), GetLast (8),
//  GetLessThan (9), GetLessThanOrEqual (10), GetEqual (11),
//  GetGreaterThan (12), GetGreaterThanOrEqual (13), Get/Set Index (14),
//  Get/Set Position (15), SavePosition (16), RestorePosition (17),
//  GetKeyString (18)
//
//  Decendant objects should start at next 100 block, e.g. Desc1 = 100-199,
//  Desc2 200-299, Desc3 300-399, etc...
//
// MethodName: Textual Description of method or property
//
// AccessType: 0=Method, 1=Property
Function TBtrieveFunctions.AuthoriseFunction (Const FuncNo     : Byte;
                                              Const MethodName : String;
                                              Const AccessType : Byte = 0) : Boolean;
begin
  Result := True;
end;

{-------------------------------------------------}

// Saves the positions of all the Btrieve files to an internal structure
Function TBtrieveFunctions.SaveSystemFilePos (IncSet : FileSet) : TBtrieveSavePosType;
Const
  BaseFileSet : FileSet = [CustF, InvF, IDetailF, StockF, MLocF, NomF, MiscF, PwrdF, JobF, JCtrlF, JMiscF];
Var
  SaveInfo : TBtrieveSavePosType;
  I        : Byte;
begin
  FillChar (SaveInfo, SizeOf(SaveInfo), #0);

  // Setup default file sets where necessary
  If (IncSet = []) Then
    IncSet := BaseFileSet
  Else
    If (IncSet = [255]) Then
      IncSet := BaseFileSet + [SysF, IncF, NHistF, JDetlF];

  With SaveInfo Do
    For I := 1 To MaxFiles Do
      // Check to see if file position is to be saved
      If (I In IncSet) Then Begin
        // Save Position
        spSaved[I] := True;
        spKeyPath[I] := GetPosKey;
        spStatus[I] := Presrv_BTPos (I, spKeyPath[I], F[I], spRecAddr[I], BOff, BOff);
      End; { If (I In IncSet) Or (IncSet = []) }

  Result := SaveInfo;
end;

// Restores the file positions saved by SaveSystemFilePos
Procedure TBtrieveFunctions.RestoreSystemFilePos (Var PrevPos : TBtrieveSavePosType);
Var
  I : Byte;
begin
  With PrevPos Do
    For I := 1 To MaxFiles Do
      // Check to see if position saved }
      If spSaved[I] And (spStatus[I] = 0) Then Begin
        // Restore position
        spStatus[I] := Presrv_BTPos(I, spKeyPath[I], F[I], spRecAddr[I], BOn, BOff);
      End { If }
end;

{-------------------------------------------------}

// Repositions the file on the locked record
Function TBtrieveFunctions.PositionOnLock : SmallInt;
Var
  KeyS : Str255;
Begin { PositionOnLock }
  Result := 0;
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr (FFileNo, FLockPosition, RecPtr[FFileNo]^);

    // Get Record
    Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, 0);
  End; { If (FLockCount > 0) }
End; { PositionOnLock }

{-------------------------------------------------}

// Saves the position in the objects main file
Procedure TBtrieveFunctions.SaveExLocalPosFile (Const FileNo : SmallInt; Var SaveInfo : TBtrieveFileSavePos);
Begin { SaveExLocalPos }
  FillChar(SaveInfo, SizeOf(SaveInfo), #0);
  With FBtrIntF^, SaveInfo Do Begin
    fsFileNo  := FileNo;
    fsKeyPath := FIndex;

    fsStatus := LGetPos (FileNo, fsRecAddr);
  End; { With SaveInfo }
End; { SaveExLocalPos }

Procedure TBtrieveFunctions.SaveExLocalPos(Var SaveInfo : TBtrieveFileSavePos);
Begin { SaveExLocalPos }
  SaveExLocalPosFile (FFileNo, SaveInfo);
End; { SaveExLocalPos }

// Saves the position in the objects main file
Procedure TBtrieveFunctions.RestoreExLocalPos(SaveInfo : TBtrieveFileSavePos);
Begin { RestoreExLocalPos }
  With FBtrIntf^, SaveInfo Do Begin
    // Restore index (if applicable) }
    If (fsFileNo = FFileNo) Then
      FIndex := fsKeyPath;

    // Copy Record Position into Data Record
    LSetDataRecOfs(fsFileNo, fsRecAddr);

    // Read Record
    LGetDirect(fsFileNo, fsKeyPath, 0);
 End; { With SaveInfo }
End; { RestoreExLocalPos }

{-------------------------------------------------}

// Saves position and record contents
Procedure TBtrieveFunctions.SaveExLocalPosRec(Var   SaveInfo : TBtrieveFileSavePos;
                                              Const RecPtr   : Pointer;
                                              Const RecSize  : LongInt);
Begin { SaveExLocalPosRec }
  SaveExLocalPosFile (FFileNo, SaveInfo);

  If (RecSize > 0) Then
    With SaveInfo Do Begin
      // Save size of saved data
      fsRecSize := RecSize;

      // Allocate memory for data
      GetMem (fsRecData, fsRecSize);

      // Copy data into memory
      Move (RecPtr^, fsRecData^, fsRecSize);
    End; { With SaveInfo }
End; { SaveExLocalPosRec }

// Restores position and record contents
Procedure TBtrieveFunctions.RestoreExLocalPosRec (Var   SaveInfo : TBtrieveFileSavePos;
                                                  Const RecPtr   : Pointer;
                                                  Const RecSize  : LongInt);
begin { RestoreExLocalPosRec }
  RestoreExLocalPos(SaveInfo);

  If (RecSize > 0) Then
    With SaveInfo Do Begin
      // Check memory size matches
      If (RecSize = fsRecSize) Then Begin
        // Copy memory back into data block
        Move (fsRecData^, RecPtr^, fsRecSize);

        // De-allocate memory for data
        FreeMem (fsRecData);

        // Reset variables to avoid multiple restores
        fsRecData := NIL;
        fsRecSize := 0;
      End { If (RecSize = fsRecSize) }
      Else
        // Saved memory different size to restore area!
        Raise Exception.Create ('RestoreExLocalPosRec (' + IntToStr(fsFileNo) + '): Record Length Mismatch');
    End; { With SaveInfo }
end; { RestoreExLocalPosRec }

{-------------------------------------------------}

// Saves the position in the global file
Procedure TBtrieveFunctions.SaveMainPos(Var SaveInfo : TBtrieveFileSavePos);
Begin { SaveMainPos }
  FillChar(SaveInfo, SizeOf(SaveInfo), #0);
  With SaveInfo Do Begin
    fsFileNo  := FFileNo;
    fsKeyPath := GetPosKey;

    fsStatus := Presrv_BTPos(FFileNo, fsKeyPath, F[FFileNo], fsRecAddr, BOff, BOff);
  End; { With SaveInfo }
End; { SaveMainPos }

// Saves the position in the global file
Procedure TBtrieveFunctions.RestoreMainPos(SaveInfo : TBtrieveFileSavePos);
Begin { RestoreMainPos }
  With SaveInfo Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(FFileNo, fsKeyPath, F[FFileNo], fsRecAddr, BOn, BOff);
End; { RestoreMainPos }

{-------------------------------------------------}


function TBtrieveFunctions.SetKeyString(BtrOp: SmallInt; const NewKey: string): string;
begin
  //PR 08/01/2007 If GetNext or GetPrev then we need to pass in the KeyString returned from the previous operation
  if BtrOp in [B_GetNext, B_GetPrev] then
    Result := FKeyString
  else
    Result := NewKey;
end;

//PR 09/05/2008 Added functions for dealing with prefill cache in SQL version
function TBtrieveFunctions.LoadTheCache : integer;
begin
  if FColumns = '' then
    FColumns := GetFieldsForToolkitObject(FObjectID);
  Result := CreateCustomPrefillCache(SetDrive + Filenames[FFileNo], FullQuery, FColumns, FCacheID, FBtrIntf.ExClientId);
  if Result <> 0 then
  begin
    FCacheID := 0;
    FCacheClientID^ := FBtrIntf.ExClientId^;
  end;
  FCacheLastReloaded := Now;
end;

function TBtrieveFunctions.UnloadTheCache : Integer;
begin
  Result := 0;
  if FCacheID > 0 then
  begin
    DropCustomPrefillCache(FCacheID, FCacheClientId);
    FCacheID := 0;
{    FColumns := '';}
  end;
end;

procedure TBtrieveFunctions.UseCache;
begin
  if not UsingRedirectCache then
    if FCacheID > 0 then
      UseCustomPrefillCache(FCacheID, FBtrIntf.ExClientID);
end;

function TBtrieveFunctions.NeedToReloadCache: Boolean;
//Function which will return true if the prefill cache needs to be reloaded
var
  CurrentInterval : longint;
begin
  Result := (Trim(FWhereClause) <> '') and (FCacheID = 0);
  if not Result then
  begin
    CurrentInterval := MinutesBetween(Now, FCacheLastReloaded);
    Result := (FUseCache and (CurrentInterval >= FCustomCacheRefreshInterval));
  end;
end;


procedure TBtrieveFunctions.ReloadCache;
begin
  UnloadTheCache;
  LoadTheCache;
end;

procedure TBtrieveFunctions.SetSQLCaching(SubType : Char = ' ');
begin
 if UsingSQL then
  begin
    if not (FFileNo in NonVariantSet) and not FUseCache then
      UseVariantForNextCall(FBtrIntf.LocalF^[FFileNo], FBtrIntf.ExClientId)
    else
    if FUseCache {or (ExSyss.SQLCachingMode = sqlCacheAuto)} then
    begin
      if NeedToReloadCache then
        ReloadCache;

      UseCache;
    end;
  end;
end;

function TBtrieveFunctions.Get_sqlAutoRefreshCache: WordBool;
begin
  AuthoriseSQLFuncs;
  Result := FAutoRefreshCache;
end;

function TBtrieveFunctions.Get_sqlCacheRefreshInterval: Integer;
begin
  Result := FCustomCacheRefreshInterval;
end;

function TBtrieveFunctions.Get_sqlQuery: WideString;
begin
  AuthoriseSQLFuncs;
  Result := FWhereClause;
end;

function TBtrieveFunctions.Get_sqlRequiredFields: WideString;
begin
  AuthoriseSQLFuncs;
  Result := FColumns;
end;

function TBtrieveFunctions.Get_sqlUseCache: WordBool;
begin
  AuthoriseSQLFuncs;
  Result := FUseCache;
end;

function TBtrieveFunctions.LoadCache: Integer;
begin
  AuthoriseSQLFuncs;
  LoadTheCache;
  FUseCache := True;
end;

procedure TBtrieveFunctions.Set_sqlAutoRefreshCache(Value: WordBool);
begin
  AuthoriseSQLFuncs;
  FAutoRefreshCache := Value;
end;

procedure TBtrieveFunctions.Set_sqlCacheRefreshInterval(Value: Integer);
begin
  AuthoriseSQLFuncs;
  if Value < 1 then
    Value := 1;

  FCustomCacheRefreshInterval := Value;
end;

procedure TBtrieveFunctions.Set_sqlQuery(const Value: WideString);
begin
  AuthoriseSQLFuncs;
  FWhereClause := Value;
end;

procedure TBtrieveFunctions.Set_sqlRequiredFields(const Value: WideString);
begin
  AuthoriseSQLFuncs;
  FColumns := Value;
end;

procedure TBtrieveFunctions.Set_sqlUseCache(Value: WordBool);
begin
  AuthoriseSQLFuncs;
  FUseCache := Value;
end;

function TBtrieveFunctions.UnloadCache: Integer;
begin
  AuthoriseSQLFuncs;
  Result := UnloadTheCache;
end;

function TBtrieveFunctions.TranslateFieldNames(
  const FieldNames : WideString): WideString;
begin
  AuthoriseSQLFuncs;
  Result := TranslateToolkitProperties(FObjectID, FieldNames, FRecordSubType);
end;

function TBtrieveFunctions.Get_sqlDefaultQuery: WideString;
begin
  AuthoriseSQLFuncs;
  Result := DefaultWhereClause(FObjectID, FRecordSubType, FSQLParentKey);
end;

function TBtrieveFunctions.FullQuery : WideString;
var
  FDefaultQuery : WideString;
begin
  AuthoriseSQLFuncs;
  FDefaultQuery := Get_sqlDefaultQuery;
  if (Trim(FDefaultQuery) <> '') and (Trim(FWhereClause) <> '') then
    Result := FDefaultQuery + ' AND ' + FWhereClause
  else
    Result := FDefaultQuery + FWhereClause;
end;

procedure TBtrieveFunctions.SetFileChanged(FileNo, ClientID: Integer);
begin
  AuthoriseSQLFuncs;
  if (FileNo in FFilesUsed) and (ClientID <> FBtrIntf^.ExClientID.TaskID) then
  begin
    //DropCache(FileNo, ClientID);  When it's ready
  end;

end;

procedure TBtrieveFunctions.SetFileNos(const FileNos : Array of Byte);
var
  i : integer;
begin
  for i := 0 to High(FileNos) do
    if FileNos[i] > 0 then
      Include(FFilesUsed, FileNos[i]);
  CacheStatusList.Add(Self as ICacheStatus);
end;

function TBtrieveFunctions.UsingRedirectCache: Boolean;
begin
  Result := Assigned(FSQLRedirect) and FSQLRedirect.Active;
end;

procedure TBtrieveFunctions.AuthoriseSQLFuncs;
begin
  //Do nothing in base - override in any objects where ISQLFunctions is not yet implemented
end;

Initialization
  SQLBeingUsed := UsingSQL;
  if SQLBeingUsed then
    SQLUtils.UseSQLCacheList;

end.
