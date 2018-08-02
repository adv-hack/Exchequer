object frmAnonymisationControlCentre: TfrmAnonymisationControlCentre
  Left = 197
  Top = 301
  Width = 806
  Height = 305
  HelpContext = 2316
  Caption = 'Anonymisation Control Centre'
  Color = clBtnFace
  Constraints.MinHeight = 270
  Constraints.MinWidth = 790
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 5
    Top = 5
    Width = 700
    Height = 266
	HelpContext = 2316
    ActivePage = tabshDue
    PopupMenu = pmMain
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabshDue: TTabSheet
      Caption = '   Due  '
      object lvOverdue: TListView
        Left = 0
        Top = 18
        Width = 692
        Height = 219
		HelpContext = 2316
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Anonymisation Date'
            MinWidth = 100
            Width = 120
          end
          item
            Caption = 'Entity Type'
            MinWidth = 75
            Width = 100
          end
          item
            Caption = 'Entity Code'
            MinWidth = 75
            Width = 120
          end
          item
            Caption = 'Entity Name'
            MinWidth = 175
            Width = 300
          end>
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        FullDrag = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        PopupMenu = pmMain
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = actViewExecute
      end
      object pnlCheckBox: TPanel
        Left = 0
        Top = 0
        Width = 692
        Height = 18
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object imgCheckBox: TImage
          Left = 5
          Top = 2
          Width = 28
          Height = 15
          Picture.Data = {
            07544269746D6170AA040000424DAA0400000000000036000000280000001900
            00000F000000010018000000000074040000C40E0000C40E0000000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FFFF0000FF6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F
            6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6F
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000
            FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF728281667976
            0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF
            0000FF6B7D7C000B0800140C6D85790000FF0000FFFF0000FF6F6F6FFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F
            0000FF0000FF0000FF0000FF6F818204171463786F6C837500150672867A0000
            FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF6A797C0010116377720000
            FF0000FF7287780010046E8081FF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000
            FF7382856E80810000FF0000FF0000FF0000FF72827B6B7F80FF0000FF6F6F6F
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000
            FF6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F
            6F6F6F6F6F6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF}
          Transparent = True
          OnClick = imgCheckBoxClick
        end
      end
    end
    object tabshPending: TTabSheet
      Caption = 'Pending'
      ImageIndex = 1
      object lvPending: TListView
        Left = 0
        Top = 0
        Width = 692
        Height = 237
		HelpContext = 2316
        Align = alClient
        Columns = <
          item
            Caption = 'Anonymisation Date'
            MinWidth = 100
            Width = 120
          end
          item
            Caption = 'Entity Type'
            MinWidth = 75
            Width = 100
          end
          item
            Caption = 'Entity Code'
            MinWidth = 75
            Width = 120
          end
          item
            Caption = 'Entity Name'
            MinWidth = 175
            Width = 300
          end>
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = actViewExecute
        OnSelectItem = lvPendingSelectItem
      end
    end
  end
  object btnClose: TButton
    Left = 711
    Top = 25
    Width = 80
    Height = 21
	HelpContext = 259
    Action = actClose
    Cancel = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btnAnonymise: TButton
    Left = 711
    Top = 80
    Width = 80
    Height = 21    
    Action = actAnonymise
    Cancel = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object btnViewEntity: TButton
    Left = 711
    Top = 56
    Width = 80
    Height = 21    
    Action = actView
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object btnReports: TButton
    Left = 711
    Top = 135
    Width = 80
    Height = 21
    HelpContext = 1769
    Action = actReports
    Cancel = True
    ParentShowHint = False
    PopupMenu = pmReports
    ShowHint = True
    TabOrder = 4
  end
  object btnUtilities: TButton
    Left = 711
    Top = 159
    Width = 80
    Height = 21
    HelpContext = 395
    Action = actUtilities
    Cancel = True
    TabOrder = 5
    Visible = False
  end
  object btnSetup: TButton
    Left = 711
    Top = 104
    Width = 80
    Height = 21    
    Action = actSetup
    Cancel = True
    PopupMenu = pmSetup
    TabOrder = 6
  end
  object pmTagging: TPopupMenu
    Left = 182
    Top = 2
    object mnuTagAll1: TMenuItem
      Caption = '&Tag All'
      OnClick = mnuTagAll1Click
    end
    object mnuUntagAll: TMenuItem
      Caption = '&Untag All'
      OnClick = mnuUntagAllClick
    end
  end
  object pmSetup: TPopupMenu
    Left = 265
    Top = 2
    object pmoGDPRConfiguration: TMenuItem
      Action = actGDPRConfiguration
    end
    object pmoUserDefinedFieldsConfiguration: TMenuItem
      Action = actUserDefinedFields
    end
  end
  object pmReports: TPopupMenu
    Left = 339
    Top = 2
    object mnuCustInactivityRep: TMenuItem
      Action = actCustInactivityRep
    end
    object mnuSupplierInactivityRep: TMenuItem
      Action = actSupplierInactivityRep
    end
    object mnuEmployeeInactivityRep: TMenuItem
      Action = actEmployeeInactivityRep
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuAnonymisedCustRep: TMenuItem
      Action = actAnonymisedCustRep
    end
    object mnuAnonymisedSuppliersRep: TMenuItem
      Action = actAnonymisedSuppliersRep
    end
    object mnuAnonymisedEmployeesRep: TMenuItem
      Action = actAnonymisedEmployeesRep
    end
  end
  object alMain: TActionList
    Left = 723
    Top = 193
    object actClose: TAction
      Caption = 'C&lose'
	  HelpContext = 259
      Hint = 'Close Window'
      OnExecute = actCloseExecute
    end
    object actView: TAction
      Caption = '&View'      
      Hint = 'View Entity'
      OnExecute = actViewExecute
    end
    object actAnonymise: TAction
      Caption = '&Anonymise'      
      Hint = 'Anonymise Selected Entity'
      OnExecute = actAnonymiseExecute
    end
    object actReports: TAction
      Caption = '&Reports'
      HelpContext = 1769
      Hint = 'Reports Selected Entity'
      OnExecute = actReportsExecute
    end
    object actUtilities: TAction
      Caption = '&Utilities'      
      Hint = 'Utilities'
    end
    object actSetup: TAction
      Caption = '&Setup'      
      Hint = 'Setup'
      OnExecute = actSetupExecute
    end
    object actProperties: TAction
      Caption = 'Properties'
      Hint = 'Access Colour & Font settings'
      OnExecute = actPropertiesExecute
    end
    object actGDPRConfiguration: TAction
      Caption = 'GDPR Configuration'
      Hint = 'GDPR Configuration'
      OnExecute = actGDPRConfigurationExecute
    end
    object actUserDefinedFields: TAction
      Caption = 'User Defined Fields'
      Hint = 'User Defined Fields'
      OnExecute = actUserDefinedFieldsExecute
    end
    object actCustInactivityRep: TAction
      Caption = 'Customer/Consumer Inactivity'
      Hint = 'Customer/Consumer Inactivity Report'
    end
    object actSupplierInactivityRep: TAction
      Caption = 'Supplier Inactivity'
    end
    object actEmployeeInactivityRep: TAction
      Caption = 'Employee Inactivity'
    end
    object actAnonymisedCustRep: TAction
      Caption = 'Anonymised Customers/Consumers'
    end
    object actAnonymisedSuppliersRep: TAction
      Caption = 'Anonymised Suppliers'
    end
    object actAnonymisedEmployeesRep: TAction
      Caption = 'Anonymised Employees'
    end
  end
  object pmMain: TPopupMenu
    Left = 726
    Top = 230
    object mnuView: TMenuItem
      Action = actView
    end
    object mnuAnonymise: TMenuItem
      Action = actAnonymise
    end
    object mnuReports: TMenuItem
      Action = actReports
      object CustomerConsumerInactivity1: TMenuItem
        Action = actCustInactivityRep
      end
      object SupplierInactivity1: TMenuItem
        Action = actSupplierInactivityRep
      end
      object EmployeeInactivity1: TMenuItem
        Action = actEmployeeInactivityRep
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object AnonymisedCustomersConsumers1: TMenuItem
        Action = actAnonymisedCustRep
      end
      object Anonymise1: TMenuItem
        Action = actAnonymisedSuppliersRep
      end
      object AnonymisedEmployees1: TMenuItem
        Action = actAnonymisedEmployeesRep
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuUtilities: TMenuItem
      Action = actUtilities
      Visible = False
    end
    object mnuSetup: TMenuItem
      Action = actSetup
      object mnuGDPRConfiguration: TMenuItem
        Action = actGDPRConfiguration
      end
      object mnuUserDefinedFields: TMenuItem
        Action = actUserDefinedFields
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuProperties: TMenuItem
      Action = actProperties
    end
    object mnuSaveCoordinates: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
