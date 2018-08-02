unit MBDTeleSales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, TCustom, ExtCtrls, VarConst, mbdLineFrame, GlobVar, ExWrap1U;

type
  TDiscountDetails = Class
    dBuyQty : Double;
    dDiscValue : Double;
    cDiscChar : Char;
    sStockDesc : string;
    idLine : IDetail;
  end;


  TfrmTeleSalesMultiBuy = class(TForm)
    scrMultiBuy: TScrollBox;
    Panel1: TPanel;
    btnApply: TSBSButton;
    btnCancel: TSBSButton;
    lblDiscount: Label8;
    lblOriginalNet: Label8;
    lblDiscountedNet: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    lblCost: Label8;
    lblCostCaption: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    MBDFramesController : TMBDFramesController;
    FStockList : TStringList;
    FCurrentPos : Integer;
    FTotalFrames : Integer;
    FSearchString : Str255;
    FCustCode : string;
    FExLocal : TdExLocalPtr;
    FCurrency : Integer;
    FFramesShowing : Boolean;
    FTotalCost : Double;
    FTotalNet : Double;
    FDocType : DocTypes;
    FTransDate : string;
  public
    { Public declarations }
    procedure AddFrames(Idx : Integer);
    procedure AddAllFrames;
    procedure FindStockCodes;
    procedure FindB2BStock (PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec);
    procedure InsertDeletedB2BLine (DeletedLine : IDetail; PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec);
    function Execute : Boolean;
    function ExecuteB2B (PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec): Boolean;
    procedure ValueChanged(Sender : TObject);
    procedure SetLineMultiBuyDiscount(var IDR : IDetail);
    procedure UpdateDiscountDetails(const sStockCode : String);
    procedure AddMultiBuyDiscountLines(var InvR : InvRec; IDR : IDetail; StockR : StockRec);
    property StockList : TStringList read FStockList write FStockList;
    property TotalFrames : Integer read FTotalFrames;
    property SearchString : Str255 read FSearchString write FSearchString;
    property CustomerCode : string read FCustCode write FCustCode;
    property ExLocal : TdExLocalPtr read FExLocal write FExLocal;
    property Currency : Integer read FCurrency write FCurrency;
    property DocType : DocTypes read FDocType write FDocType;
    property TransDate : string read FTransDate write FTransDate;
  end;

var
  frmTeleSalesMultiBuy: TfrmTeleSalesMultiBuy;

implementation

uses
  BtrvU2, VarRec2U, BtSupU1, BTKeys1U, CuStkA5U, InvFSu3U, InvListU, EtMiscU, MiscU, SavePos, ConvDocU, SysU2, ComnUnit;

{$R *.dfm}

const
  ySpace = 4;

procedure TfrmTeleSalesMultiBuy.AddAllFrames;
var
  i : integer;
begin
  FCurrentPos := ySpace * 2;
  MBDFramesController.ScrollBox := scrMultiBuy;
  MBDFramesController.ExLocal := FExLocal;
  MBDFramesController.OnValueChanged := ValueChanged;
  for i := 0 to FStockList.Count - 1 do
    AddFrames(i);
end;

procedure TfrmTeleSalesMultiBuy.AddFrames(Idx : Integer);
var
  ALabel : TLabel;
  iFrameCount : Integer;
begin
  //Heading
  ALabel := TLabel.Create(Self);
  ALabel.Parent := scrMultiBuy;
  ALabel.Left := ySpace * 2;
  ALabel.Top := FCurrentPos;
  ALabel.Caption := Format('%g x ', [(FStockList.Objects[Idx] as TDiscountDetails).dBuyQty])
                         + Trim(FStockList[Idx]) + ' - ' + (FStockList.Objects[Idx] as TDiscountDetails).sStockDesc;
  ALabel.Font.Style := ALabel.Font.Style + [fsBold];
  FCurrentPos := ALabel.Top + ALabel.Height + (ySpace * 2);

  MBDFramesController.StartYPos := FCurrentPos;

  with FStockList.Objects[Idx] as TDiscountDetails do
  begin
    FExLocal.LID := idLine;
    MBDFramesController.ExLocal := FExLocal;
    iFrameCount := MBDFramesController.AddMBDLineFrames(FCustCode, FStockList[Idx], FTransDate, FCurrency, dBuyQty);
  end;

  if iFrameCount > 0 then
  begin
    FCurrentPos := FCurrentPos + (MBDFramesController.FrameHeight * iFrameCount) + ySpace;
    ALabel.Visible := True;
    FTotalFrames := FTotalFrames + iFrameCount;
  end
  else
  begin
    FCurrentPos := ALabel.Top;
    ALabel.Free;
  end;
