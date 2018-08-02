object frmSelectAuth: TfrmSelectAuth
  Left = 241
  Top = 214
  BorderStyle = bsDialog
  Caption = 'Select request recipients'
  ClientHeight = 234
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 217
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnAuto: TButton
    Left = 217
    Top = 80
    Width = 80
    Height = 21
    Caption = '&Auto'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnAutoClick
  end
  object Button3: TButton
    Left = 217
    Top = 48
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object gbApp: TGroupBox
    Left = 8
    Top = 8
    Width = 201
    Height = 105
    Caption = 'Send for approval to:'
    TabOrder = 3
    object lbApprovers: TListBox
      Left = 8
      Top = 16
      Width = 185
      Height = 81
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbApproversClick
    end
  end
  object gbAuth: TGroupBox
    Left = 8
    Top = 120
    Width = 201
    Height = 105
    Caption = 'Send for authorisation to:'
    TabOrder = 4
    object lbAuthorisers: TListBox
      Left = 8
      Top = 16
      Width = 185
      Height = 81
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
