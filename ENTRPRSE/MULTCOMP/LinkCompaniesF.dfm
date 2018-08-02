object frmLinkCompanies: TfrmLinkCompanies
  Left = 352
  Top = 87
  Width = 739
  Height = 351
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Link Companies to Group'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 4
    Top = 1
    Width = 716
    Height = 283
    TextId = 0
  end
  object lblNotInGroup: Label8
    Left = 13
    Top = 11
    Width = 276
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Companies not in Company Group'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object lblInGroup: Label8
    Left = 411
    Top = 11
    Width = 277
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Companies in Company Group'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object btnDeselectOne: TSBSButton
    Left = 322
    Top = 146
    Width = 80
    Height = 21
    Caption = '<'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnDeselectOneClick
    TextId = 0
  end
  object btnDeselectMultiple: TSBSButton
    Left = 322
    Top = 170
    Width = 80
    Height = 21
    Caption = '<<'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnDeselectMultipleClick
    TextId = 0
  end
  object btnDeselectAll: TSBSButton
    Left = 322
    Top = 194
    Width = 80
    Height = 21
    Caption = '<< All'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnDeselectAllClick
    TextId = 0
  end
  object btnSelectOne: TSBSButton
    Left = 322
    Top = 70
    Width = 80
    Height = 21
    Caption = '>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSelectOneClick
    TextId = 0
  end
  object btnSelectMultiple: TSBSButton
    Left = 322
    Top = 94
    Width = 80
    Height = 21
    Caption = '>>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnSelectMultipleClick
    TextId = 0
  end
  object btnSelectAll: TSBSButton
    Left = 322
    Top = 118
    Width = 80
    Height = 21
    Caption = 'All >>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnSelectAllClick
    TextId = 0
  end
  object mulInGroup: TMultiList
    Left = 411
    Top = 27
    Width = 301
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Options.MultiSelection = True
    Options.MultiSelectIntegrity = True
    Columns = <
      item
        Caption = 'Code'
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 70
      end
      item
        Caption = 'Name'
        Field = '1'
        Searchable = True
        Sortable = True
        Width = 185
      end>
    TabStop = True
    OnRowDblClick = mulInGroupRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 8
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
  object btnOK: TSBSButton
    Left = 280
    Top = 289
    Width = 80
    Height = 21
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 366
    Top = 289
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = btnCancelClick
    TextId = 0
  end
  object btnFindCompany: TSBSButton
    Left = 322
    Top = 222
    Width = 80
    Height = 21
    Caption = '&Find'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnFindCompanyClick
    TextId = 0
  end
  object mulNotInGroup: TMultiList
    Left = 12
    Top = 27
    Width = 301
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Options.MultiSelection = True
    Options.MultiSelectIntegrity = True
    Columns = <
      item
        Caption = 'Code'
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 70
      end
      item
        Caption = 'Name'
        Field = '1'
        Searchable = True
        Sortable = True
        Width = 185
        IndexNo = 1
      end>
    TabStop = True
    OnRowDblClick = mulNotInGroupRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 0
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
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 222
    Top = 227
    object popFormProperties: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object PopupOpt_SepBar3: TMenuItem
      Caption = '-'
    end
    object popSavePosition: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
