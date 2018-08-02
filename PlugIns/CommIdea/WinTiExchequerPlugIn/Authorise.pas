unit Authorise;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  AuthSORProc, StrUtil, ReferralDialog, CommideaInt, Dialogs, StdCtrls, ComCtrls, ExtCtrls;

const
  WM_Execute    =  WM_User+$1;

type
  TfrmAuthorise = class(TForm)
    Shape1: TShape;
    lProcess: TLabel;
    lLine: TLabel;
    btnOK: TButton;
    Image1: TImage;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    function AuthoriseCard : boolean;
  public
    iResult : integer;
    sCardSwipe : string;
    sError : shortString;
    rOS : real;
    sLAuthCode : shortstring;
    Procedure WMExecute(Var msg:TMessage); message WM_Execute;
    Procedure UpdateLine(sText : string);
    { Public declarations }
  end;

  function LocalReferalDialog(sPhone, sMID : string; CardDetailsRec : TCardDetailsRec; var sAuthCode : string) : longInt;
  procedure LocalGetStatus(sStatus : string);

var
  frmAuthorise: TfrmAuthorise;

implementation

{$R *.dfm}

{ TfrmProgress }

procedure TfrmAuthorise.UpdateLine(sText : string);
begin
  lLine.Caption := sText;
  lLine.Refresh;
end;

procedure TfrmAuthorise.btnOKClick(Sender: TObject);
begin
  Close;
end;

function LocalReferalDialog(sPhone, sMID : string; CardDetailsRec : TCardDetailsRec; var sAuthCode : string) : longInt;
//var
//  FrmCheckSig : TFrmCheckSig;
begin
  with TFrmReferralDialog.Create(application) do begin
    lPhoneNo.Caption := sPhone;
    lMID.Caption := sMID;
    lCardNo.Caption := CardDetailsRec.CardNumber;
    lStartDate.Caption := CardDetailsRec.StartDate;
    lExpiryDate.Caption := CardDetailsRec.ExpiryDate;
    lIssueNo.Caption := CardDetailsRec.IssueNumber;

    if ShowModal = mrOK then
    begin
      sAuthCode := edCode.Text;
      Result := MR_REFERRAL_OK
    end else
    begin
      Result := MR_REFERRAL_NOT_OK;
    end;{if}
    Release;
  end;{with}
end;

function TfrmAuthorise.AuthoriseCard : boolean;
var
  iPrinterIndex, iPos : integer;
  sTXType : shortstring;
begin
  btnOK.Enabled := FALSE;
  Screen.Cursor := crHourglass;
  Result := FALSE;

  UpdateLine('Checking Card Authorisation.');

//  lError.caption := '';
//  Self.Refresh;
  application.processmessages;

//  rOS := (lEventData.Transaction.thTender as ITradeEventTender2).teCard;
  if rOS < 0 then
  begin
    sTXType := TX_REFUND;
    rOS := rOS * -1;
  end
  else sTXType := TX_SALE;

  iPrinterIndex := -1;
{  For iPos := 0 To Pred(RPDev.Printers.Count) Do begin
    if Trim(Uppercase(RPDev.Printers[iPos]))
    = Trim(Uppercase(lBaseData.SystemSetup.ssTradeCounter.ssTill
    [lBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo]
    .ssPrinting.prReceipt.pdPrinterName))
    then iPrinterIndex := iPos;
  end;{for}

  sError := '';

  iResult := ExCommideaAuthorise(sCardSwipe
//  , MoneyToStr(rOS, oToolkit.SystemSetup.ssSalesDecimals)
  , MoneyToStr(rOS) // Always send the amount to 2 dps or it gets it's knickers in a twist
  , sTXType, sError, sLAuthCode, nil, LocalReferalDialog, LocalGetStatus
  , iPrinterIndex, FALSE);

  if iResult < CR_OK then UpdateLine('Error checking card.');

  case iResult of
    CR_OK : begin
      if sTXType = TX_REFUND then UpdateLine('Card refunded successfully.')
      else UpdateLine('Card charged successfully.');

//      lEventData.Transaction.thTender.teCardDetails.cdAuthorisationCode := sAuthCode;
//      Transaction.thTender.teCardDetails.cdCardName
//      Transaction.thTender.teCardDetails.cdCardNumber
//      Transaction.thTender.teCardDetails.cdCardType
//      Transaction.thTender.teCardDetails.cdExpiryDate

      // close window
//      application.processmessages;
//      sleep(1000);
    end;

    CR_REFERRED : begin
      UpdateLine('Error : Card referred, and refused, please try another card.');
    end;

    CR_DECLINED : begin
      UpdateLine('Error : Card declined, please try another card.');
    end;

//    6 : lMessage.caption := 'Card Authorised.';
    CR_REFUSED : begin
      UpdateLine('Error : Card refused by operator, please try another card.');
    end;

    else UpdateLine('Error : ' + sError);
  end;{case}

  lProcess.Caption := 'Process Completed.';

  Result := iResult = CR_OK;
  btnOK.Enabled := TRUE;
  Screen.Cursor := crDefault;
end;

procedure LocalGetStatus(sStatus : string);
begin
  frmAuthorise.UpdateLine(sStatus);
end;

procedure TfrmAuthorise.FormShow(Sender: TObject);
begin
  PostMessage(Handle,WM_Execute,0,0);
end;

procedure TfrmAuthorise.WMExecute(var msg: TMessage);
begin
  AuthoriseCard;
end;

procedure TfrmAuthorise.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := btnOK.Enabled;
end;

procedure TfrmAuthorise.Button1Click(Sender: TObject);
begin
  AuthoriseCard;
end;

end.
