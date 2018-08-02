Unit RepLSP3U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 30/09/94                      }
{                                                              }
{                 Rep Gen Misc Line Support Unit               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses SysUtils,
     GlobVar,
     VarConst,
     RwOpenF;



Procedure RepGen_Renumber(Var  Rep2Copy  :  RepGenRec;
                               StartNo,
                               NewNo     :  LongInt;
                               FChar     :  Char;
                          Var  TOnly     :  Boolean);

Procedure RepGen_RenumbAll(Rep2Copy  :  RepGenRec;
                           OldNum    :  Longint;
                           Fnum,
                           Keypath   :  Integer;
                           FChar     :  Char;
                           TOnly     :  Boolean);

Procedure MoveEmUp(KeyChk,
                   KeyS,
                   KeyLimit:  Str255;
                   StartNo,
                   IncBy   :  LongInt;
                   Fnum,
                   KeyPath :  Integer);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   BtrvU2,
   BtSupU1,
   BtKeys1U,
   VarFposU,
   ComnUnit,
   ComnU2,
   RpCommon,
   SysU1;


{ ============ Procedure to Insert/Delete List Lines =========== }
Procedure MoveEmUp(KeyChk,
                   KeyS,
                   KeyLimit:  Str255;
                   StartNo,
                   IncBy   :  LongInt;
                   Fnum,
                   KeyPath :  Integer);
Var
  FoundOk,
  Locked,
  Ok2Store  :  Boolean;

  TmpStat,
  TmpKPath
            :  Integer;
  RecAddr2,
  TmpRecAddr
            :  LongInt;

  UniPadNo  :  Str10;
Begin
  FoundOk:=BOff; Locked:=BOff;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  UniPadNo:='';

  Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and (KeyS>=KeyLimit) do
  Begin

    FoundOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked, RecAddr2);

    With RepGenRecs^, ReportDet do
    If (FoundOk) and (Locked) and (RepVarNo>0) then
    Begin

      RepVarNo:=RepVarNo+IncBy;

      UniPadNo:=SetPadNo(Form_Int(RepVarNo,0),VNoLen);

      ReportKey:=FullRepLineKey(RepName,VarType,UniPadNo);

      If (VarType=RepNomCode) then
        ReportNom.RepPadNo:=UniPadNo
      else
        RepPAdNo:=UniPAdNo;

      Ok2Store:=BOff;

      RepGen_Renumber(RepGenRecs^,StartNo,IncBy,VarType,Ok2Store);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      { Need to release multiple-record lock }
      Status:=UnLockMultiSing(F[Fnum],Fnum,RecAddr2);
    end;

    Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
end; {Loop..}



{ ======== Function to Renumber occurances of Field Nos ======= }

Function RenumStr(S2RN    :   Str255;
                  StartNo,
                  NewNo   :   LongInt;
                  FChar   :   Char;
                  TOnly   :   Boolean)  :  Str255;


Var
  Sl,Cp    :  Byte;

  PrevChar, NextChar    :  Char;

  TStr     :  Str255;

  ValStr   :  Str20;

  Lnum     :  LongInt;

  FoundOk  :  Boolean;



Begin

  TStr:='';

  FoundOk:=BOff;

  Sl:=Length(S2RN);

  Cp:=1;

  Lnum:=0;

  NextChar:=#0;

  While (Cp<=Sl) do
  Begin
    If (Cp > 1) then
      { Not first char }
      PrevChar := UpperCase(S2RN)[Pred(Cp)]
    else
      PrevChar := #0;

    If (Cp<>Sl) then
      NextChar := S2RN[Succ(Cp)]
    else
      NextChar := #0;

    {* Check that the next char is a field number.. *}
    { And that previous char is something consistent with field number }
    If (S2RN[Cp]=FChar) and (Not (PrevChar In ['"', 'A'..'Z', '0'..'9'])) And (NextChar In ['0'..'9']) then
    Begin

      FoundOk:=BOff;

      ValStr:='';

      Inc(Cp);

      While (Cp<=Sl) and (Not FoundOk) do
      Begin

        FoundOk:=(Not (S2RN[Cp] In ['0'..'9']));

        If (Not FoundOk) then
        Begin
          ValStr:=ValStr+S2RN[Cp];

          Inc(Cp);
        end;

      end; {While..}

      Lnum:=IntStr(ValStr);

      Case TOnly of

        BOn  :  If (Lnum=StartNo) then
                 Lnum:=NewNo;

        BOff :  If (Lnum>=StartNo) then
                 Lnum:=Lnum+1;

      end; {Case..}

      If (Valstr<>'') then
        TStr:=TStr+FChar+Form_Int(Lnum,0);

    end
    else
    Begin

      TStr:=TStr+S2RN[Cp];

      Inc(Cp);

    end;

  end; {While..}


  RenumStr:=TStr;
