unit MLocFunc;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst{,
  VarCnst3};


  Function TK_GetMLoc (Var LocCode : ShortString) : Boolean;

  Procedure Stock_LocPSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);

  Procedure Stock_LocROCPSubst(Var StockR  :  StockRec;
                                   Lc      :  Str10);

  Procedure Stock_LocNSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);

  Procedure Stock_LocCCDSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10);

  Procedure Stock_LocCSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);
  //PR: 18/03/2009 Added these 7 functions to interface to match 600.003
  Function LocOverride(lc    :  Str10;
                       Mode  :  Byte)  :  Boolean;

  Function LocOPrice(lc  :  Str10)  :  Boolean;

  Function LocONom(lc  :  Str10)  :  Boolean;

  Function LocOCCDep(lc  :  Str10)  :  Boolean;

  Function LocOCPrice(lc  :  Str10)  :  Boolean;

  Function LocOSupp(lc  :  Str10)  :  Boolean;

  Procedure Stock_LocLinkSubst(Var StockR  :  StockRec;
                                   Lc      :  Str10);

  //PR: 18/03/2009 Added for InLocation ADJ changes
  Function LinkMLoc_Loc(lc  :  Str10;
                    Var TSL :  MLocLocType)  :  Boolean;

  //PR: 18/03/2009 Added to interface for InLocation ADJ changes
  Function LinkMLoc_Stock(lc  :  Str10;
                          sc  :  Str20;
                      Var TSL :  MStkLocType)  :  Boolean;




implementation

