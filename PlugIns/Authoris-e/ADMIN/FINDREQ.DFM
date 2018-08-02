object frmFindReq: TfrmFindReq
  Left = 202
  Top = 140
  ActiveControl = edtReq2Find
  BorderStyle = bsDialog
  Caption = 'Find Request'
  ClientHeight = 120
  ClientWidth = 286
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
    Left = 200
    Top = 8
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 200
    Top = 40
    Width = 80
    Height = 21
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 185
    Height = 105
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 153
      Height = 57
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Enter the transaction number of the Request you wish to find, th' +
        'en click OK'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 99
      Height = 13
      Caption = 'Transaction Number:'
    end
    object edtReq2Find: TEdit
      Left = 16
      Top = 72
      Width = 153
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
  end
end