end;


{ ======= Proc to Renumber a Detail Record ======= }



Procedure RepGen_Renumber(Var  Rep2Copy  :  RepGenRec;
                               StartNo,
                               NewNo     :  LongInt;
                               FChar     :  Char;
                          Var  TOnly     :  Boolean);


Var
  Ok2Store  :  Boolean;
  TStr      :  Str255;

Begin

  TStr:='';

  Ok2Store:=BOff;

  With Rep2Copy do
  Begin

    If (FChar=RepNomCode) then
    With ReportNom do
    Begin
      TStr:=VarSubSplit;

      VarSubSplit:=RenumStr(TStr,StartNo,NewNo,FChar,TOnly);

      Ok2Store:=(Ok2Store or (TStr<>VarSubSplit));

    end
    else
    With ReportDet do
    Begin
      TStr:=RecSelect;

      RecSelect:=RenumStr(TStr,StartNo,NewNo,FChar,TOnly);

      Ok2Store:=(Ok2Store or (TStr<>RecSelect));

      TStr:=PrintSelect;

      PrintSelect:=RenumStr(TStr,StartNo,NewNo,FChar,TOnly);

      Ok2Store:=(Ok2Store or (TStr<>PrintSelect));

      TStr:=VarSubSplit;

      If (VarType<>RepInpCode) then
        VarSubSplit:=RenumStr(TStr,StartNo,NewNo,FChar,TOnly);

      Ok2Store:=(Ok2Store or (TStr<>VarSubSplit));

    end;


  end; {With..}

  TOnly:=Ok2Store;

end; {Proc..}



{ ====== Proc to Rnumber all lines in a report ===== }

Procedure RepGen_RenumbAll(Rep2Copy  :  RepGenRec;
                           OldNum    :  Longint;
                           Fnum,
                           Keypath   :  Integer;
                           FChar     :  Char;
                           TOnly     :  Boolean);


Var
  RecAddr2,
  RecAddr  :  LongInt;
  KeyS,
  KeyChk   :  Str255;

  Locked,
  Ok2Store :  Boolean;

  SChar    :  Char;



Begin

  Status:=GetPos(F[Fnum],Fnum,RecAddr);

  Ok2Store:=BOff;

  Report_BError(Fnum, Status);

  With Rep2Copy.ReportDet do
  Begin

    If (FChar=RepInpCode) then  {* Switch to search on report lines *}
      SChar:=RepRepCode
    else
      SChar:=FChar;

    KeyChk:=PartCCKey(ReportGenCode,SChar)+PartRepLineKey(SChar,RepName);

    KeyS:=KeyChk;

    If (FChar<>RepInpCode) then
      KeyS:=KeyS+SetPadNo(Form_Int(OldNum,0),6);

  end; {With..}


  Status:=Find_Rec(B_GetGretr,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  With RepGenRecs^.ReportDet do
  Begin

    If (VarType<>RepHedTyp) then
    Begin


      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked, RecAddr2);

      If (Ok) and (Locked) then Begin

        Ok2Store:=TOnly;

        RepGen_Renumber(RepGenRecs^,OldNum,Rep2Copy.ReportDet.RepVarNo,FChar,Ok2Store);

        If (Ok2Store) then
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum, Status);

        { Need to release multiple-record lock }
        Status:=UnLockMultiSing(F[Fnum],Fnum,RecAddr2);
      end; {If locked..}

    end; {If Right type}

    Status:=Find_Rec(B_GetNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

  end; {While..}

  SetDataRecOfs(Fnum,RecAddr);

  Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}
end; {Proc..}



end. {Unit..}