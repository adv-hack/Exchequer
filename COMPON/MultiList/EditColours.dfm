object frmEditColours: TfrmEditColours
  Left = 225
  Top = 156
  BorderStyle = bsToolWindow
  Caption = 'Edit Colours'
  ClientHeight = 264
  ClientWidth = 224
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
    224
    264)
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 7
    Top = 24
    Width = 210
    Height = 201
    Anchors = [akLeft, akTop, akBottom]
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 14
    Caption = 'Colours'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 16
    Top = 32
    Width = 84
    Height = 14
    Caption = 'List Background :'
    Transparent = True
  end
  object Label7: TLabel
    Left = 16
    Top = 80
    Width = 66
    Height = 14
    Caption = 'List Highlight :'
    Transparent = True
  end
  object lMultiSelect: TLabel
    Left = 16
    Top = 128
    Width = 81
    Height = 14
    Caption = 'List Multi-Select :'
    Transparent = True
  end
  object colListBack: TColorBox
    Left = 16
    Top = 48
    Width = 193
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 0
    OnChange = colListBackChange
  end
  object colListHighlight: TColorBox
    Left = 16
    Top = 96
    Width = 193
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 1
    OnChange = colListHighlightChange
  end
  object colMultiSelect: TColorBox
    Left = 16
    Top = 144
    Width = 193
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 2
    OnChange = colMultiSelectChange
  end
  object btnClose: TButton
    Left = 136
    Top = 234
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object panFields: TPanel
    Left = 16
    Top = 176
    Width = 193
    Height = 41
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 3
    object Label9: TLabel
      Left = 0
      Top = 0
      Width = 89
      Height = 14
      Caption = 'Field Background :'
      Transparent = True
    end
    object colFields: TColorBox
      Left = 0
      Top = 16
      Width = 193
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 0
      OnChange = colFieldsChange
    end
  end
end
