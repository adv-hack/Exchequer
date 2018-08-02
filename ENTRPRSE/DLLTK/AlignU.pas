unit AlignU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{ ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
  private
    { Private declarations }
    procedure RecLens(Sender: TObject);
    procedure BatchCU(Sender: TObject);
    procedure BatchTH(Sender: TObject);
    procedure BatchTL(Sender: TObject);
    procedure SaleBands(Sender: TObject);
    procedure BatchSK(Sender: TObject);
    procedure HistoryBal(Sender: TObject);
    procedure BatchNom(Sender: TObject);
    procedure BatchBOM(Sender: TObject);
    procedure BatchSR(Sender: TObject);
    procedure BatchJH(Sender: TObject);
    procedure BatchSL(Sender: TObject);
    procedure BatchMLoc(Sender: TObject);
    procedure BatchMatch(Sender: TObject);
    procedure BatchNotes(Sender: TObject);
    procedure BatchCCDep(Sender: TObject);
    procedure StkPrice(Sender: TObject);
    procedure BatchVAT(Sender: TObject);
    procedure BatchCurr(Sender: TObject);
    procedure BatchSyss(Sender: TObject);
    procedure BatchAB(Sender: TObject);
    procedure BatchBomImp(Sender: TObject);
    procedure BatchSer(Sender: TObject);
    procedure BatchEmployee(Sender: TObject);
    procedure BatchJobAnal(Sender: TObject);
    procedure BatchJobRate(Sender: TObject);
    procedure BatchDiscRate(Sender: TObject);
    procedure BatchStockAlt(Sender: TObject);
    procedure BatchJobType(Sender: TObject);
    procedure TLArray(Sender: TObject);
    procedure BatchConvTCurr(Sender: TObject);
    procedure SysECommsRec(Sender: TObject);
    procedure DefaultForm(Sender: TObject);
    procedure PrintEmail(Sender: TObject);
    procedure DefaultVATCode(Sender: TObject);
    procedure EntInfo(Sender: TObject);
    procedure UserProf(Sender: TObject);
    procedure Links(Sender: TObject);
    procedure Conv(Sender: TObject);
    procedure Bin(Sender : TObject);
    procedure MultiBuy(Sender : TObject);
  public
    { Public declarations }
    Procedure Msg (Const MsgNo : Word; MsgCapt : ShortString; Var ErrFound : SmallInt);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses AlignedU;

{$A-}
{$I ExchDll.Inc}

{$I RecInfo.Inc}

Procedure TForm1.Msg (Const MsgNo : Word; MsgCapt : ShortString; Var ErrFound : SmallInt);
Var
  ErrStr     : String[27];
  Num1, Num2 : LongInt;
  I          : Byte;
Begin
  If (Length(MsgCapt) > 25) Then
    { Too Long }
    MsgCapt := Copy (MsgCapt, 1, 25)
  Else
    If (Length(MsgCapt) < 25) Then Begin
      { Too Short }
      For I := Length(MsgCapt) To 25 Do
        MsgCapt := MsgCapt + ' ';
    End; { If }

  Num1 := RecInfo(MsgNo);
  Num2 := GetAlignedInfo(MsgNo);
  If (Num1 = Num2) Then
    ErrStr := ''
  Else
    ErrStr := '     *** Error ***     ' + Format('%3d', [Num2 - Num1]);
  ListBox1.Items.Add (MsgCapt + '     ' +
                      Format ('%5d    %5d', [Num1, Num2]) +
                      ErrStr);

  If (Num1 <> Num2) And (ErrFound = -1) Then
    ErrFound := Pred(ListBox1.Items.Count);
End;

procedure TForm1.FormActivate(Sender: TObject);
begin
  { Display Record Lengths }
  ListBox2.ItemIndex := 0;
  ListBox2Click(Sender);
end;

procedure TForm1.RecLens(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('Record Lengths');
  ListBox1.Items.Add('--------------');
  Msg (1,  'TBatchCURec', GotErr);
  Msg (2,  'TBatchTHRec', GotErr);
  Msg (3,  'TBatchTLRec', GotErr);
  Msg (4,  'TBatchLinesRec', GotErr);
  Msg (5,  'TSaleBandsRec', GotErr);
  Msg (6,  'TSaleBandAry', GotErr);
  Msg (7,  'TBatchSKRec', GotErr);
  Msg (8,  'THistoryBalRec', GotErr);
  Msg (9,  'TBatchNomRec', GotErr);
  Msg (10, 'TBatchBOMRec', GotErr);
  Msg (11, 'TBatchBOMLinesRec', GotErr);
  Msg (12, 'TBatchSRRec', GotErr);
  Msg (13, 'TBatchSRLinesRec', GotErr);
  Msg (14, 'TBatchJHRec', GotErr);
  Msg (15, 'TBatchSLRec', GotErr);
  Msg (16, 'TBatchMLocRec', GotErr);
  Msg (17, 'TBatchMatchRec', GotErr);
  Msg (18, 'TBatchNotesRec', GotErr);
  Msg (19, 'TBatchCCDepRec', GotErr);
  Msg (20, 'TBatchStkPriceRec', GotErr);
  Msg (21, 'TBatchVATRec', GotErr);
  Msg (22, 'TBatchCurrRec', GotErr);
  Msg (23, 'TBatchSysRec', GotErr);
  Msg (24, 'TBatchAutoBankRec', GotErr);
  Msg (25, 'TBatchBOMImportRec', GotErr);
  Msg (26, 'TBatchSerialRec', GotErr);
  Msg (27, 'TBatchEmplRec', GotErr);
  Msg (28, 'TBatchJobAnalRec', GotErr);
  Msg (29, 'TBatchJobRateRec', GotErr);
  Msg (30, 'TBatchJobTypeRec', GotErr);
  Msg (31, 'TBatchDiscRec', GotErr);
  Msg (32, 'TBatchSKAltRec', GotErr);
  Msg (33, 'TLArrayInfoType', GotErr);
  Msg (34, 'TBatchConvTCurr', GotErr);
  Msg (35, 'TSysECommsRec', GotErr);
  Msg (36, 'TDefaultFormRecType', GotErr);
  Msg (37, 'TEmailPrintInfoType', GotErr);
  Msg (38, 'TVATCodeDefaultType', GotErr);
  Msg (39, 'TEnterpriseInfoType', GotErr);
  Msg (40, 'TUserProfileType', GotErr);
  Msg (41, 'TBatchLinkRec', GotErr);
  Msg (42, 'TBatchConvRec', GotErr);
  Msg (43, 'TBatchBinRec', GotErr);
  Msg (44, 'TBatchMultiBuyDiscount', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Record Length Error found in record structures');
  End; { If }
end;

procedure TForm1.BatchCU(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchCURec');
  ListBox1.Items.Add('-----------');
  Msg (100, 'CustCode', GotErr);
  Msg (101, 'CustSupp', GotErr);
  Msg (102, 'Company', GotErr);
  Msg (103, 'AreaCode', GotErr);
  Msg (104, 'RepCode', GotErr);
  Msg (105, 'RemitCode', GotErr);
  Msg (106, 'VATRegNo', GotErr);
  Msg (107, 'Addr', GotErr);

  Msg (175, 'PadChar5', GotErr);

  Msg (108, 'DespAddr', GotErr);
  Msg (109, 'DAddr', GotErr);
  Msg (110, 'Contact', GotErr);
  Msg (111, 'Phone', GotErr);
  Msg (112, 'Fax', GotErr);
  Msg (113, 'RefNo', GotErr);
  Msg (114, 'TradTerm', GotErr);
  Msg (115, 'STerms', GotErr);
  Msg (116, 'Currency', GotErr);
  Msg (117, 'VATCode', GotErr);
  Msg (144, 'PadChar1', GotErr);
  Msg (118, 'PayTerms', GotErr);
  Msg (119, 'CreditLimit', GotErr);
  Msg (120, 'Discount', GotErr);
  Msg (121, 'CreditStatus', GotErr);
  Msg (122, 'CustCC', GotErr);
  Msg (123, 'CDiscCh', GotErr);
  Msg (124, 'CustDep', GotErr);
  Msg (145, 'PadChar2', GotErr);
  Msg (125, 'EECMember', GotErr);
  Msg (126, 'IncStat', GotErr);
  Msg (127, 'DefNomCode', GotErr);
  Msg (128, 'DefMLocStk', GotErr);
  Msg (129, 'AccStatus', GotErr);
  Msg (130, 'PayType', GotErr);
  Msg (131, 'BankSort', GotErr);
  Msg (132, 'BankAcc', GotErr);
  Msg (133, 'BankRef', GotErr);
  Msg (134, 'LastUsed', GotErr);
  Msg (135, 'Phone2', GotErr);
  Msg (136, 'UserDef1', GotErr);
  Msg (137, 'UserDef2', GotErr);
  Msg (138, 'SOPInvCode', GotErr);
  Msg (146, 'PadChar3', GotErr);
  Msg (139, 'SOPAutoWOff', GotErr);

  Msg (176, 'PadChar6', GotErr);

  Msg (140, 'BOrdVal', GotErr);
  Msg (141, 'DefCOSNom', GotErr);
  Msg (142, 'DefCtrlNom', GotErr);
  Msg (148, 'DirDeb', GotErr);
  Msg (149, 'CCDSDate', GotErr);
  Msg (150, 'CCDEDate', GotErr);
  Msg (151, 'CCDName', GotErr);
  Msg (152, 'CCDCardNo', GotErr);
  Msg (153, 'CCDSARef', GotErr);
  Msg (177, 'PadChar6', GotErr);
  Msg (154, 'DefSetDDays', GotErr);
  Msg (156, 'PadChar4', GotErr);
  Msg (155, 'DefSetDisc', GotErr);
  Msg (157, 'DefFormNo', GotErr);

  Msg (158, 'StatDMode', GotErr);
  Msg (159, 'EMailAddr', GotErr);
  Msg (160, 'EmlSndRdr', GotErr);
  Msg (161, 'ebusPwrd', GotErr);
  Msg (162, 'PostCode', GotErr);
  Msg (163, 'CustCode2', GotErr);
  Msg (178, 'PadChar8', GotErr);
  Msg (164, 'AllowWeb', GotErr);
  Msg (165, 'EmlZipAtc', GotErr);
  Msg (166, 'UserDef3', GotErr);
  Msg (167, 'UserDef4', GotErr);
  Msg (168, 'TimeChange', GotErr);
  Msg (169, 'SSDDelTerms', GotErr);
  Msg (170, 'CVATIncFlg', GotErr);
  Msg (171, 'SSDModeTr', GotErr);
  Msg (172, 'LastOpo', GotErr);
  Msg (179, 'PadChar9', GotErr);
  Msg (173, 'InvDMode', GotErr);
  Msg (174, 'EmlSndHTML', GotErr);
  Msg (180, 'WebLiveCat', GotErr);
  Msg (181, 'WebPrevCat', GotErr);
  Msg (182, 'SOPCOnsHO', GotErr);

  Msg (183, 'EmlUseEDZ', GotErr);

  Msg (184, 'DefTagNo', GotErr);
  Msg (185, 'OrderConsMode', GotErr);

  Msg (186, 'UserDef5', GotErr);
  Msg (187, 'UserDef6', GotErr);
  Msg (188, 'UserDef7', GotErr);
  Msg (189, 'UserDef8', GotErr);
  Msg (190, 'UserDef9', GotErr);
  Msg (191, 'UserDef10', GotErr);
  Msg (192, 'acDeliveryPostcode', GotErr);
  Msg (193, 'acSubType', GotErr);
  Msg (194, 'acLongACCode', GotErr);
  Msg (195, 'acPPDMode', GotErr);
  Msg (196, 'acCountry', GotErr);
  Msg (197, 'acDeliveryCountry', GotErr);

  Msg (143, 'Spare', GotErr);
  Msg (147, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchCURec');
  End; { If }
end;

procedure TForm1.BatchTH(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchTHRec');
  ListBox1.Items.Add('-----------');
  Msg (200, 'RunNo', GotErr);
  Msg (201, 'CustCode', GotErr);
  Msg (202, 'OurRef', GotErr);
  Msg (241, 'PadChar1', GotErr);
  Msg (203, 'FolioNum', GotErr);
  Msg (204, 'Currency', GotErr);
  Msg (205, 'AcYr', GotErr);
  Msg (206, 'AcPr', GotErr);
  Msg (207, 'DueDate', GotErr);
  Msg (208, 'TransDate', GotErr);
  Msg (209, 'CoRate', GotErr);
  Msg (210, 'VATRate', GotErr);
  Msg (211, 'OldYourRef', GotErr);
  Msg (212, 'LongYrRef', GotErr);
  Msg (213, 'LineCount', GotErr);
  Msg (214, 'TransDocHed', GotErr);
  Msg (215, 'InvVatAnal', GotErr);
  Msg (216, 'InvNetVal', GotErr);
  Msg (217, 'InvVat', GotErr);
  Msg (218, 'DiscSetl', GotErr);
  Msg (219, 'DiscSetAm', GotErr);
  Msg (220, 'DiscAmount', GotErr);
  Msg (221, 'DiscDays', GotErr);
  Msg (222, 'DiscTaken', GotErr);
  Msg (223, 'Settled', GotErr);
  Msg (224, 'TransNat', GotErr);
  Msg (225, 'TransMode', GotErr);
  Msg (226, 'HoldFlg', GotErr);
  Msg (242, 'PadChar2', GotErr);
  Msg (227, 'TotalWeight', GotErr);
  Msg (228, 'DAddr', GotErr);
  Msg (243, 'PadChar3', GotErr);
  Msg (229, 'TotalCost', GotErr);
  Msg (230, 'PrintedDoc', GotErr);
  Msg (231, 'ManVAT', GotErr);
  Msg (232, 'DelTerms', GotErr);
  Msg (233, 'OpName', GotErr);
  Msg (234, 'DJobCode', GotErr);
  Msg (235, 'DJobAnal', GotErr);
  Msg (244, 'PadChar4', GotErr);
  Msg (236, 'TotOrdOS', GotErr);
  Msg (237, 'DocUser1', GotErr);
  Msg (238, 'DocUser2', GotErr);
  Msg (239, 'EmpCode', GotErr);
  Msg (246, 'Tag', GotErr);
  Msg (247, 'thNoLabels', GotErr);
  Msg (248, 'PadChar6', GotErr);
  Msg (249, 'CtrlNom', GotErr);

  Msg (250, 'DocUser3', GotErr);
  Msg (251, 'DocUser4', GotErr);
  Msg (252, 'SSDProcess', GotErr);
  Msg (258, 'PadChar7', GotErr);
  Msg (253, 'ExtSource', GotErr);
  Msg (254, 'PostDate', GotErr);
  Msg (259, 'PadChar8', GotErr);
  Msg (255, 'PORPickSOR', GotErr);
  Msg (260, 'PadChar9', GotErr);
  Msg (256, 'BDiscount', GotErr);
  Msg (257, 'PrePostFlg', GotErr);
  Msg (261, 'AllocStat', GotErr);
  Msg (262, 'PadChar10', GotErr);
  Msg (263, 'SOPKeepRate', GotErr);
  Msg (264, 'TimeCreate', GotErr);
  Msg (265, 'TimeChange', GotErr);

  Msg (266, 'CISTax', GotErr);
  Msg (267, 'CISDeclared', GotErr);
  Msg (268, 'CISManualTax', GotErr);
  Msg (269, 'CISDate', GotErr);
  Msg (270, 'TotalCost2', GotErr);
  Msg (271, 'CISEmpl', GotErr);
  Msg (272, 'CISGross', GotErr);
  Msg (273, 'CISHolder', GotErr);
  Msg (274, 'NomVatIO', GotErr);

  Msg (275, 'AutoInc', GotErr);
  Msg (276, 'AutoIncBy', GotErr);
  Msg (277, 'AutoEndDate', GotErr);
  Msg (278, 'AutoEndPr', GotErr);
  Msg (279, 'AutoEndYr', GotErr);
  Msg (280, 'AutoPost', GotErr);
  Msg (281, 'thAutoTransaction', GotErr);
  Msg (282, 'thDeliveryRunNo', GotErr);
  Msg (283, 'thExternal', GotErr);
  Msg (284, 'thSettledVAT', GotErr);
  Msg (285, 'thVATClaimed', GotErr);
  Msg (286, 'thPickingRunNo', GotErr);
  Msg (287, 'thDeliveryNoteRef', GotErr);
  Msg (288, 'thVATCompanyRate', GotErr);
  Msg (289, 'thVATDailyRate', GotErr);
  Msg (290, 'thPostCompanyRate', GotErr);
  Msg (291, 'thPostDailyRate', GotErr);
  Msg (292, 'thPostDiscAmount', GotErr);
  Msg (293, 'thPostDiscTaken', GotErr);
  Msg (294, 'thLastDebtChaseLetter', GotErr);
  Msg (295, 'thRevaluationAdjustment', GotErr);
  Msg (296, 'YourRef', GotErr);
  Msg (297, 'thWeekMonth', GotErr);
  Msg (298, 'thWorkflowState', GotErr);
  Msg (299, 'thOverrideLocation', GotErr);

  //PR: 21/10/2011 v6.9
  Msg (4700, 'DocUser5', GotErr);
  Msg (4701, 'DocUser6', GotErr);
  Msg (4702, 'DocUser7', GotErr);
  Msg (4703, 'DocUser8', GotErr);
  Msg (4704, 'DocUser9', GotErr);
  Msg (4705, 'DocUser10', GotErr);
  Msg (4706, 'thDeliveryPostcode', GotErr);
  Msg (4707, 'thOriginator', GotErr);
  Msg (4708, 'thCreationTime', GotErr);
  Msg (4709, 'thCreationDate', GotErr);

  Msg (4710, 'thPPDPercentage', GotErr);
  Msg (4711, 'thPPDDays', GotErr);
  Msg (4712, 'thPPDGoodsValue', GotErr);
  Msg (4713, 'thPPDVATValue', GotErr);
  Msg (4714, 'thPPDTaken', GotErr);

  Msg (4715, 'thDeliveryCountry', GotErr);
  Msg (4716, 'thIntrastatOutOfPeriod', GotErr);

  Msg (4717, 'DocUser11', GotErr);
  Msg (4718, 'DocUser12', GotErr);

  Msg (240, 'Spare', GotErr);
  Msg (245, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchTHRec');
  End; { If }
end;

procedure TForm1.BatchTL(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchTLRec');
  ListBox1.Items.Add('-----------');
  Msg (300, 'TransRefNo', GotErr);
  Msg (330, 'PadChar1', GotErr);
  Msg (301, 'LineNo', GotErr);
  Msg (302, 'NomCode', GotErr);
  Msg (303, 'Currency', GotErr);
  Msg (331, 'PadChar2', GotErr);
  Msg (304, 'CoRate', GotErr);
  Msg (305, 'VATRate', GotErr);
  Msg (306, 'CC', GotErr);
  Msg (307, 'Dep', GotErr);
  Msg (308, 'StockCode', GotErr);
  Msg (332, 'PadChar3', GotErr);
  Msg (309, 'Qty', GotErr);
  Msg (310, 'QtyMul', GotErr);
  Msg (311, 'NetValue', GotErr);
  Msg (312, 'Discount', GotErr);
  Msg (313, 'VATCode', GotErr);
  Msg (333, 'PadChar4', GotErr);
  Msg (314, 'VAT', GotErr);
  Msg (315, 'Payment', GotErr);
  Msg (316, 'DiscountChr', GotErr);
  Msg (334, 'PadChar5', GotErr);
  Msg (317, 'QtyWOFF', GotErr);
  Msg (318, 'QtyDel', GotErr);
  Msg (319, 'CostPrice', GotErr);
  Msg (320, 'CustCode', GotErr);
  Msg (321, 'LineDate', GotErr);
  Msg (322, 'Item', GotErr);
  Msg (323, 'Desc', GotErr);
  Msg (324, 'LWeight', GotErr);
  Msg (325, 'MLocStk', GotErr);
  Msg (326, 'JobCode', GotErr);
  Msg (327, 'AnalCode', GotErr);
  Msg (328, 'TSHCCurr', GotErr);
  Msg (336, 'DocLTLink', GotErr);
  Msg (337, 'KitLink', GotErr);
  Msg (338, 'FolioNum', GotErr);
  Msg (339, 'LineType', GotErr);
  Msg (340, 'Reconcile', GotErr);
  Msg (342, 'SOPLink', GotErr);
  Msg (343, 'SOPLineNo', GotErr);
  Msg (344, 'ABSLineNo', GotErr);

  Msg (345, 'LineUser1', GotErr);
  Msg (346, 'LineUser2', GotErr);
  Msg (347, 'LineUser3', GotErr);
  Msg (348, 'LineUser4', GotErr);
  Msg (349, 'SSDUpLift', GotErr);
  Msg (350, 'SSDCommod', GotErr);
  Msg (354, 'PadChar7', GotErr);
  Msg (351, 'SSDSPUnit', GotErr);
  Msg (352, 'SSDUseLine', GotErr);
  Msg (355, 'PadChar8', GotErr);
  Msg (353, 'PriceMulx', GotErr);
  Msg (356, 'QtyPick', GotErr);

  Msg (357, 'VATIncFlg', GotErr);
  Msg (359, 'PadChar9', GotErr);
  Msg (358, 'QtyPWOff', GotErr);
  Msg (360, 'PadChar10', GotErr);
  Msg (361, 'RtnErrCode', GotErr);
  Msg (362, 'SSDCountry', GotErr);
  Msg (363, 'IncNetValue', GotErr);

  Msg (341, 'Spare2', GotErr);

  Msg (364, 'AutoLineType', GotErr);
  Msg (365, 'CISRateCode', GotErr);
  Msg (366, 'CISRate', GotErr);
  Msg (367, 'CostApport', GotErr);
  Msg (368, 'NomVatType', GotErr);
  Msg (369, 'BinQty', GotErr);

  Msg (370, 'tlAltStockFolio', GotErr);
  Msg (371, 'tlRunNo', GotErr);
  Msg (372, 'tlStockDeductQty', GotErr);
  Msg (373, 'tlUseQtyMul', GotErr);
  Msg (374, 'tlSerialQty', GotErr);
  Msg (375, 'tlPriceByPack', GotErr);
  Msg (376, 'tlReconciliationDate', GotErr);
  Msg (377, 'tlB2BLinkFolio', GotErr);
  Msg (378, 'tlB2BLineNo', GotErr);
  Msg (379, 'tlCOSDailyRate', GotErr);
  Msg (380, 'tlQtyPack', GotErr);

  Msg (381, 'tlMultiBuyDiscount', GotErr);
  Msg (382, 'PadChar19', GotErr);
  Msg (383, 'tlMultiBuyDiscountChr', GotErr);
  Msg (384, 'tlTransValueDiscount', GotErr);
  Msg (385, 'PadChar20', GotErr);
  Msg (386, 'tlTransValueDiscountChr', GotErr);
  Msg (387, 'tlTransValueDiscountType', GotErr);

  Msg (388, 'tlECService', GotErr);
  Msg (389, 'tlECServiceStartDate', GotErr);
  Msg (390, 'tlECServiceEndDate', GotErr);
  Msg (391, 'tlECSalesTaxReported', GotErr);
  Msg (392, 'tlECPurchaseServiceTax', GotErr);

  Msg (393, 'tlReference', GotErr);
  Msg (394, 'tlReceiptNo', GotErr);
  Msg (395, 'tlFromPostCode', GotErr);
  Msg (396, 'tlToPostCode', GotErr);
  Msg (397, 'tlIntrastatNoTC', GotErr);

  Msg (329, 'Spare', GotErr);
  Msg (335, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchTLRec');
  End; { If }
end;

procedure TForm1.SaleBands(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TSaleBandsRec');
  ListBox1.Items.Add('-------------');
  Msg(500, 'Currency',   GotErr);
  Msg(501, 'PadChar1',   GotErr);
  Msg(502, 'SalesPrice', GotErr);
  Msg(503, 'PadChar2',   GotErr);
  Msg(504, 'LastChar',   GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TSaleBandsRec');
  End; { If }
end;


procedure TForm1.BatchSK(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchSKRec');
  ListBox1.Items.Add('-----------');
  Msg (700, 'StockCode', GotErr);
  Msg (701, 'Desc', GotErr);
  Msg (702, 'AltCode', GotErr);
  Msg (703, 'SuppTemp', GotErr);
  Msg (759, 'PadChar1', GotErr);
  Msg (704, 'NomCodeS', GotErr);
  Msg (705, 'MinFlg', GotErr);
  Msg (760, 'PadChar2', GotErr);
  Msg (706, 'StockFolio', GotErr);
  Msg (707, 'StockCat', GotErr);
  Msg (708, 'StockType', GotErr);
  Msg (709, 'UnitK', GotErr);
  Msg (710, 'UnitS', GotErr);
  Msg (711, 'UnitP', GotErr);
  Msg (784, 'PadChar13', GotErr);
  Msg (712, 'PCurrency', GotErr);
  Msg (713, 'CostPrice', GotErr);
  Msg (714, 'SaleBands', GotErr);
  Msg (715, 'SellUnit', GotErr);
  Msg (716, 'BuyUnit', GotErr);
  Msg (717, 'VATCode', GotErr);
  Msg (718, 'CC', GotErr);
  Msg (719, 'Dep', GotErr);
  Msg (761, 'PadChar3', GotErr);
  Msg (720, 'QtyInStock', GotErr);
  Msg (721, 'QtyPosted', GotErr);
  Msg (722, 'QtyAllocated', GotErr);
  Msg (723, 'QtyOnOrder', GotErr);
  Msg (724, 'QtyMin', GotErr);
  Msg (725, 'QtyMax', GotErr);
  Msg (726, 'ROQty', GotErr);
  Msg (727, 'CommodCode', GotErr);
  Msg (762, 'PadChar4', GotErr);
  Msg (728, 'SWeight', GotErr);
  Msg (729, 'PWeight', GotErr);
  Msg (730, 'UnitSupp', GotErr);
  Msg (763, 'PadChar5', GotErr);
  Msg (731, 'SuppSUnit', GotErr);
  Msg (732, 'BinLoc', GotErr);
  Msg (764, 'PadChar6', GotErr);
  Msg (733, 'CovPr', GotErr);
  Msg (735, 'CovPrUnit', GotErr);
  Msg (765, 'PadChar7', GotErr);
  Msg (736, 'CovMinPr', GotErr);
  Msg (737, 'CovMinUnit', GotErr);
  Msg (738, 'Supplier', GotErr);
  Msg (739, 'CovSold', GotErr);
  Msg (740, 'UseCover', GotErr);
  Msg (741, 'CovMaxPr', GotErr);
  Msg (742, 'CovMaxUnit', GotErr);
  Msg (766, 'PadChar8', GotErr);
  Msg (743, 'ROCurrency', GotErr);
  Msg (744, 'ROCPrice', GotErr);
  Msg (745, 'RODate', GotErr);
  Msg (746, 'StkValType', GotErr);
  Msg (767, 'PadChar9', GotErr);
  Msg (747, 'QtyPicked', GotErr);
  Msg (748, 'LastUsed', GotErr);
  Msg (749, 'StBarCode', GotErr);
  Msg (750, 'StRoCostCentre', GotErr);
  Msg (751, 'StRoDepartment', GotErr);
  Msg (752, 'StLocation', GotErr);
  Msg (753, 'StPricePack', GotErr);
  Msg (754, 'StDPackQty', GotErr);
  Msg (755, 'StKitPrice', GotErr);
  Msg (756, 'StKitOnPurch', GotErr);
  Msg (757, 'StStkUser1', GotErr);
  Msg (758, 'StStkUser2', GotErr);

  Msg (770, 'JAnalCode', GotErr);
  Msg (781, 'PadChar11', GotErr);
  Msg (771, 'WebInclude', GotErr);
  Msg (772, 'WebLiveCat', GotErr);
  Msg (773, 'StkUser3', GotErr);
  Msg (774, 'StkUser4', GotErr);
  Msg (782, 'PadChar12', GotErr);
  Msg (775, 'SerNoWAvg', GotErr);
  Msg (776, 'SSDDUpLift', GotErr);
  Msg (777, 'Timecharge', GotErr);
  Msg (778, 'SVATIncFlg', GotErr);
  Msg (779, 'LastOpo', GotErr);
  Msg (780, 'ImageFile', GotErr);
  Msg (783, 'WebPrevCat', GotErr);
  Msg (785, 'SSDCountry', GotErr);
  Msg (787, 'PadChar14', GotErr);
  Msg (788, 'StkLinkLT', GotErr);
  Msg (789, 'PriceByStkUnit', GotErr);
  Msg (790, 'ShowAsKit', GotErr);
  Msg (791, 'QtyPickWOR', GotErr);
  Msg (792, 'UsesBins', GotErr);

  Msg ( 793, 'SSDAUplift', GotErr);
  Msg ( 794, 'BOMProdTime', GotErr);
  Msg ( 795, 'WOPProdTimeDays', GotErr);
  Msg ( 796, 'WOPProdTimeHours', GotErr);
  Msg ( 797, 'WOPProdTimeMins', GotErr);
  Msg ( 798, 'WOPLeadTime', GotErr);
  Msg ( 799, 'WOPCalcProdTime', GotErr);
  Msg (4600, 'WOPMinEcQty', GotErr);
  Msg (4601, 'WOPIssuedWIPGL', GotErr);
  Msg (4602, 'QtyAllocWOR', GotErr);
  Msg (4603, 'QtyIssueWOR', GotErr);
  Msg (4604, 'WOPMinEcQty', GotErr);
  Msg (4605, 'QtyStockTake', GotErr);
  Msg (4606, 'QtyStockTakeChanged', GotErr);
  Msg (4607, 'QtyFreeze', GotErr);
  Msg (4608, 'BinLoc10', GotErr);

  Msg (4609, 'StkUser5', GotErr);
  Msg (4610, 'StkUser6', GotErr);
  Msg (4611, 'StkUser7', GotErr);
  Msg (4612, 'StkUser8', GotErr);
  Msg (4613, 'StkUser9', GotErr);
  Msg (4614, 'StkUser10', GotErr);


  Msg (786, 'Spare', GotErr);
  Msg (769, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSKRec');
  End; { If }
end;

procedure TForm1.HistoryBal(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('THistoryBalRec');
  ListBox1.Items.Add('--------------');
  Msg (800, 'Period', GotErr);
  Msg (801, 'Year', GotErr);
  Msg (802, 'Currency', GotErr);
  Msg (804, 'PadChar1', GotErr);
  Msg (803, 'Value', GotErr);
  Msg (805, 'PadChar2', GotErr);
  Msg (808, 'PadChar3', GotErr);
  Msg (807, 'CommitVal', GotErr);
  Msg (809, 'PadChar4', GotErr);
  Msg (806, 'LastChar', GotErr);


  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in THistoryBalRec');
  End; { If }
end;

procedure TForm1.BatchNom(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchNomRec');
  ListBox1.Items.Add('------------');
  Msg (900, 'NomCode', GotErr);
  Msg (901, 'Desc', GotErr);
  Msg (910, 'PadChar1', GotErr);
  Msg (902, 'Cat', GotErr);
  Msg (903, 'NomType', GotErr);
  Msg (911, 'PadChar1', GotErr);
  Msg (904, 'NomPage', GotErr);
  Msg (905, 'SubType', GotErr);
  Msg (906, 'Total', GotErr);
  Msg (907, 'CarryF', GotErr);
  Msg (908, 'ReValue', GotErr);
  Msg (913, 'AltCode', GotErr);
  Msg (915, 'PadChar4', GotErr);
  Msg (914, 'DefCurr', GotErr);
  Msg (912, 'PadChar3', GotErr);
  Msg (917, 'Inactive', GotErr);
  Msg (918, 'LongDesc', GotErr);
  Msg (916, 'Spare', GotErr);
  Msg (909, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchNomRec');
  End; { If }
end;

procedure TForm1.BatchBOM(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchBOMRec');
  ListBox1.Items.Add('------------');
  Msg (1000, 'StockCode', GotErr);
  Msg (1003, 'PadChar1', GotErr);
  Msg (1001, 'QtyUsed', GotErr);
  Msg (1002, 'QtyCost', GotErr);
  Msg (1004, 'PadChar2', GotErr);
  Msg (1005, 'LastChar', GotErr);
  Msg (1006, 'Spare', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchBOMRec');
  End; { If }
end;

procedure TForm1.BatchSR(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchSRRec');
  ListBox1.Items.Add('-----------');
  Msg (1200, 'SerialNo', GotErr);
  Msg (1201, 'BatchNo', GotErr);
  Msg (1202, 'DateOut', GotErr);
  Msg (1212, 'PadChar1', GotErr);
  Msg (1203, 'SerCost', GotErr);
  Msg (1204, 'SerSell', GotErr);
  Msg (1205, 'CurCost', GotErr);
  Msg (1206, 'CurSell', GotErr);
  Msg (1207, 'InMLoc', GotErr);
  Msg (1208, 'OutMLoc', GotErr);
  Msg (1215, 'PadChar3', GotErr);
  Msg (1209, 'BuyQty', GotErr);
  Msg (1210, 'QtyUsed', GotErr);
  Msg (1211, 'Sold', GotErr);
  Msg (1213, 'PadChar2', GotErr);
  Msg (1214, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSRRec');
  End; { If }
end;

procedure TForm1.BatchJH(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchJHRec');
  ListBox1.Items.Add('-----------');
  Msg (1400, 'JobCode', GotErr);
  Msg (1401, 'JobDesc', GotErr);
  Msg (1420, 'PadChar1', GotErr);
  Msg (1402, 'JobFolio', GotErr);
  Msg (1403, 'CustCode', GotErr);
  Msg (1404, 'JobCat', GotErr);
  Msg (1405, 'JobAltCode', GotErr);
  Msg (1421, 'PadChar2', GotErr);
  Msg (1406, 'Completed', GotErr);
  Msg (1407, 'Contact', GotErr);
  Msg (1408, 'JobMan', GotErr);
  Msg (1409, 'ChargeType', GotErr);
  Msg (1410, 'QuotePrice', GotErr);
  Msg (1411, 'CurrPrice', GotErr);
  Msg (1412, 'StartDate', GotErr);
  Msg (1413, 'EndDate', GotErr);
  Msg (1414, 'RevEDate', GotErr);
  Msg (1415, 'SORRef', GotErr);
  Msg (1416, 'VATCode', GotErr);
  Msg (1417, 'JobAnal', GotErr);
  Msg (1418, 'JobType', GotErr);
  Msg (1419, 'JobStat', GotErr);
  Msg (1423, 'UserDef1', GotErr);
  Msg (1424, 'UserDef2', GotErr);

  //PR: 21/10/2011 v6.9
  Msg (1425, 'UserDef3', GotErr);
  Msg (1426, 'UserDef4', GotErr);
  Msg (1427, 'UserDef5', GotErr);
  Msg (1428, 'UserDef6', GotErr);
  Msg (1429, 'UserDef7', GotErr);
  Msg (1430, 'UserDef9', GotErr);
  Msg (1431, 'UserDef9', GotErr);
  Msg (1432, 'UserDef10', GotErr);
  Msg (1433, 'jrCostCentre', GotErr);
  Msg (1434, 'jrDepartment', GotErr);

  Msg (1422, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchJHRec');
  End; { If }
end;

procedure TForm1.BatchSL(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchSLRec');
  ListBox1.Items.Add('-----------');
  {Msg (1500, 'RunNo', GotErr);}
  Msg (1500, 'lsStkCode', GotErr);
  Msg (1501, 'lsLocCode', GotErr);
  Msg (1530, 'PadChar1', GotErr);
  Msg (1502, 'lsQtyInStock', GotErr);
  Msg (1503, 'lsQtyOnOrder', GotErr);
  Msg (1504, 'lsQtyAlloc', GotErr);
  Msg (1505, 'lsQtyPicked', GotErr);
  Msg (1506, 'lsQtyMin', GotErr);
  Msg (1507, 'lsQtyMax', GotErr);
  Msg (1508, 'lsQtyFreeze', GotErr);
  Msg (1509, 'lsRoQty', GotErr);
  Msg (1510, 'lsRoDate', GotErr);
  Msg (1511, 'lsRoCC', GotErr);
  Msg (1512, 'lsRoDep', GotErr);
  Msg (1513, 'lsCC', GotErr);
  Msg (1514, 'lsDep', GotErr);
  Msg (1515, 'lsBinLoc', GotErr);
  Msg (1516, 'lsSaleBands', GotErr);
  Msg (1517, 'lsRoPrice', GotErr);
  Msg (1518, 'lsRoCurrency', GotErr);
  Msg (1531, 'PadChar2', GotErr);
  Msg (1519, 'lsCostPrice', GotErr);
  Msg (1520, 'lsPCurrency', GotErr);
  Msg (1532, 'PadChar3', GotErr);
  Msg (1521, 'lsDefNom', GotErr);
  Msg (1522, 'lsMinFlg', GotErr);
  Msg (1523, 'lsTempSupp', GotErr);
  Msg (1524, 'lsSupplier', GotErr);
  Msg (1526, 'lsLastUsed', GotErr);
  Msg (1533, 'PadChar4', GotErr);
  Msg (1527, 'lsQtyPosted', GotErr);
  Msg (1528, 'lsQtyTake', GotErr);
  Msg (1536, 'lsLasttime', GotErr);

  Msg (1537, 'lsQtyAllocWOR', GotErr);
  Msg (1538, 'lsQtyIssueWOR', GotErr);
  Msg (1539, 'lsQtyPickWOR', GotErr);
  Msg (1540, 'lsWOPWIPGL', GotErr);

  Msg (1529, 'Spare2', GotErr);
  Msg (1535, 'PadChar5', GotErr);
  Msg (1534, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSLRec');
  End; { If }
end;

procedure TForm1.BatchMLoc(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchMLocRec');
  ListBox1.Items.Add('-------------');
  Msg (1600, 'loCode', GotErr);
  Msg (1601, 'loName', GotErr);
  Msg (1602, 'loAddr', GotErr);
  Msg (1603, 'loTel', GotErr);
  Msg (1604, 'loFax', GotErr);
  Msg (1605, 'loemail', GotErr);
  Msg (1606, 'loModem', GotErr);
  Msg (1607, 'loContact', GotErr);
  Msg (1621, 'PadChar1', GotErr);
  Msg (1608, 'loCurrency', GotErr);
  Msg (1609, 'loArea', GotErr);
  Msg (1610, 'loRep', GotErr);
  Msg (1611, 'loTag', GotErr);
  Msg (1612, 'loNominal', GotErr);
  Msg (1613, 'loCC', GotErr);
  Msg (1614, 'loDep', GotErr);
  Msg (1615, 'loUsePrice', GotErr);
  Msg (1616, 'loUseNom', GotErr);
  Msg (1617, 'loUseCCDep', GotErr);
  Msg (1618, 'loUseSupp', GotErr);
  Msg (1619, 'loUseBinLoc', GotErr);
  Msg (1620, 'Spare2', GotErr);
  Msg (1622, 'LastChar', GotErr);
  Msg (1623, 'loNLineCount', GotErr);
  Msg (1624, 'loUseCPrice', GotErr);
  Msg (1625, 'loUseRPrice', GotErr);
  Msg (1626, 'loWOPWIPGL', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchMLocRec');
  End; { If }
end;

procedure TForm1.BatchMatch(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchMatchRec');
  ListBox1.Items.Add('--------------');
  Msg (1700, 'DebitRef', GotErr);
  Msg (1701, 'CreditRef', GotErr);
  Msg (1702, 'DebitCr', GotErr);
  Msg (1703, 'CreditCr', GotErr);
  Msg (1704, 'DebitVal', GotErr);
  Msg (1705, 'CreditVal', GotErr);
  Msg (1706, 'BaseVal', GotErr);
  Msg (1707, 'Spare', GotErr);
  Msg (1710, 'Spare2', GotErr);
  Msg (1709, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchMatchRec');
  End; { If }
end;

procedure TForm1.BatchNotes(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchNotesRec');
  ListBox1.Items.Add('--------------');
  Msg (1800, 'NoteSort', GotErr);
  Msg (1801, 'NoteType', GotErr);
  Msg (1802, 'NoteCode', GotErr);
  Msg (1803, 'NoteDate', GotErr);
  Msg (1804, 'AlarmDate', GotErr);
  Msg (1805, 'AlarmSet', GotErr);
  Msg (1810, 'PadChar1', GotErr);
  Msg (1806, 'LineNo', GotErr);
  Msg (1807, 'User', GotErr);
  Msg (1808, 'NoteLine', GotErr);
  Msg (1814, 'PadChar2', GotErr);
  Msg (1812, 'RepeatDays', GotErr);
  Msg (1813, 'NoteFor', GotErr);
  Msg (1809, 'Spare', GotErr);
  Msg (1811, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchNotesRec');
  End; { If }
end;

procedure TForm1.BatchCCDep(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchCCDepRec');
  ListBox1.Items.Add('--------------');
  Msg (1900, 'CCDepCode', GotErr);
  Msg (1902, 'CCDepDesc', GotErr);
  Msg (1901, 'Spare', GotErr);
  Msg (1903, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchCCDepRec');
  End; { If }
end;

procedure TForm1.StkPrice(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchStkPriceRec');
  ListBox1.Items.Add('-----------------');
  Msg (2000, 'StockCode', GotErr);
  Msg (2001, 'CustCode', GotErr);
  Msg (2002, 'Currency', GotErr);
  Msg (2008, 'PadChar1', GotErr);
  Msg (2003, 'Qty', GotErr);
  Msg (2004, 'Price', GotErr);
  Msg (2005, 'DiscVal', GotErr);
  Msg (2006, 'DiscChar', GotErr);
  Msg (2010, 'LocCode', GotErr);
  Msg (2011, 'PriceDate', GotErr);
  Msg (2007, 'Spare', GotErr);
  Msg (2009, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchStkPriceRec');
  End; { If }
end;

procedure TForm1.BatchVAT(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchVATRec');
  ListBox1.Items.Add('------------');
  Msg (2100, 'VATCode', GotErr);
  Msg (2102, 'PadChar1', GotErr);
  Msg (2101, 'VATRate', GotErr);
  Msg (2105, 'VATDesc', GotErr);
  Msg (2106, 'VATSpare', GotErr);
  Msg (2104, 'PadChar2', GotErr);
  Msg (2103, 'LastChar', GotErr);


  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchVATRec');
  End; { If }
end;

procedure TForm1.BatchCurr(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchCurrRec');
  ListBox1.Items.Add('------------');
  Msg (2200, 'Name', GotErr);
  Msg (2201, 'ScreenSymb', GotErr);
  Msg (2202, 'PrinterSymb', GotErr);
  Msg (2203, 'DailyRate', GotErr);
  Msg (2204, 'CompanyRate', GotErr);

  Msg (2207, 'TriEuro', GotErr);
  Msg (2211, 'PadChar2', GotErr);
  Msg (2208, 'TriRates', GotErr);
  Msg (2209, 'TriInvert', GotErr);
  Msg (2210, 'TriFloat', GotErr);

  Msg (2206, 'PadChar1', GotErr);
  Msg (2205, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchCurrRec');
  End; { If }
end;

procedure TForm1.BatchSyss(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchSysRec');
  ListBox1.Items.Add('------------');
  Msg (2300, 'UserName', GotErr);
  Msg (2301, 'UserAddr[1]', GotErr);
  Msg (2302, 'UserAddr[2]', GotErr);
  Msg (2303, 'UserAddr[3]', GotErr);
  Msg (2304, 'UserAddr[4]', GotErr);
  Msg (2305, 'UserAddr[5]', GotErr);
  Msg (2306, 'UserSort', GotErr);
  Msg (2307, 'UserAcc', GotErr);
  Msg (2308, 'UserRef', GotErr);
  Msg (2309, 'UserBank', GotErr);
  Msg (2310, 'ExPr', GotErr);
  Msg (2311, 'ExYr', GotErr);
  Msg (2314, 'DirectCust', GotErr);
  Msg (2315, 'DirectSupp', GotErr);
  Msg (2316, 'PriceDP', GotErr);
  Msg (2317, 'CostDP', GotErr);
  Msg (2318, 'QuantityDP', GotErr);
  Msg (2319, 'MultiLocn', GotErr);
  Msg (2320, 'UserVatReg', GotErr);
  Msg (2321, 'PadChar', GotErr);
  Msg (2322, 'PeriodsPerY', GotErr);
  Msg (2323, 'CCDepts', GotErr);
  Msg (2324, 'IntraStat', GotErr);
  Msg (2325, 'ExchangeRate', GotErr);
  Msg (2326, 'FinYearStart', GotErr);
  Msg (2327, 'TraderUDFLabel', GotErr);
  Msg (2328, 'StockUDFLabel', GotErr);
  Msg (2329, 'TransHeadUDFLabel', GotErr);
  Msg (2330, 'TransHeadUDFHide', GotErr);
  Msg (2331, 'TransLineUDFLabel', GotErr);
  Msg (2332, 'TransLineUDFHide', GotErr);
  Msg (2333, 'TransLineTypeLabel', GotErr);
  Msg (2334, 'TransLineTytpeHide', GotErr);
  Msg (2335, 'JobCostUDFLabel', GotErr);
  Msg (2336, 'CurrentCountry', GotErr);
  Msg (2337, 'OrderAllocStock', GotErr);
  Msg (2338, 'CalPrFromDate', GotErr);
 
  Msg (2339, 'UseCrLimitChk', GotErr);
  Msg (2340, 'UseCreditChk', GotErr);
  Msg (2341, 'StopBadDr', GotErr);
  Msg (2342, 'UsePick4All', GotErr);
  Msg (2343, 'FreeExAll', GotErr);
  Msg (2344, 'WksODue', GotErr);

  Msg(2345, 'DeductBomComponents', GotErr);
  Msg(2346, 'FilterSNoByBinLoc', GotErr);
  Msg(2347, 'KeepBinHistory', GotErr);
  Msg(2348, 'BinMask', GotErr);
  Msg(2349, 'InputPackQtyOnLine', GotErr);
  Msg(2350, 'PercentageDiscounts', GotErr);

  Msg(2351, 'TTDEnabled', GotErr);
  Msg(2352, 'VBDEnabled', GotErr);

  Msg(2353, 'ECServicesEnabled', GotErr);
  Msg(2354, 'ECSalesThreshold', GotErr);

  //PR: 15/10/2010 New field for LIVE
  Msg(2355, 'EnableOverrideLocation', GotErr);

  //PR: 28/11/2013 ABSEXCH-14797 Consumers
  Msg(2356, 'CustomersEnabled', GotErr);

  Msg (2312, 'Spare', GotErr);
  Msg (2313, 'LastChar', GotErr);


  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSysRec');
  End; { If }
end;

procedure TForm1.BatchAB(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchAutoBankRec');
  ListBox1.Items.Add('-----------------');
  Msg (2400, 'BankRef', GotErr);
  Msg (2401, 'BankValue', GotErr);
  Msg (2402, 'BankNom', GotErr);
  Msg (2403, 'BankCr', GotErr);
  Msg (2404, 'EntryOpo', GotErr);
  Msg (2405, 'EntryDate', GotErr);
  Msg (2406, 'Spare', GotErr);
  Msg (2407, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchAutoBankRec');
  End; { If }
end;


procedure TForm1.BatchBomImp(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchBomImp }
  GotErr := -1;

  ListBox1.Items.Add('TBatchBOMImportRec');
  ListBox1.Items.Add('------------------');
  Msg (2500, 'PStockCode', GotErr);
  Msg (2501, 'MStockCode', GotErr);
  Msg (2506, 'PadChar1', GotErr);
  Msg (2502, 'QtyUsed', GotErr);
  Msg (2503, 'DeleteStat', GotErr);
  Msg (2504, 'Spare', GotErr);
  Msg (2505, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchBOMImportRec');
  End; { If }
end;


procedure TForm1.BatchSer(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchSer }
  GotErr := -1;

  ListBox1.Items.Add('TBatchSerialRec');
  ListBox1.Items.Add('------------------');
  Msg (2600, 'SerialNo', GotErr);
  Msg (2601, 'BatchNo', GotErr);
  Msg (2602, 'StockCode', GotErr);
  Msg (2603, 'InDoc', GotErr);
  Msg (2604, 'DateIn', GotErr);
  Msg (2627, 'PadChar1', GotErr);
  Msg (2605, 'SerCost', GotErr);
  Msg (2606, 'CurCost', GotErr);
  Msg (2628, 'PadChar2', GotErr);
  Msg (2607, 'BuyABSLine', GotErr);
  Msg (2608, 'BuyQty', GotErr);
  Msg (2609, 'InMLoc', GotErr);
  Msg (2610, 'OutDoc', GotErr);
  Msg (2611, 'DateOut', GotErr);
  Msg (2612, 'SerSell', GotErr);
  Msg (2613, 'CurSell', GotErr);
  Msg (2629, 'PadChar3', GotErr);
  Msg (2614, 'SoldABSLine', GotErr);
  Msg (2615, 'QtyUsed', GotErr);
  Msg (2616, 'OutMLoc', GotErr);
  Msg (2617, 'Sold', GotErr);
  Msg (2618, 'BatchRec', GotErr);
  Msg (2619, 'BatchChild', GotErr);
  Msg (2630, 'PadChar4', GotErr);
  Msg (2620, 'CoRate', GotErr);
  Msg (2621, 'DailyRate', GotErr);
  Msg (2622, 'InOrdDoc', GotErr);
  Msg (2631, 'PadChar5', GotErr);
  Msg (2623, 'InOrdLine', GotErr);
  Msg (2624, 'OutOrdDoc', GotErr);
  Msg (2632, 'PadChar6', GotErr);
  Msg (2625, 'OutOrdLine', GotErr);
  Msg (2634, 'DateUseX', GotErr);
  Msg (2636, 'PadChar7', GotErr);
  Msg (2635, 'DoNotUpdateTL', GotErr);
  Msg (2638, 'PadChar8', GotErr);
  Msg (2637, 'RecPos', GotErr);
  Msg (2626, 'Spare', GotErr);
  Msg (2633, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSerialRec');
  End; { If }
end; { BatchSer }


procedure TForm1.BatchEmployee(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchEmployee }
  GotErr := -1;

  ListBox1.Items.Add('TBatchEmplRec');
  ListBox1.Items.Add('-------------');

  Msg (2700, 'EmpCode', GotErr);
  Msg (2701, 'Supplier', GotErr);
  Msg (2702, 'EmpName', GotErr);
  Msg (2703, 'Addr[1]', GotErr);
  Msg (2704, 'Addr[2]', GotErr);
  Msg (2705, 'Addr[3]', GotErr);
  Msg (2706, 'Addr[4]', GotErr);
  Msg (2707, 'Addr[5]', GotErr);
  Msg (2708, 'Phone', GotErr);
  Msg (2709, 'Fax', GotErr);
  Msg (2710, 'Mobile', GotErr);
  Msg (2711, 'EmpType', GotErr);
  Msg (2712, 'PayNo', GotErr);
  Msg (2713, 'CertNo', GotErr);
  Msg (2714, 'CertExpiry', GotErr);
  Msg (2720, 'PadChar1', GotErr);
  Msg (2715, 'UseORate', GotErr);
  Msg (2716, 'UserDef1', GotErr);
  Msg (2717, 'UserDef2', GotErr);
  Msg (2721, 'CC', GotErr);
  Msg (2722, 'Dep', GotErr);
  Msg (2723, 'SelfBill', GotErr);
  Msg (2724, 'GroupCert', GotErr);
  Msg (2725, 'CertType', GotErr);
  Msg (2726, 'UserDef3', GotErr);
  Msg (2727, 'UserDef4', GotErr);
  Msg (2718, 'Spare', GotErr);
  Msg (2719, 'LastChar', GotErr);

  Msg (2728, 'ENINo', GotErr);
  Msg (2729, 'LabourPLOnly', GotErr);

  Msg (2730, 'emEmailAddress', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchEmplRec');
  End; { If }
end; { BatchEmployee }

procedure TForm1.BatchJobAnal(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchJobAnal }
  GotErr := -1;

  ListBox1.Items.Add('TBatchJobAnalRec');
  ListBox1.Items.Add('----------------');

  Msg (2800, 'JAnalCode', GotErr);
  Msg (2801, 'JAnalDesc', GotErr);
  Msg (2802, 'JAnalType', GotErr);
  Msg (2803, 'JAnalCatry', GotErr);
  Msg (2804, 'WIPNomCode', GotErr);
  Msg (2805, 'PLNomCode', GotErr);
  Msg (2806, 'LineType', GotErr);
  Msg (2807, 'Spare', GotErr);
  Msg (2808, 'LastChar', GotErr);

  Msg (2809, 'CISTaxRate', GotErr);
  Msg (2810, 'UpliftP', GotErr);
  Msg (2811, 'UpliftGL', GotErr);
  Msg (2812, 'RevenueType', GotErr);
  Msg (2813, 'jaPayCode', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchJobAnalRec');
  End; { If }
end; { BatchJobAnal }

procedure TForm1.BatchJobRate(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchJobRate }
  GotErr := -1;

  ListBox1.Items.Add('TBatchJobRateRec');
  ListBox1.Items.Add('----------------');

  Msg (2900, 'JEmpCode', GotErr);
  Msg (2901, 'JRateCode', GotErr);
  Msg (2902, 'JRateDesc', GotErr);
  Msg (2903, 'JAnalCode', GotErr);
  Msg (2904, 'CostCurr', GotErr);
  Msg (2911, 'PadChar1', GotErr);
  Msg (2905, 'Cost', GotErr);
  Msg (2906, 'ChargeCurr', GotErr);
  Msg (2912, 'PadChar2', GotErr);
  Msg (2907, 'ChargeRate', GotErr);
  Msg (2908, 'PayRollCode', GotErr);
  Msg (2913, 'PayFactor', GotErr);
  Msg (2914, 'PayRate', GotErr);
  Msg (2909, 'Spare', GotErr);
  Msg (2910, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchJobRateRec');
  End; { If }
end; { BatchJobRate }

procedure TForm1.BatchDiscRate(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchDiscRate }
  GotErr := -1;

  ListBox1.Items.Add('TBatchDiscRec');
  ListBox1.Items.Add('-------------');

  Msg (3000, 'CustCode', GotErr);
  Msg (3001, 'StockCode', GotErr);
  Msg (3002, 'DiscType', GotErr);
  Msg (3003, 'SalesBand', GotErr);
  Msg (3004, 'SPCurrency', GotErr);
  Msg (3005, 'SPrice', GotErr);
  Msg (3006, 'DiscPer', GotErr);
  Msg (3007, 'DiscAmt', GotErr);
  Msg (3008, 'DiscMar', GotErr);
  Msg (3009, 'QtyBreak', GotErr);
  Msg (3010, 'QtyFr', GotErr);
  Msg (3011, 'QtyTo', GotErr);
  Msg (3012, 'Spare', GotErr);
  Msg (3013, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchDiscRec');
  End; { If }
end; { BatchDiscRate }

procedure TForm1.BatchStockAlt(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchStockAlt }
  GotErr := -1;

  ListBox1.Items.Add('TBatchSKAltRec');
  ListBox1.Items.Add('-------------');

  Msg (3100, 'StockCode', GotErr);
  Msg (3101, 'AltCode', GotErr);
  Msg (3102, 'AltDesc', GotErr);
  Msg (3103, 'SuppCode', GotErr);
  Msg (3108, 'PadChar1', GotErr);
  Msg (3104, 'ROCurr', GotErr);
  Msg (3105, 'ROPrice', GotErr);
  Msg (3106, 'UseROPrice', GotErr);
  Msg (3107, 'LastUsed', GotErr);
  Msg (3111, 'LastTime', GotErr);
  Msg (3112, 'PadChar2', GotErr);

  Msg (3110, 'Spare', GotErr);
  Msg (3109, 'LastChar', GotErr);


  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchSKAltRec');
  End; { If }
end; { BatchStockAlt }

procedure TForm1.BatchJobType(Sender: TObject);
Var
  GotErr : SmallInt;
begin { BatchJobType }
  GotErr := -1;

  ListBox1.Items.Add('TBatchJobTypeRec');
  ListBox1.Items.Add('----------------');

  Msg (3300, 'JTypeCode', GotErr);
  Msg (3301, 'JTypeDesc', GotErr);
  Msg (3302, 'Spare', GotErr);
  Msg (3303, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchJobTypeRec');
  End; { If }
end; { BatchJobType }

procedure TForm1.TLArray(Sender: TObject);
Var
  GotErr : SmallInt;
begin { TLArray }
  GotErr := -1;

  ListBox1.Items.Add('TLArrayInfoType');
  ListBox1.Items.Add('---------------');

  Msg (3200, 'TLArray', GotErr);
  Msg (3201, 'NumTL', GotErr);
  Msg (3202, 'UsedSize', GotErr);
  Msg (3203, 'MaxTL', GotErr);
  Msg (3204, 'TLSize', GotErr);
  Msg (3205, 'Spare', GotErr);
  Msg (3206, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TLArrayInfoType');
  End; { If }
end; { TLArray }

procedure TForm1.BatchConvTCurr(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchConvTCurr');
  ListBox1.Items.Add('------------');
  Msg (3400, 'Amount', GotErr);
  Msg (3401, 'Rate', GotErr);
  Msg (3402, 'AmtCurr', GotErr);
  Msg (3403, 'ConvMode', GotErr);
  Msg (3404, 'ConvTo', GotErr);
  Msg (3408, 'PadChar1', GotErr);
  Msg (3405, 'RtnValue', GotErr);
  Msg (3406, 'Spare', GotErr);
  Msg (3407, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchConvTCurr');
  End; { If }
end;

procedure TForm1.SysECommsRec(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TSysECommsRec');
  ListBox1.Items.Add('------------');
  Msg (3500, 'YourEmailName', GotErr );
  Msg (3501, 'YourEmailAddr', GotErr );
  Msg (3502, 'SMTPServerName', GotErr );
  Msg (3503, 'Priority', GotErr);
  Msg (3504, 'UseMAPI', GotErr);
  Msg (3505, 'Spare', GotErr);
  Msg (3506, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TSysECommsRec');
  End; { If }
end;

procedure TForm1.DefaultForm(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TDefaultFormRecType');
  ListBox1.Items.Add('-------------------');
  Msg (3600, 'dfAccount', GotErr );
  Msg (3604, 'dfPadChar1', GotErr );
  Msg (3601, 'dfFormNo', GotErr );
  Msg (3606, 'dfCheckGlobal', GotErr );
  Msg (3602, 'dfFormName', GotErr );
  Msg (3605, 'dfSpare', GotErr );
  Msg (3603, 'dfLastChar', GotErr );

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TDefaultFormRecType');
  End; { If }
end;

procedure TForm1.PrintEmail(Sender: TObject);
Var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TEmailPrintInfoType');
  ListBox1.Items.Add('-------------------');
  Msg (3700, 'emPreview', GotErr);
  Msg (3709, 'emCoverSheet', GotErr);
  Msg (3701, 'emSenderName', GotErr);
  Msg (3702, 'emSenderAddr', GotErr);
  Msg (3703, 'emSubject', GotErr);
  Msg (3704, 'emPriority', GotErr);
  Msg (3705, 'emSendReader', GotErr);
  Msg (3706, 'emCompress', GotErr);
  Msg (3708, 'emSpare', GotErr);
  Msg (3707, 'emLastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TEmailPrintInfoType');
  End; { If }
end;

procedure TForm1.DefaultVATCode(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TVATCodeDefaultType');
  ListBox1.Items.Add('-------------------');
  Msg (3800, 'StockVATCode', GotErr);
  Msg (3801, 'AccountVATCode', GotErr);
  Msg (3802, 'DefaultVATCode', GotErr);
  Msg (3803, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TVATCodeDefaultType');
  End; { If }
end;

procedure TForm1.EntInfo(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TEnterpriseInfoType');
  ListBox1.Items.Add('-------------------');
  Msg (3900, 'eiDefined', GotErr);
  Msg (3901, 'eiEntVersion', GotErr);
  Msg (3902, 'eiEntPath', GotErr);
  Msg (3903, 'eiDataPath', GotErr);
  Msg (3904, 'eiUserName', GotErr);
  Msg (3905, 'eiCurrencyVer', GotErr);
  Msg (3906, 'eiSpare', GotErr);
  Msg (3907, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TEnterpriseInfoType');
  End; { If }
end;

procedure TForm1.UserProf(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TUserProfileType');
  ListBox1.Items.Add('----------------');
  Msg (4000, 'upUserId', GotErr);
  Msg (4001, 'upName', GotErr);
  Msg (4002, 'upEmail', GotErr);
  Msg (4003, 'upLockOutMins', GotErr);
  Msg (4004, 'upDefSRICust', GotErr);
  Msg (4005, 'upDefPPISupp', GotErr);
  Msg (4006, 'upDefCostCentre', GotErr);
  Msg (4007, 'upDefDepartment', GotErr);
  Msg (4008, 'upDefCCDeptRule', GotErr);
  Msg (4009, 'upDefLocation', GotErr);
  Msg (4010, 'upDefLocRule', GotErr);
  Msg (4011, 'upDefSalesBankGL', GotErr);
  Msg (4012, 'upDefPurchBankGL', GotErr);
  Msg (4013, 'upMaxSalesAuth', GotErr);
  Msg (4014, 'upMaxPurchAuth', GotErr);
  Msg (4015, 'upSpare', GotErr);
  Msg (4016, 'LastChar', GotErr);
  Msg (4017, 'upShowGLCodesInTree', GotErr);
  Msg (4018, 'upShowProductTypesInTree', GotErr);
  Msg (4019, 'upShowStockCodesInTree', GotErr);
  Msg (4020, 'upUserStatus', GotErr);
  Msg (4021, 'upWindowsUserId', GotErr);
  Msg (4022, 'HighlightPIIFields', GotErr);
  Msg (4023, 'HighlightPIIColour', GotErr); 

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TUserProfileType');
  End; { If }
end;

procedure TForm1.Links(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchLinkRec');
  ListBox1.Items.Add('----------------');
  Msg (4100, 'lkCode', GotErr);
  Msg (4114, 'lkPadChar1', GotErr);
  Msg (4101, 'lkFolioKey', GotErr);
  Msg (4102, 'lkAttachTo', GotErr);
  Msg (4103, 'lkLetterLink', GotErr);
  Msg (4104, 'lkLinkType', GotErr);
  Msg (4105, 'lkDate', GotErr);
  Msg (4106, 'lkTime', GotErr);
  Msg (4107, 'lkUserCode', GotErr);
  Msg (4108, 'lkLetterDescription', GotErr);
  Msg (4109, 'lkLetterFileName', GotErr);
  Msg (4110, 'lkLinkDescription', GotErr);
  Msg (4111, 'lkLinkFileName', GotErr);
  Msg (4112, 'lkSpare', GotErr);
  Msg (4113, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchLinkRec');
  End; { If }
end;

procedure TForm1.Conv(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchConvRec');
  ListBox1.Items.Add('----------------');
  Msg (4200, 'cvDocFrom', GotErr);
  Msg (4201, 'cvDocTo', GotErr);
  Msg (4202, 'cvDocToType', GotErr);
  Msg (4203, 'cvStatus', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchConvRec');
  End; { If }
end;

procedure TForm1.Bin(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchBinRec');
  ListBox1.Items.Add('----------------');

  Msg (4300, 'brBinCode', GotErr);
  Msg (4301, 'brInDocRef', GotErr);
  Msg (4302, 'brOutDocRef', GotErr);
  Msg (4303, 'PadChar1', GotErr);
  Msg (4304, 'brSold', GotErr);
  Msg (4305, 'brInDate', GotErr);
  Msg (4306, 'PadChar2', GotErr);
  Msg (4307, 'brCostPrice', GotErr);
  Msg (4308, 'brCapacity', GotErr);
  Msg (4309, 'brStockFolio', GotErr);
  Msg (4310, 'brOutDate', GotErr);
  Msg (4311, 'PadChar3', GotErr);
  Msg (4312, 'brOutDocLine', GotErr);
  Msg (4313, 'brInDocLine', GotErr);
  Msg (4314, 'brQty', GotErr);
  Msg (4315, 'brQtyUsed', GotErr);
  Msg (4316, 'brUsedRec', GotErr);
  Msg (4317, 'brInLocation', GotErr);
  Msg (4318, 'brOutLocation', GotErr);
  Msg (4319, 'PadChar4', GotErr);
  Msg (4320, 'brOutOrderRef', GotErr);
  Msg (4321, 'brInOrderRef', GotErr);
  Msg (4322, 'brInOrderLine', GotErr);
  Msg (4323, 'brOutOrderLine', GotErr);
  Msg (4324, 'brCostPriceCurrency', GotErr);
  Msg (4325, 'brPickingPriority', GotErr);
  Msg (4326, 'PadChar5', GotErr);
  Msg (4327, 'brSalesPrice', GotErr);
  Msg (4328, 'brCompanyRate', GotErr);
  Msg (4329, 'brDailyRate', GotErr);
  Msg (4330, 'brUseORate', GotErr);
  Msg (4331, 'PadChar6', GotErr);
  Msg (4332, 'brTriRates', GotErr);
  Msg (4333, 'brTriEuro', GotErr);
  Msg (4334, 'brTriInvert', GotErr);
  Msg (4335, 'brTriFloat', GotErr);
  Msg (4336, 'brUseByDate', GotErr);
  Msg (4337, 'brSalesPriceCurrency', GotErr);
  Msg (4338, 'brUnitOfMeasurement', GotErr);
  Msg (4339, 'PadChar7', GotErr);
  Msg (4340, 'brAutoPickMode', GotErr);
  Msg (4341, 'brTagNo', GotErr);
  Msg (4342, 'brRecPos', GotErr);
  Msg (4343, 'Spare', GotErr);
  Msg (4344, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchConvRec');
  End; { If }
end;

procedure TForm1.MultiBuy(Sender: TObject);
var
  GotErr : SmallInt;
begin
  GotErr := -1;

  ListBox1.Items.Add('TBatchMultiBuyDiscount');
  ListBox1.Items.Add('----------------');

  Msg (4400, 'mbdOwnerType', GotErr);
  Msg (4401, 'mbdDiscountType', GotErr);


  Msg (4402, 'mbdAcCode', GotErr);
  Msg (4403, 'mbdStockCode', GotErr);
  Msg (4404, 'mbdCurrency', GotErr);
  Msg (4405, 'mbdStartDate', GotErr);
  Msg (4406, 'mbdEndDate', GotErr);
  Msg (4407, 'mbdUseDates', GotErr);
  Msg (4408, 'mbdBuyQty', GotErr);
  Msg (4409, 'mbdRewardValue', GotErr);
  Msg (4410, 'RecordPosition', GotErr);
  Msg (4411, 'Spare', GotErr);
  Msg (4412, 'LastChar', GotErr);

  If (GotErr <> -1) Then Begin
    ListBox1.ItemIndex := GotErr;
    ShowMessage ('Field Position Error found in TBatchConvRec');
  End; { If }
end;


procedure TForm1.ListBox2Click(Sender: TObject);
begin
  If (ListBox2.ItemIndex <> -1) Then Begin
    ListBox1.Clear;

    Case ListBox2.ItemIndex Of
      0  : RecLens(Sender);
      1  : BatchCU(Sender);
      2  : BatchTH(Sender);
      3  : BatchTL(Sender);
      4  : SaleBands(Sender);
      5  : BatchSK(Sender);
      6  : HistoryBal(Sender);
      7  : BatchNom(Sender);
      8  : BatchBOM(Sender);
      9  : BatchSR(Sender);
      10 : BatchJH(Sender);
      11 : BatchSL(Sender);
      12 : BatchMLoc(Sender);
      13 : BatchMatch(Sender);
      14 : BatchNotes(Sender);
      15 : BatchCCDep(Sender);
      16 : StkPrice(Sender);
      17 : BatchVAT(Sender);
      18 : BatchCurr(Sender);
      19 : BatchSyss(Sender);
      20 : BatchAB(Sender);
      21 : BatchBomImp(Sender);
      22 : BatchSer(Sender);
      23 : BatchEmployee(Sender);
      24 : BatchJobAnal(Sender);
      25 : BatchJobRate(Sender);
      26 : BatchJobType(Sender);
      27 : BatchDiscRate(Sender);
      28 : BatchStockAlt(Sender);
      29 : TLArray(Sender);
      30 : BatchConvTCurr(Sender);
      31 : SysECommsRec(Sender);
      32 : DefaultForm(Sender);
      33 : PrintEmail(Sender);
      34 : DefaultVATCode(Sender);
      35 : EntInfo(Sender);
      36 : UserProf(Sender);
      37 : Links(Sender);
      38 : Conv(Sender);
      39 : Bin(Sender);
      40 : MultiBuy(Sender);
    End; { Case }
  End; { If }
end;


end.



