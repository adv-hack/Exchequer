unit Account;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CustAbsU, Dialogs, Grids, ValEdit, StdCtrls, ExtCtrls, StrUtil;

type
  TFrmAccount = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnSaveEdits: TButton;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSaveEditsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure FillProperties;
  public
    LAccount : TAbsCustomer2;
    LHandlerID : integer;
  end;

{var
  FrmTransaction: TFrmTransaction;}

implementation

procedure TFrmAccount.FillProperties;
begin
  with LAccount do begin

    vlProperties.Values['acStateDeliveryMode'] := IntToStr(acStateDeliveryMode);
    vlProperties.Values['acHeadOffice'] := IntToStr(acHeadOffice);
    vlProperties.Values['acCode'] := acCode;
    vlProperties.Values['acCompany'] := acCompany;
    vlProperties.Values['acArea'] := acArea;
    vlProperties.Values['acAccType'] := acAccType;
    vlProperties.Values['acStatementTo'] := acStatementTo;
    vlProperties.Values['acVATRegNo'] := acVATRegNo;
    vlProperties.Values['acAddress[1]'] := acAddress[1];
    vlProperties.Values['acAddress[2]'] := acAddress[2];
    vlProperties.Values['acAddress[3]'] := acAddress[3];
    vlProperties.Values['acAddress[4]'] := acAddress[4];
    vlProperties.Values['acAddress[5]'] := acAddress[5];
    vlProperties.Values['acDelAddr'] := BooleanToStr(acDelAddr);
    vlProperties.Values['acDelAddress[1]'] := acDelAddress[1];
    vlProperties.Values['acDelAddress[2]'] := acDelAddress[2];
    vlProperties.Values['acDelAddress[3]'] := acDelAddress[3];
    vlProperties.Values['acDelAddress[4]'] := acDelAddress[4];
    vlProperties.Values['acDelAddress[5]'] := acDelAddress[5];
    vlProperties.Values['acContact'] := acContact;
    vlProperties.Values['acPhone'] := acPhone;
    vlProperties.Values['acFax'] := acFax;
    vlProperties.Values['acTheirAcc'] := acTheirAcc;
    vlProperties.Values['acOwnTradTerm'] := BooleanToStr(acOwnTradTerm);
    vlProperties.Values['acTradeTerms[1]'] := acTradeTerms[1];
    vlProperties.Values['acTradeTerms[2]'] := acTradeTerms[2];
    vlProperties.Values['acCurrency'] := IntToStr(acCurrency);
    vlProperties.Values['acVATCode'] := acVATCode;
    vlProperties.Values['acPayTerms'] := IntToStr(acPayTerms);
    vlProperties.Values['acCreditLimit'] := FloatToStr(acCreditLimit);
    vlProperties.Values['acDiscount'] := FloatToStr(acDiscount);
    vlProperties.Values['acCreditStatus'] := IntToStr(acCreditStatus);
    vlProperties.Values['acCostCentre'] := acCostCentre;
    vlProperties.Values['acDiscountBand'] := acDiscountBand;
    vlProperties.Values['acDepartment'] := acDepartment;
    vlProperties.Values['acECMember'] := BooleanToStr(acECMember);
    vlProperties.Values['acStatement'] := BooleanToStr(acStatement);
    vlProperties.Values['acSalesGL'] := IntToStr(acSalesGL);
    vlProperties.Values['acLocation'] := acLocation;
    vlProperties.Values['acAccStatus'] := IntToStr(acAccStatus);
    vlProperties.Values['acPayType'] := acPayType;
    vlProperties.Values['acBankSort'] := acBankSort;
    vlProperties.Values['acBankAcc'] := acBankAcc;
    vlProperties.Values['acBankRef'] := acBankRef;
    vlProperties.Values['acPhone2'] := acPhone2;
    vlProperties.Values['acCOSGL'] := IntToStr(acCOSGL);
    vlProperties.Values['acDrCrGL'] := IntToStr(acDrCrGL);
    vlProperties.Values['acLastUsed'] := acLastUsed;
    vlProperties.Values['acUserDef1'] := acUserDef1;
    vlProperties.Values['acUserDef2'] := acUserDef2;
    vlProperties.Values['acInvoiceTo'] := acInvoiceTo;
    vlProperties.Values['acSOPAutoWOff'] := BooleanToStr(acSOPAutoWOff);
    vlProperties.Values['acFormSet'] := IntToStr(acFormSet);
    vlProperties.Values['acBookOrdVal'] := FloatToStr(acBookOrdVal);
    vlProperties.Values['acDirDebMode'] := IntToStr(acDirDebMode);
    vlProperties.Values['acAltCode'] := acAltCode;
    vlProperties.Values['acPostCode'] := acPostCode;
    vlProperties.Values['acUserDef3'] := acUserDef3;
    vlProperties.Values['acUserDef4'] := acUserDef4;
    vlProperties.Values['acEmailAddr'] := acEmailAddr;
    vlProperties.Values['acCCStart'] := acCCStart;
    vlProperties.Values['acCCEnd'] := acCCEnd;
    vlProperties.Values['acCCName'] := acCCName;
    vlProperties.Values['acCCNumber'] := acCCNumber;
    vlProperties.Values['acCCSwitch'] := acCCSwitch;
    vlProperties.Values['acDefTagNo'] := IntToStr(acDefTagNo);
    vlProperties.Values['acDefSettleDisc'] := FloatToStr(acDefSettleDisc);
    vlProperties.Values['acDefSettleDays'] := IntToStr(acDefSettleDays);
    vlProperties.Values['acDocDeliveryMode'] := IntToStr(acDocDeliveryMode);
    vlProperties.Values['acEbusPword'] := acEbusPword;
    vlProperties.Values['acUseForEbus'] := IntToStr(acUseForEbus);
    vlProperties.Values['acWebLiveCatalog'] := acWebLiveCatalog;
    vlProperties.Values['acWebPrevCatalog'] := acWebPrevCatalog;
    vlProperties.Values['acInclusiveVATCode'] := acInclusiveVATCode;
    vlProperties.Values['acLastOperator'] := acLastOperator;
    vlProperties.Values['acSendHTML'] := BooleanToStr(acSendHTML);
    vlProperties.Values['acSendReader'] := BooleanToStr(acSendReader);
    vlProperties.Values['acZIPAttachments'] := IntToStr(acZIPAttachments);
    vlProperties.Values['acSSDDeliveryTerms'] := acSSDDeliveryTerms;
    vlProperties.Values['acSSDModeOfTransport'] := IntToStr(acSSDModeOfTransport);
    vlProperties.Values['acTimeStamp'] := acTimeStamp;
  end;{with}

  btnSaveEdits.enabled := LHandlerID in [];
