object Form1: TForm1
  Left = 218
  Top = 170
  Width = 417
  Height = 395
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cmbComNo: TComboBox
    Left = 8
    Top = 8
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 0
    Text = 'COM 3'
    Items.Strings = (
      'COM 1'
      'COM 2'
      'COM 3'
      'COM 4'
      'COM 5'
      'COM 6'
      'COM 7'
      'COM 8')
  end
  object Button1: TButton
    Left = 136
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Send Text'
    TabOrder = 1
    OnClick = Button1Click
  end
  object edSend: TEdit
    Left = 8
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edSend'
  end
  object edChar: TSpinEdit
    Left = 8
    Top = 160
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object btnSendChar: TButton
    Left = 136
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Send Char'
    TabOrder = 4
    OnClick = btnSendCharClick
  end
  object Button2: TButton
    Left = 136
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Neil'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 240
    Top = 232
    Width = 145
    Height = 89
    Caption = 'Close'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 224
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Home'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 336
    Width = 89
    Height = 25
    Caption = 'Printer + Screen'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 304
    Width = 89
    Height = 25
    Caption = 'Screen'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 8
    Top = 272
    Width = 89
    Height = 25
    Caption = 'Printer'
    TabOrder = 10
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 136
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 11
    OnClick = Button8Click
  end
  object ApdComPort1: TApdComPort
    TraceName = 'APRO.TRC'
    LogName = 'APRO.LOG'
    Left = 224
    Top = 160
  end
end
