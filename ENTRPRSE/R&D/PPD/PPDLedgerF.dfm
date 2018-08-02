object frmPPDLedger: TfrmPPDLedger
  Left = 75
  Top = 225
  Width = 1089
  Height = 264
  HelpContext = 2211
  Caption = 'PPD Ledger for ABAP01'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object lblFind: TLabel
    Left = 722
    Top = 186
    Width = 45
    Height = 14
    Caption = 'Find Next'
  end
  object lvTransactions: TListView
    Left = 5
    Top = 17
    Width = 974
    Height = 164
    Checkboxes = True
    Color = clWhite
    Columns = <
      item
        Caption = 'OurRef'
        Width = 90
      end
      item
        Caption = 'Date'
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'Amount Settled'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Outstanding'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Total Value'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Original Value'
        Width = 100
      end
      item
        Caption = 'Your Ref'
        Width = 70
      end
      item
        Caption = 'Date Due'
        Width = 75
      end
      item
        Caption = 'Status'
        Width = 55
      end
      item
        Alignment = taRightJustify
        Caption = 'PPD Value'
        Width = 95
      end
      item
        Caption = 'PPD Expiry'
        Width = 85
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = lvTransactionsAdvancedCustomDrawItem
    OnColumnDragged = lvTransactionsColumnDragged
    OnCustomDrawItem = lvTransactionsCustomDrawItem
    OnCustomDrawSubItem = lvTransactionsCustomDrawSubItem
    OnDblClick = btnViewInvoiceClick
    OnSelectItem = lvTransactionsSelectItem
  end
  object btnGivePPD: TButton
    Left = 985
    Top = 38
    Width = 80
    Height = 21
    Caption = 'Give &PPD'
    Enabled = False
    TabOrder = 2
    OnClick = btnGivePPDClick
  end
  object btnClose: TButton
    Left = 985
    Top = 62
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnTagInvoice: TButton
    Left = 985
    Top = 97
    Width = 80
    Height = 21
    Caption = '&Tag Invoice'
    TabOrder = 4
    OnClick = btnTagInvoiceClick
  end
  object lstTransactionIndex: TComboBox
    Left = 3
    Top = 183
    Width = 265
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 6
    OnClick = lstTransactionIndexClick
    Items.Strings = (
      '')
  end
  object edtFind: TEdit
    Left = 771
    Top = 183
    Width = 127
    Height = 22
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object btnFind: TButton
    Left = 899
    Top = 183
    Width = 80
    Height = 21
    Caption = '&Find'
    TabOrder = 8
    OnClick = btnFindClick
  end
  object btnViewInvoice: TButton
    Left = 985
    Top = 121
    Width = 80
    Height = 21
    Caption = '&View Invoice'
    TabOrder = 5
    OnClick = btnViewInvoiceClick
  end
  object panProgress: TPanel
    Left = 237
    Top = 66
    Width = 555
    Height = 78
    BevelOuter = bvNone
    Caption = 'Please wait, finding qualifying transactions...'
    TabOrder = 1
    Visible = False
  end
  object panHeader: TPanel
    Left = 5
    Top = 0
    Width = 974
    Height = 17
    BevelOuter = bvNone
    TabOrder = 9
    object imgCheckBox: TImage
      Left = 0
      Top = 0
      Width = 28
      Height = 15
      Picture.Data = {
        07544269746D6170AA040000424DAA0400000000000036000000280000001900
        00000F000000010018000000000074040000C40E0000C40E0000000000000000
        00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FFFF0000FF6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F
        6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6F
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000
        FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF728281667976
        0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF
        0000FF6B7D7C000B0800140C6D85790000FF0000FFFF0000FF6F6F6FFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F
        0000FF0000FF0000FF0000FF6F818204171463786F6C837500150672867A0000
        FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF6A797C0010116377720000
        FF0000FF7287780010046E8081FF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000
        FF7382856E80810000FF0000FF0000FF0000FF72827B6B7F80FF0000FF6F6F6F
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FFFF0000FF6F6F6FFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6F0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF0000
        FF6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F
        6F6F6F6F6F6F6F6F0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF}
      Transparent = True
      OnClick = imgCheckBoxClick
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 1029
    Top = 152
  end
  object PopupMenu1: TPopupMenu
    Left = 988
    Top = 150
    object mnuoptGivePPD: TMenuItem
      Caption = 'Give &PPD'
      OnClick = btnGivePPDClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuoptTagInvoice: TMenuItem
      Caption = '&Tag Invoice'
      OnClick = btnTagInvoiceClick
    end
    object mnuOptViewInvoice: TMenuItem
      Caption = '&View Invoice'
      OnClick = btnViewInvoiceClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
    end
  end
  object pmHeader: TPopupMenu
    Left = 992
    Top = 184
    object agAll1: TMenuItem
      Action = aTagAll
    end
    object UntagAll1: TMenuItem
      Action = aUntagAll
    end
  end
  object alMain: TActionList
    Left = 1032
    Top = 184
    object aTagAll: TAction
      Caption = '&Tag All'
      OnExecute = aTagAllExecute
    end
    object aUntagAll: TAction
      Caption = '&Untag All'
      OnExecute = aUntagAllExecute
    end
  end
end
