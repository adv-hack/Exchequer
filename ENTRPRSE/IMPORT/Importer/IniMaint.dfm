object frmIniMaint: TfrmIniMaint
  Left = 96
  Top = 175
  BorderStyle = bsSingle
  Caption = 'Exchequer Record Definition'
  ClientHeight = 378
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox3: TGroupBox
    Left = 0
    Top = 340
    Width = 816
    Height = 38
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      816
      38)
    object btnEdit: TButton
      Left = 640
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Edit the selected Field Def'
      Anchors = [akRight, akBottom]
      Caption = 'Edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnEditClick
    end
    object btnRecSizes: TButton
      Left = 385
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Display the sizes of the toolkit'#39's Exchequer records'
      Anchors = [akRight, akBottom]
      Caption = 'Rec Sizes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnRecSizesClick
    end
    object edtStatusBar: TEdit
      Left = 5
      Top = 11
      Width = 280
      Height = 22
      TabStop = False
      BevelKind = bkFlat
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object btnClose: TButton
      Left = 725
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Close this window'
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnCloseClick
    end
    object btnAdd: TButton
      Left = 470
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Add a new S-Type or F-Type Field Def'
      Anchors = [akRight, akBottom]
      Caption = 'Add x-Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 555
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Delete the selected Field Def'
      Anchors = [akRight, akBottom]
      Caption = 'Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnDeleteClick
    end
    object btnClipboard: TButton
      Left = 300
      Top = 11
      Width = 80
      Height = 21
      Hint = '|Copies the Delphi equivalents of all the fields to clipboard'
      Anchors = [akRight, akBottom]
      Caption = 'Clipboard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnClipboardClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 10
    Top = 10
    Width = 796
    Height = 330
    Align = alClient
    TabOrder = 0
    object lblRecordDefinition: TLabel
      Left = 8
      Top = -1
      Width = 155
      Height = 14
      Caption = 'Exchequer Record Definition'
      Enabled = False
    end
    object mlIniRecords: TMultiList
      Left = 2
      Top = 16
      Width = 792
      Height = 286
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
      TabStop = True
      OnChangeSelection = mlIniRecordsChangeSelection
      OnRowDblClick = mlIniRecordsRowDblClick
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
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
    object Panel1: TPanel
      Left = 2
      Top = 302
      Width = 792
      Height = 26
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        792
        26)
      object lblRecordSize: TLabel
        Left = 10
        Top = 7
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
      object lblImportRecordSize: TLabel
        Left = 87
        Top = 7
        Width = 95
        Height = 14
        Caption = 'lblImportRecordSize'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object lblOffset: TLabel
        Left = 160
        Top = 7
        Width = 76
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lblOffset'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblAdd: TLabel
        Left = 397
        Top = 7
        Width = 23
        Height = 14
        Anchors = [akRight, akBottom]
        Caption = 'Add:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rbSType: TRadioButton
        Left = 423
        Top = 6
        Width = 56
        Height = 17
        Hint = '|When checked, the Add button will add S-Type fields'
        Anchors = [akRight, akBottom]
        Caption = 'S-Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object rbFType: TRadioButton
        Left = 483
        Top = 6
        Width = 55
        Height = 17
        Hint = '|When checked, the Add button will add F-Type fields'
        Anchors = [akRight, akBottom]
        Caption = 'F-Type'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
      end
      object lblDelphiDef: TStaticText
        Left = 546
        Top = 7
        Width = 239
        Height = 13
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'DelphiDef'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object Panel2: TPanel
    Left = 806
    Top = 10
    Width = 10
    Height = 330
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 10
    Width = 10
    Height = 330
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 816
    Height = 10
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
  end
  object PopupMenu1: TPopupMenu
    Left = 328
    Top = 152
    object mniAdd: TMenuItem
      Caption = 'Add'
      Hint = '|Add a new S-Type or F-Type Field Def'
      OnClick = btnAddClick
    end
    object mniDelete: TMenuItem
      Caption = 'Delete'
      Hint = '|Delete the selected Field Def'
      OnClick = btnDeleteClick
    end
    object mniEdit: TMenuItem
      Caption = 'Edit'
      Hint = '|Edit the selected Field Def'
      OnClick = btnEditClick
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
end
