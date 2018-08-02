inherited frmSCDDirDlg: TfrmSCDDirDlg
  Left = 387
  Top = 203
  ActiveControl = nil
  Caption = 'Exchequer Accounting System Installation'
  ClientHeight = 379
  ClientWidth = 490
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 334
    Width = 467
  end
  inherited TitleLbl: TLabel
    Left = 168
    Width = 315
  end
  inherited InstrLbl: TLabel
    Left = 168
    Top = 46
    Width = 313
    Height = 41
  end
  inherited imgSide: TImage
    Height = 223
  end
  inherited HelpBtn: TButton
    Top = 351
  end
  inherited Panel1: TPanel
    Height = 317
    inherited Image1: TImage
      Height = 315
    end
    object imgBackdoor: TImage
      Left = 99
      Top = 228
      Width = 23
      Height = 15
      Anchors = [akLeft, akBottom]
      Enabled = False
      OnDblClick = imgBackdoorDblClick
    end
  end
  inherited ExitBtn: TButton
    Top = 351
  end
  inherited BackBtn: TButton
    Left = 313
    Top = 351
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Left = 400
    Top = 351
    TabOrder = 5
  end
  object btnFindEnt: TButton
    Left = 185
    Top = 351
    Width = 79
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = '&Find'
    TabOrder = 3
    OnClick = btnFindEntClick
  end
  object ShellTreeView20051: TShellTreeView2005
    Left = 169
    Top = 92
    Width = 312
    Height = 215
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
    TabOrder = 6
    OnChange = ShellTreeView20051Change
  end
  object edtPath: TComboBox
    Left = 169
    Top = 310
    Width = 312
    Height = 21
    Style = csSimple
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 14
    Sorted = True
    TabOrder = 7
    OnChange = edtPathChange
    OnKeyDown = edtPathKeyDown
  end
end
