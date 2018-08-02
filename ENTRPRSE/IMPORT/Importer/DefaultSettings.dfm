object frmDefaultSettings: TfrmDefaultSettings
  Left = 22
  Top = 179
  HelpContext = 2
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Default Settings'
  ClientHeight = 362
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 14
  object lblPage: TLabel
    Left = 6
    Top = 336
    Width = 34
    Height = 14
    Caption = 'lblPage'
  end
  object PageControl: TPageControl
    Left = 193
    Top = 12
    Width = 545
    Height = 315
    ActivePage = tsSettings
    TabIndex = 0
    TabOrder = 1
    object tsSettings: TTabSheet
      Caption = 'Default Settings'
      ImageIndex = 1
      object btnMoveSettingUp: TButton
        Left = 412
        Top = 143
        Width = 20
        Height = 20
        Caption = #199
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Wingdings 3'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnMoveSettingUpClick
      end
      object btnMoveSettingDown: TButton
        Left = 412
        Top = 167
        Width = 20
        Height = 20
        Caption = #200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Wingdings 3'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnMoveSettingDownClick
      end
      object mlSettings: TMultiList
        Left = 4
        Top = 28
        Width = 441
        Height = 250
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'DefOrJob'
            Visible = False
          end
          item
            Caption = 'Setting'
            Field = 'JobSetting'
            Sortable = True
            Width = 200
          end
          item
            Caption = 'Current Value'
            Width = 200
          end>
        TabStop = True
        OnChangeSelection = mlSettingsChangeSelection
        OnRowDblClick = mlSettingsRowDblClick
        PopupMenu = PopupMenu2
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
      object btnAddSetting: TButton
        Left = 453
        Top = 72
        Width = 80
        Height = 21
        Hint = '|Add a new setting'
        Caption = 'Add'
        TabOrder = 3
        OnClick = btnAddSettingClick
      end
      object btnEditSetting: TButton
        Left = 453
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Edit the selected setting'
        Caption = 'Edit'
        Enabled = False
        TabOrder = 4
        OnClick = btnEditSettingClick
      end
      object btnRemoveSetting: TButton
        Left = 453
        Top = 121
        Width = 80
        Height = 21
        Hint = '|Remove the selected setting'
        Caption = 'Delete'
        Enabled = False
        TabOrder = 5
        OnClick = btnRemoveSettingClick
      end
      object btnRemoveAllSettings: TButton
        Left = 453
        Top = 145
        Width = 80
        Height = 21
        Hint = '|Remove all the settings for the selected section'
        Caption = 'Delete All'
        Enabled = False
        TabOrder = 6
        OnClick = btnRemoveAllSettingsClick
      end
      object btnReloadSettings: TButton
        Left = 453
        Top = 96
        Width = 80
        Height = 21
        Hint = '|Reload the settings for the selected section'
        Caption = 'Reload'
        TabOrder = 7
        Visible = False
        OnClick = btnReloadSettingsClick
      end
      object gbSections: TGroupBox
        Left = 448
        Top = 186
        Width = 89
        Height = 92
        Caption = 'Sections'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        Visible = False
        object btnAdminReload: TButton
          Left = 5
          Top = 16
          Width = 80
          Height = 21
          Hint = '|Reload the list of sections from the main settings file'
          Caption = 'Reload'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnAdminReloadClick
        end
        object btnAdminAddSection: TButton
          Left = 5
          Top = 40
          Width = 80
          Height = 21
          Hint = '|Add a new section to the main settings file'
          Caption = 'Add'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnAdminAddSectionClick
        end
        object btnAdminRemoveSection: TButton
          Left = 5
          Top = 64
          Width = 80
          Height = 21
          Hint = '|Remove the selected section from the main settings file'
          Caption = 'Delete'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnAdminRemoveSectionClick
        end
      end
    end
  end
  object pnlSections: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 326
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 6
      Top = 8
      Width = 173
      Height = 315
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object lbSections: TListBox
        Left = 4
        Top = 35
        Width = 163
        Height = 276
        Hint = '|Click on a section to display its settings'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        PopupMenu = PopupMenu3
        TabOrder = 0
        OnClick = lbSectionsClick
        OnDblClick = lbSectionsDblClick
      end
      object Edit2: TEdit
        Left = 4
        Top = 9
        Width = 163
        Height = 22
        TabStop = False
        BevelKind = bkFlat
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = 'Sections'
      end
    end
  end
  object btnPrev: TButton
    Left = 198
    Top = 333
    Width = 80
    Height = 21
    Hint = '|Go to the previous page'
    Caption = '<< Prev'
    TabOrder = 2
    OnClick = btnPrevClick
  end
  object btnNext: TButton
    Left = 288
    Top = 333
    Width = 80
    Height = 21
    Hint = '|Go to the next page'
    Caption = 'Next >>'
    TabOrder = 3
    OnClick = btnNextClick
  end
  object btnSave: TButton
    Left = 378
    Top = 333
    Width = 80
    Height = 21
    Hint = '|Save the changes to the main settings file'
    Caption = 'Save'
    TabOrder = 4
    Visible = False
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 469
    Top = 333
    Width = 80
    Height = 21
    Hint = '|Close this window'
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object OpenJobDialog: TpsvOpenDialog
    Left = 56
    Top = 112
  end
  object BrowseFolderDialog: TpsvBrowseFolderDialog
    Left = 56
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 112
    Top = 228
    object mnuSelectFiles: TMenuItem
      Caption = 'Add File(s)'
    end
    object mnuSelectFolder: TMenuItem
      Caption = 'Add Folder'
    end
  end
  object SaveJobDialog: TpsvSaveDialog
    Left = 56
    Top = 176
  end
  object OpenFileDialog: TpsvOpenDialog
    Left = 44
    Top = 247
  end
  object OpenMapFileDialog: TOpenDialog
    Left = 112
    Top = 140
  end
  object PopupMenu2: TPopupMenu
    Left = 324
    Top = 120
    object mniEditSetting: TMenuItem
      Caption = 'Edit'
      OnClick = btnEditSettingClick
    end
    object mniAddSetting: TMenuItem
      Caption = 'Add'
      OnClick = btnAddSettingClick
    end
    object mniReloadSettings: TMenuItem
      Caption = 'Reload'
      OnClick = btnReloadSettingsClick
    end
    object mniRemoveSetting: TMenuItem
      Caption = 'Delete'
      OnClick = btnRemoveSettingClick
    end
    object mniRemoveAllSettings: TMenuItem
      Caption = 'Delete All'
      OnClick = btnRemoveAllSettingsClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniPropertiesClick
    end
    object mniSaveCoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 124
    Top = 60
    object mniAdminReload: TMenuItem
      Caption = 'Reload'
      OnClick = btnAdminReloadClick
    end
    object mniAdminAddSection: TMenuItem
      Caption = 'Add'
      OnClick = btnAdminAddSectionClick
    end
    object mniAdminRemoveSection: TMenuItem
      Caption = 'Delete'
      OnClick = btnAdminRemoveSectionClick
    end
  end
end
