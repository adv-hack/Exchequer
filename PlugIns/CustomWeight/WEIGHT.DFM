object FrmWeight: TFrmWeight
  Left = 399
  Top = 320
  Width = 224
  Height = 179
  Caption = 'Enter the Total Weight'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 201
    Height = 97
    Shape = bsFrame
  end
  object Label2: TLabel
    Left = 24
    Top = 76
    Width = 65
    Height = 14
    Caption = 'Total Weight :'
  end
  object Label3: TLabel
    Left = 184
    Top = 76
    Width = 13
    Height = 14
    Caption = 'Kg'
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 46
    Height = 14
    Caption = 'Quantity :'
  end
  object lQty: TLabel
    Left = 96
    Top = 24
    Width = 46
    Height = 14
    Caption = 'Quantity :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 24
    Top = 48
    Width = 69
    Height = 14
    Caption = 'Current Price :'
  end
  object lPrice: TLabel
    Left = 96
    Top = 48
    Width = 46
    Height = 14
    Caption = 'Quantity :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object edWeight: TCurrencyEdit
    Left = 96
    Top = 72
    Width = 80
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object btnOK: TButton
    Left = 72
    Top = 120
    Width = 65
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 144
    Top = 120
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
