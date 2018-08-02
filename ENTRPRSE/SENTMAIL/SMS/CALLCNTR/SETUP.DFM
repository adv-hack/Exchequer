object frmSetup: TfrmSetup
  Left = 404
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'SMS Call Centre Configuration'
  ClientHeight = 312
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 329
    Height = 145
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 164
    Width = 71
    Height = 14
    Caption = 'Use Com Port :'
  end
  object Label2: TLabel
    Left = 16
    Top = 76
    Width = 49
    Height = 14
    Caption = 'Data Bits :'
  end
  object Label3: TLabel
    Left = 16
    Top = 100
    Width = 33
    Height = 14
    Caption = 'Parity :'
  end
  object Label4: TLabel
    Left = 16
    Top = 124
    Width = 49
    Height = 14
    Caption = 'Stop Bits :'
  end
  object Label5: TLabel
    Left = 16
    Top = 224
    Width = 89
    Height = 14
    Caption = 'Com Port Log File :'
  end
  object Label6: TLabel
    Left = 16
    Top = 248
    Width = 64
    Height = 14
    Caption = 'Tap Log File :'
  end
  object Label7: TLabel
    Left = 16
    Top = 192
    Width = 109
    Height = 14
    Caption = 'Pause Between Dials :'
  end
  object Label8: TLabel
    Left = 200
    Top = 192
    Width = 25
    Height = 14
    Caption = 'Secs'
  end
  object Label9: TLabel
    Left = 16
    Top = 20
    Width = 58
    Height = 14
    Caption = 'Call Centre :'
  end
  object Label10: TLabel
    Left = 16
    Top = 48
    Width = 98
    Height = 14
    Caption = 'Call Centre Number :'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 151
    Width = 329
    Height = 122
    Shape = bsFrame
  end
  object edComPortLogFile: TEdit
    Left = 128
    Top = 220
    Width = 201
    Height = 22
    TabOrder = 8
  end
  object cmbComNo: TComboBox
    Left = 128
    Top = 160
    Width = 65
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 5
    Items.Strings = (
      'COM1'
      'COM2'
      'COM3'
      'COM4')
  end
  object btnOK: TButton
    Left = 200
    Top = 280
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 10
    OnClick = btnOKClick
  end
  object cmbDataBits: TComboBox
    Left = 128
    Top = 72
    Width = 65
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 2
    Items.Strings = (
      '4'
      '5'
      '6'
      '7'
      '8')
  end
  object cmbParity: TComboBox
    Left = 128
    Top = 96
    Width = 65
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    Items.Strings = (
      'Even'
      'Odd'
      'None'
      'Mark'
      'Space')
  end
  object cmbStopBits: TComboBox
    Left = 128
    Top = 120
    Width = 65
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 4
    Text = '1'
    Items.Strings = (
      '1'
      '1.5'
      '2')
  end
  object btnCancel: TButton
    Left = 272
    Top = 280
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object udPause: TUpDown
    Left = 177
    Top = 188
    Width = 15
    Height = 22
    Associate = edSecsToPause
    Min = 0
    Position = 4
    TabOrder = 7
    Wrap = False
  end
  object edSecsToPause: TEdit
    Left = 128
    Top = 188
    Width = 49
    Height = 22
    TabOrder = 6
    Text = '4'
  end
  object cmbCallCentre: TComboBox
    Left = 128
    Top = 16
    Width = 201
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnClick = cmbCallCentreClick
  end
  object edTapLogFile: TEdit
    Left = 128
    Top = 244
    Width = 201
    Height = 22
    TabOrder = 9
  end
  object edCallCentreNo: TEdit
    Left = 127
    Top = 44
    Width = 201
    Height = 22
    TabOrder = 1
  end
  object Timer1: TTimer
    Left = 8
    Top = 280
  end
end
