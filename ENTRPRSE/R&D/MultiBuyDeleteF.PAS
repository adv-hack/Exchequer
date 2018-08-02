unit MultiBuyDeleteF;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel, GlobVar, MultiBuyVar, BtKeys1U;

type
    PMBBlockDeleteParams = ^TMBBlockDeleteParams;
    TMBBlockDeleteParams = Record
      AllAccounts,
      DeleteExpired,
      UseDates : Boolean;
      AccountFilter : String[CustKeyLen];
      StockFilter : String[StkKeyLen];
      StartDate,
      EndDate   : LongDate;
      OwnerMode : Byte;
      OwnerHandle : longint;
    end;

  TfrmMBDBlockDelete = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    DelAll1: TBorCheckEx;
    DelExp1: TBorCheckEx;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure DelExp1Click(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;


    CRepParam  :  PMBBlockDeleteParams;

    procedure SetHelpContextIDs; // NF: 11/05/06
  public
    { Public declarations }
    DefFilter  :  Str20;
    MsgHandle : THandle;
  end;

Var
  QBRNo  :  Byte;

  procedure Del_MultiBuyDiscount(IdMode  :  Byte; //0 for stock, 1 for Customers, 2 for suppliers
                                 CFilt   :  Str20;
                                 AOwner  :  TComponent;
                                 MsgHandle : THandle);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  VarConst,
  ComnU2,
  BTSupU1,
  InvListU,
  RevalueU,
  SysU1,
  SysU2,
  GenWarnU,
  BTSupU2,
  ExBtTh1u,
  ExThrd2u,
  SQLUtils,
  DelQDiscU;


{$R *.DFM}

type


    TMBDiscountDelete   =  Object(TThreadQueue)

                          private
                            CRepParam  :  PMBBlockDeleteParams;
                            OHandle    :  THandle;

                            Procedure  DeleteDiscounts;

                          public
                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            function Start : Boolean;
                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                        end; {Class..}

Procedure AddMBDBlockDelete2Thread(AOwner : TComponent;
                                   FMode        :  Byte;
                                   RRepParam    :  PMBBlockDeleteParams;
                                   MessageHandle:  THandle);


Var
  tqDelete :  ^TMBDiscountDelete;

Begin

  If (Create_BackThread) then
  Begin
    New(tqDelete,Create(AOwner));

    try
      With tqDelete^ do
      Begin
        If (Start) and (Create_BackThread) then
        Begin
            OHandle:=MessageHandle;

          CRepParam^:=RRepParam^;

//          CRepParam^.FiltOrd:=FMode;

//          MTExLocal^.Open_System(CustF,MiscF);

          With BackThread do
            AddTask(tqDelete,'Del Discs');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(tqDelete,Destroy);
        end;
      end; {with..}

    except
      Dispose(tqDelete,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





procedure TfrmMBDBlockDelete.FormCreate(Sender: TObject);


Var
  HideLoc  :  Boolean;

begin
  inherited;

  ClientHeight:=183;
  ClientWidth:=299;

  RepMode:=QBRNo;

  Animated1.Visible:=BOff;

  If (RepMode=0) then
  Begin
    Label81.Visible:=BOff;
    ACFF.Visible:=BOff;
  end;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  I1TransDateF.DateValue:=Today;
  I2TransDateF.DateValue:=MaxUntilDate;

  SetLastValues;

  DelExp1Click(Nil);

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;

procedure TfrmMBDBlockDelete.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;





procedure TfrmMBDBlockDelete.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,99));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;



procedure TfrmMBDBlockDelete.DelExp1Click(Sender: TObject);
begin
  If (DelExp1.Checked) and (I1TransDateF.DateValue='') and (Assigned(Sender)) then
  Begin
    I1TransDateF.DateValue:=Today;
    I2TransDateF.DateValue:=Today;

  end;

  I1TransDateF.ReadOnly:=Not DelExp1.Checked;
  I1TransDateF.TabStop:=Not I1TransDateF.ReadOnly;

  I2TransDateF.ReadOnly:=I1TransDateF.ReadOnly;
  I2TransDateF.TabStop:=Not I1TransDateF.ReadOnly;

  If (Not DelExp1.Checked) then
    I1TransDateF.Color:=clBtnFace
  else
    I1TransDateF.Color:=clWhite;

  I2TransDateF.Color:=I1TransDateF.Color;


end;


procedure TfrmMBDBlockDelete.OkCP1BtnClick(Sender: TObject);

Var
  Ok2Cont  :  Boolean;
  sMsg : string;
  mType : TMsgDlgType;
