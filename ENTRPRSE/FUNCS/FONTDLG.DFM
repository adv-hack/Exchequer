object frmFontDlg: TfrmFontDlg
  Left = 338
  Top = 228
  BorderStyle = bsDialog
  Caption = 'Font'
  ClientHeight = 288
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 168
    Width = 145
    Height = 113
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 160
    Width = 35
    Height = 14
    Caption = 'Effects'
  end
  object Label2: TLabel
    Left = 16
    Top = 232
    Width = 34
    Height = 14
    Caption = 'Colour:'
  end
  object Bevel2: TBevel
    Left = 160
    Top = 168
    Width = 177
    Height = 113
    Shape = bsFrame
  end
  object Label3: TLabel
    Left = 168
    Top = 160
    Width = 35
    Height = 14
    Caption = 'Sample'
  end
  object lName: TLabel
    Left = 8
    Top = 8
    Width = 24
    Height = 14
    Caption = 'Font:'
  end
  object lStyle: TLabel
    Left = 160
    Top = 8
    Width = 51
    Height = 14
    Caption = 'Font Style:'
  end
  object lSize: TLabel
    Left = 280
    Top = 8
    Width = 24
    Height = 14
    Caption = 'Size:'
  end
  object lstFont: TListBox
    Left = 8
    Top = 48
    Width = 145
    Height = 97
    ItemHeight = 14
    TabOrder = 1
    OnClick = lstFontClick
  end
  object lstStyle: TListBox
    Left = 160
    Top = 48
    Width = 113
    Height = 97
    ItemHeight = 14
    Items.Strings = (
      'Regular'
      'Italic'
      'Bold'
      'Bold Italic')
    TabOrder = 3
    OnClick = lstStyleClick
  end
  object lstSize: TListBox
    Left = 280
    Top = 48
    Width = 57
    Height = 97
    ItemHeight = 14
    TabOrder = 5
    OnClick = lstSizeClick
  end
  object edFont: TEdit
    Left = 8
    Top = 24
    Width = 145
    Height = 22
    TabOrder = 0
    OnChange = edFontChange
  end
  object edStyle: TEdit
    Left = 160
    Top = 24
    Width = 113
    Height = 22
    TabOrder = 2
    OnChange = edStyleChange
  end
  object edSize: TEdit
    Left = 280
    Top = 24
    Width = 57
    Height = 22
    TabOrder = 4
    OnChange = edSizeChange
  end
  object btnOK: TButton
    Left = 344
    Top = 24
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 10
  end
  object btnCancel: TButton
    Left = 344
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object cbStrikeout: TCheckBox
    Left = 16
    Top = 184
    Width = 97
    Height = 17
    Caption = 'Strikeout'
    TabOrder = 6
    OnClick = cbStrikeoutClick
  end
  object cbUnderLine: TCheckBox
    Left = 16
    Top = 208
    Width = 97
    Height = 17
    Caption = 'Underline'
    TabOrder = 7
    OnClick = cbUnderLineClick
  end
  object colFont: TColorBox
    Left = 16
    Top = 248
    Width = 129
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 8
    OnChange = colFontChange
  end
  object panSample: TPanel
    Left = 176
    Top = 184
    Width = 145
    Height = 81
    BevelOuter = bvLowered
    Caption = 'AaBbYyZz'
    TabOrder = 9
  end
end
