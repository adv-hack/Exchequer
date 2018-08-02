object frmCriteria: TfrmCriteria
  Left = 425
  Top = 353
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Create SRI'
  ClientHeight = 86
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel5: TBevel
    Left = 8
    Top = 8
    Width = 329
    Height = 42
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object btnClose: TButton
    Left = 256
    Top = 56
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object cmbCompany: TComboBox
    Left = 80
    Top = 16
    Width = 241
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnCreate: TButton
    Left = 168
    Top = 56
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Generate'
    TabOrder = 1
    OnClick = btnCreateClick
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 56
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 40
    Top = 56
  end
end
