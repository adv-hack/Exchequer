object frmBankDetails: TfrmBankDetails
  Left = 197
  Top = 249
  Width = 479
  Height = 419
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
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 471
    Height = 385
    ActivePage = tabDefaults
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabDefaults: TTabSheet
      Caption = '&Defaults'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 0
        Width = 345
        Height = 153
        Caption = 'Account Details '
        TabOrder = 0
        object Label1: TLabel
          Left = 32
          Top = 28
          Width = 68
          Height = 14
          Alignment = taRightJustify
          Caption = 'Bank Account'
        end
        object Label2: TLabel
          Left = 36
          Top = 60
          Width = 64
          Height = 14
          Alignment = taRightJustify
          Caption = 'Bank Product'
        end
        object Label3: TLabel
          Left = 52
          Top = 92
          Width = 48
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sort Code'
        end
        object Label4: TLabel
          Left = 43
          Top = 124
          Width = 57
          Height = 14
          Alignment = taRightJustify
          Caption = 'Account No'
        end
        object cbProduct: TSBSComboBox
          Left = 112
          Top = 56
          Width = 121
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 2
          MaxListWidth = 0
        end
        object edtGLDesc: TEdit
          Left = 208
          Top = 24
          Width = 121
          Height = 22
          TabStop = False
          TabOrder = 1
        end
        object edtSortCode: TEdit
          Left = 112
          Top = 88
          Width = 121
          Height = 22
          TabOrder = 3
        end
        object edtAcNo: TEdit
          Left = 112
          Top = 120
          Width = 121
          Height = 22
          TabOrder = 4
        end
        object edtGLCode: TEdit
          Left = 112
          Top = 24
          Width = 89
          Height = 22
          TabOrder = 0
          OnExit = edtGLCodeExit
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 154
        Width = 345
        Height = 129
        Caption = 'Files '
        TabOrder = 1
        object Label5: TLabel
          Left = 7
          Top = 20
          Width = 92
          Height = 14
          Alignment = taRightJustify
          Caption = 'Payments Filename'
        end
        object Label6: TLabel
          Left = 12
          Top = 52
          Width = 87
          Height = 14
          Alignment = taRightJustify
          Caption = 'Receipts Filename'
        end
        object Label7: TLabel
          Left = 43
          Top = 84
          Width = 56
          Height = 14
          Alignment = taRightJustify
          Caption = 'Output Path'
        end
        object btnOutPathBrowse: TSpeedButton
          Left = 296
          Top = 80
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = btnOutPathBrowseClick
        end
        object edtPayFile: TEdit
          Left = 112
          Top = 16
          Width = 121
          Height = 22
          TabOrder = 0
        end
        object edtRecFile: TEdit
          Left = 112
          Top = 48
          Width = 121
          Height = 22
          TabOrder = 1
        end
        object edtOutputPath: TEdit
          Left = 112
          Top = 80
          Width = 185
          Height = 22
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 286
        Width = 345
        Height = 67
        Caption = 'Statements '
        TabOrder = 2
        object Label8: TLabel
          Left = 7
          Top = 28
          Width = 91
          Height = 14
          Alignment = taRightJustify
          Caption = 'Statement File Path'
        end
        object btnStatementBrowse: TSpeedButton
          Left = 296
          Top = 24
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = btnStatementBrowseClick
        end
        object edtStatementPath: TEdit
          Left = 112
          Top = 24
          Width = 185
          Height = 22
          TabOrder = 0
        end
      end
      object pnlDefaults: TPanel
        Left = 360
        Top = 0
        Width = 103
        Height = 353
        BevelInner = bvLowered
        BevelOuter = bvLowered
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
          Top = 40
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
        Left = 8
        Top = 0
        Width = 345
        Height = 353
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Date'
            Width = 55
          end
          item
            Caption = 'Reference'
            Width = 90
          end
          item
            Caption = 'Status'
            Width = 80
          end
          item
            Caption = 'Balance'
            Width = 80
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
      object pnlStatements: TPanel
        Left = 358
        Top = 0
        Width = 107
        Height = 353
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 1
        object SBSButton1: TSBSButton
          Left = 8
          Top = 16
          Width = 80
          Height = 21
          Caption = '&Close'
          TabOrder = 0
          OnClick = SBSButton1Click
          TextId = 0
        end
        object SBSButton2: TSBSButton
          Left = 8
          Top = 56
          Width = 80
          Height = 21
          Caption = '&Import'
          TabOrder = 1
          TextId = 0
        end
        object SBSButton3: TSBSButton
          Left = 8
          Top = 80
          Width = 80
          Height = 21
          Caption = '&Reconcile'
          TabOrder = 2
          TextId = 0
        end
        object SBSButton4: TSBSButton
          Left = 8
          Top = 104
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 3
          TextId = 0
        end
        object SBSButton5: TSBSButton
          Left = 8
          Top = 128
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
    Version = 'TEnterToTab v1.01 for Delphi 6.01'
    Left = 464
    Top = 400
  end
end
