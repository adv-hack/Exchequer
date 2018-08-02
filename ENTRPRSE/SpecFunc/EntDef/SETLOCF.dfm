inherited SetLocFrm: TSetLocFrm
  Left = 219
  Top = 442
  ActiveControl = LastTriNom
  Caption = 'Special Function 71'
  ClientHeight = 209
  ClientWidth = 412
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 412
    Height = 168
    inherited TabSheet1: TTabSheet
      Caption = 'Set Blank Locations'
      inherited SBSPanel4: TSBSBackGroup
        Height = 109
      end
      object Label2: TLabel [1]
        Left = 17
        Top = 15
        Width = 361
        Height = 34
        AutoSize = False
        Caption = 
          'Please enter the location code you wish to apply to all transact' +
          'ion lines with a blank stock location code.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 69
        Top = 62
        Width = 84
        Height = 14
        Caption = 'Default Location: '
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
        Top = 156
        Visible = False
      end
      object LastTriNom: Text8Pt
        Left = 164
        Top = 59
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
    end
  end
  inherited OkCP1Btn: TButton
    Top = 181
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Top = 181
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 412
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Set ALL blank locations'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
