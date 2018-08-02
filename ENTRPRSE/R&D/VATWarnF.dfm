object frmVATWarning: TfrmVATWarning
  Left = 463
  Top = 294
  BorderStyle = bsDialog
  Caption = 'Warning'
  ClientHeight = 334
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 7
    Top = 8
    Width = 265
    Height = 233
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 0
    object Image1: TImage
      Left = 10
      Top = 6
      Width = 53
      Height = 73
    end
    object Label2: TLabel
      Left = 15
      Top = 96
      Width = 241
      Height = 81
      AutoSize = False
      Caption = 
        'You are attempting to change either the Last Tax Return Date or ' +
        'Return Frequency.  Any change to these fields will impact on the' +
        ' VAT Report output and should only be changed after careful cons' +
        'ideration.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 15
      Top = 176
      Width = 241
      Height = 49
      AutoSize = False
      Caption = 
        'If you are certain that you need to make this change then you mu' +
        'st enter the Daily Password to continue.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object SBSPanel2: TSBSPanel
      Left = 66
      Top = 6
      Width = 185
      Height = 77
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object CLMsgL: Label8
        Left = 3
        Top = 30
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Change Date and Frequency'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 4
        Top = 9
        Width = 176
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'WARNING'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8
        Left = 3
        Top = 50
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'PLEASE READ BELOW'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
    end
  end
  object btnCancel: TSBSButton
    Left = 144
    Top = 304
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object btnOK: TSBSButton
    Left = 56
    Top = 304
    Width = 80
    Height = 21
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 2
    TextId = 0
  end
  object Panel2: TPanel
    Left = 8
    Top = 247
    Width = 265
    Height = 49
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 3
    object Label1: TLabel
      Left = 33
      Top = 15
      Width = 56
      Height = 14
      Caption = 'Password'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtPassword: Text8Pt
      Left = 96
      Top = 11
      Width = 121
      Height = 22
      CharCase = ecUpperCase
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 8
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 0
      OnChange = edtPasswordChange
      TextId = 0
      ViaSBtn = False
    end
  end
end
