unit BtSupu2;

{$I DEFOVR.Inc}

interface

Uses
  GlobVar,
  VarConst,
  WinTypes,
  Messages,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  Forms,
  BtrvU2;


Type
  tObjectSERec  =  Record
                     OSCode  :  Str20;
                     OLCode,
                     OCCode  :  Str10;
                     OCurr,
                     OTCurr  :  SmallInt;
                   end;

  TWindowsVersion = (wv31, wv95, wv98, wvNT3, wvNT4, wv2000, wvNT4TerminalServer
  , wv2000TerminalServer, wvNTOther, wvUnknown, wvXPTerminalServer, wvXP);

const
  wvXPStyle = [wvXP, wvXPTerminalServer];


Var
  STDStkTList,
  STDValList,
  STDVATList,

  {$IFDEF JC}
    STDCISList,
  {$ENDIF}

  STDDocTList,
  STDQtyBList,
  STDNomTList,
  STDCurrList,
  STDAccStatusList,
  STDAccLedStatusList :  TStringList; //PL 09/01/2017 : 2017 R1 :	ABSEXCH-17809 Copied changes from R&D/BTSup1U.pas


Procedure Set_DefaultVAT(ThisSet  :  TStrings;
                         ShowInc,
                         ShowFull :  Boolean);

Procedure Build_DefaultCVAT(ThisSet  :  TStrings;
                            ShowInc,
                            ShowMan,
                            ShowEC,
                            ShowFull :  Boolean);

Procedure Set_DefaultCVAT(ThisSet  :  TStrings;
                          ShowFull :  Boolean);


{$IFDEF JC}
  Procedure Init_STDCISList;

  Procedure Set_DefaultCIS(ThisSet  :  TStrings;
                           ShowFull,
                           ShowNA   :  Boolean);

  {$IFDEF JAP}
    Procedure Set_DefaultJADed(ThisSet  :  TStrings;
                               ShowFull,
                               ShowNA   :  Boolean);

    Procedure Set_DefaultJARet(ThisSet  :  TStrings;
                               ShowFull,
                               ShowNA   :  Boolean);
  {$ENDIF}
{$ENDIF}

Function TxLatePound(Const TS     :  Str255;
                     Const From   :  Boolean)  :  Str255;


Procedure Set_DefaultCurr(ThisSet  :  TStrings;
                          IncZero,
                          ShowFull :  Boolean;
                          ShowBlankRecord :  Boolean=True);

Procedure Set_DefaultPr(ThisSet  :  TStrings);

Procedure Set_DefaultYr(ThisSet  :  TStrings;
                        ThisYr   :  Byte);

Function Set_TSIndex(ThisSet  :  TStrings;
                     CI       :  Integer;
                     T2M      :  Str255)  :  Integer;

Procedure Set_DefaultDocT(ThisSet  :  TStrings;
                          ShowInc,
                          ShowFull :  Boolean);

{$IFDEF JC}
  Procedure Set_JAPDefaultDocT(ThisSet  :  TStrings;
                               Mode     :  Byte);
{$ENDIF}

Procedure Set_DefaultNomT(ThisSet  :  TStrings;
                          ShowFull :  Boolean);

Procedure Set_DefaultNOMClass(ThisSet  :  TStrings;
                              ShowFull :  Boolean);

Function TxLate_NOMClass(CLItem  :  Integer;
                         FromRec :  Boolean)  :  Integer;

  //PL 09/01/2017 : 2017 R1 :	ABSEXCH-17809 Copied changes from R&D/BTSup1U.pas
  Procedure Set_DefaultAccLedStatus(ThisSet  :  TStrings;
                                 ShowInc,
                                 ShowFull :  Boolean);    
{$IFDEF STK}
  Procedure Set_DefaultStkT(ThisSet  :  TStrings;
                            ShowInc,
                            ShowFull :  Boolean;
                            ShowBlankRecord :  Boolean=True);

  Procedure Set_DefaultVal(ThisSet  :  TStrings;
                           ShowInc,
                           ShowFull,
                           AddSNAV  :  Boolean);

  Procedure Set_DefaultQtyB(ThisSet  :  TStrings;
                            ShowInc,
                            ShowFull :  Boolean);

  Function StkPriceIndex(SRec  :  StockRec)  :  Integer;

  {$IFDEF RET}
    Procedure Set_DefaultRetStat(ThisSet  :  TStrings;
                                 UseSale,
                                 ShowFull :  Boolean);

    Function  Get_RetLineStat(dno  :  Byte)  :  Str50;

    Procedure Set_RetLineStat(ThisSet  :  TStrings);

    Procedure XSet_RetLineStat(ThisSet  :  TStrings);

  {$ENDIF}
{$ENDIF}

Procedure Set_GLViewList(ThisSet  :  TStrings;
                         ShowFull :  Boolean);

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

function GetNewTabIdx(PC  :  TPageControl;
                      KC  :  Word)  :  Integer;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);


Procedure SendToObjectCC(NCode  :  Str20;
                         OMode  :  Byte);

Procedure SendToObjectStkEnq(NCode  :  Str20;
                             LCode,
                             CUode  :  Str10;
                             CCurr,
                             TCurr  :  SmallInt;
                             OMode  :  Byte);


Procedure SendSuperOpoStkEnq(NCode  :  Str20;
                             LCode,
                             CUode  :  Str10;
                             CCurr,
                             TCurr  :  SmallInt;
                             OMode  :  Byte);


Function MatchOwner(Const MStr  :  Str255;
                    Const Ownby :  TObject)  :  Boolean;

Procedure MDI_SetFormCoord(Var F  :  TForm);

Procedure MDI_UpdateParentStat;

Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);

Procedure MDI_UpdateParentBkGnd(WholeScreen  :  Boolean);

Function GetMaxColors(Handle  :  HDC)  :  Integer;

Procedure GenCanCloseAll(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow,
                      CheckChild
                               :  Boolean);

Procedure GenCanClose(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow  :  Boolean);

Procedure GenForceClose(PForm    :  TForm;
                        Sender   :  TObject;
                    Var CanClose :  Boolean);

Procedure Get_NonClientInfo;

Function GenCheck_InPrint  :  Boolean;

procedure SetNextLine(FP,TC,LC,PC
                                 :  TObject;
                      Var Key    :  Char);

{$IFDEF MC_On}
  Function Set_EuroVer  :  Str255;
{$ENDIF}

Function Get_CustmFieldCaption(DataSet,AryNo  :  SmallInt)  :  String;

Function Get_CustmFieldHide(DataSet,AryNo  :  SmallInt)  :  Boolean;

Procedure Init_STDVATList;
Procedure Init_STDCurrList;
Procedure Init_STDDocTList;
// CJS 2016-05-03 ABSEXCH-9497: Copied changes from R&D/BTSup1U.pas
Procedure Set_DefaultAccStatus(ThisSet: TStrings; ShowInc, ShowFull: Boolean);
Procedure Init_STDAccLedStatusList; //PL 09/01/2017 : 2017 R1 :	ABSEXCH-17809 Copied changes from R&D/BTSup1U.pas
{$IFDEF STK}
  Procedure Init_STDStkTList;
  Procedure Init_STDValList;
{$ENDIF}

Procedure BtSupU2_Init;

Procedure BtSupU2_Destroy;

function WinGetUserName : Ansistring;

function GetWindowsVersion : TWindowsVersion;

