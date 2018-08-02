unit mbdLineFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, MultiBuyVar, MultiBuyFuncs, ExWrap1U, VarConst;

type
  TMultiBuyDiscountLineFrame = class(TFrame)
    lblMBDDesc: TLabel;
    UpDown1: TUpDown;
    edtMBDQty: TEdit;
    Label2: TLabel;
    lblX: TLabel;
    lblMBDValue: TLabel;
    procedure edtMBDQtyChange(Sender: TObject);
    procedure edtMBDQtyExit(Sender: TObject);
  private
    { Private declarations }
    FMBDFuncs : TMultiBuyFunctions;
    FMBDHolder : TMultiBuyDiscountHolder;
    FExistingQty : Double;
    FExLocal : TdExLocalPtr;
    FDiscountValue : Double;
    FOnQtyChange : TNotifyEvent;
    FLockUpdate : Boolean;
    FId : IDetail;
    function GetQty: Integer;
    function GetTotalQty: Double;
  public
    { Public declarations }
    procedure SetEnabled(BuyQty : Double);
    procedure SetQty(BuyQty : Double);
    property MBDFuncs : TMultiBuyFunctions read FMBDFuncs write FMBDFuncs;
    property MBDHolder : TMultiBuyDiscountHolder read FMBDHolder write FMBDHolder;
    property Qty : Integer read GetQty;
    property TotalQty : Double read GetTotalQty;
    property ExLocal : TdExLocalPtr read FExLocal write FExLocal;
    property DiscountValue : Double read FDiscountValue write FDiscountValue;
    property OnQtyChange : TNotifyEvent read FOnQtyChange write FOnQtyChange;
    property LockUpdate : Boolean read FLockUpdate write FLockUpdate;
    property IDRec : IDetail read FId write FId;
  end;

  TMBDFramesController = Class
  private
    FMBDFunctions : TMultiBuyFunctions;
    FScrollBox : TScrollBox;
    FStockCode : String;
    FAcCode : String;
    FStartYPos : Integer;
    FExLocal : TdExLocalPtr;
    FList : TStringList;
    FCurrentList : TStringList;
    FFirstEnabledEdit : TWinControl;
    FFirstEnabledFrame : TMultiBuyDiscountLineFrame;
    FTotalDiscountValue : Double;
    FOnValueChanged : TNotifyEvent;
    FDiscountChar : Char;
    FFrameCount, FTotalFrames : Integer;
    FFrameHeight : Integer;
    FLockUpdate : Boolean;
    FCurrentId : IDetail;
    FIsSales : Boolean;
    FHelpContext : Integer;
    FEnabled : Boolean;
    function FrameEnabled(AComponent : TObject) : Boolean;
    procedure EnableFrame(AComponent : TObject; Value : Boolean);
    function GetDiscountCount: Integer;
    procedure SetStockCode(const Value: string);
    function ConsolidatedToCurrency(Value : Double) : Double;
    procedure SetEnabled(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function AddMBDLineFrames(const sCustCode, sStockCode, sTransDate : string; Currency : Integer; BuyQty : Double = 0) : Integer;
    procedure ClearFrames;
    procedure UpdateValues(BuyQty, NetValue : Double; AnID : IDetail);
    procedure EnableFrames(BuyQty : Double);
    procedure UpdateQuantities(BuyQty : Double);
    procedure FrameQtyChanged(Sender : TObject);
    procedure CalcTotal;
    function TotalBuyQty : Double;
    function GetDiscountLineStrings : TStringList;
    procedure GetUnitDiscountValue(var DiscValue : Double; var DiscChar : Char);
    function GetAllTotalDiscounts : Double;
  {$IFNDEF TRADE}
    // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
    procedure AddMultiBuyDiscountLines(var InvR: InvRec;
                                           IDR: IDetail;
                                           StockFolio : longint;
                                           NoOfDeletedLines : Integer;
                                       Const InsertMode : Boolean = False);
  {$ENDIF}
    function DeleteDescLines(const LID : IDetail) : Integer;
    property MBDFunctions : TMultiBuyFunctions read FMBDFunctions write FMBDFunctions;
    property ScrollBox : TScrollBox read FScrollBox write FScrollBox;
    property StartYPos : Integer read FStartYPos write FStartYPos;
    property ExLocal : TdExLocalPtr read FExLocal write FExLocal;
    property FirstEnabledEdit : TWinControl read FFirstEnabledEdit write FFirstEnabledEdit;
    property TotalDiscountValue : Double read FTotalDiscountValue write FTotalDiscountValue;
//    property UnitDiscountValue : Double read GetUnitDiscountValue;
    property OnValueChanged : TNotifyEvent read FOnValueChanged write FOnValueChanged;
    property DiscountChar : Char read FDiscountChar;
    property DiscountCount : Integer read GetDiscountCount;
    property StockCode : string read FStockCode write SetStockCode;
    property FrameHeight : Integer read FFrameHeight;
    property IsSales : Boolean read FIsSales write FIsSales;
    property HelpContext : Integer read FHelpContext write FHelpContext;
    property Enabled : Boolean read FEnabled write SetEnabled;
  end;



implementation

{$R *.dfm}
uses
  EtMiscU, {InvFSu2U,} BtrvU2, CurrncyU, Sysu2, Comnunit, BtKeys1U, BtSupU1

  {$IFDEF TRADE}
    , TCMEntFuncs;
  {$ELSE}
    , InvFSU3U, InvFSu2U;
  {$ENDIF}


{ TMBDFramesController }

function TMBDFramesController.AddMBDLineFrames(const sCustCode, sStockCode, sTransDate : string; Currency : Integer; BuyQty : Double = 0) : Integer;
var
  i, j : Integer;
  AFrame : TMultiBuyDiscountLineFrame;
  AList, FrameList  : TStringList;
  ThisFrameCount : Integer;
begin
  Result := 0;
  if Assigned(FMBDFunctions) then
  begin
    AList := FMBDFunctions.GetMultiBuyList(sCustCode, sStockCode, sTransDate, FExLocal, Currency, False, FIsSales);
    FrameList := TStringList.Create;
    Try
      Result := AList.Count;
      FFrameCount := Result;
      ThisFrameCount := 0;

      for i := 0 to AList.Count - 1 do
      begin
        //BuyQty will be 0 when this is called from a transaction line; in that case we want all valid mds for this cust/stock combination.
        //If BuyQty is > 0 then it's been called from the telesales form at a point when line qtys can no longer be changed - so
        //we only need the valid mbds for this qty or less
        if (BuyQty = 0) or ((AList.Objects[i] as TMultiBuyDiscountHolder).MBDRec.mbdBuyQty <= BuyQty) then
        begin
          inc(FTotalFrames);
          AFrame := TMultiBuyDiscountLineFrame.Create(FScrollBox);
          AFrame.Parent := FScrollBox;
          AFrame.Name := 'mbdLineFrame' + IntToStr(FTotalFrames);
          AFrame.Left := 1;
          AFrame.Width := FScrollBox.Width - 8;
          AFrame.Top := FStartYPos + (ThisFrameCount * AFrame.Height);
          inc(ThisFrameCount);
          FFrameHeight := AFrame.Height;
          AFrame.lblMBDDesc.Caption := AList[i];
          AFrame.MBDHolder := AList.Objects[i] as TMultiBuyDiscountHolder;
          AFrame.MBDHolder.LineUnitPrice := ExLocal.LId.NetValue;
          AFrame.MBDFuncs := FMBDFunctions;
          AFrame.ExLocal := FExLocal;
          AFrame.edtMBDQtyChange(Self);
          AFrame.IDRec := FExLocal.LId;
          AFrame.HelpContext := FHelpContext;
          AFrame.HelpType := htContext;
          for j := 0 to AFrame.ControlCount - 1 do
          begin
            AFrame.Controls[j].HelpContext := FHelpContext;
            AFrame.Controls[j].HelpType := htContext;
          end;
          if BuyQty = 0 then
            AFrame.OnQtyChange := FrameQtyChanged
          else
            AFrame.OnQtyChange := FOnValueChanged;
          AFrame.LockUpdate := False;

          FrameList.AddObject(AList[i], AFrame);
        end
        else
          Dec(Result);
      end;
    Finally
      FList.AddObject(sStockCode, FrameList);
    End;
  end;
end;

procedure TMBDFramesController.ClearFrames;
var
  i : Integer;
begin
  if Assigned(FCurrentList) then
  for i := FCurrentList.Count - 1 downto 0 do
    if FCurrentList.Objects[i] is TMultiBuyDiscountLineFrame then
    begin
     (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).MBDHolder.Free;
      FCurrentList.Objects[i].Free;
    end;

end;

constructor TMBDFramesController.Create;
begin
  inherited;
  FMBDFunctions := TMultiBuyFunctions.Create;
  FList := TStringList.Create;
  FTotalFrames := 0;
  FLockUpdate := False;
end;

destructor TMBDFramesController.Destroy;
var
  i : integer;
begin
  FMBDFunctions.Free;
  for i := 0 to FList.Count - 1 do
  begin
    if FList.Objects[i] is TStringList then
    begin
      FCurrentList := FList.Objects[i] as TStringList;
      ClearFrames;
    end;
  end;
  FList.Free;
  inherited;
end;

procedure TMultiBuyDiscountLineFrame.edtMBDQtyChange(Sender: TObject);
begin
  if not FLockUpdate then
  begin
    if edtMBDQty.Enabled and Assigned(FMBDFuncs) then
    begin
      FMBDFuncs.MBDRec := FMBDHolder.MBDRec;
      FDiscountValue :=  FMBDFuncs.ValueOfDiscount(FId, Qty);
    end
    else
      FDiscountValue := 0;

    lblMBDValue.Caption := Format('%8.2f', [FDiscountValue]);
    if Assigned(FOnQtyChange) and not FLockUpdate then
      FOnQtyChange(Self);
  end;
end;

procedure TMBDFramesController.UpdateValues(BuyQty, NetValue : Double; AnID : IDetail);
var
  i : integer;
  StoreList : TStringList;
begin
  if Assigned(FCurrentList) then
  begin

    for i := 0 to FCurrentList.Count - 1 do
    if FrameEnabled(FCurrentList.Objects[i]) then
      begin
        //PR: 20/08/2009 When more than one stock code on Telesales form, FCurrentList was getting lost - save and restore it.
        StoreList := FCurrentList;
       (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).IDRec := AnId;
       (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).MBDHolder.LineUnitPrice := NetValue;
       (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).edtMBDQtyChange(Self);
       FCurrentList := StoreList;
      end;
  end;
end;

procedure TMBDFramesController.EnableFrames(BuyQty : Double);
var
  i : integer;
begin
  FFirstEnabledEdit := nil;
  FFirstEnabledFrame := nil;
  if Assigned(FCurrentList) then
  begin
    for i := 0 to FCurrentList.Count - 1 do
      if FCurrentList.Objects[i] is TMultiBuyDiscountLineFrame then
      begin
        (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).SetEnabled(BuyQty);
        if not Assigned(FFirstEnabledEdit) and (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).edtMBDQty.Enabled then
        begin
          FFirstEnabledEdit :=  (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).edtMBDQty;
          FFirstEnabledFrame := FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame;
        end;
      end;
  end;
end;

procedure TMultiBuyDiscountLineFrame.edtMBDQtyExit(Sender: TObject);
begin
  FExistingQty := StrToFloatDef(edtMBDQty.Text, 0);
end;

function TMultiBuyDiscountLineFrame.GetQty: Integer;
begin
  Result := StrToIntDef(edtMBDQty.Text, 0);
end;

function TMultiBuyDiscountLineFrame.GetTotalQty: Double;
begin
  FMBDFuncs.MBDRec := MBDHolder.MBDRec;
  Result := FMBDFuncs.DiscountQty * Qty;
end;

procedure TMultiBuyDiscountLineFrame.SetEnabled(BuyQty: Double);
begin
  FMBDFuncs.MBDRec := MBDHolder.MBDRec;
  edtMBDQty.Enabled := FMBDFuncs.DiscountAvailable(BuyQty);
  if not edtMBDQty.Enabled then
    edtMBDQty.Text := FloatToStr(0);
  edtMBDQty.Refresh;
  Updown1.Refresh;
end;


procedure TMultiBuyDiscountLineFrame.SetQty(BuyQty: Double);
var
  TmpQty : Double;
begin
  FLockUpdate := True;
  FMBDFuncs.MBDRec := FMBDHolder.MBDRec;
  if edtMBDQty.Enabled then
  begin
    TmpQty := 0;
    if (BuyQty > 0) then
    begin
      if BuyQty >= FMBDFuncs.DiscountQty then
      begin
        while BuyQty >= FMBDFuncs.DiscountQty do
        begin
          TmpQty := TmpQty + 1;
          edtMBDQty.Text := FloatToStr(TmpQty);
          BuyQty := BuyQty - FMBDFuncs.DiscountQty;
        end;
      end
      else
        edtMBDQty.Text := FloatToStr(0);
    end
    else
      edtMBDQty.Text := FloatToStr(0);
  end
  else
    edtMBDQty.Text := FloatToStr(0);
  FLockUpdate := False;
end;

procedure TMBDFramesController.UpdateQuantities(BuyQty : Double);
var
  i : integer;
begin
  if Assigned(FCurrentList) then
    for i := 0 to FCurrentList.Count - 1 do
    if FrameEnabled(FCurrentList.Objects[i]) then
    begin
      (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).LockUpdate := True;
     (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).SetQty(BuyQty);
      (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).LockUpdate := False;

      if BuyQty > 0 then
        BuyQty := BuyQty - (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).TotalQty;
    end;
end;

procedure TMBDFramesController.FrameQtyChanged(Sender: TObject);
begin
  CalcTotal;
end;

procedure TMBDFramesController.CalcTotal;
var
  i : integer;
begin
  FTotalDiscountValue := 0;
  if Assigned(FCurrentList) then
    for i := 0 to FCurrentList.Count - 1 do
      if FrameEnabled(FCurrentList.Objects[i]) then
         FTotalDiscountValue := FTotalDiscountValue + (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).DiscountValue;

  if Assigned(FOnValueChanged) and not FLockUpdate then
    FOnValueChanged(Self);
end;

function TMBDFramesController.TotalBuyQty: Double;
var
  i : integer;
begin
  Result := 0;
  if Assigned(FCurrentList) then
    for i := 0 to FCurrentList.Count - 1 do
      if FrameEnabled(FCurrentList.Objects[i]) then
         Result := Result + (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).TotalQty;
end;

function TMBDFramesController.FrameEnabled(
  AComponent: TObject): Boolean;
begin
  Result := (AComponent is TMultiBuyDiscountLineFrame) and (AComponent as TMultiBuyDiscountLineFrame).edtMBDQty.Enabled;
end;

procedure TMBDFramesController.GetUnitDiscountValue(var DiscValue : Double; var DiscChar : Char);
var
  iDP : Integer;
  TempQty : Double;
begin
  if Assigned(FCurrentList) and Assigned(FFirstEnabledFrame) then
  begin
    if (DiscountCount = 1) and (FDiscountChar = '%') then
    begin
      DiscValue := FFirstEnabledFrame.MBDHolder.MBDRec.mbdRewardValue;
      DiscChar := '%'
    end
    else
    begin

 //PR: 19/06/2009 Wasn't working for split packs
      if not Stock.CalcPack then
        TempQty := Ea2Case(FFirstEnabledFrame.IdRec, Stock, FFirstEnabledFrame.IdRec.Qty)
      else
      if not Stock.DPackQty  then
        TempQty := FFirstEnabledFrame.IdRec.Qty * FFirstEnabledFrame.IdRec.QtyPack
      else
        TempQty := FFirstEnabledFrame.IdRec.Qty;
      if TempQty <> 0 then
        DiscValue := FTotalDiscountValue / TempQty
      else
        DiscValue := 0;
      DiscChar := #0;
    end;

  end
  else
  begin
    DiscValue := 0;
    DiscChar := #0;
  end;
end;

function TMBDFramesController.GetDiscountCount: Integer;
var
  i : integer;
begin
  Result := 0;
  if Assigned(FCurrentList) then
    for i := 0 to FCurrentList.Count - 1 do
      if FrameEnabled(FCurrentList.Objects[i]) and ((FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).Qty > 0) then
        inc(Result);
end;

//Returns a list of description strings for the description lines to be added
function TMBDFramesController.GetDiscountLineStrings: TStringList;
var
  i : integer;

  function InsertStockCode(const s : string) : string;
  var
    j : Integer;
  begin
    Result := s;
    j := 5;
    while (Result[j] <> ' ') do inc(j);
      //Insert(Trim(FExLocal.LId.StockCode) + ' ', Result, j + 1);
      Insert(Trim(FStockCode) + ' ', Result, j + 1);
  end;

begin
  Result := TStringList.Create;
  if Assigned(FCurrentList) then
  begin
    for i := 0 to FCurrentList.Count - 1 do
      if FrameEnabled(FCurrentList.Objects[i]) and ((FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame).Qty > 0) then
        with  (FCurrentList.Objects[i] as TMultiBuyDiscountLineFrame) do
        Result.Add(QtyString(Qty) + InsertStockCode(lblMBDDesc.Caption));
  end;
end;

//Setting the stock code sets the FCurrentList to be list of MBDs for that code (+ sets the DiscountChar property to the appropriate value.
procedure TMBDFramesController.SetStockCode(const Value: string);
var
  i : integer;
begin
  FLockUpdate := True;
  FStockCode := Value;
  if FList.Count > 0 then
  begin
    i := FList.IndexOf(FStockCode);
    if i >= 0 then
    begin
      FCurrentList := FList.Objects[i] as TStringList;
      if FCurrentList.Count > 0 then
      begin
        if Pos('%', FCurrentList[0]) > 0 then
          FDiscountChar := '%'
        else
          FDiscountChar := #0;

        FFirstEnabledEdit := (FCurrentList.Objects[0] as TMultiBuyDiscountLineFrame).edtMBDQty;
        FFirstEnabledFrame := FCurrentList.Objects[0] as TMultiBuyDiscountLineFrame;
      end;
      CalcTotal;
    end
    else
      FCurrentList := nil;
  end;
  FLockUpdate := False;
end;

function TMBDFramesController.GetAllTotalDiscounts: Double;
var
  i : integer;
  KeepList : TStringList;
begin
  FLockUpdate := True;
  Result := 0;
  KeepList := FCurrentList;
  for i := 0 to FList.Count - 1 do
  begin
    StockCode := FList[i];
    Result := Result + FTotalDiscountValue;
  end;
  FCurrentList := KeepList;
  FLockUpdate := False;
end;

{$IFNDEF TRADE}
// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
procedure TMBDFramesController.AddMultiBuyDiscountLines(var InvR: InvRec;
                                                            IDR: IDetail;
                                                            StockFolio : longint;
                                                            NoOfDeletedLines : Integer;
                                                        Const InsertMode : Boolean = False);
var
  Res, i : Integer;
  AList : TStringList;
  TmpID : IDetail;
  // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
  MoveEmUpMode : enumMoveEmUpMode;
begin
  AList := GetDiscountLineStrings;
  Try
    //Do we need to create space for description lines?
    //PR: 16/07/2009 If no deleted lines then MoveEmUp was screwing up order.
    if ((NoOfDeletedLines > 0) and (NoOfDeletedLines < AList.Count)) Or InsertMode then
    begin
      TmpId:=IDr;

      // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
      If InsertMode Then
        MoveEmUpMode := mumInsert
      Else
        MoveEmUpMode := mumDefault;

      MoveEmUp(FullNomKey(IDR.FolioRef),
             FullIdKey(IDR.FolioRef,LastAddrD),
             FullIdKey(IDR.FolioRef,IDR.LineNo),
             2 * (AList.Count - NoOfDeletedLines),
             IDetailF,IdFolioK);

      IDR:=TmpId;
    end;

    if AList.Count > 0 then
    for i := 0 to AList.Count - 1 do
    begin
      FillChar(TmpID, SizeOf(TmpID), 0);
      Set_UpId(Idr, TmpID);
      TmpId.DocltLink := 0;
      TmpID.LineNo:= IDR.LineNo + 2 + (2 * i);
      TmpID.ABSLineNo:=InvR.ILineCount;
      if NoOfDeletedLines < AList.Count then
        Inc(InvR.ILineCount, 2);
      //PR: 16/06/2009 - shouldn't have vat code
//      TmpID.VatCode := Idr.VatCode;


      TmpID.Desc := AList[i];
      TmpID.Qty := Ea2Case(Idr,Stock,Calc_IdQty(IdR.Qty,Idr.QtyMul,Idr.UsePack));
{      TmpID.QtyMul := IdR.QtyMul;
      TmpID.UsePack := IDR.UsePack;
      TmpId.QtyPack := IDr.QtyPack;
      TmpId.PrxPack := Idr.PrxPack;}

//      TmpID.KitLink := IDr.FolioRef;
      TmpID.KitLink := 0;
      TmpID.Discount3Type := mbdDescLineID;

      Res := Add_Rec(F[IDetailF], IDetailF, TmpID, -1);
    end;
  Finally
    AList.Free;
  End;
end;
{$ENDIF}

function TMBDFramesController.ConsolidatedToCurrency(
  Value: Double): Double;
begin
  Result := Value;
  if Assigned(FFirstEnabledFrame) then
  with FFirstEnabledFrame do
  begin
    if (MBDHolder.MBDRec.mbdDiscountType = mbtForAmount) and (MBDHolder.MBDRec.mbdCurrency = 0) then
      Result := Currency_ConvFT(Value, 0, IDRec.Currency, UseCoDayRate);
  end;
end;

function TMBDFramesController.DeleteDescLines(const LID: IDetail) : Integer;
var
  Res : Integer;
  KeyS, KeyChk : ShortString;
  sStock : string;

  function IsCorrectDescriptionLine : Boolean;
  begin
    Result := (Trim(ID.StockCode) = '') and (Id.Discount3Type = 255) and (Id.Qty = LId.Qty) and
              (Pos(Trim(LID.StockCode), ID.Desc) > 0); //PR: 09/07/2009 Need to Trim LID.StockCode when looking for it in ID.Desc
  end;
begin
  Result := 0;
  KeyS := FullNomKey(LID.FolioRef);
  KeyChk := KeyS;

  Res :=  Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) do
  begin
    if IsCorrectDescriptionLine then
    begin
      Delete_Rec(F[IDetailF],IDetailF,IdFolioK);
      Inc(Result);
    end;

    Res :=  Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
  end;
end;

procedure TMBDFramesController.SetEnabled(const Value: Boolean);
var
  i : Integer;
begin
  FEnabled := Value;
  if Assigned(FCurrentList) then
    for i := 0 to FCurrentList.Count - 1 do
      EnableFrame(FCurrentList.Objects[i], Value);
end;

procedure TMBDFramesController.EnableFrame(AComponent: TObject;
  Value: Boolean);
begin
  if (AComponent is TMultiBuyDiscountLineFrame) then
    (AComponent as TMultiBuyDiscountLineFrame).edtMBDQty.Enabled := Value;
end;

end.
