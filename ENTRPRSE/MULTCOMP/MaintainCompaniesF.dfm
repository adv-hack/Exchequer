object frmMaintainCompanies: TfrmMaintainCompanies
  Left = 352
  Top = 213
  Width = 490
  Height = 304
  Caption = 'Maintain Companies'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object mulCompanyList: TDBMultiList
    Left = 4
    Top = 5
    Width = 351
    Height = 256
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
      end
      item
        Caption = 'Path'
        Field = '2'
        Width = 250
      end
      item
        Caption = 'ESN'
        Field = '3'
        Width = 230
      end>
    TabStop = True
    OnCellPaint = mulCompanyListCellPaint
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
    Dataset = bdsCompanyList
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object panButtons: TPanel
    Left = 361
    Top = 4
    Width = 108
    Height = 258
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      108
      258)
    object CloseBtn: TButton
      Tag = 1
      Left = 4
      Top = 4
      Width = 80
      Height = 21
      Hint = 'Closes the Multi-Company Manager'
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = CloseMCM
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 32
      Width = 104
      Height = 229
      Anchors = [akLeft, akTop, akBottom]
      BorderStyle = bsNone
      TabOrder = 1
      object btnAddCompany: TButton
        Tag = 2
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        Hint = 'Attaches an existing company to this Multi-Company Manager'
        Caption = '&Attach'
        TabOrder = 0
        OnClick = AddCompany
      end
      object btnEditCompany: TButton
        Tag = 2
        Left = 4
        Top = 25
        Width = 80
        Height = 21
        Hint = 'Edits the company details'
        HelpContext = 2
        Caption = '&Edit'
        TabOrder = 1
        OnClick = EditCompanyRec
      end
      object btnDeleteCompany: TButton
        Tag = 2
        Left = 4
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Detaches or Deletes the selected company from the Multi-Company ' +
          'Manager'
        HelpContext = 1
        Caption = '&Detach'
        TabOrder = 3
        OnClick = DeleteCompanyRec
      end
      object btnFindCompany: TButton
        Tag = 2
        Left = 4
        Top = 97
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'F&ind'
        TabOrder = 4
        OnClick = Find
      end
      object btnLoggedInUsersReports: TButton
        Tag = 2
        Left = 4
        Top = 126
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'Login Report'
        TabOrder = 5
        OnClick = btnLoggedInUsersReportsClick
      end
      object btnBackupCompany: TButton
        Tag = 2
        Left = 4
        Top = 150
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'Backup'
        TabOrder = 6
        OnClick = btnBackupCompanyClick
      end
      object btnRestoreCompany: TButton
        Tag = 2
        Left = 4
        Top = 174
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'Restore'
        TabOrder = 7
        OnClick = btnRestoreCompanyClick
      end
      object btnRebuildCompany: TButton
        Tag = 2
        Left = 4
        Top = 198
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'Rebuild'
        TabOrder = 8
        OnClick = btnRebuildCompanyClick
      end
      object btnViewCompany: TButton
        Tag = 2
        Left = 4
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Detaches or Deletes the selected company from the Multi-Company ' +
          'Manager'
        HelpContext = 1
        Caption = '&View'
        TabOrder = 2
        OnClick = ViewCompanyRec
      end
    end
  end
  object bdsCompanyList: TBTGlobalDataset
    FileName = 'Parameter Not used'
    SearchKey = 'C'
    OnGetFieldValue = bdsCompanyListGetFieldValue
    OnGetFileVar = bdsCompanyListGetFileVar
    OnGetDataRecord = bdsCompanyListGetDataRecord
    OnGetBufferSize = bdsCompanyListGetBufferSize
    Left = 104
    Top = 134
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 94
    Top = 43
    object popAddCompany: TMenuItem
      Tag = 1
      Caption = '&Attach Existing Company'
      OnClick = AddCompany
    end
    object popEditCompany: TMenuItem
      Tag = 2
      Caption = '&Edit Company Details'
      OnClick = EditCompanyRec
    end
    object popViewCompanyDetails: TMenuItem
      Caption = '&View Company Details'
      OnClick = ViewCompanyRec
    end
    object popDeleteCompany: TMenuItem
      Tag = 3
      Caption = '&Detach Selected Company'
      OnClick = DeleteCompanyRec
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popFindCompany: TMenuItem
      Caption = '&Find Company'
      OnClick = Find
    end
    object PopupOpt_SepBar2: TMenuItem
      Caption = '-'
    end
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
