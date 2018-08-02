object frmTaskList: TfrmTaskList
  Left = 228
  Top = 253
  Width = 604
  Height = 349
  HelpContext = 2
  Caption = 'Exchequer Task Scheduler'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 588
    Height = 311
    HelpContext = 2
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Scheduled Tasks'
      object Panel1: TPanel
        Left = 475
        Top = 0
        Width = 105
        Height = 282
        HelpContext = 2
        Align = alRight
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        object btnAdd: TSBSButton
          Left = 12
          Top = 24
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddClick
          TextId = 0
        end
        object btnEdit: TSBSButton
          Left = 12
          Top = 48
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditClick
          TextId = 0
        end
        object btnDelete: TSBSButton
          Left = 12
          Top = 72
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Delete'
          TabOrder = 2
          OnClick = btnDeleteClick
          TextId = 0
        end
        object btnClose: TSBSButton
          Left = 12
          Top = 144
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Close'
          TabOrder = 5
          OnClick = btnCloseClick
          TextId = 0
        end
        object btnSettings: TSBSButton
          Left = 12
          Top = 96
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Settings'
          TabOrder = 3
          OnClick = btnSettingsClick
          TextId = 0
        end
        object btnRefresh: TSBSButton
          Left = 12
          Top = 120
          Width = 80
          Height = 21
          HelpContext = 2
          Caption = '&Refresh'
          TabOrder = 4
          OnClick = btnRefreshClick
          TextId = 0
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 475
        Height = 282
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object mlTasks: TDBMultiList
          Left = 0
          Top = 0
          Width = 475
          Height = 282
          HelpContext = 2
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
              Width = 150
            end
            item
              Caption = 'Next Run Due'
              Field = 'R'
              Searchable = True
              Sortable = True
            end
            item
              Caption = 'Status'
              Field = 'S'
              Width = 70
            end
            item
              Caption = 'Type'
              Field = 'T'
              Width = 117
            end>
          TabStop = True
          OnChangeSelection = mlTasksChangeSelection
          OnRowDblClick = mlTasksRowDblClick
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnKeyDown = mlTasksKeyDown
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
          Dataset = dsTasks
          OnAfterLoad = mlTasksAfterLoad
          Active = False
          SortColIndex = 0
          SortAsc = True
        end
      end
    end
  end
  object dsTasks: TBtrieveDataset
    OnFilterRecord = dsTasksFilterRecord
    OnGetFieldValue = dsTasksGetFieldValue
    Left = 544
    Top = 248
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 520
    Top = 200
    object Active1: TMenuItem
      AutoCheck = True
      Caption = 'Active'
      OnClick = Active1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = btnAddClick
    end
    object mniEdit: TMenuItem
      Caption = '&Edit'
      OnClick = btnEditClick
    end
    object mniDelete: TMenuItem
      Caption = '&Delete'
      OnClick = btnDeleteClick
    end
    object Settings1: TMenuItem
      Caption = '&Settings'
      OnClick = btnSettingsClick
    end
    object Refresh1: TMenuItem
      Caption = '&Refresh'
      OnClick = btnRefreshClick
    end
    object Close1: TMenuItem
      Caption = '&Close'
      OnClick = btnCloseClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'A&bout'
      OnClick = About1Click
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
