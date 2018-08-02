inherited PurgeDataI: TPurgeDataI
  Tag = 104
  ActiveControl = PrgYrF
  Caption = 'Purge Exchequer Data'
  ClientHeight = 240
  ClientWidth = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Width = 395
    Height = 240
    inherited TabSheet1: TTabSheet
      Caption = 'Purge All Data'
      inherited SBSPanel4: TSBSBackGroup
        Top = 1
        Width = 380
        Height = 179
      end
      object Label2: TLabel [1]
        Left = 16
        Top = 13
        Width = 334
        Height = 32
        Alignment = taCenter
        AutoSize = False
        Caption = 'Please select the following options for purging the Accounts'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 18
        Top = 64
        Width = 162
        Height = 14
        Alignment = taRightJustify
        Caption = 'Purge all years upto and including'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      inherited StartBtn: TButton
        Visible = False
      end
      object ShrinkF: TBorCheck
        Left = 29
        Top = 155
        Width = 166
        Height = 20
        Caption = 'Shrink file sizes after purge'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
        TabStop = True
        TextId = 0
      end
      object PrgYrF: TCurrencyEdit
        Left = 183
        Top = 60
        Width = 49
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '1999')
        MaxLength = 4
        ParentFont = False
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        OnExit = PrgYrFExit
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1999
      end
      object RemCustF: TBorCheck
        Left = 22
        Top = 93
        Width = 173
        Height = 20
        Caption = 'Remove empty Customer records'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TabStop = True
        TextId = 0
      end
      object RemSuppF: TBorCheck
        Left = 203
        Top = 93
        Width = 173
        Height = 20
        Caption = 'Remove empty Supplier records'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object RemStkF: TBorCheck
        Left = 22
        Top = 115
        Width = 173
        Height = 20
        Caption = 'Remove empty Stock records'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object RemLocF: TBorCheck
        Left = 203
        Top = 115
        Width = 173
        Height = 20
        Caption = 'Remove empty Location records'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object RemSnoF: TBorCheck
        Left = 22
        Top = 135
        Width = 173
        Height = 20
        Caption = 'Remove used Serial records'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object UpDown1: TUpDown
        Left = 232
        Top = 60
        Width = 16
        Height = 25
        Associate = PrgYrF
        Min = 1950
        Max = 2049
        Position = 1999
        TabOrder = 8
        Wrap = False
      end
    end
  end
  inherited SBSPanel1: TSBSPanel
    Left = 401
    Top = 103
    inherited Animated1: TAnimated
      Left = 3
    end
  end
  inherited OkCP1Btn: TButton
    Left = 114
    Top = 211
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Left = 200
    Top = 211
    OnClick = ClsCP1BtnClick
  end
end
