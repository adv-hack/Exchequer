unit MBDFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SBSPanel, ExtGetU, CustSupU, GlobVar, BtSupU1, ExWrap1U, MultiBuyVar, BtKeys1U, SBSComp2, EntWindowSettings,
  Menus;

type
  TMultiBuyDiscountFrame = class(TFrame)
    scrMBDList: TScrollBox;
    mbdHedPanel: TSBSPanel;
    mdLabSCode: TSBSPanel;
    mdLabBuyQty: TSBSPanel;
    mdLabFreeQty: TSBSPanel;
    mdLabPurchVal: TSBSPanel;
    mdLabDisc: TSBSPanel;
    mdLabDates: TSBSPanel;
    mdPanSCode: TSBSPanel;
    mdPanBuyQty: TSBSPanel;
    mdPanDisc: TSBSPanel;
    mdPanFreeQty: TSBSPanel;
    mdPanPurchVal: TSBSPanel;
    mdPanDates: TSBSPanel;
    mbdListBtnPanel: TSBSPanel;
    mnuCopy: TPopupMenu;
    Fromanotheraccount1: TMenuItem;
    osametypeaccounts1: TMenuItem;
    procedure osametypeaccounts1Click(Sender: TObject);
    {$IFDEF SOP}
  private
    { Private declarations }
    ListOfSet : Byte;
    IsStock   : Boolean;
    FMessageHandle : THandle;
    FDiscountType : Char;
    LastCoord : Boolean;
    FAllowEdit: Boolean;
    procedure ShowDiscountDetails(DisplayMode : Byte); //0 - Add, 1 - Edit, 2 - Delete
    procedure CopyAccountDiscounts(FromCust, ToCust : Str255);
    procedure CopyStockDiscounts(FromStock, ToStock : Str255);
    procedure CopyDiscountsFromAccount;
    procedure CopyDiscountsToAccounts;
    procedure CopyDiscountsFromStock;
    procedure DeleteAllMBDiscountsForAccount(const AcCode : Str255);
    procedure CheckAccountDiscounts(const AcCode : string; cCustSupp : Char);
    procedure CheckStockDiscounts;
  public
    { Public declarations }
    //PR: 25/06/2009 Added extra parameters to let frame reload colour/font settings.
    FMulCtrl : TDDMList;
    function BuildList(const AcCode, StockCode : Str255; ExLocal : TdExLocalPtr; MsgHandle : longint;
                       SettingsKey : Char; bLastCoord : Boolean; const FSettings : IWindowSettings) : TDDMList;
    procedure RefreshCustList(const AcCode : Str255);
    procedure RefreshStockList(const StockCode : Str255);
    Function OutLine(Col  :  Byte)  :  Str255;
    procedure SetMBDButtons(ThisIsStock : Boolean);
    //procedures to be called from Button Clicks
    procedure AddDiscount;
    procedure EditDiscount;
    procedure DeleteDiscount(BlockDelete : Boolean);
    procedure CopyDiscount(CopyFrom : Boolean);
    procedure CheckDiscounts(const AcCode : string = ''; cCustSupp : Char = 'C');
    procedure SetButtons(const ButtonList : TVisiBtns; bStock : Boolean = False);
    procedure mbdResize(sbWidth, sbHeight, ListHeight : Longint);
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    property AllowEdit: Boolean read FAllowEdit write FAllowEdit;
    {$ENDIF SOP}
  end;


implementation

{$R *.dfm}

uses
{$IFDEF SOP}  StockU,{$ENDIF} SBSComp, IIFFuncs, VarConst, EtDateU, MBDiscF, BtrvU2, BtSupU2, ApiUtil, AuditNotes,
  CmpCtrlU, InvListU, {$IFDEF SOP}MultiBuyFuncs, Discu3U, {$ENDIF}

  // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  ExportListIntf;
{$IFDEF SOP}


type
  TOutlineProc = function (Col : Byte) : Str255 of Object;

  TMBDCustList = Class(TCLMList)
  private
    FMBDOutLine : TOutlineProc;
  public
    Function OutLine(Col  :  Byte)  :  Str255; override;
    Function SetCheckKey  :  Str255; Override;
    property MBDOutline : TOutlineProc read FMBDOutLine write FMBDOutLine;
  end;

  TMBDStockList = Class(TSLMList)
  private
    FMBDOutLine : TOutlineProc;
  public
    Function OutLine(Col  :  Byte)  :  Str255; override;
    Function SetCheckKey  :  Str255; Override;
    property MBDOutline : TOutlineProc read FMBDOutLine write FMBDOutLine;
  end;