end;

function TfrmTeleSalesMultiBuy.Execute: Boolean;
begin
  Result := False;
  FindStockCodes;
  AddAllFrames;
  if FTotalFrames > 0 then
  begin
    ShowModal;
    Result := ModalResult = mrOK;
  end;
end;

//-------------------------------------------------------------------------

function TfrmTeleSalesMultiBuy.ExecuteB2B (PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec) : Boolean;
begin
  Result := False;

  FindB2BStock (PORRec, SuppRec, B2BCtrl);
  AddAllFrames;

  if FTotalFrames > 0 then
  begin
    Caption := Caption + ' for ' + Trim(PORRec.OurRef) + ' (' + Trim(SuppRec.CustCode) + ')';
    ShowModal;
    Result := ModalResult = mrOK;
  end;
end;

//------------------------------

// Eduardo has deleted the friggin' line so we need to insert it manually
procedure TfrmTeleSalesMultiBuy.InsertDeletedB2BLine (DeletedLine : IDetail; PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec);
Var
  DiscountObject : TDiscountDetails;
Begin // InsertDeletedB2BLine
  DiscountObject := TDiscountDetails.Create;
  DiscountObject.dBuyQty := DeletedLine.Qty;
  DiscountObject.sStockDesc := DeletedLine.Desc;

  // Need to modify SOR line details to represent POR (can't use proper function as that deducts stock, etc...)
  SetB2B_Copy(DeletedLine, PORRec, SuppRec, B2BCtrl, True);
  DiscountObject.idLine := DeletedLine;
  FStockList.AddObject(DeletedLine.StockCode, DiscountObject);

  FTotalCost := FTotalCost + (DeletedLine.CostPrice * DeletedLine.Qty);
  FTotalNet := FTotalNet + InvLTotal(DeletedLine, True, 0);
End; // InsertDeletedB2BLine

//------------------------------

procedure TfrmTeleSalesMultiBuy.FindB2BStock (PORRec : InvRec; SuppRec : CustRec; B2BCtrl :  B2BInpRec);
Var
  oMiscSavePos : TBtrieveSavePosition;
  oMiscSavePos2 : TBtrieveSavePosition;
  oIDetailSavePos : TBtrieveSavePosition;

  //PR: 18/01/2010 Wasn't storing stock position so could get qty wrong on b2b line
  oStockSavePos : TBtrieveSavePosition;
  KeyId, KeyS, KeyChk : Str255;
  iStatus, idStatus : SmallInt;
  DiscountObject : TDiscountDetails;
