object UnallocateAllForm: TUnallocateAllForm
  Left = 344
  Top = 419
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Unallocate All Transactions'
  ClientHeight = 148
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel4: TSBSBackGroup
    Left = 6
    Top = 2
    Width = 311
    Height = 111
    TextId = 0
  end
  object lblAccountRange: Label8
    Left = 16
    Top = 19
    Width = 119
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. range from '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblAccountTo: Label8
    Left = 218
    Top = 19
    Width = 9
    Height = 14
    Alignment = taRightJustify
    Caption = 'to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 289
    Height = 57
    AutoSize = False
    Caption = 
      'This will unallocate all transactions for the selected accounts,' +
      ' with the exception of previously revalued transactions and tran' +
      'sactions created through the Order Payments system.'
    WordWrap = True
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 79
    Top = 120
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OkCP1BtnClick
  end
  object ClsCP1Btn: TButton
    Left = 165
    Top = 120
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = ClsCP1BtnClick
  end
  object edtFromAccountCode: Text8Pt
    Tag = 1
    Left = 139
    Top = 17
    Width = 75
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnExit = edtFromAccountCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object edtToAccountCode: Text8Pt
    Tag = 1
    Left = 232
    Top = 17
    Width = 75
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnExit = edtFromAccountCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 288
    Top = 120
  end
end