Function IS_WINXPStyle  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  Registry,
  SysUtils,
  Grids,
  SBSOutL,
  VarRec2U,
  TEditVal,
  BorBtns,
  BTSupU1,
  ComnU2,
  SysU1,
  SBSComp2,

  {$IFNDEF ENSECR}
    XPThemes,
  {$ENDIF}

  {$IFDEF JC}
     VarJCSTU,
  {$ENDIF}

  PWarnU,

  SButton,
  CustomFieldsVar,
  CustomFieldsIntf;

{* Function to Return TList of Std VAT Items *}

Procedure Init_STDVATList;

Var
  n  :  VATType;

Begin
  STDVATList:=TStringList.Create;

  try

    For n:=VStart to VEnd do
    With SyssVAT^ do
    Begin
      With VATRates.VAT[n] do
        STDVATList.Add(Code+' - '+Desc);
    end;

  except
    STDVATList.Free;

  end;

end;


Procedure Set_DefaultVAT(ThisSet  :  TStrings;
                         ShowInc,
                         ShowFull :  Boolean);

Var
  n  :  Byte;

Begin
  ThisSet.Assign(STDVATList);

  If (ShowInc) then
  Begin
    ThisSet.Add('I - Inclusive');
    ThisSet.Add('M - Manual');
  end;

  {If (Syss.IntraStat) then}
  Begin
    ThisSet.Add('A - Aquisitions');
    ThisSet.Add('D - Despatches');
  end;

  If (Not ShowFull) then
  Begin
    For n:=0 to Pred(ThisSet.Count) do
      ThisSet[n]:=Copy(ThisSet[n],1,1);

  end;
end;


Procedure Build_DefaultCVAT(ThisSet  :  TStrings;
                            ShowInc,
                            ShowMan,
                            ShowEC,
                            ShowFull :  Boolean);

Var
  n  :  Byte;

Begin
  ThisSet.Assign(STDVATList);

  If (ShowInc) then
  Begin
    ThisSet.Add('I - Inclusive');

    If (ShowMan) then
      ThisSet.Add('M - Manual');
  end;

  {$IFDEF SOP}
    If (Syss.IntraStat) and (ShowEC) then
  {$ELSE}
    If (ShowEC) then
  {$ENDIF}
  Begin
    ThisSet.Add('A - Aquisitions');
    ThisSet.Add('D - Despatches');
  end;

  If (Not ShowFull) then
  Begin
    For n:=0 to Pred(ThisSet.Count) do
      ThisSet[n]:=Copy(ThisSet[n],1,1);

  end;
end;


Procedure Set_DefaultCVAT(ThisSet  :  TStrings;
                          ShowFull :  Boolean);


Begin
  Build_DefaultCVAT(ThisSet,BOn,BOff,BOn,ShowFull);
end;


{$IFDEF JC}

  {* Function to Return TList of Std CIS Items *}

  Procedure Init_STDCISList;

  Var
    n  :  CISTaxType;

  Begin
    STDCISList:=TStringList.Create;

    try

      For n:=CISStart to CISEnd do
      With SyssCIS^ do
      Begin
        With CISRates.CISRate[n] do
          STDCISList.Add(Code+' - '+Desc);
      end;

    except
      STDCISList.Free;

    end;

  end;


  Procedure Set_DefaultCIS(ThisSet  :  TStrings;
                           ShowFull,
                           ShowNA   :  Boolean);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDCISList);

    If (ShowNA) then
      ThisSet.Insert(0,'N/A');

    If (Not ShowFull) then
    Begin
      For n:=Ord(ShowNA) to Pred(ThisSet.Count) do
        ThisSet[n]:=Copy(ThisSet[n],1,1);

    end;
  end;

  {$IFDEF JAP}
    Procedure Set_DefaultJADed(ThisSet  :  TStrings;
                               ShowFull,
                               ShowNA   :  Boolean);
    Var
      AStr  :  Str20;

    Begin
      If (ShowFull) then
        AStr:='Apply '
      else
        AStr:='';

      With ThisSet do
      Begin
        Add(AStr+'to all Analysis Codes');
        Add(AStr+'Materials only');
        Add(AStr+'Labour only');
        Add(AStr+'Labour and Materials');
        Add(AStr+'Overheads only');
      end;
    end;

    Procedure Set_DefaultJARet(ThisSet  :  TStrings;
                               ShowFull,
                               ShowNA   :  Boolean);
    Begin
      With ThisSet do
      Begin
        Add('One off');
        Add('Interim');
        Add('Practical');
          
        If (ShowFull) then
          Add('Final');
      end;
    end;



  {$ENDIF}

{$ENDIF}



{* Function to Return TList of Std Currency Items *}


Function TxLatePound(Const TS     :  Str255;
                     Const From   :  Boolean)  :  Str255;

Var
  P  :  Integer;

Begin
  Result:=TS;

  If (From) then
    P:=Pos(#156,Result)
  else
    P:=Pos('£',Result);

  While (p<>0) do
  Begin
    If (From) then
    Begin
      Result[p]:='£';

      P:=Pos(#156,Result);
    end
    else
    Begin
      Result[p]:=#156;

      P:=Pos('£',Result);
    end;
  end;
end;


Procedure Init_STDCurrList;

Var
  n,
  TotCurr  :  Integer;

  Ts :  Str10;

Begin
  STDCurrList:=TStringList.Create;

  try

    If (EuroVers) then
      TotCurr:=2
    else
    {$IFDEF LTE}
      TotCurr:=Pred(Currency1Page);

    {$ELSE}
      TotCurr:=CurrencyType;
    {$ENDIF}
    
    For n:=0 to TotCurr do
    With SyssCurr^ do
    Begin
      With Currencies[n] do
      Begin
        Ts:=SSymb;

        Ts:=TxLatePound(Ts,BOn);

        STDCurrList.Add(Ts+' - '+Desc);

      end;
    end;

  except
    STDCurrList.Free;

  end;


end;


Procedure Set_DefaultCurr(ThisSet  :  TStrings;
                          IncZero,
                          ShowFull :  Boolean;
                          ShowBlankRecord :  Boolean);


Var
  n  :  Byte;

Begin
  ThisSet.Assign(STDCurrList);

  If (Not IncZero) then
    ThisSet.Delete(0);

  If (Not ShowFull) then
  Begin
    For n:=0 to Pred(ThisSet.Count) do
      ThisSet[n]:=ExtractWords(1,1,ThisSet[n]);

  end;
end;


Procedure Set_DefaultPr(ThisSet  :  TStrings);


Var
  n  :  Integer;

Begin
  ThisSet.Clear;

  For n:=1 to Syss.PrInYr do
  Begin
    If (GetLocalPr(0).DispPrAsMonths) then
      ThisSet.Add(PPr_Pr(n))
    else
      ThisSet.Add(SetN(n));
  end;
end;


Procedure Set_DefaultYr(ThisSet  :  TStrings;
                        ThisYr   :  Byte);

Var

  n,
  Start  :  Integer;

Begin
  ThisSet.Clear;

  Start:=TxLateYrVal(ThisYr,BOff);

  For n:=Start-10 to Start+10 do
  Begin
    ThisSet.Add(Form_Int(n,0));
  end;
end;


Function Set_TSIndex(ThisSet  :  TStrings;
                     CI       :  Integer;
                     T2M      :  Str255)  :  Integer;

Var

  n        :  Integer;

  FoundOk  :  Boolean;



Begin
  If (CI>=0) then
    Result:=CI
  else
    Result:=0;

  FoundOk:=BOff;

  With ThisSet do
    For n:=0 to Pred(Count) do
    Begin
      FoundOk:=CheckKey(T2M,Strings[n],Length(T2M),BOff);

      If (FoundOk) then
        Break;

    end; {with..}

  If (FoundOk) then
    Result:=n;
end;



{* Function to Return TList of Doc Type Headings*}

Procedure Init_STDDocTList;
Var
  n : Byte;
Begin
  STDDocTList:=TStringList.Create;

  try
    STDDocTList.Add('Normal');
    for n := 1 to 4 do
    begin
      STDDocTList.Add(CustomFields[cfLinetypes, n].cfCaption);
    end;
  except
    STDDocTList.Free;
  end;
end;

Procedure Set_DefaultAccStatus(ThisSet  :  TStrings;
                          ShowInc,
                          ShowFull :  Boolean);
Begin
  ThisSet.Assign(STDAccStatusList);
end;

Procedure Set_DefaultDocT(ThisSet  :  TStrings;
                          ShowInc,
                          ShowFull :  Boolean);

Var
  n  :  Byte;

Begin
  ThisSet.Assign(STDDocTList);

end;

{$IFDEF JC}
  Procedure Set_JAPDefaultDocT(ThisSet  :  TStrings;
                               Mode     :  Byte);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDDocTList);

    For n:=Low(JALTypes^) to High(JALTypes^) do
      ThisSet.Add(JALTypes^[n]);

  end;

{$ENDIF}

  {* Function to Return TList of Nom Type Headings *}

  Procedure Init_STDNomTList;

  Var
    n  :  Byte;

  Begin
    STDNomTList:=TStringList.Create;

    try
      With STDNomTList do
      Begin
        Add('Balance Sheet (B)');
        Add('Profit & Loss (A)');
        Add('Control (C)');
        Add('Heading (H)');
        Add('Carry Forward (F)');

      end; {With..}

    except
      STDNOMTList.Free;

    end;

  end;



  Procedure Set_DefaultNOMT(ThisSet  :  TStrings;
                            ShowFull :  Boolean);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDNomTList);

    If (Not ShowFull) then
    Begin
      For n:=0 to Pred(ThisSet.Count) do
        ThisSet[n]:=Copy(ThisSet[n],Length(ThisSet[n])-1,1);
    end;
  end;



