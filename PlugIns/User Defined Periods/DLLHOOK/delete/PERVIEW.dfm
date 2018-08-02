object frmPeriodList: TfrmPeriodList
  Left = 293
  Top = 146
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Period Selection'
  ClientHeight = 430
  ClientWidth = 346
  Color = clBtnFace
  Constraints.MinHeight = 260
  Constraints.MinWidth = 220
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lCompany: TLabel
    Left = 8
    Top = 12
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object cmbCompany: TComboBox
    Left = 64
    Top = 8
    Width = 273
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object panMain: TPanel
    Left = 0
    Top = 40
    Width = 337
    Height = 385
    BevelOuter = bvNone
    TabOrder = 1
    object lMaxPeriods: TLabel
      Left = 16
      Top = 32
      Width = 121
      Height = 14
      Caption = 'Maximum No. of Periods :'
    end
    object Bevel1: TBevel
      Left = 8
      Top = 72
      Width = 329
      Height = 281
      Shape = bsFrame
    end
    object lLastDate: TLabel
      Left = 72
      Top = 8
      Width = 265
      Height = 14
      AutoSize = False
    end
    object Label2: TLabel
      Left = 16
      Top = 8
      Width = 55
      Height = 14
      Caption = 'Last Date : '
    end
    object Bevel2: TBevel
      Left = 8
      Top = 0
      Width = 329
      Height = 57
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
    object btnInsert: TButton
      Left = 248
      Top = 88
      Width = 80
      Height = 21
      Caption = '&Insert'
      TabOrder = 2
      OnClick = actInsertExecute
    end
    object btnEdit: TButton
      Left = 248
      Top = 112
      Width = 80
      Height = 21
      Caption = '&Edit'
      TabOrder = 3
      OnClick = actEditExecute
    end
    object btnDelete: TButton
      Left = 248
      Top = 136
      Width = 80
      Height = 21
      Caption = '&Delete'
      TabOrder = 4
      OnClick = actDeleteExecute
    end
    object btnSave: TButton
      Left = 168
      Top = 360
      Width = 80
      Height = 21
      Caption = '&Save'
      TabOrder = 9
      OnClick = mniSaveClick
    end
    object btnClose: TButton
      Left = 256
      Top = 360
      Width = 80
      Height = 21
      Caption = '&Close'
      TabOrder = 10
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
      TabOrder = 0
      OnClick = cbUsePlugInClick
    end
    object btnReload: TButton
      Left = 248
      Top = 248
      Width = 80
      Height = 21
      Caption = '&Reload'
      TabOrder = 8
      OnClick = mniReloadClick
    end
    object btnExport: TButton
      Left = 248
      Top = 224
      Width = 80
      Height = 21
      Caption = 'E&xport'
      TabOrder = 7
      OnClick = mniExportClick
    end
    object btnLastDate: TButton
      Left = 248
      Top = 168
      Width = 80
      Height = 21
      Caption = '&Last Date'
      TabOrder = 5
      OnClick = actEditLastDateExecute
    end
    object btnAutoFill: TButton
      Left = 248
      Top = 192
      Width = 80
      Height = 21
      Caption = '&Auto-Fill'
      TabOrder = 6
      OnClick = actAutoFillExecute
    end
  end
  object mnuPopup: TPopupMenu
    Left = 40
    Top = 384
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
    Left = 72
    Top = 384
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
