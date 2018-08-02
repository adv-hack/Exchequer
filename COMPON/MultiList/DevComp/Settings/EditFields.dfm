object frmEditFields: TfrmEditFields
  Left = 328
  Top = 204
  BorderStyle = bsToolWindow
  Caption = 'Fields Properties'
  ClientHeight = 167
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 7
    Top = 88
    Width = 474
    Height = 41
  end
  object Shape5: TShape
    Left = 7
    Top = 24
    Width = 474
    Height = 41
  end
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 14
    Caption = 'Field Font :'
    Transparent = True
  end
  object Label9: TLabel
    Left = 8
    Top = 72
    Width = 89
    Height = 14
    Caption = 'Field Background :'
    Transparent = True
  end
  object colFieldsFont: TColorBox
    Left = 312
    Top = 32
    Width = 161
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 3
    OnChange = colFieldsFontChange
  end
  object btnClose: TButton
    Left = 400
    Top = 138
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object cmbFieldsStyle: TComboBox
    Left = 232
    Top = 32
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
    Left = 16
    Top = 32
    Width = 145
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    OnChange = cmbFieldsFontChange
  end
  object cmbFieldsSize: TComboBox
    Left = 168
    Top = 32
    Width = 57
    Height = 22
    ItemHeight = 14
    TabOrder = 1
    OnChange = cmbFieldsSizeChange
  end
  object colFieldsBack: TColorBox
    Left = 16
    Top = 96
    Width = 193
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 4
    OnChange = colFieldsBackChange
  end
end