Procedure Set_DefaultNOMClass(ThisSet  :  TStrings;
                              ShowFull :  Boolean);


Const                                                              {A gap of 10 has been allowed between each one to allow for insertions}
  GLClasses  :  Array[0..9] of Str50 = ('','Bank Account',         {01}
                                           'Closing Stock',        {02}
                                           'Finished Goods',       {03}
                                           'Stock Value',          {04}
                                           'WOP WIP',              {05}
                                           'Overheads',            {06}
                                           'Misc',                 {07}
                                           'Sales Return',         {08}
                                           'Purch Return');        {09}

Var
  n  :  Byte;

Begin
  ThisSet.Clear;

  {If (Not ShowFull) then}
  Begin
    For n:=Low(GLClasses) to High(GLClasses) do
    Begin
      If ShowFull {$IFNDEF STK} or (Not (n In [2..5,8,9])) {$ELSE} or (n In [0..4,6..7]) {$IFDEF RET} or ((n In [8,9]) and (RetMOn))  {$ENDIF} {$IFDEF WOP} or ((n In [5]) and (WOPOn))  {$ENDIF} {$ENDIF} then
        ThisSet.Add(GLClasses[n]);

    end;
  end;
end;


Function TxLate_NOMClass(CLItem  :  Integer;
                         FromRec :  Boolean)  :  Integer;

Begin
  Result:=0;

  If (FromRec) then
  Begin
    Case CLItem of
      10  :  Result:=1;
      {$IFNDEF STK}
        60  :  Result:=2;
        70  :  Result:=3;
      {$ELSE}
        {$IFNDEF WOP}
          20..40  : Result:=Trunc(CLItem/10);
          50..90  : Result:=Pred(Trunc(CLItem/10));
        {$ELSE}
          20..90  : If (Not WOPOn) and (CLItem In [50..90]) then
                      Result:=Pred(Trunc(CLItem/10))
                    else
                      Result:=Trunc(CLItem/10);
        {$ENDIF}
      {$ENDIF}

      else
        Result:=0;
    end; {Case..}
  end
  else
  Begin
    Case CLItem of
      1  :  Result:=10;
      {$IFNDEF STK}
        2  :  Result:=60;
        3  :  Result:=70;
      {$ELSE}
        {$IFNDEF WOP}
          2..4  : Result:=CLItem*10;
          5..9  : Result:=Succ(CLItem)*10;
        {$ELSE}
          2..9  : If (Not WOPOn) and (CLItem In [5..9]) then
                    Result:=Succ(CLItem)*10
                  else
                    Result:=CLItem*10;
        {$ENDIF}
      {$ENDIF}

      else
        Result:=0;

    end; {Case..}
  end;
end;

//PL 09/01/2017 : 2017 R1 :	ABSEXCH-17809 Copied changes from R&D/BTSup1U.pas
Procedure Init_STDAccLedStatusList;
  Var
    n  :  Byte;
  Begin
    STDAccLedStatusList:=TStringList.Create;
    try
      With STDAccLedStatusList do
      Begin
        Add('No Hold');
        Add('Query ');
        Add('Hold until Allocated');
        Add('Authorise Payment');
        Add('Hold for any stock');
        Add('Hold for Credit');
        Add('Notes on transaction');
        Add('Suspend');
        Add('PPD Available');
        Add('PPD Taken');
      end; {With..}
    except
      STDAccLedStatusList.Free;
    end;
  End;  


  //PL 09/01/2017 : 2017 R1 :	ABSEXCH-17809 Copied changes from R&D/BTSup1U.pas
  Procedure Set_DefaultAccLedStatus(ThisSet  :  TStrings;
                            ShowInc,
                            ShowFull :  Boolean);
  Begin
    ThisSet.Assign(STDAccLedStatusList);
  end;        

