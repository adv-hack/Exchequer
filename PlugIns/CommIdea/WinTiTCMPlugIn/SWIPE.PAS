unit Swipe;

{ nfrewer440 12:21 21/01/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ExtCtrls, AdPacket, OoMisc, AdPort, IAeverButton
  , EnterpriseTrade_TLB, StrUtil, APIUtil, ASK, RpDevice, CommideaInt;

  function LocalCheckSig : longInt;
  function LocalReferalDialog(sPhone, sMID : string; CardDetailsRec : TCardDetailsRec; var sAuthCode : string) : longInt;
  procedure LocalGetStatus(sStatus : string);

type
  TCheckSigProc = function : longInt;
  TGetStatusProc = procedure(sStatus : string);

  TfrmSwipe = class(TForm)
    Panel1: TPanel;
    lMessage: TLabel;
    btnOK: TIAeverButton;
    lError: TLabel;
    Button1: TButton;
    btnManual: TIAeverButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnManualClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    bAuthorised, bCardSwipe : boolean;
    sCardSwipe : string;
    function CardSwipeKeyPress(Sender: TObject; var Key: Char; TheActiveControl : TWinControl
    ; TheHandle: THandle; var bCardSwipe : boolean; var sCardSwipe : string; bDoSomething : boolean = TRUE) : boolean;
    procedure AuthoriseCard;
  public
    lEventData: ITradeEventData;
    lBaseData: ITradeConnectionPoint;
    sAuthCode : shortstring;
  end;

var
  frmSwipe: TfrmSwipe;

implementation
uses
  ReferralDialog, GfxUtil, JPeg, ManualEntry;

{$R *.dfm}
{$R EXCHBACK.RES}

procedure TfrmSwipe.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  bitFormBackground : TBitmap;
begin
  bAuthorised := FALSE;
  if ColorMode(canvas) in [cm64Bit, cm32Bit, cm24Bit, cm16Bit] then begin
    {Load Background JPEG}
    TmpJPEG := TJPEGImage.Create;
    bitFormBackground := TBitmap.create;
    if LoadJPEGFromRes('FORMBAK2', TmpJPEG) then begin
      bitFormBackground.Assign(TmpJPEG);
      DrawFormBackground(self, bitFormBackground);
    end;{if}
    TmpJPEG.Free;
    bitFormBackground.Free;
  end;{if}
end;

procedure TfrmSwipe.FormShow(Sender: TObject);
begin
  bCardSwipe := FALSE;
  lMessage.Caption := ' Waiting for a card swipe.....';
end;

function TfrmSwipe.CardSwipeKeyPress(Sender: TObject; var Key: Char; TheActiveControl : TWinControl
; TheHandle: THandle; var bCardSwipe : boolean; var sCardSwipe : string; bDoSomething : boolean = TRUE) : boolean;
{Handles the possible input of a CardSwipe}
{CardSwipe reader must be setup to send : [STX]CardSwipe[ETX]}
const
  STX = ';';
  ETX = '?';
begin
  Result := FALSE;
  if Key = STX then
    begin
      bCardSwipe := TRUE;
      sCardSwipe := STX;
      lMessage.caption := 'Reading Card Details';
      lError.caption := '';
    end
  else begin
    if bCardSwipe then
      begin
        if Key = ETX then
          begin
            sCardSwipe := sCardSwipe + ETX;
            bCardSwipe := FALSE;
            if bDoSomething then Result := TRUE;
          end
        else sCardSwipe := sCardSwipe + Key;
        Key := #0
      end;
{    else GlobFormKeyPress(Sender, Key, TheActiveControl, TheHandle);}
  end;{if}
  Key := #0;
end;

procedure TfrmSwipe.AuthoriseCard;
var
  iPrinterIndex, iPos, iResult : integer;
  sTXType, sError : shortstring;
  rOS : real;
begin
  btnOK.Enabled := FALSE;
  btnManual.Enabled := FALSE;

  lMessage.caption := 'Checking Card Authorisation.';
  lError.caption := '';
  Self.Refresh;
  application.processmessages;

  rOS := (lEventData.Transaction.thTender as ITradeEventTender2).teCard;
  if rOS < 0 then
  begin
    sTXType := TX_REFUND;
    rOS := rOS * -1;
  end
  else sTXType := TX_SALE;

  iPrinterIndex := 0;
  For iPos := 0 To Pred(RPDev.Printers.Count) Do begin
    if Trim(Uppercase(RPDev.Printers[iPos]))
    = Trim(Uppercase(lBaseData.SystemSetup.ssTradeCounter.ssTill
    [lBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo]
    .ssPrinting.prReceipt.pdPrinterName))
    then iPrinterIndex := iPos;
  end;{for}

  {.012}
  sAuthCode := 'TILL' + PadString(psLeft, IntToStr(lBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo), '0', 2);

  iResult := ExCommideaAuthorise(sCardSwipe
//  , MoneyToStr(rOS, lBaseData.SystemSetup.ssEnterprise.ssSalesDecimals)
  , MoneyToStr(rOS) // Always send the amount to 2 dps or it gets it's knickers in a twist
  , sTXType, sError, sAuthCode, LocalCheckSig, LocalReferalDialog, LocalGetStatus
  , iPrinterIndex);

  btnOK.Enabled := TRUE;
  btnManual.Enabled := TRUE;

  if iResult < CR_OK then lMessage.caption := 'Error checking card.';

  case iResult of
    CR_OK : begin
      if sTXType = TX_REFUND then lMessage.caption := 'Card refunded.'
      else lMessage.caption := 'Card charged.';

      lEventData.Transaction.thTender.teCardDetails.cdAuthorisationCode := sAuthCode;
//      Transaction.thTender.teCardDetails.cdCardName
//      Transaction.thTender.teCardDetails.cdCardNumber
//      Transaction.thTender.teCardDetails.cdCardType
//      Transaction.thTender.teCardDetails.cdExpiryDate

      // close window
      lMessage.Refresh;
      application.processmessages;
      sleep(1000);
      PostMessage(Self.Handle,WM_Close,0,0);// Close Window
    end;

    CR_REFERRED : begin
      lMessage.caption := 'Card referred, and refused.';
      lError.caption := 'Please try another card.';
    end;

    CR_DECLINED : begin
      lMessage.caption := 'Card declined.';
      lError.caption := 'Please try another card.';
    end;

//    6 : lMessage.caption := 'Card Authorised.';
    CR_REFUSED : begin
      lMessage.caption := 'Card refused by operator.';
      lError.caption := 'Please try another card.';
    end;

    else lError.caption := sError;
  end;{case}

  bAuthorised := iResult = CR_OK;

  if iResult = CR_OK then
  begin
    btnOK.Caption := 'OK';
    if ActiveControl <> btnOK then SendMessage(btnOK.Handle,CM_MOUSEENTER,0,0); {redraw button}
  end;{if}
end;

procedure TfrmSwipe.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not bAuthorised then begin
    if CardSwipeKeyPress(Sender, Key, ActiveControl, Handle, bCardSwipe, sCardSwipe)
    then AuthoriseCard;
  end;{if}
end;

procedure TfrmSwipe.btnOKClick(Sender: TObject);
begin
//  ShowMessage('Cancel Pressed');
  if btnOK.Caption = 'OK' then ModalResult := mrOK
  else ModalResult := mrCancel;
end;

procedure TfrmSwipe.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
//  EPOSKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {Trap function keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
        VK_F5 : btnManualClick(btnManual);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TfrmSwipe.Button1Click(Sender: TObject);
begin
  sCardSwipe := ';6331656217930524=06072010300000000000?';
  AuthoriseCard;
end;

procedure TfrmSwipe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if btnOK.Caption = 'OK' then modalresult := mrOK;
end;

function LocalCheckSig : longInt;
//var
//  FrmCheckSig : TFrmCheckSig;
begin
  with TFrmCheckSig.Create(application) do begin
    if ShowModal = mrYes
    then Result := MR_SIGNATURE_OK
    else Result := MR_SIGNATURE_NOT_OK;
  end;{with}
end;

procedure LocalGetStatus(sStatus : string);
begin
  frmSwipe.lMessage.Caption := sStatus;
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

procedure TfrmSwipe.btnManualClick(Sender: TObject);
begin
  with TfrmManualEntry.Create(self) do begin
    if showmodal = mrOK then
    begin
      lMessage.Caption := 'Contacting Commidea Server....';
      lError.Caption := '';
      Self.Refresh;
      application.processmessages;
      sCardSwipe := RemoveAllChars(edCardNo.Text,' ') + '/' +  RemoveAllChars(Trim(edStartDate.Text), '/') + '/'
      +  RemoveAllChars(Trim(edExpiryDate.Text), '/') + '/' +  Trim(edIssueNumber.Text) + '/' +  Trim(edSecurityNumber.Text);
      AuthoriseCard;
    end;
    Release;
  end;{with}
end;

procedure TfrmSwipe.Button2Click(Sender: TObject);
begin
  sCardSwipe := ';4544206500010382=04122010300000000000?';
  AuthoriseCard;
end;

end.
