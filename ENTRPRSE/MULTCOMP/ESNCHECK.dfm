object frmESNWarning: TfrmESNWarning
  Left = 146
  Top = 171
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Security Error'
  ClientHeight = 111
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IconImage: TImage
    Left = 8
    Top = 27
    Width = 32
    Height = 32
  end
  object Label1: TLabel
    Left = 54
    Top = 10
    Width = 154
    Height = 13
    AutoSize = False
    Caption = 'Invalid Site Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 54
    Top = 27
    Width = 348
    Height = 29
    AutoSize = False
    Caption = 
      'The Site Number has been corrupted and the system cannot be used' +
      ' until this has been corrected.'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 54
    Top = 59
    Width = 348
    Height = 19
    AutoSize = False
    Caption = 'Please contact your dealer or distributor for instructions.'
    WordWrap = True
  end
  object lblErrNo: TLabel
    Left = 311
    Top = 10
    Width = 89
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnOK: TButton
    Left = 167
    Top = 86
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
end
