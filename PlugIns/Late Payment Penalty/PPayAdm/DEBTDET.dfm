object frmDebtDetails: TfrmDebtDetails
  Left = 383
  Top = 285
  BorderStyle = bsDialog
  Caption = 'Debt Collection Details'
  ClientHeight = 109
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel
    Left = 8
    Top = 12
    Width = 102
    Height = 14
    Caption = 'Value Range - From :'
  end
  object lTo: TLabel
    Left = 208
    Top = 12
    Width = 18
    Height = 14
    Caption = 'To :'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 115
    Height = 14
    Caption = 'Debt Collection Charge :'
  end
  object edValueFrom: TCurrencyEdit
    Left = 128
    Top = 8
    Width = 65
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
    OnChange = edValueFromChange
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edCharge: TCurrencyEdit
    Left = 128
    Top = 40
    Width = 65
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object btnCancel: TButton
    Left = 216
    Top = 80
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 128
    Top = 80
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object pmMain: TPopupMenu
    Left = 8
    Top = 72
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
