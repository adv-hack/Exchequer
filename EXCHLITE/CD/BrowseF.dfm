object frmBrowseForLITE: TfrmBrowseForLITE
  Left = 338
  Top = 174
  Width = 303
  Height = 262
  BorderIcons = [biSystemMenu]
  Caption = 'Find <APPTITLE>'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectedDir: TLabel
    Left = 61
    Top = 193
    Width = 228
    Height = 13
    AutoSize = False
    Caption = 'X:\EXCHLITE\CD'
  end
  object Label1: TLabel
    Left = 8
    Top = 193
    Width = 50
    Height = 13
    AutoSize = False
    Caption = 'Directory:'
  end
  object DriveComboBox1: TDrive95ComboBox
    Left = 4
    Top = 4
    Width = 286
    Height = 22
    DirList = DirectoryListBox1
    TabOrder = 0
  end
  object DirectoryListBox1: TDirectory95ListBox
    Left = 4
    Top = 28
    Width = 286
    Height = 161
    DirLabel = lblSelectedDir
    ItemHeight = 17
    TabOrder = 1
    OnChange = DirectoryListBox1Change
  end
  object btnOK: TButton
    Left = 64
    Top = 211
    Width = 80
    Height = 21
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 151
    Top = 211
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
