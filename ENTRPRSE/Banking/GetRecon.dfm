object frmSelectReconcile: TfrmSelectReconcile
  Left = 256
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Select Reconciliation'
  ClientHeight = 265
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 265
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object mlRec: TDBMultiList
      Left = 0
      Top = 0
      Width = 367
      Height = 265
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Date'
          Color = clWhite
          DataType = dtDate
          Field = 'D'
          Searchable = True
          Sortable = True
          Width = 70
          IndexNo = 1
        end
        item
          Caption = 'Reference'
          Color = clWhite
          Field = 'R'
          Searchable = True
          Sortable = True
          Width = 152
        end
        item
          Caption = 'Reconciled By'
          Color = clWhite
          Field = 'U'
        end>
      TabStop = True
      OnRowDblClick = mlRecRowDblClick
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
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
      HighlightFont.Name = 'MS Sans Serif'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
      Dataset = btdRec
      OnAfterLoad = mlRecAfterLoad
      Active = False
      SortColIndex = 0
      SortAsc = False
    end
    object Panel3: TPanel
      Left = 374
      Top = 0
      Width = 106
      Height = 265
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnDelete: TSBSButton
        Left = 8
        Top = 96
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 0
        OnClick = btnDeleteClick
        TextId = 0
      end
      object btnOK: TSBSButton
        Left = 10
        Top = 20
        Width = 80
        Height = 21
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 1
        TextId = 0
      end
      object btnCancel: TSBSButton
        Left = 10
        Top = 44
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 2
        TextId = 0
      end
    end
  end
  object btdRec: TBtrieveDataset
    OnFilterRecord = btdRecFilterRecord
    OnGetFieldValue = btdRecGetFieldValue
    Left = 224
    Top = 168
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 168
    object Properties1: TMenuItem
      Caption = 'Properties'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      Caption = 'Save Coordinates'
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 88
    Top = 200
  end
end
