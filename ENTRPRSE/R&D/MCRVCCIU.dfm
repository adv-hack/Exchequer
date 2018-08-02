object MCRVCCDep: TMCRVCCDep
  Left = 422
  Top = 240
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Revaluation Defaults'
  ClientHeight = 191
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 500
    Height = 147
    TextId = 0
  end
  object Label83: Label8
    Left = 13
    Top = 15
    Width = 489
    Height = 47
    AutoSize = False
    Caption = 
      'During the revaluation process a currency movement journal is ge' +
      'nerated which requires a default Cost Centre and Department code' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label81: Label8
    Left = 22
    Top = 73
    Width = 66
    Height = 14
    Caption = 'Cost Centre : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 164
    Top = 74
    Width = 61
    Height = 14
    Caption = 'Department :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 167
    Top = 162
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 257
    Top = 162
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 90
    Top = 70
    Width = 64
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 234
    Top = 70
    Width = 64
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object RestRVAChk: TCheckBox
    Left = 19
    Top = 105
    Width = 482
    Height = 27
    Caption = 
      'Restore transaction currency value using the transaction'#39's origi' +
      'nal exchange rate '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
  end
end
