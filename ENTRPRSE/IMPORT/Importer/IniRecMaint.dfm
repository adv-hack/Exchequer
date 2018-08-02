object frmIniRecMaint: TfrmIniRecMaint
  Left = 64
  Top = 224
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Edit Exchequer Field Definition'
  ClientHeight = 251
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 19
    Top = 81
    Width = 602
    Height = 27
    AutoSize = False
    Caption = '           Do not bring this label to the front'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 887
    Height = 65
    Caption = 'Field Meta-Data'
    TabOrder = 0
    object lblTemplate: TLabel
      Left = 3
      Top = 48
      Width = 756
      Height = 14
      Caption = 
        ' RT.Field Name               |OSET|OO|T|WWWW|U|X|Field Desc     ' +
        '                                   |default='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object lblFieldDesc: TLabel
      Left = 348
      Top = 8
      Width = 237
      Height = 13
      Caption = 'N.B. Customer already has a field called "Bernard"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edtIniRecord: TEdit
      Left = 8
      Top = 24
      Width = 873
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 
        'CU.NomCode                           L 0004 O X Nominal Code    ' +
        '                                   default=                     ' +
        '                                                                ' +
        '                comment='
      OnChange = edtIniRecordChange
      OnKeyPress = edtIniRecordKeyPress
      OnKeyUp = edtIniRecordKeyUp
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 118
    Width = 889
    Height = 102
    TabOrder = 4
    object lblRecordSize: TLabel
      Left = 8
      Top = 80
      Width = 66
      Height = 14
      Caption = 'lblRecordSize'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblRecordDefinition: TLabel
      Left = 8
      Top = -1
      Width = 123
      Height = 13
      Caption = 'Exchequer Field Definition'
    end
    object mlIniRecord: TMultiList
      Left = 8
      Top = 16
      Width = 873
      Height = 59
      Bevels.Inner = bvRaised
      Custom.ListName = 'Available Fields'
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 1
      Options.BoldActiveColumn = False
      Options.MultiSelection = True
      Options.MultiSelectIntegrity = True
      Columns = <
        item
          Caption = 'Field No'
          Field = 'FieldNo'
          Searchable = True
          Width = 55
        end
        item
          Caption = 'RT'
          Width = 20
        end
        item
          Caption = 'Field Name'
          Field = 'FieldName'
          Searchable = True
        end
        item
          Alignment = taCenter
          Caption = 'Offset'
          Width = 45
        end
        item
          Alignment = taCenter
          Caption = 'Occurs'
          Field = 'occurs'
          Width = 45
        end
        item
          Alignment = taCenter
          Caption = 'Type'
          Width = 30
        end
        item
          Alignment = taCenter
          Caption = 'Width'
          Width = 35
        end
        item
          Alignment = taCenter
          Caption = 'Usage'
          Width = 38
        end
        item
          Alignment = taCenter
          Caption = 'Sys'
          Width = 24
        end
        item
          Caption = 'Field Desc'
          Width = 170
        end
        item
          Caption = 'Default='
          Width = 50
        end
        item
          Caption = 'Field Default'
          Width = 80
        end
        item
          Caption = 'Comment='
          Width = 65
        end
        item
          Caption = 'Field Comment'
          Width = 610
        end>
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      PopupMenu = PopupMenu1
      TabOrder = 0
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = [fsBold]
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
    object lblDelphiDef: TStaticText
      Left = 592
      Top = 80
      Width = 272
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'DelphiDef'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object btnSaveClose: TButton
    Left = 729
    Top = 224
    Width = 80
    Height = 21
    Hint = '|Save this Field Def and close this window'
    Caption = 'Save + Close'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnSaveCloseClick
  end
  object btnCancel: TButton
    Left = 816
    Top = 224
    Width = 80
    Height = 21
    Hint = '|Cancel any changes to this Field Def and close this window'
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object btnApplyEdits: TButton
    Left = 817
    Top = 88
    Width = 80
    Height = 21
    Hint = '|Validate the amended Field Def into the columns below'
    Caption = 'Apply'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnApplyEditsClick
  end
  object btnSetDefault: TButton
    Left = 641
    Top = 88
    Width = 80
    Height = 21
    Hint = 'Set "default=" at its correction location in this Field Def'
    Caption = 'Set Default='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSetDefaultClick
  end
  object btnSetComment: TButton
    Left = 729
    Top = 88
    Width = 80
    Height = 21
    Hint = 'Set "comment=" at its correction location in this Field Def'
    Caption = 'Set Comment='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnSetCommentClick
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 81
    Width = 36
    Height = 28
    TabOrder = 9
    object lblOVRINS: TLabel
      Left = 3
      Top = 9
      Width = 30
      Height = 13
      Hint = '|Press the INSERT key to toggle Insert or Overtype modes'
      Alignment = taCenter
      AutoSize = False
      Caption = 'OVR'
    end
  end
  object btnSaveNext: TButton
    Left = 642
    Top = 224
    Width = 80
    Height = 21
    Hint = '|Save this Field Def and edit the next one'
    Caption = 'Save + Next'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnSaveNextClick
  end
  object btnSaveAdd: TButton
    Left = 556
    Top = 224
    Width = 80
    Height = 21
    Hint = '|Save this Field Def and add another'
    Caption = 'Save + Add'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnSaveAddClick
  end
  object GroupBox4: TGroupBox
    Left = 50
    Top = 81
    Width = 36
    Height = 28
    TabOrder = 10
    object lblNum: TLabel
      Left = 3
      Top = 9
      Width = 30
      Height = 13
      Hint = '|When active, only digits 0-9 may be entered'
      Alignment = taCenter
      AutoSize = False
      Caption = 'NUM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaptionText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 220
    object mniProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniPropertiesClick
    end
    object mniSaveCoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
end
