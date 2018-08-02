object frmCopy: TfrmCopy
  Left = 359
  Top = 234
  BorderStyle = bsDialog
  Caption = 'Copy Company Configuration'
  ClientHeight = 155
  ClientWidth = 328
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 313
    Height = 41
    AutoSize = False
    Caption = 
      'This facility allows you to copy the Cost Centre / Department co' +
      'nfiguration from one company to another.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 26
    Top = 60
    Width = 89
    Height = 14
    Alignment = taRightJustify
    Caption = 'Source Company :'
  end
  object Label3: TLabel
    Left = 8
    Top = 92
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Destination Company :'
  end
  object cmbSource: TComboBox
    Left = 120
    Top = 56
    Width = 201
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbSourceChange
  end
  object cmbDestination: TComboBox
    Left = 120
    Top = 88
    Width = 201
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 1
    OnChange = cmbSourceChange
  end
  object btnClose: TButton
    Left = 240
    Top = 128
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnCopy: TButton
    Left = 152
    Top = 128
    Width = 80
    Height = 21
    Caption = '&Copy'
    Enabled = False
    TabOrder = 2
    OnClick = btnCopyClick
  end
end
