inherited frmSelectExchSQLDir: TfrmSelectExchSQLDir
  Left = 394
  Top = 127
  HelpContext = 3
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = 'frmSelectExchSQLDir'
  ClientHeight = 452
  ClientWidth = 400
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  PrintScale = poNone
  DesignSize = (
    400
    452)
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 400
  end
  inherited lblBanner: TLabel
    Width = 237
    Caption = 'Select SQL Directory'
  end
  object InstrLbl: TLabel [2]
    Left = 8
    Top = 48
    Width = 383
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please select the main directory of the Exchequer SQL Edition sy' +
      'stem that you want to convert within the tree below.  The Excheq' +
      'uer main directory is the directory that contains Enter1.Exe and' +
      ' Entrprse.Dat.'
    WordWrap = True
  end
  object ShellTreeView20051: TShellTreeView2005 [3]
    Left = 9
    Top = 96
    Width = 382
    Height = 292
    ObjectTypes = [otFolders, otHidden]
    Root = 'rfMyComputer'
    UseShellImages = True
    OnAddFolder = ShellTreeView20051AddFolder
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoRefresh = False
    HideSelection = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
    OnChange = ShellTreeView20051Change
    OnEditing = ShellTreeView20051Editing
  end
  object edtPath: TComboBox [4]
    Left = 9
    Top = 393
    Width = 382
    Height = 21
    Style = csSimple
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 14
    Sorted = True
    TabOrder = 1
    OnChange = edtPathChange
    OnKeyDown = edtPathKeyDown
  end
  object btnContinue: TButton [5]
    Left = 114
    Top = 423
    Width = 80
    Height = 21
    Caption = 'Continue'
    TabOrder = 2
    OnClick = btnContinueClick
  end
  object btnClose: TButton [6]
    Left = 205
    Top = 423
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 3
  end
end
