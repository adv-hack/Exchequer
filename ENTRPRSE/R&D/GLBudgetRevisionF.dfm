object frmGLBudgetRevisions: TfrmGLBudgetRevisions
  Left = 358
  Top = 271
  Width = 580
  Height = 503
  HelpContext = 40183
  Caption = 'frmGLBudgetRevisions'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 564
    Height = 464
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 0
    DesignSize = (
      564
      464)
    object Label81: Label8
      Left = 19
      Top = 26
      Width = 26
      Height = 14
      Caption = 'Year:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label1: TLabel
      Left = 144
      Top = 26
      Width = 29
      Height = 14
      Caption = 'View:'
    end
    object cbYear: TComboBox
      Left = 48
      Top = 24
      Width = 89
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnChange = cbYearChange
    end
    object cbView: TComboBox
      Left = 184
      Top = 24
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 1
      Text = 'All'
      OnChange = cbViewChange
      Items.Strings = (
        'All'
        'Changes only'
        'Differences only')
    end
    object mlRevisions: TMultiList
      Left = 16
      Top = 64
      Width = 449
      Height = 385
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <>
      TabStop = True
      PopupMenu = PopupMenu1
      TabOrder = 2
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Arial'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
    end
    object btnExport: TSBSButton
      Left = 473
      Top = 64
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Export'
      TabOrder = 3
      OnClick = btnExportClick
      TextId = 0
    end
    object btnClose: TSBSButton
      Left = 473
      Top = 88
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 4
      TextId = 0
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Left = 336
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 368
    Top = 8
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
    end
  end
end
