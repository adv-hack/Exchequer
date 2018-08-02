object frmEditFonts: TfrmEditFonts
  Left = 337
  Top = 186
  BorderStyle = bsToolWindow
  Caption = 'Edit Fonts'
  ClientHeight = 359
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  DesignSize = (
    488
    359)
  PixelsPerInch = 96
  TextHeight = 14
  object Shape3: TShape
    Left = 7
    Top = 152
    Width = 474
    Height = 38
  end
  object Shape4: TShape
    Left = 7
    Top = 216
    Width = 474
    Height = 38
  end
  object Shape2: TShape
    Left = 7
    Top = 88
    Width = 474
    Height = 38
  end
  object Shape1: TShape
    Left = 8
    Top = 24
    Width = 473
    Height = 38
  end
  object Label10: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 14
    Caption = 'List Main :'
    Transparent = True
  end
  object Label12: TLabel
    Left = 8
    Top = 72
    Width = 61
    Height = 14
    Caption = 'List Header :'
    Transparent = True
  end
  object Label13: TLabel
    Left = 8
    Top = 136
    Width = 66
    Height = 14
    Caption = 'List Highlight :'
    Transparent = True
  end
  object lMultiSelect: TLabel
    Left = 8
    Top = 200
    Width = 81
    Height = 14
    Caption = 'List Multi-Select :'
    Transparent = True
  end
  object lLHFont: TLabel
    Left = 16
    Top = 164
    Width = 41
    Height = 14
    Caption = 'lLHFont'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lLHSize: TLabel
    Left = 168
    Top = 164
    Width = 40
    Height = 14
    Caption = 'lLHSize'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lLMSFont: TLabel
    Left = 16
    Top = 228
    Width = 51
    Height = 14
    Caption = 'lLMSFont'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lLMSSize: TLabel
    Left = 168
    Top = 228
    Width = 50
    Height = 14
    Caption = 'lLMSSize'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 168
    Top = 8
    Width = 21
    Height = 14
    Caption = 'Size'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 232
    Top = 8
    Width = 24
    Height = 14
    Caption = 'Style'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 312
    Top = 8
    Width = 31
    Height = 14
    Caption = 'Colour'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object cmbListMainFont: TComboBox
    Left = 16
    Top = 32
    Width = 145
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbListMainFontChange
  end
  object cmbListMainSize: TComboBox
    Left = 168
    Top = 32
    Width = 57
    Height = 22
    ItemHeight = 14
    TabOrder = 1
    OnChange = cmbListMainSizeChange
  end
  object cmbListMainStyle: TComboBox
    Left = 232
    Top = 32
    Width = 73
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 2
    Text = 'Regular'
    OnChange = cmbListMainStyleChange
    Items.Strings = (
      'Regular'
      'Italic'
      'Bold'
      'Bold Italic')
  end
  object colListMain: TColorBox
    Left = 312
    Top = 32
    Width = 161
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 3
    OnChange = colListMainChange
  end
  object ColListHeader: TColorBox
    Left = 312
    Top = 96
    Width = 161
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 7
    OnChange = ColListHeaderChange
  end
  object ColListHighlight: TColorBox
    Left = 312
    Top = 160
    Width = 161
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
    OnChange = ColListHighlightChange
  end
  object colMultiSelect: TColorBox
    Left = 312
    Top = 224
    Width = 161
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 11
    OnChange = colMultiSelectChange
  end
  object btnClose: TButton
    Left = 400
    Top = 330
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Close'
    TabOrder = 13
    OnClick = btnCloseClick
  end
  object cmbListHeaderStyle: TComboBox
    Left = 232
    Top = 96
    Width = 73
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 6
    Text = 'Regular'
    OnChange = cmbListHeaderStyleChange
    Items.Strings = (
      'Regular'
      'Italic'
      'Bold'
      'Bold Italic')
  end
  object cmbListHighlightStyle: TComboBox
    Left = 232
    Top = 160
    Width = 73
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 8
    Text = 'Regular'
    OnChange = cmbListHighlightStyleChange
    Items.Strings = (
      'Regular'
      'Italic'
      'Bold'
      'Bold Italic')
  end
  object cmbListMultiSelectStyle: TComboBox
    Left = 232
    Top = 224
    Width = 73
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 10
    Text = 'Regular'
    OnChange = cmbListMultiSelectStyleChange
    Items.Strings = (
      'Regular'
      'Italic'
      'Bold'
      'Bold Italic')
  end
  object cmbListHeaderFont: TComboBox
    Left = 16
    Top = 96
    Width = 145
    Height = 22
    ItemHeight = 14
    TabOrder = 4
    OnChange = cmbListHeaderFontChange
  end
  object cmbListHeaderSize: TComboBox
    Left = 168
    Top = 96
    Width = 57
    Height = 22
    ItemHeight = 14
    TabOrder = 5
    OnChange = cmbListHeaderSizeChange
  end
  object panFields: TPanel
    Left = 7
    Top = 264
    Width = 481
    Height = 57
    BevelOuter = bvNone
    TabOrder = 12
    object Shape5: TShape
      Left = 0
      Top = 16
      Width = 474
      Height = 38
    end
    object Label11: TLabel
      Left = 0
      Top = 0
      Width = 34
      Height = 14
      Caption = 'Fields :'
      Transparent = True
    end
    object colFields: TColorBox
      Left = 305
      Top = 24
      Width = 161
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 3
      OnChange = colFieldsChange
    end
    object cmbFieldsStyle: TComboBox
      Left = 225
      Top = 24
      Width = 73
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 2
      Text = 'Regular'
      OnChange = cmbFieldsStyleChange
      Items.Strings = (
        'Regular'
        'Italic'
        'Bold'
        'Bold Italic')
    end
    object cmbFieldsFont: TComboBox
      Left = 9
      Top = 24
      Width = 145
      Height = 22
      ItemHeight = 14
      TabOrder = 0
      OnChange = cmbFieldsFontChange
    end
    object cmbFieldsSize: TComboBox
      Left = 161
      Top = 24
      Width = 57
      Height = 22
      ItemHeight = 14
      TabOrder = 1
      OnChange = cmbFieldsSizeChange
    end
  end
end