end;


{$R *.dfm}

procedure TFrmAccount.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmAccount.btnSaveEditsClick(Sender: TObject);
begin
(*  with LTX do begin
    case LHandlerID of
      1 : begin
        thDueDate := vlProperties.Values['thDueDate'];
        thHoldFlg := StrToIntDef(vlProperties.Values['thHoldFlg'], 0);
        thNoLabels := StrToIntDef(vlProperties.Values['thNoLabels'], 0);
        thPeriod := StrToIntDef(vlProperties.Values['thPeriod'], 0);
        thTagNo := StrToIntDef(vlProperties.Values['thTagNo'], 0);
        thTransDesc := vlProperties.Values['thTransDesc'];
        thUser1 := vlProperties.Values['thUser1'];
        thUser2 := vlProperties.Values['thUser2'];
        thUser3 := vlProperties.Values['thUser3'];
        thUser4 := vlProperties.Values['thUser4'];
        thYear := StrToIntDef(vlProperties.Values['thYear'], 0);
        thYourRef := vlProperties.Values['thYourRef'];
      end;

      61 : thUser1 := vlProperties.Values['thUser1'];
      62 : thUser2 := vlProperties.Values['thUser2'];
      63 : thUser3 := vlProperties.Values['thUser3'];
      64 : thUser4 := vlProperties.Values['thUser4'];
      109 : thDueDate := vlProperties.Values['thDueDate'];
      180, 65 : thYourRef := vlProperties.Values['thYourRef'];
      181 : thTransDesc := vlProperties.Values['thTransDesc'];
    end;{case}
  end;{with}
  FillProperties;*)
end;

procedure TFrmAccount.btnCloseClick(Sender: TObject);
begin
  close;
end;

end.
