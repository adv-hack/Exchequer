Unit WOPCT1U;

{$I DEFOVR.Inc}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/09/96                      }
{                 SOP Process Control Unit II                  }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


{$IFDEF SOPDLL}
  {$DEFINE SOP}
  {$UNDEF EXDLL}

{$ENDIF}


Interface

Uses
  Forms,
  GlobVar,
  VarConst,
  TEditVal;


Type
  tWORGen  =  Record
                ptrMTExLocal  :  Pointer;

                ptrThisScrt   :  Pointer;

                ShowWOR,
                WORCreated,
                AbortRun,
                FinalItem     :  Boolean;

                ptrMsgForm    :  TForm;

                LastMatchLine :  LongInt;
              end;


Procedure WORAuto_PickQty(Var InvR   :  InvRec;
                          BOMId      :  IDetail;
                          BOMQty     :  Double;
                      Var CouldBuild :  Double;
                      Var CouldIssue :  Boolean;
                          Mode       :  Byte;
                          AOwner     :  TObject);

Procedure WORAuto_WriteOfff(Var InvR   :  InvRec;
                            BOMId      :  IDetail;
                            Mode       :  Byte;
                            AOwner     :  TObject);

Function  CanPickStdBOM(Var InvR       :  InvRec;
                            BOMId      :  IDetail;
                            BOMQty     :  Double;
                        Var CouldBuild :  Double;
                            Mode       :  Byte;
                            AOwner     :  TObject)  :  Boolean;

Function CanBuildStd(InvR   :  InvRec;
                     Mode   :  Byte;
                     Warn   :  Boolean)  :  Boolean;

Function  Adjust_CouldQty(QA,QM  :  Double)  :  Double;

Function CouldBuildBOM(InvR       :  InvRec;
                   Var CouldIssue :  Boolean;
                   Var LowStock   :  Str20;
                   Var LowQty     :  Double;
                   Var LowLoc     :  Str5;
                       Mode       :  Byte)  :  Double;

Function BOMQtyIssue(LId       :  IDetail)  :  Double;

Function Check_PossBuild(LId       :  IDetail;
                         ShowMsg   :  Boolean)  :  Boolean;

Function ContainsChildBom(StockR  :  StockRec;
                          Mode    :  Byte)  :  Boolean;

Procedure Time2Mins(Var MTime                :  LongInt;
                    Var Days,Hrs,Mins        :  Extended;
                        SetMode              :  Byte);

Procedure CompTime2Mins(Var MTime                :  LongInt;
                        Var Days,Hrs,Mins        :  TCurrencyEdit;
                            SetMode              :  Byte);

Function ProdTime2Str(MTime  :  LongInt)  :  Str255;


Procedure Generate_WOR(SORInv  :  InvRec;
                       SORLine :  IDetail;
                       WorStkR :  StockRec;
                   Var B2BCtrl :  B2BInpRec;
                   Var RunCtrl :  tWORGen);

{$IFDEF SOP}
  Function Sno4Sale(StockFolio  :  LongInt;
                    QtyReq      :  Double;
                    Mode        :  Byte)  :  Double;

  Function CheckExsiting_WOR(OInv  :  InvRec;
                             OId   :  IDetail;
                         Var WORef :  Str10)  :  Boolean;

