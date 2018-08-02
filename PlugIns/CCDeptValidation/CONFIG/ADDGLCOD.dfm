object FrmAddGLCode: TFrmAddGLCode
  Left = 353
  Top = 309
  BorderStyle = bsDialog
  Caption = 'Add New Code'
  ClientHeight = 116
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 8
    Top = 8
    Width = 257
    Height = 73
    Pen.Color = clGray
  end
  object Label3: TLabel
    Left = 19
    Top = 28
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Caption = 'GL Code :'
    Transparent = True
  end
  object lGLName: TLabel
    Left = 72
    Top = 54
    Width = 185
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object btnOK: TButton
    Left = 96
    Top = 88
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 184
    Top = 88
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnCCWC: TButton
    Left = 8
    Top = 88
    Width = 80
    Height = 21
    Caption = 'Wild Card'
    TabOrder = 3
    TabStop = False
    OnClick = btnCCWCClick
  end
  object edGLCode: TEdit
    Left = 72
    Top = 24
    Width = 81
    Height = 22
    TabOrder = 0
    OnChange = edGLCodeChange
  end
  object btnFindGLCode: TButton
    Left = 152
    Top = 23
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = btnFindGLCodeClick
  end
end
