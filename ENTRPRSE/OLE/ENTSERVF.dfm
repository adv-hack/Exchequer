object Form_EnterpriseOleServer: TForm_EnterpriseOleServer
  Left = 369
  Top = 195
  HelpContext = 1000
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer OLE Server'
  ClientHeight = 251
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    491
    251)
  PixelsPerInch = 96
  TextHeight = 14
  object Label_Ver: Label8
    Left = 132
    Top = 6
    Width = 352
    Height = 14
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Server Version: x.xx'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Panel_Bitmap: TPanel
    Left = 6
    Top = 23
    Width = 145
    Height = 223
    BevelOuter = bvLowered
    TabOrder = 1
    object Image_About256: TImage
      Left = 1
      Top = 1
      Width = 143
      Height = 221
      Align = alClient
      AutoSize = True
    end
  end
  object List_Info: TListBox
    Left = 157
    Top = 23
    Width = 328
    Height = 223
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 14
    Items.Strings = (
      'Loaded from About Branding File at runtime')
    TabOrder = 0
    TabWidth = 50
  end
end
