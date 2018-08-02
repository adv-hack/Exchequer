object frmSelectPPDRagColours: TfrmSelectPPDRagColours
  Left = 549
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Set PPD Colours'
  ClientHeight = 199
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 92
    Height = 14
    Caption = 'Background Colour'
  end
  object Label2: TLabel
    Left = 45
    Top = 35
    Width = 55
    Height = 14
    Caption = 'Font Colour'
  end
  object Label3: TLabel
    Left = 41
    Top = 61
    Width = 59
    Height = 14
    Caption = 'Font Effects'
  end
  object Label4: TLabel
    Left = 65
    Top = 142
    Width = 35
    Height = 14
    Caption = 'Sample'
  end
  object btnOK: TButton
    Left = 38
    Top = 170
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 128
    Top = 170
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edtExampleText: TEdit
    Left = 105
    Top = 139
    Width = 129
    Height = 22
    TabStop = False
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 2
    Text = 'Expired'
  end
  object AdvTextColorSelector1: TAdvTextColorSelector
    Left = 105
    Top = 32
    Width = 129
    Height = 22
    TabOrder = 3
    TabStop = True
    AppearanceStyle = esWhidbey
    Version = '1.3.4.0'
    AutoThemeAdapt = False
    BorderColor = 9841920
    BorderDownColor = 7021576
    BorderHotColor = clBlack
    Color = 15462127
    ColorTo = 8296600
    ColorDown = 557032
    ColorDownTo = 8182519
    ColorHot = 14483455
    ColorHotTo = 6013175
    ColorDropDown = 16251129
    ColorSelected = 9758459
    ColorSelectedTo = 1414638
    SelectedColor = clNone
    Style = ssCombo
    Tools = <
      item
        BackGroundColor = clNavy
        Caption = 'Automatic'
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Color'
        ItemType = itFullWidthButton
      end
      item
        BackGroundColor = clBlack
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Black'
      end
      item
        BackGroundColor = clGray
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Gray'
      end
      item
        BackGroundColor = clMaroon
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Maroon'
      end
      item
        BackGroundColor = clOlive
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Olive'
      end
      item
        BackGroundColor = clGreen
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Green'
      end
      item
        BackGroundColor = clTeal
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Teal'
      end
      item
        BackGroundColor = clNavy
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Navy'
      end
      item
        BackGroundColor = clPurple
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Purple'
      end
      item
        BackGroundColor = clWhite
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'White'
      end
      item
        BackGroundColor = clSilver
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Silver'
      end
      item
        BackGroundColor = clRed
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Red'
      end
      item
        BackGroundColor = clYellow
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Yellow'
      end
      item
        BackGroundColor = clLime
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Lime'
      end
      item
        BackGroundColor = clAqua
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Aqua'
      end
      item
        BackGroundColor = clBlue
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Blue'
      end
      item
        BackGroundColor = clFuchsia
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Fuchsia'
      end>
    OnClick = AdvTextColorSelector1Click
    OnSelect = AdvTextColorSelector1Select
  end
  object AdvColorSelector1: TAdvColorSelector
    Left = 105
    Top = 7
    Width = 129
    Height = 22
    TabOrder = 4
    TabStop = True
    AppearanceStyle = esWhidbey
    Version = '1.3.4.0'
    SelectedColor = clNone
    ShowRGBHint = True
    AutoThemeAdapt = False
    BorderColor = 9841920
    BorderDownColor = 7021576
    BorderHotColor = clBlack
    Color = 15462127
    ColorTo = 8296600
    ColorDown = 557032
    ColorDownTo = 8182519
    ColorHot = 14483455
    ColorHotTo = 6013175
    ColorDropDown = 16251129
    ColorSelected = 9758459
    ColorSelectedTo = 1414638
    Style = ssCombo
    Tools = <
      item
        BackGroundColor = clWhite
        Caption = 'Automatic'
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'Automatic'
        ItemType = itFullWidthButton
      end
      item
        BackGroundColor = clBlack
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13209
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13107
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13056
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 6697728
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clNavy
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 3486515
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 3355443
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clMaroon
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 26367
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clOlive
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clGreen
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clTeal
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clBlue
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 10053222
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clGray
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clRed
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 39423
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 52377
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 6723891
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13421619
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 16737843
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clPurple
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 10066329
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clFuchsia
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 52479
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clYellow
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clLime
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clAqua
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 16763904
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 6697881
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clSilver
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13408767
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 10079487
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 10092543
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 13434828
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 16777164
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 16764057
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = 16751052
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        BackGroundColor = clWhite
        CaptionAlignment = taCenter
        ImageIndex = -1
      end
      item
        Caption = 'More Colors...'
        CaptionAlignment = taCenter
        ImageIndex = -1
        Hint = 'More Color'
        ItemType = itFullWidthButton
      end>
    OnClick = AdvColorSelector1Click
    OnSelect = AdvColorSelector1Select
  end
  object chkFontBold: TCheckBox
    Left = 105
    Top = 60
    Width = 45
    Height = 17
    Caption = 'Bold'
    TabOrder = 5
    OnClick = chkFontBoldClick
  end
  object chkFontItalic: TCheckBox
    Left = 105
    Top = 78
    Width = 45
    Height = 17
    Caption = 'Italic'
    TabOrder = 6
    OnClick = chkFontItalicClick
  end
  object chkFontUnderline: TCheckBox
    Left = 105
    Top = 96
    Width = 68
    Height = 17
    Caption = 'Underline'
    TabOrder = 7
    OnClick = chkFontUnderlineClick
  end
  object chkFontStrikeOut: TCheckBox
    Left = 105
    Top = 114
    Width = 65
    Height = 17
    Caption = 'Strikeout'
    TabOrder = 8
    OnClick = chkFontStrikeOutClick
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen, cdAnyColor]
    Left = 191
    Top = 70
  end
end