{$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   VarRec2U,
   Dialogs,
   Controls,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   ETStrU,
   SysU1,
   SysU2,
   BTSupU1,
   BTSupU3,
   BTKeys1U,
   InvListU,
   {$IFDEF SOP}
     InvLst3U,
     Saltxl2U,
     PayF2U,

   {$ENDIF}

   StkBinU,

   PassWR2U,
   Event1U,
   GenWarnU,
   Warn1U,
   NoteSupU,
   LedgSupU,
   ExBtTh1U,
   ExThrd2U,
   InvCTSUU,
   SCRTCH2U,
   CustomFieldsIntf,
   { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
   TransactionOriginator,

   InvCt2Su;




Procedure WORAuto_PickQty(Var InvR   :  InvRec;
                          BOMId      :  IDetail;
                          BOMQty     :  Double;
                      Var CouldBuild :  Double;
                      Var CouldIssue :  Boolean;
                          Mode       :  Byte;
                          AOwner     :  TObject);


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdFolioK;



Var
  FoundCode  :  Str20;

  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  GotLines,
  LineOk,
  GotStock,
  TmpOk,
  NoStop
           :  Boolean;

  SnoAvail,
  QtyAvail :  Double;
  FreeAll  :  Real;

  CopyId   :  IDetail;

  MsgForm  :  TForm;

  mbRet    :  TModalResult;




Begin


  GotLines:=BOff;

  LineOk:=BOff;

  FreeAll:=0; QtyAvail:=0;  CouldBuild:=-1.0;

  GotStock:=BOff; SNoAvail:=0.0;

  NoStop:=BOn;

  GenStr:=''; CopyId:=Id;

  TmpOk:=BOff;

  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please Wait... Automatically picking order',mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;



  KeyChkI:=FullNomKey(InvR.FolioNum);

  KeySI:=FullIdKey(InvR.FolioNum,2);

  Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (NoStop) do
  With Id do
  Begin

    mbRet:=MsgForm.ModalResult;

    Loop_CheckKey(NoStop,mbRet);

    MsgForm.ModalResult:=mbRet;

    Application.ProcessMessages;


    If (Qty_OS(Id)<>0) then
    Begin

      GotStock:=GetStock(Application.MainForm,StockCode,FoundCode,-1);

      {$IFDEF SOP}
        Stock_LocSubst(Stock,MLocStk);

      {$ENDIF}


      If (GotStock) then
      Begin
        If (Stock.StockType=StkDescCode) then
          QtyAvail:=Qty_OS(Id)
        else
          QtyAvail:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR+QtyPick);
      end
      else
        QtyAvail:=0.0;

      LineOk:=(((QtyAvail>0) or (Mode In [3,4])) and GotStock and ((Not Is_SerNo(Stock.StkValType)) or (Mode In [2,4])) and Is_FullStkCode(StockCode))
              and (B2BLink=0) and ((QtyPick<(QtyMul*BOMQty)) or (Mode In [3,4]));

      If (LineOk) then
      Begin
        If (Not GotLines) then
        Begin

          GotLines:=BOn;

        end;



        Begin
          CopyId:=Id;

          If (Mode In [1,2]) then
          Begin
            QtyPick:=(QtyMul*BOMQty);

            If (QtyPick>Qty_OS(Id)) then
              QtyPick:=Qty_OS(Id)
            else
              If (QtyPick<Qty_OS(Id)) then  {If the difference left is less than a whole, include it}
              Begin
                If (DivWChk(Qty_OS(Id)-QtyPick,QtyMul)<1.0) then
                  QtyPick:=Qty_OS(Id);
              end;
          end
          else
          Begin {We are resetting them}
            QtyPick:=0.0;

          end;


          Begin

            If (Stock.StockType=StkDescCode) then
              FreeAll:=QtyPick
            else
              FreeAll:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR+CopyId.QtyPick);

            If (FreeAll<QtyPick) then
            Begin

              If (FreeAll>0) then
                QtyPick:=FreeAll
              else
                QtyPick:=0;

            end;


          end;

          {$IFDEF SOP}
            If (QtyPick<>CopyId.QtyPick) and (Mode=2) and Is_SerNo(Stock.StkValType) then {* Check there are enough free serial nos before proceeding *}
            Begin
              SnoAvail:=Sno4Sale(Stock.StockFolio,QtyPick-SerialQty,0);

              If (SnoAvail<QtyPick) then {Lower amount picked to match qty available}
              Begin
                QtyPick:=SnoAvail;

                If (QtyPick<CopyId.QtyPick) then
                  QtyPick:=CopyId.QtyPick;
              end;

            end;
          {$ENDIF}
          
          If (QtyPick<>CopyId.QtyPick) then {* Update Picked Qty Status *}
          Begin
            Stock_Deduct(CopyId,InvR,BOff,BOn,3); {* Deduct previous amount picked }

            {Bring any bins in line}
            Auto_PickBin(Id,InvR,CopyId.QtyPick,Id.BinQty,1);

            Stock_Deduct(Id,InvR,BOn,BOn,3);

            {Bring any bins in line}
            Auto_PickBin(Id,InvR,Id.QtyPick,Id.BinQty,0);


            {$IFDEF SOP}

              If (Mode In [2,4]) and (Not Stock.MultiBinMode)then
                Control_SNos(Id,InvR,Stock,1,AOWner);

              If (CostPrice<>CopyId.Costprice) then
              Begin
                UpdateWORCost(InvR,CopyId,1);

                UpdateWORCost(InvR,Id,0);
              end;

            {$ENDIF}


            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

            Report_BError(Fnum2,Status);

          end;

        end;



      end; {If LineOk..}


      If (DivWChk(QtyPick,QtyMul)<CouldBuild) or (CouldBuild=-1.0) then
        CouldBuild:=Round_Up(DivWChk(QtyPick,QtyMul),Syss.NoQtyDec);
    end;

    CouldIssue:=(CouldIssue or(QtyPick<>0.0));

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  end; {While..}

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}


Procedure WORAuto_WriteOfff(Var InvR   :  InvRec;
                            BOMId      :  IDetail;
                            Mode       :  Byte;
                            AOwner     :  TObject);


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdFolioK;



Var
  FoundCode  :  Str20;

  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  GotLines,
  LineOk,
  GotStock,
  TmpOk,
  NoStop
           :  Boolean;

  CopyId   :  IDetail;

  MsgForm  :  TForm;

  mbRet    :  TModalResult;




Begin


  GotLines:=BOff;

  LineOk:=BOff;


  GotStock:=BOff;

  NoStop:=BOn;

  GenStr:=''; CopyId:=Id;

  TmpOk:=BOff;

  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please Wait... Automatically writing off order',mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;



  KeyChkI:=FullNomKey(InvR.FolioNum);

  KeySI:=FullIdKey(InvR.FolioNum,1);

  Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (NoStop) do
  With Id do
  Begin

    mbRet:=MsgForm.ModalResult;

    Loop_CheckKey(NoStop,mbRet);

    MsgForm.ModalResult:=mbRet;

    Application.ProcessMessages;


    If (Qty_OS(Id)<>0) then
    Begin
      Stock_Deduct(Id,InvR,BOff,BOn,3); {* Deduct previous amount picked }

      QtyPWOff:=Round_Up(QtyPWOff+(Qty_OS(Id)*DocNotCnst),Syss.NoQtyDec);

      Stock_Deduct(Id,InvR,BOn,BOn,3);

      Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

      Report_BError(Fnum2,Status);


    end;

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  end; {While..}

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}


Function HasSerLines(BOMId      :  IDetail;
                     Mode       :  Byte)  :  Boolean;


Const
    Fnum2    =  IdetailF;

    Keypath2 =  IdFolioK;



Var
  KeySI,
  KeyChkI,
  GenStr  :  Str255;


  GotLines:  Boolean;


Begin


  GotLines:=BOff;

  KeyChkI:=FullNomKey(BOMId.FolioRef);

  KeySI:=FullIdKey(BOMId.FolioRef,2);

  Set_BackThreadMVisible(BOn);

  Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (Not GotLines) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Global_GetMainRec(StockF,StockCode)) then
      GotLines:=Is_SerNo(Stock.StkValType);


    If (Not GotLines) then
      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  end; {While..}

  Set_BackThreadMVisible(BOff);

  Result:=GotLines;
