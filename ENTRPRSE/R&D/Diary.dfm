object DiaryFrm: TDiaryFrm
  Left = -842
  Top = -138
  Width = 746
  Height = 449
  HelpContext = 1719
  Caption = 'Workflow Diary'
  Color = clBtnFace
  Constraints.MinHeight = 245
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object StatusBar: TStatusBar
    Left = 0
    Top = 391
    Width = 730
    Height = 19
    Panels = <
      item
        Width = 256
      end
      item
        Width = 400
      end>
    SimplePanel = False
  end
  object MultiList: TMultiList
    Left = 5
    Top = 5
    Width = 635
    Height = 381
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Entry Date'
        Field = '0'
        Searchable = True
        Sortable = True
        Width = 65
      end
      item
        Caption = 'Alarm Date'
        Field = '1'
        Searchable = True
        Sortable = True
        Width = 65
      end
      item
        Caption = 'Notes'
        Field = '2'
        Width = 256
      end
      item
        Caption = 'From'
        Field = '3'
        Searchable = True
        Sortable = True
        Width = 64
      end
      item
        Caption = 'Source'
        Field = '4'
        Searchable = True
        Sortable = True
        Width = 64
      end
      item
        Caption = 'To'
        Field = '5'
        Searchable = True
        Sortable = True
        Width = 64
      end
      item
        Caption = 'RecPFix'
        Field = '6'
        Visible = False
      end
      item
        Caption = 'SubType'
        Field = '7'
        Visible = False
      end
      item
        Caption = 'NoteNo'
        Field = '8'
        Visible = False
      end
      item
        Caption = 'NoteFolio'
        Field = '9'
        Visible = False
      end
      item
        Caption = 'LineNumber'
        DataType = dtInteger
        Field = '10'
        Visible = False
      end
      item
        Caption = 'RepeatNo'
        DataType = dtInteger
        Field = '11'
        Visible = False
      end
      item
        Caption = 'PositionId'
        DataType = dtInteger
        Field = '12'
        Visible = False
      end>
    TabStop = True
    OnCellPaint = MultiListCellPaint
    OnChangeSelection = MultiListChangeSelection
    OnRowClick = MultiListRowClick
    OnRowDblClick = MultiListRowDblClick
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    PopupMenu = PopupMenu
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
  object CloseBtn: TButton
    Left = 645
    Top = 24
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = CloseBtnClick
  end
  object AddBtn: TButton
    Left = 645
    Top = 62
    Width = 80
    Height = 21
    Hint = 
      'Add a new record|Add a new record. Store with OK, abandon with C' +
      'ancel.'
    HelpContext = 592
    Caption = '&Add'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = AddBtnClick
  end
  object EditBtn: TButton
    Left = 645
    Top = 86
    Width = 80
    Height = 21
    Hint = 
      'Edit current record|Edit the currently displayed record. Store a' +
      'ny changes with OK, abandon with Cancel.'
    HelpContext = 593
    Caption = '&Edit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = EditBtnClick
  end
  object ClearBtn: TButton
    Left = 645
    Top = 110
    Width = 80
    Height = 21
    Hint = 
      'Clear the note from the diary without deleting it from the origi' +
      'nal notepad'
    HelpContext = 594
    Caption = 'C&lear'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = ClearBtnClick
  end
  object SwitchBtn: TButton
    Left = 645
    Top = 134
    Width = 80
    Height = 21
    Hint = 
      'Toggle display of cleared notes|Shows or hides previously cleare' +
      'd Workflow Diary notes'
    HelpContext = 593
    Caption = '&Show Cleared'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = SwitchBtnClick
  end
  object DeleteBtn: TButton
    Left = 645
    Top = 158
    Width = 80
    Height = 21
    Hint = 'Delete record|Delete the currently selected record.'
    HelpContext = 77
    Caption = '&Delete'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = DeleteBtnClick
  end
  object ViewBtn: TButton
    Left = 645
    Top = 182
    Width = 80
    Height = 21
    Hint = 'Drill-Down to the source of the note'
    HelpContext = 595
    Caption = '&View Source'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = ViewBtnClick
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 8
    Top = 24
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = EditBtnClick
    end
    object Clear1: TMenuItem
      Caption = 'C&lear'
      OnClick = ClearBtnClick
    end
    object ShowCleared1: TMenuItem
      Caption = '&Show Cleared'
      OnClick = SwitchBtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = DeleteBtnClick
    end
    object ViewSource1: TMenuItem
      Caption = '&View Source'
      OnClick = ViewBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Sa&ve Coordinates'
    end
  end
end