var
  StockList : TMBDStockList;
  CustList : TMBDCustList;



{ TMultiBuyDiscountFrame }

procedure TMultiBuyDiscountFrame.AddDiscount;
begin
  ShowDiscountDetails(dmAdd);
end;

function TMultiBuyDiscountFrame.BuildList(const AcCode, StockCode : Str255; ExLocal : TdExLocalPtr;
                                          MsgHandle : longint; SettingsKey : Char; bLastCoord : Boolean;
                                          const FSettings : IWindowSettings) : TDDMList;
var
  StartPanel : TSBSpanel;
  n : integer;
  KeyS : Str255;
  Idx : Byte;
  KeyLen : Integer;

    procedure FindCoord(Key: Char);
    Var
      GlobComp:  TGlobCompRec;
    Begin

      New(GlobComp,Create(BOn));

      Try
        With GlobComp^ do
        Begin
          GetValues:=BOn;

          PrimeKey:=Key;

          HasCoord:=LastCoord;


          Result.Find_ListCoord(GlobComp);

        end; {With GlobComp..}

      Finally
        Dispose(GlobComp,Destroy);
      End;
    end;
begin
  StartPanel := nil;
  LastCoord := bLastCoord;
  IsStock := Trim(AcCode) = '';
  if IsStock then
  begin
    StockList := TMBDStockList.Create(Self);
    StockList.MBDOutline := Outline;

    Result := StockList;
    ListOfSet := 10;
  end
  else
  begin
    CustList := TMBDCustList.Create(Self);
    CustList.MBDOutline := Outline;
    Result := CustList;
    ListOfSet := 10;
  end;

  Result.Name := 'List_MultiBuy';
  FMessageHandle := MsgHandle;
  FMulCtrl := Result; //Store reference to Btrieve List
  with Result do
  Try
    with VisiList do
    try
      AddVisiRec(mdPanSCode, mdLabSCode);
      AddVisiRec(mdPanBuyQty, mdLabBuyQty);
      AddVisiRec(mdPanFreeQty, mdLabFreeQty);
      AddVisiRec(mdPanPurchVal, mdLabPurchVal);
      AddVisiRec(mdPanDisc, mdLabDisc);
      AddVisiRec(mdPanDates, mdLabDates);

      // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
      // MH 10/05/2018 108-R1.1 ABSEXCH-20498: Added missing metadata for cols 1, 2 and 4. Note: that the Qty columns are defined as numbers in the list
      ColAppear^[1].ExportMetadata := emtNonCurrencyAmount;
      ColAppear^[2].ExportMetadata := emtNonCurrencyAmount;
      ColAppear^[3].ExportMetadata := emtCurrencyAmount;
      ColAppear^[4].ExportMetadata := emtNonCurrencyAmount;

      VisiRec:=List[0];
      StartPanel:=(VisiRec^.PanelObj as TSBSPanel);
      SetHidePanel(FindXColOrder(0), IsStock, Bon);

      LabHedPanel := mbdHedPanel;
      SetHedPanel(ListOfSet);

    except
      VisiList.Free;
    end;


      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      Font:=StartPanel.Font;

      if IsStock then
        MUTotCols:=5
      else
        MUTotCols:=5;


      WM_ListGetRec:=WM_CustGetRec;


      MessHandle:=MsgHandle;
      Parent:=StartPanel.Parent;


      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [1..4]) then
        Begin
          DispFormat:=SGFloat;

          NoDecPlaces:=2;
        end;
      end;


      ListLocal:=ExLocal;

      if Assigned(FSettings) then
        FSettings.SettingsToParent(Result)
      else
        FindCoord(SettingsKey);

      ListCreate;



      if IsStock then
      begin
        //PR: 26/05/2009 Changed to PartStockCodeKey to work with new MultiBuy.dat
        KeyS := mbdPartStockCodeKey(AcCode, StockCode);
        KeyLen := mbdAcStockKeyLen;
      end
      else
      begin
        KeyS := FullCustCode(AcCode);
        KeyLen := Length(KeyS);
      end;
      Idx := mbdAcCodeK;

      Set_Buttons(mbdListBtnPanel);

      StartList(MultiBuyF, Idx, KeyS, '', '', KeyLen, False);

