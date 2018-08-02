object FrmProcessFunction: TFrmProcessFunction
  Left = 400
  Top = 283
  BorderStyle = bsDialog
  Caption = 'Process Functions'
  ClientHeight = 135
  ClientWidth = 216
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 48
    Width = 201
    Height = 49
    Shape = bsFrame
  end
  object lText: TLabel
    Left = 8
    Top = 8
    Width = 200
    Height = 28
    Caption = 'Please pick the category of function you wish to process'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 16
    Top = 66
    Width = 47
    Height = 14
    Caption = 'Function :'
  end
  object btnCancel: TButton
    Left = 144
    Top = 104
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnDoIt: TButton
    Left = 72
    Top = 104
    Width = 65
    Height = 25
    Caption = '&Process'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnDoItClick
  end
  object cbCategory: TComboBox
    Left = 72
    Top = 62
    Width = 129
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
  end
end
