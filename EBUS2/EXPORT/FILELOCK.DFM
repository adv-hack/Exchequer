object frmFileLocking: TfrmFileLocking
  Left = 334
  Top = 253
  BorderStyle = bsDialog
  Caption = 'File Locking'
  ClientHeight = 207
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 8
    Top = 125
    Width = 321
    Height = 44
    Shape = bsFrame
  end
  object lTitle: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 33
    AutoSize = False
    Caption = 
      'Please Select the method of file locking that you wish to use fo' +
      'r the customer file'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label47: TLabel
    Left = 83
    Top = 139
    Width = 51
    Height = 14
    Caption = 'File Exists '
  end
  object Bevel1: TBevel
    Left = 8
    Top = 48
    Width = 321
    Height = 79
    Shape = bsFrame
  end
  object rbFilename: TRadioButton
    Left = 24
    Top = 64
    Width = 113
    Height = 17
    Caption = 'Specific Filename :'
    TabOrder = 0
    OnClick = rbFilenameClick
  end
  object rbExtension: TRadioButton
    Left = 24
    Top = 96
    Width = 97
    Height = 17
    Caption = 'File Extension :'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rbFilenameClick
  end
  object edFilename: TEdit
    Left = 136
    Top = 61
    Width = 113
    Height = 22
    Enabled = False
    MaxLength = 12
    TabOrder = 2
  end
  object edExtension: TEdit
    Left = 136
    Top = 93
    Width = 41
    Height = 22
    MaxLength = 3
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 264
    Top = 176
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 192
    Top = 176
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 5
  end
  object cmbStockLockType: TComboBox
    Left = 136
    Top = 135
    Width = 185
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 6
    Items.Strings = (
      'when creating the export file'
      'when the export file is created')
  end
end
