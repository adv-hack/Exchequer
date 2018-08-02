object frmCheckSNo: TfrmCheckSNo
  Left = 191
  Top = 181
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Check Drive Serial Number'
  ClientHeight = 181
  ClientWidth = 290
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object DriveComboBox1: TDriveComboBox
    Left = 13
    Top = 11
    Width = 145
    Height = 19
    TabOrder = 0
  end
  object btnCheck: TButton
    Left = 173
    Top = 7
    Width = 75
    Height = 25
    Caption = '&Check'
    TabOrder = 1
    OnClick = btnCheckClick
  end
  object ListBox1: TListBox
    Left = 21
    Top = 44
    Width = 256
    Height = 126
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
  end
end
