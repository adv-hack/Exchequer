object frmScheduler: TfrmScheduler
  Left = 111
  Top = 183
  HelpContext = 11
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Importer v5.70.001 - Scheduler'
  ClientHeight = 412
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl: TPageControl
    Left = 7
    Top = 10
    Width = 768
    Height = 369
    ActivePage = tsSettings
    TabOrder = 0
    object tsSettings: TTabSheet
      Caption = 'Job Settings'
      ImageIndex = 1
      TabVisible = False
      object gbSettings: TGroupBox
        Left = 5
        Top = 4
        Width = 664
        Height = 353
        Caption = 'List of Import Jobs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object mlJobList: TMultiList
          Left = 8
          Top = 24
          Width = 649
          Height = 319
          Custom.SplitterCursor = crHSplit
          Dimensions.HeaderHeight = 18
          Dimensions.SpacerWidth = 1
          Dimensions.SplitterWidth = 3
          Options.BoldActiveColumn = False
          Columns = <
            item
              Caption = 'DefOrJob'
              Visible = False
            end
            item
              Caption = 'Enabled'
              Field = 'Enabled'
              Sortable = True
              Width = 50
            end
            item
              Caption = 'Job File'
              Field = 'JobFile'
              Width = 70
            end
            item
              Caption = 'Description'
              Field = 'Description'
              Width = 200
            end
            item
              Alignment = taCenter
              Caption = 'Job No.'
              Field = 'JobNo'
              Width = 36
            end
            item
              Caption = 'Status'
              Field = 'RunStatus'
              Sortable = True
            end
            item
              Caption = 'Next Run'
              Field = 'NextRun'
              Width = 160
            end
            item
              Caption = 'Last Run'
              Field = 'LastRun'
            end
            item
              Caption = 'NextRunDateTime'
              DataType = dtDateTime
              Visible = False
            end
            item
              Caption = 'Company'
            end
            item
              Caption = 'FullJobFileName'
              Visible = False
            end
            item
              Caption = 'PrevStatus'
              Visible = False
            end>
          TabStop = True
          OnChangeSelection = mlJobListChangeSelection
          OnRowDblClick = mlJobListRowDblClick
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
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
      end
      object btnHoldJob: TButton
        Left = 677
        Top = 73
        Width = 80
        Height = 21
        Hint = '|Hold the selected Import Job'
        Caption = 'Hold'
        Enabled = False
        TabOrder = 2
        OnClick = btnHoldJobClick
      end
      object btnReleaseJob: TButton
        Left = 677
        Top = 98
        Width = 80
        Height = 21
        Hint = '|Release the selected Import Job'
        Caption = 'Release'
        Enabled = False
        TabOrder = 3
        OnClick = btnReleaseJobClick
      end
      object btnDeleteJob: TButton
        Left = 677
        Top = 123
        Width = 80
        Height = 21
        Hint = 
          '|Delete the selected Import Job from list - this does not delete' +
          ' the file from disk'
        Caption = 'Delete'
        Enabled = False
        TabOrder = 4
        OnClick = btnDeleteJobClick
      end
      object btnRunNow: TButton
        Left = 677
        Top = 149
        Width = 80
        Height = 21
        Hint = '|Run the selected Import Job immediately'
        Caption = 'Run Now'
        TabOrder = 5
        OnClick = btnRunNowClick
      end
      object edtTime: TEdit
        Left = 706
        Top = 333
        Width = 52
        Height = 22
        TabStop = False
        BevelInner = bvSpace
        BevelOuter = bvSpace
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 8
      end
      object btnJobQueue: TButton
        Left = 677
        Top = 174
        Width = 80
        Height = 21
        Hint = '|Show the Job Queue'
        Caption = 'Job Queue'
        TabOrder = 6
        OnClick = btnJobQueueClick
      end
      object btnShowLog: TButton
        Left = 677
        Top = 199
        Width = 80
        Height = 21
        Hint = '|Display Importer'#39's log file'
        Caption = 'Importer Log'
        TabOrder = 7
        OnClick = btnShowLogClick
      end
      object btnEditJob: TButton
        Left = 677
        Top = 48
        Width = 80
        Height = 21
        Hint = '|Edit the selected Import Job'
        Caption = 'Edit'
        TabOrder = 1
        OnClick = btnEditJobClick
      end
      object btnHoldAllJobs: TButton
        Left = 677
        Top = 224
        Width = 80
        Height = 21
        Hint = '|Hold the selected Import Job'
        Caption = 'Hold All'
        Enabled = False
        TabOrder = 9
        OnClick = btnHoldAllJobsClick
      end
      object btnReleaseAllJobs: TButton
        Left = 677
        Top = 250
        Width = 80
        Height = 21
        Hint = '|Release the selected Import Job'
        Caption = 'Release All'
        Enabled = False
        TabOrder = 10
        OnClick = btnReleaseAllJobsClick
      end
    end
  end
  object btnClose: TButton
    Left = 693
    Top = 386
    Width = 80
    Height = 21
    Hint = '|Close Scheduler'
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnStop: TButton
    Left = 271
    Top = 384
    Width = 80
    Height = 21
    Hint = '|Stop Scheduler and the Job Queue'
    Caption = 'Stop'
    TabOrder = 1
    OnClick = btnStopClick
  end
  object btnGo: TButton
    Left = 355
    Top = 384
    Width = 80
    Height = 21
    Hint = 
      '|Start Scheduler and the Job Queue - Import Jobs will be run at ' +
      'their scheduled date and time'
    Caption = 'Go'
    Enabled = False
    TabOrder = 2
    OnClick = btnGoClick
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 8
    Top = 381
  end
  object PopupMenu: TPopupMenu
    Left = 256
    Top = 80
    object mniEditJob: TMenuItem
      Caption = 'Edit'
      OnClick = btnEditJobClick
    end
    object mniHoldJob: TMenuItem
      Caption = 'Hold'
      OnClick = btnHoldJobClick
    end
    object mniReleaseJob: TMenuItem
      Caption = 'Release'
      OnClick = btnReleaseJobClick
    end
    object mniDeleteJob: TMenuItem
      Caption = 'Delete'
      OnClick = btnDeleteJobClick
    end
    object mniRunNow: TMenuItem
      Caption = 'Run Now'
      OnClick = btnRunNowClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniProperties: TMenuItem
      Caption = 'Properties'
      OnClick = mniPropertiesClick
    end
    object mniSaveCoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinatesClick
    end
  end
end
