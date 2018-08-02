inherited BaseLabelDialog1: TBaseLabelDialog1
  Left = 383
  Top = 139
  Caption = 'Preview Label Setup'
  ClientHeight = 314
  ClientWidth = 348
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup [0]
    Left = 5
    Top = 3
    Width = 249
    Height = 260
    Caption = 'Select the first label to print: '
    TextId = 0
  end
  inherited Image_Labels: TImage
    Top = 19
    Width = 240
    Height = 240
  end
  object btnOK: TButton
    Left = 262
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 262
    Top = 34
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object SBSGroup1: TSBSGroup
    Left = 4
    Top = 266
    Width = 249
    Height = 43
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label81: Label8
      Left = 7
      Top = 14
      Width = 96
      Height = 14
      Caption = 'No. of labels to print'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object ccyNoLbl: TCurrencyEdit
    Left = 112
    Top = 277
    Width = 37
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
end
