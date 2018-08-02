object frmEmailDetails: TfrmEmailDetails
  Left = 366
  Top = 176
  BorderStyle = bsDialog
  Caption = 'Email Details'
  ClientHeight = 342
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    448
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object Label817: Label8
    Left = 7
    Top = 7
    Width = 37
    Height = 20
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Subj.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label818: Label8
    Left = 8
    Top = 33
    Width = 37
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Mess.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object btnOK: TButton
    Left = 271
    Top = 315
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 360
    Top = 315
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object memMessage: TMemo
    Left = 48
    Top = 30
    Width = 394
    Height = 275
    HelpContext = 1198
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10000
    ParentFont = False
    TabOrder = 1
  end
  object edtSubject: Text8Pt
    Left = 48
    Top = 4
    Width = 394
    Height = 22
    HelpContext = 1204
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
end
