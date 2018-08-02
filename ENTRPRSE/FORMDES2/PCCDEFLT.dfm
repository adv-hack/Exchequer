object Form_PCCDefaults: TForm_PCCDefaults
  Left = 375
  Top = 107
  HelpContext = 6004
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'System Setup - PCC Defaults'
  ClientHeight = 363
  ClientWidth = 420
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
  object Label81: Label8
    Left = 4
    Top = 4
    Width = 87
    Height = 14
    AutoSize = False
    Caption = 'Default Printer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label4: TLabel
    Left = 4
    Top = 122
    Width = 173
    Height = 14
    Caption = 'Default Bin (for the selected printer)'
  end
  object Label5: TLabel
    Left = 4
    Top = 242
    Width = 182
    Height = 14
    Caption = 'Default Form (for the selected printer)'
  end
  object btnOK: TButton
    Left = 333
    Top = 21
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 333
    Top = 51
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object List_Bins: TListBox
    Left = 4
    Top = 135
    Width = 320
    Height = 101
    ItemHeight = 14
    TabOrder = 0
    TabWidth = 45
    OnClick = List_BinsClick
  end
  object List_Papers: TListBox
    Left = 4
    Top = 256
    Width = 320
    Height = 100
    ItemHeight = 14
    TabOrder = 1
    TabWidth = 45
    OnClick = List_PapersClick
  end
  object List_Printers: TListBox
    Left = 4
    Top = 18
    Width = 320
    Height = 100
    ItemHeight = 14
    TabOrder = 4
    TabWidth = 45
    OnClick = List_PrintersClick
  end
end
