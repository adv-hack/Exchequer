object frmGLDetail: TfrmGLDetail
  Left = 263
  Top = 217
  BorderStyle = bsDialog
  Caption = 'frmGLDetail'
  ClientHeight = 149
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 6
    Top = 6
    Width = 325
    Height = 136
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 40
      Width = 42
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'GL Code'
    end
    object Label2: TLabel
      Left = 12
      Top = 63
      Width = 42
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Alt Code'
    end
    object Label3: TLabel
      Left = 12
      Top = 86
      Width = 42
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Name'
    end
    object Label4: TLabel
      Left = 150
      Top = 40
      Width = 31
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type'
    end
    object Label5: TLabel
      Left = 12
      Top = 17
      Width = 42
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Parent'
    end
    object edtGLCode: TEdit
      Left = 58
      Top = 37
      Width = 86
      Height = 21
      MaxLength = 10
      TabOrder = 0
    end
    object edtAltCode: TEdit
      Left = 58
      Top = 60
      Width = 259
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 2
    end
    object edtGLName: TEdit
      Left = 58
      Top = 83
      Width = 259
      Height = 21
      MaxLength = 30
      TabOrder = 3
    end
    object lstGLType: TComboBox
      Left = 186
      Top = 37
      Width = 131
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Profit & Loss (A)'
        'Balance Sheet (B)'
        'Control (C)'
        'Carry Forward (F)'
        'Heading (H)')
    end
    object edtParent: TEdit
      Left = 58
      Top = 14
      Width = 259
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
  end
  object btnSave: TButton
    Left = 337
    Top = 21
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 337
    Top = 47
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
