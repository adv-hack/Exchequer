unit AdmUtl2;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,TEditVal,
  VarConst, GlobVar,SBSComp2;

{ ----------------------}


Type
  TVATMatrixPtr=  ^TVATMatrixRec;


  TVATMatrixRec=  Record
                    RateD    :  Text8Pt;
                    GoodsD,
                    VATD     :  TCurrencyEdit;


                    RateCode :  VATType;
                  end;

  TVATMatrix  =  Class(TList)

                  SpaceGap :  Integer;

                  VisiRec    :  TVATMatrixPtr;

                  Destructor Destroy; override;


                  Procedure AddVisiRec(RObj,
                                       VObj,
                                       GObj      :   TObject);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  TVATMatrixPtr;

                  Procedure HideVATMatrix(INAnal  :  IVATAnalType);

                  Procedure Update_Rate(Sender  :  TObject;
                                    Var InvR    :  InvRec);
                end; {TVATMatrix..}

{ ---------------------------------------------------------------------}

{ ---------------------------------------------------------------------}

  TDetCtrl  =  Class(TVisiBtns)

                 Procedure AddVisiRec(PObj      :   TObject;
                                      State     :   Boolean); Override;

                 Function IdWinRec(Start  :  Integer)  :  TWinControl;

                 Procedure SetVisiParent(PHandle  :  TWinControl);

                 Function FindxName(PName  :  String)  :  Integer;

               end;

{ ---------------------------------------------------------------------}

TDescfCtrl  =  Class(TDetCtrl)


                 Function IdDescfRec(Start  :  Integer)  :  Text8pt;


               end;

{ ---------------------------------------------------------------------}

  TLDescPtr  =  ^TLDescRec;


  TLDescRec  =  Record

                  fLine    :  Str255;
                  fLineNo  :  LongInt;
                  fNewAdd  :  Boolean;

                end;


  TLineDesc =  Class(TList)

                  VisiRec    :  TLDescPtr;

                  HasDesc,
                  Editing    :  Boolean;

                  LdFolio,
                  LdKitLink  :  LongInt;

                  Fnum,
                  Keypath    :  Integer;

                  DescFields :  TDescfCtrl;

                  Constructor Create;

                  Destructor Destroy;  override;


                  Procedure AddVisiRec(L    :  Str255;
                                       LNo  :  LongInt);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  TLDescPtr;

                  Procedure SetDescFields;

                  Procedure GetMultiLines(RecAddr  :  LongInt;
                                          AddMode  :  Boolean);

                  Procedure StoreMultiLines(LId    :  IDetail;
                                        Var LInv   :  InvRec);

                  Function GetUsedNo(LId  :  Idetail)  :  LongInt;


                end; {TLineDesc..}


    Procedure Delete_Kit(KitFolio :  LongInt;
                         DispMode :  Byte;
                     Var LInv     :  InvRec);


{ ---------------------------------------------------------------------}




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  BtrvU2,
  ComnU2,
  ComnUnit,
  BtKeys1U,
  InvFSU3U,
  BTSupU1,
  ETStrU,
  ETMiscU;



{ ============== Function to Calculate Total VAT Based on InvVatAnal =========== }

Function CalcTotalVAT(InvR  :  InvRec)  :  Real;

Var
  n    :  VatType;
  Rnum :  Real;


Begin
  Rnum:=0;

  For n:=Vstart to VEnd do
    Rnum:=Rnum+Round_Up(InvR.InvVatAnal[n],2);

  CalcTotalVAT:=Rnum;
end;


{ ====================== TVATMatrix Methods ===================== }

Destructor TVATMatrix.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TVATMatrix.AddVisiRec(RObj,
                                VObj,
                                GObj      :   TObject);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      RateD:=Text8Pt(RObj);
      GoodsD:=TCurrencyEdit(GObj);
      VATD:=TCurrencyEdit(VObj);
      RateCode:=VATType(Count);

      With SyssVAT^ do
        RateD.Text:=VATRates.VAT[RateCode].Desc;

      With (GoodsD) do {* Calculate Gap between Rows *}
      Case Count of
         1  :  SpaceGap:=Top+Height;
         2  :  SpaceGap:=Top-SpaceGap;
      end;

    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}

