object frmLine: TfrmLine
  Left = 355
  Top = 261
  BorderStyle = bsDialog
  Caption = 'Line Details'
  ClientHeight = 78
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 65
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 57
      Height = 14
      Caption = 'Cost Centre'
    end
    object Label2: TLabel
      Left = 72
      Top = 16
      Width = 22
      Height = 14
      Caption = 'Dept'
    end
    object Label3: TLabel
      Left = 136
      Top = 16
      Width = 55
      Height = 14
      Caption = 'Percentage'
    end
    object Label4: TLabel
      Left = 200
      Top = 16
      Width = 62
      Height = 14
      Caption = 'Remaining %'
    end
    object edtCC: TEdit
      Left = 8
      Top = 32
      Width = 57
      Height = 22
      CharCase = ecUpperCase
      MaxLength = 3
      TabOrder = 0
      OnExit = edtCCExit
    end
    object edtDept: TEdit
      Left = 72
      Top = 32
      Width = 57
      Height = 22
      CharCase = ecUpperCase
      MaxLength = 3
      TabOrder = 1
      OnExit = edtCCExit
    end
    object edtPerc: TEdit
      Left = 136
      Top = 32
      Width = 57
      Height = 22
      TabOrder = 2
      OnExit = edtPercExit
    end
    object edtRemaining: TEdit
      Left = 200
      Top = 32
      Width = 65
      Height = 22
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
  object SBSButton1: TSBSButton
    Left = 288
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 288
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
