object Form3: TForm3
  Left = 204
  Top = 154
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Directory Checking Tests'
  ClientHeight = 51
  ClientWidth = 418
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 3
    Top = 2
    Width = 411
    Height = 46
    Caption = ' Check Directory Rights '
    TabOrder = 0
    object ComboBox1: TComboBox
      Left = 8
      Top = 16
      Width = 313
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\enterp~1\'
        's:\temp\mark\entbtr7\')
      TabOrder = 0
      Text = 'ComboBox1'
    end
    object Button1: TButton
      Left = 328
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Check'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
