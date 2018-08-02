object RunDialog: TRunDialog
  Left = 403
  Top = 201
  ActiveControl = rnCommand
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'RunDialog'
  ClientHeight = 98
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label82: Label8
    Left = 8
    Top = 6
    Width = 414
    Height = 31
    AutoSize = False
    Caption = 
      'Please make any necessary changes to the command line below, and' +
      ' then click the run button.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object rnCommand: Text8Pt
    Left = 13
    Top = 42
    Width = 406
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object OKBtn: TButton
    Left = 133
    Top = 72
    Width = 80
    Height = 21
    Caption = '&Run'
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 219
    Top = 72
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
end
