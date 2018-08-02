object Form1: TForm1
  Left = 341
  Top = 262
  Width = 699
  Height = 452
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    691
    425)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 3
    Width = 684
    Height = 418
    ActivePage = tabshMain
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 0
    TabOrder = 0
    object tabshMain: TTabSheet
      Caption = 'Main'
      DesignSize = (
        676
        390)
      object Label1: TLabel
        Left = 5
        Top = 12
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'CDKey'
      end
      object Label4: TLabel
        Left = 5
        Top = 42
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Activation Code'
      end
      object Label2: TLabel
        Left = 5
        Top = 67
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Activation Date'
      end
      object edtCDKey: TEdit
        Left = 88
        Top = 9
        Width = 273
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'XBXSQQQQCQQQQQQQQQQQTP3G'
      end
      object btnActivateFromWS: TButton
        Left = 367
        Top = 8
        Width = 107
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'ActivateFromWS'
        TabOrder = 1
        OnClick = btnActivateFromWSClick
      end
      object edtActivationKey: TEdit
        Left = 88
        Top = 39
        Width = 273
        Height = 21
        TabOrder = 2
      end
      object btnActivateCDKey: TButton
        Left = 367
        Top = 38
        Width = 107
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'ActivateCDKey'
        TabOrder = 3
        OnClick = btnActivateCDKeyClick
      end
      object Button1: TButton
        Left = 62
        Top = 223
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 4
      end
      object edtActivationDate: TEdit
        Left = 88
        Top = 64
        Width = 93
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
    end
    object tabshLogging: TTabSheet
      Caption = 'Logging'
      ImageIndex = 1
      DesignSize = (
        676
        390)
      object memLogging: TMemo
        Left = 3
        Top = 4
        Width = 669
        Height = 382
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
end
