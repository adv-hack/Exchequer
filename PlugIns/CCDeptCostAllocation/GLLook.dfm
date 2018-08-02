object frmGLLookup: TfrmGLLookup
  Left = 245
  Top = 203
  BorderStyle = bsDialog
  Caption = 'Select a General Ledger Code'
  ClientHeight = 280
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 257
    Height = 265
    Caption = 'General Ledger Codes  '
    TabOrder = 0
    object mlGL: TMultiList
      Left = 8
      Top = 16
      Width = 241
      Height = 241
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Code'
          Width = 60
        end
        item
          Caption = 'Name'
          Width = 142
        end>
      TabStop = True
      OnRowDblClick = mlGLRowDblClick
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
      Version = 'v1.12'
    end
  end
  object btnOK: TSBSButton
    Left = 272
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 272
    Top = 40
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = SBSButton2Click
    TextId = 0
  end
end