end; {Proc..}


Function  CanPickStdBOM(Var InvR       :  InvRec;
                            BOMId      :  IDetail;
                            BOMQty     :  Double;
                        Var CouldBuild :  Double;
                            Mode       :  Byte;
                            AOwner     :  TObject)  :  Boolean;

Var
  LowLoc   :  Str5;
  LowStock :  Str20;
  SuggStr,
  LSStr    :  Str100;
  OurMode  :  Byte;
  mbRet    :  Word;
  LowQty   :  Double;
  NeedSerNo,
  CouldIssue
           :  Boolean;
  StockR   :  StockRec;

Begin
  StockR:=Stock; CouldIssue:=BOff;;  LSStr:='';


  If (BOMQty>0.0) then
    OurMode:=Mode+1
  else
    OurMode:=Mode+3;

  mbRet:=0;  NeedSerNo:=BOff;

  CouldBuild:=CouldBuildBOM(InvR,CouldIssue,LowStock,LowQty,LowLoc,1);

  Result:=(CouldBuild>=BOMQty);

  If (Result) then
  Begin
    CouldBuild:=0.0;


    {$IFDEF SOP}

      NeedSerNo:=HasSerLines(BOMId,0);

      If (NeedSerNo) then
        mbRet:=CustomDlg(Application.MainForm,'Please Confirm','Pick Serial/Batch Items',
                                 'Do you wish to pick the serial/batch components contained within this Works Order?'+#13+#13+
                                 'If you choose not to, you will not be able to build '+Trim(BOMId.StockCode),
                                 mtConfirmation,
                                 [mbYes,mbNo]);

    {$ENDIF}

    If (Not NeedSerNo) or ((mbRet=mrOK) or (Not Is_StdWOP)) then
      WORAuto_PickQty(InvR,BOMId,BOMQty,CouldBuild,CouldIssue,OurMode+Ord(mbRet=mrOK),AOwner);

    Result:=(CouldBuild>=BOMQty);

    If (Not Result) then
    Begin
      If (CouldBuild=0) then
          SuggStr:='not enough available stock for you to build any'
      else
          SuggStr:='only enough available stock for you to build '+Form_Real(CouldBuild,0,Syss.NoQtyDec);

      ShowMessage('There is '+SuggStr+' '+Trim(BOMId.StockCode));
    end
    {$IFDEF SOP}
      else
        If (Is_SerNo(StockR.StkValType)) and (CouldBuild>0.0) then
        Begin

          mbRet:=CustomDlg(Application.MainForm,'Create Serial/Batch','Pick Serial/Batch Items',
                                 'You must now create the serial/batch records required to build '+Form_Real(CouldBuild,0,Syss.NoQtyDec)+
                                 ' '+Trim(BOMId.StockCode),mtInformation,[mbOK]);
        end;
    {$ELSE}
      ;
    {$ENDIF}
  end
  else
  Begin
    If (CouldBuild=0) then
    Begin
      SuggStr:='not enough available stock for you to build any';

      LSStr:=#13+#13+'('+Trim(LowStock)+'. Qty Available';

      If (LowLoc<>'') then
        LSStr:=LSStr+' at loc '+LowLoc;

      LSStr:=LSStr+' : '+Form_Real(LowQty,0,Syss.NoQtyDec)+')';
    end
    else
      SuggStr:='only enough available stock for you to build '+Form_Real(CouldBuild,0,Syss.NoQtyDec);

    ShowMessage('There is '+SuggStr+' '+Trim(BOMId.StockCode)+LSStr);
  end;

  Stock:=StockR;
end;


Function BOMQtyIssue(LId       :  IDetail)  :  Double;

Begin
  With LId do
  Begin
    Result:=(SSDUplift-QtyWOff);

    If (QtyPWOff>0) then {We have yielded more than the formula allows for so add it in as if it were free issue}
      Result:=Result+QtyPWOff;
  end;

end;


Function Check_PossBuild(LId       :  IDetail;
                         ShowMsg   :  Boolean)  :  Boolean;

Var
  SuggStr  :  Str50;
  SuggQty  :  Double;



Begin
  SuggStr:='';

  With LId do
  Begin
    If (Is_StdWOP) then
    Begin
      SuggQty:=QtyPick; {*EN440WOP*} {Check here for picked values on other lines}
    end
    else
      SuggQty:=BOMQtyIssue(LId);

    Result:=(Round_Up(SuggQty,Syss.NoQtydec)<Round_Up(QtyPick,Syss.NoQtyDec));

    If (Result) and (ShowMsg) then
    Begin
      If (SuggQty=0) then
        SuggStr:='not enough issued stock for you to build any'
      else
        SuggStr:='only enough issued stock for you to build '+Form_Real(SuggQty,0,Syss.NoQtyDec);

      ShowMessage('There is '+SuggStr+' '+Trim(StockCode));

    end;
  end; {With..}
end;


{ == Function to check in std mode if the lines still balance == }

Function CanBuildStd(InvR   :  InvRec;
                     Mode   :  Byte;
                     Warn   :  Boolean)  :  Boolean;


Const
  Fnum2    =  IdetailF;

  Keypath2 =  IdFolioK;



Var
  KeySI,
  KeyChkI,
  GenStr  :  Str255;

  mbRet   :  Word;

  FoundOk :  Boolean;

  CouldBuild,
  LineBuild
          :  Double;

  BOMId   :  IDetail;


