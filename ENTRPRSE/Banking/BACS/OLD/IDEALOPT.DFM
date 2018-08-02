object frmIdealOptions: TfrmIdealOptions
  Left = 159
  Top = 108
  ActiveControl = edtUserID
  BorderStyle = bsDialog
  Caption = 'Ideal Options'
  ClientHeight = 130
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
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
      Left = 22
      Top = 28
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company ID:'
    end
    object Label2: TLabel
      Left = 8
      Top = 68
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company Code:'
    end
    object edtUserID: TEdit
      Left = 88
      Top = 24
      Width = 97
      Height = 21
      TabOrder = 0
    end
    object edtCompCode: TEdit
      Left = 88
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 224
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 224
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
