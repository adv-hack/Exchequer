object FrmDirBrowse: TFrmDirBrowse
  Left = 203
  Top = 123
  HelpContext = 1
  BorderStyle = bsDialog
  Caption = 'Directory Browser'
  ClientHeight = 279
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 50
    Height = 14
    Caption = 'Directory :'
  end
  object lDir: TLabel
    Left = 64
    Top = 13
    Width = 313
    Height = 14
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnOK: TButton
    Left = 296
    Top = 32
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 296
    Top = 56
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnCreateNew: TButton
    Left = 296
    Top = 80
    Width = 80
    Height = 21
    Caption = 'Create &New'
    TabOrder = 3
    OnClick = btnCreateNewClick
  end
  object stvDirectory: TShellTreeView2005
    Left = 8
    Top = 32
    Width = 281
    Height = 241
    ObjectTypes = [otFolders]
    Root = 'rfMyComputer'
    UseShellImages = True
    OnAddFolder = stvDirectoryAddFolder
    AutoRefresh = False
    HideSelection = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
    OnChange = stvDirectoryChange
  end
end
