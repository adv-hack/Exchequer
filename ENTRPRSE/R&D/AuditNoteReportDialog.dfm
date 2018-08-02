inherited RepInpMsg2: TRepInpMsg2
  Left = 534
  Top = 270
  Caption = 'Audit Notes Report: Options'
  ClientHeight = 237
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 204
  end
  inherited OkCP1Btn: TButton
    Top = 210
  end
  inherited ClsCP1Btn: TButton
    Top = 210
    OnClick = ClsCP1BtnClick
  end
  object grpFilter: TGroupBox
    Left = 16
    Top = 16
    Width = 265
    Height = 97
    Caption = '  '
    TabOrder = 3
    object Label3: TLabel
      Left = 40
      Top = 64
      Width = 14
      Height = 14
      Caption = 'To:'
    end
    object Label2: TLabel
      Left = 40
      Top = 32
      Width = 27
      Height = 14
      Caption = 'From:'
    end
    object cbDateFilterEnabled: TCheckBox
      Left = 11
      Top = -1
      Width = 114
      Height = 17
      Caption = 'Filter by date range'
      TabOrder = 0
      OnClick = cbDateFilterEnabledClick
    end
    object dpFromDate: TEditDate
      Left = 72
      Top = 32
      Width = 121
      Height = 22
      AutoSelect = False
      Color = clWhite
      Enabled = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Placement = cpAbove
    end
    object dpToDate: TEditDate
      Left = 72
      Top = 64
      Width = 121
      Height = 22
      AutoSelect = False
      Color = clWhite
      Enabled = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 2
      Placement = cpAbove
    end
  end
  object grpSort: TGroupBox
    Left = 16
    Top = 117
    Width = 265
    Height = 81
    Caption = 'Sort Results:'
    TabOrder = 4
    object radSortDate: TRadioButton
      Left = 44
      Top = 24
      Width = 209
      Height = 17
      Caption = 'Sort by Date, Then Sort by Code'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object radSortCode: TRadioButton
      Left = 44
      Top = 48
      Width = 209
      Height = 17
      Caption = 'Sort by Code, Then Sort by Date'
      TabOrder = 1
    end
  end
end