Begin
  Result:=BOff;

  KeyChkI:=FullNomKey(InvR.FolioNum);
  KeySI:=FullIdKey(InvR.FolioNum,1);

  Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  FoundOk:=(StatusOk) and (Id.QtyPick<>0.0);

  CouldBuild:=-1.0;  LineBuild:=0.0;

  If (FoundOk) then
  Begin
    BOMId:=Id;

    KeySI:=FullIdKey(InvR.FolioNum,2);

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

    While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) do
    With Id do
    Begin
      Application.ProcessMessages;

      If (Stock.StockCode<>StockCode) then
        If (Not Global_GetMainRec(StockF,StockCode)) then
          ResetRec(StockF);


      LineBuild:=Round_Up(DivWChk(QtyPick,QtyMul),Syss.NoQtyDec);

      If ((LineBuild<CouldBuild) or (CouldBuild=-1.0)) and (Qty_Os(Id)<>0.0) and (Stock.StockType<>StkDescCode) then
        CouldBuild:=LineBuild;

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

    end; {While..}


    // MH 20/10/2010 v6.5 ABSEXCH-2959: Added rounding as BOMId.QtyPick was coming in as 3.7999999927 instead of 3.8
    Result:=(Round_Up(CouldBuild,Syss.NoQtyDec) = Round_Up(BOMId.QtyPick,Syss.NoQtyDec));


    If (Not Result) and (Warn) then
    Begin
      mbRet:=CustomDlg(Application.MainForm,'Build Works Order','Insufficient Picked Component Stock',
                               'Not enough component stock has been picked to build '+Form_Real(BOMId.QtyPick,0,Syss.NoQtyDec)+
                       ' ' + Trim(BOMId.StockCode)+#13+#13+
                               'You must return to the Works Order and pick the correct amount of component stock.',mtWarning,[mbOK]);

    end;

  end
  else
    If (Warn) and (StatusOk) then
    Begin
      mbRet:=CustomDlg(Application.MainForm,'Build Works Order','Insufficient Picked Build Stock',
                               'No stock has been picked to build '+Trim(Id.StockCode)+#13+#13+
                               'You must return to the Works Order and pick the correct amount of stock to be built.',mtWarning,[mbOK]);

    end;

end;

{ == Function to round down could issue/build qty if qty dec places rounding would cause an inaccuracy == }
{* Should only kick in for 3 dec places max, as upto 6 was causing undesired effects the other way 33.1/0.000662 = 50,000
   but floating point maths was returning 49,999.9999999403954*}

Function  Adjust_CouldQty(QA,QM  :  Double)  :  Double;

Begin
  Result:=DivWChk(QA,QM);

  If ((Round_Up(Result,Syss.NoQtyDec)-Round_Up(Result,Syss.NoQtyDec+1))>0.0) and (Syss.NoQtyDec<=3) then
    Result:=Trunc(Result)
  else
    Result:=Round_Up(Result,Syss.NoQtyDec);
end;



{ == Function to check How much stock is available for issue == }

Function CouldBuildBOM(InvR       :  InvRec;
                   Var CouldIssue :  Boolean;
                   Var LowStock   :  Str20;
                   Var LowQty     :  Double;
                   Var LowLoc     :  Str5;
                       Mode       :  Byte)  :  Double;


Const
  Fnum2    =  IdetailF;

  Keypath2 =  IdFolioK;



Var
  KeySI,
  KeyChkI,
  GenStr  :  Str255;

  mbRet   :  Word;

  FirstLow,
  FoundOk :  Boolean;

  CouldBuild,
  QtyAvail,
  fQtyMul,
  LineBuild
          :  Double;

  LastId,
  BOMId   :  IDetail;


Begin
  Result:=0.0;  CouldIssue:=BOff;  LowStock:=''; LowQty:=0.0; FirstLow:=BOff;

  LowLoc:=''; fQtyMul:=0.0;

  KeyChkI:=FullNomKey(InvR.FolioNum);
  KeySI:=FullIdKey(InvR.FolioNum,1);

  LastId:=Id;

  Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

  FoundOk:=(StatusOk) and (Qty_OS(Id)<>0);

  CouldBuild:=-1.0;  LineBuild:=0.0; QtyAvail:=0.0;

  If (FoundOk) then
  Begin
    BOMId:=Id;

    KeySI:=FullIdKey(InvR.FolioNum,2);

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

    While (StatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) do
    With Id do
    Begin
      Application.ProcessMessages;

      If (Stock.StockCode<>StockCode) then
        If (Not Global_GetMainRec(StockF,StockCode)) then
          ResetRec(StockF);

      {$IFDEF SOP}
        Stock_LocSubst(Stock,MLocStk);

      {$ENDIF}


      QtyAvail:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR);

      If (Mode=1) then {Add whats already been picked back in}
        QtyAvail:=QtyAvail+QtyPick;

      If (QtyMul<>0.0) then {Assume 1 for zero qty per}
        fQtyMul:=QtyMul
      else
        fQtyMul:=1.0;

      LineBuild:=Adjust_CouldQty(QtyAvail,fQtyMul);

      If (LineBuild<1.0) and (Not FirstLow) then
      Begin
        FirstLow:=BOn;
        LowStock:=StockCode;
        LowQty:=QtyAVail;
        LowLoc:=MLocStk;
      end;

      If (Not Is_StdWOP) then
        CouldIssue:=(CouldIssue or (QtyPick<>0.0));

      If ((LineBuild<CouldBuild) or (CouldBuild=-1.0)) and (Qty_Os(Id)<>0.0) and (Stock.StockType<>StkDescCode) then
        CouldBuild:=LineBuild;

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeySI);

    end; {While..}


    If (CouldBuild>0.0) then
      Result:=CouldBuild;


  end;

  Id:=LastId;
end;


{ == Func to determine if BOM has anyother boms ==}

Function ContainsChildBom(StockR  :  StockRec;
                          Mode    :  Byte)  :  Boolean;

Const
    Fnum     =  PWrdF;

    Keypath  =  PWK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;


