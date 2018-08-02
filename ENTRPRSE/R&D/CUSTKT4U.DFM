object CuStkT4: TCuStkT4
  Left = 347
  Top = 209
  HelpContext = 500
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TeleSales default settings'
  ClientHeight = 178
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 6
    Top = 4
    Width = 387
    Height = 131
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 39
      Top = 41
      Width = 135
      Height = 14
      Alignment = taRightJustify
      Caption = 'History Analysis based on : '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 56
      Top = 81
      Width = 118
      Height = 14
      Alignment = taRightJustify
      Caption = 'Analysis scale interval : '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object TSHMCBox: TSBSComboBox
      Left = 177
      Top = 38
      Width = 110
      Height = 22
      HelpContext = 634
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      Items.Strings = (
        'Invoices'
        'Orders')
      MaxListWidth = 0
    end
    object TSSCBox: TSBSComboBox
      Left = 177
      Top = 75
      Width = 110
      Height = 22
      HelpContext = 634
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      Items.Strings = (
        'Period'
        '1 Week'
        '2 Weeks'
        '3 Weeks'
        '4 Weeks')
      MaxListWidth = 0
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 117
    Top = 148
    Width = 80
    Height = 21
    HelpContext = 257
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 201
    Top = 148
    Width = 80
    Height = 21
    HelpContext = 258
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
end