//       ReFreshList(BOn,BOff);


//      DefaultPageReSize;

  Except

    Result.Free;
    Result:=Nil;
  end;
end;

function mbdShowDoubleOrBlank(const Condition : Boolean; Value : Double) : Str255;
begin
  Result := TRim(IIF(Condition, Format('%8.2f', [Value]), ''));
end;

function mbdShowEffectiveDates(const MBD : TMultiBuyDiscount) : Str255;
begin
  with MBD do
    Result := IIF(mbdUseDates, Format('%s - %s', [POutDate(mbdStartDate), POutDate(mbdEndDate)]), '');
end;

procedure TMultiBuyDiscountFrame.CheckDiscounts(const AcCode : string = ''; cCustSupp : Char = 'C');
begin
  if IsStock then
    CheckStockDiscounts
  else
    CheckAccountDiscounts(AcCode, cCustSupp);
end;

procedure TMultiBuyDiscountFrame.CopyDiscount(CopyFrom : Boolean);
var
  ListPoint : TPoint;
begin
  If IsStock then
    CopyDiscountsFromStock
  else
  begin
    if CopyFrom then
      CopyDiscountsFromAccount
    else
      CopyDiscountsToAccounts;
  end;
end;

procedure TMultiBuyDiscountFrame.CopyDiscountsFromAccount;
var
  SCode : string;
  InpOK, FoundOK : Boolean;
  ToCust, FromCust : Str20;
  Res : Integer;
  RecAddr : longint;
begin
  InpOk:=InputQuery('Copy Discounts','Copy from which account record?',SCode);
  if InpOk then
  begin
    FoundOK := False;
    //Save position in cust file
    Res :=GetPos(F[CustF],CustF,RecAddr);
    Try
      ToCust := FullCustCode(Cust.CustCode);
      FromCust := UpperCase(Trim(SCode));
      FoundOK := (GetCust(Self,FromCust,FromCust,Cust.CustSupp = TradeCode[BOn],0));
      if FoundOK then
        CopyAccountDiscounts(FromCust, ToCust);
    Finally
      //Restore custsupp position
      SetDataRecOfs(CustF,RecAddr);
      Res := GetDirect(F[CustF],CustF,RecPtr[CustF]^,0,0);
      if FoundOK then
        RefreshCustList(ToCust);
    end;
  end;
end;

procedure TMultiBuyDiscountFrame.CopyDiscountsToAccounts;
var
  Res : Integer;
  RecAddr : longint;
  FromCust : Str255;
  AccountType : String[4];
  CustSuppType : Char;
  MsgForm : TForm;
  KeyS : Str255;
begin
  Res := msgBox('Please confirm you wish to copy these discounts to the same type accounts.',
      mtConfirmation,[mbYes,mbNo], mbYes, 'Confirm');
  if Res = mrYes then
  begin
    CustSuppType := Cust.CustSupp;
    AccountType := Cust.RepCode;
    //Save position in cust file
    Res :=GetPos(F[CustF],CustF,RecAddr);
    if Res = 0 then
    begin
      MsgForm:=CreateMessageDialog('Please Wait.... Updating discounts.',mtInformation,[mbAbort]);
      Try
        FromCust := Cust.CustCode;
        KeyS := CustSuppType;

        MsgForm.Show;
        MsgForm.Update;
        Screen.Cursor := crHourglass;
        Res := Find_Rec(B_GetGEq, F[CustF], CustF, Cust, ATCodeK, KeyS);
        while (Res = 0) and (Cust.CustSupp = CustSuppType) do
        begin
          if (Cust.CustCode <> FromCust) and (Cust.RepCode = AccountType) then
          begin
            DeleteAllMBDiscountsForAccount(Cust.CustCode);

            CopyAccountDiscounts(FromCust, Cust.CustCode);
          end;

          Res := Find_Rec(B_GetNext, F[CustF], CustF, Cust, ATCodeK, KeyS);
        end;
      Finally
        MsgForm.Free;
        Screen.Cursor := crDefault;
        //Restore custsupp position
        SetDataRecOfs(CustF,RecAddr);
        Res := GetDirect(F[CustF],CustF,RecPtr[CustF]^,0,0);
      End;
    end;
  end; //Res = mrYes
