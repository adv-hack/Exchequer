object FrmEditSettings: TFrmEditSettings
  Left = 256
  Top = 68
  BorderStyle = bsDialog
  Caption = 'Edit Settings'
  ClientHeight = 296
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    353
    296)
  PixelsPerInch = 96
  TextHeight = 14
  object bvBevel: TBevel
    Left = 8
    Top = 16
    Width = 337
    Height = 241
    Anchors = [akLeft, akTop, akBottom]
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 46
    Height = 14
    Caption = 'Example'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCode: TLabel
    Left = 193
    Top = 36
    Width = 25
    Height = 14
    Alignment = taRightJustify
    Caption = 'Code'
  end
  object Label2: TLabel
    Left = 196
    Top = 68
    Width = 22
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date'
  end
  object btnEditFields: TButton
    Left = 8
    Top = 266
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Edit &Fields'
    TabOrder = 0
    Visible = False
    OnClick = EditFieldProperties1Click
  end
  object mlExample: TMultiList
    Left = 16
    Top = 96
    Width = 321
    Height = 153
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Options.MultiSelection = True
    Options.MultiSelectIntegrity = True
    Columns = <
      item
        Caption = 'Code'
        Field = 'C'
        Searchable = True
        Sortable = True
        Width = 50
      end
      item
        Caption = 'Description'
        Field = 'D'
        Searchable = True
        Sortable = True
        Width = 113
      end
      item
        Alignment = taRightJustify
        Caption = 'Quanitity'
        Field = 'Q'
        Width = 52
      end
      item
        Alignment = taRightJustify
        Caption = 'Value'
        Field = 'V'
        Width = 60
      end>
    TabStop = True
    OnChangeSelection = mlExampleChangeSelection
    OnRefreshList = mlExampleRefreshList
    PopupMenu = pmList
    TabOrder = 8
    Anchors = [akLeft, akBottom]
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'MS Sans Serif'
    HeaderFont.Style = []
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clWindowText
    HighlightFont.Height = -11
    HighlightFont.Name = 'Arial'
    HighlightFont.Style = []
    MultiSelectFont.Charset = DEFAULT_CHARSET
    MultiSelectFont.Color = clWindowText
    MultiSelectFont.Height = -11
    MultiSelectFont.Name = 'Arial'
    MultiSelectFont.Style = []
  end
  object edCode: TEdit
    Left = 224
    Top = 32
    Width = 113
    Height = 22
    PopupMenu = pmEditFields
    TabOrder = 6
    Text = 'ACC01'
    OnDblClick = EditFieldProperties1Click
  end
  object edDate: TEdit
    Left = 224
    Top = 64
    Width = 113
    Height = 22
    PopupMenu = pmEditFields
    TabOrder = 7
    Text = '23/07/2000'
    OnDblClick = EditFieldProperties1Click
  end
  object btnCancel: TButton
    Left = 265
    Top = 266
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'C&ancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 179
    Top = 266
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
  end
  object btnEditColours: TButton
    Left = 8
    Top = 266
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Edit &Colours'
    TabOrder = 1
    OnClick = btnEditColoursClick
  end
  object btnEditFonts: TButton
    Left = 93
    Top = 266
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Edit &Fonts'
    TabOrder = 2
    OnClick = btnEditFontsClick
  end
  object memName: TMemo
    Left = 16
    Top = 32
    Width = 161
    Height = 57
    Lines.Strings = (
      'John Smith'
      '35 Fortland Road'
      'Bournemouth'
      'Dorset')
    PopupMenu = pmEditFields
    TabOrder = 5
    OnDblClick = EditFieldProperties1Click
  end
  object pmEditFields: TPopupMenu
    Left = 24
    Top = 40
    object EditFieldProperties1: TMenuItem
      Caption = 'Edit Field Properties'
      OnClick = EditFieldProperties1Click
    end
  end
  object pmList: TPopupMenu
    OnPopup = pmListPopup
    Left = 24
    Top = 120
    object EditHeaderFont1: TMenuItem
      Caption = 'Edit Header Font'
      OnClick = EditHeaderFont1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object EditMainFont1: TMenuItem
      Caption = 'Edit Main Font'
      OnClick = EditMainFont1Click
    end
    object EditMainBackgroundColour1: TMenuItem
      Caption = 'Edit Main Background Colour'
      OnClick = EditMainBackgroundColour1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object EditHighlightFont1: TMenuItem
      Caption = 'Edit Highlight Font'
      OnClick = EditHighlightFont1Click
    end
    object EditHighlightColor1: TMenuItem
      Caption = 'Edit Highlight Colour'
      OnClick = EditHighlightColor1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object EditMultiSelectFont1: TMenuItem
      Caption = 'Edit Multi-Select Font'
      OnClick = EditMultiSelectFont1Click
    end
    object EditMultiSelectColour1: TMenuItem
      Caption = 'Edit Multi-Select Colour'
      OnClick = EditMultiSelectColour1Click
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 56
    Top = 120
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 88
    Top = 120
  end
end
