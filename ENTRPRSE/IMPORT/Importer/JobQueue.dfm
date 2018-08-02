object frmJobQueue: TfrmJobQueue
  Left = 277
  Top = 156
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Import Job Queue'
  ClientHeight = 416
  ClientWidth = 473
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl: TPageControl
    Left = 7
    Top = 12
    Width = 459
    Height = 373
    ActivePage = tsSettings
    TabOrder = 0
    object tsSettings: TTabSheet
      Caption = 'Job Settings'
      ImageIndex = 1
      TabVisible = False
      object gbSettings: TGroupBox
        Left = 9
        Top = 3
        Width = 352
        Height = 350
        Caption = 'List of Import Jobs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object mlJobQueue: TMultiList
          Left = 8
          Top = 24
          Width = 333
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
              Caption = 'Job No.'
              Field = 'JobNo'
              Width = 50
            end
            item
              Alignment = taRightJustify
              Caption = 'File No.'
              Field = 'FileNo'
              Width = 50
            end
            item
              Caption = 'Status'
              Width = 50
            end
            item
              Caption = 'File Name'
              Field = 'FileName'
              Width = 200
            end
            item
              Caption = 'Job File'
              Field = 'JobFile'
              Width = 70
            end
            item
              Caption = 'LogFileName'
              Visible = False
            end
            item
              Caption = 'Previous Status'
              Visible = False
            end>
          TabStop = True
          OnChangeSelection = mlJobQueueChangeSelection
          OnRowDblClick = mlJobQueueRowDblClick
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
        Left = 367
        Top = 47
        Width = 80
        Height = 21
        Hint = '|Hold all the Import Jobs for the selected Job No.'
        Caption = 'Hold'
        Enabled = False
        TabOrder = 1
        OnClick = btnHoldJobClick
      end
      object btnReleaseJob: TButton
        Left = 367
        Top = 72
        Width = 80
        Height = 21
        Hint = '|Release all the Import Jobs for the selected Job No.'
        Caption = 'Release'
        Enabled = False
        TabOrder = 2
        OnClick = btnReleaseJobClick
      end
      object btnDeleteJob: TButton
        Left = 367
        Top = 97
        Width = 80
        Height = 21
        Hint = '|Delete all the Import Jobs for the selected Job No.'
        Caption = 'Delete'
        Enabled = False
        TabOrder = 3
        OnClick = btnDeleteJobClick
      end
      object btnDeleteAllJobs: TButton
        Left = 367
        Top = 122
        Width = 80
        Height = 21
        Hint = '|Delete all Import Jobs from the Job Queue'
        Caption = 'Delete All'
        Enabled = False
        TabOrder = 4
        OnClick = btnDeleteAllJobsClick
      end
    end
  end
  object btnStop: TButton
    Left = 153
    Top = 390
    Width = 80
    Height = 21
    Hint = '|Stop Scheduler and the Job Queue'
    Caption = 'Stop'
    Enabled = False
    TabOrder = 1
    OnClick = btnStopClick
  end
  object btnGo: TButton
    Left = 241
    Top = 390
    Width = 80
    Height = 21
    Hint = '|Start Scheduler and the Job Queue'
    Caption = 'Go'
    TabOrder = 2
    OnClick = btnGoClick
  end
  object btnClose: TButton
    Left = 384
    Top = 390
    Width = 80
    Height = 21
    Hint = '|Close the Job Queue'
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object PopupMenu: TPopupMenu
    Left = 144
    Top = 140
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
