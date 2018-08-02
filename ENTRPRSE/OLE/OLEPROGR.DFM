object frmOLEProgress: TfrmOLEProgress
  Left = 216
  Top = 184
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmOLEProgress'
  ClientHeight = 172
  ClientWidth = 308
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup2: TSBSBackGroup
    Left = 5
    Top = 97
    Width = 298
    Height = 70
    TextId = 0
  end
  object lblProg: TLabel
    Left = 12
    Top = 110
    Width = 285
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = 'SORT0001231'
  end
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 298
    Height = 93
    TextId = 0
  end
  object btnAbort: TButton
    Left = 93
    Top = 134
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'Abort Calculation'
    TabOrder = 0
    OnClick = btnAbortClick
  end
  object lstInfo: TListBox
    Left = 10
    Top = 15
    Width = 285
    Height = 77
    BorderStyle = bsNone
    Color = clBtnFace
    ItemHeight = 13
    TabOrder = 1
    TabWidth = 60
  end
end
