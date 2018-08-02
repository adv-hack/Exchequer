object frmSelectContact: TfrmSelectContact
  Left = 158
  Top = 280
  Width = 669
  Height = 363
  HelpContext = 10000
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Select Contact'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TSBSButton
    Left = 576
    Top = 216
    Width = 80
    Height = 21
    HelpContext = 10009
    Caption = '&OK'
    Default = True
    TabOrder = 9
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 576
    Top = 192
    Width = 80
    Height = 21
    HelpContext = 10008
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 8
    TextId = 0
  end
  object btnNew: TSBSButton
    Left = 16
    Top = 40
    Width = 80
    Height = 21
    Caption = '&New Contact'
    TabOrder = 10
    Visible = False
    OnClick = btnNewClick
    TextId = 0
  end
  object btnRestore: TSBSButton
    Left = 576
    Top = 168
    Width = 80
    Height = 21
    HelpContext = 10007
    Caption = '&Restore'
    TabOrder = 7
    OnClick = btnRestoreClick
    TextId = 0
  end
  object btnView: TButton
    Left = 576
    Top = 88
    Width = 80
    Height = 21
    HelpContext = 10004
    Caption = '&View'
    TabOrder = 4
    OnClick = btnViewClick
  end
  object btnFind: TButton
    Left = 576
    Top = 112
    Width = 80
    Height = 21
    HelpContext = 10005
    Caption = '&Find'
    TabOrder = 5
    OnClick = btnFindClick
  end
  object btnPickAccount: TButton
    Left = 576
    Top = 136
    Width = 80
    Height = 21
    HelpContext = 10006
    Caption = '&Pick Account'
    TabOrder = 6
    OnClick = btnPickAccountClick
  end
  object mlContacts: TMultiList
    Left = 8
    Top = 8
    Width = 561
    Height = 314
    HelpContext = 10000
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Name'
        Field = 'N'
        Searchable = True
        Sortable = True
        Width = 142
      end
      item
        Caption = 'Job Title'
        Field = 'J'
        Searchable = True
        Sortable = True
        Width = 196
      end
      item
        Caption = 'Address'
        Field = 'A'
        Width = 181
      end
      item
        Caption = 'Code'
        Field = 'C'
        Searchable = True
        Sortable = True
        Width = 70
      end
      item
        Caption = 'Tel No'
        Field = 'T'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Fax No'
        Field = 'F'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Email Address'
        Field = 'E'
        Searchable = True
        Sortable = True
        Width = 200
      end
      item
        Caption = 'Acc. Code'
        Field = 'A'
        Width = 60
      end>
    TabStop = True
    OnChangeSelection = mlContactsChangeSelection
    OnRowDblClick = mlContactsRowDblClick
    TabOrder = 0
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Arial'
    HeaderFont.Style = []
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clWhite
    HighlightFont.Height = -11
    HighlightFont.Name = 'Arial'
    HighlightFont.Style = []
    MultiSelectFont.Charset = DEFAULT_CHARSET
    MultiSelectFont.Color = clWindowText
    MultiSelectFont.Height = -11
    MultiSelectFont.Name = 'Arial'
    MultiSelectFont.Style = []
    Version = 'v1.13'
  end
  object btnAdd: TButton
    Left = 576
    Top = 8
    Width = 80
    Height = 21
    HelpContext = 10001
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 576
    Top = 32
    Width = 80
    Height = 21
    HelpContext = 10002
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 576
    Top = 56
    Width = 80
    Height = 21
    HelpContext = 10003
    Caption = '&Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object pmMain: TPopupMenu
    Left = 576
    Top = 240
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = btnAddClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = 'Edit'
      OnClick = btnEditClick
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = btnDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object View1: TMenuItem
      Caption = 'View'
      OnClick = btnViewClick
    end
    object Find1: TMenuItem
      Caption = 'Find'
      OnClick = btnFindClick
    end
    object PickAccount1: TMenuItem
      Caption = 'Pick Account'
      OnClick = btnPickAccountClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