Procedure TVATMatrix.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}

Function TVATMatrix.IdRec(Start  :  Integer)  :  TVATMatrixPtr;

Begin

  Result:=List[Start];

end;

{ ===== Procedure to Hide non used VAT rates ===== }

Procedure TVATMatrix.HideVATMatrix(INAnal  :  IVATAnalType);

Var
  n       :  VATType;
  NewTop  :  Integer;

Begin
  NewTop:=IdRec(0)^.GoodsD.Top;

  For n:=VStart to VEnd do
  Begin
    With IdRec(Ord(n))^ do
    Begin
      RateD.Visible:=INAnal[n];
      VATD.Visible:=INAnal[n];
      GoodsD.Visible:=INAnal[n];

      If (INAnal[n]) then {* Re-adjust position *}
      Begin
        RateD.Top:=NewTop;
        VATD.Top:=NewTop;
        GoodsD.Top:=NewTop;
        NewTop:=NewTop+GoodsD.Height+SpaceGap;
      end;
    end;
  end; {Loop..}
end;

{ ==== Update Manual VAT ==== }

Procedure TVATMatrix.Update_Rate(Sender  :  TObject;
                             Var InvR    :  InvRec);


Var
  n          :  Integer;
  FoundOk    :  Boolean;

Begin
  n:=0;
  FoundOk:=BOff;

  While (n<=Pred(Count)) and (Not FoundOk) do
  With IdRec(n)^ do
  Begin
    FoundOk:=(Sender=VATD);

    If (FoundOk) then
    With InvR do
    Begin
      InvVATAnal[RateCode]:=VATD.Value;
      InvVAT:=CalcTotalVAT(InvR);
    end
    else
      Inc(n);
  end; {While..}
end; {Proc..}




  { ======== Set Up Default Stock ========= }

  Procedure Set_UpId(IdR    :  IDetail;
                 Var TmpId  :  IDetail);


  Begin

    Blank(TmpId,Sizeof(TmpId));

    With TmpId do
    Begin

      FolioRef:=IdR.FolioRef;

      DocPRef:=IdR.DocPRef;

      IDDocHed:=IdR.IDDocHed;

      LineNo:=Succ(IdR.LineNo);

      Currency:=IdR.Currency;

      CXRate:=IdR.CXRate;

      CurrTriR:=IdR.CurrTriR;

      {$IFDEF STK}
        LineType:=StkLineType[IdDocHed];
      {$ENDIF}

      ABSLineNo:=0;

      PYr:=IdR.PYr;
      PPr:=IdR.PPr;

      Payment:=IdR.Payment;

      Reconcile:=IdR.Reconcile;

      CustCode:=IdR.CustCode;

      PDate:=IdR.PDate;

      DocLTLink:=IdR.DocLTLink;

      MLocStk:=IdR.MLocStk;
    end; {With..}

  end; {Proc..}


  { ======= Procedure to Store artificial lines ======= }

  Procedure Store_StkId(Fnum,
                        KeyPAth  :  Integer;
                    Var LInv     :  InvRec);

  Var
    TmpId  :  IDetail;

    TmpINo :  LongInt;

  Begin                                {* Before you start looking, there is no quicker way
                                          to speed this up. An atempt was made to avoid using
                                          moveEmUp on an add by recalling the lines in order,
                                          this is contained within move2.prg, but at the time
                                          prooved too complicated since all the other routines
                                          were geared around bringing the lines in in reverse
                                          order. Tests showed this renumbering does add
                                          time onto recalling the lines, only using it on an
                                          insert would improove things, but not dramaticaly*}

    TmpId:=Id;

    TmpIno:=Id.LineNo;

    If (TmpIno>1) then
      TmpIno:=Pred(Id.LineNo);


    MoveEmUp(FullNomKey(Id.FolioRef),
             FullIdKey(Id.FolioRef,LastAddrD),
             FullIdKey(Id.FolioRef,TmpIno),
             2,                         {* Increase x 2 so an insert works *}
             Fnum,KeyPath);



    Id:=TmpId;



    LInv.ILineCount:=LInv.ILineCount+2; {* Normally 1 *}

    {If (Id.IdDocHed In OrderSet) then}

    Id.ABSLineNo:=LInv.ILineCount;



    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


    Report_BError(Fnum,Status);

  end; {Proc..}


