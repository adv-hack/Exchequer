object Form1: TForm1
  Left = 192
  Top = 114
  Width = 392
  Height = 384
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 8
    Top = 136
    Width = 369
    Height = 209
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel2'
    TabOrder = 0
    object memSentinel: TMemo
      Left = 8
      Top = 8
      Width = 353
      Height = 193
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 369
    Height = 121
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel2'
    TabOrder = 1
    object Label1: TLabel
      Left = 51
      Top = 12
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company'
    end
    object Label2: TLabel
      Left = 73
      Top = 36
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'User'
    end
    object Label3: TLabel
      Left = 57
      Top = 60
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sentinel'
    end
    object Label4: TLabel
      Left = 54
      Top = 84
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Instance'
    end
    object cbCompanies: TComboBox
      Left = 104
      Top = 8
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object edtUser: TEdit
      Left = 104
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'MISS'
    end
    object edtSentinel: TEdit
      Left = 104
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Button1: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Get Sentinel'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 288
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Get Next'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 288
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 5
      OnClick = Button3Click
    end
    object edtInstance: TEdit
      Left = 104
      Top = 80
      Width = 41
      Height = 21
      TabOrder = 6
    end
  end
end
