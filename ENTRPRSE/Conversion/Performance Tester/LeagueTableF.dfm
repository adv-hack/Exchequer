object frmLeagueTable: TfrmLeagueTable
  Left = 364
  Top = 216
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'League Table'
  ClientHeight = 346
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object mulLeagueTable: TMultiList
    Left = 8
    Top = 8
    Width = 370
    Height = 301
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Computer'
        Field = '1'
        Width = 220
      end
      item
        Caption = 'Time (Secs)'
        DataType = dtFloat
        Field = '2'
      end
      item
        Caption = 'IntTime'
        Visible = False
      end>
    TabStop = True
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
  object btnClose: TButton
    Left = 153
    Top = 317
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
end
