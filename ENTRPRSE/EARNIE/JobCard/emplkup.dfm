object frmEmpLookup: TfrmEmpLookup
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Employees'
  ClientHeight = 245
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mlEmp: TDBMultiList
    Left = 8
    Top = 8
    Width = 289
    Height = 201
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Code'
        Field = 'C'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Name'
        Field = 'N'
        Width = 151
      end>
    TabStop = True
    OnRowDblClick = mlEmpRowDblClick
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
    Dataset = dsEmp
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object btnOK: TSBSButton
    Left = 58
    Top = 216
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 162
    Top = 216
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object dsEmp: TComTKDataset
    OnGetFieldValue = dsEmpGetFieldValue
    Left = 16
    Top = 32
  end
end
