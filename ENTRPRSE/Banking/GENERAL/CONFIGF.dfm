object frmBacsConfig: TfrmBacsConfig
  Left = 192
  Top = 133
  Width = 295
  Height = 164
  Caption = 'Configure Bacs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 64
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 169
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label2'
      WordWrap = True
    end
    object edtVal: TEdit
      Left = 8
      Top = 80
      Width = 161
      Height = 21
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
end