end;

procedure TMultiBuyDiscountFrame.DeleteDiscount(BlockDelete : Boolean);
begin
  if not BlockDelete then
    ShowDiscountDetails(dmDelete)
  else
  begin
    with TMultiBuyFunctions.Create do
    Try
      BlockDelete(IsStock, Self, FMessageHandle);
    Finally
      Free;
    End;

  end;
end;

procedure TMultiBuyDiscountFrame.EditDiscount;
begin
  if AllowEdit then
    ShowDiscountDetails(dmEdit);
end;

function TMultiBuyDiscountFrame.OutLine(Col: Byte): Str255;
begin
  with MultiBuyDiscount do
  begin
    Case Col of
      0 : If not IsStock then
            Result := mbdStockCode
          else
            Result := '';
      1 : Result := mbdShowDoubleOrBlank(True, mbdBuyQty);
      2 : Result := mbdShowDoubleOrBlank(mbdDiscountType = mbtGetFree, mbdRewardValue);
      {$IFDEF MC_ON}
      3 : Result := IIF(mbdDiscountType = mbtForAmount, TxLatePound(Trim(SyssCurr.Currencies[mbdCurrency].SSymb), True), '') +
                        mbdShowDoubleOrBlank(mbdDiscountType = mbtForAmount, mbdRewardValue);
      {$ELSE}   //PR: 09/07/2009 Remove currency symbol from Single Currency version
      3 : Result := mbdShowDoubleOrBlank(mbdDiscountType = mbtForAmount, mbdRewardValue);
      {$ENDIF}
      4 : Result := mbdShowDoubleOrBlank(mbdDiscountType = mbtGetPercentOff, mbdRewardValue * 100);
      5 : Result := mbdShowEffectiveDates(MultiBuyDiscount);
    end;
  end;
  Result := Trim(Result);
end;

procedure TMultiBuyDiscountFrame.RefreshCustList(const AcCode: Str255);
begin
  CustList.StartList(MultiBuyF, mbdAcCodeK, FullCustCode(AcCode), '', '', Length(AcCode), False);
end;

procedure TMultiBuyDiscountFrame.SetButtons(const ButtonList : TVisiBtns; bStock : Boolean = False);
const
  //Number of buttons on each form (excluding OK, Cancel, Close but including Custom Buttons on Customer - on Stock, custom btns have already been set.)
  CustButtonCount = 30;
  StockButtonCount = 17;

  CustButtonSet = [0, 1, 3, 17, 19];
  StockButtonSet = [0, 1, 3, 10, 11];
var
  i : integer;
begin
  IsStock := bStock;
  if IsStock then
  begin
    for i := 0 to StockButtonCount - 1 do
      ButtonList.SetHideBtn(i, not (i in StockButtonSet), i = StockButtonCount - 1);
  end
  else
    for i := 0 to CustButtonCount - 1 do
      ButtonList.SetHideBtn(i, not (i in CustButtonSet), i = CustButtonCount - 1);
end;

procedure TMultiBuyDiscountFrame.SetMBDButtons(ThisIsStock: Boolean);
begin

end;

procedure TMultiBuyDiscountFrame.ShowDiscountDetails(DisplayMode: Byte);
var
  Res, LockRes : Integer;
  RecAddr : longint;
  Idx : Byte;
  OKToContinue : Boolean;
  KeyS : Str255;
