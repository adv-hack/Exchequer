object frmBureauMCM: TfrmBureauMCM
  Left = 393
  Top = 222
  Width = 479
  Height = 249
  Caption = 'frmBureauMCM'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
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
      Height = 153
      Anchors = [akLeft, akTop, akBottom]
      BorderStyle = bsNone
      TabOrder = 1
      object btnFindCompany: TButton
        Tag = 2
        Left = 4
        Top = 78
        Width = 80
        Height = 21
        Hint = 'Deletes a company from the Multi-Company Manager'
        HelpContext = 1
        Caption = 'F&ind'
        TabOrder = 3
        OnClick = btnFindCompanyClick
      end
      object btnOpenEnterprise: TButton
        Tag = 2
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        Hint = 'Opens the company In Exchequer Windows'
        Caption = '&Open'
        Default = True
        TabOrder = 0
        OnClick = OpenEnterprise
      end
      object btnOpenEBusiness: TButton
        Tag = 2
        Left = 4
        Top = 25
        Width = 80
        Height = 21
        Hint = 'Opens the Exchequer eBusiness module'
        Caption = 'e&Business'
        TabOrder = 1
        OnClick = OpenEBusiness
      end
      object btnOpenSentimail: TButton
        Tag = 2
        Left = 4
        Top = 49
        Width = 80
        Height = 21
        Hint = 'Opens the Exchequer Sentimail module'
        Caption = '&Sentimail'
        TabOrder = 2
        OnClick = OpenSentimail
      end
      object btnChangePWord: TSBSButton
        Left = 4
        Top = 102
        Width = 80
        Height = 21
        Caption = 'Change &Pword'
        TabOrder = 4
        OnClick = btnChangePWordClick
        TextId = 0
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
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 89
    Top = 31
    object Menu_File: TMenuItem
      Caption = '&File'
      HelpContext = 10
      object mnuOpenEnterprise: TMenuItem
        Caption = '&Open Company'
        OnClick = OpenEnterprise
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuOpenEBusiness: TMenuItem
        Caption = 'Open e&Business Module'
        OnClick = OpenEBusiness
      end
      object mnuOpenScheduler: TMenuItem
        Caption = 'Open Sc&heduler'
        OnClick = mnuOpenSchedulerClick
      end
      object mnuOpenSentimail: TMenuItem
        Caption = 'Open &Sentimail Module'
        OnClick = OpenSentimail
      end
      object MenuOpt_SepBar4: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maAutomatic
        Caption = '-'
      end
      object mnuOpenRebuild: TMenuItem
        Caption = 'Open R&ebuild Module'
        HelpContext = 18
        OnClick = mnuOpenRebuildClick
      end
      object MenuOpt_SepBar1: TMenuItem
        Caption = '-'
      end
      object mnuViewCompanyDetails: TMenuItem
        Caption = '&View Company Details'
        OnClick = ViewCompanyDets
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuSecurityUtilities: TMenuItem
        Caption = 'Se&curity Utilities'
        object MenuOpt_ResyncComps: TMenuItem
          Caption = 'Resynchronise &Company Licences'
          OnClick = MenuOpt_ResyncCompsClick
        end
        object MenuOpt_ResetUserCounts: TMenuItem
          Caption = 'Reset Exchequer &User Counts'
          OnClick = MenuOpt_ResetUserCountsClick
        end
        object MenuOpt_ResetIndividualUserCounts: TMenuItem
          Caption = 'Reset &Individual User Counts'
          OnClick = MenuOpt_ResetIndividualUserCountsClick
        end
        object MenuOpt_ResetPIUsers: TMenuItem
          Caption = 'Reset &Plug-In User Counts'
          OnClick = MenuOpt_ResetPIUsersClick
        end
      end
      object MenuOpt_SepBar10: TMenuItem
        Caption = '-'
      end
      object MenuOpt_Exit: TMenuItem
        Caption = 'Exi&t'
        OnClick = CloseMCM
      end
    end
    object mnuAdministration: TMenuItem
      Caption = '&Administration'
      object mnuCompaniesList: TMenuItem
        Caption = 'Companies List'
        OnClick = mnuCompaniesListClick
      end
      object mnuGroupsList: TMenuItem
        Caption = 'Groups List'
        OnClick = mnuGroupsListClick
      end
      object MenuOpt_SepBar8: TMenuItem
        Caption = '-'
      end
      object mnuMCMOptions: TMenuItem
        Caption = '&Options'
        HelpContext = 25
        OnClick = mnuMCMOptionsClick
      end
      object MenuOpt_SepBar5: TMenuItem
        Caption = '-'
      end
      object mnuLicencing: TMenuItem
        Caption = 'Licencing && Release Codes'
        object mnuEntReleaseCode: TMenuItem
          Caption = 'Exchequer Security &Release Code'
          OnClick = mnuEntReleaseCodeClick
        end
        object mnuEntUserCount: TMenuItem
          Caption = 'Exchequer Multi-&User Licence'
          OnClick = mnuEntUserCountClick
        end
        object mnuModuleLicencing: TMenuItem
          Caption = '&Module Licences and User Counts'
          OnClick = mnuModuleLicencingClick
        end
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      HelpContext = 8
      object MenuOpt_HelpCont: TMenuItem
        Caption = '&Contents'
        OnClick = MenuOpt_HelpContClick
      end
      object MenuOpt_SepBar2: TMenuItem
        Caption = '-'
      end
      object MenuOpt_SessionInfo: TMenuItem
        Caption = 'Session Information'
        OnClick = MenuOpt_SessionInfoClick
      end
      object MenuOpt_About: TMenuItem
        Caption = '&About...'
        HelpContext = 16
        OnClick = MenuOpt_AboutClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 173
    Top = 31
    object popOpenEnterprise: TMenuItem
      Caption = '&Open Company'
      OnClick = OpenEnterprise
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popOpenEBusiness: TMenuItem
      Caption = 'Open e&Business Module'
      OnClick = OpenEBusiness
    end
    object popOpenScheduler: TMenuItem
      Caption = 'Open Sc&heduler'
      OnClick = mnuOpenSchedulerClick
    end
    object popOpenSentimail: TMenuItem
      Caption = 'Open &Sentimail Module'
      OnClick = OpenSentimail
    end
    object PopupOpt_SepBar2: TMenuItem
      Caption = '-'
    end
    object popViewCompanyDetails: TMenuItem
      Caption = '&View Company Details'
      OnClick = ViewCompanyDets
    end
    object popFindCompany: TMenuItem
      Caption = '&Find Company'
      OnClick = btnFindCompanyClick
    end
    object N2: TMenuItem
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
      OnClick = popSavePositionClick
    end
  end
end
