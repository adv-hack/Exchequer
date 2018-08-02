object SortViewOptionsFrm: TSortViewOptionsFrm
  Left = 405
  Top = 169
  Width = 535
  Height = 253
  HelpContext = 8028
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Customer List - Sort View Options'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object SortViewList: TMultiList
    Left = 6
    Top = 7
    Width = 419
    Height = 206
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Type'
        Width = 75
      end
      item
        Caption = 'Description'
        Width = 270
      end
      item
        Caption = 'Deflt'
        Width = 30
      end>
    TabStop = True
    OnCellPaint = SortViewListCellPaint
    OnChangeSelection = SortViewListChangeSelection
    OnRowDblClick = SortViewListRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
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
  object panButtons: TPanel
    Left = 433
    Top = 7
    Width = 90
    Height = 206
    BevelOuter = bvLowered
    TabOrder = 1
    object ApplyBtn: TButton
      Left = 5
      Top = 46
      Width = 80
      Height = 21
      HelpContext = 8020
      Caption = 'Apply'
      ModalResult = 1
      TabOrder = 1
      OnClick = ApplyBtnClick
    end
    object CloseBtn: TButton
      Left = 6
      Top = 7
      Width = 80
      Height = 21
      HelpContext = 24
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = CloseBtnClick
    end
    object AddBtn: TButton
      Left = 5
      Top = 70
      Width = 80
      Height = 21
      HelpContext = 8021
      Caption = 'Add'
      TabOrder = 2
      OnClick = AddBtnClick
    end
    object EditBtn: TButton
      Left = 5
      Top = 94
      Width = 80
      Height = 21
      HelpContext = 8022
      Caption = 'Edit'
      TabOrder = 3
      OnClick = EditBtnClick
    end
    object CopyBtn: TButton
      Left = 5
      Top = 118
      Width = 80
      Height = 21
      HelpContext = 8023
      Caption = 'Copy'
      TabOrder = 4
      OnClick = CopyBtnClick
    end
    object DeleteBtn: TButton
      Left = 5
      Top = 142
      Width = 80
      Height = 21
      HelpContext = 8024
      Caption = 'Delete'
      TabOrder = 5
      OnClick = DeleteBtnClick
    end
    object DefaultBtn: TButton
      Left = 5
      Top = 166
      Width = 80
      Height = 21
      HelpContext = 8025
      Caption = 'Set As Default'
      TabOrder = 6
      OnClick = DefaultBtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 12
    Top = 28
    object Apply1: TMenuItem
      Caption = '&Apply'
      OnClick = ApplyBtnClick
    end
    object Add1: TMenuItem
      Caption = 'A&dd'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = EditBtnClick
    end
    object Copy1: TMenuItem
      Caption = '&Copy'
      OnClick = CopyBtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = DeleteBtnClick
    end
    object SetAsDefault1: TMenuItem
      Caption = 'Set As &Default'
      OnClick = DefaultBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
    end
  end
end
