object frmCopyGLCode: TfrmCopyGLCode
  Left = 363
  Top = 256
  ActiveControl = btnClose
  BorderStyle = bsDialog
  Caption = 'Copy GL Code Configuration'
  ClientHeight = 148
  ClientWidth = 321
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
  object lbSourceGL: TLabel
    Left = 30
    Top = 63
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Source GL Code'
  end
  object lbDestinationGL: TLabel
    Left = 30
    Top = 93
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Destination GL Code'
  end
  object lbPrompt: TLabel
    Left = 10
    Top = 10
    Width = 267
    Height = 42
    Caption = 
      'This facility allows you to copy the Cost Centre / Department co' +
      'nfiguration from one GL Code to another.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnClose: TButton
    Left = 232
    Top = 120
    Width = 80
    Height = 21
    Caption = 'C&lose'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnCopy: TButton
    Left = 144
    Top = 120
    Width = 80
    Height = 21
    Caption = '&Copy'
    TabOrder = 2
    OnClick = btnCopyClick
  end
  object cbSourceGL: TComboBox
    Left = 140
    Top = 58
    Width = 173
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cbGLChange
  end
  object cbDestinationGL: TComboBox
    Left = 140
    Top = 88
    Width = 173
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 1
    OnChange = cbGLChange
  end
end
