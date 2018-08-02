object ESecFrm: TESecFrm
  Left = 386
  Top = 141
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Exchequer'
  ClientHeight = 214
  ClientWidth = 357
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UserLab: Label8
    Left = 12
    Top = 15
    Width = 335
    Height = 28
    Alignment = taCenter
    AutoSize = False
    Caption = 'Please Wait...'
    Color = clNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    TextId = 0
  end
  object VerF: Label8
    Left = 203
    Top = 195
    Width = 148
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
    Transparent = True
    TextId = 0
  end
  object SecLab: Label8
    Left = 12
    Top = 43
    Width = 335
    Height = 99
    Alignment = taCenter
    AutoSize = False
    Color = clNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    WordWrap = True
    TextId = 0
  end
  object OKBtn: TButton
    Left = 139
    Top = 175
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    Visible = False
  end
end
