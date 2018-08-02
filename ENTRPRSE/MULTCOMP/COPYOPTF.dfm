inherited CopyDataWiz2: TCopyDataWiz2
  Left = 441
  Top = 229
  HelpContext = 20
  Caption = 'CopyDataWiz2'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 246
    Height = 5
  end
  inherited TitleLbl: TLabel
    Caption = 'Select Data To Copy'
  end
  inherited InstrLbl: TLabel
    Height = 29
    Caption = 
      'Please select below the types of data you want to copy into the ' +
      'new company.'
  end
  object PageControl1: TPageControl [4]
    Left = 168
    Top = 85
    Width = 284
    Height = 152
    ActivePage = TabMisc
    PopupMenu = PopupMenu1
    TabIndex = 2
    TabOrder = 5
    OnChange = PageControl1Change
    object TabAcc: TTabSheet
      Caption = 'Accounts'
      object CustAcc: TSBSGroup
        Left = 2
        Top = 2
        Width = 271
        Height = 37
        Caption = 'Customer Accounts'
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Cust: TBorCheck
          Left = 10
          Top = 15
          Width = 82
          Height = 18
          Align = alRight
          Caption = 'Details'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_CustNote: TBorCheck
          Left = 140
          Top = 16
          Width = 114
          Height = 18
          Align = alRight
          Caption = 'Notes'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
      end
      object SuppAcc: TSBSGroup
        Left = 2
        Top = 42
        Width = 271
        Height = 37
        Caption = 'Supplier Accounts'
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Supp: TBorCheck
          Left = 12
          Top = 15
          Width = 77
          Height = 18
          Align = alRight
          Caption = 'Details'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_SuppNote: TBorCheck
          Left = 140
          Top = 15
          Width = 66
          Height = 18
          Align = alRight
          Caption = 'Notes'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
      end
    end
    object TabJob: TTabSheet
      Caption = 'Job Costing'
      object SBSGroup1: TSBSGroup
        Left = 2
        Top = 62
        Width = 271
        Height = 37
        Caption = 'Employee'
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Empl: TBorCheck
          Left = 10
          Top = 15
          Width = 82
          Height = 18
          Align = alRight
          Caption = 'Details'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_EmplRate: TBorCheck
          Left = 139
          Top = 15
          Width = 114
          Height = 18
          Align = alRight
          Caption = 'Rates Of Pay'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
      end
      object SBSGroup5: TSBSGroup
        Left = 2
        Top = 2
        Width = 271
        Height = 57
        Caption = 'Jobs'
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Job: TBorCheck
          Left = 10
          Top = 15
          Width = 82
          Height = 18
          Align = alRight
          Caption = 'Job Details'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_JobBudg: TBorCheck
          Left = 139
          Top = 15
          Width = 114
          Height = 18
          Align = alRight
          Caption = 'Job Budgets'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_JobAnal: TBorCheck
          Left = 139
          Top = 33
          Width = 114
          Height = 18
          Align = alRight
          Caption = 'Job Analysis'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_JobType: TBorCheck
          Left = 10
          Top = 33
          Width = 82
          Height = 18
          Align = alRight
          Caption = 'Job Types'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          TextId = 0
          OnClick = CheckHandler
        end
      end
    end
    object TabMisc: TTabSheet
      Caption = 'Misc'
      object SBSGroup2: TSBSGroup
        Left = 2
        Top = 2
        Width = 271
        Height = 114
        Caption = 'Miscellaneous'
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_RepWrt: TBorCheck
          Left = 10
          Top = 71
          Width = 155
          Height = 18
          Align = alRight
          Caption = 'Report Writer Reports'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_Disc: TBorCheck
          Left = 10
          Top = 52
          Width = 248
          Height = 18
          Align = alRight
          Caption = 'Customer and Quantity Discounts'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_CCDep: TBorCheck
          Left = 10
          Top = 33
          Width = 155
          Height = 18
          Align = alRight
          Caption = 'Cost Centres && Departments'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_Nom: TBorCheck
          Left = 10
          Top = 15
          Width = 180
          Height = 18
          Align = alRight
          Caption = 'General Ledger Accounts'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_SortView: TBorCheck
          Left = 10
          Top = 90
          Width = 155
          Height = 18
          Align = alRight
          Caption = 'Sort Views'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
          TextId = 0
          OnClick = CheckHandler
        end
      end
    end
    object TabSetup: TTabSheet
      Caption = 'Setup'
      object SBSGroup4: TSBSGroup
        Left = 2
        Top = 61
        Width = 271
        Height = 60
        Caption = 'Users'
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Users: TBorCheck
          Left = 10
          Top = 14
          Width = 119
          Height = 18
          Align = alRight
          Caption = 'Details && Security'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_UsWinPos: TBorCheck
          Left = 139
          Top = 14
          Width = 126
          Height = 18
          Align = alRight
          Caption = 'Window Positions'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
        object chkSignatures: TBorCheck
          Left = 10
          Top = 35
          Width = 136
          Height = 18
          Align = alRight
          Caption = 'Fax && Email Signatures'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TextId = 0
          OnClick = CheckHandler
        end
      end
      object SBSGroup7: TSBSGroup
        Left = 2
        Top = 2
        Width = 271
        Height = 57
        Caption = 'System Setup'
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Flags: TBorCheck
          Left = 10
          Top = 15
          Width = 119
          Height = 18
          Align = alRight
          Caption = 'Flags'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_Forms: TBorCheck
          Left = 10
          Top = 33
          Width = 168
          Height = 18
          Align = alRight
          Caption = 'Form Definitions and Layouts'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
      end
    end
    object TabStock: TTabSheet
      Caption = 'Stock'
      object SBSGroup6: TSBSGroup
        Left = 2
        Top = 2
        Width = 271
        Height = 95
        Caption = 'Stock'
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Chk_Stock: TBorCheck
          Left = 10
          Top = 15
          Width = 232
          Height = 18
          Align = alRight
          Caption = 'Stock Items && Bill Of Materials'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_StkNotes: TBorCheck
          Left = 10
          Top = 33
          Width = 98
          Height = 18
          Align = alRight
          Caption = 'Notes'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_MLStock: TBorCheck
          Left = 10
          Top = 71
          Width = 128
          Height = 18
          Align = alRight
          Caption = 'Multi-Location Stock'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          TextId = 0
          OnClick = CheckHandler
        end
        object Chk_AltCodes: TBorCheck
          Left = 10
          Top = 52
          Width = 168
          Height = 18
          Align = alRight
          Caption = 'Alternate Stock Codes'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TextId = 0
          OnClick = CheckHandler
        end
      end
    end
  end
  inherited NextBtn: TButton
    Caption = '&Copy'
  end
  object PopupMenu1: TPopupMenu
    Left = 4
    Top = 6
    object SelectAllDataItems1: TMenuItem
      Caption = 'Select All'
      OnClick = Popup_SelectClick
    end
    object SelectNone1: TMenuItem
      Caption = 'Select None'
      OnClick = Popup_SelectClick
    end
  end
end
