object frmEbusMatchList: TfrmEbusMatchList
  Left = 41
  Top = 164
  Width = 589
  Height = 262
  BorderIcons = [biSystemMenu]
  Caption = 'Unmatched invoice lines'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    581
    235)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 465
    Height = 41
    AutoSize = False
    Caption = 
      'It was not possible to identify the orders or delivery notes for' +
      ' these lines. To show possible matches for a selected line, clic' +
      'k on the Show Matches button (or double click the line.)'
    WordWrap = True
  end
  object mlUD: TMultiList
    Left = 8
    Top = 48
    Width = 470
    Height = 185
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Stock Code'
        Color = clTeal
        Width = 124
      end
      item
        Caption = 'Description'
        Color = clTeal
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Qty '
        Color = clTeal
        Width = 45
      end
      item
        Alignment = taRightJustify
        Caption = 'Value '
        Color = clTeal
        Width = 52
      end>
    TabStop = True
    OnRowDblClick = mlUDRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
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
  end
  object Panel1: TPanel
    Left = 484
    Top = 48
    Width = 93
    Height = 185
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 1
    object Button1: TButton
      Left = 4
      Top = 8
      Width = 80
      Height = 21
      Caption = 'Show &Matches'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 4
      Top = 32
      Width = 80
      Height = 21
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