{$IFDEF STK}

  {* Function to Return TList of Stk Type Headings*}

  Procedure Init_STDStkTList;

  Var
    n  :  Byte;

  Begin
    STDStkTList:=TStringList.Create;

    try
      With STDStkTList do
      Begin
        If (FullStkSysOn) then
          Add('Product');

        Add('Description Only');
        Add('Group');
        Add('Discontinued');

        {$IFDEF PF_On}
          If (FullStkSysOn) then
            Add('Bill of Materials');
        {$ENDIF}

      end; {With..}

    except
      STDStkTList.Free;

    end;

  end;



  Procedure Set_DefaultStkT(ThisSet  :  TStrings;
                            ShowInc,
                            ShowFull :  Boolean;
                            ShowBlankRecord :  Boolean=True);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDStkTList);
  end;


  {* Function to Return TList of Stk Valuation Headings*}

  Procedure Init_STDValList;

  Var
    n  :  Byte;

  Begin
    STDValList:=TStringList.Create;

    try
      With STDValList do
      Begin
        {$IFNDEF LTE}
          Add('Last Cost');
          Add('Standard');

          {$IFDEF PF_On}
            Add('FIFO');
            Add('LIFO');
            Add('Average');

            {$IFDEF SOP}
              Add('Serial/Batch');
            {$ENDIF}
          {$ENDIF}
        {$ELSE}
          Add('Standard');

          Add('FIFO');
          Add('Average');
        {$ENDIF}
          
      end; {With..}

    except
      STDValList.Free;

    end;

  end;



  Procedure Set_DefaultVal(ThisSet  :  TStrings;
                           ShowInc,
                           ShowFull,
                           AddSNAV  :  Boolean);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDValList);

    {$IFNDEF LTE}

      {$IFDEF SOP}
         If (AddSNAV) then
           ThisSet.Add('Serial/Batch Average Cost');

      {$ENDIF}
    {$ENDIF}
  end;


  {* Function to Return TList of Stk Type Headings*}

  Procedure Init_STDQBList;

  Var
    n  :  Byte;

  Begin
    STDQtyBList:=TStringList.Create;

    try
      With STDQtyBList do
      Begin
        Add('B Band Price (less discount)');
        Add('P Special Price');
        Add('M Margin %');
        Add('U Markup %');

      end; {With..}

    except
      STDQtyBList.Free;

    end;

  end;



  Procedure Set_DefaultQtyB(ThisSet  :  TStrings;
                            ShowInc,
                            ShowFull :  Boolean);

  Var
    n  :  Byte;

  Begin
    ThisSet.Assign(STDQtyBList);

    If (ShowInc) then
      ThisSet.Add('Q Qty break');

    For n:=0 to Pred(ThisSet.Count) do
      If (ShowFull) then
        ThisSet[n]:=Copy(ThisSet[n],3,Length(ThisSet[n])-2)
      else
        ThisSet[n]:=Copy(ThisSet[n],1,1);

  end;


  Function StkPriceIndex(SRec  :  StockRec)  :  Integer;

  Begin
    With SRec do
    Begin
      If (CalcPack) then
        Result:=0
      else
        If (PricePack) then
          Result:=2
        else
          Result:=1;
    end; {With..}
  end;


  {$IFDEF RET}
    Procedure Set_DefaultRetStat(ThisSet  :  TStrings;
                                 UseSale,
                                 ShowFull :  Boolean);

    Const
      SFullDesc  :  Array[0..9] of Str50 = ('Pending action for',
                                          'Quarantined for inspection on',
                                          'Credit & Write off',
                                          'SOR generated for replacement goods from',
                                          'SOR <> POR gen. for replacement goods from',
                                          'SIN generated for replacement goods based on',
                                          'Repair SIN generated based on',
                                          'Write Off',
                                          'Issue Stock',
                                          'Return complete');

      SShortDesc :  Array[0..9] of Str50 = ('Pending',
                                           'Quarantined',
                                           'Credit/WO',
                                           'SOR gen.',
                                           'SOR<>POR',
                                           'SIN gen.',
                                           'Rep SIN gen.',
                                           'Write Off',
                                           'Issue',
                                           'Complete');

      PFullDesc  :  Array[0..7] of Str50 = ('Pending action for',
                                          'Quarantined for inspection on',
                                          'Credit & Write off',
                                          'PDN generated for replacement goods from',
                                          'PIN generated for replacement goods based on',
                                          'Repair PIN generated based on',
                                          'Write Off',
                                          'Return complete');

      PShortDesc :  Array[0..7] of Str50 = ('Pending',
                                           'Quarantined',
                                           'Credit/WO',
                                           'PDN gen.',
                                           'PIN gen.',
                                           'Rep PIN gen.',
                                           'Write Off',
                                           'Complete');

    Var
      n        :  Byte;
      ListStr  :  Str255;

    Begin
      ThisSet.Clear;

      If (UseSale) then
      Begin
        For n:=Low(SFullDesc) to High(SFullDesc) do
        Begin
          If (ShowFull) then
            ListStr:=SFullDesc[n]
          else
            ListStr:=SShortDesc[n];

          If (n<High(SFullDesc)) and (ShowFull) then
            ListStr:=ListStr+' '+DocCodes[Doctypes(Ord(PRN)-Ord(UseSale))];

          ThisSet.Add(ListStr);
        end; {Loop..}
      end
      else
      Begin
        For n:=Low(PFullDesc) to High(PFullDesc) do
        Begin
          If (ShowFull) then
            ListStr:=PFullDesc[n]
          else
            ListStr:=PShortDesc[n];

          If (n<High(PFullDesc)) and (ShowFull) then
            ListStr:=ListStr+' '+DocCodes[Doctypes(Ord(PRN)-Ord(UseSale))];

          ThisSet.Add(ListStr);
        end; {Loop..}
      end;
    end;


    Function  XGet_RetLineStat(dno  :  Byte)  :  Str50;

    Const
      FullDesc  :  Array[0..8] of Str50 = ('N/A',
                                          'Damaged',
                                          'Faulty',
                                          'Not Required',
                                          'Incorrect Order',
                                          'Out of Date',
                                          'Discontinued',
                                          'Sale/Return',
                                          'Repair Quote');


    Begin
      If (dno<=High(FullDesc)) then
        Result:=FullDesc[dno]
      else
        Result:='';

    end;


    Procedure XSet_RetLineStat(ThisSet  :  TStrings);


    Var
      n        :  Byte;
      ListStr  :  Str255;

    Begin
      ThisSet.Clear;

      For n:=0 to 8 do
      Begin
        ListStr:=XGet_RetLineStat(n);

        ThisSet.Add(ListStr);
      end; {Loop..}
    end;


    Function  Get_RetLineStat(dno  :  Byte)  :  Str50;

    Const
      Fnum    =  MiscF;
      Keypath =  MIK;

    Var
      KeyS    :  Str255;

      TmpKPath,
      TmpStat :  Integer;
      TmpMisc :  MiscRec;

      TmpRecAddr
              :  LongInt;

    Begin
      TmpMisc:=MiscRecs^;

      Result:='';

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyS:=RetRLCode+RetPFCode+SetPadNo(Form_Int(dno,0),4);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      If (StatusOk) then
        Result:=MiscRecs^.rtReasonRec.ReasonDesc;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;
    end;


    Procedure Set_RetLineStat(ThisSet  :  TStrings);


        Const
      Fnum    =  MiscF;
      Keypath =  MIK;

    Var
      KeyChk,
      KeyS    :  Str255;

      TmpKPath,
      TmpStat :  Integer;
      TmpMisc :  MiscRec;

      TmpRecAddr
              :  LongInt;

      ListStr  :  Str255;


    Begin
      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=RetRLCode+RetPFCode;

      KeyS:=RetRLCode+RetPFCode+#32;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      Begin
        ListStr:=MiscRecs^.rtReasonRec.ReasonDesc;

        ThisSet.Add(ListStr);

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;

      If (ThisSet.Count=0) then
        ThisSet.Add('N/A');

    end; {Proc..}


  {$ENDIF}



{$ENDIF}



Function Can_ViewView(VN  :  Integer)  :  Boolean;

Begin
  Result:=BOn;

  Case VN of
    001..100  :  Result:=ChkAllowed_In(557);
    101..200  :  Result:=ChkAllowed_In(558);
    201..300  :  Result:=ChkAllowed_In(559);
    301..400  :  Result:=ChkAllowed_In(560);
    401..500  :  Result:=ChkAllowed_In(561);
    501..600  :  Result:=ChkAllowed_In(562);
    601..700  :  Result:=ChkAllowed_In(563);
    701..800  :  Result:=ChkAllowed_In(564);
    801..900  :  Result:=ChkAllowed_In(565);
    901..999  :  Result:=ChkAllowed_In(566);
  end; {Case..}



