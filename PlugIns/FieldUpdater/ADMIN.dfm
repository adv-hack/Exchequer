object frmAdmin: TfrmAdmin
  Left = 346
  Top = 82
  HorzScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 625
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 529
    Height = 81
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object Label2: TLabel
    Left = 16
    Top = 60
    Width = 63
    Height = 14
    Caption = 'Transaction :'
  end
  object Label3: TLabel
    Left = 296
    Top = 61
    Width = 37
    Height = 14
    Caption = 'Status :'
  end
  object lStatus: TLabel
    Left = 336
    Top = 61
    Width = 193
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel7: TBevel
    Left = 8
    Top = 103
    Width = 529
    Height = 162
    Shape = bsFrame
  end
  object Label12: TLabel
    Left = 16
    Top = 96
    Width = 86
    Height = 14
    Caption = 'Transaction Lines'
  end
  object Bevel8: TBevel
    Left = 8
    Top = 8
    Width = 529
    Height = 41
    Shape = bsFrame
  end
  object btnClose: TButton
    Left = 544
    Top = 8
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object cmbCompany: TComboBox
    Left = 88
    Top = 16
    Width = 441
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    Sorted = True
    TabOrder = 0
    OnChange = cmbCompanyChange
  end
  object pcTabs: TPageControl
    Left = 8
    Top = 272
    Width = 529
    Height = 345
    ActivePage = tsHeader
    TabIndex = 0
    TabOrder = 4
    object tsHeader: TTabSheet
      Caption = 'Header Fields'
      ImageIndex = 1
      object Bevel6: TBevel
        Left = 8
        Top = 8
        Width = 393
        Height = 297
        Shape = bsFrame
      end
      object Bevel5: TBevel
        Left = 8
        Top = 8
        Width = 393
        Height = 257
        Shape = bsFrame
      end
      object Label8: TLabel
        Left = 16
        Top = 20
        Width = 103
        Height = 14
        Caption = 'User Defined Field 1 :'
      end
      object Label9: TLabel
        Left = 16
        Top = 44
        Width = 103
        Height = 14
        Caption = 'User Defined Field 2 :'
      end
      object Label10: TLabel
        Left = 16
        Top = 68
        Width = 103
        Height = 14
        Caption = 'User Defined Field 3 :'
      end
      object Label11: TLabel
        Left = 16
        Top = 92
        Width = 103
        Height = 14
        Caption = 'User Defined Field 4 :'
      end
      object Bevel3: TBevel
        Left = 416
        Top = 8
        Width = 98
        Height = 297
      end
      object lDueDate: TLabel
        Left = 16
        Top = 277
        Width = 50
        Height = 14
        Caption = 'Due Date :'
      end
      object lHUDF5: TLabel
        Left = 16
        Top = 116
        Width = 103
        Height = 14
        Caption = 'User Defined Field 5 :'
      end
      object lHUDF6: TLabel
        Left = 16
        Top = 140
        Width = 103
        Height = 14
        Caption = 'User Defined Field 6 :'
      end
      object lHUDF7: TLabel
        Left = 16
        Top = 164
        Width = 103
        Height = 14
        Caption = 'User Defined Field 7 :'
      end
      object lHUDF8: TLabel
        Left = 16
        Top = 188
        Width = 103
        Height = 14
        Caption = 'User Defined Field 8 :'
      end
      object lHUDF9: TLabel
        Left = 16
        Top = 212
        Width = 103
        Height = 14
        Caption = 'User Defined Field 9 :'
      end
      object lHUDF10: TLabel
        Left = 16
        Top = 236
        Width = 109
        Height = 14
        Caption = 'User Defined Field 10 :'
      end
      object btnHSave: TButton
        Left = 425
        Top = 16
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Save'
        TabOrder = 11
        OnClick = btnHSaveClick
      end
      object edHDueDate: TDateTimePicker
        Left = 128
        Top = 273
        Width = 121
        Height = 22
        CalAlignment = dtaLeft
        Date = 40158.5668710764
        Time = 40158.5668710764
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 10
      end
      object edHUDF1: TEdit
        Left = 128
        Top = 16
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 0
      end
      object edHUDF2: TEdit
        Left = 128
        Top = 40
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 1
      end
      object edHUDF3: TEdit
        Left = 128
        Top = 64
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 2
      end
      object edHUDF4: TEdit
        Left = 128
        Top = 88
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 3
      end
      object btnHReload: TButton
        Left = 425
        Top = 40
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Reload'
        TabOrder = 12
        OnClick = btnHReloadClick
      end
      object edHUDF5: TEdit
        Left = 128
        Top = 112
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 4
      end
      object edHUDF6: TEdit
        Left = 128
        Top = 136
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 5
      end
      object edHUDF7: TEdit
        Left = 128
        Top = 160
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 6
      end
      object edHUDF8: TEdit
        Left = 128
        Top = 184
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 7
      end
      object edHUDF9: TEdit
        Left = 128
        Top = 208
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 8
      end
      object edHUDF10: TEdit
        Left = 128
        Top = 232
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 9
      end
    end
    object tsLines: TTabSheet
      Caption = 'Line Fields'
      object Bevel10: TBevel
        Left = 8
        Top = 8
        Width = 393
        Height = 297
        Shape = bsFrame
      end
      object Bevel4: TBevel
        Left = 8
        Top = 8
        Width = 393
        Height = 257
        Shape = bsFrame
      end
      object Label4: TLabel
        Left = 16
        Top = 20
        Width = 103
        Height = 14
        Caption = 'User Defined Field 1 :'
      end
      object Label5: TLabel
        Left = 16
        Top = 44
        Width = 103
        Height = 14
        Caption = 'User Defined Field 2 :'
      end
      object Label6: TLabel
        Left = 16
        Top = 68
        Width = 103
        Height = 14
        Caption = 'User Defined Field 3 :'
      end
      object Label7: TLabel
        Left = 16
        Top = 92
        Width = 103
        Height = 14
        Caption = 'User Defined Field 4 :'
      end
      object Bevel2: TBevel
        Left = 416
        Top = 8
        Width = 98
        Height = 297
      end
      object lLUDF5: TLabel
        Left = 16
        Top = 116
        Width = 103
        Height = 14
        Caption = 'User Defined Field 5 :'
      end
      object lLUDF6: TLabel
        Left = 16
        Top = 140
        Width = 103
        Height = 14
        Caption = 'User Defined Field 6 :'
      end
      object lLUDF7: TLabel
        Left = 16
        Top = 164
        Width = 103
        Height = 14
        Caption = 'User Defined Field 7 :'
      end
      object lLUDF8: TLabel
        Left = 16
        Top = 188
        Width = 103
        Height = 14
        Caption = 'User Defined Field 8 :'
      end
      object lLUDF9: TLabel
        Left = 16
        Top = 212
        Width = 103
        Height = 14
        Caption = 'User Defined Field 9 :'
      end
      object lLUDF10: TLabel
        Left = 16
        Top = 236
        Width = 109
        Height = 14
        Caption = 'User Defined Field 10 :'
      end
      object btnLSave: TButton
        Left = 425
        Top = 16
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Save'
        TabOrder = 10
        OnClick = btnLSaveClick
      end
      object edLUDF1: TEdit
        Left = 128
        Top = 16
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 0
      end
      object edLUDF2: TEdit
        Left = 128
        Top = 40
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 1
      end
      object edLUDF3: TEdit
        Left = 128
        Top = 64
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 2
      end
      object edLUDF4: TEdit
        Left = 128
        Top = 88
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 3
      end
      object btnLReload: TButton
        Left = 425
        Top = 40
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Reload'
        TabOrder = 11
        OnClick = btnLReloadClick
      end
      object edLUDF5: TEdit
        Left = 128
        Top = 112
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 4
      end
      object edLUDF6: TEdit
        Left = 128
        Top = 136
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 5
      end
      object edLUDF7: TEdit
        Left = 128
        Top = 160
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 6
      end
      object edLUDF8: TEdit
        Left = 128
        Top = 184
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 7
      end
      object edLUDF9: TEdit
        Left = 128
        Top = 208
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 8
      end
      object edLUDF10: TEdit
        Left = 128
        Top = 232
        Width = 257
        Height = 22
        MaxLength = 30
        TabOrder = 9
      end
    end
    object tsNotes: TTabSheet
      Caption = 'Notes'
      ImageIndex = 2
      object Bevel9: TBevel
        Left = 416
        Top = 8
        Width = 98
        Height = 297
      end
      object mlNotes: TMultiList
        Left = 8
        Top = 8
        Width = 401
        Height = 297
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Date'
            Field = '0'
            Visible = False
            Width = 80
          end
          item
            Caption = 'Description'
            Field = '3'
            Width = 366
          end>
        TabStop = True
        OnChangeSelection = mlLinesChangeSelection
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
      end
      object btnNShow: TButton
        Left = 425
        Top = 16
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Show Dated'
        TabOrder = 1
        OnClick = btnNShowClick
      end
      object btnNAdd: TButton
        Left = 425
        Top = 40
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Add'
        TabOrder = 2
        OnClick = btnNAddClick
      end
    end
  end
  object edTransaction: TEdit
    Left = 88
    Top = 56
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 9
    TabOrder = 1
  end
  object btnLoad: TButton
    Left = 208
    Top = 55
    Width = 75
    Height = 24
    Caption = '&Load'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object mlLines: TMultiList
    Left = 16
    Top = 112
    Width = 513
    Height = 145
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Stock Code'
        Field = '0'
        Width = 129
      end
      item
        Caption = 'Description'
        Field = '1'
        Width = 158
      end
      item
        Alignment = taRightJustify
        Caption = 'Quantity'
        Field = '2'
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'Line Total'
        Field = '3'
        Width = 90
      end>
    TabStop = True
    OnChangeSelection = mlLinesChangeSelection
    TabOrder = 3
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
  object MainMenu1: TMainMenu
    Left = 544
    Top = 64
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Utilities1: TMenuItem
      Caption = 'Utilities'
      Visible = False
      object Import1: TMenuItem
        Caption = 'Import Discounts'
      end
      object Update1: TMenuItem
        Caption = 'Update Discounts'
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
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 544
    Top = 32
  end
end
