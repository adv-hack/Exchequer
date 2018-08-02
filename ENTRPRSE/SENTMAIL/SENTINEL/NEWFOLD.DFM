object frmNewFolder: TfrmNewFolder
  Left = 191
  Top = 133
  Width = 267
  Height = 130
  Caption = 'frmNewFolder'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 184
    Top = 8
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 184
    Top = 40
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 169
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 60
      Height = 13
      Caption = 'Folder Name'
    end
    object edtFolder: TEdit
      Left = 24
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = edtFolderChange
    end
  end
end
