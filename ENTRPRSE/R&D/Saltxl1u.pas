unit Saltxl1U;

{$I DEFOVR.INC}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,TEditVal,
  Globvar,VarConst,

  VARJCStU,

  {$IFDEF C_On}
    Custr3U,
  {$ENDIF}

  SBSComp2,
  BTSupU1;

type
  TFCustDisplay = class(TForm)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }

    CustActive  :  Boolean;
    TraderActive: Array[0..2] of Boolean;
    {$IFDEF C_On}
      CustRecForm :  TCustRec3;
      TraderRecForm:  Array[0..2] of TCustRec3;
    {$ENDIF}

    procedure Display_Account(IsCust  :  Boolean;
                              Mode    :  Byte;
                              ThisSRC :  InvRec);

    //HV 31/01/2018 2017R1 ABSEXCH-19694: Customer and Supplier share same window when the Trader record is accessed from Anonymisation Control Centre.
    //this will display separate window as per Trader type
    procedure Display_Trader(const AIsCust: Boolean;
                             const AMode: Byte;
                             AThisSRC: InvRec);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;



  end;



{ ----------------------}



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

                  // CJS 2014-08-29 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
                  Procedure EnableVATMatrix(Enable: Boolean);

                  Procedure Update_Rate(Sender  :  TObject;
                                    Var InvR    :  InvRec);
                end; {TVATMatrix..}

  TLTMatrix  =  Class(TVATMatrix)

                  Procedure AddVisiRec(RObj,
                                       GObj      :   TObject;
                                       RText     :   Str255);

                  Procedure HideLTMatrix(INAnal  :  tJALLTTypes);

                end; {TVATMatrix..}

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

                  fABSLineNo,
                  fLineNo  :  LongInt;
                  fNewAdd  :  Boolean;

                end;


  TLineDesc =  Class(TList)

                  VisiRec    :  TLDescPtr;

                  HasDesc,
                  BeenDeleted,
                  Editing    :  Boolean;

                  LdFolio,
                  LdKitLink  :  LongInt;

                  MaxCount,
                  Fnum,
                  Keypath    :  Integer;

                  DescFields :  TDescfCtrl;

                  Constructor Create;

                  Destructor Destroy;  override;


                  Procedure AddVisiRec(L    :  Str255;
                                       LNo,
                                       ABLNo:  LongInt);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  TLDescPtr;

                  Procedure SetDescFields;

                  Procedure ResetAllText;

                  Procedure GetMultiLines(RecAddr  :  LongInt;
                                          AddMode  :  Boolean);

                  Procedure StoreMultiLines(LId    :  IDetail;
                                        Var LInv   :  InvRec;
                                        Const InsertMode : Boolean);

                  Function GetUsedNo(LId  :  Idetail)  :  LongInt;

                  Procedure RenumberBy(IncX  :  Integer);

                  Procedure AssignCopy(CopyLDesc  :  TLineDesc);

                end; {TLineDesc..}

{ ---------------------------------------------------------------------}

  TPieRecPtr=  ^TPieRec;


  TPieRec   =  Record
                  PNomCode  :  LongInt;
                  PNomDesc  :  Str30;
                  PNomValue :  Double;

                  end;

  TPieList  =  Class(TList)

                  VisiRec    :  TPieRecPtr;

                  PieTotal   :  Double;

                  Destructor Destroy;  override;


                  Procedure AddVisiRec(PNOm  :  NominalRec;
                                       PV    :  Double);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  TPieRecPtr;

                  Procedure SetPieTotal;

                end; {TPieList..}

{ ---------------------------------------------------------------------}

  TSBCtrl  =  Class(TDetCtrl)


                 Procedure AddSBRec(PObj      :   TObject;
                                    HelpID    :   LongInt);


                 Procedure Reset_MainMenu;

                 Procedure Set_MainMenu;

                 Private
                   Function IdComRec(Start  :  Integer)  :  TControl;

                   Function NoneB4Visible(Start  :  Integer)  :  Boolean;
                   Procedure Adj_Others(TW,Start  :  Integer);

               end;

  TCBCtrl  =  Class(TDetCtrl)


                 Procedure AddSBRec(PObj      :   TObject;
                                    HelpID    :   LongInt);


                 Procedure Reset_MainMenu;

                 Procedure Set_MainMenu;

                 Private
                   Function IdComRec(Start  :  Integer)  :  TControl;

                   Function NoneB4Visible(Start  :  Integer)  :  Boolean;
                   Procedure Adj_Others(TW,Start  :  Integer);

               end;