begin
  Res := 0;
  OKToContinue := True;
{  If IsStock then
    idx := mbdStockK
  else}
    Idx := mbdAcCodeK;
  if DisplayMode = dmAdd then
  begin
    FillChar(MultiBuyDiscount, SizeOf(MultiBuyDiscount), 0);
    if not IsStock then
    begin
      MultiBuyDiscount.mbdAcCode := FullCustCode(Cust.CustCode);
      MultiBuyDiscount.mbdOwnerType := Cust.CustSupp;
    end
    else
    begin
      MultiBuyDiscount.mbdAcCode := FullCustCode('');
      MultiBuyDiscount.mbdOwnerType := 'T';
    end;
  end
  else
  begin //Reread and lock record
    Res :=GetPos(F[MultiBuyF],MultiBuyF,RecAddr);
    SetDataRecOfs(MultiBuyF,RecAddr);

    Res := GetDirect(F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,Idx,B_SingNWLock);
    if Res in [84, 85] then
    repeat
      LockRes := msgBox('Record in use by another station', mtConfirmation, [mbCancel, mbRetry], mbCancel, 'Confirm');

      if LockRes <> mrCancel then
        Res := GetDirect(F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,Idx,B_SingNWLock);
    Until (LocKRes = mrCancel) or (Res = 0);

    OKToContinue := Res = 0;
  end;

  if OKToContinue then
  begin
    frmMBDDetails := TfrmMBDDetails.Create(Parent);
    frmMBDDetails.IsStock := IsStock;
    with frmMBDDetails do
    Try
      Case DisplayMode of
        dmAdd : Caption := 'Add';
        dmEdit : Caption := 'Edit';
        dmDelete : Caption := 'Delete';
      end;
      DispMode := DisplayMode;
      Caption := Caption + ' Multi-Buy Discount';
      RecordToForm(MultiBuyDiscount, DisplayMode = dmAdd);
      WantDelete := DisplayMode = dmDelete;
      ShowModal;
      if (ModalResult = mrOK) or ((DisplayMode = dmDelete) and DoDelete) then
      begin
        FormToRecord(MultiBuyDiscount);
        Case DisplayMode of
          dmAdd    :  Res := Add_Rec(F[MultiBuyF], MultiBuyF, MultiBuyDiscount, Idx);
          dmEdit   :  Res := Put_Rec(F[MultiBuyF], MultiBuyF, MultiBuyDiscount, Idx);
          dmDelete :  Res := Delete_Rec(F[MultiBuyF], MultiBuyF, Idx);
        end; //Case

        //PR: 22/11/2011 Added audit notes for parent account or stock record.
        if IsStock then
        begin
          if Res = 0 then
            TAuditNote.WriteAuditNote(anStock, anEdit);
          RefreshStockList(MultiBuyDiscount.mbdStockCode);
        end
        else
        begin
          if Res = 0 then
            TAuditNote.WriteAuditNote(anAccount, anEdit);
          RefreshCustList(MultiBuyDiscount.mbdAcCode);
        end;
      end
      else
      begin
        if DisplayMode in [dmEdit, dmDelete] then
          Res := Find_Rec(B_Unlock, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, Idx, KeyS);
      end;
    Finally
      Free;
    End;
  end;
end;

procedure TMultiBuyDiscountFrame.WMCustGetRec(var Message: TMessage);
begin
  if (Message.WParam = 0) and AllowEdit then
  begin
    CustList.GetSelRec(False);
    EditDiscount;
  end;
  inherited;
end;

procedure TMultiBuyDiscountFrame.DeleteAllMBDiscountsForAccount(
  const AcCode: Str255);
var
  KeyS, KeyChk: Str255;
  Res : Integer;
begin
  KeyS := FullCustCode(AcCode);
  KeyChk := KeyS;

  Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
  while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
  begin
    Res := Delete_Rec(F[MultiBuyF], MultiBuyF, mbdAcCodeK);

    Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
  end;
end;

