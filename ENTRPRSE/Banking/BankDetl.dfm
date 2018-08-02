object frmBankDetails: TfrmBankDetails
  Left = 76
  Top = 220
  Width = 471
  Height = 423
  HelpContext = 1958
  Caption = 'Bank Account Details'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 216
    Top = 8
    Width = 32
    Height = 14
    Caption = 'Label4'
  end
  object pgDetails: TPageControl
    Left = 0
    Top = 0
    Width = 455
    Height = 384
    HelpContext = 1980
    ActivePage = tabStatements
    Align = alClient
    TabIndex = 1
    TabOrder = 0
    TabStop = False
    OnChange = pgDetailsChange
    object tabDefaults: TTabSheet
      Caption = '&Defaults'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 345
        Height = 193
        Caption = 'Account Details '
        PopupMenu = PopupMenu1
        TabOrder = 0
        object Label1: TLabel
          Left = 49
          Top = 20
          Width = 67
          Height = 14
          Alignment = taRightJustify
          Caption = 'Bank Account'
        end
        object Label2: TLabel
          Left = 52
          Top = 44
          Width = 64
          Height = 14
          Alignment = taRightJustify
          Caption = 'Bank Product'
        end
        object Label3: TLabel
          Left = 43
          Top = 68
          Width = 73
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sort Code / BIC'
        end
        object Label9: TLabel
          Left = 65
          Top = 116
          Width = 51
          Height = 14
          Alignment = taRightJustify
          Caption = 'Reference'
        end
        object Label10: TLabel
          Left = 81
          Top = 140
          Width = 35
          Height = 14
          Alignment = taRightJustify
          Caption = 'User ID'
        end
        object Label11: TLabel
          Left = 19
          Top = 162
          Width = 97
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User ID (Receipts)'
          WordWrap = True
        end
        object Label12: TLabel
          Left = 26
          Top = 92
          Width = 90
          Height = 14
          Alignment = taRightJustify
          Caption = 'Account No / IBAN'
        end
        object cbProduct: TSBSComboBox
          Left = 120
          Top = 40
          Width = 121
          Height = 22
          HelpContext = 1960
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 0
          ParentFont = False
          TabOrder = 2
          MaxListWidth = 0
        end
        object edtGLDesc: TEdit
          Left = 196
          Top = 16
          Width = 133
          Height = 22
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtSortCode: TEdit
          Left = 120
          Top = 64
          Width = 121
          Height = 22
          HelpContext = 1961
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          TabOrder = 3
        end
        object edtAcNo: TEdit
          Left = 120
          Top = 88
          Width = 209
          Height = 22
          HelpContext = 1961
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 35
          ParentFont = False
          TabOrder = 4
        end
        object edtGLCode: TEdit
          Left = 120
          Top = 16
          Width = 73
          Height = 22
          HelpContext = 1959
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnExit = edtGLCodeExit
        end
        object edtRef: TEdit
          Left = 120
          Top = 112
          Width = 209
          Height = 22
          HelpContext = 1962
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edtUserID: TEdit
          Left = 120
          Top = 136
          Width = 201
          Height = 22
          HelpContext = 1963
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 35
          ParentFont = False
          TabOrder = 6
        end
        object edtRecUserID: TEdit
          Left = 120
          Top = 160
          Width = 201
          Height = 22
          HelpContext = 1963
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 35
          ParentFont = False
          TabOrder = 7
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 194
        Width = 345
        Height = 103
        Caption = 'Files '
        PopupMenu = PopupMenu1
        TabOrder = 1
        object Label5: TLabel
          Left = 23
          Top = 20
          Width = 92
          Height = 14
          Alignment = taRightJustify
          Caption = 'Payments Filename'
        end
        object Label6: TLabel
          Left = 28
          Top = 44
          Width = 87
          Height = 14
          Alignment = taRightJustify
          Caption = 'Receipts Filename'
        end
        object Label7: TLabel
          Left = 59
          Top = 68
          Width = 56
          Height = 14
          Alignment = taRightJustify
          Caption = 'Output Path'
        end
        object edtPayFile: TEdit
          Left = 120
          Top = 16
          Width = 121
          Height = 22
          HelpContext = 1964
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 12
          ParentFont = False
          TabOrder = 0
        end
        object edtRecFile: TEdit
          Left = 120
          Top = 40
          Width = 121
          Height = 22
          HelpContext = 1965
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 12
          ParentFont = False
          TabOrder = 1
        end
        object edtOutputPath: TEdit
          Left = 120
          Top = 64
          Width = 185
          Height = 22
          HelpContext = 1966
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object SBSButton6: TSBSButton
          Left = 304
          Top = 64
          Width = 23
          Height = 23
          Caption = '...'
          TabOrder = 3
          OnClick = SBSButton6Click
          TextId = 0
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 298
        Width = 345
        Height = 55
        Caption = 'Statements '
        PopupMenu = PopupMenu1
        TabOrder = 2
        object Label8: TLabel
          Left = 23
          Top = 20
          Width = 91
          Height = 14
          Alignment = taRightJustify
          Caption = 'Statement File Path'
        end
        object edtStatementPath: TEdit
          Left = 120
          Top = 16
          Width = 185
          Height = 22
          HelpContext = 1967
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object SBSButton7: TSBSButton
          Left = 304
          Top = 16
          Width = 23
          Height = 23
          Caption = '...'
          TabOrder = 1
          OnClick = SBSButton7Click
          TextId = 0
        end
      end
      object pnlDefaults: TPanel
        Left = 352
        Top = 0
        Width = 103
        Height = 329
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 3
        object btnOK: TSBSButton
          Left = 9
          Top = 8
          Width = 80
          Height = 21
          Hint = 'Store the record'
          HelpContext = 1968
          Caption = '&OK'
          TabOrder = 0
          OnClick = btnOKClick
          TextId = 0
        end
        object btnCancel: TSBSButton
          Left = 9
          Top = 32
          Width = 80
          Height = 21
          Hint = 'Cancel record changes'
          HelpContext = 1969
          Cancel = True
          Caption = '&Cancel'
          TabOrder = 1
          OnClick = btnCancelClick
          TextId = 0
        end
        object btnClose: TSBSButton
          Left = 9
          Top = 56
          Width = 80
          Height = 21
          Hint = 'Close this window'
          HelpContext = 1970
          Caption = '&Close'
          TabOrder = 2
          OnClick = btnCloseClick
          TextId = 0
        end
        object btnEdit: TSBSButton
          Left = 9
          Top = 120
          Width = 80
          Height = 21
          Hint = 'Edit current record'
          HelpContext = 1972
          Caption = '&Edit'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnEditClick
          TextId = 0
        end
        object btnAdd: TSBSButton
          Left = 9
          Top = 96
          Width = 80
          Height = 21
          Hint = 'Add a new record'
          HelpContext = 1971
          Caption = '&Add'
          TabOrder = 4
          OnClick = btnAddClick
          TextId = 0
        end
      end
    end
    object tabStatements: TTabSheet
      Caption = '&Statements'
      ImageIndex = 1
      object pnlStatements: TPanel
        Left = 350
        Top = 0
        Width = 103
        Height = 305
        BevelOuter = bvNone
        PopupMenu = PopupMenu2
        TabOrder = 1
        object btnClose2: TSBSButton
          Left = 8
          Top = 8
          Width = 80
          Height = 21
          Hint = 'Close this window'
          HelpContext = 1985
          Cancel = True
          Caption = '&Close'
          TabOrder = 0
          OnClick = btnClose2Click
          TextId = 0
        end
        object btnImport: TSBSButton
          Left = 8
          Top = 48
          Width = 80
          Height = 21
          Hint = 'Import statements'
          HelpContext = 1986
          Caption = '&Import'
          TabOrder = 1
          OnClick = btnImportClick
          TextId = 0
        end
        object btnReconcile: TSBSButton
          Left = 8
          Top = 72
          Width = 80
          Height = 21
          Hint = 'Reconcile the selected statement'
          HelpContext = 1987
          Caption = '&Reconcile'
          TabOrder = 2
          OnClick = btnReconcileClick
          TextId = 0
        end
        object btnDelete: TSBSButton
          Left = 8
          Top = 96
          Width = 80
          Height = 21
          Hint = 'Delete the selected statement'
          HelpContext = 1988
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnDeleteClick
          TextId = 0
        end
        object btnPrint: TSBSButton
          Left = 8
          Top = 120
          Width = 80
          Height = 21
          Hint = 'Print the selected statement'
          HelpContext = 1989
          Caption = '&Print'
          TabOrder = 4
          OnClick = btnPrintClick
          TextId = 0
        end
      end
      object mlStatements: TDBMultiList
        Left = 4
        Top = 3
        Width = 341
        Height = 342
        HelpContext = 1980
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
            Width = 68
          end
          item
            Caption = 'Reference'
            Color = clWhite
            Field = 'R'
            Searchable = True
            Sortable = True
            Width = 90
            IndexNo = 1
          end
          item
            Caption = 'Status'
            Color = clWhite
            DataType = dtInteger
            Field = 'S'
            Searchable = True
            Sortable = True
            Width = 60
            IndexNo = 2
          end
          item
            Alignment = taRightJustify
            Caption = 'Balance'
            Color = clWhite
            DataType = dtFloat
            Field = 'B'
            Width = 80
          end
          item
            Caption = 'Folio'
            Color = clWhite
            Field = 'F'
            Searchable = True
            Sortable = True
            Visible = False
          end>
        TabStop = True
        OnColumnClick = mlStatementsColumnClick
        OnRowDblClick = mlStatementsRowDblClick
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
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
        Dataset = ctkStatements
        OnAfterLoad = mlStatementsAfterLoad
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 464
    Top = 400
  end
  object PopupMenu1: TPopupMenu
    Left = 368
    Top = 264
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      Caption = 'Save Coordinates'
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 400
    Top = 264
    object Import1: TMenuItem
      Caption = '&Import'
    end
    object Reconcile1: TMenuItem
      Caption = '&Reconcile'
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
    end
    object Print1: TMenuItem
      Caption = '&Print'
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Properties2: TMenuItem
      Caption = '&Properties'
      OnClick = Properties2Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates2: TMenuItem
      AutoCheck = True
      Caption = 'Sa&ve Coordinates'
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Left = 432
    Top = 264
  end
  object ctkStatements: TComTKDataset
    OnFilterRecord = ctkStatementsFilterRecord
    OnGetFieldValue = ctkStatementsGetFieldValue
    OnSelectRecord = ctkStatementsSelectRecord
    Left = 424
    Top = 224
  end
end