Function FormatBFloat(Fmask  :  Str255;
                      Value  :  Double;
                      SBlnk  :  Boolean)  :  Str255;

Function FormatBChar(C      :  Char;
                     SBlnk  :  Boolean)  :  Str5; OverLoad;

Function FormatBChar(S      :  Str255;
                     SBlnk  :  Boolean)  :  Str5; OverLoad;

Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;

Function LComplete_CCDep(IdR    :  IDetail;
                         LineV  :  Real)  :  Boolean;

{$IFDEF PF_On}

  Function LComplete_JobAnl(IdR    :  IDetail;
                            LineV  :  Real)  :  Boolean;

  {$IFDEF SOP}
      Function LComplete_MLoc(IdR    :  IDetail)  :  Boolean;
  {$ENDIF}

{$ENDIF}


procedure CustToMemo(CRec    :  CustRec;
                 Var Memo1   :  TMemo;
                     Mode    :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ComCtrls,
  ETStrU,
  EtMiscU,
  SBSPanel,
  BtrvU2,
  BtKeys1U,
  VARRec2U,
  ComnU2,
  CurrncyU,
  InvFSu2U,
  BTSupU2,
  PWarnU,

  //PR: 03/10/2013 MRD 1.1.17
  ConsumerUtils,

  FormatFloatFuncs;


{$R *.DFM}


Function FormatBFloat(Fmask  :  Str255;
                      Value  :  Double;
                      SBlnk  :  Boolean)  :  Str255;


Begin
  // MH 03/07/2015 2015-R1: Implementation moved to new unit to make re-use easier
  // without bring in 2.5 million other units you don't want, e.g. PrntDlg2.pas!
  Result := FormatFloatFuncs.FormatBFloat(Fmask, Value, SBlnk);
end;

Function FormatBChar(C       :  Char;
                     SBlnk   :  Boolean)  :  Str5;

Begin
  If (Ord(C)>32) and (Not SBlnk) then
    Result:=C
  else
    Result:='';
end;


Function FormatBChar(S       :  Str255;
                     SBlnk   :  Boolean)  :  Str5;

Begin
  If (S<>'') and (Not SBlnk) then
    Result:=S
  else
    Result:='';
end;


Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;
Begin
  // MH 03/07/2015 2015-R1: Implementation moved to new unit to make re-use easier
  // without bring in 2.5 million other units you don't want, e.g. PrntDlg2.pas!
  Result := FormatFloatFuncs.FormatCurFloat(Fmask, Value, SBlnk, Cr);
end;


{Proc..}



procedure TFCustDisplay.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  GenCanClose(Self,Sender,CanClose,BOn);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TFCustDisplay.Send_UpdateList(Edit   :  Boolean;
                                        Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    If (Owner=Application.MainForm) then
      MSg:=WM_FormCloseMsg
    else
      MSg:=WM_CustGetRec;
      
    WParam:=Mode;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TFCustDisplay.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of

         1  :  ;

       //PR: 13/03/2014 ABSEXCH-15097. Extend to handle params 200-202 (now including consumers)

       200,
       201,
       202  :  Begin
                 CustActive:=Boff;

                 {$IFDEF C_On}
                    CustRecForm :=nil;
                    TraderActive[WParam-200]:=Boff;
                    TraderRecForm[WParam-200]:=nil;
                 {$ENDIF}

                 Send_UpDateList(BOff,18);
               end;


    end; {Case..}

  end;
  Inherited;
end;

procedure TFCustDisplay.Display_Trader(const AIsCust: Boolean; const AMode: Byte; AThisSRC: InvRec);
var
  lKey: Str255;
  CType: Integer;
begin
  {$IFDEF C_On}
    if AIsCust then
      CType := 0
    else
      CType := 2;

    if not Assigned(TraderRecForm[CType]) then
    begin
      case CType of
        0: Set_CustFormMode(CUSTOMER_TYPE);
        1: Set_CustFormMode(CONSUMER_TYPE);
        2: Set_CustFormMode(SUPPLIER_TYPE);
      end;
      TraderRecForm[CType]:=TCustRec3.Create(Self);
    end
    else
    begin
      TraderRecForm[CType].RecordMode  := AIsCust;
      TraderRecForm[CType].ListScanningOn  := True;
    end;

    try  
      TraderActive[CType] := True;
      with TraderRecForm[CType] do
      begin
        WindowState := wsNormal;
        AnonymisationON := GDPROn and (Cust.acAnonymisationStatus in [asPending, asAnonymised]);

        if AMode <> 50 then
          Show;

        if Not ExLocal.InAddEdit then
        begin
          {* Re-establish file position *}
          lKey := FullCustCode(Cust.CustCode);
          ExLocal.LGetMainRecPos(CustF, lKey);
          ShowLink;
        end;

        if (AMode In [1..3]) and (not ExLocal.InAddEdit) then
          ChangePage(0)
        else If (AMode In [10,23]) then
        begin
          SRCAlloc := (AMode = 10);
          SRCInv := AThisSRC;
          CanAllocate := (AMode = 10);
          SetTabs;
          ChangePage(LedgerPNo);
        end
        {$IFDEF SOP}
          else if (AMode In [11,13,14]) then
          begin
            ChangePage(OrdersPNo);
            ExecuteLFilter(nil, 5, AMode-10);
          end;
        {$ENDIF}
      end; {With..}
    except
     TraderActive[CType] := BOff;
     TraderRecForm[CType].Free;
    end;              
  {$ENDIF}
end;


procedure TFCustDisplay.Display_Account(IsCust  :  Boolean;
                                        Mode    :  Byte;
                                        ThisSRC :  InvRec);

Var
  FKey  :  Str255;

Begin
  {$IFDEF C_On}

    //PR: 03/10/2013 MRD 1.1.17
    Set_CustFormMode(TraderTypeFromSubType(Cust.acSubType));

    If (CustRecForm=nil) then
    Begin


      CustRecForm:=TCustRec3.Create(Self);

    end
    else
      With CustRecForm do
      Begin
        RecordMode:=IsCust;
        ListScanningOn := True;
      end;

    Try


     CustActive:=BOn;

     With CustRecForm do
     Begin

       

       WindowState:=wsNormal;
       // HV 29/11/2017 ABSEXCH-19386: Implements anonymisation behaviour for trader
       AnonymisationON := GDPROn and (Cust.acAnonymisationStatus in [asPending, asAnonymised]);

       If (Mode<>50) then
         Show;

       If (Not ExLocal.InAddEdit) then
       Begin
         {* Re-establish file position *}

         FKey:=FullCustCode(Cust.CustCode);

         ExLocal.LGetMainRecPos(CustF,FKey);

         ShowLink;
       end;


       If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0);
       end
       else
         If (Mode In [10,23]) then
         Begin
           SRCAlloc:=(Mode=10);
           SRCInv:=ThisSRC;
           CanAllocate:=(Mode=10);
           SetTabs;
           ChangePage(LedgerPNo);
         end
         {$IFDEF SOP}
           else
             If (Mode In [11,13,14]) then
             Begin
               ChangePage(OrdersPNo);

               ExecuteLFilter(nil,5,Mode-10);

             end;
         {$ENDIF}
     end; {With..}


    except

     CustActive:=BOff;

     CustRecForm.Free;

    end;

  {$ENDIF}
end;



{-----------------------}


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

// CJS 2014-08-29 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
// Enable/Disable the VAT edit fields
Procedure TVATMatrix.EnableVATMatrix(Enable: Boolean);
Var
  n: VATType;
Begin
  For n := VStart to VEnd do
    IdRec(Ord(n))^.VATD.Enabled := Enable;
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



{ ====================== TLTMatrix Methods ===================== }



Procedure TLTMatrix.AddVisiRec(RObj,
                               GObj      :   TObject;
                               RText     :   Str255);

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

      RateD.Text:=RText;

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


{ ===== Procedure to Hide non used VAT rates ===== }

Procedure TLTMatrix.HideLTMatrix(INAnal  :  tJALLTTypes);

Var
  n       :  Byte;
  NewTop  :  Integer;

Begin
  NewTop:=IdRec(0)^.GoodsD.Top;

  For n:=Low(INAnal) to High(INAnal) do
  Begin
    With IdRec(n)^ do
    Begin
      RateD.Visible:=(INAnal[n]<>0.0);
      GoodsD.Visible:=(INAnal[n]<>0.0);

      If (INAnal[n]<>0.0) then {* Re-adjust position *}
      Begin
        RateD.Top:=NewTop;
        GoodsD.Top:=NewTop;
        NewTop:=NewTop+GoodsD.Height+SpaceGap;
      end;
    end;
  end; {Loop..}
end;


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
  BeenDeleted:=BOff;
  MaxCount:=0;

end;

Destructor TLineDesc.Destroy;

Begin
  DestroyVisi;
  DescFields.Free;

  Inherited;
end;


Procedure TLineDesc.AddVisiRec(L    :  Str255;
                               LNo,
                               ABLNo:  LongInt);


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
      fABSLineNo:=ABLNo;

    end;

    Idx:=Add(NewVRec);

  except

    Dispose(NewVRec);

  end; {Except..}


  If (MaxCount<Count) then {Keep track of number added, so we can go back and only delete that many}
    MaxCount:=Count;

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
      Begin
        Dispose(VisiRec);
        List[n]:=Nil;
      end;

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


Procedure TLineDesc.ResetAllText;

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    IdRec(n).fLine:='';

  end;

  SetDescFields;

  Clear;
end;


Procedure TLineDesc.GetMultiLines(RecAddr  :  LongInt;
                                  AddMode  :  Boolean);


Var
  KeyS,
  KeyChk  :  Str255;

  Locked,
  boLoop,
  FoundOk :  Boolean;

  DelCount,
  B_Func2 :  Integer;

  B_Func  :  Array[BOff..BOn] of Integer;



Function AcceptLine  :  Boolean;
Begin

  Result:=((Id.KitLink=LDKitLink) and (Not Is_FullStkCode(Id.StockCode)) and ((Id.Qty=0.0) and (Id.NetValue=0.0))
               and ((DelCount<MaxCount) or (Not Editing) or (AddMode) or (Not boLoop)));


end;

Begin
  Locked:=BOff;

  B_Func[BOff]:=B_GetGEq;
  B_Func[BOn]:=B_GetNext;

  boLoop:=Not Editing or AddMode;

  If (AddMode) then
    Clear;

  DelCount:=0;

  KeyChk:=FullNomKey(LDFolio);

  Repeat
    If (Editing) then
    Begin
      Status:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],RecAddr,BOn,BOn);

      With Id do
        KeyS:=FullIdKey(LDFolio,LineNo);

      If (boLoop) and (Not AddMode) then
      Begin
        B_Func2:=B_GetPrev;
        B_Func[BOff]:=B_GetLessEq;
        B_Func[BOn]:=B_Func2;

      end
      else
        B_Func2:=B_GetNext;

    end
    else
    Begin
      KeyS:=FullIdKey(LDFolio,IdRec(0)^.fLineNo);

      B_Func2:=B_Func[Editing];

    end;


    Status:=Find_Rec(B_Func2,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    FoundOk:=AcceptLine;

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (FoundOk)
         and ((Count<Pred(NofSDesc)) or (Not AddMode)) do
    With Id do
    Begin

      If (AddMode) then
      Begin
        AddVisiRec(Desc,LineNo,ABSLineNo);
        MaxCount:=0; {Reset here, as we only want the count if lines added during an edit}
      end
      else
      Begin
        GetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        Report_BError(Fnum,Status);

        {DelCount:=DelCount+Ord(BoLoop);}

        Inc(DelCount);
      end;


      Status:=Find_Rec(B_Func[AddMode],F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      FoundOk:=AcceptLine;

    end; {While..}


    boLoop:=Not BoLoop;
              {* Don't bother attempting to clean up the line above its a manual line*}

  Until (Not boLoop) or (Not Editing) or (AddMode)  or (LDFolio=LDKitLink);

  If (Editing) then
    Status:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],RecAddr,BOn,BOn);

end; {Proc..}


// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
Procedure TLineDesc.StoreMultiLines(LId    :  IDetail;
                                Var LInv   :  InvRec;
                                Const InsertMode : Boolean);


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

    ABSLineNo:=IdRec(n)^.fABSLineNo;

    QtyPick:=LId.QtyPick;

    If (LineNo=0) or (IdRec(n)^.fNewAdd) then
    Begin
      LineNo:=Succ(NextNo);

	  // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
      Store_StkID(Fnum,Keypath,LInv,0,(ABSLineNo=0), InsertMode);
      Inc(LInv.ILineCount); {Move up one for insurance, other wise on an edit next line gets a duplicate value}
    end
    else
    Begin
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);


      Report_BError(Fnum,Status);
    end;

  end; {With..}

