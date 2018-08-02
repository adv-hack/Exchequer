object frmAibOpts: TfrmAibOpts
  Left = 159
  Top = 99
  ActiveControl = edtUserID
  BorderStyle = bsDialog
  Caption = 'EFT Options'
  ClientHeight = 146
  ClientWidth = 344
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
    Width = 241
    Height = 129
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 28
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Caption = 'Authorised User ID:'
    end
    object Label2: TLabel
      Left = 42
      Top = 60
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Volume prefix:'
    end
    object Label3: TLabel
      Left = 30
      Top = 92
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Caption = 'Volume Number:'
    end
    object edtUserID: TEdit
      Left = 120
      Top = 24
      Width = 97
      Height = 21
      TabOrder = 0
    end
    object edtVolNo: TEdit
      Left = 120
      Top = 88
      Width = 41
      Height = 21
      TabOrder = 1
    end
    object edtVolPrefix: TEdit
      Left = 120
      Top = 56
      Width = 65
      Height = 21
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 264
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 264
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
