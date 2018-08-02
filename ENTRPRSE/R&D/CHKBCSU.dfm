object ChkBCSFrm: TChkBCSFrm
  Left = 505
  Top = 187
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Exchequer Client Server Check'
  ClientHeight = 268
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 6
    Top = 8
    Width = 143
    Height = 219
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Image1: TImage
      Left = 3
      Top = 4
      Width = 136
      Height = 212
    end
  end
  object OkI1Btn: TButton
    Tag = 1
    Left = 170
    Top = 241
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 165
    Top = 8
    Width = 245
    Height = 219
    TabStop = False
    Alignment = taCenter
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      ''
      ' Client Server Check'
      ' '
      'The Client Server version of '
      'Pervasive.SQL has been '
      'detected...'
      ''
      'Reconfigure Pervasive.SQL to  '
      'use the local engine, or upgrade  '
      'this system to a Client Server '
      'version.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
end
