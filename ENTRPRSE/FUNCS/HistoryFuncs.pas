unit HistoryFuncs;
//PR: 17/02/2014 ABSEXCH-14477 Moved Chage_Hist proc here from StockU.pas to allow use by COM Toolkit
interface

Procedure Change_Hist(OldTyp,NewTyp  :  Char;
                      SFolio         :  LongInt);

implementation

uses
  BtrvU2, VarConst, BtKeys1U, GlobVar, BtSupU1;


Procedure Change_Hist(OldTyp,NewTyp  :  Char;
                      SFolio         :  LongInt);


Const
  Fnum    =  NHistF;

  Keypath =  NHk;


Var

  KeyChk,
  KeyS    :  Str255;

  NeedYTD,
  Loop,
  UOk,
  Locked  :  Boolean;

  LRecAddr
          :  LongInt;

  LastCr,
  LastYr  :  Byte;

  TPurch,
  TSales,
  TCleared
          :  Real;

  LastNHist
          :  HistoryRec;


Begin

  Loop:=BOff;  LastCr:=0; LastYr:=0; NeedYTD:=BOff;

  TPurch:=0.0; TSales:=0.0; TCleared:=0.0;


  Repeat
    UOk:=BOff; Locked:=BOff;

    If (Loop) then {* Change Stk loc hist as well *}
      KeyChk:=OldTyp+'L'+FullNomKey(SFolio)
    else
    Begin
      KeyChk:=PartNHistKey(OldTyp,FullNomKey(SFolio),0);
      KeyChk:=Copy(KeyChk,1,Pred(Length(KeyChk)));  {* Search for all matches ignoring currency *}
    end;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    With NHist do
    Begin
      LastCr:=Cr;
      LastYr:=Yr;
      LastNHist:=NHist;
    end;


    While (StatusOk) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    With NHist do
    Begin
      If (NewTyp In YTDSet) then
      Begin
        If (LastCr<>Cr) or (LastYr<>Yr) then
        Begin
          LastCr:=Cr;

          LastYr:=Yr;

          If (NeedYTD) then
          Begin
            Status:=GetPos(F[Fnum],Fnum,LRecAddr);

            NHist:=LastNHist;
            Pr:=YTD;
            Purchases:=TPurch;
            Sales:=TSales;
            Cleared:=TCleared;

            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,Status);

            SetDataRecOfs(Fnum,LRecAddr);

            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}

          end;

          TPurch:=0.0;
          TSales:=0.0;
          TCleared:=0.0;

        end
        else
        Begin
          TPurch:=TPurch+Purchases;
          TSales:=TSales+Sales;

          TCleared:=TCleared+Cleared;

        end;


      end;

      NeedYTD:=(Pr<>YTD);

      UOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOn,Locked,LRecAddr);

      If (UOk) and (Locked) then
      Begin

        ExClass:=NewTyp;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LRecAddr);
      end; {If Locked Ok..}

      If (StatusOk) then
        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end; {While..}
    Loop:=Not Loop;

  Until (Not Loop);
end; {Proc..}


end.
 