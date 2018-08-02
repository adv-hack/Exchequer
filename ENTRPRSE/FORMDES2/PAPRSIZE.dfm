object Form_PaperSizes: TForm_PaperSizes
  Left = 458
  Top = 217
  HelpContext = 5000
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Paper Sizes'
  ClientHeight = 256
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object List_Sizes: TListBox
    Left = 5
    Top = 5
    Width = 263
    Height = 245
    Ctl3D = True
    ItemHeight = 14
    ParentCtl3D = False
    TabOrder = 0
    OnDblClick = List_SizesDblClick
  end
  object Button_Select: TButton
    Left = 275
    Top = 7
    Width = 80
    Height = 21
    Caption = '&Select'
    TabOrder = 1
    OnClick = Button_SelectClick
  end
  object Button_Close: TButton
    Left = 275
    Top = 34
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 2
    OnClick = Button_CloseClick
  end
  object Button_Add: TButton
    Left = 275
    Top = 64
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 3
    OnClick = Button_AddClick
  end
  object Button_Edit: TButton
    Left = 275
    Top = 93
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 4
    OnClick = Button_EditClick
  end
  object Button_Delete: TButton
    Left = 275
    Top = 122
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 5
    OnClick = Button_DeleteClick
  end
end
