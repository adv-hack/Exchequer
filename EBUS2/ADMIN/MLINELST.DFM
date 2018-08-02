object frmLineList: TfrmLineList
  Left = 102
  Top = 110
  Width = 806
  Height = 275
  BorderIcons = [biSystemMenu]
  Caption = 'Possible matches'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    798
    248)
  PixelsPerInch = 96
  TextHeight = 13
  object mlLines: TMultiList
    Left = 8
    Top = 8
    Width = 681
    Height = 233
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Our Ref'
        Color = clTeal
        Field = 'OurRef'
        Sortable = True
        Width = 70
      end
      item
        Caption = 'Stock Code'
        Color = clTeal
        Field = 'StockCode'
        Sortable = True
        Width = 120
      end
      item
        Caption = 'Description'
        Color = clTeal
        Field = 'Description'
        Sortable = True
        Width = 199
      end
      item
        Caption = 'Date'
        Color = clTeal
        Field = 'Date'
        Sortable = True
        Width = 64
      end
      item
        Alignment = taRightJustify
        Caption = 'Qty '
        Color = clTeal
        Field = 'Qty'
        Sortable = True
        Width = 53
      end
      item
        Alignment = taRightJustify
        Caption = 'Value '
        Color = clTeal
        Field = 'Value'
        Sortable = True
        Width = 53
      end
      item
        Caption = 'Supplier'
        Color = clTeal
        Field = 'Supplier'
        Sortable = True
        Width = 61
      end>
    TabStop = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
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
    Left = 696
    Top = 8
    Width = 97
    Height = 233
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 1
    object Button1: TButton
      Left = 7
      Top = 8
      Width = 80
      Height = 21
      Caption = '&Match'
      ModalResult = 1
      TabOrder = 0
    end
    object Button3: TButton
      Left = 7
      Top = 36
      Width = 80
      Height = 21
      Caption = '&Options'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 7
      Top = 64
      Width = 80
      Height = 21
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
