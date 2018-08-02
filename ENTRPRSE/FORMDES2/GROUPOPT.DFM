object Form_GroupOptions: TForm_GroupOptions
  Left = 272
  Top = 105
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Group Options'
  ClientHeight = 358
  ClientWidth = 337
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Button_Save: TButton
    Left = 250
    Top = 25
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 251
    Top = 59
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = Button_CancelClick
  end
  object SBSPanel3: TSBSPanel
    Left = 6
    Top = 314
    Width = 258
    Height = 36
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    object Label_If: Label8
      Left = 6
      Top = 6
      Width = 99
      Height = 25
      AutoSize = False
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object Button_If: TButton
    Left = 135
    Top = 320
    Width = 75
    Height = 25
    Caption = '&If'
    TabOrder = 1
    OnClick = Button_IfClick
  end
  object SBSPanel1: TSBSPanel
    Left = 7
    Top = 6
    Width = 211
    Height = 304
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = False
  end
  object ListView1: TListView
    Left = 15
    Top = 15
    Width = 58
    Height = 286
    Columns = <
      item
      end>
    ReadOnly = False
    TabOrder = 5
    ViewStyle = vsList
  end
end
