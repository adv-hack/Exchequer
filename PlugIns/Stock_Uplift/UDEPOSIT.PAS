unit uDeposit;

interface

uses CustAbsU, UseDLLU, SysUtils, Dialogs;

{$I ExDllBt.inc}
{$I ExchDll.inc}

type
  TUplifter = class
  private
    fEventData: TAbsEnterpriseSystem;
    fHeaderRec: TBatchTHRec;
    fTxRec: TBatchLinesRec;
    fStockRec: TBatchSKRec;
    function isValidUserField: boolean;
    function isValidStockCode(LineIndex: integer): boolean;
    function isValidUplift(LineIndex: integer): boolean;
  public
    procedure DoUplift(EventData: TAbsEnterpriseSystem);
  end;

implementation

uses Crypto;

procedure ToolKitOK;
const
  CODE = #238 + #27 + #236 + #131 + #174 + #38 + #110 + #208 + #185 + #168 + #157;
var
  pCode: array[0..255] of char;
begin
  ChangeCryptoKey(19701115);
  StrPCopy(pCode, Decode(CODE));
  Ex_SetReleaseCode(pCode);
end;

procedure TUplifter.DoUplift;
var
LineIndex: integer;
Uplift: double;
DataPath: string;
SearchKey, HoldTransRef, HoldStockCode: PChar;
Res: SmallInt;
begin
  fEventData:= EventData;

  with fEventData, Transaction do
  begin
    if thInvDocHed <> cuPDN then Exit;   //Only process purchase delivery notes i.e. exclude sales delivery notes;

    DataPath:= Setup.ssDataPath;
    ToolKitOK;
    Ex_InitDllPath(PChar(DataPath), true);
    Res:= Ex_InitDll;   //Load the toolkit to post the uplifted transaction;
    if Res = 0 then
    try
      SearchKey:= StrAlloc(255);
      StrPCopy(SearchKey, Trim(thOurRef));
      Res:= Ex_GetTrans(@fHeaderRec, @fTxRec, SizeOf(TBatchTHRec), SizeOf(TBatchLinesRec), SearchKey, 0, B_GetGEq, false);
      if Res = 0 then for LineIndex:= 1 to fHeaderRec.LineCount do with fTxRec[LineIndex] do
      begin
        if isValidUplift(LineIndex) then   //Confirm the uplift has not already been set by the user;
        begin
          if isValidStockCode(LineIndex) then   //If the stock code is valid, get the stock information;
          begin
            StrPCopy(SearchKey, Trim(StockCode));
            Res:= Ex_GetStock(@fStockRec, SizeOf(TBatchSKRec), SearchKey, 0, B_GetGEq, false);   //Load the stock object;
            if Res = 0 then with fStockRec do
            begin
              if isValidUserField then   //Confirm the user defined field #3 has been set correctly for the current stock item;
              begin
                Uplift:= StrToFloat(StkUser3);
                if fHeaderRec.Currency <> 1 then
                begin
                  Res:= Ex_ConvertAmount(1, fHeaderRec.Currency, Uplift, 2);
                  if Res <> 0 then MessageDlg('An error has occurred converting between currencies for stock item ' + StockCode + ' (Error ' + IntToStr(Res) + ').  The uplift for this line will need to be set manually.' , mtInformation, [mbOK], 0);
                end;

                HoldTransRef := StrAlloc(255);
                HoldStockCode:= StrAlloc(255);
                StrPCopy(HoldTransRef, thOurRef);
                StrPCopy(HoldStockCode, StockCode);
                if Res = 0 then
                begin
                  Res:= Ex_UpdateUplift(HoldTransRef, AbsLineNo, HoldStockCode, Uplift);
                  if Res <> 0 then MessageDlg('An error has occurred updating the uplift for stock item ' + StockCode + ' (Error ' + IntToStr(Res) + '). The uplift for this line will need to be set manually.' , mtInformation, [mbOK], 0);
                end;
                StrDispose(HoldStockCode);
                StrDispose(HoldTransRef);
              end; 
            end
            else MessageDlg('An error has occurred retrieving stock information for ' + EventData.Transaction.thOurRef + ' on line ' + IntToStr(LineNo) + ' (Error ' + IntToStr(Res) + '). Please set the Delivery Note Uplift manually and notify your technical support.' , mtInformation, [mbOK], 0);
          end;
        end;
      end
      else MessageDlg('An error has occurred retrieving transaction information for ' + EventData.Transaction.thOurRef + ' (Error ' + IntToStr(Res) + '). Please set the Delivery Note Uplift manually and notify your technical support.' , mtInformation, [mbOK], 0);
      StrDispose(SearchKey);
    finally
      Ex_CloseData;
    end
    else MessageDlg('An error has occurred initialising the Delivery Note Plug-In for ' + EventData.Transaction.thOurRef + ' (Error ' + IntToStr(Res) + '). Please set the Delivery Note Uplift manually and notify your technical support.' , mtInformation, [mbOK], 0);
  end;
end;

function TUplifter.isValidUserField: boolean;
begin
  try
    StrToFloat(fStockRec.StkUser3);
    isValidUserField:= true;
  except
    isValidUserField:= false;
    MessageDlg('The user defined field #3 has not been set for this stock item. The uplift for the Delivery Note ' + fEventData.Transaction.thOurRef + ' will need to be set manually.', mtInformation, [mbOK], 0);
  end;
end;

function TUplifter.isValidStockCode(LineIndex: integer): boolean;
begin
  isValidStockCode:= Trim(fTxRec[LineIndex].StockCode) <> '';
end;

function TUplifter.isValidUplift(LineIndex: integer): boolean;
begin
  isValidUplift:= fTxRec[LineIndex].CostPrice = 0;
end;

end.
