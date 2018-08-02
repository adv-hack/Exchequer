object Form_DlgTest: TForm_DlgTest
  Left = 176
  Top = 167
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dialog Test'
  ClientHeight = 167
  ClientWidth = 369
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 147
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
end