Begin // FindB2BStock
  oMiscSavePos := TBtrieveSavePosition.Create;
  oMiscSavePos2 := TBtrieveSavePosition.Create;
  oIDetailSavePos := TBtrieveSavePosition.Create;
  oStockSavePos := TBtrieveSavePosition.Create;
  Try
    oMiscSavePos.SaveFilePosition (MiscF, GetPosKey);
    oMiscSavePos.SaveDataBlock (MiscRecs, SizeOf(MiscRecs^));

    oIDetailSavePos.SaveFilePosition (IDetailF, GetPosKey);
    oIDetailSavePos.SaveDataBlock (@Id, SizeOf(Id));

    //PR: 18/01/2010 Store Stock Position
    oStockSavePos.SaveFilePosition (StockF, GetPosKey);
    oStockSavePos.SaveDataBlock (@Stock, SizeOf(StockRec));

    KeyS := FSearchString;
    KeyChk := FSearchString;
    iStatus := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    While (iStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOff) Do
    Begin
      With MiscRecs^.B2BInpDefRec Do
      Begin
        // Load transaction line
        KeyId := FullIdKey(B2BLine.OrderFolio, B2BLine.OrderLineNo);
        idStatus := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, B2BLine.UseKPath, KeyId);

        // This code is crap - but it is how Eduardo wrote it in SOPCT5U.Generate_MB2BPOR
        If ((B2BLine.OrderLinePos <> Id.LineNo) or (B2BLine.OrderAbsLine <> Id.ABSLineNo)) and (B2BLine.OrderLineAddr <> 0) Then {* v5.52 We have a duplicate line situation so revert to the record address *}
        Begin
          SetDataRecOfs(IDetailF, B2BLine.OrderLineAddr);
          idStatus := GetDirect(F[IDetailF], IDetailF, RecPtr[IDetailF]^, B2BLine.UseKPath, 0);
        End; // If ((B2BLine.OrderLinePos <> Id.LineNo) ...

        If (idStatus = 0) and ((Id.FolioRef = B2BLine.OrderFolio) and ((Id.ABSLineNo = B2BLine.OrderLineNo) or (Id.LineNo = B2BLine.OrderLineNo))) then
        Begin
          DiscountObject := TDiscountDetails.Create;
          DiscountObject.dBuyQty := Id.Qty;
          DiscountObject.sStockDesc := Id.Desc;

          // Need to modify SOR line details to represent POR (can't use proper function as that deducts stock, etc...)

          oMiscSavePos2.SaveFilePosition (MiscF, GetPosKey);
          oMiscSavePos2.SaveDataBlock (MiscRecs, SizeOf(MiscRecs^));
          try
            SetB2B_Copy(Id, PORRec, SuppRec, B2BCtrl, True);
          finally
            oMiscSavePos2.RestoreDataBlock (MiscRecs);
            oMiscSavePos2.RestoreSavedPosition;
          end;
          DiscountObject.idLine := Id;
          FStockList.AddObject(Id.StockCode, DiscountObject);

          FTotalCost := FTotalCost + (Id.CostPrice * Id.Qty);
          FTotalNet := FTotalNet + InvLTotal(Id, True, 0);
        End; // If (idStatus = 0) and ...
      End; // With MiscRecs^.B2BInpDefRec

      iStatus := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    End; // While (iStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)
  Finally
    //PR: 18/01/2010 Restore Stock Position
    oStockSavePos.RestoreDataBlock (@Stock);
    oStockSavePos.RestoreSavedPosition;
    oStockSavePos.Free;

    oMiscSavePos.RestoreDataBlock (MiscRecs);
    oMiscSavePos.RestoreSavedPosition;
    oMiscSavePos.Free;

    oMiscSavePos2.Free;

    oIDetailSavePos.RestoreDataBlock (@Id);
    oIDetailSavePos.RestoreSavedPosition;
    oIDetailSavePos.Free;
  End; // Try..Finally
End; // FindB2BStock

//-------------------------------------------------------------------------

procedure TfrmTeleSalesMultiBuy.FindStockCodes;
var
  KeyS : Str255;
  Res : Integer;
  DiscountObject : TDiscountDetails;
  IDR : IDetail;
  RecAddr : Longint;
  KeyPath : Integer;
  FoundCode : Str20;

  function CalcNet(const ARec : CuStkType) : Double;
  begin
//    Result := ARec.csNetValue * ARec.csQty;
    Result := InvLTotal(DiscountObject.idLine, True, 0);
  end;

begin
  FTotalCost := 0;
  FTotalNet := 0;
  //Keep position in MLoc file as we need to return to the header once we've finished
  Res := Presrv_BTPos(MLocF, KeyPath, F[MLocF], RecAddr, False, False);
  if Res = 0 then
  begin
    KeyS := FSearchString;
    Res := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);

    While (Res = 0) and (CheckKey(FSearchString,KeyS,Length(FSearchString),BOff)) do
    With MLocCtrl.CuStkRec do
    begin
      if csEntered then
      begin
        If (Stock.StockCode<>csStockCode) then
          GetStock(Application.MainForm,csStockCode,FoundCode,-1);

        DiscountObject := TDiscountDetails.Create;
        DiscountObject.sStockDesc := Trim(Stock.Desc[1]);
        TL2ID(DiscountObject.idLine, MLocCtrl.CuStkRec);
        with DiscountObject.idLine do  //PR: 19/06/2009 Wasn't working for split packs
          DiscountObject.dBuyQty := Ea2Case(DiscountObject.idLine,Stock,Qty);
        FStockList.AddObject(csStockCode, DiscountObject);
        FTotalCost := FTotalCost + (csCost * csQty);
        FTotalNet := FTotalNet + CalcNet(MLocCtrl.CuStkRec);
      end;

      Res := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);
    end;

    Move(RecAddr, RecPtr[MLocF]^, SizeOf(RecAddr));
    Res := Presrv_BTPos(MLocF, KeyPath, F[MLocF], RecAddr, True, True);
  end;