begin
  If (Sender=OkCP1Btn) and (DelAll1.Checked) then
  Begin
    Ok2Cont:= ConfirmDeleteAllDiscounts(Self,
                                        RepMode > 0, //Customer or Supplier rather than stock
                                        DelExp1.Checked, //Use Date Range
                                        Trim(ACFF.Text) <> '', //Has a stock code
                                        sMsg, mType);

  end
  else
    Ok2Cont:=(Sender=OkCP1Btn);

  If OK2Cont then
  With CRepParam^ do
  Begin
    OKCP1Btn.Enabled:=BOff;

    If (RepMode in [1, 2]) then
    Begin
      StockFilter:=FullStockCode(ACFF.Text);


      AccountFilter:=DefFilter;

    end
    else
      StockFilter:=FullStockCode(DefFilter);


    StartDate:=I1TransDateF.DateValue;
    EndDate:=I2TransDateF.DateValue;

    AllAccounts:=DelAll1.Checked;
    UseDates:=DelExp1.Checked;

    OwnerMode := RepMode;

    AddMBDBlockDelete2Thread(Owner,RepMode,CRepParam, MsgHandle);
  end;

  inherited;

end;

procedure TfrmMBDBlockDelete.SetHelpContextIDs;
// NF: 11/05/06 Fix for incorrect Context IDs
begin
  HelpContext := 1726;
  DelExp1.HelpContext := 1727;
  DelAll1.HelpContext := 1728;
  OkCP1Btn.HelpContext := 1729;
  ClsCP1Btn.HelpContext := 1730;
  ACFF.HelpContext := 2082 // NF: 24/07/06
end;

  procedure Del_MultiBuyDiscount(IdMode  :  Byte;
                                 CFilt   :  Str20;
                                 AOwner  :  TComponent;
                                 MsgHandle : THandle);
  const
    DeleteAllMsg : Array[False..True] of String = ('Stock', 'Account');
  Var
    RepInpMsg1  :  TfrmMBDBlockDelete;

  Begin
    QBRNo:=IdMode;

    RepInpMsg1:=TfrmMBDBlockDelete.Create(AOwner);

    Try
      RepInpMsg1.DefFilter:=CFilt;
      RepInpMsg1.MsgHandle := MsgHandle;
      RepInpMsg1.DelAll1.Caption := 'Delete for All ' + DeleteAllMsg[IdMode > 0] + ' Records';
    except
      RepInpMsg1.Free;
    end; {Try..}

  end;




constructor TMBDiscountDelete.Create(AOwner: TObject);
begin
  Inherited Create(AOwner);
  New(CRepParam);

  Blank(CRepParam^,Sizeof(CRepParam^));
end;

