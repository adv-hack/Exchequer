inherited RepInpMsgM: TRepInpMsgM
  Left = 449
  Top = 253
  HelpContext = 671
  Caption = 'Kitting Report'
  ClientHeight = 156
  ClientWidth = 326
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 4
    Width = 317
    Height = 121
  end
  object Label81: Label8 [1]
    Left = 29
    Top = 27
    Width = 112
    Height = 14
    Alignment = taRightJustify
    Caption = 'For B.O.M Stock Code :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [2]
    Left = 19
    Top = 51
    Width = 123
    Height = 14
    Alignment = taRightJustify
    Caption = 'Qty Required (of above) :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 21
    Top = 76
    Width = 120
    Height = 14
    Alignment = taRightJustify
    Caption = 'or - for Sales Order No. :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object AccLab: Label8 [4]
    Left = 72
    Top = 99
    Width = 72
    Height = 14
    Alignment = taRightJustify
    Caption = 'Supplier filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 83
    Top = 129
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Left = 169
    Top = 129
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    Left = 248
    TabOrder = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 146
    Top = 21
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 697
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object AgeInt: TCurrencyEdit
    Left = 146
    Top = 46
    Width = 62
    Height = 22
    Hint = 
      'Enter Run Noumber.|Enter the run number of the posting report yo' +
      'u wish to reprint. 0 for unposted items, -1 for all posting runs' +
      '.'
    HelpContext = 695
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    OnEnter = AgeIntEnter
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object SorF: Text8Pt
    Tag = 1
    Left = 146
    Top = 71
    Width = 99
    Height = 22
    HelpContext = 696
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnEnter = SorFEnter
    OnExit = SorFExit
    TextId = 0
    ViaSBtn = False
  end
  object UseFreeF: TBorCheckEx
    Left = 11
    Top = 98
    Width = 151
    Height = 20
    Caption = 'Use Free Stock Levels : '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object ACCF: Text8Pt
    Tag = 1
    Left = 146
    Top = 96
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Visible = False
    OnExit = ACCFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
end
