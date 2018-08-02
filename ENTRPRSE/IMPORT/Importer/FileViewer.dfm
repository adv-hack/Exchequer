object frmFileViewer: TfrmFileViewer
  Left = 97
  Top = 173
  Width = 696
  Height = 480
  Caption = 'File Viewer'
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
  Visible = True
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 14
  object sb: TStatusBar
    Left = 0
    Top = 422
    Width = 680
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 581
    Top = 0
    Width = 99
    Height = 422
    Align = alRight
    BevelOuter = bvLowered
    TabOrder = 1
    object btnClose: TButton
      Left = 11
      Top = 24
      Width = 80
      Height = 21
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnEdit: TButton
      Left = 11
      Top = 48
      Width = 80
      Height = 21
      Caption = 'Edit'
      TabOrder = 1
      Visible = False
      OnClick = btnEditClick
    end
    object btnSave: TButton
      Left = 11
      Top = 72
      Width = 80
      Height = 21
      Caption = 'Save'
      TabOrder = 2
      Visible = False
    end
    object btnSaveAs: TButton
      Left = 11
      Top = 96
      Width = 80
      Height = 21
      Caption = 'Save As'
      TabOrder = 3
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 422
    Align = alClient
    TabOrder = 2
    object mlTextFile: TMultiList
      Left = 256
      Top = 164
      Width = 332
      Height = 262
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'File Contents'
          Width = 650
        end>
      TabStop = True
      OnChangeSelection = mlTextFileChangeSelection
      OnRowDblClick = mlTextFileRowDblClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
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
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 80
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
