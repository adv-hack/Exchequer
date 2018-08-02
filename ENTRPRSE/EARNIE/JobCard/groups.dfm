object frmGroupList: TfrmGroupList
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Payroll Account Groups'
  ClientHeight = 269
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbGroups: TListBox
    Left = 8
    Top = 16
    Width = 193
    Height = 241
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
  object SBSButton1: TSBSButton
    Left = 208
    Top = 104
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 1
    OnClick = SBSButton1Click
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 208
    Top = 136
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 2
    OnClick = SBSButton2Click
    TextId = 0
  end
  object SBSButton3: TSBSButton
    Left = 208
    Top = 168
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = SBSButton3Click
    TextId = 0
  end
  object SBSButton4: TSBSButton
    Left = 208
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 4
    TextId = 0
  end
  object SBSButton5: TSBSButton
    Left = 208
    Top = 40
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
    TextId = 0
  end
end
