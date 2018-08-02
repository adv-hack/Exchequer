object Form_SelectField: TForm_SelectField
  Left = 24
  Top = 111
  HelpContext = 1200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Field'
  ClientHeight = 310
  ClientWidth = 506
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup
    Left = 6
    Top = 3
    Width = 401
    Height = 41
    TextId = 0
  end
  object Label81: Label8
    Left = 11
    Top = 20
    Width = 24
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'File'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Select: TButton
    Left = 417
    Top = 9
    Width = 80
    Height = 21
    Caption = '&Select'
    Default = True
    TabOrder = 2
    OnClick = Button_SelectClick
  end
  object Button_Cancel: TButton
    Left = 417
    Top = 38
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = Button_CancelClick
  end
  object Combo_File: TSBSComboBox
    Left = 40
    Top = 16
    Width = 358
    Height = 22
    Style = csDropDownList
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnClick = Combo_FileClick
    MaxListWidth = 0
  end
  object List_Fields: TListBox
    Left = 7
    Top = 50
    Width = 399
    Height = 254
    Ctl3D = True
    ItemHeight = 13
    ParentCtl3D = False
    Sorted = True
    TabOrder = 1
    TabWidth = 60
    OnClick = List_FieldsClick
    OnDblClick = Button_SelectClick
  end
end