end;

    Procedure Set_GLViewList(ThisSet  :  TStrings;
                             ShowFull :  Boolean);


    Const
      Fnum    =  NomViewF;
      Keypath =  NVCodeK;

    Var
      KeyChk,
      KeyS    :  Str255;

      TmpKPath,
      TmpStat :  Integer;
      TmpMisc :  NomViewRec;

      TmpRecAddr
              :  LongInt;

      ListStr  :  Str255;


    Begin
      ThisSet.Clear;

      ThisSet.Add('No View Selected');

      TmpMisc:=NomView^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=NVRCode+NVCSCode;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With NomView^.ViewCtrl do
      Begin
        If ((Not InActive) or (ChkAllowed_In(547))) and (Can_ViewView(ViewCtrlNo)) then
        Begin
          ListStr:=SetPadNo(Form_Int(ViewCtrlNo,0),3)+'. ';

          {If (ShowFull) then}
            ListStr:=ListStr+' - '+Trim(ViewDesc);

          ThisSet.Add(ListStr);
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      NomView^:=TmpMisc;


    end; {Proc..}




{ ================ Global Key handling routines =============== }

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:=((Syss.TxlateCR) );

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         { HM 09/11/99: Was interfering with Memo control on print dialog }
         ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
         (ActiveControl is TSBSOutLineB) then {* switched off so it does not interfere with a list *}
        IrqKey:=BOff;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

  end;
end;

function GetNewTabIdx(PC  :  TPageControl;
                      KC  :  Word)  :  Integer;

{* Could not use, as VK_Home&End seem to be intercepted by list boxes *}
Begin
  
  Case KC of
    VK_Prior,
    VK_Next   :  With PC do
                   Result:=FindNextPage(ActivePage,(KC=VK_Next),BOn).PageIndex;

    VK_Home   :  Result:=0;
    VK_End    :  Result:=Pred(Pc.PageCount);
    else         Result:=PC.ActivePage.PageIndex;

  end;
end;


procedure ClickOk(Sender  :  TObject;
              Var VKey    :  Word);

Var
  FForm  :  TForm;
  n      :  Integer;

Begin
  If (Sender is TForm) then
    With TForm(Sender) do
    Begin
      For n:=0 to Pred(ComponentCount) do
        If (Components[n] is TButton) then
          With TButton(Components[n]) do
            If ((Caption='&OK') or (ModalResult=mrOk)) and (Enabled) and (Visible) and (CanFocus) then
            Begin
              VKey:=0;
              Click;
              Exit
            end;


    end;

end;



procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  Begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    If (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown) or
       (ActiveControl is TScrollButton) or

         { HM 09/11/99: Was interfering with Memo control on print dialog }
       ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
       (ActiveControl is TSBSOutLineB) then {* Could combine with a switch, as there maybe cases where a
                                                                                 a string grid is used without the list... *}
      IrqKey:=BOff;


  If (IrqKey) then
  Case Key of


    VK_Up  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  Begin
                If (Key=VK_Return) and (Not Syss.TxLateCr) then
                  Exit;


                If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;

  end;

  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift)) and (AllowHotKey) then
  Begin
    If (Key=VK_F9) then
    Begin
      If (ActiveControl is TComponent) then
      Begin
        TComp:=TComponent(ActiveControl);
        LastValueObj.GetValue(TComp);
        PostMessage(Handle,wm_NextDlgCtl,0,0);
      end;
    end
    else
      if Assigned(Application.MainForm) then PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
  end;

  If (ActiveControl is TScrollButton) then {Don't go any further}
    Exit;

  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift) and (AllowHotKey) then {* Select Next/Prev page of tabbed notebook *}
    PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift) and (AllowHotKey) then {* Jump straight to list body *}
    PostMessage(Handle,wm_CustGetRec,176,Ord(Key=VK_Home));

  If ((Key=VK_Return) and (ssCtrl In Shift)) then
    ClickOK(Sender,Key);

end;


Procedure SendToObjectCC(NCode  :  Str20;
                         OMode  :  Byte);


Var
  CCode  :  ^Str20;

Begin
  New(CCode);

  CCode^:=NCode;

  PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,76+OMode,LongInt(@CCode^));

end;


Procedure SendToObjectStkEnq(NCode  :  Str20;
                             LCode,
                             CUode  :  Str10;
                             CCurr,
                             TCurr  :  SmallInt;
                             OMode  :  Byte);


Var
  CCode  :  ^tObjectSERec;

  MsgNo  :  Word;


Begin
  New(CCode);

  Blank(CCode^,Sizeof(CCode^));

  CCode^.OSCode:=NCode;
  CCode^.OLCode:=LCode;
  CCode^.OCCode:=CUode;
  CCode^.OCurr:=CCurr;
  CCode^.OTCurr:=TCurr;

  If (OMode=1) then
    MsgNo:=218
  else
    MsgNo:=212;

  PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,MsgNo,LongInt(@CCode^));

end;


Procedure SendSuperOpoStkEnq(NCode  :  Str20;
                             LCode,
                             CUode  :  Str10;
                             CCurr,
                             TCurr  :  SmallInt;
                             OMode  :  Byte);

Var
  CCode  :  ^tObjectSERec;

Begin

  SendToObjectStkEnq(NCode,LCode,CUode,CCurr,TCurr,OMode);

  New(CCode);

  Blank(CCode^,Sizeof(CCode^));

  CCode^.OSCode:=NCode;
  CCode^.OLCode:=LCode;
  CCode^.OCCode:=CUode;
  CCode^.OCurr:=CCurr;
  CCode^.OTCurr:=TCurr;

  PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,229,LongInt(@CCode^));

end;



{ ======= Procedure to Check all owners up to top level ===== }

Function MatchOwner(Const MStr  :  Str255;
                    Const Ownby :  TObject)  :  Boolean;

Var
  OForm    :  TObject;
  FoundOk  :  Boolean;

Begin
  OForm:=OwnBy;
  FoundOk:=BOff;


  While (OForm<>nil) and (Not FoundOk) do
  Begin
    If (OForm is TWinControl) then
    With TWinControl(OForm) do
    Begin
      FoundOk:=CheckKey(MStr,Name,Length(Mstr),BOff);

      If (Not FoundOk) then
        OForm:=Owner;
    end
    else
      OForm:=nil;
  end; {While..}

  Result:=FoundOk;



end;


{ ========= Procedure Set Coordinates of next MDI Child ======= }

Procedure MDI_SetFormCoord(Var F  :  TForm);

Var
  MDIForm  :  TForm;

Begin
  MDIForm:=Application.MainForm.ActiveMDIChild;

  If (MDIForm<>nil)  then
  With MDIForm do
  Begin
    If (Not CheckKey('ObjectThread',Caption,12,BOff))
      and (Not CheckKey('ObjectPrice',Caption,11,BOff))
      and (Not CheckKey('ObjectCredit',Caption,12,BOff))
      and (Not CheckKey('ObjectStock',Caption,11,BOff))
      and (WindowState=wsNormal) then
    Begin
      F.Left:=Left+20;
      F.Top:=Top+20;
    end
    else
    Begin
      F.Left:=1;
      F.Top:=1;
    end;
  end
  else
  Begin
    F.Left:=1;
    F.Top:=1;
  end;
