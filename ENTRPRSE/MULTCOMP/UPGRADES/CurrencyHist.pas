unit CurrencyHist;

//PR: 23/07/2012 ABSEXCH-12956 Function to add existing currency rates into the new currency history table on upgrade.

interface


  function AddCurrentCurrencyRatesToHistory(var ErrString : string) : Integer;

implementation

uses
  BtrvU2, VarConst, VarRec2U, Classes, CurrencyHistoryVar, CurrencyHistoryClass, GlobVar, SysUtils;

{====================================================================================}
{ Functions copied and adapted from BtSupU1.pas to avoid compiling in most of Enter1 }
{====================================================================================}

{ === Procedure to Populate Global Currency Array === }

Procedure SetCurrPage(PNo    :  Byte;
                  Var C1P    :  Curr1PRec;
                  Var GCP    :  CurrRec);


Const
  PageNos  :  Array[1..CurrencyPages] of Integer = (0,31,61);

Var
  n  :  Integer;


Begin
  For n:=0 to Currency1Page do
  If (n+PageNos[PNo]<=CurrencyType) then
  Begin
    GCP.Currencies[n+PageNos[PNo]].SSymb:=C1P.Currencies[n].Ssymb;
    GCP.Currencies[n+PageNos[PNo]].Desc:=C1P.Currencies[n].Desc;
    GCP.Currencies[n+PageNos[PNo]].CRates:=C1P.Currencies[n].CRates;
    GCP.Currencies[n+PageNos[PNo]].PSymb:=C1P.Currencies[n].PSymb;
  end; {Loop..}
end;



{ === Procedure to Populate Global Triangulation Currency Array === }

Procedure SetGCurPage(PNo    :  Byte;
                  Var C1P    :  GCur1PRec;
                  Var GCP    :  GCurRec);


Const
  PageNos  :  Array[1..CurrencyPages] of Integer = (0,31,61);

Var
  n  :  Integer;


Begin
  For n:=0 to Currency1Page do
  If (n+PageNos[PNo]<=CurrencyType) then
  Begin
    GCP.GhostRates.TriRates[n+PageNos[PNo]]:=C1P.GhostRates.TriRates[n];
    GCP.GhostRates.TriEuro[n+PageNos[PNo]]:=C1P.GhostRates.TriEuro[n];
    GCP.GhostRates.TriInvert[n+PageNos[PNo]]:=C1P.GhostRates.TriInvert[n];
    GCP.GhostRates.TriFloat[n+PageNos[PNo]]:=C1P.GhostRates.TriFloat[n];
  end; {Loop..}
end;

Function GetMultiSys(SysMode :  SysRecTypes)  :  Boolean;

Var
  TempSys  :  Sysrec;
  Key2F    :  Str255;
  LStatus  :  SmallInt;


Begin

  TempSys:=Syss;

  Key2F:=SysNames[SysMode];

  Result:=BOff;

  LStatus:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

  Result:=(LStatus=0);

  If (Result)  then
  Begin
    Case SysMode of
      CurR,
      CuR2,
      CuR3  :  Begin
                 Move(Syss,SyssCurr1P^,Sizeof(SyssCurr1P^));

                 SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr);

               end;



      GCuR,
      GCU2,
      GCU3  :  Begin

                 Move(Syss,SyssGCur1P^,Sizeof(SyssGCur1P^));

                 SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                             SyssGCuR1P^,
                             SyssGCuR^);

               end;

    end; //case

  end; //if Result;
end;

Function GetMultiSysCur  :  Boolean;


Var
  N        :  SysRecTypes;

Begin

  Result:=BOn;

  For n:=CurR to Cur3 do
  Begin
    If (Result) then
      Result:=GetMultiSys(N);
  end;

end;

Function GetMultiSysGCur  :  Boolean;

Var
  N        :  SysRecTypes;
Begin
  Result:=BOn;

  For n:=GCUR to GCU3 do
  Begin
    If (Result) then
      Result:=GetMultiSys(N);
  end;

end;

{====================================================================================}
{ End of copied functions                                                            }
{====================================================================================}


function AddCurrentCurrencyRatesToHistory(var ErrString : string) : Integer;
var
  Res : integer;
  CurrNo   : integer;
  CurrencyHistoryObj : TCurrencyHistory;
  sKey : Str255;
  SysLocked : Boolean;
  SysType : SysRecTypes;

  function NeedToUpgrade : Boolean;
  begin
    //If we have any records in the currency history table, then
    //we've already done the upgrade so don't need to do it again.
    Res := CurrencyHistoryObj.FindRec(B_GetFirst, sKey);
    Result := Res <> 0;
  end;

begin

  Result := 0;
  CurrencyHistoryObj := TCurrencyHistory.Create;
  Try
    Open_System(CurrencyHistoryF, CurrencyHistoryF);

    //Check if we need to do anything
    if NeedToUpgrade then
    begin

      Open_System(SysF, SysF);

      //Get currency and ghost currency arrays.
      if GetMultiSysCur and GetMultiSysGCur then
      begin

        //iterate through currencies checking for any that have been used (ie their description has been populated.
        for CurrNo := 1 to CurrencyType do
        begin
          if Trim(SyssCurr.Currencies[CurrNo].Desc) <> '' then
          begin //Found one - add initial history record.
            CurrencyHistoryObj.SetDataRec(SyssCurr.Currencies, SyssGCur^.GhostRates, CurrNo);
            Result := CurrencyHistoryObj.Save;
            if Result <> 0 then
            begin
              ErrString := 'Error ' + IntToStr(Result) + ' occurred when adding a record for ' +
                       Trim(CurrencyHistoryObj.chDescription) + ' to the Currency History table.';

              Break;
            end
          end;
        end;
      end
      else
      begin
        ErrString := 'It was not possible to read the currency values.';
        Result := -1;
      end;
    end;
  Finally
    CurrencyHistoryObj.Free;
    Close_Files(True);
  End;
end;

end.