procedure TMultiBuyDiscountFrame.CopyAccountDiscounts(FromCust, ToCust: Str255);
var
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  KeyS := FullCustCode(FromCust);
  if KeyS <> FullCustCode(ToCust) then
  begin
    KeyChk := KeyS;
    Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    begin
      MultiBuyDiscount.mbdAcCode := ToCust;
      Res := Add_Rec(F[MultiBuyF], MultiBuyF, MultiBuyDiscount, -1); //-1 to keep position on from record

      Res := Find_Rec(B_GetNext, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    end;
  end;
end;

procedure TMultiBuyDiscountFrame.CheckAccountDiscounts(const AcCode : string; cCustSupp : Char);
var
  UPrice : Double;
begin
  Screen.Cursor := crHourglass;
  with TMultiBuyFunctions.Create do
  Try
    CheckPricesForAccount(AcCode);
  Finally
    Free;
    Screen.Cursor := crDefault;
  End;
end;

procedure TMultiBuyDiscountFrame.mbdResize(sbWidth, sbHeight,
  ListHeight: Integer);
begin
  if Align = alNone then
  begin
    Width := Parent.Width - 4;
    //TG 15-05-2017 ABSEXCH-15353 have redesigned stock screen, MultiBuyDiscount tab's scrollbar is displayed properly
    Height := Parent.Height - 3; //PR: 19/06/2009 On Stock Record ScrollBar wasn't showing completely
  end;
  scrMBDList.Width := sbWidth;
  scrMBDList.Height := sbHeight;
  mbdListBtnPanel.Height := ListHeight;
  mbdListBtnPanel.Left := scrMBDList.Left + scrMBDList.Width + 1;
  if Assigned(FMulCtrl) then
  With FMULCtrl,VisiList do
  Begin
    VisiRec:=List[0];

    With (VisiRec^.PanelObj as TSBSPanel) do
      Height:=ListHeight;

    ReFresh_Buttons;

    RefreshAllCols;
  end;
end;

procedure TMultiBuyDiscountFrame.RefreshStockList(const StockCode: Str255);
var
  KeyS : Str255;
  KeyLen : Integer;
begin
  KeyS := mbdPartStockCodeKey('', StockCode);
  StockList.StartList(MultiBuyF, mbdAcCodeK, KeyS, '', '', mbdAcStockKeyLen, False);
end;

procedure TMultiBuyDiscountFrame.CopyDiscountsFromStock;
var
  SCode : string;
  InpOK, FoundOK : Boolean;
  ToStock, FromStock : Str20;
  Res : Integer;
  RecAddr : longint;
begin
  InpOk:=InputQuery('Copy Discounts','Copy from which Stock record?',SCode);
  if InpOk then
  begin
    FoundOK := False;
    //Save position in cust file
    Res :=GetPos(F[StockF],StockF,RecAddr);
    Try
      ToStock := FullStockCode(Stock.StockCode);
      FromStock := UpperCase(Trim(SCode));
      FoundOK := (GetStock(Self,FromStock,FromStock,0));
      if FoundOK then
        CopyStockDiscounts(FromStock, ToStock);
    Finally
      //Restore Stocksupp position
      SetDataRecOfs(StockF,RecAddr);
      Res := GetDirect(F[StockF],StockF,RecPtr[StockF]^,0,0);
      if FoundOK then
        RefreshStockList(ToStock);
    end;
  end;
end;

procedure TMultiBuyDiscountFrame.CopyStockDiscounts(FromStock,
  ToStock: Str255);
var
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  KeyS := mbdStockCodeKey('', FromStock);
  if Trim(FromStock) <> Trim(ToStock) then
  begin
    KeyChk := Copy(KeyS, 1, mbdAcStockKeyLen);
    Res := Find_Rec(B_GetLessEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    begin
      MultiBuyDiscount.mbdStockCode := ToStock;
      Res := Add_Rec(F[MultiBuyF], MultiBuyF, MultiBuyDiscount, -1); //-1 to keep position on from record

      Res := Find_Rec(B_GetPrev, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    end;
  end;
end;

procedure TMultiBuyDiscountFrame.CheckStockDiscounts;
var
  UPrice : Double;
begin
  Screen.Cursor := crHourglass;
  with TMultiBuyFunctions.Create do
  Try
    CheckPricesForStock(Stock.StockCode);
  Finally
    Free;
    Screen.Cursor := crDefault;
  End;
end;


{ TMBDCustList }

function TMBDCustList.OutLine(Col: Byte): Str255;
begin
  if Assigned(FMBDOutline) then
    Result := FMBDOutline(Col);
end;

function TMBDCustList.SetCheckKey: Str255;
begin
  Result := FullCustCode(Cust.CustCode);
end;

{ TMBDStockList }

function TMBDStockList.OutLine(Col: Byte): Str255;
begin
  if Assigned(FMBDOutline) then
    Result := FMBDOutline(Col);
end;

function TMBDStockList.SetCheckKey: Str255;
begin
  Result := FullCustCode('') + FullStockCode(Stock.StockCode);
end;
{$ENDIF}

procedure TMultiBuyDiscountFrame.osametypeaccounts1Click(Sender: TObject);
begin
{$IFDEF SOP}
  CopyDiscountsToAccounts;
{$ENDIF}
end;

end.
