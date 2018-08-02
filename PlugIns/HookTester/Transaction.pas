unit Transaction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CustAbsU, Dialogs, Grids, ValEdit, StdCtrls, ExtCtrls, StrUtil;

type
  TFrmTransaction = class(TForm)
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
    LTX : TAbsInvoice5;
    LHandlerID : integer;
  end;

{var
  FrmTransaction: TFrmTransaction;}

implementation
uses
  MathUtil;

procedure TFrmTransaction.FillProperties;
var
  iPos : cuVATIndex;
begin
  with LTX do begin
    vlProperties.Values['thRunNo'] := IntToStr(thRunNo);
    vlProperties.Values['thAcCode'] := thAcCode;
    vlProperties.Values['thNomAuto'] := BooleanToStr(thNomAuto);
    vlProperties.Values['thOurRef'] := thOurRef;
    vlProperties.Values['thFolioNum'] := IntToStr(thFolioNum);
    vlProperties.Values['thCurrency'] := IntToStr(thCurrency);
    vlProperties.Values['thYear'] := IntToStr(thYear);
    vlProperties.Values['thPeriod'] := IntToStr(thPeriod);
    vlProperties.Values['thDueDate'] := thDueDate;
    vlProperties.Values['thVATPostDate'] := thVATPostDate;
    vlProperties.Values['thTransDate'] := thTransDate;
    vlProperties.Values['thCustSupp'] := thCustSupp;
    vlProperties.Values['thCompanyRate'] := FloatToStr(thCompanyRate);
    vlProperties.Values['thDailyRate'] := FloatToStr(thDailyRate);
    vlProperties.Values['thYourRef'] := thYourRef;
    vlProperties.Values['thYourRef20'] := thYourRef20;
    vlProperties.Values['thBatchLink'] := thBatchLink;
    vlProperties.Values['thAllocStat'] := thAllocStat;
