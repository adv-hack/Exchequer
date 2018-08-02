object frmEventKey: TfrmEventKey
  Left = 188
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Event Sentinel'
  ClientHeight = 174
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 264
    Top = 144
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object Button2: TButton
    Left = 192
    Top = 144
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 129
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 289
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label1'
      WordWrap = True
    end
    object edtKey: TEdit
      Left = 16
      Top = 56
      Width = 289
      Height = 21
      TabOrder = 0
    end
    object rgCustSupp: TRadioGroup
      Left = 16
      Top = 80
      Width = 289
      Height = 41
      Columns = 2
      Enabled = False
      ItemIndex = 0
      Items.Strings = (
        'Customer'
        'Supplier')
      TabOrder = 1
    end
  end
end