procedure TMBDiscountDelete.DeleteDiscounts;
{$IFDEF SOP}
var
  Res,ResGroup, Idx,I : Integer;
  KeyS, KeyChk : Str255;
  StockList : TStringList;
  StkGroupCode : String;

  {Sanjay Sonani 16/02/2016 2016-R1
  ABSEXCH-16675: Process to build StockList of the Group and its sub-groups.}

  procedure ProcessGroupItems (Const AGroupCode : String);
  var
    lResult,J : Integer;
    lKey : Str255;
    lGroupCodeList : TStringList;
  Begin
    // Run through the sub-items of the group and sub-groups
    lKey := FullStockCode(AGroupCode);

    lGroupCodeList := TStringList.create;
    lGroupCodeList.Sorted := True;
    lGroupCodeList.Duplicates := dupIgnore;
    try
      lResult := MTExLocal.LFind_Rec(B_GetGEq, StockF, StkCATK, lKey);
      while (lResult = 0) And(MTExLocal.LStock.StockCat = FullStockCode(AGroupCode)) Do
      begin
        if (MTExLocal.LStock.StockType = stkGrpCode) then
        begin
          // Build a GroupList of the sub-groups.
          lGroupCodeList.Add(MTExLocal.LStock.StockCode);
        End
        Else
          StockList.Add(MTExLocal.LStock.StockCode);

        lResult := MTExLocal.LFind_Rec(B_GetNext, StockF, StkCATK, lKey);
      end;

      // Process a GroupList recursively.
      for J :=0 to lGroupCodeList.Count-1 do
      begin
        ProcessGroupItems(lGroupCodeList.Strings[J]);
      end;

    finally
      lGroupCodeList.Free;
    end;
  end;
  
   {Sanjay Sonani 16/02/2016 2016-R1
   ABSEXCH-16675:Check weather stock type is Group or Product.}

  function CheckStockTypeIsGroup():Boolean;
  begin
    Result := False;
    KeyS := FullStockCode(StkGroupCode);     
    ResGroup := MTExLocal.LFind_Rec(B_GetEq, StockF, StkCodeK, KeyS);
    Result :=  (ResGroup = 0) and (MTExLocal.LStock.StockType =  StkGrpCode) ;
  end;


  function WantToDeleteThisRec : Boolean;
  begin
    with MTExLocal^.LMultiBuyDiscount do
    Result :=  //Account check
              (CRepParam^.AllAccounts or (mbdAcCode = CRepParam^.AccountFilter)) and
               //Stock check
              (
                (Trim(CRepParam^.StockFilter) = '') or (CRepParam^.StockFilter = mbdStockCode) or((Trim(CRepParam^.AccountFilter) = '') and CRepParam^.AllAccounts)
                ) and
              //Date check
              (not CRepParam^.UseDates or
                (mbdUseDates and (mbdEndDate >= CRepParam^.StartDate) and (mbdEndDate <= CRepParam^.EndDate))
              );
  end;

   {Sanjay Sonani 16/02/2016 2016-R1
   ABSEXCH-16675:Delete Stock discount by Stock Code.}

  Procedure DeleteStockDiscount(aStock : String = '');
  begin
    if aStock <> EmptyStr then
      CRepParam^.StockFilter := FullStockCode(aStock);

    if CRepParam^.AllAccounts then
      KeyS := #33
    else
    if Trim(CRepParam^.StockFilter) <> '' then
      KeyS := CRepParam^.AccountFilter + CRepParam^.StockFilter
    else
      KeyS := CRepParam^.AccountFilter;


  //  if Length(KeyS) > CustKeyLen then
      KeyS := KeyS + BuyQuantityStringStartValue;

    with MTExLocal^ do
    begin
      Res := LFind_Rec(B_GetLessEq, MultiBuyF, Idx, KeyS);
      while (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) or CRepParam^.AllAccounts) do
      begin
        if WantToDeleteThisRec then
          LDelete_Rec(MultiBuyF, Idx);

        Res := LFind_Rec(B_GetPrev, MultiBuyF, Idx, KeyS);
      end;
    end;
  end;

{$ENDIF}                                                  
begin
{$IFDEF SOP}

  Idx := mbdAcCodeK;
  KeyChk := Emptystr;
  CRepParam^.AccountFilter := FullCustCode(CRepParam^.AccountFilter);
  StkGroupCode :=  CRepParam^.StockFilter;

  {Sanjay Sonani 12/02/2016 2016-R1
   ABSEXCH-16675:Block delete option in trader record multi-buy discounts does not work.}
   
  StockList := TStringList.Create;
  StockList.Sorted := True;
  StockList.Duplicates := dupIgnore;
  try
    if CheckStockTypeIsGroup then
    begin
      ProcessGroupItems(MTExLocal.LStock.StockCode);
      if StockList.Count <> 0 then
      begin
        for I := 0 to StockList.Count-1 do
        begin
          DeleteStockDiscount(StockList.Strings[I]);
        end;
      end;
    end
    else
      DeleteStockDiscount();
  finally
    StockList.Free;
  end;

  if CRepParam^.OwnerMode = 0 then
    PostMessage(OHandle,WM_CustGetRec,119,0)
  else
    PostMessage(OHandle,WM_CustGetRec,120,0);
{$ENDIF}
end;

destructor TMBDiscountDelete.Destroy;
begin
  Dispose(CRepParam);
  inherited;
end;

procedure TMBDiscountDelete.Finish;
begin
  PostMessage(oHandle, WM_CUSTGETREC, 121, 0);
  inherited Finish;
end;

procedure TMBDiscountDelete.Process;
begin
  InMainThread:=BOn;
  Inherited Process;
   if SQLUtils.UsingSQL then
     With MTExLocal^ do
       Open_System(MultiBuyF,MultiBuyF);
  ShowStatus(0,'Delete Multi-Buy Discount Records.');

  DeleteDiscounts;
end;

function TMBDiscountDelete.Start: Boolean;
begin
    Result := True;
    Set_BackThreadMVisible(BOff);

    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
            MTExLocal := LPostLocal;

        end
        else
        {$ENDIF}
        begin
          New(MTExLocal,Create(16));

          try
            With MTExLocal^ do
            begin
              Open_System(StockF, StockF);
              Open_System(MultiBuyF,MultiBuyF);
            end;
          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;
          end; {Except}
        end;
        Result:=Assigned(MTExLocal);
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;

end.