{------------ TDetCtrl Methods ------------- }

Procedure TDetCtrl.AddVisiRec(PObj      :   TObject;
                              State     :   Boolean);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      PanelObj:=PObj;
    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}



Function TDetCtrl.IdWinRec(Start  :  Integer)  :  TWinControl;

Begin

  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      Result:=TWinControl(VisiRec^.PanelObj);

    except

      Result:=nil;

    end;
  end
  else
    Result:=nil;

end;


Procedure TDetCtrl.SetVisiParent(PHandle  :  TWinControl);

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    If (IdWinRec(n)<>nil) then
    Begin
      IdWinRec(n).Parent:=PHandle;
    end;

  end;
end;


Function TDetCtrl.FindxName(PName  :  String)  :  Integer;

Var
  n       :  Integer;
  FoundOk :  Boolean;

Begin
  FoundOk:=BOff;
  For n:=0 to Pred(Count) do
  Begin
    If (IdWinRec(n).Name=PName) then
    Begin
      FoundOk:=BOn;
      Break;
    end;
  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

end;

{ ========= TDescfCtrl Method ========= }


Function TDescfCtrl.IdDescfRec(Start  :  Integer)  :  Text8pt;

Begin

  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      Result:=Text8pt(VisiRec^.PanelObj);

    except

      Result:=nil;

    end;
  end
  else
    Result:=nil;

end;


{ ====================== TLineDesc Methods ===================== }

Constructor TLineDesc.Create;
Begin
  Inherited;

  DescFields:=TDescfCtrl.Create;

  Editing:=BOff;
  HasDesc:=BOff;

end;

Destructor TLineDesc.Destroy;

Begin
  DestroyVisi;
  DescFields.Free;

  Inherited;
end;


Procedure TLineDesc.AddVisiRec(L    :  Str255;
                               LNo  :  LongInt);


Var
  Idx  :  Integer;

  NewVRec
       :  TLDescPtr;


Begin
  New(NewVRec);

  try
    With NewVRec^ do
    Begin
      FillChar(NewVRec^,Sizeof(NewVRec^),0);

      fLine:=L;
      fLineNo:=Lno;

    end;

    Idx:=Add(NewVRec);

  except

    Dispose(NewVRec);

  end; {Except..}

end; {Proc..}

Procedure TLineDesc.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}


Function TLineDesc.IdRec(Start  :  Integer)  :  TLDescPtr;

Begin

  Result:=List[Start];

end;


Procedure TLineDesc.SetDescFields;

Var
  n  :  Integer;

Begin

  For n:=0 to Pred(Count) do
    DescFields.IdDescfRec(n).Text:=IdRec(n).fLine;


end;

Procedure TLineDesc.GetMultiLines(RecAddr  :  LongInt;
                                  AddMode  :  Boolean);

Const
  B_Func  :  Array[BOff..BOn] of Integer = (B_GetGEq,B_GetNext);

Var
  KeyS,
  KeyChk  :  Str255;

  Locked,
  boLoop,
  FoundOk :  Boolean;

  B_Func2 :  Integer;


