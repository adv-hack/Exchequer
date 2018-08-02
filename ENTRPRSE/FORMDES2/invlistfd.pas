unit invlistfd;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst, BtrvU2,
     SBSComp, SupListU, VarRec2U, BTSupU1;

{--------------------------------------------------------------------------------------}

Type
  TStockList = Class(TGenList)
    Function SetCheckKey  :  Str255; Override;
    Function StkMatchWCard(StockR  :  StockRec)  :  Char;
    Function SetFilter  :  Str255; Override;
    Function OutStkLine(Col  :  Byte)  :  Str255;
    Function OutLine(Col  :  Byte)  :  Str255; Override;
    Function SetColCaption  :  Str255; Override;
  end;

  TStockFind = Object
    MULCtrlO    :  TStocklist;
    PopUpList   :  TPopUpList;
    AdvanceFind :  Boolean;

    Destructor Destroy;

    Constructor Create(AOwner   :  TComponent;
                       Fnum,
                       SKeyPath :  Integer;
                       Key2F    :  Str255;
                       KLen     :  Integer;
                       XMode    :  Integer;
                       UseWC    :  Boolean;
                       KeyW,
                       KeyF     :  Str255;
                       CFilters :  FilterType);
  End; { TStockFind }


  Function GetStock(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    Mode   :  Integer)  :  Boolean;


implementation

Uses ETStrU, EtMiscU, BtKeys1u;


{ ============ TStockList Methods ================= }
Function TStockList.SetCheckKey  :  Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case ScanFileNum of
    StockF  :
               With Stock do
                 Case Keypath of
                   StkCodeK   :  DumStr:=StockCode;
                   StkDescK   :  DumStr:=Desc[1];
                   StkAltK    :  DumStr:=AltCode;
                   StkBarCK   :  DumStr:=Barcode;
                 end; {Case..}

  {$IFDEF SOP}

    MLocF : With MLocCtrl^,MLocLoc do
            Case KeyPath of
              MLK       :  DumStr:=RecPfix+SubType+loCode;
              MLSecK    :  DumStr:=RecPfix+SubType+loName;
            end; {Case..}

  {$ENDIF}

  end; {Case..}
  SetCheckKey:=DumStr;
end;


Function TStockList.StkMatchWCard(StockR  :  StockRec)  :  Char;
Var
  TmpBo,
  FOk    :  Boolean;
  TChr   :  Char;
  TMode  :  Byte;

  GenStr,
  WMatch
         :  Str255;

Begin

  TmpBO:=BOff;
  TMode:=0;

  FOk:=(Not UseWildCard);

  If (Not FOk) then
  With StockR do
  Begin
    TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=BarCTrig))+
           (5*Ord(KeyWildM[1]=WildCha));

    If (TMode>0) then
      WMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
    else
      WMatch:=KeyWildM;

    Case TMode of

      0,1
         :  FOk:=(Match_Glob(Sizeof(StockCode),WMatch,StockCode,TmpBo));
      2  :  FOk:=(Match_Glob(Sizeof(Desc),WMatch,Desc,TmpBo));
      3  :  FOk:=(Match_Glob(Sizeof(AltCode),WMatch,Altcode,TmpBo));
      4  :  FOk:=(Match_Glob(Sizeof(BarCode),WMatch,BarCode,TmpBo));
      5  :  FOk:=(Match_Glob(Sizeof(StockR),WMatch,StockR,TmpBo));
      else  FOk:=BOff;


    end; {Case..}


  end; {With..}

  If (FOk) then
    TChr:=StockR.StockType
  else
    TChr:=NdxWeight;

  StkMatchWCard:=TChr;

end;


Function TStockList.SetFilter  :  Str255;

Begin
  Case ScanFileNum of
    StockF  :  Result:=StkMatchWCard(Stock);

    {$IFNDEF EDLL}
      {$IFNDEF OLE}
        {$IFNDEF RW}
          {$IFNDEF ENDV}
          {$IFNDEF XO}
            {$IFDEF SOP}

                MLocF  :  Begin
                            With MLocCtrl^.sdbStkRec do
                            Begin
                              LinksdbStk(SdStkFolio,0);

                              If (UseWildCard) then
                                Result:=StkMatchWCard(Stock)
                              else
                                Result:=Stock.StockType;


                              If (KeyFilter<>'') and (Not CheckKey(KeyFilter,sdSuppCode,Length(KeyFilter),BOff)) then
                                Result:=Filter[1,1];
                            end;

                          end;
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
  end; {Case..}