end;

procedure TfrmTeleSalesMultiBuy.FormCreate(Sender: TObject);
begin
  MBDFramesController := TMBDFramesController.Create;
  //PR: 10/06/2009 FRv6.01.030 - Wasn't telling frames controller that these are sales transactions.
  MBDFramesController.IsSales := True;
  FStockList := TStringList.Create;
  FTotalFrames := 0;
  FFramesShowing := False;
end;

procedure TfrmTeleSalesMultiBuy.FormDestroy(Sender: TObject);
begin
  FreeAndNil(MBDFramesController);
  FStockList.Free;
end;

procedure TfrmTeleSalesMultiBuy.FormActivate(Sender: TObject);
var
  i : integer;
begin
  if not FFramesShowing then
  begin
    {First activation - at this point we've created the frames and added them to the scroll box, but if we set the quantities at that point,
    they would be reset to zero when the form was shown - eek! So set the quantities and values here.}
    FFramesShowing := True;
    if FTotalFrames > 0 then
    begin
      for i := 0 to FStockList.Count - 1 do
      begin
        MBDFramesController.StockCode := FStockList[i];
        MBDFramesController.UpdateQuantities((FStockList.Objects[i] as TDiscountDetails).dBuyQty);
        with FStockList.Objects[i] as TDiscountDetails do
          MBDFramesController.UpdateValues(idLine.Qty, idLine.NetValue, idLine);
      end;
      if Show_CMG(FDoctype) then //Check that user is allowed to see cost/margin
        lblCost.Caption := Format('%.2f', [FTotalCost])
      else
      begin
        lblCost.Visible := False;
        lblCostCaption.Visible := False;
      end;
      lblOriginalNet.Caption  := Format('%.2f', [FTotalNet]);
      ValueChanged(Self);
    end;
  end;
end;

procedure TfrmTeleSalesMultiBuy.ValueChanged(Sender: TObject);
var
  dTotalDiscount, dDiscountedNet : Double;
begin
  dTotalDiscount := MBDFramesController.GetAllTotalDiscounts;
  lblDiscount.Caption := Format('%.2f', [dTotalDiscount]);

  dDiscountedNet := FTotalNet - dTotalDiscount;
  lblDiscountedNet.Caption := Format('%.2f', [dDiscountedNet]);

  UpdateDiscountDetails(MBDFramesController.StockCode);
end;

procedure TfrmTeleSalesMultiBuy.SetLineMultiBuyDiscount(var IDR: IDetail);
var
  i : integer;
begin
  i := FStockList.IndexOf(IDR.StockCode);
  if i >=0 then
  with (FStockList.Objects[i] as TDiscountDetails) do
  begin
    UpdateDiscountDetails(IDR.StockCode);
    IDR.Discount2 := Round_Up(dDiscValue, 2);
    IDR.Discount2Chr := cDiscChar;
  end;
end;

procedure TfrmTeleSalesMultiBuy.UpdateDiscountDetails(
  const sStockCode: String);
var
  i : integer;
begin
  i := FStockList.IndexOf(sStockCode);
  if i >=0 then
  begin
    MBDFramesController.StockCode := sStockCode;
    with (FStockList.Objects[i] as TDiscountDetails) do
      MBDFramesController.GetUnitDiscountValue(dDiscValue, cDiscChar);
  end;
end;

procedure TfrmTeleSalesMultiBuy.AddMultiBuyDiscountLines(var InvR: InvRec;
  IDR: IDetail; StockR : StockRec);
begin
  MBDFramesController.StockCode := StockR.StockCode;
  MBDFramesController.AddMultiBuyDiscountLines(InvR, IDR, StockR.StockFolio, 0);
end;

end.
