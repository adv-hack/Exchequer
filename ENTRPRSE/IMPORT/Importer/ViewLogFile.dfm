object frmViewLogFile: TfrmViewLogFile
  Left = 34
  Top = 144
  Width = 743
  Height = 480
  HelpContext = 12
  Caption = 'View Log Files'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 735
    Height = 417
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 242
      Top = 16
      Width = 3
      Height = 399
      Cursor = crHSplit
    end
    object Panel1: TPanel
      Left = 2
      Top = 16
      Width = 240
      Height = 399
      Align = alLeft
      TabOrder = 0
      object mlLogFiles: TMultiList
        Left = 1
        Top = 1
        Width = 238
        Height = 397
        Hint = '|Double-click on a log file to display its contents'
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Log Files'
            Field = 'LogFile'
            Searchable = True
            Sortable = True
            Width = 300
          end>
        TabStop = True
        OnRowDblClick = mlLogFilesRowDblClick
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        PopupMenu = PopupMenu1
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
    object mlLogFile: TMultiList
      Left = 245
      Top = 16
      Width = 488
      Height = 399
      Hint = 
        '|If a row number is displayed, double-click on it to view the da' +
        'ta'
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Log File Contents'
          Width = 850
        end>
      TabStop = True
      OnRowDblClick = mlLogFileRowDblClick
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      PopupMenu = PopupMenu2
      TabOrder = 1
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Courier New'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 417
    Width = 735
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      735
      29)
    object btnClose: TButton
      Left = 649
      Top = 4
      Width = 80
      Height = 21
      Hint = '|Close this window'
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnRefresh: TButton
      Left = 5
      Top = 4
      Width = 80
      Height = 21
      Hint = '|Refresh the list of log files'
      Anchors = [akLeft, akBottom]
      Caption = 'Refresh'
      TabOrder = 1
      OnClick = btnRefreshClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 128
    object mniProperties1: TMenuItem
      Caption = 'Properties'
      OnClick = mniProperties1Click
    end
    object mniSaveCoordinates1: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinates1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 388
    Top = 128
    object mniProperties2: TMenuItem
      Caption = 'Properties'
      OnClick = mniProperties2Click
    end
    object mniSaveCoordinates2: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = mniSaveCoordinates2Click
    end
  end
end