end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TStockList.OutStkLine(Col  :  Byte)  :  Str255;

Begin
   With Stock do
     Case Col of
       0  :  Case Keypath of
               StkAltK  :  Result:=AltCode;
               else        Result:=StockCode;
             end;

       1  :  Result:=Desc[1];
     end; {Case..}
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TStockList.OutLine(Col  :  Byte)  :  Str255;

Begin
  Case ScanFileNum of
    StockF  :  Result:=OutStkLine(Col);

    {$IFNDEF EDLL}
      {$IFNDEF OLE}
        {$IFNDEF RW}
         {$IFNDEF ENDV}
          {$IFNDEF XO}
            {$IFDEF SOP}
              MLocF :  Result:=OutAltLine(Col);
            {$ENDIF}
          {$ENDIF}
         {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  end; {Case..}
end;


Function TStockList.SetColCaption  :  Str255;

Begin
Case SCCount of
  0  :  Result:='Stock Item';
  1  :  Result:='RO Price,A/C Code';
  2  :  Result:='Stock Description';
  3  :  Result:='Alt Description';
  4  :  Result:='Alt Supplier';
end; {Case..}
end;




Destructor TStockFind.Destroy;

Begin

  MULCtrlO.Destroy;

  If (PopUpList<>Nil) then
    PopUpList.Free;

end;

Constructor TStockFind.Create(AOwner   :  TComponent;
                              Fnum,
                              SKeyPath :  Integer;
                              Key2F    :  Str255;
                              KLen     :  Integer;
                              XMode    :  Integer;
                              UseWC    :  Boolean;
                              KeyW,
                              KeyF     :  Str255;
                              CFilters :  FilterType);

Begin

  PopUpList:=Nil;
  AdvanceFind:=BOff;

  MULCtrlO:=TStockList.Create(AOwner);

  Try
    With MULCtrlO do
    Begin
      Filter:=CFilters;

      UseWildCard:=UseWC;
      KeyWildM:=KeyW;
      KeyFilter:=KeyF;

      StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

      AdvanceFind:=GetCode(XMode);
    end;

    If (Not AdvanceFind) and (XMode<>-1) then
    Begin
      MULCtrlO.Destroy;

      PopUpList:=TPOPUpList.Create(AOwner);

      Try

        MULCtrlO:=TStockList.Create(PopUpList);


        With MULCtrlO do
        Begin
          UseWildCard:=UseWC;
          KeyWildM:=KeyW;
          KeyFilter:=KeyF;

          HasScroll:=(Fnum=MLocF);

          If (HasScroll) then
            SCMax:=4;
        end;

        PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

      except

        PopUpList.Free;
        PopUpList:=Nil;

      end;

    end {IF Advance find ok..}
    else
    Begin
      {$IFNDEF EDLL}
       {$IFNDEF OLE}
        {$IFNDEF RW}
         {$IFNDEF ENDV}
          {$IFNDEF XO}
           {$IFDEF SOP}
             If (FNum=MLocF) then  {* On auto find, link to stock record... *}
               With MLocCtrl^.sdbStkRec do
                 LinksdbStk(SdStkFolio,0);
           {$ENDIF}
          {$ENDIF}
         {$ENDIF}
        {$ENDIF}
       {$ENDIF}
      {$ENDIF}
    end;



  Except

     MULCtrlO.Free;
     MULCtrlO:=Nil;
  end;

end; {Proc..}


{ ================ Function to Find an approximate match via list =========== }
Function GetsdbStock(AOWner   :  TComponent;
                     Want     :  Str20;
                     SuppFilt :  Str10;
                 Var Found    :  Str20;
                 Var sdbStkL  :  LongInt;
                     Mode     :  Integer)  :  Boolean;

Var
  RecFind   :  ^TStockFind;
  LenSCode  :  Byte;

  WithSupF,
  UseAltdb,
  PrevHState,
  UseWildCard
            :  Boolean;

  SFnum,
  SKeyPath  :  Integer;

  KeyFilter,
  KeyWildM  :  Str255;

  RecFilters
            :  FilterType;
  KeyRef    :  Str255;

Begin
  UseWildCard:=BOff;

  WithSupF:=BOff; UseAltdb:=BOff;

  SKeyPath:=StkCodeK;
  SFnum:=StockF;

  KeyFilter:='';

  Blank(RecFilters,Sizeof(RecFilters));

  LenSCode:=Length(Want);

  If (LenSCode>0) then
  Begin

    UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

    If (UseWildCard) then
      Want:=Copy(Want,2,Pred(LenScode));

    If ((Want[1]=WildChQ) or (Want[1]=DescTrig) or (Want[1]=BarCTrig)
         {$IFDEF SOP} or (Want[1]=sdbTrig) or (Want[1]=supTrig) {$ENDIF} ) and (Mode<>-1) then
    Begin

      If (Want[1]=WildChQ) then
        SKeyPath:=StkAltK
      else
        If (Want[1]=DescTrig) then
          SKeyPath:=StkDescK
        else
          If (Want[1]=BarCTrig) then
            SKeyPath:=StkBarCK
          {$IFDEF SOP}
          else
            If (Want[1]=sdbTrig) or (Want[1]=SupTrig) then
            Begin
              SKeyPath:=MLK;
              UseAltdb:=BOn;
              WithSupF:=(Want[1]=SupTrig);
            end;

          {$ELSE}

            ;

          {$ENDIF}


      If (Not UseWildCard) then
        Want:=Copy(Want,2,Pred(LenScode));
    end
  end;

  KeyRef:=UpCaseStr(Want);




  If (Mode<>-1) then
  Begin
    If (UseWildCard) then
    Begin
      RecFilters[1,1]:=NdxWeight;
      KeyWildM:=KeyRef;
      KeyRef:='';
    end
    else
      KeyRef:=Strip('B',[#32],KeyRef);

    {$IFDEF SOP}

      If (UseAltdb) then
        KeyRef:=PartCCKey(NoteTCode,NoteCCode)+KeyRef;
    {$ENDIF}


    If (UseAltdb) then
      SFnum:=MLocF
    else
      SFnum:=StockF;

    Case Mode of
      0,3
         :  Begin                     { -- Exclude G types, Include P & D & M types only -- }
                                      { -- Mode 3 exclude delisted types in addition -- }
              RecFilters[1+Ord(UseWildCard),1]:=StkGrpCode;

              If (Mode=3) then
                RecFilters[2+Ord(UseWildCard),1]:=StkDListCode;

              {$IFDEF SOP}
                If (WithSupF) then
                  KeyFilter:=SuppFilt;
              {$ENDIF}

            end;

      1  :  RecFilters[1,0]:=StkGrpCode;  { -- Include only H types -- }

      2  :  RecFilters[1,0]:=StkBillCode;  { -- Include only M types -- }

      4  :  RecFilters[1+Ord(UseWildCard),1]:=StkDListCode; { -- Exclude de-listed -- }

      99 :  ;                         { -- Include All -- }
    end; {Case..}

  end;

  LenSCode:=Length(KeyRef);

  New(RecFind,Create(AOwner,SFNum,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,KeyFilter, RecFilters));

  Try
    Result:=RecFind^.AdvanceFind;

    If (Not Result) and (Mode<>-1) then
    With RecFind^.PopUpList do
    Begin
      ListPFix:='K';

      Caption:='Stock '+Caption;

      If (SKeyPath=StkAltK) then
        ListCol1Lab.Caption:='Alternative Code'
      else
        ListCol1Lab.Caption:='Code';

      ListCol2Lab.Caption:='Description';

      SetAllowHotKey(BOff,PrevHState);

      //Set_BackThreadMVisible(BOn);

      ShowModal;

      //Set_BackThreadMVisible(BOff);

      SetAllowHotKey(BOn,PrevHState);

      Result:=FFoundOk;

      If (Result) then
      Begin
        Found:=Stock.StockCode;

        {$IFDEF SOP}
          With MLocCtrl^.sdbStkRec do
          If (SFnum=MLocF) and (sdStkFolio=Stock.StockFolio) and (UseAltdb) then
            SdbStkL:=SdFolio;
        {$ENDIF}
      end;

    end
    else
      If (Result) then
      Begin
        Found:=Stock.StockCode;

        {$IFDEF SOP}
          With MLocCtrl^.sdbStkRec do
          If (SFnum=MLocF) and (sdStkFolio=Stock.StockFolio) and (UseAltdb) then
            SdbStkL:=SdFolio;
        {$ENDIF}
      end;

  finally

    Dispose(RecFind,Destroy);

  end;


end; {Func..}


Function GetStock(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;
Var
  sdbFolio  :  LongInt;
Begin
  sdbFolio:=0;

  Result:=GetsdbStock(AOwner,Want,'',Found,sdbFolio,Mode);
end;

end.