end;


{ ========= Procedure to Tell Parent to update Staus display ======= }

Procedure MDI_UpdateParentStat;

Begin
  If (Assigned(Application.MainForm)) then
    PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,0,0);

end;

{ ========= Procedure to Tell Parent to update background ======= }

Procedure MDI_UpdateParentBkGnd(WholeScreen  :  Boolean);
Var
  MForm  :  TForm;

Begin
  {$IFDEF XEX32}
  {* Not used anymore, as realize pallete works better in EParent U *}

  If (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then
  Begin
    MForm:=TForm.Create(Application.MainForm);
    try
      With MForm do
      Begin
        If (WholeScreen) then
        Begin
          {FormStyle:=fsMDIChild;}
          Top:=1;
          Left:=1;
          Height:=Application.MainForm.ClientHeight+75;
          Width:=Application.MainForm.ClientWidth;
        end
        else
        Begin
          Top:=Application.MainForm.ClientHeight-10;
          Height:=1;
          Width:=1;
        end;

        BorderStyle:=bsNone;
        BorderIcons:=[];
        Show;
      end;
    finally
      Mform.Free;
    end;
  end;

  {$ENDIF}

end;

Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);
Var
  MForm  :  TForm;

Begin

  {$B-}

  If (Assigned(Application.MainForm)) and (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then

  {$B+}

  Begin
    MForm:=TForm.Create(Application.MainForm);
    try
      With MForm do
      Begin
        If (WholeScreen) then
        Begin
          {FormStyle:=fsMDIChild;}
          Top:=1;
          Left:=1;
          Height:=Application.MainForm.ClientHeight+75;
          Width:=Application.MainForm.ClientWidth;
        end
        else
        Begin
          Top:=Application.MainForm.ClientHeight-10;
          Height:=1;
          Width:=1;
        end;

        BorderStyle:=bsNone;
        BorderIcons:=[];
        Show;
      end;
    finally
      Mform.Free;
    end;
  end;

end;

Function GetMaxColors(Handle  :  HDC)  :  Integer;

Var
  TInt  :  Integer;

Begin

  TInt:=GetDeviceCaps(Handle,BITSPIXEL);

  Case TInt of

    4  :  Result:=0;
    8  :  Result:=1;
    16..256
       :  Result:=2;
    else  Result:=0;

  end;

end;


Procedure GenCanCloseAll(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow,
                      CheckChild
                               :  Boolean);

Var
  n  :  Integer;


Begin

  If (CanClose) then
  With PForm do
    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TForm) then
        With TForm(Components[n]) do
        Begin
          {$B-}
          If (CheckChild) and (n<PForm.ComponentCount) and (Assigned(TForm(PForm.Components[n]))) then
          {$B+}
          Begin
            GenCanCloseAll(TForm(PForm.Components[n]),nil,CanClose,UseShow,CheckChild);

            If (Not CanClose) then
              Break;
          end;

          If (Assigned(OnCloseQuery)) and (CanClose) then
            OnCloseQuery(Sender,CanClose);

          If (Not CanClose) then
          Begin
            If (UseShow) then
              Show;
            Break;
          end;

          
        end; {Loop..}
end;

Procedure GenCanClose(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow  :  Boolean);



Begin
  GenCanCloseAll(PForm,Sender,CanClose,UseShow,BOff);

end;


Procedure GenForceClose(PForm    :  TForm;
                        Sender   :  TObject;
                    Var CanClose :  Boolean);

Var
  n  :  Integer;


Begin

  If (CanClose) then
  With PForm do
    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TForm) then
        With TForm(Components[n]) do
        Begin
          If (Assigned(OnCloseQuery)) then
            OnCloseQuery(Sender,CanClose);

          If (CanClose) then
          Begin
            Close;
          end;
        end;

end;

Function GenCheck_InPrint  :  Boolean;

Begin
  Result:=BOff;

  If (DefPrintLock) and (InPrint) then
    ShowMessage('This form cannot be closed until printing has finished.')
  else
    Result:=BOn;
end;


Function NextTCtrl(PC  :  TObject;
                   TN  :  Integer)  :  TWinControl;

Var
  n  :  Integer;

Begin
  Result:=nil;

  If (PC is TWinControl) then
  With TWinControl(PC) do
  Begin
    For n:=0 to Pred(ControlCount) do
    Begin
      If (Controls[n] is TWinControl) then
      Begin
        If (TWinControl(Controls[n]).TabOrder=TN) then
        Begin
          Result:=TWinControl(Controls[n]);
          break;
        end;
      end;
    end;
  end;
end;


procedure SetNextLine(FP,TC,LC,PC
                                 :  TObject;
                      Var Key    :  Char);

Var
  wp,
  wc  :  Integer;
  lw  :  Str255;

  TmpT:  String;


  NC  :  TWinControl;
  TxC :  Text8pt;

Begin
  If (Key In [#32..#126]) then
  Begin
    If (TC<>LC) and (TC is Text8Pt) and (Key<>#32) then
    With Text8Pt(TC) do
    Begin
      wc:=WordCnt(Text);
      lw:=ExtractWords(wc,1,Text);

      wp:=PosWord(wc,Text);

      TmpT:=Text;

      Delete(TmpT,wp,Succ(Length(Text)-wp));

      Text:=TmpT;

      NC:=NextTCtrl(PC,Succ(TabOrder));

      If (Assigned(NC)) and (NC is Text8Pt) then
      Begin
        TxC:=Text8pt(NC);

        TxC.Text:=lw+Key;

        If (TxC.CanFocus) then
          TxC.SetFocus;

        TxC.SelStart:=Succ(Length(TxC.Text));
        TxC.SelLength:=1;

        Key:=#0;
      end
      else
        PostMessage(TWinControl(FP).Handle,wm_NextDlgCtl,0,0);
    end
    else
      PostMessage(TWinControl(FP).Handle,wm_NextDlgCtl,0,0);

  end;
end;


{ ==== Function to determine if Winnt(3) <4 is running ==== }

Function IS_WinNT  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT) And
            (OSVerIRec.dwMajorVersion<4);

    {* Could check whick version ie NT 4.0 maynot have these problems *}
  end;
end;

Function IS_AnyWinNT  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT);

    {* Could check whick version ie NT 4.0 maynot have these problems *}
  end;
end;


{ ==== Function to determine if Winnt is running ==== }

Function IS_WinNT4  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT) And
            (OSVerIRec.dwMajorVersion=4);

  end;
end;


{ ==== Function to determine if Winnt is running ==== }

Function IS_WinNT5  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT) And
            (OSVerIRec.dwMajorVersion=5);

  end;
end;

function GetWindowsVersion : TWindowsVersion;
// Wraps the Windows API call : GetVersionEx
// Returns the version of Windows that you are running
var
  OSVerIRec : TOSVersionInfo;
begin
  Result := wvUnknown;
  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  GetVersionEx(OSVerIRec);
  case OSVerIRec.dwPlatformId of
    VER_PLATFORM_WIN32s : Result := wv31;

    VER_PLATFORM_WIN32_WINDOWS : begin
      case OSVerIRec.dwMinorVersion of
        0 : Result := wv95;
        10 : Result := wv98;
      end;{case}
    end;

    VER_PLATFORM_WIN32_NT : begin
      Result := wvNTOther;
      case OSVerIRec.dwMajorVersion of
        3 : Result := wvNT3;
        4 : Result := wvNT4;
        5 : begin
          case OSVerIRec.dwMinorVersion of
            0 : Result := wv2000;
            1 : Result := wvXP;
          end;{case}
        end;
      end;{case}

      
    end;
  end;{case}
