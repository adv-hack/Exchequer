inherited PurgeOrderI: TPurgeOrderI
  Tag = 103
  ActiveControl = PrgPrYr
  Caption = 'Purge Orders'
  ClientHeight = 240
  ClientWidth = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Width = 395
    Height = 240
    inherited TabSheet1: TTabSheet
      Caption = 'Purge Orders'
      inherited SBSPanel4: TSBSBackGroup
        Left = 6
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
        Caption = 'Please select the following options for purging Orders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 23
        Top = 64
        Width = 118
        Height = 14
        Alignment = taRightJustify
        Caption = 'Purge upto and including'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8 [3]
        Left = 17
        Top = 93
        Width = 124
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Include Account :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8 [4]
        Left = 216
        Top = 93
        Width = 89
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Exclude Account :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8 [5]
        Left = 17
        Top = 121
        Width = 124
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Include Account type :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8 [6]
        Left = 214
        Top = 121
        Width = 92
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Excl Account type:'
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
      object PrgPrYr: TEditPeriod
        Left = 145
        Top = 60
        Width = 66
        Height = 22
        AutoSelect = False
        EditMask = '00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 7
        ParentFont = False
        TabOrder = 1
        Text = '011996'
        Placement = cpAbove
        EPeriod = 1
        EYear = 96
        ViewMask = '00/0000;0;'
      end
      object IncACF: Text8Pt
        Left = 145
        Top = 88
        Width = 66
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnExit = IncACFExit
        TextId = 0
        ViaSBtn = False
      end
      object ExcACF: Text8Pt
        Left = 307
        Top = 88
        Width = 66
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TextId = 0
        ViaSBtn = False
      end
      object IncAcTyp: Text8Pt
        Left = 145
        Top = 116
        Width = 66
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        TextId = 0
        ViaSBtn = False
      end
      object ExcAcTyp: Text8Pt
        Left = 307
        Top = 116
        Width = 66
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TextId = 0
        ViaSBtn = False
      end
      object ShrinkF: TBorCheck
        Left = 61
        Top = 149
        Width = 98
        Height = 20
        Caption = 'Shrink File Size'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        TabStop = True
        TextId = 0
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
