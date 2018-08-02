inherited StkTRI: TStkTRI
  ActiveControl = MaxRecs
  Caption = 'Tree Record Limit'
  ClientHeight = 177
  FormStyle = fsNormal
  Position = poScreenCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 141
  end
  object Label81: Label8 [1]
    Left = 20
    Top = 16
    Width = 271
    Height = 63
    AutoSize = False
    Caption = 
      'Exchequer has detected more than 500 records. To reduce the time' +
      ' taken to display the Tree, it is possible to limit how many rec' +
      'ords Exchequer attempts to load in one go per branch of the tree' +
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
  object Label82: Label8 [2]
    Left = 20
    Top = 90
    Width = 113
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Allow Tree up to  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [3]
    Left = 203
    Top = 92
    Width = 25
    Height = 14
    Caption = 'recs.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 109
    Top = 151
    TabOrder = 1
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 2
    Visible = False
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 3
  end
  object MaxRecs: TCurrencyEdit
    Left = 135
    Top = 88
    Width = 61
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '500 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 500
  end
end