end; {Proc..}


Procedure TLineDesc.AssignCopy(CopyLDesc  :  TLineDesc);

Var
  n  :  Integer;

Begin
  If (Assigned(CopyLDesc)) then
  Begin
    CopyLDesc.Clear;

    For n:=0 to Pred(Count) do
    Begin
      CopyLDesc.AddVisiRec(IdRec(n)^.fLine,IdRec(n)^.fLineNo,IdRec(n)^.fABSLineNo);

    end;

    CopyLDesc.LDKitLink:=LDKitLink;
    CopyLDesc.Fnum:=Fnum;
    CopyLDesc.Keypath:=KeyPath;

  end;


end;


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


Procedure TLineDesc.RenumberBy(IncX  :  Integer);

Var

  n  :  Integer;

Begin

  For n:=0 to Pred(Count) do
    IdRec(n)^.fLineNo:=IdRec(n)^.fLineNo+IncX;

end;



{ ====================== TPieList Methods ===================== }

Destructor TPieList.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TPieList.AddVisiRec(PNom  :  NominalRec;
                              PV    :  Double);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      PNomCode:=PNom.NomCode;
      PNomDesc:=PNom.Desc;

      PNomValue:=PV;


    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}

Procedure TPieList.DestroyVisi;

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

Function TPieList.IdRec(Start  :  Integer)  :  TPieRecPtr;

