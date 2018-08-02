object frmJobLineDrill: TfrmJobLineDrill
  Left = 489
  Top = 339
  Width = 638
  Height = 393
  Caption = 'Exchequer GL Job History Drill-Down'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupMenu
  Position = poDefaultPosOnly
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 622
    Height = 73
    Align = alTop
    Pen.Style = psClear
  end
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 55
    Height = 14
    Caption = 'Company:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 4
    Top = 20
    Width = 50
    Height = 14
    Caption = 'GL Code:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 4
    Top = 36
    Width = 32
    Height = 14
    Caption = 'From:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 4
    Top = 52
    Width = 16
    Height = 14
    Caption = 'To:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblCompany: TLabel
    Left = 68
    Top = 4
    Width = 55
    Height = 14
    Caption = 'lblCompany'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblGLCode: TLabel
    Left = 68
    Top = 20
    Width = 49
    Height = 14
    Caption = 'lblGLCode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblFrom: TLabel
    Left = 68
    Top = 36
    Width = 34
    Height = 14
    Caption = 'lblFrom'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblTo: TLabel
    Left = 68
    Top = 52
    Width = 21
    Height = 14
    Caption = 'lblTo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 164
    Top = 4
    Width = 55
    Height = 14
    Caption = 'Job Code:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 164
    Top = 20
    Width = 54
    Height = 14
    Caption = 'Currency:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label7: TLabel
    Left = 164
    Top = 36
    Width = 82
    Height = 14
    Caption = 'Analysis Code:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 164
    Top = 52
    Width = 66
    Height = 14
    Caption = 'Stock Code:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblJobCode: TLabel
    Left = 256
    Top = 4
    Width = 52
    Height = 14
    Caption = 'lblJobCode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblCurrency: TLabel
    Left = 256
    Top = 20
    Width = 55
    Height = 14
    Caption = 'lblCurrency'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblAnalysisCode: TLabel
    Left = 256
    Top = 36
    Width = 77
    Height = 14
    Caption = 'lblAnalysisCode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblStockCode: TLabel
    Left = 256
    Top = 52
    Width = 62
    Height = 14
    Caption = 'lblStockCode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 360
    Top = 4
    Width = 80
    Height = 14
    Caption = 'Account Code:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 360
    Top = 20
    Width = 70
    Height = 14
    Caption = 'Cost Centre:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 360
    Top = 36
    Width = 68
    Height = 14
    Caption = 'Department:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 360
    Top = 52
    Width = 50
    Height = 14
    Caption = 'Location:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblAccountCode: TLabel
    Left = 448
    Top = 4
    Width = 76
    Height = 14
    Caption = 'lblAccountCode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblCostCentre: TLabel
    Left = 448
    Top = 20
    Width = 64
    Height = 14
    Caption = 'lblCostCentre'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblDepartment: TLabel
    Left = 448
    Top = 36
    Width = 65
    Height = 14
    Caption = 'lblDepartment'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblLocation: TLabel
    Left = 448
    Top = 52
    Width = 51
    Height = 14
    Caption = 'lblLocation'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object JList: TMultiList
    Left = 4
    Top = 76
    Width = 513
    Height = 253
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Our Ref'
        Color = clWhite
        Width = 64
      end
      item
        Caption = 'Per/Yr'
        Color = clWhite
        Width = 50
      end
      item
        Caption = 'Acct'
        Color = clWhite
        Width = 56
      end
      item
        Caption = 'Description'
        Color = clWhite
      end
      item
        Alignment = taRightJustify
        Caption = 'Amnt'
        Color = clWhite
        Width = 64
      end
      item
        Caption = 'Status'
        Color = clWhite
        Width = 56
      end
      item
        Caption = 'Date'
        Color = clWhite
        Width = 64
      end>
    TabStop = True
    OnRowDblClick = JListRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    TabOrder = 0
    OnClick = JListClick
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
  object StatusBar: TStatusBar
    Left = 0
    Top = 336
    Width = 622
    Height = 19
    Panels = <
      item
        Text = 'Records found: '
        Width = 200
      end
      item
        Text = 'Total amount: '
        Width = 200
      end
      item
        Width = 50
      end>
    SimplePanel = False
    SizeGrip = False
  end
  object BtnPanel: TSBSPanel
    Left = 524
    Top = 73
    Width = 94
    Height = 260
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1BSBox: TScrollBox
      Left = 3
      Top = 7
      Width = 88
      Height = 187
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 0
      object btnViewLine: TButton
        Left = 4
        Top = 32
        Width = 80
        Height = 21
        Hint = 
          'Find Stock Code|Choosing this option allows you to move to the n' +
          'ext line containing a specified Stock Code.'
        HelpContext = 264
        Caption = '&View'
        TabOrder = 0
        OnClick = btnViewLineClick
      end
      object btnClose: TButton
        Left = 4
        Top = 1
        Width = 80
        Height = 21
        HelpContext = 259
        Cancel = True
        Caption = 'C&lose'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 11
    Top = 98
    object ViewTransaction1: TMenuItem
      Caption = '&View Transaction'
      OnClick = ViewTransaction1Click
    end
    object N2: TMenuItem
      Caption = '-'
      Visible = False
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      Visible = False
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
    object ResetCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Reset Coordinates'
      OnClick = ResetCoordinates1Click
    end
  end
end
