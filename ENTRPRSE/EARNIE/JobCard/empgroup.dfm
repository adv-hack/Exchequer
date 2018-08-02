object frmEmpGroup: TfrmEmpGroup
  Left = 337
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Employee Account Groups'
  ClientHeight = 188
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 177
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 51
      Top = 20
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = 'Employee Code'
    end
    object Label2: TLabel
      Left = 48
      Top = 60
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = 'Employee Name'
    end
    object Label3: TLabel
      Left = 19
      Top = 100
      Width = 106
      Height = 13
      Caption = 'Payroll Account Group'
    end
    object cbAcGroup: TComboBox
      Left = 136
      Top = 96
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object SBSButton3: TSBSButton
      Left = 136
      Top = 128
      Width = 105
      Height = 21
      Caption = 'Account Groups'
      TabOrder = 3
      OnClick = SBSButton3Click
      TextId = 0
    end
    object edtCode: TEdit
      Left = 136
      Top = 16
      Width = 161
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnExit = edtCodeExit
    end
    object edtEmpName: Text8Pt
      Left = 136
      Top = 56
      Width = 161
      Height = 21
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
      GDPREnabled = True
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
  object btnCancel: TSBSButton
    Left = 336
    Top = 40
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