Begin
  Locked:=BOff;

  boLoop:=Not Editing or AddMode;

  If (AddMode) then
    Clear;

  KeyChk:=FullNomKey(LDFolio);

  Repeat
    If (Editing) then
    Begin
      Status:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],RecAddr,BOn,BOn);

      With Id do
        KeyS:=FullIdKey(LDFolio,LineNo);

      If (boLoop) and (Not AddMode) then
        B_Func2:=B_GetPrev
      else
        B_Func2:=B_GetNext;

    end
    else
    Begin
      KeyS:=FullIdKey(LDFolio,IdRec(0)^.fLineNo);

      B_Func2:=B_Func[Editing];

    end;


    Status:=Find_Rec(B_Func2,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    FoundOk:=((Id.KitLink=LDKitLink) and (Not Is_FullStkCode(Id.StockCode)) and ((Id.Qty=0.0) and (Id.NetValue=0.0)));

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (FoundOk)
         and ((Count<Pred(NofSDesc)) or (Not AddMode)) do
    With Id do
    Begin

      If (AddMode) then
      Begin
        AddVisiRec(Desc,LineNo);
      end
      else
      Begin
        GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        Report_BError(Fnum,Status);

      end;


      Status:=Find_Rec(B_Func[AddMode],F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      FoundOk:=((Id.KitLink=LDKitLink) and (Not Is_FullStkCode(Id.StockCode)) and ((Id.Qty=0.0) and (Id.NetValue=0.0)));


    end; {While..}

    boLoop:=Not BoLoop;

  Until (Not boLoop) or (Not Editing) or (AddMode);

  If (Editing) then
    Status:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],RecAddr,BOn,BOn);

end; {Proc..}



Procedure TLineDesc.StoreMultiLines(LId    :  IDetail;
                                Var LInv   :  InvRec);


Var
  n  :  Integer;

  NextNo
     :  LongInt;


Begin

  NextNo:=GetUsedNo(LId);


  For n:=Pred(Count) downto 0 do
  With Id do
  Begin

    Set_UpId(LId,Id);

    KitLink:=LDKitLink;
    Desc:=IdRec(n)^.fLine;
    LineNo:=IdRec(n)^.fLineNo;
    QtyPick:=LId.QtyPick;

    If (LineNo=0) or (IdRec(n)^.fNewAdd) then
    Begin
      LineNo:=Succ(NextNo);

      Store_StkID(Fnum,Keypath,LInv);
    end
    else
    Begin
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


      Report_BError(Fnum,Status);
    end;

  end; {With..}

end; {Proc..}


Function TLineDesc.GetUsedNo(LId  :  Idetail)  :  LongInt;

Var

  n  :  Integer;

Begin

  Result:=0;

  For n:=0 to Pred(Count) do
    If (IdRec(n)^.fLineNo>Result) then
      Result:=IdRec(n)^.fLineNo;

  If (Result=0) then
    Result:=LId.LineNo;

end;



  { ========= Procedure to delete kitting lines ========= }

  Procedure Delete_Kit(KitFolio :  LongInt;
                       DispMode :  Byte;
                   Var LInv     :  InvRec);



  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;



  Var

    KeyS,
    KeyChk    :  Str255;

    ExStatus  :  Integer;

    KitMatch,
    Locked    :  Boolean;

    LAddr,
    RecAddr   :  LongInt;

    TmpId     :  ^IDetail;



  Begin
    RecAddr:=0;

    New(TmpId);

    TmpId^:=Id;

    ExStatus:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve so we can lockit again *}

    {Report_BError(Fnum,ExStatus);  If we start with a blank tx we will ger an error 8 at this point}

    KitMatch:=BOn;

    Locked:=BOff;

    With Id do
    Begin
      KeyChk:=FullNomKey(FolioRef);

      KeyS:=FullIdKey(FolioRef,Succ(LineNo));
    end;


    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (KitMatch) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin

      KitMatch:=(KitLink=KitFolio);

      If (KitMatch) then
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          UpdateRecBal(Id,LInv,BOn,BOn,DispMode);

          ExStatus:=Delete_Rec(F[Fnum],Fnum,Keypath);

          Report_Berror(Fnum,ExStatus);

        end; {If Ok..}

      end; {If Match..}

      If (KitMatch) then
        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}


    If (RecAddr<>0) then
    Begin
      SetDataRecOfs(Fnum,RecAddr);

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0); {* Re-Establish Position *}
    end;

    Id:=TmpId^;

    Dispose(TmpId);

  end; {Proc..}





initialization

finalization

end.


