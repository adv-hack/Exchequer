object frmHoldAdmin: TfrmHoldAdmin
  Left = 727
  Top = 186
  BorderStyle = bsDialog
  Caption = 'Custom Hold Plug-in  Administration v5.60.004'
  ClientHeight = 167
  ClientWidth = 414
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 305
    Height = 153
    Caption = 'Validate customer hold status for these transactions...'
    TabOrder = 0
    object edtSQU: TCheckBox
      Tag = 1
      Left = 16
      Top = 24
      Width = 121
      Height = 17
      Caption = 'Sales Quotation'
      TabOrder = 0
    end
    object chkSOR: TCheckBox
      Tag = 2
      Left = 16
      Top = 56
      Width = 121
      Height = 17
      Caption = 'Sales Order'
      TabOrder = 1
    end
    object CheckBox5: TCheckBox
      Tag = 8
      Left = 16
      Top = 88
      Width = 121
      Height = 17
      Caption = 'Sales Invoice'
      TabOrder = 2
    end
    object CheckBox6: TCheckBox
      Tag = 16
      Left = 16
      Top = 120
      Width = 121
      Height = 17
      Caption = 'Sales Credit Note'
      TabOrder = 3
    end
    object CheckBox7: TCheckBox
      Tag = 32
      Left = 144
      Top = 24
      Width = 121
      Height = 17
      Caption = 'Sales Refund'
      TabOrder = 4
    end
    object CheckBox4: TCheckBox
      Tag = 64
      Left = 144
      Top = 56
      Width = 129
      Height = 17
      Caption = 'Sales Journal Invoice'
      TabOrder = 5
    end
    object CheckBox8: TCheckBox
      Tag = 128
      Left = 144
      Top = 88
      Width = 153
      Height = 17
      Caption = 'Sales Receipt and Invoice'
      TabOrder = 6
    end
    object CheckBox2: TCheckBox
      Tag = 256
      Left = 144
      Top = 120
      Width = 121
      Height = 17
      Caption = 'Sales Journal Credit'
      TabOrder = 7
    end
  end
  object SBSButton1: TSBSButton
    Left = 320
    Top = 48
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 320
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    TextId = 0
  end
  object SBSButton3: TSBSButton
    Left = 320
    Top = 80
    Width = 80
    Height = 21
    Caption = '&Password'
    TabOrder = 3
    OnClick = SBSButton3Click
    TextId = 0
  end
end