Begin

  If (Start>Pred(Count)) then
    Start:=Pred(Count);

  Result:=List[Start];

end;


Procedure TPieList.SetPieTotal;

Var
  n  :  Integer;

Begin
  PieTotal:=0;

  For n:=0 to Pred(Count) do
    PieTotal:=PieTotal+IdRec(n)^.PNomValue;

end;



{------------ TSBCtrl Methods ------------- }

Procedure TSBCtrl.AddSBRec(PObj      :   TObject;
                           HelpId    :   LongInt);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      PanelObj:=PObj;
      ColOrder:=HelpId;
    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Function TSBCtrl.IdComRec(Start  :  Integer)  :  TControl;

Begin

  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      Result:=TControl(VisiRec^.PanelObj);

    except

      Result:=nil;

    end;
  end
  else
    Result:=nil;

end;

Function TSBCtrl.NoneB4Visible(Start  :  Integer)  :  Boolean;

Var
  n  :  Integer;

Begin
  Result := False;
  For n:=Start downto 0 do
  Begin
    Result:=Not IdComRec(n).Visible;

    If (Not Result) then
      Exit;
  end;
end;


Procedure TSBCtrl.Adj_Others(TW,Start  :  Integer);

Var
  n  :  Integer;

Begin
  For n:=Start to Pred(Count) do
  Begin
    {$B-}
    If (IdComRec(n) is TBevel) and (n>0) and (NoneB4Visible(Pred(n))) then
    With TBevel(IdComRec(n)) do
    Begin
    {$B+}
      Visible:=BOff;
      Left:=Left-TW;
    end
    else
    With IdComRec(n) do
    Begin
      Left:=Left-TW;
    end;

  end;
