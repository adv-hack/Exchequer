object frmMain: TfrmMain
  Left = 386
  Top = 183
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CC / Dept / GL Code Configuration'
  ClientHeight = 410
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 48
    Width = 369
    Height = 97
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 96
    Width = 369
    Height = 49
    Shape = bsFrame
  end
  object lCompany: TLabel
    Left = 8
    Top = 11
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object Label3: TLabel
    Left = 16
    Top = 40
    Width = 78
    Height = 14
    Caption = 'Use GL Codes'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lGLCode: TLabel
    Left = 33
    Top = 116
    Width = 48
    Height = 14
    Caption = 'GL Code :'
  end
  object pcCombinations: TPageControl
    Left = 8
    Top = 152
    Width = 281
    Height = 249
    ActivePage = tsInvalid
    TabIndex = 1
    TabOrder = 4
    OnChange = pcCombinationsChange
    object tsValid: TTabSheet
      Caption = 'Valid Combinations'
      object mlValid: TDBMultiList
        Left = 8
        Top = 8
        Width = 258
        Height = 209
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Cost Centre'
            Field = 'C'
            Width = 80
          end
          item
            Caption = 'Department'
            Field = 'D'
            Width = 80
          end
          item
            Caption = 'VAT Code'
            Field = 'V'
            Width = 56
          end>
        TabStop = True
        OnRowDblClick = mlRowDblClick
        PopupMenu = RightClickMenu
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
        Dataset = bdsValid
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
    object tsInvalid: TTabSheet
      Caption = 'Invalid Combinations'
      ImageIndex = 1
      object mlInvalid: TDBMultiList
        Left = 8
        Top = 8
        Width = 258
        Height = 209
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Cost Centre'
            Field = 'C'
            Width = 80
          end
          item
            Caption = 'Department'
            Field = 'D'
            Width = 80
          end
          item
            Caption = 'VAT Code'
            Field = 'V'
            Width = 56
          end>
        TabStop = True
        OnRowDblClick = mlRowDblClick
        PopupMenu = RightClickMenu
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
        Dataset = bdsInvalid
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
  end
  object btnAdd: TButton
    Tag = 2
    Left = 296
    Top = 176
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 6
    OnClick = btnAddEditClick
  end
  object btnEdit: TButton
    Tag = 1
    Left = 296
    Top = 200
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 7
    OnClick = btnAddEditClick
  end
  object btnDelete: TButton
    Left = 296
    Top = 224
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 8
    OnClick = btnDeleteClick
  end
  object btnTest: TButton
    Left = 296
    Top = 280
    Width = 80
    Height = 21
    Caption = '&Test'
    TabOrder = 10
    OnClick = btnTestClick
  end
  object btnClose: TButton
    Left = 296
    Top = 376
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 11
    OnClick = btnCloseClick
  end
  object cmbCompany: TComboBox
    Left = 64
    Top = 8
    Width = 313
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object btnCopy: TButton
    Left = 296
    Top = 248
    Width = 80
    Height = 21
    Caption = 'Cop&y'
    TabOrder = 9
    OnMouseDown = btnCopyMouseDown
  end
  object rbSame: TRadioButton
    Left = 16
    Top = 64
    Width = 209
    Height = 17
    Caption = 'Same Combinations for all GL Codes'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rbClick
  end
  object rbDifferent: TRadioButton
    Left = 16
    Top = 88
    Width = 225
    Height = 17
    Caption = 'Different Combinations for each GL Code'
    TabOrder = 2
    TabStop = True
    OnClick = rbClick
  end
  object cmbGLCode: TComboBox
    Left = 88
    Top = 112
    Width = 177
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    Sorted = True
    TabOrder = 3
    OnChange = cmbGLCodeChange
  end
  object btnAddCode: TButton
    Left = 288
    Top = 113
    Width = 80
    Height = 21
    Caption = 'Add C&ode'
    TabOrder = 5
    OnClick = btnAddCodeClick
  end
  object RightClickMenu: TPopupMenu
    Left = 344
    Top = 336
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = btnAddEditClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = 'Edit'
      OnClick = btnAddEditClick
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = btnDeleteClick
    end
  end
  object MainMenu1: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object ValidateVAT1: TMenuItem
        Caption = 'Validate VAT'
        OnClick = ValidateVAT1Click
      end
      object Import1: TMenuItem
        Caption = 'Import'
        OnClick = Import1Click
      end
      object Export1: TMenuItem
        Caption = 'Export'
        OnClick = Export1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object RebuildDatafile1: TMenuItem
        Caption = 'Rebuild Datafile'
        Visible = False
        OnClick = RebuildDatafile1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object CopyBtnMenu: TPopupMenu
    TrackButton = tbLeftButton
    OnPopup = CopyBtnMenuPopup
    Left = 344
    Top = 248
    object CopyToCompany: TMenuItem
      Caption = 'Copy to Company'
      OnClick = btnCopyCompany
    end
    object CopytoGL: TMenuItem
      Caption = 'Copy to GL'
      OnClick = btnCopyGL
    end
  end
  object bdsValid: TBtrieveDataset
    OnGetFieldValue = bdsGetFieldValue
    Left = 16
    Top = 168
  end
  object bdsInvalid: TBtrieveDataset
    OnGetFieldValue = bdsGetFieldValue
    Left = 120
    Top = 168
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'CSV'
    Filter = 'CSV File|*.CSV'
    Left = 32
  end
end
