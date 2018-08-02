unit CardDet;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls, BTSupU1, EposProc;

type
  TCardInfo = class
    CardNo : integer;
    GLCode : integer;
    constructor create(iCardNo, iGLCode : integer);
  end;

  TFrmCardDetails = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edExpiry: TEdit;
    edCardName: TEdit;
    edCardNo: TEdit;
    Shape1: TShape;
    Label4: TLabel;
    edAuthorCode: TEdit;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    cmbCardType: TComboBox;
    Label5: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
  public
    { Public declarations }
  end;

var
  FrmCardDetails: TFrmCardDetails;

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  TXRecs, EPOSKey, EPOSCnst, GfxUtil, TXHead;
{$R *.DFM}

constructor TCardInfo.create(iCardNo, iGLCode : integer);
begin
  inherited create;
  CardNo := iCardNo;
  GLCode := iGLCode;
end;

procedure TFrmCardDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmCardDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F9 : ModalResult := mrOK;
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmCardDetails.FormCreate(Sender: TObject);
var
  iPos : integer;
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  {Credit Cards Tab}
  For iPos := 0 to 19 do begin
    with SetupRecord do begin
      if CreditCards[iPos].Desc <> '' then cmbCardType.Items.AddObject(CreditCards[iPos].Desc
      , TCardInfo.Create(iPos,CreditCards[iPos].GLCode));
    end;{with}
  end;{for}
  if cmbCardType.Items.Count > 0 then cmbCardType.ItemIndex := 0;
  btnOK.Enabled := cmbCardType.ItemIndex > -1;
end;

procedure TFrmCardDetails.WMFormCloseMsg(var Message : TMessage);
{Receive WMFormCloseMsg message}
begin
  with Message do begin
    case WParam of
      {Close Form on Form Show}
      0 : begin
        ModalResult := mrCancel;
      end;

      1 : begin
        ModalResult := mrOK;
      end;
    end;{case}
  end;{with}
  inherited;
end;



procedure TFrmCardDetails.FormShow(Sender: TObject);
var
  bPDQFail, bCloseWindow : boolean;

  procedure HOOK_CreditCardBeforeShow;
  var
    CurrentLineRec : TTXLineRec;
    iPos : integer;
  begin{HOOK_CreditCardBeforeShow}
    bCloseWindow := FALSE;
    bPDQFail := FALSE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiCreditCard, hpCreditCardBeforeShow) then begin
        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign (Self.Handle, twiCreditCard, hpCreditCardBeforeShow
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin

          bPDQFail := TradeCustomisation.EventDataO.aBoolResult[2];
          bCloseWindow := TradeCustomisation.EventDataO.aBoolResult[1];

          if DataChanged and (not bPDQFail) then begin
            // Update form with changes
            TXRec := LTXRec;

            // Copy details onto form
            with TXRec do begin

              // Set Card Type
              For iPos := 0 to cmbCardType.Items.Count - 1 do begin
                if TCardInfo(cmbCardType.Items.Objects[iPos]).CardNo = iCardType then begin
                  cmbCardType.ItemIndex := iPos;
                  Break;
                end;{if}
              end;{for}

              edCardNo.Text := asCardDetails[1];
              edCardName.Text := asCardDetails[2];
              edExpiry.Text := asCardDetails[3];
              edAuthorCode.Text := asCardDetails[4];
            end;{with}
          end;{if}

        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_CreditCardBeforeShow}

begin
  HOOK_CreditCardBeforeShow;
  if bPDQFail then PostMessage(Self.Handle,WM_FormCloseMsg,0,0)
  else begin
    if bCloseWindow then PostMessage(Self.Handle,WM_FormCloseMsg,1,0);
  end;{if}
end;

procedure TFrmCardDetails.btnOKClick(Sender: TObject);
begin
  if btnOK.Enabled then ModalResult := mrOK;
end;

procedure TFrmCardDetails.btnCancelClick(Sender: TObject);
begin
  if btnCancel.Enabled then ModalResult := mrCancel;
end;

end.
