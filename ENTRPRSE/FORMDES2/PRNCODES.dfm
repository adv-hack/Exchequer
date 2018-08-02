object Form_PrnCodes: TForm_PrnCodes
  Left = 396
  Top = 229
  HelpContext = 6003
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'System Setup - Printer Control Codes'
  ClientHeight = 201
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 6
    Top = 54
    Width = 86
    Height = 14
    Caption = 'Windows Printers'
  end
  object Label2: TLabel
    Left = 305
    Top = 54
    Width = 102
    Height = 14
    Caption = 'Printer Control Codes'
  end
  object lbExchPrinters: TListBox
    Left = 304
    Top = 68
    Width = 260
    Height = 97
    ItemHeight = 14
    TabOrder = 0
    OnClick = lbExchPrintersClick
  end
  object lbWinPrinters: TListBox
    Left = 4
    Top = 68
    Width = 289
    Height = 97
    ItemHeight = 14
    TabOrder = 1
    OnClick = lbWinPrintersClick
  end
  object btnOK: TButton
    Left = 396
    Top = 174
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 483
    Top = 174
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 3
    Top = 2
    Width = 562
    Height = 46
    TabOrder = 4
    object Label81: Label8
      Left = 7
      Top = 11
      Width = 548
      Height = 29
      AutoSize = False
      Caption = 
        'For each Windows Printer shown in the list on the the left, you ' +
        'must select a Printer Control Code Set from the list on the righ' +
        't.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
  end
  object btnEditPrinterCodes: TButton
    Left = 6
    Top = 174
    Width = 103
    Height = 21
    Caption = '&Edit Printer Codes'
    TabOrder = 5
    OnClick = btnEditPrinterCodesClick
  end
end
