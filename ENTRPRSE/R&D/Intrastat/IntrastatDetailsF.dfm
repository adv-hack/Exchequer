object IntrastatDetailsFrm: TIntrastatDetailsFrm
  Left = 344
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Intrastat Settings'
  ClientHeight = 155
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblDeliveryTerms: TLabel
    Left = 24
    Top = 11
    Width = 71
    Height = 14
    Alignment = taRightJustify
    Caption = 'Delivery Terms'
  end
  object lblTransactionType: TLabel
    Left = 12
    Top = 39
    Width = 83
    Height = 14
    Alignment = taRightJustify
    Caption = 'Transaction Type'
  end
  object lblNoTc: TLabel
    Left = 69
    Top = 67
    Width = 26
    Height = 14
    Alignment = taRightJustify
    Caption = 'NoTC'
  end
  object lblModeOfTransport: TLabel
    Left = 6
    Top = 95
    Width = 89
    Height = 14
    Alignment = taRightJustify
    Caption = 'Mode of Transport'
  end
  object cbDeliveryTerms: TSBSComboBox
    Left = 102
    Top = 7
    Width = 183
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    MaxListWidth = 350
  end
  object cbTransactionType: TSBSComboBox
    Left = 102
    Top = 35
    Width = 183
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    Items.Strings = (
      'Normal Transaction'
      'Triangulation Transaction'
      'Process Transaction')
    MaxListWidth = 350
  end
  object cbNoTc: TSBSComboBox
    Left = 102
    Top = 63
    Width = 183
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 350
  end
  object cbModeOfTransport: TSBSComboBox
    Left = 102
    Top = 91
    Width = 183
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 3
    MaxListWidth = 350
  end
  object btnOK: TButton
    Left = 60
    Top = 124
    Width = 80
    Height = 21
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 152
    Top = 124
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
end
