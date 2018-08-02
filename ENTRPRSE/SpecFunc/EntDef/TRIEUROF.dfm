inherited TriEuroFrm: TTriEuroFrm
  Left = 219
  Top = 442
  ActiveControl = LastTriNom
  Caption = 'Special Function 54'
  ClientHeight = 290
  ClientWidth = 408
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 408
    Height = 249
    inherited TabSheet1: TTabSheet
      Caption = 'Apply Euro Triangulation'
      inherited SBSPanel4: TSBSBackGroup
        Height = 191
      end
      object Label2: TLabel [1]
        Left = 17
        Top = 15
        Width = 361
        Height = 50
        AutoSize = False
        Caption = 
          'If you have already applied the triangulation rates, then please' +
          ' enter the Number of the last Revaluation Nominal Transfer which' +
          ' was generated, otherwise, simply leave blank.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel [2]
        Left = 17
        Top = 105
        Width = 361
        Height = 28
        AutoSize = False
        Caption = 
          'If the Euro is already present as a currency then please select ' +
          'it from the list of currencies.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [3]
        Left = 53
        Top = 73
        Width = 110
        Height = 14
        Caption = 'Nom Transaction Ref : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8 [4]
        Left = 76
        Top = 140
        Width = 79
        Height = 14
        Caption = 'Euro Currency : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      inherited StartBtn: TButton
        Left = 96
        Top = 240
        Visible = False
      end
      object LastTriNom: Text8Pt
        Left = 164
        Top = 70
        Width = 121
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 9
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnExit = LastTriNomExit
        TextId = 0
        ViaSBtn = False
      end
      object EuroCurrF: TSBSComboBox
        Left = 164
        Top = 135
        Width = 124
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        MaxListWidth = 0
      end
    end
  end
  inherited OkCP1Btn: TButton
    Top = 264
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Top = 264
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 408
    object Label1: TLabel
      Left = 6
      Top = 12
      Width = 371
      Height = 25
      AutoSize = False
      Caption = 'Set Pre-Triangulation Transactions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