Var
    TmpOk,
    Ok2Cont  :  Boolean;

    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    OldStk   :  StockRec;

Begin
  Result:=BOff;

  OldStk:=Stock;

  With StockR do
  Begin

    KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

    KeyChk:=KeyS;

  end;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
  With Password.BillMatRec do
  Begin
    Application.ProcessMessages;

    KeySTk:=BillLink;

    Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


    Result:=(StatusOk) and (Stock.StockType=StkBillCode);

    If (Not Result) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While}

  Stock:=OldStk;
end;


{ == Proc to encode/decode Production time == }

// HM 25/06/02: Duplicated in x:\entrprse\r&d\OLESERVR.PAS
Procedure Time2Mins(Var MTime                :  LongInt;
                    Var Days,Hrs,Mins        :  Extended;
                        SetMode              :  Byte);
Var
  TimeLeft  :  Extended;
Begin
  Case  SetMode of
    0  :  Begin
            Days:=Trunc(MTime/1440);
            TimeLeft:=Round(MTime-(Days*1440));

            Hrs:=Trunc(TimeLeft/60);

            Mins:=Round(TimeLeft-(Hrs*60));
          end;

    1  :  Begin
            MTime:=Round((Days*1440)+(Hrs*60)+Mins);

          end;
  end;{Case..}
end;


Procedure CompTime2Mins(Var MTime                :  LongInt;
                        Var Days,Hrs,Mins        :  TCurrencyEdit;
                            SetMode              :  Byte);

Var
  D,H,M  :  Extended;

Begin
  D:=Days.Value; H:=Hrs.Value; M:=Mins.Value;

  Time2Mins(MTime,D,H,M,SetMode);

  If (SetMode=0) then
  Begin
    Days.Text:=''; Hrs.Text:=''; Mins.Text:='';

    Days.Value:=D; Hrs.Value:=H; Mins.Value:=M;
  end;


end;

{ == Function to return time as a string == }

Function ProdTime2Str(MTime  :  LongInt)  :  Str255;

Var
  D,H,M  :  Extended;

Function  Add_Plural(V  :  Extended)  : Str5;

Begin
  If (V>1) then
    Result:='s '
  else
    Result:=' ';
end;


Begin
  Time2Mins(MTime,D,H,M,0);

  Result:='';

  If (D<>0.0) then
  Begin
    Result:=Form_Real(D,0,0)+' day'+Add_Plural(D);
  end;

  If (H<>0.0) then
  Begin
    Result:=Result+Form_Real(H,0,0)+' hr'+Add_Plural(H);
  end;

  If (M<>0.0) then
  Begin
    If (H=0.0) or (D=0.0) then
      Result:=Result+Form_Real(M,0,0)+' min'+Add_Plural(M)
    else
      Result:=Result+Form_Real(M,0,0)+' m';

  end;

  If (Result='') then
    Result:='00-00:00';

end;


  { ========= Procedure to Generate a Document Header ======= }

  Procedure Gen_WORHed(CCode  :  Str30;
                       RNo    :  LongInt;
                       TDate  :  LongDate;
                       YRef   :  Str10;
                       Desc   :  Str20;
                       ILoc   :  Str10;
                   Var Ignore :  Boolean;
                       Mode   :  Byte);




  Const
    Fnum     =  InvF;
    Keypath  =  InvOurRefK;




  Var
    FoundOk    :  Boolean;
    FoundCode  :  Str20;

    KeyC       :  Str255;




  Begin

    Ignore:=BOn;

    With Inv do
    Begin

      ResetRec(Fnum);

      NomAuto:=BOn;

      TransDate:=TDate; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,nil);

      ILineCount:=2; {By pass line one as this is auto generated at the end}

      NLineCount:=1;

      RunNo:=RNo;

      CXrate:=SyssCurr.Currencies[Currency].CRates;

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

      OrigRates:=SyssCurr.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);
      SetTriRec(Syss.VATCurr,UseORate,VATTriR);
      SetTriRec(Currency,UseORate,OrigTriR);


      OpName:=EntryRec^.LogIn;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(Inv);

      DelTerms:=ILoc;

      InvDocHed:=WOR;

      YourRef:=YRef;

      If (Not Global_GetMainRec(CustF,CCode)) then
        ResetRec(CustF);

      CustCode:=Cust.CustCode;

      CustSupp:='W';

      TransDesc:=Desc;

      SetNextDocNos(Inv,BOn);
    end; {With..}


  end; {Proc..}



  { ============ Store Header ============ }

  Procedure Store_WORHed(Mode  :  Byte);

  Const

    Fnum     =  InvF;

    Keypath  =  InvOurRefK;


  Var
    UOR      :  Byte;

    RecAddr  :  LongInt;


  Begin
    UOR:=0;


    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    Report_BError(Fnum,Status);


  end;



{ =========== Procedure to Generate automatic Works Orders ========= }



Procedure Generate_WOR(SORInv  :  InvRec;
                       SORLine :  IDetail;
                       WorStkR :  StockRec;
                   Var B2BCtrl :  B2BInpRec;
                   Var RunCtrl :  tWORGen);



Const
  Fnum      =  IdetailF;


  Fnum2     =  PWrdF;

  Keypath2  =  PWK;

  Fnum3    =  StockF;
  Keypath3 =  StkFolioK;




Var
  KeyChk,
  KeyS,
  KeyI,
  KeyIChk    :  Str255;

  YRef,
  LastSupp   :  Str10;

  UOR,
  LastCurr   :  Byte;

  LFiltSet,
  Ok2Print,
  GotSome,
  Ok2Go,
  LOk,
  Locked,
  GotHed,
  AddDLines,
  CalledThread,
  Ignore     :  Boolean;

  LAddr,
  DocICnst,
  RecAddr    :  LongInt;

  //PR: 10/10/2014 ABSEXCH-15496 Integer to act as var keypath param in Presrv_BTPos
  LKeyPath2  :  Integer;

  Keypath,
  B_Func     :  Integer;

  FreeAll,
  CalcBOMCost,
  MatchVal   :  Double;

  MsgForm    :  TForm;

  mbRet      :  TModalResult;

  TmpInv     :  InvRec;
  TmpId      :  IDetail;

  MTExLocal  :  tdPostExLocalPtr;

  ThisScrt   :  Scratch2Ptr;

