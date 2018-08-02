object Form1: TForm1
  Left = 139
  Top = 40
  Width = 711
  Height = 625
  Caption = 'Exchequer Toolkit DLL - Word Alignment Testing Utility'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 118
    Height = 586
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object ListBox2: TListBox
      Left = 0
      Top = 0
      Width = 118
      Height = 586
      Align = alClient
      ItemHeight = 13
      Items.Strings = (
        'Record Lengths'
        'TBatchCURec'
        'TBatchTHRec'
        'TBatchTLRec'
        'TSaleBandsRec'
        'TBatchSKRec'
        'THistoryBalRec'
        'TBatchNomRec'
        'TBatchBOMRec'
        'TBatchSRRec'
        'TBatchJHRec'
        'TBatchSLRec'
        'TBatchMLocRec'
        'TBatchMatchRec'
        'TBatchNotesRec'
        'TBatchCCDepRec'
        'TBatchStkPriceRec'
        'TBatchVATRec'
        'TBatchCurrRec'
        'TBatchSysRec'
        'TBatchAutoBankRec'
        'TBatchBOMImportRec'
        'TBatchSerialRec'
        'TBatchEmplRec'
        'TBatchJobAnalRec'
        'TBatchJobRateRec'
        'TBatchJobTypeRec'
        'TBatchDiscRec'
        'TBatchSKAltRec'
        'TLArrayInfoType'
        'TBatchConvTCurr'
        'TSysECommsRec'
        'TDefaultFormRecType'
        'TEmailPrintInfoType'
        'TVATCodeDefaultType'
        'TEnterpriseInfoType'
        'TUserProfileType'
        'TBatchLinkRec'
        'TBatchConvRec'
        'TBatchBinRec'
        'TMultiBuyDiscount')
      TabOrder = 0
      OnClick = ListBox2Click
    end
  end
  object ListBox1: TListBox
    Left = 118
    Top = 0
    Width = 577
    Height = 586
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    TabWidth = 140
  end
end
