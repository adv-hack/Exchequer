unit TestForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BrwseDir
  {$IFNDEF DLL}
    {,EntPrice_TLB;} ,Enterprise02_TLB, ExtCtrls;
  {$ELSE}
    ;
  {$ENDIF}

type
  TForm1 = class(TForm)
    grpPriceCalc: TGroupBox;
    Label1: TLabel;
    edtAccCode: TEdit;
    Label2: TLabel;
    edtStockCode: TEdit;
    Label4: TLabel;
    edtQuantity: TEdit;
    Label3: TLabel;
    edtCurrCode: TEdit;
    btnCalculate: TButton;
    edtPrice: TEdit;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    btnCurrencyInfo: TButton;
    edtCurrencyNum: TEdit;
    GroupBox2: TGroupBox;
    btnCurrencyArray: TButton;
    lstCurrencyArray: TListBox;
    btnDataDir: TButton;
    edtDataDirectory: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label8: TLabel;
    edtUploadDir: TEdit;
    btnUploadDir: TButton;
    Label9: TLabel;
    btnInstallDir: TButton;
    btnRunUpdate: TButton;
    edtInstallDir: TEdit;
    edtLoc: TEdit;
    Label11: TLabel;
    chkLoc: TCheckBox;
    Panel1: TPanel;
    Button1: TButton;
    procedure btnCalculateClick(Sender: TObject);
    procedure edtAccCodeExit(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCurrencyInfoClick(Sender: TObject);
    procedure btnCurrencyArrayClick(Sender: TObject);
    procedure btnBrowseDirClick(Sender: TObject);
    procedure btnRunUpdateClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    {$IFNDEF DLL}
      {$IFNDEF LOC}
        Server : IEnterprisePriceCalc;
      {$ELSE}
        Server : IEnterprisePriceCalc3;
      {$ENDIF}
    {$ENDIF}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{$IFNDEF DLL}
uses
  ComObj, Variants;
{$ENDIF}

type
  {$I COMPrice.inc}

{$IFDEF DLL}
function CalculatePrice(RootDir, AccCode, StockCode : pchar;
                        CurrencyCode : smallint; Quantity : double;
                        var Price : double) : smallint;
                        stdcall external 'CalcPrce.dll';

function CurrencyInfo(RootDir : pchar;
                      CurrNum : smallint;
                      CurrName, CurrSymbol : PChar) : smallint;
                      stdcall external 'Calcprce.dll';

function ProcessPriceUpdate(var COMPriceUpdateRec : TCOMPriceUpdateRec) : smallint;
                            stdcall external 'Calcprce.dll';
{$ENDIF}

procedure TForm1.btnCalculateClick(Sender: TObject);
var
  Dir,
  Acc,
  Stock : array[0..255] of char;
  {$IFDEF DLL }
  Price : double;
  {$ELSE}
  Price : OleVariant;
  {$ENDIF}
  Res : integer;
begin
  edtPrice.Text := '';
  StrPCopy(Acc, edtAccCode.Text);
  StrPCopy(Stock, edtStockCode.Text);
  StrPCopy(Dir, edtDataDirectory.Text);

  {$IFDEF DLL}
    Res := CalculatePrice(Dir, Acc, Stock, StrToInt(edtCurrCode.Text),
                            StrToFloat(edtQuantity.Text), Price);
  {$ELSE}
    Server.TestMode := false;
    {$IFDEF LOC}
      Server.UseLocation := chkLoc.Checked;
      Server.DefaultLocation := edtLoc.Text;
    {$ENDIF}
    Res := Server.CalcPrice(edtDataDirectory.Text, Acc, Stock, StrToInt(edtCurrCode.Text),
             StrToFloat(edtQuantity.Text), Price);
  {$ENDIF}

  ShowMessage('Call to CalculatePrice = ' + IntToStr(Res));
  edtPrice.Text := FloatToStr(Price);
end;


procedure TForm1.edtAccCodeExit(Sender: TObject);
begin
  edtAccCode.Text := UpperCase(edtAccCode.Text);
end;

procedure TForm1.edtStockCodeExit(Sender: TObject);
begin
  edtStockCode.Text := UpperCase(edtStockCode.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IFDEF DLL}
    Caption := 'Price Calculations - DLL Mode';
  {$ELSE}
    Caption := 'Price Calculations - COM Mode';
//    Server := CoEnterprisePriceCalc.Create;
    {$IFNDEF LOC}
    Server := CoCOMPricing.Create;
    {$ELSE}
    Server := CoCOMPricing.Create as IEnterprisePriceCalc3;
    {$ENDIF}
  {$ENDIF}
end;

procedure TForm1.btnCurrencyInfoClick(Sender: TObject);
var
  Res : smallint;
  {$IFDEF DLL}
  Dir,
  CurrName,
  CurrSymb : array[0..255] of char;
  {$ELSE}
  CurrName,
  CurrSymb : OleVariant;
  {$ENDIF}
begin
  {$IFDEF DLL}
    FillChar(CurrName, SizeOf(CurrName), 0);
    FillChar(CurrSymb, SizeOf(CurrSymb), 0);
    StrPCopy(Dir, edtDataDirectory.Text);

    Res := CurrencyInfo(Dir, StrToInt(edtCurrencyNum.Text), CurrName, CurrSymb);
  {$ELSE}
    Res := Server.GetCurrency(edtDataDirectory.Text, StrToInt(Trim(edtCurrencyNum.Text)),
                                CurrName, CurrSymb);
  {$ENDIF}
  if Res = 0 then
    ShowMessage('Currency = ' + CurrName + #13#10 +
                'Symbol = ' + CurrSymb)
  else
    ShowMessage('Call to GetCurrency = ' + IntToStr(Res));
end;

//-----------------------------------------------------------------------

procedure TForm1.btnCurrencyArrayClick(Sender: TObject);
{$IFNDEF DLL}
var
  Res : smallint;
  Curr : OleVariant;
  i : integer;
  CurrNum : integer;
  CurrName, CurrSymb : string;
{$ENDIF}
begin
  {$IFNDEF DLL}
  Res := Server.GetCurrencyArray(edtDataDirectory.Text, Curr);

  if Res <> 0 then
    ShowMessage('Call to GetCurrencyArray = ' + IntToStr(Res))
  else
  begin
    lstCurrencyArray.Items.Clear;
    for i := VarArrayLowBound(Curr, 1) to VarArrayHighBound(Curr, 1) do
    begin
      CurrNum := Curr[i,0];
      CurrName := Curr[i,1];
      CurrSymb := Curr[i,2];
      if CurrSymb = #156 then
        CurrSymb := '£';
      lstCurrencyArray.Items.Add(Format('%u  %s  %s', [CurrNum, CurrName, CurrSymb]));
    end;
  end;
  {$ELSE}
    ShowMessage('Only implemented in COM object');
  {$ENDIF}
end;

procedure TForm1.btnBrowseDirClick(Sender: TObject);
var
  Dir : string;
begin
  with TFrmDirBrowse.Create(self) do
    try
      if ShowModal = mrOK then
      begin
        Dir := IncludeTrailingBackslash(lbDirectory.Directory);
        if Sender = btnDataDir then
          edtDataDirectory.Text := Dir;
        if Sender = btnUploadDir then
          edtUploadDir.Text := Dir;
        if Sender = btnInstallDir then
          edtInstallDir.Text := Dir;
      end;
    finally
      Release;
    end;
end;

procedure TForm1.btnRunUpdateClick(Sender: TObject);
var
  COMPriceUpdateRec : TCOMPriceUpdateRec;
  Status : integer;
  ErrorMsg : widestring;
begin
  {$IFDEF DLL}
  COMPriceUpdateRec.UploadDir := StrAlloc(length(edtUploadDir.Text)+1);
  StrPCopy(COMPriceUpdateRec.UploadDir, edtUploadDir.Text);
  COMPriceUpdateRec.InstallDir := StrAlloc(length(edtInstallDir.Text)+1);
  StrPCopy(COMPriceUpdateRec.InstallDir, edtInstallDir.Text);
  COMPriceUpdateRec.ErrorMsg := StrAlloc(1024);

  Status := ProcessPriceUpdate(COMPriceUpdateRec);
  ShowMessage('Status = ' + IntToStr(Status) + #13#10 +
              'Message = ' + COMPriceUpdateRec.ErrorMsg);

  StrDispose(COMPriceUpdateRec.UploadDir);
  StrDispose(COMPriceUpdateRec.InstallDir);
  StrDispose(COMPriceUpdateRec.ErrorMsg);
  {$ELSE}
    {$IFDEF LOC}
      Server.UseLocation := True;
    {$ENDIF}
  Status := Server.UpdatePriceData(edtUploadDir.Text, edtInstallDir.Text, ErrorMsg);
  ShowMessage('Status = ' + IntToStr(Status) + #13#10 +
              'Message = ' + ErrorMsg);
  {$ENDIF}
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Res : Integer;
  DiscValue : OleVariant;
  DiscChar : OleVariant;
  sDiscChar : String;
begin
  Res := Server.GetValueBasedDiscount(edtDataDirectory.Text, edtAccCode.Text, StrToInt(edtCurrCode.Text),
            StrToFloat(edtQuantity.Text), DiscValue, DiscChar);
  ShowMessage('Call to GetValueBasedDiscount = ' + IntToStr(Res));
  sDiscChar := DiscChar;
  if (Length(DiscChar) > 0) and (sDiscChar[1] <> #0) then
    edtPrice.Text := FloatToStr(DiscValue) + sDiscChar
  else
    edtPrice.Text := FloatToStr(DiscValue);

end;

end.