end;


Procedure TSBCtrl.Set_MainMenu;

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
      Begin
        If (Not IdComRec(n).Visible) or (Not ChkAllowed_In(VisiRec^.ColOrder)) then
        With IdComRec(n) do
        Begin
          Visible:=BOff;
          Adj_Others(Width,n+1);
        end;
      end;

    Except
    end; {except..}

  end;
end;


Procedure TSBCtrl.Reset_MainMenu;

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
      Begin
        If (Not IdComRec(n).Visible) then
        With IdComRec(n) do
        Begin
          Visible:=BOn;
          Adj_Others(Width*-1,n+1);
        end;
      end;

    Except
    end; {except..}

  end;
end;


{------------ TCBCtrl Methods ------------- }

Procedure TCBCtrl.AddSBRec(PObj      :   TObject;
                           HelpId    :   LongInt);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      PanelObj:=PObj;
      ColOrder:=HelpId;
    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Function TCBCtrl.IdComRec(Start  :  Integer)  :  TControl;

Begin

  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      Result:=TControl(VisiRec^.PanelObj);

    except

      Result:=nil;

    end;
  end
  else
    Result:=nil;

end;

Function TCBCtrl.NoneB4Visible(Start  :  Integer)  :  Boolean;

Var
  n  :  Integer;

