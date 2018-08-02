unit MainF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  COMObj, Enterprise01_TLB, ComCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    lblProgress: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    RecCount : Array [1..3] Of Integer;

    Function COMTHTest (oTrans : ITransaction; Const Lines : Boolean; Var Counter : Integer) : LongInt;
    Function OLETHTest (oTrans : Variant; Const Lines : Boolean; Var Counter : Integer) : LongInt;
    Function tkTrans (Const UseHed : Boolean) : LongInt;
    Function TimeInt : LongInt;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

Uses UseDllu;

// Import Btrieve Constants
{$I ExDllBt.Inc}

// Import Record Structures
{$I EXCHDLL.INC}


Var
  oToolkit  : Variant; //IToolkit;  // OLE Object
  oToolkit2 : IToolkit;  // COM Object
  BaseTime  : Dword;

procedure TForm3.FormCreate(Sender: TObject);
Const
  EntTKGuid : TGuid = '{F9C1BB23-3625-11D4-A992-0050DA3DF9AD}';
Var
  FuncRes : LongInt;
begin
  // Load Toolkit DLL
  FuncRes := Ex_InitDLL;
  If (FuncRes <> 0) Then
    ShowMessage ('oToolkit.OpenToolkit: ' + IntToStr(FuncRes));

  // Load Toolkit OLE object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') {As IToolkit};
  {If Assigned(oToolkit) Then} Begin
    FuncRes := oToolkit.OpenToolkit;
    If (FuncRes <> 0) Then
      ShowMessage ('oToolkit.OpenToolkit: ' + IntToStr(FuncRes));
  End; { If Assigned(oToolkit) }

  // Load Toolkit COM object
  oToolkit2 := {CoToolkit.Create; //}CreateComObject (EntTKGuid) As IToolkit;
  If Assigned(oToolkit2) Then Begin
    FuncRes := oToolkit2.OpenToolkit;
    If (FuncRes <> 0) Then
      ShowMessage ('oToolkit2.OpenToolkit: ' + IntToStr(FuncRes));
  End; { If Assigned(oToolkit) }
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  // Remove COM Toolkit references
  oToolkit2 := NIL;
  //oToolkit := NIL;

  // Close Toolkit DLL
  Ex_CloseDLL;
end;

//Function CycleCount : Int64;
//__int64 GetMachineCycleCount()
//{
//   __int64 cycles;
//   _asm rdtsc; // won't work on 486 or below - only pentium or above
//   _asm lea ebx,cycles;
//   _asm mov [ebx],eax;
//   _asm mov [ebx+4],edx;
//   return cycles;
//}

// returns current time as a longint in milli-seconds
Function TForm3.TimeInt : LongInt;
Var
  Tmp : DWord;
begin
  Tmp := (GetTickCount - BaseTime);
  Result := Tmp;
end;

procedure TForm3.Button1Click(Sender: TObject);
Var
  RecCount : Array [1..3] Of Integer;

  Function TKCust : LongInt;
  Var
    AccountRec : ^TBatchCURec;
    SearchKey  : PChar;
    Res        : SmallInt;
  begin { tkcust }
    Result := TimeInt;

    // Allocate memory for AccountRec pointer
    New (AccountRec);

    // Allocate memory for SearchKey variable
    SearchKey := StrAlloc (255);

    // Call Ex_GetAccount to find the first customer record
    Res := EX_GETACCOUNT(AccountRec,            // P
                         SizeOf(AccountRec^),   // PSIZE
                         SearchKey,             // SEARCHKEY
                         0,                     // SEARCHPATH
                         B_GetFirst,            // SEARCHMODE
                         1,                     // ACCTYPE - 1 = Customer
                         False);                // LOCK

    // Check to see if a record was returned OK
    While (Res = 0) Do Begin
      Inc (RecCount[1]);

      lblProgress.Caption := AccountRec^.CustCode + ' - ' + Trim(AccountRec^.Company) + ' - ' + Trim(AccountRec^.CustCode2);
      lblProgress.Refresh;

      // Call Ex_GetAccount to find the first customer record
      Res := EX_GETACCOUNT(AccountRec,            // P
                           SizeOf(AccountRec^),   // PSIZE
                           SearchKey,             // SEARCHKEY
                           0,                     // SEARCHPATH
                           B_GetNext,             // SEARCHMODE
                           1,                     // ACCTYPE - 1 = Customer
                           False);                // LOCK
    End; { While }

    // De-allocate memory for SearchKey variable
    StrDispose (SearchKey);

    // De-allocate memory for AccountRec pointer
    Dispose (AccountRec);

    Result := (Result - TimeInt) * -1;
  end; { tkcust }

  Function COMTKTest (oCust : IAccount; Var Counter : Integer) : LongInt;
  Var
    Res : LongInt;
  Begin { COMTKTest }
    Result := TimeInt;

    With oCust Do Begin
      Res := GetFirst;

      While (Res = 0) Do Begin
        Inc(Counter);

        lblProgress.Caption := acCode + ' - ' + Trim(acCompany) + ' - ' + Trim(acAltCode);
        lblProgress.Refresh;

        Res := GetNext;
      End; { While }
    End; { With oCust }

    Result := (Result - TimeInt) * -1;
  End; { COMTKTest }

  Function OLETKTest (oCust : Variant; Var Counter : Integer) : LongInt;
  Var
    Res : LongInt;
  Begin { COMTKTest }
    Result := TimeInt;

    {With oCust Do} Begin
      Res := oCust.GetFirst;

      While (Res = 0) Do Begin
        Inc(Counter);

        lblProgress.Caption := oCust.acCode + ' - ' + Trim(oCust.acCompany) + ' - ' + Trim(oCust.acAltCode);
        lblProgress.Refresh;

        Res := oCust.GetNext;
      End; { While }
    End; { With oCust }

    Result := (Result - TimeInt) * -1;
  End; { COMTKTest }

begin
  With ListView1.Items.Add Do Begin
    Caption := 'Customer List';

    RecCount[1] := 0;
    RecCount[2] := 0;
    RecCount[3] := 0;

    // Toolkit Test
    SubItems.Add (IntToStr(tkCust));

    // OLE Toolkit Test
    SubItems.Add (IntToStr(OLETKTest (oToolkit.Customer, RecCount[2])));

    // COM Toolkit Test
    SubItems.Add (IntToStr(COMTKTest (oToolkit2.Customer, RecCount[3])));

    lblProgress.Caption := Format ('Records Processed: TK(%d) OLE(%d) COM(%d)', [RecCount[1], RecCount[2], RecCount[3]]);
  End; { With ListView1.Items.Add }
end;

Function TForm3.tkTrans (Const UseHed : Boolean) : LongInt;
Type
  TLType = Array[1..1100] of TBatchTLRec;
Var
  THRec      : TBatchTHRec;
  TLArray    : ^TLType;
  SearchKey  : PChar;
  Res, LCnt  : SmallInt;
begin { tkTrans }
  Result := TimeInt;

  New(TLArray);

  // Allocate memory for SearchKey variable
  SearchKey := StrAlloc (255);
  StrPCopy (SearchKey, 'SIN');

  // Disable LineCount counting
  EX_SETCALCLINECOUNT(False);

  If UseHed Then
    // Call Ex_GetAccount to find the first customer record
    Res := EX_GETTRANSHED(@THRec, SizeOf(THRec),
                          SearchKey,             // SEARCHKEY
                          0,                     // SEARCHPATH
                          B_GetGEq,              // SEARCHMODE
                          False)                 // LOCK
  Else
    Res := EX_GETTRANS(@THRec, TLArray, SizeOf(THRec), SizeOf(TLArray^),
                       SearchKey,             // SEARCHKEY
                       0,                     // SEARCHPATH
                       B_GetGEq,              // SEARCHMODE
                       False);                // LOCK

  // Check to see if a record was returned OK
  LCnt := 0;
  While (Res = 0) And (Copy(THRec.OurRef, 1, 3) = 'SIN') Do Begin
    Inc (RecCount[1]);

    lblProgress.Caption := THRec.OurRef + ' - ' + IntToStr(THRec.LineCount);
    lblProgress.Refresh;

    //If (LCnt < THRec.LineCount) Then LCnt := THRec.LineCount;

    If UseHed Then
      Res := EX_GETTRANSHED(@THRec, SizeOf(THRec),
                            SearchKey,             // SEARCHKEY
                            0,                     // SEARCHPATH
                            B_GetNext,             // SEARCHMODE
                            False)                 // LOCK
    Else
      Res := EX_GETTRANS(@THRec, TLArray, SizeOf(THRec), SizeOf(TLArray^),
                           SearchKey,             // SEARCHKEY
                           0,                     // SEARCHPATH
                           B_GetNext,             // SEARCHMODE
                           False);                // LOCK
  End; { While }

//ShowMessage ('LineCount: ' + IntToStr(LCnt));

  // De-allocate memory for SearchKey variable
  StrDispose (SearchKey);

  Dispose(TLArray);

  Result := (Result - TimeInt) * -1;
end; { tkTrans }

Function TForm3.COMTHTest (oTrans : ITransaction; Const Lines : Boolean; Var Counter : Integer) : LongInt;
Var
  Res : LongInt;
Begin { COMTHTest }
  Result := TimeInt;

  With oTrans Do Begin
    Index := thIdxOurRef;
    Res := GetGreaterThanOrEqual('SIN');

    While (Res = 0) And (Copy(thOurRef, 1, 3) = 'SIN') Do Begin
      Inc (Counter);

      If Lines Then
        lblProgress.Caption := thOurRef + ' - ' + IntToStr(thLines.thLineCount)
      Else
        lblProgress.Caption := thOurRef;

      lblProgress.Refresh;

      Res := GetNext;
    End; { While }
  End; { With oTrans }

  Result := (Result - TimeInt) * -1;
End; { COMTHTest }

Function TForm3.OLETHTest (oTrans : Variant; Const Lines : Boolean; Var Counter : Integer) : LongInt;
Var
  Res : LongInt;
Begin { OLETHTest }
  Result := TimeInt;

  {With oTrans Do} Begin
    oTrans.Index := thIdxOurRef;
    Res := oTrans.GetGreaterThanOrEqual('SIN');

    While (Res = 0) And (Copy(oTrans.thOurRef, 1, 3) = 'SIN') Do Begin
      Inc (Counter);

      If Lines Then
        lblProgress.Caption := oTrans.thOurRef + ' - ' + IntToStr(oTrans.thLines.thLineCount)
      Else
        lblProgress.Caption := oTrans.thOurRef;

      lblProgress.Refresh;

      Res := oTrans.GetNext;
    End; { While }
  End; { With oTrans }

  Result := (Result - TimeInt) * -1;
End; { OLETHTest }

procedure TForm3.Button2Click(Sender: TObject);
begin
  With ListView1.Items.Add Do Begin
    Caption := 'Ex_GetTrans List';

    RecCount[1] := 0;
    RecCount[2] := 0;
    RecCount[3] := 0;

    // Toolkit Test
    SubItems.Add (IntToStr(tkTrans(False)));

    // OLE Toolkit Test
    SubItems.Add (IntToStr(OLETHTest (oToolkit.Transaction, True, RecCount[2])));

    // COM Toolkit Test
    SubItems.Add (IntToStr(COMTHTest (oToolkit2.Transaction, True, RecCount[3])));

    lblProgress.Caption := Format ('Records Processed: TK(%d) OLE(%d) COM(%d)', [RecCount[1], RecCount[2], RecCount[3]]);
  End; { With ListView1.Items.Add }
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  With ListView1.Items.Add Do Begin
    Caption := 'Ex_GetTransHed List';

    RecCount[1] := 0;
    RecCount[2] := 0;
    RecCount[3] := 0;

    // Toolkit Test
    SubItems.Add (IntToStr(tkTrans(True)));

    // OLE Toolkit Test
    SubItems.Add (IntToStr(OLETHTest (oToolkit.Transaction, False, RecCount[2])));

    // COM Toolkit Test
    SubItems.Add (IntToStr(COMTHTest (oToolkit2.Transaction, False, RecCount[3])));

    lblProgress.Caption := Format ('Records Processed: TK(%d) OLE(%d) COM(%d)', [RecCount[1], RecCount[2], RecCount[3]]);
  End; { With ListView1.Items.Add }
end;

procedure TForm3.Button4Click(Sender: TObject);
Const
  Repeats = 50;
Var
  Times  : Array [1..3] Of LongInt;
  I      : SmallInt;
begin
  With ListView1.Items.Add Do Begin
    Caption := 'Ex_GetTrans List';

    Times[1] := 0;
    Times[2] := 0;
    Times[3] := 0;

    For I := 1 To Repeats Do Begin
      RecCount[1] := 0;
      RecCount[2] := 0;
      RecCount[3] := 0;

      Times[1] := Times[1] + tkTrans(False);

      Times[2] := Times[2] + OLETHTest (oToolkit.Transaction, True, RecCount[2]);

      Times[3] := Times[3] + COMTHTest (oToolkit2.Transaction, True, RecCount[3]);
    End; { For I }

    Times[1] := Times[1] Div Repeats;
    Times[2] := Times[2] Div Repeats;
    Times[3] := Times[3] Div Repeats;

    // Toolkit Test
    SubItems.Add (IntToStr(Times[1]));

    // OLE Toolkit Test
    SubItems.Add (IntToStr(Times[2]));

    // COM Toolkit Test
    SubItems.Add (IntToStr(Times[3]));

    lblProgress.Caption := Format ('Records Processed: TK(%d) OLE(%d) COM(%d)', [RecCount[1], RecCount[2], RecCount[3]]);
  End; { With ListView1.Items.Add }
end;

Initialization
  BaseTime := GetTickCount;
end.

