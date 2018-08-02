object TestPrnMsg: TTestPrnMsg
  Left = 225
  Top = 157
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 131
  ClientWidth = 337
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TestCP1Btn: TButton
    Tag = 1
    Left = 125
    Top = 99
    Width = 80
    Height = 22
    Caption = '&Test'
    ModalResult = 6
    TabOrder = 1
  end
  object SBSPanel3: TSBSPanel
    Left = 5
    Top = 2
    Width = 326
    Height = 86
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    object Label1: Label8
      Left = 8
      Top = 4
      Width = 308
      Height = 53
      Alignment = taCenter
      AutoSize = False
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: Label8
      Left = 8
      Top = 60
      Width = 308
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 209
    Top = 99
    Width = 80
    Height = 22
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OKCp1Btn: TButton
    Tag = 1
    Left = 41
    Top = 99
    Width = 80
    Height = 22
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