Uses
  SysUtils, BtrvU2, BTSupU1, BTKeys1U, ETStrU, SQLUtils;


  { ======= Return Full MLoc Key ======== }
  Function Full_MLocKey(lc  :  Str10)  :  Str10;
  Begin
    Full_MLocKey:=LJVar(LC,MLocKeyLen);
  end;

  { ======= Return Full Stk MLoc Key ======== }
  Function Full_MLocLKey(lc  :  Str10;
                         sc  :  Str20)  :  Str30;
  Begin
    Full_MLocLKey:=Full_MLocKey(lc)+FullStockCode(sc);
  end;


  Function TK_GetMLoc (Var LocCode : ShortString) : Boolean;
  Begin { GetMLoc }
    {$IFDEF EXSQL}
      if UsingSQL then
        UseVariantForNextCall(F[MLocF]);
    {$ENDIF}
    Result := Global_GetMainRec(MLocF, CostCCode + CSubCode[True] + Full_MLocKey(LocCode));
  End; { GetMLoc }

  Function LocOverride(lc    :  Str10;
                       Mode  :  Byte)  :  Boolean;
  Const
    Fnum  =  MLocF;
  Var
    TmpLoc     : MLocPtr;
    LOk        : Boolean;
    TmpKPath,
    TmpStat    : Integer;
    TmpRecAddr : LongInt;
  Begin
    Result:=BOff;

    New(TmpLoc);

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    TmpLoc^:=MLocCtrl^;

    {LOk:=GetMLoc(Application.MainForm,lc,lc,'',-1);}
    LOk:=TK_GetMLoc(lc);

    With MLocCtrl^.MLocLoc do
      Case Mode of
        0  :  Result:=loUsePrice;
        1  :  Result:=loUseNom;
        2  :  Result:=loUseCCDep;
        3  :  Result:=loUseSupp;
        4  :  Result:={loUseBinLoc;}BOn;
        5  :  Result:=loUseCPrice;
        6  :  Result:=loUseRPrice;
      end; {Case..}

    Result:=(LOk and Result);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpLoc^;

    Dispose(TmpLoc);
  end;


 { =========== Proc to return linked stock record ======== }
 { Duplicated in ExBtTh1U, TdexPost}

  Function LinkMLoc_Stock(lc  :  Str10;
                          sc  :  Str20;
                      Var TSL :  MStkLocType)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLSecK;

  Var
    KeyS,
    KeyChk     :  Str255;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;
    TmpMLoc    :  MLocRec;


  Begin
    TmpMLoc:=MLocCtrl^;

    Blank(TSL,Sizeof(TSL));

    Result:=BOff;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(lc,sc);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    {$IFDEF EXSQL}
      if UsingSQL then
        UseVariantForNextCall(F[MLocF]);
    {$ENDIF}
    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    Begin
      Result:=BOn;
      TSL:=MLocCtrl^.MStkLoc;
    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpMLoc;


  end;


 { ==== Procedure to Substitute Stock levels for location levels ==== }
 { Duplicated in ExBtTh1U, TdexPost}
 Procedure Stock_LocFullSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10;
                                  Mode    :  Byte);
 Var
   TSL     :  MStkLocType;
   n       :  Byte;
   FoundOk :  Boolean;



 Begin
   If (Syss.UseMLoc) and (Not EmptyKey(lc,MLocKeyLen)) and (Not EmptyKey(StockR.StockCode,StkKeyLen)) then
   With StockR,TSL do
   Begin

     FoundOk:=LinkMLoc_Stock(Lc,StockCode,TSL);


     Case Mode of
       0  :  Begin
               QtyInStock:=lsQtyInStock;
               QtyAllocated:=lsQtyAlloc;
               QtyOnOrder:=lsQtyOnOrder;
               QtyPosted:=lsQtyPosted;
               QtyPicked:=lsQtyPicked;
             end;
       1  :  Begin
               {If (lsQtyMin<>0) then}
                 QtyMin:=lsQtyMin;

               {If (lsQtyMax<>0) then}
                 QtyMax:=lsQtyMax;

               MinFlg:=lsMinFlg;
               ROQty:=lsRoQty;
               RODate:=lsRODate;
               ROCCDep:=lsROCCDep;

               If LocOverride(lc,6) then
               Begin
                 ROCPrice:=lsROPrice;
                 ROCurrency:=lsROCurrency;
               end;

               ROFlg:=lsROFlg;
             end;
       2  :  Begin
               QtyTake:=lsQtyTake;

               QtyFreeze:=lsQtyFreeze;
               StkFlg:=lsStkFlg;
             end;

       3  :  If FoundOk and LocOverride(lc,0) then
               SaleBands:=lsSaleBands;

       4  :  If FoundOk and LocOverride(lc,1) then
               For n:=1 to NofSNoms do
                 NomCodes[n]:=lsDefNom[n];

       5  :  If (FoundOk) and LocOverride(lc,5) then
             Begin
               PCurrency:=lsPCurrency;
               CostPrice:=lsCostPrice;
             end;
       6  :  If (FoundOk) and LocOverride(lc,2) then
               CCDep:=lsCCDep;

       7  :  If (FoundOk) then
               BinLoc:=lsBinLoc;

       8  :  If (FoundOk) and LocOverride(lc,6) then
             Begin
               ROCurrency:=lsROCurrency;
               ROCPrice:=lsROPrice;
             end;

     end; {Case..}
   end;
 end;



 { ==== Procedure to Substitute Stock levels for location levels ==== }
 Procedure Stock_LocPSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);
 Begin
   Stock_LocFullSubst(StockR,Lc,3);
 end;


 { ==== Procedure to Substitute Stock levels for location levels ==== }
 Procedure Stock_LocROCPSubst(Var StockR  :  StockRec;
                                Lc      :  Str10);
 Begin
   Stock_LocFullSubst(StockR,Lc,8);
 end;

 Procedure Stock_LocNSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,4);

 end;

 Procedure Stock_LocCCDSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,6);

 end;

 Procedure Stock_LocCSubst(Var StockR  :  StockRec;
                               Lc      :  Str10);


 Begin
   Stock_LocFullSubst(StockR,Lc,5);
 end;

  Function LocOPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOPrice:=LocOverride(lc,0);

  end;

  Function LocONom(lc  :  Str10)  :  Boolean;

  Begin
    LocONom:=LocOverride(lc,1);

  end;


  Function LocOCCDep(lc  :  Str10)  :  Boolean;

  Begin
    LocOCCDep:=LocOverride(lc,2);

  end;

  Function LocOSupp(lc  :  Str10)  :  Boolean;

  Begin
    LocOSupp:=LocOverride(lc,3);

  end;

  Function LocOCPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocOCPrice:=LocOverride(lc,5);

  end;


  Function LocORPrice(lc  :  Str10)  :  Boolean;

  Begin
    LocORPrice:=LocOverride(lc,6);

  end;

 Procedure Stock_LocLinkSubst(Var StockR  :  StockRec;
                                  Lc      :  Str10);

 Var
   n  :  Byte;

 Begin
   For n:=4 to 8 do {* Set Cost Price, Re-Order Price, Nominal Codes *}
     If (n In [4..6,8]) then
       Stock_LocFullSubst(StockR,Lc,n);
 end;

  Function LinkMLoc_Loc(lc  :  Str10;
                    Var TSL :  MLocLocType)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

  Var
    KeyS,
    KeyChk     :  Str255;

    TmpKPath,
    TmpStat    :  Integer;
    TmpRecAddr :  LongInt;
    TmpMLoc    :  MLocRec;


  Begin
    TmpMLoc:=MLocCtrl^;

    Blank(TSL,Sizeof(TSL));

    Result:=BOff;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOn])+Full_MLocKey(lc);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    TmpStat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    Begin
      Result:=BOn;
      TSL:=MLocCtrl^.MLocLoc;
    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TmpMLoc;


  end;
 

end.
