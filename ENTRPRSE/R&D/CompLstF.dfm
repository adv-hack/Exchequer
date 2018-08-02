object frmCompanyList: TfrmCompanyList
  Left = 419
  Top = 243
  Width = 478
  Height = 230
  Caption = 'Change Company'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object mulCompanyList: TDBMultiList
    Left = 4
    Top = 4
    Width = 349
    Height = 185
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Code'
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 60
      end
      item
        Caption = 'Name'
        Field = '1'
        Width = 245
      end>
    TabStop = True
    OnCellPaint = mulCompanyListCellPaint
    OnRowDblClick = mulCompanyListRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
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
    Dataset = bdsCompanyList
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object panButtons: TPanel
    Left = 356
    Top = 4
    Width = 108
    Height = 185
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      104
      181)
    object CloseBtn: TButton
      Tag = 1
      Left = 4
      Top = 4
      Width = 80
      Height = 21
      Hint = 'Closes the Change Company window'
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = CloseBtnClick
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 32
      Width = 104
      Height = 153
      Anchors = [akLeft, akTop, akBottom]
      BorderStyle = bsNone
      TabOrder = 1
      object btnOpenEnterprise: TButton
        Tag = 2
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        Hint = 'Opens the company In Exchequer'
        Caption = '&Open'
        Default = True
        TabOrder = 0
        OnClick = btnOpenEnterpriseClick
      end
      object btnOpenEBusiness: TButton
        Tag = 2
        Left = 4
        Top = 23
        Width = 80
        Height = 21
        Hint = 'Opens the Exchequer e-Business module'
        Caption = 'e&Business'
        TabOrder = 1
        OnClick = btnOpenEBusinessClick
      end
      object btnOpenSentimail: TButton
        Tag = 2
        Left = 4
        Top = 47
        Width = 80
        Height = 21
        Hint = 'Opens the Exchequer Sentimail module'
        Caption = '&Sentimail'
        TabOrder = 2
        OnClick = btnOpenSentimailClick
      end
    end
  end
  object bdsCompanyList: TComTKDataset
    OnGetFieldValue = bdsCompanyListGetFieldValue
    Left = 103
    Top = 134
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 171
    Top = 31
    object popOpenEnterprise: TMenuItem
      Caption = '&Open Company'
      OnClick = btnOpenEnterpriseClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popOpenEBusiness: TMenuItem
      Caption = 'Open e&Business Module'
      OnClick = btnOpenEBusinessClick
    end
    object popOpenSentimail: TMenuItem
      Caption = 'Open &Sentimail Module'
      OnClick = btnOpenSentimailClick
    end
    object PopupOpt_SepBar2: TMenuItem
      Caption = '-'
    end
    object popFormProperties: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popSavePosition: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
