object frmTakePPD: TfrmTakePPD
  Left = 654
  Top = 356
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmTakePPD'
  ClientHeight = 240
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object lblTransDate: Label8
    Left = 23
    Top = 74
    Width = 111
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'xJC Transaction Date'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label5: TLabel
    Left = 82
    Top = 99
    Width = 52
    Height = 14
    Alignment = taRightJustify
    Caption = 'Discount%'
  end
  object Label2: TLabel
    Left = 116
    Top = 10
    Width = 18
    Height = 14
    Alignment = taRightJustify
    Caption = 'A/C'
  end
  object lblAcCode: Label8
    Left = 141
    Top = 10
    Width = 86
    Height = 14
    AutoSize = False
    Caption = 'ABAP01'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label3: TLabel
    Left = 68
    Top = 46
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = 'Default PPD%'
  end
  object lblDefaultPPDPercentage: TLabel
    Left = 141
    Top = 46
    Width = 31
    Height = 14
    Caption = '1.25%'
  end
  object Label6: TLabel
    Left = 242
    Top = 46
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'Default Days'
  end
  object lblDefaultPPDDays: TLabel
    Left = 311
    Top = 46
    Width = 12
    Height = 14
    Caption = '30'
  end
  object Bevel3: TBevel
    Left = 7
    Top = 65
    Width = 404
    Height = 3
    Shape = bsTopLine
  end
  object Label8: TLabel
    Left = 96
    Top = 131
    Width = 38
    Height = 14
    Alignment = taRightJustify
    Caption = 'Our Ref'
  end
  object Label9: TLabel
    Left = 80
    Top = 149
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trans Date'
  end
  object lblDefaultExpiry: TLabel
    Left = 242
    Top = 149
    Width = 153
    Height = 14
    Alignment = taRightJustify
    Caption = '(Default PPD Expiry 21/11/2015)'
  end
  object lblInvoiceOurRef: Label8
    Left = 141
    Top = 131
    Width = 76
    Height = 14
    AutoSize = False
    Caption = 'SIN000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblInvoiceTransDate: TLabel
    Left = 141
    Top = 149
    Width = 54
    Height = 14
    Caption = '21/10/2015'
  end
  object Bevel1: TBevel
    Left = 7
    Top = 123
    Width = 404
    Height = 3
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 85
    Top = 167
    Width = 49
    Height = 14
    Alignment = taRightJustify
    Caption = 'PPD Value'
  end
  object lblPPDValue: Label8
    Left = 141
    Top = 167
    Width = 76
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = '999,999,99'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label12: TLabel
    Left = 48
    Top = 185
    Width = 86
    Height = 14
    Alignment = taRightJustify
    Caption = 'Invoice Remaining'
  end
  object lblInvoiceRemaining: Label8
    Left = 141
    Top = 185
    Width = 76
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = '999,999,99'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label13: TLabel
    Left = 89
    Top = 28
    Width = 45
    Height = 14
    Alignment = taRightJustify
    Caption = 'Company'
  end
  object lblAcCompany: Label8
    Left = 141
    Top = 28
    Width = 266
    Height = 14
    AutoSize = False
    Caption = 'ABC Systems Ltd (Scunthorpe)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object btnCreateSJC: TButton
    Left = 122
    Top = 213
    Width = 80
    Height = 21
    Caption = 'Create SJC'
    TabOrder = 2
    OnClick = btnCreateSJCClick
  end
  object btnCancel: TButton
    Left = 215
    Top = 213
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object edxJCTransDate: TEditDate
    Tag = 1
    Left = 141
    Top = 71
    Width = 78
    Height = 22
    HelpContext = 143
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 0
    Placement = cpAbove
  end
  object ccyDiscountPercentage: TCurrencyEdit
    Tag = 1
    Left = 141
    Top = 96
    Width = 78
    Height = 22
    HelpContext = 288
    Alignment = taLeftJustify
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      ' 0.60')
    MaxLength = 6
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    OnExit = ccyDiscountPercentageExit
    OnKeyPress = ccyDiscountPercentageKeyPress
    AutoSize = False
    BlockNegative = True
    BlankOnZero = False
    DisplayFormat = ' 0.00;-0.00'
    ShowCurrency = False
    TextId = 0
    Value = 0.6
  end
end
