object frmPeriodList: TfrmPeriodList
  Left = 350
  Top = 195
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Period Selection'
  ClientHeight = 410
  ClientWidth = 327
  Color = clBtnFace
  Constraints.MinHeight = 260
  Constraints.MinWidth = 220
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object lMaxPeriods: TLabel
    Left = 8
    Top = 40
    Width = 121
    Height = 14
    Caption = 'Maximum No. of Periods :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 72
    Width = 313
    Height = 281
    Shape = bsFrame
  end
  object lvwPeriods: TListView
    Left = 16
    Top = 88
    Width = 225
    Height = 257
    Columns = <
      item
        Caption = 'Period'
      end
      item
        Caption = 'Year'
      end
      item
        Caption = 'Start Date'
        Width = 105
      end>
    ColumnClick = False
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = mnuPopup
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = lvwPeriodsChange
    OnDblClick = actEditExecute
    OnKeyDown = lvwPeriodsKeyDown
  end
  object sbrLastDate: TStatusBar
    Left = 0
    Top = 391
    Width = 327
    Height = 19
    Panels = <
      item
        Text = 'Last Date :'
        Width = 60
      end
      item
        Width = 50
      end>
    ParentFont = True
    SimplePanel = False
    SizeGrip = False
    UseSystemFont = False
    OnDblClick = actEditLastDateExecute
  end
  object cmbCompany: TComboBox
    Left = 64
    Top = 8
    Width = 257
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnInsert: TButton
    Left = 248
    Top = 88
    Width = 65
    Height = 25
    Caption = '&Insert'
    TabOrder = 3
    OnClick = actInsertExecute
  end
  object btnEdit: TButton
    Left = 248
    Top = 120
    Width = 65
    Height = 25
    Caption = '&Edit'
    TabOrder = 4
    OnClick = actEditExecute
  end
  object btnDelete: TButton
    Left = 248
    Top = 152
    Width = 65
    Height = 25
    Caption = '&Delete'
    TabOrder = 5
    OnClick = actDeleteExecute
  end
  object btnSave: TButton
    Left = 184
    Top = 360
    Width = 65
    Height = 25
    Caption = '&Save'
    TabOrder = 6
    OnClick = mniSaveClick
  end
  object btnClose: TButton
    Left = 256
    Top = 360
    Width = 65
    Height = 25
    Caption = '&Close'
    TabOrder = 7
    OnClick = btnCloseClick
  end
  object cbUsePlugIn: TCheckBox
    Left = 16
    Top = 64
    Width = 121
    Height = 17
    Caption = 'Use Periods Plug-In'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = cbUsePlugInClick
  end
  object mnuMain: TMainMenu
    Left = 23
    Top = 112
    object mniFile: TMenuItem
      Caption = '&File'
      object mniSave: TMenuItem
        Caption = '&Save'
        OnClick = mniSaveClick
      end
      object mniReload: TMenuItem
        Caption = '&Reload'
        OnClick = mniReloadClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mniExport: TMenuItem
        Caption = '&Export to File'
        OnClick = mniExportClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mniExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mniExitClick
      end
    end
    object mniEdit: TMenuItem
      Caption = '&Edit'
      object mniInsertItem: TMenuItem
        Action = actInsert
      end
      object mniEditItem: TMenuItem
        Action = actEdit
      end
      object mniDeleteItem: TMenuItem
        Action = actDelete
      end
      object mniEditLastDate: TMenuItem
        Action = actEditLastDate
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mniAutoFill: TMenuItem
        Action = actAutoFill
      end
      object UndoAutoFill1: TMenuItem
        Action = actUndoAutoFill
      end
    end
    object mniHelp: TMenuItem
      Caption = '&Help'
      object mniAbout: TMenuItem
        Caption = '&About'
        OnClick = mniAboutClick
      end
    end
  end
  object mnuPopup: TPopupMenu
    Left = 56
    Top = 112
    object mniPopUpInsert: TMenuItem
      Action = actInsert
    end
    object mniPopupEdit: TMenuItem
      Action = actEdit
    end
    object mniPopUpDelete: TMenuItem
      Action = actDelete
    end
    object mniPopupEditLastDate: TMenuItem
      Action = actEditLastDate
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniPopupAutoFill: TMenuItem
      Action = actAutoFill
    end
    object UndoAutoFill2: TMenuItem
      Action = actUndoAutoFill
    end
  end
  object aclActions: TActionList
    Left = 88
    Top = 112
    object actAutoFill: TAction
      Caption = '&Auto Fill'
      OnExecute = actAutoFillExecute
    end
    object actInsert: TAction
      Caption = '&Insert'
      OnExecute = actInsertExecute
    end
    object actEdit: TAction
      Caption = '&Edit'
      OnExecute = actEditExecute
    end
    object actDelete: TAction
      Caption = '&Delete'
      OnExecute = actDeleteExecute
    end
    object actEditLastDate: TAction
      Caption = '&Last Date'
      OnExecute = actEditLastDateExecute
    end
    object actUndoAutoFill: TAction
      Caption = '&Undo AutoFill'
      Enabled = False
      OnExecute = actUndoAutoFillExecute
    end
  end
end
