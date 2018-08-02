inherited SetStkFrm: TSetStkFrm
  Left = 218
  Top = 412
  ActiveControl = LastTriNom
  Caption = 'Special Function 91'
  ClientHeight = 225
  ClientWidth = 444
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 444
    Height = 184
    inherited TabSheet1: TTabSheet
      Caption = 'Enter Stock Code'
      inherited SBSPanel4: TSBSBackGroup
        Width = 424
        Height = 122
      end
      object Label2: TLabel [1]
        Left = 14
        Top = 14
        Width = 389
        Height = 31
        AutoSize = False
        Caption = 
          'Please enter the stock code for the stock record whose purged qu' +
          'antity history you wish to reset to zero'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 110
        Top = 74
        Width = 61
        Height = 14
        Caption = 'Stock Code: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      inherited StartBtn: TButton
        Left = 103
        Top = 168
        Visible = False
      end
      object LastTriNom: Text8Pt
        Left = 177
        Top = 71
        Width = 130
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
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
    end
  end
  inherited OkCP1Btn: TButton
    Left = 264
    Top = 195
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Left = 350
    Top = 195
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 444
    object Label1: TLabel
      Left = 4
      Top = 10
      Width = 406
      Height = 27
      AutoSize = False
      Caption = 'Reset Purged History'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
