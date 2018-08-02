object FrmDirBrowse: TFrmDirBrowse
  Left = 96
  Top = 157
  HelpContext = 1
  BorderStyle = bsDialog
  Caption = 'Directory Browser'
  ClientHeight = 265
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 50
    Height = 14
    Caption = 'Directory :'
  end
  object lDir: TLabel
    Left = 64
    Top = 6
    Width = 3
    Height = 14
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDirectory: TDirectoryListBox
    Left = 8
    Top = 48
    Width = 281
    Height = 209
    ItemHeight = 16
    TabOrder = 0
    OnChange = lbDirectoryChange
  end
  object DriveComboBox1: TDriveComboBox
    Left = 8
    Top = 24
    Width = 281
    Height = 20
    DirList = lbDirectory
    TabOrder = 1
    OnChange = DriveComboBox1Change
  end
  object btnOK: TButton
    Left = 296
    Top = 24
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 296
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
