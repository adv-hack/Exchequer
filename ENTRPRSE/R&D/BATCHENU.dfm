object BatchEntry: TBatchEntry
  Left = 393
  Top = 187
  Width = 640
  Height = 438
  HelpContext = 40033
  Caption = 'Batch Entry'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 631
    Height = 345
    ActivePage = MainPage
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object MainPage: TTabSheet
      HelpContext = 40033
      Caption = 'Data Entry'
      PopupMenu = PopupMenu1
      object I1SBox: TScrollBox
        Left = 2
        Top = 117
        Width = 497
        Height = 160
        HorzScrollBar.Position = 9
        HorzScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object I1QtyPanel: TSBSPanel
          Left = 121
          Top = 17
          Width = 52
          Height = 122
          HelpContext = 40002
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1StkCodePanel: TSBSPanel
          Left = -6
          Top = 17
          Width = 70
          Height = 122
          HelpContext = 40001
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1DescPanel: TSBSPanel
          Left = 233
          Top = 17
          Width = 141
          Height = 122
          HelpContext = 40012
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1LTotPanel: TSBSPanel
          Left = 376
          Top = 17
          Width = 86
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1VATPanel: TSBSPanel
          Left = 463
          Top = 17
          Width = 26
          Height = 122
          HelpContext = 40016
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1HedPanel: TSBSPanel
          Left = -7
          Top = -1
          Width = 500
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 5
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I1SCodeLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 68
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1QtyLab: TSBSPanel
            Left = 125
            Top = 3
            Width = 58
            Height = 13
            BevelOuter = bvNone
            Caption = 'Date'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1VATLab: TSBSPanel
            Left = 470
            Top = 3
            Width = 29
            Height = 13
            BevelOuter = bvNone
            Caption = 'VAT'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1DescLab: TSBSPanel
            Left = 242
            Top = 3
            Width = 144
            Height = 13
            BevelOuter = bvNone
            Caption = 'Description'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1LTotLab: TSBSPanel
            Left = 382
            Top = 3
            Width = 86
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Line Total   '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1ItemLab: TSBSPanel
            Left = 71
            Top = 3
            Width = 49
            Height = 13
            BevelOuter = bvNone
            Caption = 'Acc No'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I1YRefLab: TSBSPanel
            Left = 184
            Top = 3
            Width = 58
            Height = 13
            BevelOuter = bvNone
            Caption = 'Your Ref'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object I1ItemPanel: TSBSPanel
          Left = 65
          Top = 17
          Width = 54
          Height = 122
          HelpContext = 40010
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1YRefPanel: TSBSPanel
          Left = 175
          Top = 17
          Width = 56
          Height = 122
          HelpContext = 40011
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object I1ListBtnPanel: TSBSPanel
        Left = 500
        Top = 136
        Width = 18
        Height = 121
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object I1BtmPanel: TSBSPanel
        Left = 0
        Top = 280
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label813: Label8
          Left = 3
          Top = -1
          Width = 60
          Height = 14
          Caption = 'G/L Account'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I1CCLab: Label8
          Left = 118
          Top = -1
          Width = 14
          Height = 14
          Caption = 'CC'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I1DepLab: Label8
          Left = 150
          Top = -1
          Width = 22
          Height = 14
          Caption = 'Dept'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label819: Label8
          Left = 248
          Top = -1
          Width = 41
          Height = 14
          Caption = 'Net Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I1VATTLab: Label8
          Left = 295
          Top = -1
          Width = 99
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = ' Content'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label821: Label8
          Left = 467
          Top = -1
          Width = 22
          Height = 14
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object CurrLab1: Label8
          Left = 192
          Top = -1
          Width = 42
          Height = 14
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object I1NomCodeF: Text8Pt
          Left = 2
          Top = 12
          Width = 86
          Height = 22
          HelpContext = 40013
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object I1CCF: Text8Pt
          Left = 90
          Top = 12
          Width = 43
          Height = 22
          HelpContext = 40014
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object I1DepF: Text8Pt
          Left = 135
          Top = 12
          Width = 43
          Height = 22
          HelpContext = 40014
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object INetTotF: TCurrencyEdit
          Tag = 2
          Left = 192
          Top = 12
          Width = 100
          Height = 22
          HelpContext = 40015
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object IVATTotF: TCurrencyEdit
          Tag = 2
          Left = 294
          Top = 12
          Width = 100
          Height = 22
          HelpContext = 40016
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
        object IGTotF: TCurrencyEdit
          Tag = 2
          Left = 396
          Top = 12
          Width = 100
          Height = 22
          HelpContext = 40017
          TabStop = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = -0.666666
        end
      end
    end
    object AnalPage: TTabSheet
      HelpContext = 40031
      Caption = 'Analysis'
      object I2BtmPanel: TSBSPanel
        Left = 0
        Top = 280
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object I2StkDescLab: Label8
          Left = 4
          Top = -1
          Width = 54
          Height = 14
          Caption = 'Description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object CurrLab2: Label8
          Left = 192
          Top = -1
          Width = 42
          Height = 14
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object Label87: Label8
          Left = 248
          Top = -1
          Width = 41
          Height = 14
          Caption = 'Net Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I2VATTLab: Label8
          Left = 295
          Top = -1
          Width = 99
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = ' Content'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label810: Label8
          Left = 467
          Top = -1
          Width = 22
          Height = 14
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I2StkDescF: Text8Pt
          Left = 2
          Top = 12
          Width = 145
          Height = 22
          HelpContext = 250
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
      end
      object I2SBox: TScrollBox
        Left = 2
        Top = 117
        Width = 497
        Height = 160
        HorzScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 1
        object I2CCPanel: TSBSPanel
          Left = 184
          Top = 17
          Width = 34
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2OrefPanel: TSBSPanel
          Left = 3
          Top = 17
          Width = 70
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2JCPanel: TSBSPanel
          Left = 257
          Top = 17
          Width = 102
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2JAPanel: TSBSPanel
          Left = 360
          Top = 17
          Width = 86
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2VATPanel: TSBSPanel
          Left = 447
          Top = 17
          Width = 26
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2HedPanel: TSBSPanel
          Left = 2
          Top = -1
          Width = 486
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 5
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I2OrefLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 68
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Our Ref'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2CCLab: TSBSPanel
            Left = 180
            Top = 3
            Width = 35
            Height = 13
            BevelOuter = bvNone
            Caption = 'CC'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2VATLab: TSBSPanel
            Left = 443
            Top = 3
            Width = 29
            Height = 13
            BevelOuter = bvNone
            Caption = 'VAT'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2JCLab: TSBSPanel
            Left = 255
            Top = 3
            Width = 100
            Height = 13
            BevelOuter = bvNone
            Caption = 'Job Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2JALab: TSBSPanel
            Left = 358
            Top = 2
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Job Analysis'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2GLLab: TSBSPanel
            Left = 128
            Top = 3
            Width = 51
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Acc'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2DepLab: TSBSPanel
            Left = 216
            Top = 3
            Width = 37
            Height = 13
            BevelOuter = bvNone
            Caption = 'Dept'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2AcLab: TSBSPanel
            Left = 74
            Top = 3
            Width = 49
            Height = 13
            BevelOuter = bvNone
            Caption = 'A/C No'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object I2GLPanel: TSBSPanel
          Left = 129
          Top = 17
          Width = 54
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2DepPanel: TSBSPanel
          Left = 219
          Top = 17
          Width = 37
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2AcPanel: TSBSPanel
          Left = 74
          Top = 17
          Width = 54
          Height = 122
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object NotesPage: TTabSheet
      HelpContext = 80
      Caption = 'Notes'
      object TCNScrollBox: TScrollBox
        Left = 2
        Top = 117
        Width = 496
        Height = 198
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 2
          Top = -1
          Width = 480
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object NDateLab: TSBSPanel
            Left = 2
            Top = 1
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'Date'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NDescLab: TSBSPanel
            Left = 67
            Top = 1
            Width = 328
            Height = 16
            BevelOuter = bvNone
            Caption = 'Notes'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NUserLab: TSBSPanel
            Left = 396
            Top = 2
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'User'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object NDatePanel: TSBSPanel
          Left = 2
          Top = 20
          Width = 65
          Height = 157
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NDescPanel: TSBSPanel
          Left = 69
          Top = 20
          Width = 328
          Height = 157
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NUserPanel: TSBSPanel
          Left = 399
          Top = 20
          Width = 70
          Height = 157
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object TCNListBtnPanel: TSBSPanel
        Left = 500
        Top = 139
        Width = 18
        Height = 156
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object I1FPanel: TSBSPanel
    Left = 3
    Top = 23
    Width = 624
    Height = 114
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1DumPanel: TSBSPanel
      Left = 576
      Top = 36
      Width = 0
      Height = 0
      BevelOuter = bvNone
      Caption = 'I1DumPanel'
      Enabled = False
      TabOrder = 0
      Visible = False
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object SBSPanel3: TSBSPanel
      Left = 3
      Top = 2
      Width = 422
      Height = 111
      BevelInner = bvRaised
      BevelOuter = bvLowered
      PopupMenu = PopupMenu1
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Label817: Label8
        Left = 8
        Top = 14
        Width = 38
        Height = 14
        Caption = 'Our Ref'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 24
        Top = 39
        Width = 22
        Height = 14
        Caption = 'Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 15
        Top = 65
        Width = 31
        Height = 14
        Caption = 'Per/Yr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 204
        Top = 13
        Width = 72
        Height = 14
        Caption = 'Bank G/L Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 194
        Top = 38
        Width = 82
        Height = 14
        Caption = 'Cheque No. Start'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object I1CurrLab: Label8
        Left = 175
        Top = 63
        Width = 101
        Height = 14
        Alignment = taRightJustify
        Caption = 'Currency/Batch Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 194
        Top = 88
        Width = 82
        Height = 14
        Caption = 'Batch Difference'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object I1OurRefF: Text8Pt
        Left = 49
        Top = 10
        Width = 84
        Height = 22
        HelpContext = 142
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object I1OpoF: Text8Pt
        Left = 135
        Top = 10
        Width = 62
        Height = 22
        HelpContext = 241
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object I1TransDateF: TEditDate
        Tag = 1
        Left = 49
        Top = 35
        Width = 80
        Height = 22
        HelpContext = 40002
        AutoSelect = False
        Color = clWhite
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        OnExit = I1TransDateFExit
        Placement = cpAbove
      end
      object I1PrYrF: TEditPeriod
        Tag = 1
        Left = 49
        Top = 60
        Width = 80
        Height = 22
        HelpContext = 40003
        AutoSelect = False
        Color = clWhite
        EditMask = '00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 7
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = '011996'
        Placement = cpAbove
        EPeriod = 1
        EYear = 96
        ViewMask = '000/0000;0;'
        OnConvDate = I1PrYrFConvDate
        OnShowPeriod = I1PrYrFShowPeriod
      end
      object I1BNomF: Text8Pt
        Tag = 1
        Left = 282
        Top = 9
        Width = 86
        Height = 22
        HelpContext = 40004
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnExit = I1BNomFExit
        TextId = 0
        ViaSBtn = False
      end
      object I1CqStartF: TCurrencyEdit
        Tag = 1
        Left = 282
        Top = 34
        Width = 84
        Height = 22
        HelpContext = 40005
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        WantReturns = False
        WordWrap = False
        OnExit = I1CqStartFExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object I1CurrF: TSBSComboBox
        Tag = 1
        Left = 282
        Top = 59
        Width = 47
        Height = 22
        HelpContext = 40006
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MaxLength = 3
        ParentFont = False
        TabOrder = 6
        OnEnter = I1CurrFEnter
        OnExit = I1CurrFExit
        ExtendedList = True
        MaxListWidth = 90
        ReadOnly = True
        Validate = True
      end
      object I1BTotF: TCurrencyEdit
        Tag = 1
        Left = 332
        Top = 59
        Width = 84
        Height = 22
        HelpContext = 40007
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        MaxLength = 12
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        OnExit = I1BTotFExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object I1BDifF: TCurrencyEdit
        Left = 282
        Top = 84
        Width = 84
        Height = 22
        HelpContext = 40008
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
  end
  object I1BtnPanel: TSBSPanel
    Left = 523
    Top = 140
    Width = 102
    Height = 200
    BevelOuter = bvLowered
    Caption = 'I1BtnPanel'
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1BSBox: TScrollBox
      Left = 1
      Top = 81
      Width = 99
      Height = 118
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 0
      object EditI1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 40011
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddI1BtnClick
      end
      object CopyI1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Copy/Reverse current transaction|Generate an exact copy, or reve' +
          'rse of the currently highlighted transaction.'
        HelpContext = 19
        Caption = '&Copy'
        TabOrder = 5
        OnClick = CopyI1BtnClick
      end
      object FullI1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Fill current entry|Choosing this option allows you to add more d' +
          'etail to the currently highlighted line.'
        HelpContext = 40018
        Caption = '&Full'
        TabOrder = 4
        OnClick = FullI1BtnClick
      end
      object chkI1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Recalculate Batch total|Choosing this option will recalculate th' +
          'e batch total in cases where the batch total does not agree with' +
          ' the sum of the individual entries.'
        HelpContext = 40013
        Caption = 'Chec&k'
        Enabled = False
        TabOrder = 6
        OnClick = chkI1BtnClick
      end
      object AddI1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the invoice.'
        HelpContext = 40035
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddI1BtnClick
      end
      object InsI1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Insert new line|Choosing this option allows you to Insert a new ' +
          'line before the currently highlighted line.'
        HelpContext = 261
        Caption = '&Insert'
        TabOrder = 2
        OnClick = AddI1BtnClick
      end
      object SwiI1Btn: TButton
        Left = 1
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Switch between alternative notepads|Switches the display of the ' +
          'notepad between dated notepad, & general notepad.'
        HelpContext = 469
        Caption = '&Switch'
        Enabled = False
        TabOrder = 7
        OnClick = SwiI1BtnClick
      end
      object DelI1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Delete current line|Choosing this option allows you to delete th' +
          'e currently highlighted line.'
        HelpContext = 263
        Caption = '&Delete'
        TabOrder = 3
        OnClick = DelI1BtnClick
      end
      object LnkI1Btn: TButton
        Left = 1
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 469
        Caption = '&Li&nks'
        Enabled = False
        TabOrder = 8
        OnClick = LnkI1BtnClick
      end
    end
  end
  object I1BtnPanel2: TSBSPanel
    Left = 524
    Top = 141
    Width = 99
    Height = 71
    BevelOuter = bvNone
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object I1StatLab: Label8
      Left = 4
      Top = 3
      Width = 95
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Caption = 'I1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object OkI1Btn: TButton
      Tag = 1
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      HelpContext = 257
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = OkI1BtnClick
    end
    object CanI1Btn: TButton
      Tag = 1
      Left = 2
      Top = 26
      Width = 80
      Height = 21
      HelpContext = 258
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsI1BtnClick
    end
    object ClsI1Btn: TButton
      Left = 2
      Top = 49
      Width = 80
      Height = 21
      HelpContext = 259
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsI1BtnClick
    end
  end
  object SBSPanel4: TSBSPanel
    Left = 432
    Top = 25
    Width = 193
    Height = 111
    BevelInner = bvRaised
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label85: Label8
      Left = 55
      Top = 88
      Width = 73
      Height = 14
      Caption = 'Payment Terms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SBSPanel5: TSBSPanel
      Left = 9
      Top = 5
      Width = 177
      Height = 76
      BevelOuter = bvNone
      Caption = 'SBSPanel4'
      Color = clPurple
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object I1AddrF: TMemo
        Left = 0
        Top = 0
        Width = 177
        Height = 76
        HelpContext = 40009
        Align = alClient
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        WantReturns = False
        OnClick = I1AddrFClick
      end
    end
    object I1PayTF: TCurrencyEdit
      Left = 133
      Top = 84
      Width = 53
      Height = 22
      HelpContext = 40009
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = 0
    Top = 365
    Width = 632
    Height = 42
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 0
      Width = 623
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 214
      Top = 8
      Width = 240
      Height = 24
      Alignment = taCenter
      Caption = 'Anonymised 30/09/2017'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 556
    Top = 65516
    object Copy2: TMenuItem
      Tag = 1
      Caption = '&Copy Transaction'
      HelpContext = 28
      Hint = 'Generate an exact copy of the currently highlighted transaction.'
      OnClick = Copy2Click
    end
    object Reverse1: TMenuItem
      Tag = 2
      Caption = '&Reverse/Contra Transaction'
      HelpContext = 28
      Hint = 
        'Generate the exact reverse of the currently highlighted transact' +
        'ion.'
      OnClick = Copy2Click
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 578
    Top = 65516
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option allows you to Add a new line which will be ' +
        'placed at the end of the invoice.'
      OnClick = AddI1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
      OnClick = AddI1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = AddI1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = DelI1BtnClick
    end
    object Full1: TMenuItem
      Caption = '&Full'
      OnClick = FullI1BtnClick
    end
    object Copy1: TMenuItem
      Caption = '&Copy'
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      OnClick = chkI1BtnClick
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SwiI1BtnClick
    end
    object Links1: TMenuItem
      Caption = '&Li&nks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
      OnClick = LnkI1BtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
end
