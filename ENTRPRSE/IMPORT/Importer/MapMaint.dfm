object frmMapMaint: TfrmMapMaint
  Left = 235
  Top = 184
  HelpContext = 5
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Field Map'
  ClientHeight = 526
  ClientWidth = 719
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
  WindowState = wsMinimized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  DesignSize = (
    719
    526)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 12
    Top = 8
    Width = 69
    Height = 14
    Caption = 'Record Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 14
    Top = 28
    Width = 89
    Height = 14
    Caption = 'Import File Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object lblRTDescription: TLabel
    Left = 349
    Top = 10
    Width = 332
    Height = 31
    AutoSize = False
    Caption = 'lblRTDescription'
    WordWrap = True
  end
  object cbFieldDef: TComboBox
    Left = 88
    Top = 5
    Width = 209
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnChange = cbFieldDefChange
  end
  object gbAvailableFields: TGroupBox
    Left = 8
    Top = 50
    Width = 702
    Height = 188
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Available Fields'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      702
      188)
    object mlAvailableFields: TMultiList
      Left = 17
      Top = 19
      Width = 580
      Height = 163
      Bevels.Inner = bvRaised
      Custom.ListName = 'Available Fields'
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Options.MultiSelection = True
      Options.MultiSelectIntegrity = True
      Columns = <
        item
          Caption = 'Field ID'
          Field = 'FieldID'
          Sortable = True
          Visible = False
        end
        item
          Caption = 'Field name'
          Field = 'FieldName'
          Sortable = True
          Width = 250
        end
        item
          Caption = 'Field Default'
          Field = 'FieldDefault'
        end
        item
          Caption = 'FieldDef'
          Field = 'FieldDef'
          Visible = False
          Width = 400
        end
        item
          Caption = 'Comment'
          Field = 'Comment'
          Width = 350
        end
        item
          Caption = 'Field Usage'
          Field = 'FieldUsage'
          Visible = False
        end>
      TabStop = True
      OnChangeSelection = mlAvailableFieldsChangeSelection
      OnRowDblClick = mlAvailableFieldsRowDblClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      PopupMenu = AvailableFieldsPopupMenu
      TabOrder = 0
      Anchors = [akLeft, akTop, akRight, akBottom]
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Arial'
      HighlightFont.Style = [fsBold]
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = [fsBold]
      Version = 'v1.13'
    end
    object btnSelectFieldDef: TButton
      Left = 614
      Top = 40
      Width = 80
      Height = 21
      Hint = '|Add the selected field to the Field Map below'
      Caption = 'Select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSelectFieldDefClick
    end
    object btnSelectAllFieldDefs: TButton
      Left = 614
      Top = 88
      Width = 80
      Height = 21
      Hint = '|Add all the available fields to the Field Map below'
      Caption = 'Select All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnSelectAllFieldDefsClick
    end
    object GroupBox3: TGroupBox
      Left = 614
      Top = 152
      Width = 36
      Height = 28
      Hint = 
        '|Press the INSERT key to switch between adding a field to the en' +
        'd of the list or inserting a field at the current position'
      TabOrder = 3
      object lblOVRINS: TLabel
        Left = 3
        Top = 9
        Width = 30
        Height = 13
        Hint = 
          '|Press the INSERT key to switch between adding a field to the en' +
          'd of the list or inserting a field at the current position'
        Alignment = taCenter
        AutoSize = False
        Caption = 'ADD'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 243
    Width = 704
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Field Map'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object pcFieldMap: TPageControl
      Left = 4
      Top = 18
      Width = 603
      Height = 200
      ActivePage = tsFType
      TabIndex = 2
      TabOrder = 0
      OnChange = pcFieldMapChange
      object tsSType: TTabSheet
        Caption = 'System'
        ImageIndex = 2
        object mlSType: TMultiList
          Left = 8
          Top = 6
          Width = 580
          Height = 164
          Bevels.Inner = bvRaised
          Custom.ListName = 'Available Fields'
          Custom.SplitterCursor = crHSplit
          Dimensions.HeaderHeight = 18
          Dimensions.SpacerWidth = 1
          Dimensions.SplitterWidth = 3
          Options.BoldActiveColumn = False
          Options.MultiSelection = True
          Options.MultiSelectIntegrity = True
          Columns = <
            item
              Caption = 'Field ID'
              Field = 'FieldID'
              Sortable = True
              Visible = False
            end
            item
              Caption = 'Field name'
              Field = 'FieldName'
              Width = 200
            end
            item
              Caption = 'Field Default'
            end
            item
              Caption = 'FieldDef'
              Visible = False
            end
            item
              Caption = 'Comment'
              Width = 290
            end
            item
              Caption = 'Field Usage'
              Visible = False
            end>
          TabStop = True
          OnCellPaint = mlSTypeCellPaint
          OnChangeSelection = mlSTypeChangeSelection
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          PopupMenu = FieldMapPopupMenu
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
          HighlightFont.Style = [fsBold]
          MultiSelectFont.Charset = DEFAULT_CHARSET
          MultiSelectFont.Color = clWindowText
          MultiSelectFont.Height = -11
          MultiSelectFont.Name = 'Arial'
          MultiSelectFont.Style = []
          Version = 'v1.13'
        end
      end
      object tsAType: TTabSheet
        Caption = 'Header Record'
        ImageIndex = 1
        object mlAType: TMultiList
          Left = 8
          Top = 6
          Width = 580
          Height = 164
          Bevels.Inner = bvRaised
          Custom.ListName = 'Available Fields'
          Custom.SplitterCursor = crHSplit
          Dimensions.HeaderHeight = 18
          Dimensions.SpacerWidth = 1
          Dimensions.SplitterWidth = 3
          Options.BoldActiveColumn = False
          Options.MultiSelection = True
          Options.MultiSelectIntegrity = True
          Columns = <
            item
              Caption = 'Field ID'
              Field = 'FieldID'
              Sortable = True
              Visible = False
            end
            item
              Caption = 'Field name'
              Field = 'FieldName'
              Sortable = True
              Width = 200
            end
            item
              Caption = 'Field Default'
            end
            item
              Caption = 'FieldDef'
              Visible = False
            end
            item
              Caption = 'Comment'
              Width = 290
            end
            item
              Caption = 'Field Usage'
              Visible = False
            end>
          TabStop = True
          OnCellPaint = mlATypeCellPaint
          OnChangeSelection = mlATypeChangeSelection
          OnRowDblClick = mlATypeRowDblClick
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          PopupMenu = FieldMapPopupMenu
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
          HighlightFont.Style = [fsBold]
          MultiSelectFont.Charset = DEFAULT_CHARSET
          MultiSelectFont.Color = clWindowText
          MultiSelectFont.Height = -11
          MultiSelectFont.Name = 'Arial'
          MultiSelectFont.Style = []
          Version = 'v1.13'
        end
      end
      object tsFType: TTabSheet
        Caption = 'Detail Record'
        object mlFType: TMultiList
          Left = 8
          Top = 10
          Width = 580
          Height = 164
          Bevels.Inner = bvRaised
          Custom.ListName = 'Available Fields'
          Custom.SplitterCursor = crHSplit
          Dimensions.HeaderHeight = 18
          Dimensions.SpacerWidth = 1
          Dimensions.SplitterWidth = 3
          Options.BoldActiveColumn = False
          Options.MultiSelection = True
          Options.MultiSelectIntegrity = True
          Columns = <
            item
              Caption = 'Field ID'
              Field = 'FieldID'
              Sortable = True
              Visible = False
            end
            item
              Caption = 'Field name'
              Field = 'FieldName'
              Sortable = True
              Width = 200
            end
            item
              Caption = 'Field Default'
            end
            item
              Caption = 'FieldDef'
              Visible = False
              Width = 400
            end
            item
              Caption = 'Comment'
              Width = 290
            end
            item
              Caption = 'Field Usage'
              Visible = False
            end>
          TabStop = True
          OnCellPaint = mlFTypeCellPaint
          OnChangeSelection = mlFTypeChangeSelection
          OnRowDblClick = mlFTypeRowDblClick
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          PopupMenu = FieldMapPopupMenu
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
          HighlightFont.Style = [fsBold]
          MultiSelectFont.Charset = DEFAULT_CHARSET
          MultiSelectFont.Color = clWindowText
          MultiSelectFont.Height = -11
          MultiSelectFont.Name = 'Arial'
          MultiSelectFont.Style = []
          Version = 'v1.13'
        end
      end
    end
    object btnMoveFieldDefUp: TButton
      Left = 614
      Top = 65
      Width = 80
      Height = 21
      Hint = '|Move the selected field up'
      Caption = 'Move Up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnMoveFieldDefUpClick
    end
    object btnMoveFieldDefDown: TButton
      Left = 614
      Top = 89
      Width = 80
      Height = 21
      Hint = '|Move the selected field down'
      Caption = 'Move Down'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnMoveFieldDefDownClick
    end
    object btnEditDefault: TButton
      Left = 614
      Top = 41
      Width = 80
      Height = 21
      Hint = '|Edit the default value for the selected field'
      Caption = 'Edit'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnEditDefaultClick
    end
    object btnRemoveFieldDef: TButton
      Left = 614
      Top = 112
      Width = 80
      Height = 21
      Hint = '|Return the selected field to the list of available fields'
      Caption = 'De-Select'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnRemoveFieldDefClick
    end
    object btnRemoveAllFieldDefs: TButton
      Left = 614
      Top = 168
      Width = 80
      Height = 21
      Hint = '|Return all the fields to the list of available fields'
      Caption = 'De-Select All'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnRemoveAllFieldDefsClick
    end
    object edtMsg: TEdit
      Left = 5
      Top = 222
      Width = 603
      Height = 22
      BevelInner = bvSpace
      BevelOuter = bvSpace
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object btnCreateUserDefFile: TButton
      Left = 614
      Top = 197
      Width = 80
      Height = 21
      Hint = 
        '|Create a blank file containing just the column headings from th' +
        'is Field Map'
      Caption = 'Create File'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnCreateUserDefFileClick
    end
  end
  object btnSaveMapFile: TButton
    Left = 444
    Top = 498
    Width = 80
    Height = 21
    Hint = '|Save the changes to this Field Map'
    Caption = 'Save'
    Enabled = False
    TabOrder = 3
    OnClick = btnSaveMapFileClick
  end
  object btnSaveMapFileAs: TButton
    Left = 532
    Top = 498
    Width = 80
    Height = 21
    Hint = '|Save this Field Map'
    Caption = 'Save As'
    Enabled = False
    TabOrder = 4
    OnClick = btnSaveMapFileAsClick
  end
  object btnClose: TButton
    Left = 620
    Top = 498
    Width = 80
    Height = 21
    Hint = '|Close this window'
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object chbShowMandatory: TBorCheckEx
    Left = 12
    Top = 500
    Width = 177
    Height = 20
    Hint = 
      '|These fields cannot be altered but must appear at the start of ' +
      'each of your import records'
    Align = alRight
    Caption = 'Show required system fields'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TextId = 0
    OnClick = chbShowMandatoryClick
  end
  object cbImportFileType: TComboBox
    Left = 120
    Top = 29
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 7
    Text = 'User-Defined File'
    Visible = False
    OnChange = cbImportFileTypeChange
    Items.Strings = (
      'User-Defined File'
      'Std Import File')
  end
  object OpenDialog: TpsvOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 128
    Top = 132
  end
  object SaveDialog: TpsvSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 52
    Top = 128
  end
  object SaveCSVDialog: TpsvSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 212
    Top = 128
  end
  object AvailableFieldsPopupMenu: TPopupMenu
    Left = 328
    Top = 108
    object mniSelectFieldDef: TMenuItem
      Caption = 'Select'
      Hint = '|Add the selected field to the Field Map below'
      OnClick = btnSelectFieldDefClick
    end
    object mniSelectAllFieldDefs: TMenuItem
      Caption = 'Select All'
      Hint = '|Add all the available fields to the Field Map below'
      OnClick = btnSelectAllFieldDefsClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniProperties1: TMenuItem
      Caption = 'Properties'
      OnClick = mniProperties1Click
    end
    object mniSaveCoordinates1: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
  object FieldMapPopupMenu: TPopupMenu
    Left = 264
    Top = 340
    object mniEditDefault: TMenuItem
      Caption = 'Edit'
      Hint = '|Edit the default value for the selected field'
      OnClick = btnEditDefaultClick
    end
    object mniMoveFieldDefUp: TMenuItem
      Caption = 'Move Up'
      Hint = '|Move the selected field up'
      OnClick = btnMoveFieldDefUpClick
    end
    object mniMoveFieldDefDown: TMenuItem
      Caption = 'Move Down'
      Hint = '|Move the selected field up'
      OnClick = btnMoveFieldDefDownClick
    end
    object mniRemoveFieldDef: TMenuItem
      Caption = 'De-Select'
      Hint = '|Move the selected field up'
      OnClick = btnRemoveFieldDefClick
    end
    object mniRemoveAllFieldDefs: TMenuItem
      Caption = 'De-Select All'
      Hint = '|Move the selected field up'
      OnClick = btnRemoveAllFieldDefsClick
    end
    object mniCreateUserDefFile: TMenuItem
      Caption = 'Create File'
      Hint = 
        '|Create a blank file containing just the column headings from th' +
        'is Field Map'
      OnClick = btnCreateUserDefFileClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniProperties2: TMenuItem
      Caption = 'Properties'
      OnClick = mniProperties2Click
    end
    object mniSaveCoordinates2: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
end
