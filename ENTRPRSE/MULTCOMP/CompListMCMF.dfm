inherited frmStandardMCM: TfrmStandardMCM
  Left = 490
  Top = 199
  Width = 488
  Height = 322
  HelpContext = 28
  Caption = 'Multi-Company Manager'
  Menu = MainMenu1
  OldCreateOrder = True
  OnDblClick = FormDblClick
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  inherited mulCompanyList: TDBMultiList
    OnRowDblClick = mulCompanyListRowDblClick
  end
  inherited panButtons: TPanel
    inherited CloseBtn: TButton
      HelpContext = 7
    end
    inherited ScrollBox1: TScrollBox
      Height = 200
      object btnOpenSentimail: TButton [0]
        Tag = 2
        Left = 4
        Top = 49
        Width = 80
        Height = 21
        Hint = 'Opens the Exchequer Sentimail module'
        HelpContext = 11
        Caption = '&Sentimail'
        TabOrder = 2
        OnClick = OpenSentimail
      end
      inherited btnRebuildCompany: TButton [1]
        Top = 175
        TabOrder = 10
      end
      inherited btnFindCompany: TButton [2]
        Top = 150
        HelpContext = 5
        TabOrder = 6
      end
      inherited btnRestoreCompany: TButton [3]
        Top = 127
        TabOrder = 9
        Visible = False
      end
      inherited btnBackupCompany: TButton [4]
        Top = 104
        TabOrder = 8
        Visible = False
      end
      inherited btnAddCompany: TButton [5]
        Top = 102
        HelpContext = 3
        TabOrder = 3
      end
      inherited btnEditCompany: TButton [6]
        Top = 126
        TabOrder = 4
      end
      inherited btnLoggedInUsersReports: TButton [7]
        Top = 81
        TabOrder = 7
        Visible = False
      end
      inherited btnDeleteCompany: TButton [8]
        Top = 176
        TabOrder = 5
      end
      inherited btnViewCompany: TButton
        Top = 150
        HelpContext = 16
        TabOrder = 11
      end
      object btnOpenEnterprise: TButton
        Tag = 2
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        Hint = 'Opens the company In Exchequer Windows'
        HelpContext = 6
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
        HelpContext = 4
        Caption = 'e&Business'
        TabOrder = 1
        OnClick = OpenEBusiness
      end
    end
  end
  object MainMenu1: TMainMenu [3]
    AutoHotkeys = maManual
    Left = 89
    Top = 38
    object Menu_File: TMenuItem
      Caption = '&File'
      HelpContext = 10
      object mnuOpenEnterprise: TMenuItem
        Caption = '&Open Company'
        HelpContext = 6
        OnClick = OpenEnterprise
      end
      object MenuOpt_SepBar4: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maAutomatic
        Caption = '-'
      end
      object mnuOpenEBusiness: TMenuItem
        Caption = 'Open e&Business Module'
        HelpContext = 4
        OnClick = OpenEBusiness
      end
      object mnuOpenScheduler: TMenuItem
        Caption = 'Open Sc&heduler'
        OnClick = mnuOpenSchedulerClick
      end
      object mnuOpenSentimail: TMenuItem
        Caption = 'Open &Sentimail Module'
        HelpContext = 11
        OnClick = OpenSentimail
      end
      object MenuOpt_SepBar7: TMenuItem
        Caption = '-'
      end
      object mnuAddCompany: TMenuItem
        Caption = '&Attach Existing Company'
        HelpContext = 3
        OnClick = AddCompany
      end
      object mnuEditCompany: TMenuItem
        Caption = '&Edit Company Details'
        HelpContext = 2
        OnClick = EditCompanyRec
      end
      object mnuViewCompanyDetails: TMenuItem
        Caption = '&View Company Details'
        HelpContext = 16
        OnClick = ViewCompanyRec
      end
      object mnuDeleteCompany: TMenuItem
        Caption = '&Detach Selected Company'
        HelpContext = 1
        OnClick = DeleteCompanyRec
      end
      object MenuOpt_SepBar6: TMenuItem
        Caption = '-'
      end
      object mnuUpdateLicence: TMenuItem
        Caption = 'Update Licence'
        OnClick = mnuUpdateLicenceClick
      end
      object mnuModuleLicencing: TMenuItem
        Caption = '&Module Licences and User Counts'
        OnClick = ModuleRelCodes
      end
      object mnuEntUserCount: TMenuItem
        Caption = 'Exchequer Multi-&User Licence'
        OnClick = EnterpriseUserCount
      end
      object mnuEntReleaseCode: TMenuItem
        Caption = 'Exchequer Security &Release Code'
        OnClick = EnterpriseRelCode
      end
      object MenuOpt_SepBar8: TMenuItem
        Caption = '-'
      end
      object mnuSecurityUtilities: TMenuItem
        Caption = 'Se&curity Utilities'
        object MenuOpt_ResyncComps: TMenuItem
          Caption = 'Resynchronise &Company Licences'
          OnClick = ResyncCompanies
        end
        object MenuOpt_ResetUserCounts: TMenuItem
          Caption = 'Reset System &User Counts'
          OnClick = ResetEntUserCounts
        end
        object MenuOpt_ResetIndividualUserCounts: TMenuItem
          Caption = 'Reset &Individual User Counts'
          OnClick = MenuOpt_ResetIndividualUserCountsClick
        end
        object MenuOpt_ResetPIUsers: TMenuItem
          Caption = 'Reset &Plug-In User Counts'
          OnClick = ResetPlugInUserCounts
        end
      end
      object MenuOpt_SepBar1: TMenuItem
        Caption = '-'
      end
      object mnuMCMLogin: TMenuItem
        Caption = '&Login'
        HelpContext = 17
        OnClick = Login
      end
      object MenuOpt_SepBar3: TMenuItem
        Caption = '-'
      end
      object MenuOpt_Exit: TMenuItem
        Caption = 'Exi&t'
        HelpContext = 7
        OnClick = CloseMCM
      end
    end
    object mnuTools: TMenuItem
      Caption = '&Tools'
      HelpContext = 9
      object mnuLoggedInUserReport: TMenuItem
        Caption = 'Logged In User Report'
        HelpContext = 22
        OnClick = LoggedInUserReport
      end
      object MenuOpt_SepBar9: TMenuItem
        Caption = '-'
      end
      object mnuOpenRebuild: TMenuItem
        Caption = 'R&ebuild'
        HelpContext = 18
        OnClick = OpenRebuild
      end
      object MenuOpt_SepBar10: TMenuItem
        Caption = '-'
      end
      object mnuRunBackup: TMenuItem
        Caption = '&Backup'
        HelpContext = 23
        OnClick = RunBackup
      end
      object mnuRunRestore: TMenuItem
        Caption = '&Restore'
        HelpContext = 23
        OnClick = RunRestore
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuEncryptDataFiles: TMenuItem
        Caption = 'Encrypt &Data Files'
        Visible = False
        OnClick = mnuEncryptDataFilesClick
      end
      object MenuOpt_SepBar5: TMenuItem
        Caption = '-'
      end
      object mnuMCMOptions: TMenuItem
        Caption = '&Options'
        HelpContext = 25
        OnClick = DisplayMCMOptions
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      HelpContext = 8
      object MenuOpt_HelpCont: TMenuItem
        Caption = '&Contents'
        OnClick = ShowHelpContents
      end
      object MenuOpt_SepBar2: TMenuItem
        Caption = '-'
      end
      object MenuOpt_SessionInfo: TMenuItem
        Caption = 'Session Information'
        OnClick = SessionInformation
      end
      object MenuOpt_About: TMenuItem
        Caption = '&About...'
        HelpContext = 16
        OnClick = ShowAbout
      end
    end
    object Bang1: TMenuItem
      Caption = 'Bang'
      OnClick = Bang1Click
    end
  end
  inherited PopupMenu1: TPopupMenu
    Left = 183
    Top = 44
    object popOpenEnterprise: TMenuItem [0]
      Caption = '&Open Company'
      HelpContext = 6
      OnClick = OpenEnterprise
    end
    object N3: TMenuItem [1]
      Caption = '-'
    end
    object popOpenEBusiness: TMenuItem [2]
      Caption = 'Open e&Business Module'
      HelpContext = 4
      OnClick = OpenEBusiness
    end
    object popOpenScheduler: TMenuItem [3]
      Caption = 'Open Sc&heduler'
      OnClick = mnuOpenSchedulerClick
    end
    object popOpenSentimail: TMenuItem [4]
      Caption = 'Open &Sentimail Module'
      HelpContext = 11
      OnClick = OpenSentimail
    end
    object N2: TMenuItem [5]
      Caption = '-'
    end
    inherited popAddCompany: TMenuItem
      HelpContext = 3
    end
    inherited popEditCompany: TMenuItem
      HelpContext = 2
    end
    inherited popViewCompanyDetails: TMenuItem
      HelpContext = 16
    end
    inherited popDeleteCompany: TMenuItem
      HelpContext = 1
    end
    inherited popFindCompany: TMenuItem
      HelpContext = 5
    end
  end
end