//    vlProperties.Values['thInvDocHed'] := thInvDocHed;

    For iPos := CUStandard to CUSpare8 do
    begin
      vlProperties.Values['thInvVatAnal[' + IntToStr(Integer(iPos))
      + ']'] := FloatToStr(thInvVatAnal[iPos]);
    end;{for}

    vlProperties.Values['thInvNetVal'] := FloatToStr(thInvNetVal);
    vlProperties.Values['thInvVat'] := FloatToStr(thInvVat);
    vlProperties.Values['thDiscSetl'] := FloatToStr(thDiscSetl);
    vlProperties.Values['thDiscSetAm'] := FloatToStr(thDiscSetAm);
    vlProperties.Values['thDiscAmount'] := FloatToStr(thDiscAmount);
    vlProperties.Values['thDiscDays'] := IntToStr(thDiscDays);
    vlProperties.Values['thDiscTaken'] := BooleanToStr(thDiscTaken);
    vlProperties.Values['thSettled'] := FloatToStr(thSettled);
    vlProperties.Values['thAutoInc'] := IntToStr(thAutoInc);
    vlProperties.Values['thNextAutoYr'] := IntToStr(thNextAutoYr);
    vlProperties.Values['thNextAutoPr'] := IntToStr(thNextAutoPr);
    vlProperties.Values['thTransNat'] := IntToStr(thTransNat);
    vlProperties.Values['thTransMode'] := IntToStr(thTransMode);
    vlProperties.Values['thRemitNo'] := thRemitNo;
    vlProperties.Values['thAutoIncBy'] := thAutoIncBy;
    vlProperties.Values['thHoldFlg'] := IntToStr(thHoldFlg);
    vlProperties.Values['thAuditFlg'] := BooleanToStr(thAuditFlg);
    vlProperties.Values['thTotalWeight'] := FloatToStr(thTotalWeight);
    vlProperties.Values['thDelAddr[1]'] := thDelAddr[1];
    vlProperties.Values['thDelAddr[2]'] := thDelAddr[2];
    vlProperties.Values['thDelAddr[3]'] := thDelAddr[3];
    vlProperties.Values['thDelAddr[4]'] := thDelAddr[4];
    vlProperties.Values['thDelAddr[5]'] := thDelAddr[5];
    vlProperties.Values['thVariance'] := FloatToStr(thVariance);
    vlProperties.Values['thTotalOrdered'] := FloatToStr(thTotalOrdered);
    vlProperties.Values['thTotalReserved'] := FloatToStr(thTotalReserved);
    vlProperties.Values['thTotalCost'] := FloatToStr(thTotalCost);
    vlProperties.Values['thTotalInvoiced'] := FloatToStr(thTotalInvoiced);
    vlProperties.Values['thTransDesc'] := thTransDesc;
    vlProperties.Values['thAutoUntilDate'] := thAutoUntilDate;
    vlProperties.Values['thExternal'] := BooleanToStr(thExternal);
    vlProperties.Values['thPrinted'] := BooleanToStr(thPrinted);
    vlProperties.Values['thCurrVariance'] := FloatToStr(thCurrVariance);
    vlProperties.Values['thCurrSettled'] := FloatToStr(thCurrSettled);
    vlProperties.Values['thSettledVAT'] := FloatToStr(thSettledVAT);
    vlProperties.Values['thVATClaimed'] := FloatToStr(thVATClaimed);
    vlProperties.Values['thBatchPayGL'] := IntToStr(thBatchPayGL);
    vlProperties.Values['thAutoPost'] := BooleanToStr(thAutoPost);
    vlProperties.Values['thManualVAT'] := BooleanToStr(thManualVAT);
    vlProperties.Values['thSSDDelTerms'] := thSSDDelTerms;
    vlProperties.Values['thUser'] := thUser;
    vlProperties.Values['thNoLabels'] := IntToStr(thNoLabels);
    vlProperties.Values['thTagged'] := BooleanToStr(thTagged);
    vlProperties.Values['thPickRunNo'] := IntToStr(thPickRunNo);
    vlProperties.Values['thOrdMatch'] := BooleanToStr(thOrdMatch);
    vlProperties.Values['thDeliveryNote'] := thDeliveryNote;
    vlProperties.Values['thVATCompanyRate'] := FloatToStr(thVATCompanyRate);
    vlProperties.Values['thVATDailyRate'] := FloatToStr(thVATDailyRate);
    vlProperties.Values['thPostCompanyRate'] := FloatToStr(thPostCompanyRate);
    vlProperties.Values['thPostDailyRate'] := FloatToStr(thPostDailyRate);
    vlProperties.Values['thPostDiscAm'] := FloatToStr(thPostDiscAm);
    vlProperties.Values['thPostedDiscTaken'] := BooleanToStr(thPostedDiscTaken);
    vlProperties.Values['thDrCrGL'] := IntToStr(thDrCrGL);
    vlProperties.Values['thJobCode'] := thJobCode;
    vlProperties.Values['thJobAnal'] := thJobAnal;
    vlProperties.Values['thTotOrderOS'] := FloatToStr(thTotOrderOS);
    vlProperties.Values['thUser1'] := thUser1;
    vlProperties.Values['thUser2'] := thUser2;
    vlProperties.Values['thDocLSplit[1]'] := FloatToStr(thDocLSplit[1]);
    vlProperties.Values['thDocLSplit[2]'] := FloatToStr(thDocLSplit[2]);
    vlProperties.Values['thDocLSplit[3]'] := FloatToStr(thDocLSplit[3]);
    vlProperties.Values['thDocLSplit[4]'] := FloatToStr(thDocLSplit[4]);
    vlProperties.Values['thDocLSplit[5]'] := FloatToStr(thDocLSplit[5]);
    vlProperties.Values['thDocLSplit[6]'] := FloatToStr(thDocLSplit[6]);
    vlProperties.Values['thLastLetter'] := IntToStr(thLastLetter);
    vlProperties.Values['thUnTagged'] := BooleanToStr(thUnTagged);
