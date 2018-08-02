object frmEmailEdit: TfrmEmailEdit
  Left = 361
  Top = 301
  HelpContext = 69
  BorderStyle = bsDialog
  Caption = 'Email Recipient Details'
  ClientHeight = 168
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 121
    HelpContext = 69
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label16: TLabel
      Left = 16
      Top = 64
      Width = 72
      Height = 14
      Caption = 'Email Address:'
    end
    object Label17: TLabel
      Left = 88
      Top = 16
      Width = 78
      Height = 14
      Caption = 'Name (optional):'
    end
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 27
      Height = 14
      Caption = 'Type:'
    end
    object edtEmailAddress: TEdit
      Left = 16
      Top = 80
      Width = 233
      Height = 22
      HelpContext = 69
      TabOrder = 2
      OnChange = edtEmailAddressChange
      OnEnter = edtEmailAddressEnter
    end
    object edtEmailName: TEdit
      Left = 88
      Top = 32
      Width = 161
      Height = 22
      HelpContext = 69
      TabOrder = 1
      OnEnter = edtEmailNameEnter
    end
    object cbEmType: TComboBox
      Left = 16
      Top = 32
      Width = 57
      Height = 22
      HelpContext = 69
      ItemHeight = 14
      TabOrder = 0
      Items.Strings = (
        'To'
        'CC'
        'BCC')
    end
  end
  object btnOk: TButton
    Left = 144
    Top = 136
    Width = 65
    Height = 25
    HelpContext = 69
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 216
    Top = 136
    Width = 65
    Height = 25
    HelpContext = 69
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnDBF: TButton
    Left = 8
    Top = 135
    Width = 65
    Height = 25
    HelpContext = 69
    Caption = '&DB Field'
    TabOrder = 3
    Visible = False
    OnClick = btnDBFClick
  end
end