Begin
  Result:=BOn;

  For n:=Start downto 0 do
  Begin
    {$B-}
    If (Not Result) or ((IdComRec(n) is TToolButton) and (TToolButton(IdComRec(n)).Style=tbsSeparator)) then
    {$B+}
      Exit;

   Result:=Not IdComRec(n).Visible;

  end;
end;


Procedure TCBCtrl.Adj_Others(TW,Start  :  Integer);

Var
  n  :  Integer;

Begin
  n:=Start;


  Begin
    {$B-}
    If (IdComRec(n) is TToolButton) and (n>0) and (TToolButton(IdComRec(n)).Style=tbsSeparator)  then
    With TToolButton(IdComRec(n)) do
    Begin
    {$B+}
      Visible:=(Not NoneB4Visible(Pred(n)));
    end;

  end;
end;


Procedure TCBCtrl.Set_MainMenu;

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
      Begin
        If (Not IdComRec(n).Visible) or (Not ChkAllowed_In(VisiRec^.ColOrder)) then
        With IdComRec(n) do
        Begin
          Visible:=BOff;
          Adj_Others(Width,n+1);
        end;
      end;

    Except
    end; {except..}

  end;
end;


Procedure TCBCtrl.Reset_MainMenu;

Var
  n  :  Integer;

Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
      Begin
        If (Not IdComRec(n).Visible) then
        With IdComRec(n) do
        Begin
          Visible:=BOn;
          Adj_Others(Width*-1,n+1);
        end;
      end;

    Except
    end; {except..}

  end;
end;


{ ======== Function to Determine if CC Dep should be completed ======= }

  Function LComplete_CCDep(IdR    :  IDetail;
                           LineV  :  Real)  :  Boolean;


  Begin

    With IdR do
      LComplete_CCDep:=((LineV<>0) or ((Syss.AutoValStk) and (Qty<>0) and (CostPrice<>0)));

  end; {Func..}


  {$IFDEF PF_On}

    { ======== Function to Determine if CC Dep should be completed ======= }

    Function LComplete_JobAnl(IdR    :  IDetail;
                              LineV  :  Real)  :  Boolean;


    Begin

      With IdR do
        LComplete_JobAnl:=((LineV<>0) and (KitLink=0) and (Not EmptyKey(JobCode,JobKeyLen)));

    end; {Func..}

    {$IFDEF SOP}
     { ======== Function to Determine if Loc code required ======= }

      Function LComplete_MLoc(IdR    :  IDetail)  :  Boolean;


      Begin

        With IdR do
          LComplete_MLoc:=((Qty<>0) and Is_FullStkCode(StockCode));

      end; {Func..}

    {$ENDIF}
  {$ENDIF}


  
procedure CustToMemo(CRec    :  CustRec;
                 Var Memo1   :  TMemo;
                     Mode    :  Byte);
Var
  n         :  Byte;

  ThisAddr  :  AddrTyp;


Begin
  With CRec,Memo1,Lines do
  Begin
    Text:=Trim(Company);

    Case Mode of
      0  :  ThisAddr:=CRec.Addr;
      1  :  ThisAddr:=CRec.DAddr;
    end; {Case..}

    For n:=1 to High(AddrTyp) do
      If (Trim(ThisAddr[n])<>'') then
        Text:=Text+#13+Trim(ThisAddr[n]);

    If (Contact<>'') then
      Text:=Text+#13+'Contact : '+Trim(Contact);

    If (Phone<>'') then
      Text:=Text+#13+'Tel: '+Trim(Phone);

    If (Phone2<>'') then
      Text:=Text+#13+'Tel: '+Trim(Phone2);

    If (Fax<>'') then
      Text:=Text+#13+'Fax: '+Trim(Fax);

  end; {With..}

end;




end.
