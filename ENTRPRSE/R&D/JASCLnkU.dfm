object ShowSubCon: TShowSubCon
  Left = 225
  Top = 212
  Width = 348
  Height = 271
  BorderIcons = [biMinimize, biMaximize, biHelp]
  Caption = 'SC Linked list'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = pmSettings
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    340
    237)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 329
    Height = 36
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'This Supplier is linked to the following Sub Contractor Employee' +
      ' Records:- '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnCancel: TButton
    Left = 170
    Top = 216
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object mlSubContractors: TDBMultiList
    Left = 8
    Top = 48
    Width = 323
    Height = 161
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Sub Contractor'
        Field = 'S'
        Searchable = True
        Sortable = True
        Width = 95
        IndexNo = 2
      end
      item
        Caption = 'Name'
        Field = 'N'
        Width = 190
      end>
    TabStop = True
    OnRowDblClick = mlSubContractorsRowDblClick
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
    Dataset = bdsSubContractors
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object btnView: TButton
    Left = 82
    Top = 216
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&View'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnViewClick
  end
  object bdsSubContractors: TBTGlobalDataset
    SearchKey = 'JE'
    OnGetFieldValue = bdsSubContractorsGetFieldValue
    OnGetFileVar = bdsSubContractorsGetFileVar
    OnGetDataRecord = bdsSubContractorsGetDataRecord
    OnGetBufferSize = bdsSubContractorsGetBufferSize
    Left = 16
    Top = 72
  end
  object pmSettings: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmSettingsPopup
    Left = 11
    Top = 215
    object popFormProperties: TMenuItem
      Caption = 'Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miSaveCoordinates: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = miSaveCoordinatesClick
    end
  end
end