//AP 12/01/2018 ABSEXCH-19504 Amend WOP wizard to respect PII flag on UDF fields
function UDFContainsPIIData(const ACategory, AValue: Integer): Boolean;
begin
  with CustomFields do
    Result := (Field[ACategory, AValue].cfEnabled) and (not Field[ACategory, AValue].cfContainsPIIData);
end;

{ == Function to finalise WOR ==}

Procedure Finish_WOR;

Var
  HMode  :  Byte;


Function BuildStkCopNotesK  :  Str20;

Begin
  Result:=FullNCode(FullNomKey(WORStkR.StockFolio));

  Case Syss.WOPStkCopMode of
    1  :  Result:=Result+NoteCGCode;
    2  :  Result:=Result+NoteCDCode;
  end; {Case..}
end;

Begin
  HMode:=232;

  If (B2BCtrl.CopyStkNote) then
  Begin
    CopyNoteFolio(NoteSCode,NoteDCode,BuildStkCopNotesK,FullNCode(FullNomKey(Inv.FolioNum)),Inv.NLineCount);
    Inv.NLineCount:=Inv.NLineCount+WORStkR.NLineCount;
  end;

  If (B2BCtrl.ExcludeBOM) and (SORInv.OurRef<>'') then
  Begin
    CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(SORInv.FolioNum)),FullNCode(FullNomKey(Inv.FolioNum)),Inv.NLineCount);

    Inv.NLineCount:=Inv.NLineCount+SORInv.NLineCount;
  end;

  If (SORInv.OurRef<>'') then
    Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
              Inv.OurRef+' was created from '+SORInv.OurRef+' / '+SORInv.YourRef+' '+SORInv.TransDesc,
              Inv.NLineCount);

  If (Inv.NLineCount>2) then
    SetHold(HMode,Fnum,Keypath,BOff,Inv);

  Store_WORHed(0);

  Status:=GetPos(F[InvF],InvF,RecAddr);


  If (B2BCtrl.MultiMode) and (Assigned(MTExLocal)) then
  Begin
    If (Not Assigned(ThisScrt)) then
      New(ThisScrt,Init(16,MTExLocal,BOff));

    ThisScrt^.Add_Scratch(InvF,InvOurRefK,RecAddr,Inv.OurRef,Inv.OurRef);
  end;


    {* Store matching information *}

  If (SORInv.OurRef<>'') then
  Begin
    With Inv do
    Begin
      RemitNo:=SORInv.OurRef;

      Match_Payment(Inv,Round_Up(Conv_TCurr(TotalCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                ,TotalCost,23);
      RemitNo:='';
    end;

    With SORInv do
    Begin
      RemitNo:=Inv.OurRef;

      MatchVal:=Round_Up(Conv_TCurr(Inv.TotalCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

      Currency:=Inv.Currency;

      Match_Payment(SORInv,MatchVal,Inv.TotalCost,23);

      RemitNo:='';
    end;

    If (B2BCtrl.CopySORUDF) then
    With Inv do
    Begin
      //AP 12/01/2018 ABSEXCH-19504 Amend WOP wizard to respect PII flag on UDF fields
      if UDFContainsPIIData(cfSORHeader, 1) then
        DocUser1:=SORInv.DocUser1;
      if UDFContainsPIIData(cfSORHeader, 2) then
        DocUser2:=SORInv.DocUser2;
      if UDFContainsPIIData(cfSORHeader, 3) then
        DocUser3:=SORInv.DocUser3;
      if UDFContainsPIIData(cfSORHeader, 4) then
        DocUser4:=SORInv.DocUser4;
    end;
  end;



  With B2BCtrl do
    If (GenOrder<254) then
      Inc(GenOrder);

  

  GotSome:=BOn;
end;

Procedure PrimeLine;
Var
  TBo  :  Boolean;

Begin
  With Id do
  Begin
    ResetRec(Fnum);
    CustCode:=Inv.CustCode;
    CXRate:=Inv.CXRate;
    CurrTriR:=Inv.CurrTriR;

    UseORate:=Inv.UseORate;

    COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

    FolioRef:=Inv.FolioNum;

    DocPRef:=Inv.OurRef;

    IdDocHed:=Inv.InvDocHed;

    LineType:=StkLineType[IdDocHed];

    Lineno:=Inv.ILineCount;

    ABSLineNo:=Inv.ILineCount;

    {* Bring Period in line with Header *}

    Id.PPr:=Inv.AcPr;

    Id.PYr:=Inv.AcYr;

    PDate:=Inv.DueDate;

    MLocStk:=GetProfileMLoc(Cust.DefMLocStk,Stock.DefMLoc,B2BCtrl.LOCOR,Ord(Not B2BCtrl.UseDefLoc));

    If (EmptyKey(MLocStk,MLocKeyLen)) then
      MLocStk:=B2BCtrl.LOCOR;

    CCDep:=GetProfileCCDep(Cust.CustCC,Cust.CustDep,Stock.CCDep,B2BCtrl.DefCCDep,Ord(Not B2BCtrl.UseDefCCDep));

    For TBo:=BOff to BOn do
      If (EmptyKeyS(CCDep[TBo],CCKeyLen,BOff)) then
        CCDep[TBo]:=B2BCtrl.DefCCDep[TBo];
  end;

end;



Procedure StoreLine;

Begin

  Stock_Deduct(Id,Inv,BOn,BOn,0);

  If (Id.LineNo<>1) then
  With Id do
    Inv.TotalCost:=Inv.totalCost+Round_Up(Qty*CostPrice,2);

  Inc(Inv.ILineCount);


  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

  Report_BError(Fnum,Status);

end;


Begin
  //PR: 10/10/2014 ABSEXCH-15496
  LKeyPath2 := KeyPath2;

  LastSupp:='';  YRef:='';

  DocICnst:=1;  GotHed:=BOff;

  Ignore:=BOff;

  LastCurr:=0; UOR:=0;  FreeAll:=0.0;  CalcBOMCost:=0.0;

  LFiltSet:=Not EmptyKey(B2BCtrl.LocOR,LocKeyLen);

  With WORStkR do
    KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

  KeyChk:=KeyS;

  GotSome:=BOff;

  Ok2Go:=BOn;

  Ok2Print:=BOn;

  With RunCtrl do
  Begin

    ThisScrt:=ptrThisScrt;
    MTExLocal:=ptrMTExLocal;
    MsgForm:=ptrMsgForm;

  end; {With..}

  If (Not Assigned(MTExLocal)) and (B2BCtrl.MultiMode) then
  Begin
    New(MTExLocal,Create(27));

    try
      With MTExLocal^ do
        Open_System(CustF,PWrdF);

    except
      Dispose(MTExLocal,Destroy);
      MTExLocal:=nil;

    end; {Except}
  end;

  CalledThread:=BOff;

  KeyPath:=IdFolioK;

  TmpInv:=Inv;
  TmpId:=Id;

  If (Assigned(MTExLocal)) or (Not B2BCtrl.MultiMode) then
  Begin

    With B2BCtrl do
    Begin
      try
        Set_BackThreadMVisible(BOn);

        If (Not Assigned(MsgForm)) then
          MsgForm:=CreateMessageDialog('Please wait... Generating Works Order.',mtInformation,[mbAbort]);

        MsgForm.Show;
        MsgForm.Update;


        Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

        // CJS 2016-04-12 - ABSEXCH-14541 - erroneously-linked BoM components
        // Changed last parameter of CheckKey to True, for a case-sensitive
        // check as the search key contains a FullNomKey value
        While (StatusOk) and (Ok2Go) and (CheckKey(KeyChk,KeyS,Length(KeyChk),True)) do
        With Password.BillMatRec,Id do
        Begin

          //PR: 10/10/2014 ABSEXCH-15496 Save position in PWrd table
          Presrv_BTPos(Fnum2, LKeypath2, F[Fnum2], LAddr, False, False);

          B_Func:=B_GetNext;

          mbRet:=MsgForm.ModalResult;

          Loop_CheckKey(Ok2Go,mbRet);

          MsgForm.ModalResult:=mbRet;

          Application.ProcessMessages;

          KeyI:=BillLink;

          Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyI);

          If (StatusOk) then
          Begin

            {$IFDEF SOP}
               If (LFiltSet) then
                Stock_LocNSubst(Stock,LOCOR);
            {$ENDIF}

            If (Not GotHed) then
            Begin
              YRef:=SORInv.OurRef;

              If (YRef='') then
                Yref:=WORRef;

              Gen_WORHed(SuppCode,WORUPRunNo,Today,YRef,WORRef,LocOR,GotHed,0);

              Inv.DueDate:=WCompDate;
              Inv.TransDate:=WStartDate;
              Inv.Tagged:=WORTagNo;

              Inv.PORPickSOR:=(AutoPick and ((Not Is_StdWOP) or (SORInv.InvDocHed=SOR)));
            end;

            If (GotHed) then
            Begin
              PrimeLine;

              StockCode:=Stock.StockCode;
              Desc:=Stock.Desc[1];

              QtyMul:=QtyUsed;

              If (FIFO_Mode(WORStkR.StkValType)=1) or (FIFO_Mode(WORStkR.StkValType)=6) then
              Begin {If Std or last cost BOM, then Use BOM component line cost as basis of cost}
                CalcBOMCost:=Currency_ConvFT(QtyCost,WORStkR.PCurrency,Inv.Currency,UseCoDayRate);

              end
              else {Take all costs from each stock record instead}
                CalcBOMCost:=Currency_ConvFT(Calc_StkCP(Stock.CostPrice,Stock.BuyUnit,(Stock.DPackQty And Stock.CalcPack)),
                                           Stock.PCurrency,Inv.Currency,UseCoDayRate);

              CostPrice:=Round_Up(CalcBOMCost,Syss.NoCosDec);

              {CostPrice:=QtyCost;} {Do not use BOM cost as probably out of date. Replace with stock cost}

              // MH 20/10/2010 v6.5 ABSEXCH-2959: Modidifed to always round up if next value > 0, otherwise lines won't necessarily have enough stock to build the BoM
              //Qty:=Round_Up(BuildQty*QtyMul,Syss.NoQtyDec);
              Qty:=ForceRound(BuildQty*QtyMul,Syss.NoQtyDec);

              If (Stock.StockType=StkBillCode) then
                NomCode:=Stock.NomCodes[5]  {* Asjust WIP *}
              else
                NomCode:=Stock.NomCodes[4];

              If (Not Is_StdWOP) then
              Begin
                If (Stock.StockType=StkDescCode) then
                   QtyPick:=Qty
                else
                  If (FreeIssue) then {Set as free issue and auto pick if possible}
                  Begin
                    {$IFDEF SOP}
                      Stock_LocSubst(Stock,MLocStk);
                    {$ENDIF}

                    SSDUseLine:=BOn;

                    FreeAll:=(Stock.QtyInStock-Stock.QtyPicked-Stock.QtyPickWOR);

                    If (FreeAll>=Qty) then
                      QtyPick:=Qty
                    else
                      If (FreeAll>0) then
                        QtyPick:=FreeAll;

                  end;
              end;

              StoreLine;


{              SetDataRecOfs(Fnum2,LAddr);

              Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);}

             //PR: 10/10/2014 ABSEXCH-15496 Restore position in PWrd table
             Presrv_BTPos(Fnum2, LKeypath2, F[Fnum2], LAddr, True, False);

            end
            else
              B_Func:=B_GetNext;
          end;

          Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

        end; {While..}

        If (GotHed) then
        With Id do
        Begin
          {Add Line one controlling line}
          PrimeLine;

          StockCode:=WORBomCode;
          Qty:=BuildQty;
          QtyMul:=1;
          MLocStk:=LOCIR;
          CCDep:=DefCCDep;
          CostPrice:=Round_Up(DivWChk(Inv.TotalCost,Qty),Syss.NoCosDec);

          LineNo:=1;
          ABSLineNo:=1;

          {Link line 1 to originator transaction}
          SOPLink:=SORInv.FolioNum;

          SOPLineNo:=SORLine.ABSLineNo;

          If (SORInv.OurRef<>'') and (SOPLineNo<>0) then
          Begin
            MLocStk:=SORLine.MLocStk; {We have to tie up build location with final picking location}
            Desc:=SORLine.Desc;  {Tie up sales order line desc with line one desc}

            If (CopySORUDF) then {Copy over UDF details}
            Begin
              //AP 12/01/2018 ABSEXCH-19504 Amend WOP wizard to respect PII flag on UDF fields
              if UDFContainsPIIData(cfSORLine, 1) then
                LineUser1:=SORLine.LineUser1;
              if UDFContainsPIIData(cfSORLine, 2) then
                LineUser2:=SORLine.LineUser2;
              if UDFContainsPIIData(cfSORLine, 3) then
                LineUser3:=SORLine.LineUser3;
              if UDFContainsPIIData(cfSORLine, 4) then
                LineUser4:=SORLine.LineUser4;
            end;
          end
          else
            Desc:=WORStkR.Desc[1];


          NomCode:=WORStkR.NomCodes[5];


          StoreLine;

          Finish_WOR;
        end;



      Finally

        If (Not B2BCtrl.MultiMode) then
          MsgForm.Free;

        Set_BackThreadMVisible(BOff);

      end; {Try..}

    end; {With}
  end; {If Print Abort..}

  With RunCtrl do
  Begin

    ptrThisScrt:=ThisScrt;
    ptrMTExLocal:=MTExLocal;
    ptrMsgForm:=MsgForm;

    AbortRun:=Not Ok2Go;
    WORCreated:=(GotHed);
    ShowWOR:=(ShowWOR or GotHed);
  end; {With..}


  If (Not B2BCtrl.UseOnOrder) and (Not B2BCtrl.MultiMode) then
    Inv:=TmpInv;

  Id:=TmpId;


end; {Proc..}

{$IFDEF SOP}

  { == Func to check if there are sufficient serial nos available for sale == }

  Function Sno4Sale(StockFolio  :  LongInt;
                    QtyReq      :  Double;
                    Mode        :  Byte)  :  Double;

  Const
    Fnum      = MiscF;
    Keypath   = MIK;

  Var
    KeyS,KeyChk  :  Str255;
    FoundOk      :  Boolean;
    QtyFound     :  Double;

  Begin
    QtyFound:=0.0; FoundOk:=BOff;

    KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio));
    KeyS:=KeyChk+#0;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    With MiscRecs^.SerialRec do
    {$B-}
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk)  and (Not Sold) do
    {$B+}
    Begin
      If (BatchRec) then
        QtyFound:=QtyFound+(BuyQty-QtyUsed)
      else
        QtyFound:=QtyFound+1.0;

      FoundOk:=(QtyFound>=QtyReq);

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    Result:=QtyFound;
  end;


  Function CheckExsiting_WOR(OInv  :  InvRec;
                             OId   :  IDetail;
                         Var WORef :  Str10)  :  Boolean;

  Const
    Fnum      =  PWrdF;
    Fnum2     =  IdetailF;
    Keypath2  =  IdFolioK;


  Var
    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    Keypath
              :  Integer;
    KeyS,KeyChk,
    NKey,KeyI
              :  Str255;
    FoundOk   :  Boolean;


  Begin
    WORef:=''; FoundOk:=BOff;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    Begin

      With OInv do
        If ((RemitNo<>'') or (OrdMatch)) then
          Keypath:=PWK
        else
          Keypath:=HelpNDXK;

      KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OInv.OurRef);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
      With Password.MatchPayRec do
      Begin
        Case Keypath of
          PWK       :  Begin
                         NKey:=PayRef;
                       end;
          HelpNdxK  :  Begin
                         NKey:=DocCode;
                       end;
        end; {Case..}

        If (Copy(Nkey,1,3)=DocCodes[WOR]) then
        Begin
          KeyI:=NKey;

          Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI);

          If (StatusOk) then
          With Inv do
          Begin
            KeyI:=FullIdKey(FolioNum,1);

            Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyI);

            If (StatusOk) then
            With Id do
            Begin
              WORef:=OurRef;

              FoundOk:=(CheckKey(OId.StockCode,StockCode,Length(OId.StockCode),BOff) and (OID.FolioRef=SOPLink) and (OId.LineNo=SOPLineNo));

            end;
          end;

        end;

        If (Not FoundOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

    end; {With..}

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOn);

    Id:=OId;

    Result:=FoundOk;

  end;

{$ENDIF}

{$IFDEF SOPDLL}
  {$DEFINE EXDLL}
  {$UNDEF SOP}
{$ENDIF}


end. {Unit..}