end;


{Function to check for XP}

Function IS_WINXP  :  Boolean;

Var
  wv  :  TWindowsVersion;

Begin
  wv:=GetWindowsVersion;

  Result:=(wv=wvXP) or (wv=wvxpTerminalServer);

end;

{Function to check for XP style}

Function IS_WINXPStyle  :  Boolean;

Var
  wv  :  TWindowsVersion;

Begin
  wv:=GetWindowsVersion;

  Result:=wv In wvXPStyle; 

  {Result:=Is_WInXP;}

end;



{ ==== Function to determine if Winnt is running ====

Function IS_WinNT  :  Boolean;


Var
  CReg  :  TRegistry;


Begin
  Result:=BOff;

  CReg:=TRegistry.Create;

  try
    With CReg do
    Begin
      RootKey:=HKEY_LOCAL_MACHINE;

      Result:=KeyExists('SOFTWARE\Microsoft\Windows NT');

    end;

  finally
    CReg.Free;

  end;

end;}

Procedure Get_NonClientInfo;

Var
  NCMetrics  :  PNonClientMetrics;
  SBW,SBH    :  Integer;


Begin
  New(NCMetrics);

  FillChar(NCMetrics^,Sizeof(NCMetrics^),0);

  NCMetrics^.cbSize:=Sizeof(NCMetrics^);

  If (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,NCMETRICS,0)) then
  Begin
    Move(NCMetrics^.iScrollWidth,SBW,Sizeof(SBW));
    Move(NCMetrics^.iScrollHeight,SBH,Sizeof(SBH));

    SBW:=16;
    SBH:=16;

    Move(SBW,NCMetrics^.iScrollWidth,Sizeof(SBW));
    Move(SBH,NCMetrics^.iScrollHeight,Sizeof(SBH));

    If (SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0)) then;
  end;

  Dispose(NCMetrics);

end;

{$IFDEF MC_On}
  Function Set_EuroVer  :  Str255;

  Var
    n  :  Integer;
  Begin
    Result:=Ver;

    If (EuroVers) then
    Begin
      n:=Pos('MC',Ver);

      If (n<>0) then
        Result:=Copy(Ver,1,Pred(n))+'EC'+Copy(Ver,n+2,Length(Ver)-n+1);
    end;

  end;

