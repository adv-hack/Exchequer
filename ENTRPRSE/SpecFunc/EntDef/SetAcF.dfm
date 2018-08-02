inherited SetAcFrm: TSetAcFrm
  Left = 218
  Top = 412
  ActiveControl = LastTriNom
  Caption = 'Special Function 90'
  ClientHeight = 255
  ClientWidth = 412
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 412
    Height = 214
    inherited TabSheet1: TTabSheet
      Caption = 'Enter Account Code'
      inherited SBSPanel4: TSBSBackGroup
        Height = 147
      end
      object Label2: TLabel [1]
        Left = 17
        Top = 43
        Width = 361
        Height = 50
        AutoSize = False
        Caption = 
          'Please enter the account code for the account whose purged histo' +
          'ry you wish to reset to zero'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 113
        Top = 106
        Width = 47
        Height = 14
        Caption = 'Account: '
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
        Top = 103
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
    Top = 221
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Top = 221
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 412
    object Label1: TLabel
      Left = 3
      Top = 12
      Width = 377
      Height = 25
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