//  vlProperties.Values['thLines'] := ;
    vlProperties.Values['thUser3'] := thUser3;
    vlProperties.Values['thUser4'] := thUser4;
    vlProperties.Values['thTagNo'] := IntToStr(thTagNo);
    vlProperties.Values['thCISTaxDue'] := FloatToStr(thCISTaxDue);
    vlProperties.Values['thCISTaxDeclared'] := FloatToStr(thCISTaxDeclared);
    vlProperties.Values['thCISManualTax'] := BooleanToStr(thCISManualTax);
    vlProperties.Values['thCISDate'] := thCISDate;
    vlProperties.Values['thCISEmployee'] := thCISEmployee;
    vlProperties.Values['thCISTotalGross'] := FloatToStr(thCISTotalGross);
    vlProperties.Values['thCISSource'] := IntToStr(thCISSource);
    vlProperties.Values['thTotalCostApport'] := FloatToStr(thTotalCostApport);
//    vlProperties.Values['thNOMVATIO'] := thNOMVATIO;
    vlProperties.Values['thTSHExported'] := BooleanToStr(thTSHExported);
  end;{with}

  btnSaveEdits.enabled := NumberIn(LHandlerID,[102001, 102006, 102007, 102008
  , 102009, 102050, 102061, 102062, 102063, 102064, 102065, 102066, 102080, 102081
  , 102109, 102180, 102181, 102190, 102191]);
end;


{$R *.dfm}

procedure TFrmTransaction.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmTransaction.btnSaveEditsClick(Sender: TObject);
var
  iPos : cuVATIndex;
begin
  with LTX do begin
    case LHandlerID of
      102001 : begin
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
        thYourRef20 := vlProperties.Values['thYourRef20'];
      end;

      102006 : begin
        thAcCode := vlProperties.Values['thAcCode'];
      end;

      102007 : begin
        thDailyRate := StrToFloatDef(vlProperties.Values['thDailyRate'], 0);
      end;

      102008 : begin
        thPeriod := StrToIntDef(vlProperties.Values['thPeriod'], 0);
        thYear := StrToIntDef(vlProperties.Values['thYear'], 0);
      end;

      102009 : begin
        thDelAddr[1] := vlProperties.Values['thDelAddr[1]'];
        thDelAddr[2] := vlProperties.Values['thDelAddr[2]'];
        thDelAddr[3] := vlProperties.Values['thDelAddr[3]'];
        thDelAddr[4] := vlProperties.Values['thDelAddr[4]'];
        thDelAddr[5] := vlProperties.Values['thDelAddr[5]'];
//        thJobAnal := vlProperties.Values['thJobAnal'];
        thJobCode := vlProperties.Values['thJobCode'];
      end;

      102050 : thDueDate := vlProperties.Values['thDueDate'];
      102061 : thUser1 := vlProperties.Values['thUser1'];
      102062 : thUser2 := vlProperties.Values['thUser2'];
      102063 : thUser3 := vlProperties.Values['thUser3'];
      102064 : thUser4 := vlProperties.Values['thUser4'];
      102066 : thTransDesc := vlProperties.Values['thTransDesc'];

      102080 : begin
        thYear := StrToIntDef(vlProperties.Values['thYear'], 0);
        thPeriod := StrToIntDef(vlProperties.Values['thPeriod'], 0);
      end;

      102081 : thTransDate := vlProperties.Values['thTransDate'];
      102109 : thDueDate := vlProperties.Values['thDueDate'];

      102180, 102065 : begin
        thYourRef := vlProperties.Values['thYourRef'];
        thYourRef20 := vlProperties.Values['thYourRef20'];
      end;

      102181 : thTransDesc := vlProperties.Values['thTransDesc'];

      102190 : begin
        thJobAnal := vlProperties.Values['thJobAnal'];
      end;

      102191 : begin
        thManualVAT := StrToBool(vlProperties.Values['thManualVAT']);

        For iPos := CUStandard to CUSpare8 do
        begin
          thInvVatAnal[iPos] := StrToFloatDef(vlProperties.Values['thInvVatAnal['
          + IntToStr(integer(iPos)) + ']'], 0);
        end;{for}

      end;
    end;{case}
  end;{with}
  FillProperties;
end;

procedure TFrmTransaction.btnCloseClick(Sender: TObject);
begin
  close;
end;

end.
