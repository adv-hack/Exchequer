object frmAdvancedFind: TfrmAdvancedFind
  Left = 386
  Top = 174
  Width = 475
  Height = 276
  HelpContext = 5
  ActiveControl = cmbSearchFor
  BorderIcons = [biSystemMenu]
  Caption = 'frmAdvancedFind'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 3
    Top = 3
    Width = 460
    Height = 235
    ActivePage = tabshSearch
    TabIndex = 0
    TabOrder = 0
    object tabshSearch: TTabSheet
      Caption = 'Search'
      DesignSize = (
        452
        206)
      object Panel1: TPanel
        Left = 2
        Top = 3
        Width = 358
        Height = 61
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        DesignSize = (
          358
          61)
        object Label81: Label8
          Left = 15
          Top = 9
          Width = 57
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Search For:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnDblClick = Label81DblClick
          TextId = 0
        end
        object Label82: Label8
          Left = 15
          Top = 35
          Width = 54
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Search By:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object cmbSearchFor: TSBSComboBox
          Left = 77
          Top = 6
          Width = 273
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 0
          MaxListWidth = 0
        end
        object cmbSearchBy: TSBSComboBox
          Left = 76
          Top = 32
          Width = 273
          Height = 22
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
          MaxListWidth = 0
        end
      end
      object btnFindCancel: TSBSButton
        Left = 366
        Top = 9
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Find Now'
        TabOrder = 1
        OnClick = btnFindCancelClick
        TextId = 0
      end
      object btnGroupClose: TSBSButton
        Left = 366
        Top = 36
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Close'
        TabOrder = 2
        OnClick = btnClose
        TextId = 0
      end
      object mulResults: TMultiList
        Left = 2
        Top = 69
        Width = 445
        Height = 135
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Code'
            Field = '0'
            Searchable = True
            Sortable = True
            Width = 150
          end
          item
            Caption = 'Name'
            Field = '1'
            Searchable = True
            Sortable = True
            Width = 250
            IndexNo = 1
          end>
        TabStop = True
        OnRowDblClick = mulResultsRowDblClick
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        TabOrder = 3
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
        Version = 'v1.13'
      end
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 194
    Top = 125
    object popFormProperties: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object PopupOpt_SepBar3: TMenuItem
      Caption = '-'
    end
    object popSavePosition: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
