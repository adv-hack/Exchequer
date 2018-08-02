unit Funcs1U;

{ prutherford440 08:53 25/03/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, Forms;

function EntVersion : ShortString; StdCall;

Function EntDefaultLogin (Const UserId : ShortString;
                          Const PWord  : ShortString) : SmallInt; StdCall;

Function EntConvertInts (Const Int2 : SmallInt;
                         Const Int4 : LongInt) : Double; StdCall;

Function EntDocSign (Const DocType : ShortString) : SmallInt; StdCall;

Function EntCustValue(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Const CustCode  : ShortString;
                      Const Year      : SmallInt;
                      Const Period    : SmallInt;
                      Var   CustBal   : Double) : SmallInt; StdCall;

Function EntGLValue(Const WantValue : SmallInt;
                    Const SubType   : SmallInt;
                    Const Company   : ShortString;
                    Const GLCode    : LongInt;
                    Const Year      : SmallInt;
                    Const Period    : SmallInt;
                    Const Currency  : SmallInt;
                    Const CCDep     : ShortString;
                    Const Committed : SmallInt;
                    Var   GLBal     : Double) : SmallInt; StdCall;

Function EntStockValue(Const WantValue : SmallInt;
                       Const Company   : ShortString;
                       Const StkCode   : ShortString;
                       Const LocCode   : ShortString;
                       Const Year      : SmallInt;
                       Const Period    : SmallInt;
                       Const Currency  : SmallInt;
                       Var   StkBal    : Double) : SmallInt; StdCall;

Function EntJCSummCat(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Var   TotalStr  : ShortString) : SmallInt; StdCall;

Function EntJobBudgetValue(Const WantValue : SmallInt;
                           Const Company   : ShortString;
                           Const JobCode   : ShortString;
                           Const HistFolio : LongInt;
                           Const Year      : SmallInt;
                           Const Period    : SmallInt;
                           Const Currency  : SmallInt;
                           Const Commit    : WordBool;
                           Var   HistVal   : Double) : SmallInt; StdCall;

Function EntJobBudgetValue2 (Const ValueReq  : SmallInt;
                             Const Company   : ShortString;
                             Const BudgType  : ShortString;
                             Const TotalType : SmallInt;
                             Const Committed : SmallInt;
                             Const TheYear   : SmallInt;
                             Const ThePeriod : SmallInt;
                             Const TheCcy    : SmallInt;
                             Const JobCode   : ShortString;
                             Const StockId   : ShortString;
                             Var   ReturnVal : Double) : SmallInt; StdCall;

Function EntStockQty (Const Company   : ShortString;
                      Const StockCode : ShortString;
                      Const LocCode   : ShortString;
                      Var   HistVal   : Double) : SmallInt; StdCall;

{ Saves a GL Codes History Budget Value for a specified Period: }
{   SaveValue: 1=Budget1, 2=Budget2                             }
{   SubType: 0=GL, 1=GL/Cost Centre, 2=GL/Department            }
Function EntSaveGLValue(Const SaveValue : SmallInt;
                        Const SubType   : SmallInt;
                        Const Company   : ShortString;
                        Const GLCode    : LongInt;
                        Const Year      : SmallInt;
                        Const Period    : SmallInt;
                        Const Currency  : SmallInt;
                        Const CCDep     : ShortString;
                        Const NewBudget : Double) : SmallInt; StdCall;

Function EntSaveJCValue(Const SaveValue  : SmallInt;
                        Const Company    : ShortString;
                        Const JobCode    : ShortString;
                        Const StockCode  : ShortString;
                        Const Year       : SmallInt;
                        Const Period     : SmallInt;
                        Const Currency   : SmallInt;
                        Const BudgetType : String;
                        Const TotalType  : SmallInt;
                        Const Committed  : SmallInt;
                        Const NewBudget  : Double) : SmallInt; StdCall;

Function EntStockStr(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                       Var ReturnStr : ShortString) : SmallInt; StdCall;

Function EntStockInt(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnInt : LongInt) : SmallInt; StdCall;

Function EntStockVal(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnVal : Double) : SmallInt; StdCall;

Procedure EntFuncsShutDown; StdCall;

Function EntTeleValue(Const ValueReq   : SmallInt;
                      Const Company    : ShortString;
                      Const CustCode   : ShortString;
                      Const StkCode    : ShortString;
                      Const Currency   : SmallInt;
                      Const Year       : SmallInt;
                      Const Period     : SmallInt;
                      Const CostCentre : ShortString;
                      Const Dept       : ShortString;
                      Const LocCode    : ShortString;
                      Var   ReturnVal  : Double) : SmallInt; StdCall;

Function EntSuppTeleValue(Const ValueReq   : SmallInt;
                      Const Company    : ShortString;
                      Const SuppCode   : ShortString;
                      Const StkCode    : ShortString;
                      Const Currency   : SmallInt;
                      Const Year       : SmallInt;
                      Const Period     : SmallInt;
                      Const CostCentre : ShortString;
                      Const Dept       : ShortString;
                      Const LocCode    : ShortString;
                      Var   ReturnVal  : Double) : SmallInt; StdCall;  // PL 08/09/2016 R3 ABSEXCH-16676 added EntSuppTeleValue for supplier

// Maps onto GetAcMiscStr to allow Cripple to pull back Customer/Supplier Account
// Details without having to bring an additional table into the query
Function EntAccountStr(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnStr : ShortString) : SmallInt; StdCall;

// Maps onto GetAcMiscInt to allow Cripple to pull back Customer/Supplier Account
// Details without having to bring an additional table into the query
Function EntAccountInt(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnInt : longint) : SmallInt; StdCall;

// Maps onto GetAcMiscVal to allow Cripple to pull back Customer/Supplier Account
// Details without having to bring an additional table into the query
Function EntAccountVal(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnDbl : Double) : SmallInt; StdCall;
//Maps onto GetCCDepName
Function EntCCDepName(Const Company  : ShortString;
                      Const CCDpType : ShortString;
                      Const CCDpCode : ShortString;
                      Var   CCDpName : ShortString) : SmallInt; StdCall;

function EntJobStr(const Company   : ShortString;
                       const JobCode   : ShortString;
                       const ValueIdx  : SmallInt;
                       var   ReturnStr : ShortString) : SmallInt; StdCall;

function EntLocationName(const Company : ShortString;
                         const LocCode : ShortString;
                         var   LocName : ShortString) : SmallInt; StdCall;

function EntCurrencyName(const Company  : ShortString;
                         const CurrCode : SmallInt;
                         var   CurrName : ShortString) : SmallInt; StdCall;


Function EntJobInt(Const Company   : ShortString;
                   Const JobCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnInt : longint) : SmallInt; StdCall;

Function EntJobVal(Const Company   : ShortString;
                   Const JOBCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnDbl : Double) : SmallInt; StdCall;

function EntAnalDesc(const Company  : ShortString;
                     const AnalCode : ShortString;
                     var   AnalDesc : ShortString) : SmallInt; StdCall;

function EntCustStkQty(Const Company    : ShortString;
                       Const CustCode   : ShortString;
                       Const StkCode    : ShortString;
                       Const Currency   : SmallInt;
                       Const Year       : SmallInt;
                       Const Period     : SmallInt;
                       Const CostCentre : ShortString;
                       Const Dept       : ShortString;
                       Const LocCode    : ShortString;
                       Var   ReturnVal  : Double) : SmallInt; StdCall;

function EntCustStkSales(Const Company    : ShortString;
                         Const CustCode   : ShortString;
                         Const StkCode    : ShortString;
                         Const Currency   : SmallInt;
                         Const Year       : SmallInt;
                         Const Period     : SmallInt;
                         Const CostCentre : ShortString;
                         Const Dept       : ShortString;
                         Const LocCode    : ShortString;
                         Var   ReturnVal  : Double) : SmallInt; StdCall;

Function EntJCBudgetValue (Const ValueReq  : SmallInt;
                           Const Company   : ShortString;
                           Const BudgType  : String;
                           Const TotalType : SmallInt;
                           Const Committed : SmallInt;
                           Const TheYear   : SmallInt;
                           Const ThePeriod : SmallInt;
                           Const TheCcy    : SmallInt;
                           Const JobCode   : String;
                           Const StockId   : String;
                           Var   ReturnVal : Double) : SmallInt; StdCall;

function EntCurrencyValue(Const ValueReq : SmallInt;
                          Const Company  : ShortString;
                          Const Currency : SmallInt;
                            var ReturnVal : Double) : SmallInt; StdCall;



implementation


Uses OLEAuto, SysUtils, Variants, History;

Var
  EnterOLE     : Variant;
  DisableOLE   : Boolean;
  //GotOLEServer : Boolean;
  {$IFDEF OUTF}
  OutF         : TextFile;
  {$ENDIF}


{----------------------------------------------------------------------------}

{ Returns the handle to the OLE Server }
Function CheckForOLEServer : Boolean;
Begin
  Result := False;

  { Check to see if a previous exception has disabled the OLE }
  If (Not DisableOLE) Then Begin
    Try
      If VarIsEmpty(EnterOLE) Then
        { Create OLE Object }
        EnterOLE := CreateOleObject('Enterprise.OLEServer');

      { Return True if the OLE Server object is available }
      Result := Not VarIsEmpty(EnterOLE);
    Except
      On Ex:Exception Do Begin
        DisableOLE := True;
        MessageDlg ('The following exception has occurred whilst linking to the ' +
                    'Exchequer OLE Server:-' + #13#13 +
                    '''' + Ex.Message + '''', mtError, [mbOk], 0);
      End;
    End;
  End; { If (Not DisableOLE) }
End;

{----------------------------------------------------------------------------}

{ Returns the version of the DLL }
Function EntVersion : ShortString; StdCall;
Begin
  Result := CurrVersion_ODLL;
End;

{----------------------------------------------------------------------------}

{ Reconstitutes a SmallInt and LongInt that form }
{ a Real into a double.                          }
Function EntConvertInts (Const Int2 : SmallInt;
                         Const Int4 : LongInt) : Double; StdCall;
Var
  TheRealArray : Array [1..6] Of Char;
  TheReal      : Real;
Begin
  Move (Int2, TheRealArray[1], 2);
  Move (Int4, TheRealArray[3], 4);
  Move (TheRealArray[1], TheReal, 6);

  Result := TheReal;
End;

{----------------------------------------------------------------------------}

{ Returns the DOC Const value which can be used to sign the amounts }
{ on a transaction. Returns 0 if it cannot match the DocType, else  }
{ 1 or -1.                                                          }
Function EntDocSign (Const DocType : ShortString) : SmallInt; StdCall;
Begin
  If CheckForOLEServer Then
    Result := EnterOLE.DocSign(DocType)
  Else
    Result := 0;
End;

{----------------------------------------------------------------------------}

{ Returns a Customer's History Value for a specified Period: }
{   0=Balance, 1=Net Sales, 2=Costs, 3=Margin,               }
{   4=Acc Debit,5=AccCredit,6=Budget                         }
Function EntCustValue(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Const CustCode  : ShortString;
                      Const Year      : SmallInt;
                      Const Period    : SmallInt;
                      Var   CustBal   : Double) : SmallInt;
Var
  ThePeriod, TheYear, ValueReq : SmallInt;
  CCode, TheCompany            : String;
  CustValue                    : Double;
Begin
  If CheckForOLEServer Then Begin
    ValueReq   := WantValue;
    TheCompany := Company;
    TheYear    := Year;
    ThePeriod  := Period;
    CCode      := CustCode;
    CustValue  := 0.0;

    Result := EnterOLE.GetCustValue (ValueReq,TheCompany,TheYear,ThePeriod,CCode,CustValue);
    CustBal := CustValue;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    CustBal := 0.0;
  End; { Else }
End;

{----------------------------------------------------------------------------}

// Returns a GL Codes History Value for a specified Period:-
//
//   WantValue: 1=Budget1, 2=Budget2, 3=Actuals, 4=Debits, 5=Credit
//   SubType:   0=GL, 1=GL/Cost Centre, 2=GL/Department, 3=GL/CC/Dept
//
// For SubType=3 pass the CCDep in the format CCCDDD where CCC is the Cost Centre
// And DDD is the Department both padded to three character with spaces if necessary
//
Function EntGLValue(Const WantValue : SmallInt;
                    Const SubType   : SmallInt;
                    Const Company   : ShortString;
                    Const GLCode    : LongInt;
                    Const Year      : SmallInt;
                    Const Period    : SmallInt;
                    Const Currency  : SmallInt;
                    Const CCDep     : ShortString;
                    Const Committed : SmallInt;
                    Var   GLBal     : Double) : SmallInt;
Var
  TheCcy, Commit,
  ThePeriod, TheYear, ValueReq   : SmallInt;
  TheGLCode                      : LongInt;
  CCDepStr, TheCompany, CC, Dept : String;
  GLValue                        : Double;
Begin
  If CheckForOLEServer Then Begin
    ValueReq   := WantValue;
    TheCompany := Company;
    TheYear    := Year;
    ThePeriod  := Period;
    TheCcy     := Currency;
    TheGLCode  := GLCode;
    Commit     := Committed;
    GLValue    := 0.0;

    CCDepStr := 'N';
    CC := '';
    Dept := '';
    Case SubType Of
      1  : Begin
             CCDepStr := 'C';
             CC := CCDep;
           End;
      2  : Begin
             CCDepStr := 'D';
             Dept := CCDep;
           End;
      3  : Begin
             CCDepStr := 'C';
             CC := Copy(CCDep, 1, 3);
             Dept := Copy(CCDep, 4, 3);
           End;
    End; { Case }

    Result := EnterOLE.GetNominalValue (ValueReq,
                                        TheCompany,
                                        TheYear,
                                        ThePeriod,
                                        TheCcy,
                                        TheGLCode,
                                        CC,
                                        Dept,
                                        CCDepStr,
                                        GLValue,
                                        Commit);

    GLBal := GLValue;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    GLBal := 0.0;
  End; { Else }
End;

{----------------------------------------------------------------------------}

{ Returns a stock value based on ReqValue       }
{ WantValue: 1 = Qty Sold, 2 = Sales            }
{            3 = Costs, 4 = Margin              }
{            5 = Budget, 10= Posted Stock Level }
Function EntStockValue(Const WantValue : SmallInt;
                       Const Company   : ShortString;
                       Const StkCode   : ShortString;
                       Const LocCode   : ShortString;
                       Const Year      : SmallInt;
                       Const Period    : SmallInt;
                       Const Currency  : SmallInt;
                       Var   StkBal    : Double) : SmallInt;
Var
  TheCcy, ThePeriod, TheYear, ValueReq : SmallInt;
  TheStkCode, TheLocCode, TheCompany   : String;
  StkValue                             : Double;
Begin
  If CheckForOLEServer Then Begin
    ValueReq   := WantValue;
    TheCompany := Company;
    TheYear    := Year;
    ThePeriod  := Period;
    TheCcy     := Currency;
    TheStkCode := StkCode;
    TheLocCode := LocCode;
    StkValue   := 0.0;

    Result := EnterOLE.GetStockValue (ValueReq,
                                      TheCompany,
                                      TheYear,
                                      ThePeriod,
                                      TheCcy,
                                      TheStkCode,
                                      TheLocCode,
                                      StkValue);
    StkBal := StkValue;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    StkBal := 0.0;
  End; { Else }
End;

{----------------------------------------------------------------------------}

{ Returns a Job Costing Summary Category Description }
Function EntJCSummCat(Const WantValue : SmallInt;
                      Const Company   : ShortString;
                      Var   TotalStr  : ShortString) : SmallInt;
Var
  ValueReq : SmallInt;
  TheCompany, TheCat : String;
Begin
//PR 17/02/05 - wasn't checking for OLEServer
  If CheckForOLEServer Then
  Begin
    ValueReq := WantValue;
    TheCompany := Company;
    TheCat := '';

    Result := EnterOLE.GetJobTotalStr (ValueReq,
                                       TheCompany,
                                       TheCat);

    TotalStr := TheCat;
  end
  Else
  Begin
    { OLE Server Not Available }
    Result := 500;
  End; { Else }
End;

{----------------------------------------------------------------------------}

{ Returns a job budget history value based on ReqValue        }
{ WantValue: 1 = Budget Qty, 2 = Budget Value                 }
{            3 = Revised Budget Qty, 4 = Revised Budget Value }
{            5 = Actual Qty , 6= Actual Value                 }
Function EntJobBudgetValue(Const WantValue : SmallInt;
                           Const Company   : ShortString;
                           Const JobCode   : ShortString;
                           Const HistFolio : LongInt;
                           Const Year      : SmallInt;
                           Const Period    : SmallInt;
                           Const Currency  : SmallInt;
                           Const Commit    : WordBool;
                           Var   HistVal   : Double) : SmallInt;
Var
  TheCcy, ThePeriod, TheYear, ValueReq : SmallInt;
  TheJobCode, TheCompany : String;
  HistValue              : Double;
  TheHistFolio           : LongInt;
  WantCommit             : WordBool;
Begin
  If CheckForOLEServer Then Begin
    ValueReq     := WantValue;
    TheCompany   := Company;
    TheYear      := Year;
    ThePeriod    := Period;
    TheCcy       := Currency;
    TheJobCode   := JobCode;
    TheHistFolio := HistFolio;
    HistValue    := 0.0;
    WantCommit   := Commit;

    Result := EnterOLE.GetJobBudgetValue(ValueReq,
                                         TheCompany,
                                         TheYear,
                                         ThePeriod,
                                         TheCcy,
                                         TheJobCode,
                                         TheHistFolio,
                                         WantCommit,
                                         HistValue);

    HistVal := HistValue;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    HistVal := 0.0;
  End; { Else }
End;

{----------------------------------------------------------------------------}

{ Returns the Qty in Stock for a specified Stock Code with optional Location }
Function EntStockQty (Const Company   : ShortString;
                      Const StockCode : ShortString;
                      Const LocCode   : ShortString;
                      Var   HistVal   : Double) : SmallInt;
Var
  TheStock, TheLoc, TheCompany, MiscBand : String;
  HistValue                              : Double;
  ValueReq                               : SmallInt;
Begin { EntStockQty }
  If CheckForOLEServer Then Begin
    ValueReq     := 8;
    TheCompany   := Company;
    TheStock     := StockCode;
    TheLoc       := LocCode;
    MiscBand     := ' ';
    HistValue    := 0.0;

    Result := EnterOLE.GetStockMiscVal (TheCompany,
                                        TheStock,
                                        TheLoc,
                                        ValueReq,
                                        MiscBand,
                                        HistValue);
    HistVal := HistValue;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    HistVal := 0.0;
  End; { Else }
End; { EntStockQty }

{----------------------------------------------------------------------------}

Function EntDefaultLogin (Const UserId : ShortString;
                          Const PWord  : ShortString) : SmallInt;
Var
  UId, Pwd : String;
Begin { EntDefaultLogin }
  If CheckForOLEServer Then Begin
    UId := UpperCase(Trim(UserId));
    Pwd := UpperCase(Trim(PWord));
    Result := EnterOLE.PrimeLoginDets (UId, Pwd);
  End { If CheckForOLEServer }
  Else
    { OLE Server Not Available }
    Result := 500;
End; { EntDefaultLogin }

{----------------------------------------------------------------------------}

{ Saves a GL Codes History Budget Value for a specified Period: }
{   SaveValue: 1=Budget1, 2=Budget2                             }
{   SubType: 0=GL, 1=GL/Cost Centre, 2=GL/Department, 3=GL/CC/Department }
Function EntSaveGLValue(Const SaveValue : SmallInt;
                        Const SubType   : SmallInt;
                        Const Company   : ShortString;
                        Const GLCode    : LongInt;
                        Const Year      : SmallInt;
                        Const Period    : SmallInt;
                        Const Currency  : SmallInt;
                        Const CCDep     : ShortString;
                        Const NewBudget : Double) : SmallInt;
Var
  TheCcy,
  ThePeriod, TheYear, ValueReq   : SmallInt;
  TheGLCode                      : LongInt;
  CCDepStr, TheCompany, CC, Dept : String;
  GLValue                        : Double;
Begin
  If CheckForOLEServer Then Begin
    ValueReq   := SaveValue;
    TheCompany := Company;
    TheYear    := Year;
    ThePeriod  := Period;
    TheCcy     := Currency;
    TheGLCode  := GLCode;
    GLValue    := NewBudget;

    CCDepStr := 'N';
    CC := '';
    Dept := '';
    Case SubType Of
      1  : Begin
             CCDepStr := 'C';
             CC := CCDep;
           End;
      2  : Begin
             CCDepStr := 'D';
             Dept := CCDep;
           End;
      // CJS 21/09/2011 - ABSEXCH-11858
      3  : Begin
             CCDepStr := 'K'; // CC/Dept
             CC := Copy(CCDep, 1, 3);
             Dept := Copy(CCDep, 4, 3);
           End;
    End; { Case }

    Result := EnterOLE.SaveNominalValue (ValueReq,
                                         TheCompany,
                                         TheYear,
                                         ThePeriod,
                                         TheCcy,
                                         TheGLCode,
                                         CC,
                                         Dept,
                                         CCDepStr,
                                         GLValue);
  End { If CheckForOLEServer }
  Else
    { OLE Server Not Available }
    Result := 500;
End;

{----------------------------------------------------------------------------}

// Saves a GL Codes History Budget Value for a specified Period:
//
//   SaveValue: 1=Budget Qty,
//              2=Budget Value,
//              3=Revised Budget Qty
//              4=Revised Budget Value
//
//   BudgType:  B=Analysis, M=Totals, S=Stock
//
//   TotalType: 10,20,30,40,50,60,99,160,170,180,190
//
Function EntSaveJCValue(Const SaveValue  : SmallInt;
                        Const Company    : ShortString;
                        Const JobCode    : ShortString;
                        Const StockCode  : ShortString;
                        Const Year       : SmallInt;
                        Const Period     : SmallInt;
                        Const Currency   : SmallInt;
                        Const BudgetType : String;
                        Const TotalType  : SmallInt;
                        Const Committed  : SmallInt;
                        Const NewBudget  : Double) : SmallInt;
Var
  TheCcy, TotType, Commit, ThePeriod, TheYear, ValueReq : SmallInt;
  JCode, SCode, BudgType, TheCompany  : String;
  GLValue                      : Double;
Begin { EntSaveJCValue }
  If CheckForOLEServer Then Begin
    ValueReq   := SaveValue;
    TheCompany := Company;
    BudgType   := BudgetType;
    TotType    := TotalType;
    Commit     := Committed;
    TheYear    := Year;
    ThePeriod  := Period;
    TheCcy     := Currency;
    JCode      := JobCode;
    SCode      := StockCode;
    GLValue    := NewBudget;

    Result := EnterOLE.SaveJCBudgetValue (ValueReq,
                                          TheCompany,
                                          BudgType,
                                          TotType,
                                          Commit,
                                          TheYear,
                                          ThePeriod,
                                          TheCcy,
                                          JCode,
                                          SCode,
                                          GLValue);
  End { If CheckForOLEServer }
  Else
    { OLE Server Not Available }
    Result := 500;
End; { EntSaveJCValue }

{----------------------------------------------------------------------------}

{ Maps onto GetStockMiscStr to allow Cripple to pull back Stock      }
{ Details Without having to bring an additional table into the query }
Function EntStockStr(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                       Var ReturnStr : ShortString) : SmallInt;
Var
  lCompany, lStock, lLoc, lRetStr : String;
  lFieldIdx                       : SmallInt;
Begin { EntStockStr }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany  := Company;
    lStock    := StkCode;
    lLoc      := LocCode;
    lFieldIdx := ValueIdx;
    lRetStr   := '';

    { Call OLE Server }
    Result := EnterOLE.GetStockMiscStr (lCompany, lStock, lLoc, lFieldIdx, lRetStr);

    { Return string result }
    ReturnStr := lRetStr;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    ReturnStr := '';
  End; { Else }
End; { EntStockStr }

{----------------------------------------------------------------------------}

{ Maps onto GetStockMiscInt to allow Cripple to pull back Stock      }
{ Details Without having to bring an additional table into the query }
Function EntStockInt(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnInt : LongInt) : SmallInt;
Var
  lCompany, lStock, lLoc, lSalesBand : String;
  lFieldIdx                          : SmallInt;
  lRetInt                            : LongInt;
Begin { EntStockInt }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany   := Company;
    lStock     := StkCode;
    lLoc       := LocCode;
    lFieldIdx  := ValueIdx;
    lSalesBand := SalesBand;
    lRetInt    := 0;

    { Call OLE Server }
    Result := EnterOLE.GetStockMiscInt (lCompany, lStock, lLoc, lFieldIdx, lSalesBand, lRetInt);

    { Return longint result }
    ReturnInt := lRetInt;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result    := 500;
    ReturnInt := 0;
  End; { Else }
End; { EntStockInt }

{----------------------------------------------------------------------------}

{ Maps onto GetStockMiscVal to allow Cripple to pull back Stock      }
{ Details Without having to bring an additional table into the query }
Function EntStockVal(Const Company   : ShortString;
                     Const StkCode   : ShortString;
                     Const LocCode   : ShortString;
                     Const ValueIdx  : SmallInt;
                     Const SalesBand : ShortString;
                       Var ReturnVal : Double) : SmallInt;
Var
  lCompany, lStock, lLoc, lSalesBand : String;
  lFieldIdx                          : SmallInt;
  lRetVal                            : Double;
Begin { EntStockVal }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany   := Company;
    lStock     := StkCode;
    lLoc       := LocCode;
    lFieldIdx  := ValueIdx;
    lSalesBand := SalesBand;
    lRetVal    := 0.0;

    { Call OLE Server }
    Result := EnterOLE.GetStockMiscVal (lCompany, lStock, lLoc, lFieldIdx, lSalesBand, lRetVal);

    { Return double result }
    ReturnVal := lRetVal;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result    := 500;
    ReturnVal := 0.0;
  End; { Else }
End; { EntStockVal }

{----------------------------------------------------------------------------}

Procedure EntFuncsShutDown;
Begin { EntFuncsShutDown }
  If (Not VarIsEmpty(EnterOLE)) Then Begin
    { Destroy OLE Server }
    EnterOLE := UnAssigned;
  End; { If }
End; { EntFuncsShutDown }

{----------------------------------------------------------------------------}

{ Maps onto GetStockMiscVal to allow Cripple to pull back Stock      }
{ Details Without having to bring an additional table into the query }
Function EntTeleValue(Const ValueReq   : SmallInt;
                      Const Company    : ShortString;
                      Const CustCode   : ShortString;
                      Const StkCode    : ShortString;
                      Const Currency   : SmallInt;
                      Const Year       : SmallInt;
                      Const Period     : SmallInt;
                      Const CostCentre : ShortString;
                      Const Dept       : ShortString;
                      Const LocCode    : ShortString;
                      Var   ReturnVal  : Double) : SmallInt;
Var
  lCompany, lCC, lDept, lCust, lStock, lLoc, lSalesBand, lAcType : String;
  lFieldIdx, lCcy, lPeriod, lYear                                : SmallInt;
  lRetVal                                                        : Double;
Begin { EntTeleValue }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lFieldIdx  := ValueReq;
    lCompany   := Company;
    lCust      := CustCode;
    lStock     := StkCode;
    lCcy       := Currency;
    lYear      := Year;
    lPeriod    := Period;
    lCC        := CostCentre;
    lDept      := Dept;
    lLoc       := LocCode;
    lRetVal    := 0.0;
    lAcType    := 'C';

    { Call OLE Server }
    Result := EnterOLE.GetTeleValue (lFieldIdx, lCompany, lCust, lStock, lCcy, lYear, lPeriod,
                                     lCC, lDept, lLoc, {lFieldIdx, lSalesBand,} lRetVal, lAcType);

    { Return double result }
    ReturnVal := lRetVal;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result    := 500;
    ReturnVal := 0.0;
  End; { Else }
End; { EntTeleValue }

{----------------------------------------------------------------------------}
// PL 08/09/2016 R3 ABSEXCH-16676 added EntSuppTeleValue for supplier
Function EntSuppTeleValue(Const ValueReq   : SmallInt;
                          Const Company    : ShortString;
                          Const SuppCode   : ShortString;
                          Const StkCode    : ShortString;
                          Const Currency   : SmallInt;
                          Const Year       : SmallInt;
                          Const Period     : SmallInt;
                          Const CostCentre : ShortString;
                          Const Dept       : ShortString;
                          Const LocCode    : ShortString;
                          Var   ReturnVal  : Double) : SmallInt;    
Var
  lCompany, lCC, lDept, lSupp, lStock, lLoc, lSalesBand, lAcType : String;
  lFieldIdx, lCcy, lPeriod, lYear                                : SmallInt;
  lRetVal                                                        : Double;
Begin { EntSuppTeleValue }
  If CheckForOLEServer Then
  Begin
    { Copy variables into local variables which are safer to use }
    lFieldIdx  := ValueReq;
    lCompany   := Company;
    lSupp      := SuppCode;
    lStock     := StkCode;
    lCcy       := Currency;
    lYear      := Year;
    lPeriod    := Period;
    lCC        := CostCentre;
    lDept      := Dept;
    lLoc       := LocCode;
    lRetVal    := 0.0;
    lAcType	   := 'S';

      { Call OLE Server }
    Result := EnterOLE.GetTeleValue (lFieldIdx, lCompany, LSupp, lStock, lCcy, lYear, lPeriod,
                                     lCC, lDept, lLoc, lRetVal, lAcType);

    { Return double result }
    ReturnVal := lRetVal;
  End { If CheckForOLEServer }
  Else
  Begin
    { OLE Server Not Available }
    Result    := 500;
    ReturnVal := 0.0;
  End; { Else }
End; { EntSuppTeleValue  }

{----------------------------------------------------------------------------}

// Maps onto GetAcMiscStr to allow Cripple to pull back Customer/Supplier Account
// Details without having to bring an additional table into the query
Function EntAccountStr(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnStr : ShortString) : SmallInt;
Var
  lCompany, lAccount, lAcType, lRetStr : String;
  lFieldIdx                            : SmallInt;
Begin { EntAccountStr }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany  := Company;
    lAccount  := AcCode;
    lAcType   := AcType;
    lFieldIdx := ValueIdx;
    lRetStr   := '';

    { Call OLE Server }
    Result := EnterOLE.GetAcMiscStr (lCompany, lAccount, lAcType, lFieldIdx, lRetStr);

    { Return string result }
    ReturnStr := lRetStr;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    ReturnStr := '';
  End; { Else }
End; { EntAccountStr }

Function EntAccountInt(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnInt : longint) : SmallInt;
Var
  lCompany, lAccount, lAcType   : String;
  lFieldIdx                     : SmallInt;
  lRetInt                       : longint;
Begin { EntAccountStr }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany  := Company;
    lAccount  := AcCode;
    lAcType   := AcType;
    lFieldIdx := ValueIdx;
    lRetInt   := ReturnInt;

    { Call OLE Server }
    Result := EnterOLE.GetAcMiscInt (lCompany, lAccount, lAcType, lFieldIdx, lRetInt);

    { Return string result }
    ReturnInt := lRetInt;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    ReturnInt := 0;
  End; { Else }
End; { EntAccountStr }

Function EntAccountVal(Const Company   : ShortString;
                       Const AcCode    : ShortString;
                       Const AcType    : ShortString;
                       Const ValueIdx  : SmallInt;
                       Var   ReturnDbl : Double) : SmallInt;
Var
  lCompany, lAccount, lAcType   : String;
  lFieldIdx                     : SmallInt;
  lRetDbl                       : Double;
Begin { EntAccountStr }
  If CheckForOLEServer Then Begin
    { Copy variables into local variables which are safer to use }
    lCompany  := Company;
    lAccount  := AcCode;
    lAcType   := AcType;
    lFieldIdx := ValueIdx;
    lRetDbl   := ReturnDbl;

    { Call OLE Server }
    Result := EnterOLE.GetAcMiscVal (lCompany, lAccount, lAcType, lFieldIdx, lRetDbl);

    { Return string result }
    ReturnDbl := lRetDbl;
  End { If CheckForOLEServer }
  Else Begin
    { OLE Server Not Available }
    Result := 500;
    ReturnDbl := 0;
  End; { Else }
End; { EntAccountStr }


Function EntCCDepName(Const Company  : ShortString;
                      Const CCDpType : ShortString;
                      Const CCDpCode : ShortString;
                      Var   CCDpName : ShortString) : SmallInt;
var
  lCompany,
  lType,
  lCode,
  lName  : String;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lType := CCDpType;
    lCode := CCDpCode;
    lName := CCDpName;

    Result := EnterOLE.GetCCDepName(lCompany, lType, lCode, lName);

    CCDpName := lName;
  end
  else
  begin
    Result := 500;
    CCDpName := '';
  end;
end;

function EntJobStr(const Company : ShortString;
                       const JobCode : ShortString;
                       const ValueIdx : SmallInt;
                       var   ReturnStr : ShortString) : SmallInt; StdCall;
var
  lCompany,
  lJobCode,
  lReturnStr : String;
  lValueIdx  : SmallInt;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lJobCode := JobCode;
    lReturnStr := ReturnStr;
    lValueIdx := ValueIdx;

    Result := EnterOLE.GetJobMiscStr(lCompany, lJobCode, lReturnStr, lValueIdx);

    ReturnStr := lReturnStr;
  end
  else
  begin
    Result := 500;
    ReturnStr := '';
  end;
end;

function EntLocationName(const Company : ShortString;
                         const LocCode : ShortString;
                         var   LocName : ShortString) : SmallInt; StdCall;
var
  lCompany,
  lCode,
  lName : string;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lCode := LocCode;
    lName := LocName;

    Result := EnterOLE.GetLocationName(lCompany, lCode, lName);

    LocName := lName;
  end
  else
  begin
    Result := 500;
    LocName := '';
  end;
end;

function EntCurrencyName(const Company  : ShortString;
                         const CurrCode : SmallInt;
                         var   CurrName : ShortString) : SmallInt; StdCall;
var
  lCompany,
  lName     : string;
  lCode     : SmallInt;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lCode := CurrCode;
    lName := CurrName;

    Result := EnterOLE.GetCurrencyName(lCompany, lCode, lName);

    CurrName := lName;
  end
  else
  begin
    Result := 500;
    CurrName := '';
  end;
end;

Function EntJobInt(Const Company   : ShortString;
                   Const JobCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnInt : longint) : SmallInt; StdCall;
var
  lCompany,
  lJobCode : string;
  lValueIdx : SmallInt;
  lReturnInt : longint;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lJobCode := JobCode;
    lValueIdx := ValueIdx;
    lReturnInt := ReturnInt;

    Result := EnterOLE.GetJobMiscInt(lCompany, lJobCode, lReturnInt, lValueIdx);

    ReturnInt := lReturnInt;
  end
  else
  begin
    Result := 500;
    ReturnInt := 0;
  end;
end;

Function EntJobVal(Const Company   : ShortString;
                   Const JobCode   : ShortString;
                   Const ValueIdx  : SmallInt;
                   Var   ReturnDbl : Double) : SmallInt; StdCall;
var
  lCompany,
  lJobCode : string;
  lValueIdx : SmallInt;
  lReturnDbl : Double;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lJobCode := JobCode;
    lValueIdx := ValueIdx;
    lReturnDbl := ReturnDbl;

    Result := EnterOLE.GetJobMiscVal(lCompany, lJobCode, lReturnDbl, lValueIdx);

    ReturnDbl := lReturnDbl;
  end
  else
  begin
    Result := 500;
    ReturnDbl := 0;
  end;
end;

function EntAnalDesc(const Company  : ShortString;
                     const AnalCode : ShortString;
                     var   AnalDesc : ShortString) : SmallInt; StdCall;
var
  lCompany,
  lCode,
  lDesc     : string;
begin
  if CheckForOLEServer then
  begin
    { Copy variables into local variables which are safer to use }
    lCompany := Company;
    lCode := AnalCode;
    lDesc := AnalDesc;

    Result := EnterOLE.GetAnalDesc(lCompany, lCode, lDesc);

    AnalDesc := lDesc;

  end
  else
  begin
    Result := 500;
    AnalDesc := '';
  end;
end;

function EntCustStkQty(Const Company    : ShortString;
                       Const CustCode   : ShortString;
                       Const StkCode    : ShortString;
                       Const Currency   : SmallInt;
                       Const Year       : SmallInt;
                       Const Period     : SmallInt;
                       Const CostCentre : ShortString;
                       Const Dept       : ShortString;
                       Const LocCode    : ShortString;
                       Var   ReturnVal  : Double) : SmallInt;

begin

  if CheckForOLEServer then
  begin
    Result := EntTeleValue(1, Company, CustCode, StkCode, Currency, Year, Period,
                           CostCentre, Dept, LocCode, ReturnVal);
  end
  else
  begin
    Result := 500;
    ReturnVal := 0;
  end;
end;

function EntCustStkSales(Const Company    : ShortString;
                         Const CustCode   : ShortString;
                         Const StkCode    : ShortString;
                         Const Currency   : SmallInt;
                         Const Year       : SmallInt;
                         Const Period     : SmallInt;
                         Const CostCentre : ShortString;
                         Const Dept       : ShortString;
                         Const LocCode    : ShortString;
                         Var   ReturnVal  : Double) : SmallInt;
begin
  if CheckForOLEServer then
  begin
    Result := EntTeleValue(2, Company, CustCode, StkCode, Currency, Year, Period,
                           CostCentre, Dept, LocCode, ReturnVal);
  end
  else
  begin
    Result := 500;
    ReturnVal := 0;
  end;
end;


Function EntJCBudgetValue (Const ValueReq  : SmallInt;
                           Const Company   : ShortString;
                           Const BudgType  : String;
                           Const TotalType : SmallInt;
                           Const Committed : SmallInt;
                           Const TheYear   : SmallInt;
                           Const ThePeriod : SmallInt;
                           Const TheCcy    : SmallInt;
                           Const JobCode   : String;
                           Const StockId   : String;
                           Var   ReturnVal : Double) : SmallInt;
begin
  Result := EntJobBudgetValue2 (ValueReq,
                                Company,
                                BudgType,
                                TotalType,
                                Committed,
                                TheYear,
                                ThePeriod,
                                TheCcy,
                                JobCode,
                                StockId,
                                ReturnVal);
end;


Function EntJobBudgetValue2 (Const ValueReq  : SmallInt;
                             Const Company   : ShortString;
                             Const BudgType  : ShortString;
                             Const TotalType : SmallInt;
                             Const Committed : SmallInt;
                             Const TheYear   : SmallInt;
                             Const ThePeriod : SmallInt;
                             Const TheCcy    : SmallInt;
                             Const JobCode   : ShortString;
                             Const StockId   : ShortString;
                             Var   ReturnVal : Double) : SmallInt;
Var
  lValueReq  : SmallInt;
  lCompany   : String;
  lBudgType  : String;
  lTotalType : SmallInt;
  lCommitted : SmallInt;
  lTheYear   : SmallInt;
  lThePeriod : SmallInt;
  lTheCcy    : SmallInt;
  lJobCode   : String;
  lStockId   : String;
begin
  if CheckForOLEServer then
  begin
    lValueReq  := ValueReq;
    lCompany   := Company;
    lBudgType  := BudgType;
    lTotalType := TotalType;
    lCommitted := Committed;
    lTheYear   := TheYear;
    lThePeriod := ThePeriod;
    lTheCcy    := TheCcy;
    lJobCode   := JobCode;
    lStockId   := StockId;

    Result := EnterOLE.GetJCBudgetValue(lValueReq, lCompany, lBudgType, lTotalType, lCommitted,
                                        lTheYear, lThePeriod, lTheCcy, lJobCode, lStockId, ReturnVal);
  end
  else
  begin
    Result := 500;
    ReturnVal := 0;
  end;
end;

function EntCurrencyValue(Const ValueReq  : SmallInt; //0 - CompanyRate, 1 - DailyRate
                          Const Company   : ShortString;
                          Const Currency  : SmallInt;
                            var ReturnVal : Double) : SmallInt;
var
  lCompany  : String;
  lType : String;
  lCurrency : SmallInt;
begin
  if CheckForOLEServer then
  begin
    lCompany  := Company;
    lCurrency := Currency;
    Case ValueReq of
      0  : lType := 'C';
      1  : lType := 'D';
    end;
    Result := EnterOLE.GetCurrencyRate(lCompany, lType, lCurrency, ReturnVal);
  end
  else
  begin
    Result := 500;
    ReturnVal := 0;
  end;
end;





Initialization
  // HM 23/03/00: Modified to dynamically start the OLE Server as required
  //GotOLEServer := False;
  //EnterOLE := CreateOleObject('Enterprise.OLEServer');
  EnterOLE   := UnAssigned;
  DisableOLE := False;

  {$IFDEF OUTF}
    AssignFile (OutF, 'c:\entfuncs.txt');
    Rewrite (OutF);
  {$ENDIF}
Finalization
  {$IFDEF OUTF}
    CloseFile(OutF);
  {$ENDIF}
end.
