object frmAllocSelect: TfrmAllocSelect
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Select Allocation for'
  ClientHeight = 253
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object SBSButton1: TSBSButton
    Left = 328
    Top = 24
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 328
    Top = 48
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object gbAlloc: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 241
    Caption = '72050, Heat and Lighting'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object lbAlloc: TListBox
      Left = 8
      Top = 16
      Width = 297
      Height = 217
      ItemHeight = 14
      TabOrder = 0
    end
  end
end
