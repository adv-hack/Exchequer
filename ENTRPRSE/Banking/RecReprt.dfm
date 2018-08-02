object frmReconcileReport: TfrmReconcileReport
  Left = 256
  Top = 114
  HelpContext = 2025
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Statement Report'
  ClientHeight = 180
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TSBSButton
    Left = 102
    Top = 152
    Width = 80
    Height = 21
    HelpContext = 2030
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 190
    Top = 152
    Width = 80
    Height = 21
    HelpContext = 2031
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
    TextId = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 353
    Height = 137
    HelpContext = 2025
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 21
      Top = 20
      Width = 67
      Height = 14
      Alignment = taRightJustify
      Caption = 'Bank Account'
    end
    object Label2: TLabel
      Left = 22
      Top = 52
      Width = 66
      Height = 14
      Alignment = taRightJustify
      Caption = 'Reconciliation'
    end
    object Label3: TLabel
      Left = 52
      Top = 102
      Width = 36
      Height = 14
      Alignment = taRightJustify
      Caption = 'Sort By'
    end
    object lblReconBy: TLabel
      Left = 96
      Top = 72
      Width = 241
      Height = 25
      AutoSize = False
      WordWrap = True
    end
    object chkGroup: TBorCheck
      Left = 176
      Top = 98
      Width = 82
      Height = 20
      HelpContext = 2029
      Caption = 'Group Items'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 4
      TabStop = True
      TextId = 0
    end
    object edtGLCode: Text8Pt
      Left = 96
      Top = 16
      Width = 73
      Height = 22
      HelpContext = 2026
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = edtGLCodeExit
      TextId = 0
      ViaSBtn = False
    end
    object edtGLDesc: Text8Pt
      Left = 176
      Top = 16
      Width = 161
      Height = 22
      HelpContext = 2026
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
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
    end
    object edtReconcile: Text8Pt
      Left = 96
      Top = 48
      Width = 161
      Height = 22
      HelpContext = 2027
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = edtReconcileExit
      TextId = 0
      ViaSBtn = False
    end
    object cbSortBy: TSBSComboBox
      Left = 96
      Top = 98
      Width = 73
      Height = 22
      HelpContext = 2028
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 3
      Text = 'Date'
      Items.Strings = (
        'Date'
        'Reference'
        'LineNo')
      MaxListWidth = 0
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Top = 176
  end
end
