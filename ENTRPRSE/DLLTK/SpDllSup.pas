unit spdllsup;
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  VarConst, GlobVar, Classes;



  Procedure Calc_StockDeduct(InvFolio       :  LongInt;
                             CheckSOP       :  Boolean;
                             Mode           :  Byte;
                             LInv           :  InvRec;
                             ShowHLines     :  Boolean);

  Function FormatCurFloat(Fmask  :  Str255;
                          Value  :  Double;
                          SBlnk  :  Boolean;
                          Cr     :  Byte)  :  Str255;

  procedure AddToB2BList(const s : string);
  function B2BListCount : longint;
  procedure SetB2BReturn(P : Pointer; var PSize : LongInt);
  function ReverseDoc(ThisDoc : DocTypes) : DocTypes;

  var
    B2BList : TStringList;


implementation


uses
  InvCtSuU, BtKeys1U, BtrvU2, BtSupU1, EtStrU, SysUtils, CurrncyU, VarCnst3;

Const

  BOn = True;
  BOff = False;

  NoOfContras =  14;

  ConvTable  :  Array[1..2,1..NoOfContras] of DocTypes =

                ((SIN,SRC,SRI,SJI,SQU,SOR,SDN,PIN,PPY,PPI,PJI,POR,PDN,NMT),
                 (SCR,SRC,SRF,SJC,SQU,SOR,SDN,PCR,PPY,PRF,PJC,POR,PDN,NMT));



  Procedure Calc_StockDeduct(InvFolio       :  LongInt;
                             CheckSOP       :  Boolean;
                             Mode           :  Byte;
                             LInv           :  InvRec;
                             ShowHLines     :  Boolean);


  Const
    Fnum      =  IDetailF;
    Keypath   =  IDFolioK;


  Var
    KeyS,
    KeyChk    :  String[255];

    StkFolio,
    RecAddr   :  LongInt;

    dNum      : Double;

  Begin
    StkFolio:=0;

    dNum := 0.0;

    KeyS:=FullIdkey(InvFolio,StkLineNo);  {* Remove any existing lines *}

    {$IFDEF SOP}
      If (ShowHLines) then
        Set_HiddenSer(LInv,17);
    {$ENDIF}

    Delete_StockLinks(KeyS,IdetailF,Length(KeyS),IdFolioK,BOn,LInv,0);

    KeyChk:=FullNomKey(InvFolio);

    KeyS:=FullIdkey(InvFolio,0);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin

      If (Not EmptyKey(StockCode,StkKeyLen)) then   {* Deduct Lower Levels *}
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        {$IFDEF SOP}
          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);

          StkFolio:=Stock.StockFolio;

        {$ENDIF}

        Gen_StockDeduct(Id,LInv,0,Mode,dNum,StkFolio,Id.ABSLineNo);

        SetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      end;


      {$IFDEF SOP}
        If (CheckSOP) then
          Update_SOPLink(Id,BOff,BOn,BOff,Fnum,IdLinkK,Keypath);
      {$ENDIF}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    {$IFDEF SOP}
      If (ShowHLines) then
      Begin
        Set_HiddenSer(LInv,18);

        {If (Not (LInv.InvDocHed In OrderSet)) then v4.32, extended to cope with SOR's}
          RetroSNBOM(LInv,Fnum,Keypath,InvF,InvFolioK);
      end;
    {$ENDIF}
  end; {Proc..}

Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;


Var
  GenStr  :  Str5;

Begin
  GenStr:='';

  {$IFDEF MC_On}

    GenStr:=SSymb(Cr);

  {$ENDIF}

  If (Value<>0.0) or (Not SBlnk) then
    Result:=GenStr+FormatFloat(Fmask,Value)
  else
    Result:='';

end;

procedure AddToB2BList(const s : string);
begin
  B2BList.Add(s);
end;

function B2BListCount : longint;
begin
  Result := B2BList.Count;
end;

procedure SetB2BReturn(P : Pointer; var PSize : LongInt);
var
  i : longint;
  s : shortString;
  TH : TBatchTHRec;
  OurRefSize : SmallInt;
begin
  OurRefSize := SizeOf(TH.OurRef) - 1;
  for i := 0 to B2BList.Count - 1 do
  begin
    if i < PSize then
    begin
      s := B2BList[i] + StringOfChar(#0, OurRefSize);
      Move(s[1], Pointer(longint(P) + (i * OurRefSize))^, OurRefSize);
    end;
  end;
  PSize := B2BList.Count;
end;

function ReverseDoc(ThisDoc : DocTypes) : DocTypes;
var
  i : integer;
begin
  Result := ThisDoc;
  for i := 1 to NoOfContras do
    if ConvTable[1, i] = ThisDoc then
    begin
      Result := ConvTable[2, i];
      Break;
    end
    else
    if ConvTable[2, i] = ThisDoc then
    begin
      Result := ConvTable[1, i];
      Break;
    end;
end;


end.
