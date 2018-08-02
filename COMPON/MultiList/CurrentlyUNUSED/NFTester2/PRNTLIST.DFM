object FrmPrintCardList: TFrmPrintCardList
  Left = 424
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Card List Options'
  ClientHeight = 167
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 209
    Height = 81
    Shape = bsFrame
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 209
    Height = 32
    AutoSize = False
    Caption = 
      'Please choose the order in which you wish to view the card list ' +
      'in :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object rbCardNo: TRadioButton
    Left = 32
    Top = 56
    Width = 169
    Height = 17
    Caption = 'by Card Number (sequential)'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object rbCardName: TRadioButton
    Left = 32
    Top = 88
    Width = 169
    Height = 17
    Caption = 'by Card Name'
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 80
    Top = 136
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 152
    Top = 136
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
