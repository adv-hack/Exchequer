object frmTestItem: TfrmTestItem
  Left = 310
  Top = 227
  BorderStyle = bsDialog
  Caption = 'Test Item'
  ClientHeight = 269
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 249
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 52
      Height = 13
      Caption = 'Test Name'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 52
      Height = 13
      Caption = 'Application'
    end
    object SpeedButton1: TSpeedButton
      Left = 224
      Top = 72
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label3: TLabel
      Left = 16
      Top = 104
      Width = 53
      Height = 13
      Caption = 'Parameters'
    end
    object edtTestName: TEdit
      Left = 16
      Top = 24
      Width = 209
      Height = 21
      TabOrder = 0
    end
    object edtApp: TEdit
      Left = 16
      Top = 72
      Width = 209
      Height = 21
      TabOrder = 1
    end
    object chkRun: TCheckBox
      Left = 16
      Top = 220
      Width = 97
      Height = 17
      Caption = 'Run'
      TabOrder = 6
    end
    object chkCompareDB: TCheckBox
      Left = 16
      Top = 188
      Width = 97
      Height = 17
      Caption = 'Compare DB'
      TabOrder = 5
    end
    object chkCompareRes: TCheckBox
      Left = 16
      Top = 156
      Width = 97
      Height = 17
      Caption = 'Compare Result'
      TabOrder = 3
      OnClick = chkCompareResClick
    end
    object edtResult: TEdit
      Left = 120
      Top = 154
      Width = 105
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '0'
    end
    object edtExtra: TEdit
      Left = 16
      Top = 120
      Width = 209
      Height = 21
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 280
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 280
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Applications (*.exe)|*.exe'
    Left = 328
    Top = 112
  end
end