{$ENDIF}

  { === Procedure to add GCur pages and EDI VAT and General comms page === }

  Procedure Check430Sys;


  Const
    SysChk  :  Array[0..1] of SysrecTypes = ({CUR2,CUR3,GCU2,GCU3,GCUR,EDI1R,EDI2R,EDI3R,}CstmFR,CstmFR2);

  Var
    c,cs,n,m
            :  Byte;
    LOk,
    Locked  :  Boolean;

    SysCount:  SysrecTypes;

  Begin

    For n:=Low(SysChk) to High(SysChk) do
    Begin
      SysCount:=SysChk[n];

      Locked:=BOff;

      LOk:=GetMultiSys(BOff,Locked,SysCount);

      If (Not LOk) then
      Begin
        Case SysCount of

          GCUR,
          GCU2,
          GCU3  :  With SyssGCur1P^,GhostRates do
                   Begin

                     FillChar(SyssGCur1P^,Sizeof(SyssGCur1P^),0);

                     IDCode:=SysNames[SysCount];

                     Move(SyssGCur1P^,Syss,Sizeof(SyssGCur1P^));


                   end;

          CUR2,
          CUR3  :  With SyssCurr1P^ do
                   Begin

                     FillChar(SyssCurr1P^,Sizeof(SyssCurr1P^),0);

                     IDCode:=SysNames[SysCount];

                     Move(SyssCurr1P^,Syss,Sizeof(SyssCurr1P^));


                   end;

          EDI1R,
          EDI2R,
          EDI3R :  With SyssEDI1^ do
                   Begin
                     FillChar(SyssEDI1^,Sizeof(SyssEDI1^),0);

                     IDCode:=SysNames[SysCount];

                     Move(SyssEDI1^,Syss,Sizeof(SyssEdI1^));

                   end;

         { CstmFR,
          CstmFR2: With SyssCstm^,CustomSettings do
                   Begin
                     FillChar(SyssCstm^,Sizeof(SyssCstm^),0);

                     IDCode:=SysNames[SysCount];

                     If (SysCount=CstmFR) then
                     Begin
                       {Remaining two JC fields}
                //       fCaptions[1]:='User Def 3';
                  //     fCaptions[2]:='User Def 4';
                    //   cs:=3;
                 {    end
                     else
                       cs:=1;

                     m:=1;

                     For c:=cs to High(CustomSettings.fCaptions) do
                     Begin
                       fCaptions[c]:='User Def '+Form_Int(m,0);

                       Inc(m);

                       If (m>4) then
                         m:=1;
                     end;

                     Move(SyssCstm^,Syss,Sizeof(SyssCstm^));

                   end;  }


        end; {Case..}

        Status:=Add_Rec(F[SysF],SysF,RecPtr[SysF]^,0);

        Report_BError(SysF,Status);

      end;

    end;

  end;


  { === Procedure to add CIS page === }

  Procedure Check501Sys;


  Const
    SysChk  :  Array[0..0] of SysrecTypes = (CISR);

  Var
    c,cs,n,m
            :  Byte;
    LOk,
    Locked  :  Boolean;

    Ct      :  CISTaxType;

    SysCount:  SysrecTypes;

  Begin

    For n:=Low(SysChk) to High(SysChk) do
    Begin
      SysCount:=SysChk[n];

      Locked:=BOff;

      LOk:=GetMultiSys(BOff,Locked,SysCount);

      If (Not LOk) then
      Begin
        Case SysCount of


          CISR  :  With SyssCIS^,CISRates do
                   Begin
                     FillChar(SyssCIS^,Sizeof(SyssCIS^),#0);

                     With CISRate[Construct] do
                     Begin
                       Code:='C';
                       Desc:='Construct';
                       Rate:=0.18;

                     end;

                     With CISRate[Technical] do
                     Begin
                       Code:='T';
                       Desc:='Technical';
                       Rate:=0.18;

                     end;

                     For CT:=CISRate1 to High(CISRate) do
                     With CISRate[CT] do
                     Begin
                       Code:=Chr(49+Ord(CT)-Ord(CISRate1));
                       Desc:='Rate '+Code;
                       Rate:=0.0;
                     end;



                     CISInterval:=1;
                     CISLoaded:=BOn;
                     CISVFolio:=1;
                     CISAutoSetPr:=BOn;

                     For m:=Low(CISVouchers) to High(CISVouchers) do
                     With CISVouchers[m] do
                     Begin
                       Counter:=1;

                     end;

                     CISVouchers[4].Prefix:='T';
                     CISVouchers[5].Prefix:='C';
                     CISVouchers[6].Prefix:='G';
                     
                     IIREDIRef:='ZZZ9';
                     IVANIRId:='INLANDREVENUE';

                     CISVATCode:=VATZCode;
                     
                     IDCode:=SysNames[SysCount];

                     Move(SyssCIS^,Syss,Sizeof(SyssCIS^));

                   end;



        end; {Case..}

        Status:=Add_Rec(F[SysF],SysF,RecPtr[SysF]^,0);

        Report_BError(SysF,Status);

      end;

    end;

  end;


  { == Functions to return custom field values based on which fields == }

  Function Get_CustmFieldCaption(DataSet,AryNo  :  SmallInt)  :  String;
  var
    newIndex, category : longint;
  Begin
    newIndex := 0;
    Result:='XNANX';

    Case DataSet of
      0  : If (AryNo in [1..22]) then
             newIndex := CustomFields.GetNewFieldIndex('VAT',AryNo);
      1  : If (AryNo >= 1) and (AryNo <= 100) then
             newIndex := CustomFields.GetNewFieldIndex('Custom',AryNo);
      2  : If (AryNo >= 1) and (AryNo <= 100) then
             newIndex := CustomFields.GetNewFieldIndex('Custom2',AryNo);
    end;
    category := Trunc(newIndex / 1000);
    result := CustomFields[category, newIndex mod 1000].cfCaption;
  end;

  Function Get_CustmFieldHide(DataSet,AryNo  :  SmallInt)  :  Boolean;
   var
    newIndex, category : longint;
  Begin
    Result:=BOff;

    Case DataSet of
      0 : begin
            if(AryNo in [0..6]) then
              Result := CustomFields.GetFieldEnabled('HideLType', AryNo)
            else
              Result := CustomFields.GetFieldEnabled('HideUDF', AryNo);
          end;
      1 : if(AryNo >= 3) and (AryNo <= 50) then
            Result := CustomFields.GetFieldEnabled('Custom', AryNo);
      2 : if(AryNo >= 1) and (AryNo <= 40) then
            Result := CustomFields.GetFieldEnabled('Custom2', AryNo);
    end;
  end;


  Procedure Check560Num;


  Const
   Fnum1  =  IncF;
   KPath1 =  IncK;

   JAPCounters  :  Array[1..5] of Str5  = ('JCT','JST','JPT','JSA','JPA');

  Var
    PrimeCount :  LongInt;


    KeyP,KeyI  :  Str255;

    TBo        :  Boolean;

    n          :  Byte;


  Begin


    With Count do
    {= Add in JAP Counters =}
    Begin
      PrimeCount:=1;


      For n:=Low(JAPCounters) to High(JAPCounters) do
      Begin
        KeyI:=JAPCounters[n];


        Status:=Find_Rec(B_GetEq,F[Fnum1],Fnum1,RecPtr[Fnum1]^,0,KeyI);

        If (Status<>0) then
        Begin

          FillChar(Count,Sizeof(Count),0);
          Move(PrimeCount,NextCount[1],Sizeof(PrimeCount));

          CountTyp:=JAPCounters[n];

          Status:=Add_Rec(F[Fnum1],Fnum1,RecPtr[Fnum1]^,0);

          Report_BError(SysF,Status);
        end;
      end;

    end;

  end; {Check560Num..}




Procedure BtSupU2_Init;
Var
  Open : Boolean;
Begin
  Open := True;

  STDStkTList:=Nil;
  STDValList:=Nil;
  STDVATList:=Nil;
  STDDocTList:=Nil;
  STDQtyBList:=Nil;
  STDNomTList:=Nil;
  STDCurrList:=Nil;


  {$IFDEF OLE}
    { Check we're not registering an ole server }
    If (ParamCount > 0) Then
      Open := (UpperCase (ParamStr(1)) <> '/REGSERVER') And
              (UpperCase (ParamStr(1)) <> '/UNREGSERVER');
  {$ENDIF}

  {$IFDEF COMP}
    Open := False;
  {$ENDIF}

  If Open Then
  Begin
    Check430Sys;

    Check501Sys;

    Check560Num;

    Init_AllSys;

    Init_STDVATList;
    Init_STDCurrList;


    Init_STDDocTList;

    Init_STDNomTList;

    {$IFDEF STK}
      Init_STDStkTList;
      Init_STDValList;
      Init_STDQBList;
    {$ENDIF}


    { ========= Force GotPassword if SBSIN or No Passwords used ======== }

    If (Not GotPassword) then
      GotPassword:=((SBSIn) or (Not Syss.UsePasswords));

  End; { If }
End;


Procedure BtSupU2_Destroy;
Begin
  If (Assigned(STDStkTList)) then
  Begin
    STDStkTList.Free;
    STDStkTList:=Nil;
  end;

  If (Assigned(STDValList)) then
  Begin
    STDValList.Free;
    STDValList:=Nil;
  end;


  If (Assigned(STDVATList)) then
  Begin
    STDVATList.Free;
    STDVATList:=Nil;
  end;

  If (Assigned(STDDocTList)) then
  Begin
    STDDocTList.Free;
    STDDocTList:=Nil;
  end;

  If (Assigned(STDQtyBList)) then
  Begin
    STDQtyBList.Free;
    STDQtyBList:=Nil;
  end;

  If (Assigned(STDNomTList)) then
  Begin
    STDNomTList.Free;
    STDNomTList:=Nil;
  end;

  If (Assigned(STDCurrList)) then
  Begin
    STDCurrList.Free;
    STDCurrList:=Nil;
  end;

  {$IFDEF JC}
    If (Assigned(STDVATList)) then
    Begin
      STDCISList.Free;
      STDCISList:=Nil;
    end;
  {$ENDIF}

end;



function WinGetUserName : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
  lpBuffer : Array [0..255] of Char;
  nSize : DWORD;
begin
  nSize := SizeOf(lpBuffer) - 1;
  if GetUserName(lpBuffer, nSize) then Result := lpBuffer
  else Result := 'User';
end;


Initialization
  ISWINNT:=IS_WinNT;
  ISAnyWINNT:=IS_AnyWINNT;
  ISWINNT4:=IS_WinNT4;
  ISWINNT5:=IS_WinNT5;
  IsWINXP:=Is_WINXP;

  {$IFNDEF ENSECR}
    // HM 07/06/02: Modified to remove check for .manifest file 
    //IsWINXPTheme:=XP_UsingThemes(BOn);
    IsWINXPTheme:=XP_UsingThemes(BOff);
  {$ELSE}
    IsWINXPTheme:=BOff;
  {$ENDIF}

  {$IFNDEF EXDLL}  {* for ToolKit DLL 29.08.97 *}
  {$IFNDEF EDLL}
    {$IFNDEF COMP}
      {$IFNDEF OLE}
        {$IFNDEF EBUS}
          {$IFNDEF TRADE}
            {$IFNDEF ENSECR}
              {$IFNDEF SENT}  // HM 27/02/02: Removed for Sentimail on behalf of PR
                {$IFNDEF SCHEDULER}
                BtSupU2_Init;
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}

Finalization

  {$IFNDEF EXDLL}  {* for ToolKit DLL 29.08.97 *}
  {$IFNDEF EDLL}
    {$IFNDEF COMP}
      {$IFNDEF OLE}
        {$IFNDEF EBUS}
          {$IFNDEF TRADE}
            {$IFNDEF ENSECR}
              {$IFNDEF SENT}  // HM 27/02/02: Removed for Sentimail on behalf of PR
                {$IFNDEF SCHEDULER}
                BtSupU2_Destroy;
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}


end.
