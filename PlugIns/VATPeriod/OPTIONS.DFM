object frmOptions: TfrmOptions
  Left = 323
  Top = 187
  Width = 296
  Height = 154
  Caption = 'Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 201
    Height = 113
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 79
      Height = 13
      Caption = 'Periods per year:'
    end
    object SpinEdit1: TSpinEdit
      Left = 112
      Top = 16
      Width = 49
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 64
      Width = 169
      Height = 17
      Caption = 'Use Auto-fill during posting'
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 216
    Top = 8
    Width = 65
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 216
    Top = 40
    Width = 65
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
