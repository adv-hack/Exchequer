object frmShellTest: TfrmShellTest
  Left = 286
  Top = 157
  Width = 242
  Height = 129
  Caption = 'WRTransmit Shell Test'
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
  object lblFileName: TLabel
    Left = 24
    Top = 40
    Width = 47
    Height = 13
    Caption = 'File Name'
  end
  object bnExecute: TButton
    Left = 80
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Shell Execute'
    TabOrder = 1
    OnClick = bnExecuteClick
  end
  object edFilename: TEdit
    Left = 16
    Top = 16
    Width = 201
    Height = 21
    TabOrder = 0
  end
end
