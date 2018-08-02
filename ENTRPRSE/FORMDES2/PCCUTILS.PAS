unit PCCUtils;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst, BtrvU2;


{ Copied from DefSup4U }
Procedure Def_BuildPMode(    Mode     : Byte;
                         Var DMode    : Byte;
                         Var Fnum3,
                             Keypath3 : Integer;
                             ThisPtr  : Pointer);

{ Copied from DefSup4U }
Procedure Def_BuildPOrder(    Mode     : Byte;
                          Var DMode    : Byte;
                          Var Fnum3,
                              Keypath3 : Integer;
                              ThisPtr  : Pointer);



Var
  PrntOK  : Boolean;
  DefFVar : FileVar;

implementation

Uses BTSupU1, Scrtch1U, BTKeys1U, ComnUnit, Comnu2, InvListU, ETStrU,
     ETMiscU;


{ Proc to return Bin Loc + Stock Code Ordering }
Procedure Def_BuildPOrder(    Mode     : Byte;
                          Var DMode    : Byte;
                          Var Fnum3,
                              Keypath3 : Integer;
                              ThisPtr  : Pointer);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk   :  Str255;

  TmpId    :  IDetail;

  TmpInclude,
  FoundPick,
  FoundAny
           :  Boolean;

  TmpKPath,
  TmpStat
           :  Integer;

  LCount,
  RecAddr,
  TmpRecAddr
           :  LongInt;


  ThisScrt :  ScratchPtr;

  TmpStr
           :  Str255;


Begin

  LCount:=1;
  RecAddr:=0;

  FoundAny:=BOff;
  FoundPick:=BOff;

  TmpId:=Id;

  ThisScrt:=ThisPtr;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  TmpStr:='';

  With Inv do
  Begin

    ResetRec(StockF);

    KeyChk:=FullNomKey(FolioNum);

    KeyS:=FullIdKey(FolioNum,1);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (PrntOk) do
    With Id do
    Begin

      {Loop_CheckKey(PrntOk);}

      TmpInclude:=BOff;

      {* If desc line, or part of kit in product code order, then use last stock code details *}
      {* Otherwise find own. *}
      {* If kit must be preserved then remove second condition *}

      If ((Is_FullStkCode(StockCode)) and (KitLink=0)) or ((Is_FullStkCode(StockCode)) and (Mode=2)) then
      Begin
        If (Stock.StockCode<>StockCode) then
          GetStock(Application.MainForm,StockCode,StockCode,-1);


        If (Not FoundAny) then
          FoundAny:=BOn;
      end;

      Case DMode of  {* Any changes here must be reflected in Include -DefSup3U *}
        14  :  {* Matching picking Run, and Product type, ignore blank or desc only lines *}
               TmpInclude:=((SOPLineNo=Inv.PickRunNo) and (Stock.StockType In StkProdSet)
                           and ((Is_FullStkCode(StockCode)) or (KitLink=0)));
        else   TmpInclude:=BOn;
      end; {Case..}

      If (Not FoundPick) then
        FoundPick:=(TmpInclude and FoundAny);

      Case Mode of
        1  :  TmpStr:=FullStockCode(Stock.StockCode)+SetPadNo(Form_Int(LCount,0),6);
        2  :  TmpStr:=LJVar(Stock.BinLoc,10{Fpos[SBinNo].Len})+FullStockCode(Stock.StockCode)+
                      SetPadNo(Form_Int(LCount,0),6);
      end; {Case..}


      If (ThisScrt<>NIL) and (TmpInclude) then {* We need to add this anyway, as line had no serial numbers *}
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Get Preserve IdPosn *}

        ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,FullNomKey(FolioNum)+TmpStr,
                              '');

      end;


      Inc(LCount);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  end; {With..}


  Id:=TmpId;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  If (FoundAny) and (FoundPick) then
  Begin

    Fnum3:=ReportF;

    Keypath3:=RpK;

    DMode:=18;

  end;

end; {Proc..}


Procedure Def_BuildPMode(    Mode     : Byte;
                         Var DMode    : Byte;
                         Var Fnum3,
                             Keypath3 : Integer;
                             ThisPtr  : Pointer);
Begin
  Def_BuildPOrder(Mode,DMode,Fnum3,Keypath3,ThisPtr);
end;



Initialization
  PrntOK := True;
end.
