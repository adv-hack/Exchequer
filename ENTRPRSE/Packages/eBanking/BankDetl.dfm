object frmBankDetails: TfrmBankDetails
  Left = 368
  Top = 210
  Width = 471
  Height = 347
  Caption = 'Bank Account Details'
  Color = clBtnFace
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
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object pgDetails: TPageControl
    Left = 0
    Top = 0
    Width = 463
    Height = 313
    ActivePage = tabDefaults
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    OnChange = pgDetailsChange
    object tabDefaults: TTabSheet
      Caption = '&Defaults'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 345
        Height = 121
        Caption = 'Account Details '
        PopupMenu = PopupMenu1
        TabOrder = 0
        object Label1: TLabel
          Left = 48
          Top = 20
          Width = 68
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
          Left = 68
          Top = 68
          Width = 48
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sort Code'
        end
        object Label4: TLabel
          Left = 59
          Top = 92
          Width = 57
          Height = 14
          Alignment = taRightJustify
          Caption = 'Account No'
        end
        object cbProduct: TSBSComboBox
          Left = 120
          Top = 40
          Width = 121
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
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
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
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
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object edtAcNo: TEdit
          Left = 120
          Top = 88
          Width = 121
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object edtGLCode: TEdit
          Left = 120
          Top = 16
          Width = 73
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnExit = edtGLCodeExit
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 122
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
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtRecFile: TEdit
          Left = 120
          Top = 40
          Width = 121
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtOutputPath: TEdit
          Left = 120
          Top = 64
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
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
        Top = 226
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
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
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
        Height = 281
        BevelInner = bvLowered
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 3
        object btnOK: TSBSButton
          Left = 9
          Top = 8
          Width = 80
          Height = 21
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
          Cancel = True
          Caption = '&Cancel'
          TabOrder = 1
          OnClick = btnCancelClick
          TextId = 0
        end
      end
    end
    object tabStatements: TTabSheet
      Caption = '&Statements'
      ImageIndex = 1
      object mlStatements: TMultiList
        Left = 0
        Top = 0
        Width = 345
        Height = 281
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Date'
            Color = clGreen
            Width = 55
          end
          item
            Caption = 'Reference'
            Color = clGreen
            Width = 90
          end
          item
            Caption = 'Status'
            Color = clGreen
            Width = 80
          end
          item
            Caption = 'Balance'
            Color = clGreen
            Width = 80
          end>
        TabStop = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        PopupMenu = PopupMenu2
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
      object pnlStatements: TPanel
        Left = 350
        Top = 0
        Width = 107
        Height = 281
        BevelInner = bvLowered
        BevelOuter = bvLowered
        PopupMenu = PopupMenu2
        TabOrder = 1
        object SBSButton1: TSBSButton
          Left = 8
          Top = 8
          Width = 80
          Height = 21
          Caption = '&Close'
          TabOrder = 0
          OnClick = SBSButton1Click
          TextId = 0
        end
        object SBSButton2: TSBSButton
          Left = 8
          Top = 48
          Width = 80
          Height = 21
          Caption = '&Import'
          TabOrder = 1
          TextId = 0
        end
        object SBSButton3: TSBSButton
          Left = 8
          Top = 72
          Width = 80
          Height = 21
          Caption = '&Reconcile'
          TabOrder = 2
          TextId = 0
        end
        object SBSButton4: TSBSButton
          Left = 8
          Top = 96
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 3
          TextId = 0
        end
        object SBSButton5: TSBSButton
          Left = 8
          Top = 120
          Width = 80
          Height = 21
          Caption = '&Print'
          TabOrder = 4
          TextId = 0
        end
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
end
