inherited TestCust4: TTestCust4
  Tag = 102
  Caption = 'Perform Special Function'
  ClientHeight = 338
  ClientWidth = 521
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Width = 521
    Height = 338
    inherited TabSheet1: TTabSheet
      Caption = 'Select Function'
      inherited SBSPanel4: TSBSBackGroup
        Width = 496
        Height = 279
      end
      object Label2: TLabel [1]
        Left = 16
        Top = 13
        Width = 475
        Height = 32
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Please select which special function you wish to run by clicking' +
          ' on it, or entering the special function number directly in the ' +
          'box below.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label1: TLabel [2]
        Left = 22
        Top = 287
        Width = 163
        Height = 13
        AutoSize = False
        Caption = 'Choose by Special Function No.'
      end
      inherited StartBtn: TButton
        TabOrder = 2
        Visible = False
      end
      object FuncsList: TListBox
        Left = 9
        Top = 48
        Width = 486
        Height = 225
        ExtendedSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        OnDblClick = FuncsListDblClick
      end
      object SFNoF: TCurrencyEdit
        Left = 188
        Top = 284
        Width = 43
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
  end
  inherited SBSPanel1: TSBSPanel
    Left = 356
    Top = 103
  end
  inherited OkCP1Btn: TButton
    Left = 339
    Top = 311
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Left = 425
    Top = 311
    OnClick = ClsCP1BtnClick
  end
end
