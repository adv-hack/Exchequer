object frmSelectDir: TfrmSelectDir
  Left = 215
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Select Directories'
  ClientHeight = 208
  ClientWidth = 421
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
    Width = 321
    Height = 193
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 94
      Height = 13
      Caption = 'Exchequer directory'
    end
    object Label2: TLabel
      Left = 16
      Top = 72
      Width = 74
      Height = 13
      Caption = 'Payroll directory'
    end
    object Label3: TLabel
      Left = 16
      Top = 128
      Width = 66
      Height = 13
      Caption = 'Logs directory'
    end
    object SpeedButton1: TSpeedButton
      Left = 264
      Top = 32
      Width = 23
      Height = 22
      Caption = '...'
      Visible = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Tag = 1
      Left = 264
      Top = 88
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object SpeedButton3: TSpeedButton
      Tag = 2
      Left = 264
      Top = 144
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object edtEntDir: TEdit
      Left = 16
      Top = 32
      Width = 249
      Height = 21
      Color = clMenu
      Enabled = False
      TabOrder = 0
    end
    object edtPayDir: TEdit
      Left = 16
      Top = 88
      Width = 249
      Height = 21
      TabOrder = 1
    end
    object edtLogDir: TEdit
      Left = 16
      Top = 144
      Width = 249
      Height = 21
      TabOrder = 2
    end
  end
  object SBSButton1: TSBSButton
    Left = 336
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 336
    Top = 36
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
