object SalesTBody: TSalesTBody
  Left = 200
  Top = 100
  Width = 668
  Height = 455
  HelpContext = 7
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
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
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
    Height = 377
    ActivePage = FootPage
    TabIndex = 4
    TabOrder = 0
    TabStop = False
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object MainPage: TTabSheet
      Caption = 'Data Entry'
      object I1SBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 217
        HorzScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object I1QtyPanel: TSBSPanel
          Left = 145
          Top = 17
          Width = 56
          Height = 176
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
          Left = 3
          Top = 17
          Width = 111
          Height = 176
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
          Left = 202
          Top = 17
          Width = 194
          Height = 176
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
          Left = 397
          Top = 17
          Width = 88
          Height = 176
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
        object I1UPricePanel: TSBSPanel
          Left = 513
          Top = 17
          Width = 88
          Height = 176
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
        object I1VATPanel: TSBSPanel
          Left = 486
          Top = 17
          Width = 26
          Height = 176
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I1HedPanel: TSBSPanel
          Left = 2
          Top = -1
          Width = 688
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 6
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I1SCodeLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 111
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Stock Code'
            Color = clWhite
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
            Left = 143
            Top = 3
            Width = 58
            Height = 13
            BevelOuter = bvNone
            Caption = 'Qty'
            Color = clWhite
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
          object I1UPLab: TSBSPanel
            Left = 512
            Top = 3
            Width = 89
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Unit Price   '
            Color = clWhite
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
          object I1DiscLab: TSBSPanel
            Left = 600
            Top = 3
            Width = 88
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Discount  '
            Color = clWhite
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
          object I1VATLab: TSBSPanel
            Left = 483
            Top = 3
            Width = 29
            Height = 13
            BevelOuter = bvNone
            Caption = 'VAT'
            Color = clWhite
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
          object I1DescLab: TSBSPanel
            Left = 200
            Top = 3
            Width = 195
            Height = 13
            BevelOuter = bvNone
            Caption = 'Description'
            Color = clWhite
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
          object I1LTotLab: TSBSPanel
            Left = 395
            Top = 3
            Width = 89
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Line Total   '
            Color = clWhite
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
          object I1ItemLab: TSBSPanel
            Left = 114
            Top = 3
            Width = 29
            Height = 13
            BevelOuter = bvNone
            Caption = 'Item'
            Color = clWhite
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
        object I1DiscPanel: TSBSPanel
          Left = 602
          Top = 17
          Width = 88
          Height = 176
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
        object I1ItemPanel: TSBSPanel
          Left = 115
          Top = 17
          Width = 29
          Height = 176
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
      object I1ListBtnPanel: TSBSPanel
        Left = 504
        Top = 107
        Width = 18
        Height = 174
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object I1BtmPanel: TSBSPanel
        Left = 0
        Top = 312
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label813: Label8
          Left = 1
          Top = 1
          Width = 60
          Height = 14
          Caption = 'G/L Account'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = Label813Click
          TextId = 5
        end
        object I1CCLab: Label8
          Left = 116
          Top = 1
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
          Left = 148
          Top = 1
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
        object I1LocnLab: Label8
          Left = 181
          Top = 1
          Width = 24
          Height = 14
          Caption = 'Locn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label819: Label8
          Left = 270
          Top = 1
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
          Left = 317
          Top = 1
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
          Left = 489
          Top = 1
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
          Left = 214
          Top = 1
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
          Left = 0
          Top = 14
          Width = 86
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
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object I1CCF: Text8Pt
          Left = 88
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object I1DepF: Text8Pt
          Left = 133
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object I1LocnF: Text8Pt
          Left = 178
          Top = 14
          Width = 33
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
        object INetTotF: TCurrencyEdit
          Tag = 2
          Left = 214
          Top = 14
          Width = 100
          Height = 22
          HelpContext = 252
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
        object IVATTotF: TCurrencyEdit
          Tag = 2
          Left = 316
          Top = 14
          Width = 100
          Height = 22
          HelpContext = 252
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
        object IGTotF: TCurrencyEdit
          Tag = 2
          Left = 418
          Top = 14
          Width = 100
          Height = 22
          HelpContext = 252
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
          TabOrder = 6
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
      Caption = 'Analysis'
      object Label829: Label8
        Left = 0
        Top = 197
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
      object I2SBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 192
        HorzScrollBar.Position = 219
        VertScrollBar.Visible = False
        TabOrder = 0
        object I2LocnPanel: TSBSPanel
          Left = -102
          Top = 17
          Width = 37
          Height = 155
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
        object I2StkCodePanel: TSBSPanel
          Left = -215
          Top = 17
          Width = 111
          Height = 155
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
        object I2DelDatePanel: TSBSPanel
          Left = -63
          Top = 17
          Width = 64
          Height = 155
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
        object I2NomPanel: TSBSPanel
          Left = 3
          Top = 17
          Width = 48
          Height = 155
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
        object I2CCPanel: TSBSPanel
          Left = 52
          Top = 17
          Width = 28
          Height = 155
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
          Left = -217
          Top = -1
          Width = 716
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 5
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I2SCodeLab: TSBSPanel
            Left = 1
            Top = 2
            Width = 110
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Stock Code'
            Color = clWhite
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
          object I2LocnLab: TSBSPanel
            Left = 112
            Top = 2
            Width = 38
            Height = 13
            BevelOuter = bvNone
            Caption = 'Locn'
            Color = clWhite
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
          object I2NomLab: TSBSPanel
            Left = 219
            Top = 2
            Width = 50
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Code'
            Color = clWhite
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
          object I2MargLab: TSBSPanel
            Left = 502
            Top = 2
            Width = 89
            Height = 13
            BevelOuter = bvNone
            Caption = 'Margin'
            Color = clWhite
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
          object I2DelLab: TSBSPanel
            Left = 153
            Top = 2
            Width = 66
            Height = 13
            BevelOuter = bvNone
            Caption = 'Delivery'
            Color = clWhite
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
          object I2CCLab: TSBSPanel
            Left = 266
            Top = 2
            Width = 29
            Height = 13
            BevelOuter = bvNone
            Caption = 'CC'
            Color = clWhite
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
            Left = 296
            Top = 2
            Width = 28
            Height = 13
            BevelOuter = bvNone
            Caption = 'Dep'
            Color = clWhite
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
          object I2NValLab: TSBSPanel
            Left = 324
            Top = 2
            Width = 89
            Height = 13
            BevelOuter = bvNone
            Caption = 'Net Value'
            Color = clWhite
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
          object I2CostLab: TSBSPanel
            Left = 413
            Top = 2
            Width = 89
            Height = 13
            BevelOuter = bvNone
            Caption = 'Cost'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2GPLab: TSBSPanel
            Left = 590
            Top = 2
            Width = 48
            Height = 13
            BevelOuter = bvNone
            Caption = 'GP%'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 9
            OnMouseDown = I1SCodeLabMouseDown
            OnMouseMove = I1SCodeLabMouseMove
            OnMouseUp = I1StkCodePanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I2ReconLab: TSBSPanel
            Left = 640
            Top = 2
            Width = 73
            Height = 13
            BevelOuter = bvNone
            Caption = 'Recon Date'
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 10
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object I2NetValPanel: TSBSPanel
          Left = 110
          Top = 17
          Width = 88
          Height = 155
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
          Left = 81
          Top = 17
          Width = 28
          Height = 155
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
        object I2CostPanel: TSBSPanel
          Left = 199
          Top = 17
          Width = 88
          Height = 155
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
        object I2MargPanel: TSBSPanel
          Left = 288
          Top = 17
          Width = 88
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2GPPanel: TSBSPanel
          Left = 377
          Top = 17
          Width = 47
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I2ReconPanel: TSBSPanel
          Left = 425
          Top = 17
          Width = 75
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object I2BtmPanel: TSBSPanel
        Left = 0
        Top = 312
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object I2StkDescLab: Label8
          Left = 3
          Top = 1
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
        object I2QtyLab: Label8
          Left = 176
          Top = 1
          Width = 17
          Height = 14
          Caption = 'Qty'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label833: Label8
          Left = 262
          Top = 1
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
        object I1MargLab: Label8
          Left = 375
          Top = 1
          Width = 32
          Height = 14
          Caption = 'Margin'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I1GPLab: Label8
          Left = 480
          Top = 1
          Width = 24
          Height = 14
          Caption = 'GP%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I2StkDescF: Text8Pt
          Left = 1
          Top = 14
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
          ReadOnly = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object I2QtyF: TCurrencyEdit
          Left = 148
          Top = 14
          Width = 58
          Height = 22
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '0.67-')
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
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
    object QtyPPage: TTabSheet
      Caption = 'Qty/Pick'
      object I3SBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 192
        VertScrollBar.Visible = False
        TabOrder = 0
        object I3StkDPanel: TSBSPanel
          Left = 2
          Top = 17
          Width = 156
          Height = 155
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
        object I3HedPanel: TSBSPanel
          Left = 2
          Top = -1
          Width = 498
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I3StkDLab: TSBSPanel
            Left = 1
            Top = 2
            Width = 155
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Stock Code/Desc'
            Color = clWhite
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
          object I3QOrdLab: TSBSPanel
            Left = 155
            Top = 2
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Qty Ord  '
            Color = clWhite
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
          object I3DelLab: TSBSPanel
            Left = 213
            Top = 2
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Delvd   '
            Color = clWhite
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
          object I3QWOLab: TSBSPanel
            Left = 270
            Top = 2
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'W/Off   '
            Color = clWhite
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
          object I3QOSLab: TSBSPanel
            Left = 328
            Top = 3
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'O/S    '
            Color = clWhite
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
          object I3QPKLab: TSBSPanel
            Left = 384
            Top = 2
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Picked   '
            Color = clWhite
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
          object I3QTWLab: TSBSPanel
            Left = 441
            Top = 2
            Width = 56
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Write Off'
            Color = clWhite
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
        object I3QOrdPanel: TSBSPanel
          Left = 159
          Top = 17
          Width = 56
          Height = 155
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
        object I3QDelPanel: TSBSPanel
          Left = 216
          Top = 17
          Width = 56
          Height = 155
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
        object I3QWOPanel: TSBSPanel
          Left = 273
          Top = 17
          Width = 56
          Height = 155
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
        object I3QOSPanel: TSBSPanel
          Left = 330
          Top = 17
          Width = 56
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object I3QPKPanel: TSBSPanel
          Left = 387
          Top = 17
          Width = 56
          Height = 155
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
        object I3QTWPanel: TSBSPanel
          Left = 444
          Top = 17
          Width = 56
          Height = 155
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
      object I3BtmPanel: TSBSPanel
        Left = 0
        Top = 312
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object I3StkCodeLab: Label8
          Left = 1
          Top = 1
          Width = 55
          Height = 14
          Caption = 'Stock Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object I3CCLab: Label8
          Left = 112
          Top = 1
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
        object I3DepLab: Label8
          Left = 148
          Top = 1
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
        object I3LocnLab: Label8
          Left = 182
          Top = 1
          Width = 24
          Height = 14
          Caption = 'Locn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label826: Label8
          Left = 270
          Top = 1
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
          Left = 334
          Top = 1
          Width = 82
          Height = 14
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
        object Label828: Label8
          Left = 489
          Top = 1
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
        object I3StkCodeF: Text8Pt
          Left = 0
          Top = 14
          Width = 86
          Height = 22
          HelpContext = 246
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object I3CCF: Text8Pt
          Left = 88
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object I3DepF: Text8Pt
          Left = 133
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object I3LocnF: Text8Pt
          Left = 178
          Top = 14
          Width = 33
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object JobPage: TTabSheet
      Caption = 'Job-View'
      object I4SBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 192
        VertScrollBar.Visible = False
        TabOrder = 0
        object I4JCPanel: TSBSPanel
          Left = 261
          Top = 17
          Width = 73
          Height = 155
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
        object I4StkDPanel: TSBSPanel
          Left = 104
          Top = 17
          Width = 156
          Height = 155
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
        object I4LTotPanel: TSBSPanel
          Left = 409
          Top = 17
          Width = 88
          Height = 155
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
        object I4HedPanel: TSBSPanel
          Left = 2
          Top = -1
          Width = 497
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I4StkDLab: TSBSPanel
            Left = 102
            Top = 2
            Width = 155
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Description'
            Color = clWhite
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
          object I4JCLab: TSBSPanel
            Left = 257
            Top = 2
            Width = 75
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Job Code'
            Color = clWhite
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
          object I4LtotLab: TSBSPanel
            Left = 405
            Top = 2
            Width = 89
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Line Total   '
            Color = clWhite
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
          object I4JALab: TSBSPanel
            Left = 331
            Top = 2
            Width = 75
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Job Analysis'
            Color = clWhite
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
          object I4StkCLab: TSBSPanel
            Left = 1
            Top = 2
            Width = 100
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Stock Code'
            Color = clWhite
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
        end
        object I4JAPanel: TSBSPanel
          Left = 335
          Top = 17
          Width = 73
          Height = 155
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
        object I4StkCPanel: TSBSPanel
          Left = 2
          Top = 17
          Width = 101
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = I1StkCodePanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object I4BtmPanel: TSBSPanel
        Left = 0
        Top = 312
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label87: Label8
          Left = 270
          Top = 1
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
        object I3VATTLab: Label8
          Left = 334
          Top = 1
          Width = 82
          Height = 14
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
        object Label811: Label8
          Left = 489
          Top = 1
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
        object Label830: Label8
          Left = 1
          Top = 1
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
        object I4CCLab: Label8
          Left = 117
          Top = 1
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
        object I4DepLab: Label8
          Left = 149
          Top = 1
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
        object I4NomF: Text8Pt
          Left = 1
          Top = 14
          Width = 86
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
          ReadOnly = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object I4CCF: Text8Pt
          Left = 90
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          TextId = 0
          ViaSBtn = False
        end
        object I4DepF: Text8Pt
          Left = 136
          Top = 14
          Width = 43
          Height = 22
          HelpContext = 251
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object FootPage: TTabSheet
      Caption = 'Footer'
      object Label9: TLabel
        Left = 304
        Top = 5
        Width = 51
        Height = 14
        Caption = 'Line Totals'
      end
      object Bevel2: TBevel
        Left = 358
        Top = 12
        Width = 175
        Height = 3
        Shape = bsTopLine
      end
      object pnlTaxRates: TSBSPanel
        Left = 0
        Top = 7
        Width = 295
        Height = 306
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 3
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label834: Label8
          Left = 148
          Top = 8
          Width = 70
          Height = 14
          Alignment = taRightJustify
          Caption = 'Cntrl G/L Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenu1
          TextId = 0
        end
        object I5VRateL: TLabel
          Left = 136
          Top = 32
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = ' Ex.Rate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object pnlIntrastat: TPanel
          Left = 0
          Top = 184
          Width = 287
          Height = 113
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          object Label11: TLabel
            Left = 8
            Top = 0
            Width = 84
            Height = 14
            Caption = 'Intrastat Settings '
          end
          object Bevel5: TBevel
            Left = 92
            Top = 7
            Width = 195
            Height = 9
            Shape = bsTopLine
          end
          object lblDeliveryTerms: TLabel
            Left = 26
            Top = 20
            Width = 71
            Height = 14
            Alignment = taRightJustify
            Caption = 'Delivery Terms'
          end
          object lblTransactionType: TLabel
            Left = 14
            Top = 45
            Width = 83
            Height = 14
            Alignment = taRightJustify
            Caption = 'Transaction Type'
          end
          object lblNoTc: TLabel
            Left = 73
            Top = 71
            Width = 24
            Height = 14
            Alignment = taRightJustify
            Caption = 'NoTc'
          end
          object lblModeOfTransport: TLabel
            Left = 8
            Top = 95
            Width = 89
            Height = 14
            Alignment = taRightJustify
            Caption = 'Mode of Transport'
          end
          object cbDeliveryTerms: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 16
            Width = 183
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 0
            MaxListWidth = 350
          end
          object cbTransactionType: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 41
            Width = 183
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 1
            Items.Strings = (
              'Normal Transaction'
              'Triangulation Transaction'
              'Process Transaction')
            MaxListWidth = 350
          end
          object cbNoTc: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 66
            Width = 183
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 2
            ExtendedList = True
            MaxListWidth = 350
          end
          object cbModeOfTransport: TSBSComboBox
            Tag = 1
            Left = 104
            Top = 91
            Width = 183
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 3
            MaxListWidth = 350
          end
        end
        object sbVATRates: TScrollBox
          Left = 8
          Top = 49
          Width = 280
          Height = 40
          HelpContext = 286
          HorzScrollBar.Visible = False
          TabOrder = 0
          object I5VR1F: Text8Pt
            Tag = 2
            Left = 2
            Top = 2
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR2F: Text8Pt
            Tag = 2
            Left = 2
            Top = 26
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR3F: Text8Pt
            Tag = 2
            Left = 2
            Top = 50
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR4F: Text8Pt
            Tag = 2
            Left = 2
            Top = 74
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR5F: Text8Pt
            Tag = 2
            Left = 2
            Top = 98
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 4
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR6F: Text8Pt
            Tag = 2
            Left = 2
            Top = 122
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 5
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VR7F: Text8Pt
            Tag = 2
            Left = 2
            Top = 145
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 6
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG1F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 2
            Width = 100
            Height = 22
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
            TabOrder = 21
            Visible = False
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
          object I5VG2F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 26
            Width = 100
            Height = 22
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
            TabOrder = 22
            Visible = False
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
          object I5VG3F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 50
            Width = 100
            Height = 22
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
            TabOrder = 23
            Visible = False
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
          object I5VG4F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 74
            Width = 100
            Height = 22
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
            TabOrder = 24
            Visible = False
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
          object I5VG5F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 98
            Width = 100
            Height = 22
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
            TabOrder = 25
            Visible = False
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
          object I5VG6F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 122
            Width = 100
            Height = 22
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
            TabOrder = 26
            Visible = False
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
          object I5VG7F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 145
            Width = 100
            Height = 22
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
            TabOrder = 27
            Visible = False
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
          object I5VV1F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 2
            Width = 88
            Height = 22
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
            TabOrder = 42
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV2F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 26
            Width = 88
            Height = 22
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
            TabOrder = 43
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV3F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 50
            Width = 88
            Height = 22
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
            TabOrder = 44
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV4F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 74
            Width = 88
            Height = 22
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
            TabOrder = 45
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV5F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 98
            Width = 88
            Height = 22
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
            TabOrder = 46
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV6F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 122
            Width = 88
            Height = 22
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
            TabOrder = 47
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV7F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 145
            Width = 88
            Height = 22
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
            TabOrder = 48
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VR8F: Text8Pt
            Tag = 2
            Left = 2
            Top = 168
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 7
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG8F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 168
            Width = 100
            Height = 22
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
            TabOrder = 28
            Visible = False
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
          object I5VV8F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 168
            Width = 88
            Height = 22
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
            TabOrder = 49
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr9F: Text8Pt
            Tag = 2
            Left = 2
            Top = 192
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 8
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG9F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 192
            Width = 100
            Height = 22
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
            TabOrder = 29
            Visible = False
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
          object I5VV9F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 192
            Width = 88
            Height = 22
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
            TabOrder = 50
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr10F: Text8Pt
            Tag = 2
            Left = 2
            Top = 216
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 9
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG10F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 216
            Width = 100
            Height = 22
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
            TabOrder = 30
            Visible = False
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
          object I5VV10F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 216
            Width = 88
            Height = 22
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
            TabOrder = 51
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr11F: Text8Pt
            Tag = 2
            Left = 2
            Top = 240
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 10
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG11F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 240
            Width = 100
            Height = 22
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
            TabOrder = 31
            Visible = False
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
          object I5VV11F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 240
            Width = 88
            Height = 22
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
            TabOrder = 52
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VR12F: Text8Pt
            Tag = 2
            Left = 2
            Top = 264
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 11
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG12F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 264
            Width = 100
            Height = 22
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
            TabOrder = 32
            Visible = False
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
          object I5VV12F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 264
            Width = 88
            Height = 22
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
            TabOrder = 53
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr13F: Text8Pt
            Tag = 2
            Left = 2
            Top = 288
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 12
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG13F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 288
            Width = 100
            Height = 22
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
            TabOrder = 33
            Visible = False
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
          object I5VV13F: TCurrencyEdit
            Tag = 1
            Left = 171
            Top = 288
            Width = 88
            Height = 22
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
            TabOrder = 54
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr14F: Text8Pt
            Tag = 2
            Left = 2
            Top = 312
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 13
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG14F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 312
            Width = 100
            Height = 22
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
            TabOrder = 34
            Visible = False
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
          object I5VV14F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 312
            Width = 88
            Height = 22
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
            TabOrder = 55
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr15F: Text8Pt
            Tag = 2
            Left = 2
            Top = 336
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 14
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG15F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 336
            Width = 100
            Height = 22
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
            TabOrder = 35
            Visible = False
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
          object I5VV15F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 336
            Width = 88
            Height = 22
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
            TabOrder = 56
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV16F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 360
            Width = 88
            Height = 22
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
            TabOrder = 57
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VG16F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 360
            Width = 100
            Height = 22
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
            TabOrder = 36
            Visible = False
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
          object I5Vr16F: Text8Pt
            Tag = 2
            Left = 2
            Top = 360
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 15
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5Vr17F: Text8Pt
            Tag = 2
            Left = 2
            Top = 384
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 16
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG17F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 384
            Width = 100
            Height = 22
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
            TabOrder = 37
            Visible = False
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
          object I5VV17F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 384
            Width = 88
            Height = 22
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
            TabOrder = 58
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VV18F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 408
            Width = 88
            Height = 22
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
            TabOrder = 59
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5VG18F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 408
            Width = 100
            Height = 22
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
            TabOrder = 38
            Visible = False
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
          object I5Vr18F: Text8Pt
            Tag = 2
            Left = 2
            Top = 408
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 17
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5Vr19F: Text8Pt
            Tag = 2
            Left = 2
            Top = 431
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 18
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG19F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 431
            Width = 100
            Height = 22
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
            TabOrder = 39
            Visible = False
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
          object I5VV19F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 431
            Width = 88
            Height = 22
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
            TabOrder = 60
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr20F: Text8Pt
            Tag = 2
            Left = 2
            Top = 455
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 19
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG20F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 455
            Width = 100
            Height = 22
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
            TabOrder = 40
            Visible = False
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
          object I5VV20F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 455
            Width = 88
            Height = 22
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
            TabOrder = 61
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
          object I5Vr21F: Text8Pt
            Tag = 2
            Left = 2
            Top = 478
            Width = 65
            Height = 22
            TabStop = False
            AutoSize = False
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 20
            Visible = False
            TextId = 0
            ViaSBtn = False
          end
          object I5VG21F: TCurrencyEdit
            Tag = 2
            Left = 69
            Top = 478
            Width = 100
            Height = 22
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
            TabOrder = 41
            Visible = False
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
          object I5VV21F: TCurrencyEdit
            Tag = 1
            Left = 170
            Top = 478
            Width = 88
            Height = 22
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
            TabOrder = 62
            Visible = False
            WantReturns = False
            WordWrap = False
            OnExit = I5VV1FExit
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
            ShowCurrency = False
            TextId = 0
            Value = -0.666666
          end
        end
        object SBSPanel54: TSBSPanel
          Left = 8
          Top = 28
          Width = 280
          Height = 17
          Color = clWhite
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object I5VATRLab: TSBSPanel
            Left = 6
            Top = 2
            Width = 62
            Height = 13
            Alignment = taLeftJustify
            Caption = ' Rate'
            Color = clWhite
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object Label8: TSBSPanel
            Left = 128
            Top = 2
            Width = 32
            Height = 14
            Alignment = taLeftJustify
            Caption = 'Goods'
            Color = clWhite
            TabOrder = 1
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object I5VATLab: TSBSPanel
            Left = 174
            Top = 2
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = 'VAT'
            Color = clWhite
            TabOrder = 2
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object CISPanel1: TSBSPanel
          Left = 2
          Top = 91
          Width = 289
          Height = 94
          BevelOuter = bvNone
          PopupMenu = PopupMenu1
          TabOrder = 1
          Visible = False
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label1: TLabel
            Left = 6
            Top = 20
            Width = 70
            Height = 14
            Alignment = taRightJustify
            Caption = 'Taxable Gross'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 12
            Top = 46
            Width = 63
            Height = 14
            Alignment = taRightJustify
            Caption = 'Tax/Declared'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label3: TLabel
            Left = 23
            Top = 71
            Width = 50
            Height = 14
            Caption = 'Tax Period'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Bevel6: TBevel
            Left = 58
            Top = 7
            Width = 227
            Height = 9
            Shape = bsTopLine
          end
          object lblTaxSummary: TLabel
            Left = 8
            Top = 0
            Width = 48
            Height = 14
            Caption = 'Summary '
          end
          object I5CISTaxF: TCurrencyEdit
            Tag = 1
            Left = 80
            Top = 42
            Width = 100
            Height = 22
            HelpContext = 1437
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
            TabOrder = 2
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
          object I5CISManCb: TBorCheck
            Left = 191
            Top = 15
            Width = 86
            Height = 20
            HelpContext = 1436
            Caption = 'Tax amended'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 1
            TextId = 0
            OnClick = I5CISManCbClick
          end
          object I5CISDecF: TCurrencyEdit
            Tag = 2
            Left = 181
            Top = 42
            Width = 100
            Height = 22
            HelpContext = 1438
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
          object I5CISPeriodF: TEditDate
            Tag = 2
            Left = 80
            Top = 69
            Width = 80
            Height = 22
            HelpContext = 1439
            TabStop = False
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
            TabOrder = 4
            OnExit = I1TransDateFExit
            Placement = cpAbove
            AllowBlank = True
          end
          object I5CISGrossF: TCurrencyEdit
            Tag = 1
            Left = 80
            Top = 16
            Width = 100
            Height = 22
            HelpContext = 1435
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
            TabOrder = 0
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
      object DMDCNomF: Text8Pt
        Tag = 1
        Left = 225
        Top = 11
        Width = 65
        Height = 22
        HelpContext = 551
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnExit = DMDCNomFExit
        TextId = 0
        ViaSBtn = False
      end
      object I5VRateF: TCurrencyEdit
        Tag = 1
        Left = 207
        Top = 35
        Width = 84
        Height = 22
        HelpContext = 763
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0.000000 ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Visible = False
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
        DecPlaces = 6
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object lvLineTypeTotals: TListView
        Left = 304
        Top = 22
        Width = 229
        Height = 99
        Columns = <
          item
            Caption = 'Line Totals'
            Width = 135
          end
          item
            Alignment = taRightJustify
            Caption = 'Total'
            Width = 80
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ReadOnly = True
        ParentFont = False
        ShowColumnHeaders = False
        TabOrder = 5
        ViewStyle = vsReport
      end
      object nbSettleDisc: TNotebook
        Left = 307
        Top = 136
        Width = 318
        Height = 213
        PageIndex = 1
        TabOrder = 6
        object TPage
          Left = 0
          Top = 0
          Caption = 'SettlementDiscount'
          object lblDiscountSummary: TLabel
            Left = 1
            Top = 0
            Width = 31
            Height = 14
            Caption = 'Totals '
          end
          object Bevel8: TBevel
            Left = 32
            Top = 7
            Width = 277
            Height = 9
            Shape = bsTopLine
          end
          object Label5: TLabel
            Left = 9
            Top = 22
            Width = 74
            Height = 14
            Caption = 'Settlement Disc'
          end
          object Label7: TLabel
            Left = 145
            Top = 22
            Width = 10
            Height = 14
            Caption = '%'
          end
          object Label6: TLabel
            Left = 167
            Top = 22
            Width = 25
            Height = 14
            Caption = 'Days'
          end
          object Label16: TLabel
            Left = 2
            Top = 151
            Width = 49
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Total'
          end
          object Label15: TLabel
            Left = 2
            Top = 126
            Width = 49
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Discount'
          end
          object Label14: TLabel
            Left = 2
            Top = 101
            Width = 49
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'VAT'
          end
          object Label4: TLabel
            Left = 2
            Top = 75
            Width = 49
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Net'
          end
          object Label17: TLabel
            Left = 189
            Top = 75
            Width = 16
            Height = 14
            Caption = 'Net'
          end
          object Label20: TLabel
            Left = 183
            Top = 151
            Width = 22
            Height = 14
            Caption = 'Total'
          end
          object Label19: TLabel
            Left = 163
            Top = 126
            Width = 42
            Height = 14
            Caption = 'Discount'
          end
          object Label18: TLabel
            Left = 185
            Top = 101
            Width = 20
            Height = 14
            Caption = 'VAT'
          end
          object I5SDPF: TCurrencyEdit
            Tag = 1
            Left = 87
            Top = 19
            Width = 55
            Height = 22
            HelpContext = 288
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              ' 0.60')
            MaxLength = 6
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            WantReturns = False
            WordWrap = False
            OnExit = I5SDPFExit
            OnKeyPress = I5SDPFKeyPress
            AutoSize = False
            BlockNegative = True
            BlankOnZero = False
            DisplayFormat = ' 0.00;-0.00'
            ShowCurrency = False
            TextId = 0
            Value = 0.6
          end
          object I5SDDF: TCurrencyEdit
            Tag = 1
            Left = 195
            Top = 19
            Width = 46
            Height = 22
            HelpContext = 288
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              '0 ')
            MaxLength = 4
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            WantReturns = False
            WordWrap = False
            OnKeyPress = I5SDDFKeyPress
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0 ;###,###,##0-'
            DecPlaces = 0
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object SBSPanel63: TSBSPanel
            Left = 162
            Top = 49
            Width = 145
            Height = 17
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
            object Label21: TSBSPanel
              Left = 42
              Top = 2
              Width = 94
              Height = 14
              Alignment = taLeftJustify
              Caption = 'S.Discount Taken'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              AllowReSize = False
              IsGroupBox = False
              TextId = 0
              Purpose = puBtrListColumnHeader
            end
          end
          object SBSPanel62: TSBSPanel
            Left = 13
            Top = 49
            Width = 140
            Height = 17
            Color = clWhite
            TabOrder = 4
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
            object Label13: TSBSPanel
              Left = 16
              Top = 2
              Width = 115
              Height = 14
              Alignment = taLeftJustify
              Caption = 'S.Discount Not Taken'
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              AllowReSize = False
              IsGroupBox = False
              TextId = 0
              Purpose = puBtrListColumnHeader
            end
          end
          object I5Net1F: TCurrencyEdit
            Tag = 2
            Left = 54
            Top = 72
            Width = 99
            Height = 22
            HelpContext = 252
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
          object I5VAT1F: TCurrencyEdit
            Tag = 2
            Left = 54
            Top = 98
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 6
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
          object I5Disc1F: TCurrencyEdit
            Tag = 2
            Left = 54
            Top = 123
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 7
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
          object I5Tot1F: TCurrencyEdit
            Tag = 2
            Left = 54
            Top = 148
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 8
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
          object I5Tot2F: TCurrencyEdit
            Tag = 2
            Left = 208
            Top = 148
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 12
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
          object I5Disc2F: TCurrencyEdit
            Tag = 2
            Left = 208
            Top = 123
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 11
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
          object I5VAT2F: TCurrencyEdit
            Tag = 2
            Left = 208
            Top = 98
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 10
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
          object I5Net2F: TCurrencyEdit
            Tag = 2
            Left = 208
            Top = 72
            Width = 99
            Height = 22
            HelpContext = 252
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
            TabOrder = 9
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
          object I5SDTF: TCheckBox
            Tag = 1
            Left = 261
            Top = 18
            Width = 46
            Height = 20
            HelpContext = 288
            Alignment = taLeftJustify
            Caption = 'Taken'
            Color = clBtnFace
            Enabled = False
            ParentColor = False
            TabOrder = 2
          end
        end
        object TPage
          Left = 0
          Top = 0
          Caption = 'PromptPaymentDiscount'
          object shapePPDStatus: TShape
            Left = 186
            Top = 26
            Width = 128
            Height = 20
            Brush.Color = clInfoBk
            Pen.Color = clActiveBorder
            Shape = stRoundRect
          end
          object lblPromptPaymentDiscountHeader: TLabel
            Left = 2
            Top = 8
            Width = 122
            Height = 14
            Caption = 'Prompt Payment Discount'
          end
          object lblPPDPercentage: TLabel
            Left = 4
            Top = 28
            Width = 42
            Height = 14
            Caption = 'Discount'
          end
          object lblPPDPercentagePercent: TLabel
            Left = 102
            Top = 28
            Width = 10
            Height = 14
            Caption = '%'
          end
          object lblPPDDays: TLabel
            Left = 121
            Top = 28
            Width = 25
            Height = 14
            Caption = 'Days'
          end
          object bevPromptPaymentDiscountHeader: TBevel
            Left = 127
            Top = 15
            Width = 187
            Height = 3
            Shape = bsTopLine
          end
          object Label22: TLabel
            Left = 2
            Top = 69
            Width = 88
            Height = 14
            Caption = 'Transaction Totals'
          end
          object Bevel3: TBevel
            Left = 95
            Top = 76
            Width = 219
            Height = 3
            Shape = bsTopLine
          end
          object lblPPDStatus: TLabel
            Left = 188
            Top = 29
            Width = 124
            Height = 14
            Alignment = taCenter
            AutoSize = False
            Caption = 'Status: Taken/Expired'
            Transparent = True
          end
          object ccyPPDPercentage: TCurrencyEdit
            Tag = 1
            Left = 51
            Top = 25
            Width = 49
            Height = 22
            HelpContext = 288
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              ' 0.00')
            MaxLength = 6
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            WantReturns = False
            WordWrap = False
            OnExit = I5SDPFExit
            OnKeyPress = I5SDPFKeyPress
            AutoSize = False
            BlockNegative = True
            BlankOnZero = False
            DisplayFormat = ' 0.00;-0.00'
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object ccyPPDDays: TCurrencyEdit
            Tag = 1
            Left = 148
            Top = 25
            Width = 33
            Height = 22
            HelpContext = 288
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              '0 ')
            MaxLength = 3
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            WantReturns = False
            WordWrap = False
            OnExit = ccyPPDDaysExit
            OnKeyPress = I5SDDFKeyPress
            AutoSize = False
            BlockNegative = False
            BlankOnZero = False
            DisplayFormat = '###,###,##0 ;###,###,##0-'
            DecPlaces = 0
            ShowCurrency = False
            TextId = 0
            Value = 1E-10
          end
          object lvTransactionTotalsPPD: TListView
            Left = 1
            Top = 86
            Width = 313
            Height = 119
            Columns = <
              item
                Width = 55
              end
              item
                Alignment = taRightJustify
                Caption = 'PPD Not Taken '
                Width = 98
              end
              item
                Alignment = taRightJustify
                Caption = 'PPD '
                Width = 68
              end
              item
                Alignment = taRightJustify
                Caption = 'PPD Taken '
                Width = 82
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ReadOnly = True
            ParentFont = False
            TabOrder = 2
            ViewStyle = vsReport
          end
        end
        object TPage
          Left = 0
          Top = 0
          Caption = 'NoPromptPaymentDiscount'
          object Label10: TLabel
            Left = 2
            Top = 96
            Width = 88
            Height = 14
            Caption = 'Transaction Totals'
          end
          object Bevel4: TBevel
            Left = 93
            Top = 103
            Width = 137
            Height = 3
            Shape = bsTopLine
          end
          object lvTransactionTotals: TListView
            Left = 1
            Top = 113
            Width = 229
            Height = 92
            Columns = <
              item
                Width = 135
              end
              item
                Alignment = taRightJustify
                Caption = 'Totals'
                Width = 80
              end>
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ReadOnly = True
            ParentFont = False
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
      end
      object I5MVATF: TCheckBox
        Tag = 1
        Left = 10
        Top = 12
        Width = 131
        Height = 20
        HelpContext = 285
        Alignment = taLeftJustify
        Caption = ' Content Amended'
        Color = clBtnFace
        Enabled = False
        ParentColor = False
        TabOrder = 0
        OnClick = I5MVATFClick
      end
      object OkI5Btn: TButton
        Tag = 1
        Left = 538
        Top = 11
        Width = 80
        Height = 21
        HelpContext = 257
        Caption = '&OK'
        Enabled = False
        ModalResult = 1
        TabOrder = 7
        OnClick = OkI1BtnClick
      end
      object CanI5Btn: TButton
        Tag = 1
        Left = 538
        Top = 34
        Width = 80
        Height = 21
        HelpContext = 258
        Cancel = True
        Caption = '&Cancel'
        Enabled = False
        ModalResult = 2
        TabOrder = 8
        OnClick = OkI1BtnClick
      end
      object ClsI5Btn: TButton
        Left = 538
        Top = 57
        Width = 80
        Height = 21
        HelpContext = 259
        Cancel = True
        Caption = 'C&lose'
        ModalResult = 2
        TabOrder = 9
        OnClick = ClsI1BtnClick
      end
      object panOrderPayment: TSBSPanel
        Left = 0
        Top = 311
        Width = 295
        Height = 35
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 4
        Visible = False
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label12: TLabel
          Left = 8
          Top = 0
          Width = 81
          Height = 14
          Caption = 'Order Payments '
        end
        object Bevel7: TBevel
          Left = 92
          Top = 7
          Width = 195
          Height = 9
          Shape = bsTopLine
        end
        object chkCreateOrderPayment: TCheckBox
          Left = 13
          Top = 17
          Width = 268
          Height = 17
          Caption = 'Create a Payment for this Order'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
      end
    end
    object PayPage: TTabSheet
      Caption = 'Pay To'
      object RCSBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 192
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object RcHedPanel: TSBSPanel
          Left = -4
          Top = -1
          Width = 601
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object RcNLab: TSBSPanel
            Left = 6
            Top = 3
            Width = 53
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Code'
            Color = clWhite
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
          object RcBLab: TSBSPanel
            Left = 340
            Top = 3
            Width = 87
            Height = 13
            BevelOuter = bvNone
            Caption = 'Base Equiv.'
            Color = clWhite
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
          object RcDLab: TSBSPanel
            Left = 59
            Top = 3
            Width = 102
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Desc'
            Color = clWhite
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
          object RcPLab: TSBSPanel
            Left = 251
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Pay Amount'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RcQLab: TSBSPanel
            Left = 162
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Cheque No.'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RcRLab: TSBSPanel
            Left = 428
            Top = 3
            Width = 87
            Height = 13
            BevelOuter = bvNone
            Caption = 'Pay-In Ref'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object RcReconLab: TSBSPanel
            Left = 516
            Top = 4
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Recon Date'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object RcPPanel: TSBSPanel
          Left = 246
          Top = 17
          Width = 88
          Height = 155
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
        object RcNPanel: TSBSPanel
          Left = 2
          Top = 17
          Width = 54
          Height = 155
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
        object RCDPanel: TSBSPanel
          Left = 57
          Top = 17
          Width = 100
          Height = 155
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
        object RcBPanel: TSBSPanel
          Left = 335
          Top = 17
          Width = 89
          Height = 155
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object RcQPanel: TSBSPanel
          Left = 158
          Top = 17
          Width = 87
          Height = 155
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object RcRPanel: TSBSPanel
          Left = 425
          Top = 17
          Width = 87
          Height = 155
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object RcReconPanel: TSBSPanel
          Left = 513
          Top = 16
          Width = 87
          Height = 155
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object RcListBtnPanel: TSBSPanel
        Left = 504
        Top = 107
        Width = 18
        Height = 154
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object I6BtmPanel: TSBSPanel
        Left = 0
        Top = 312
        Width = 623
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label83: Label8
          Left = 286
          Top = 1
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
        object Label85: Label8
          Left = 368
          Top = 1
          Width = 43
          Height = 14
          Caption = 'Pay Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 468
          Top = 1
          Width = 43
          Height = 14
          Caption = 'Required'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
    end
    object NotesPage: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
      object TCNScrollBox: TScrollBox
        Left = 0
        Top = 88
        Width = 504
        Height = 228
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 2
          Top = 1
          Width = 480
          Height = 19
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
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
            Color = clWhite
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
            Width = 342
            Height = 16
            BevelOuter = bvNone
            Caption = 'Notes'
            Color = clWhite
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
            Left = 411
            Top = 2
            Width = 65
            Height = 16
            BevelOuter = bvNone
            Caption = 'User'
            Color = clWhite
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
          Top = 22
          Width = 65
          Height = 186
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
          Top = 22
          Width = 342
          Height = 186
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
          Left = 413
          Top = 22
          Width = 70
          Height = 186
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
        Left = 504
        Top = 110
        Width = 18
        Height = 185
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object I1BtnPanel: TSBSPanel
    Left = 526
    Top = 112
    Width = 102
    Height = 257
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Shape1: TShape
      Left = 0
      Top = 0
      Width = 65
      Height = 65
      Pen.Style = psClear
      Visible = False
    end
    object I1StatLab: Label8
      Left = 9
      Top = 8
      Width = 84
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'I1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object I1BSBox: TScrollBox
      Left = 1
      Top = 81
      Width = 99
      Height = 176
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      PopupMenu = PopupMenu1
      TabOrder = 0
      object EditI1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 261
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddI1BtnClick
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
      object InsI1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Insert new line|Choosing this option allows you to Insert a new ' +
          'line before the currently highlighted line.'
        HelpContext = 262
        Caption = '&Insert'
        TabOrder = 2
        OnClick = AddI1BtnClick
      end
      object MatI1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Match order details|Displays any matching information for the cu' +
          'rrently highlighted line.'
        HelpContext = 469
        Caption = '&Match'
        Enabled = False
        TabOrder = 4
        OnClick = MatI1BtnClick
      end
      object AddI1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the invoice.'
        HelpContext = 260
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddI1BtnClick
      end
      object FindI1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Find Stock Code|Choosing this option allows you to move to the n' +
          'ext line containing a specified Stock Code.'
        HelpContext = 264
        Caption = '&Find'
        TabOrder = 5
        OnClick = FindI1BtnClick
      end
      object APickI1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        HelpContext = 471
        Caption = 'A&uto'
        TabOrder = 7
        OnClick = APickI1BtnClick
      end
      object BkOrdI1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Display Back Orders for same account|Shows all outstanding order' +
          ' lines for the same account which could be delivered.'
        HelpContext = 470
        Caption = '&Back-Orders'
        Enabled = False
        TabOrder = 6
        OnClick = MatI1BtnClick
      end
      object SwiI1Btn: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Switch between alternative notepads|Switches the display of the ' +
          'notepad between dated notepad, & general notepad.'
        HelpContext = 90
        Caption = '&Switch To'
        TabOrder = 8
        OnClick = SwiI1BtnClick
      end
      object StatI1Btn: TButton
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Show bank cleared status|Displays the bank cleared status for th' +
          'e payment/receipt lines.'
        HelpContext = 408
        Caption = '&Status'
        TabOrder = 9
        OnClick = StatI1BtnClick
      end
      object LnkI1Btn: TButton
        Left = 2
        Top = 289
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 81
        Caption = 'Lin&ks'
        TabOrder = 12
        OnClick = LnkI1BtnClick
      end
      object CustTxBtn1: TSBSButton
        Tag = 1
        Left = 2
        Top = 404
        Width = 80
        Height = 21
        Caption = 'Custom 1'
        TabOrder = 14
        OnClick = CustTxBtn1Click
        TextId = 3
      end
      object CustTxBtn2: TSBSButton
        Tag = 2
        Left = 2
        Top = 428
        Width = 80
        Height = 21
        Caption = 'Custom 2'
        TabOrder = 15
        OnClick = CustTxBtn1Click
        TextId = 4
      end
      object WORI1Btn: TButton
        Left = 2
        Top = 241
        Width = 80
        Height = 21
        Hint = 
          'Generate a Works Order|Generate a Works Order from the currently' +
          ' highlighted line.'
        HelpContext = 408
        Caption = '&Works Order'
        TabOrder = 10
        OnClick = WORI1BtnClick
      end
      object RetI1Btn: TButton
        Left = 2
        Top = 265
        Width = 80
        Height = 21
        Hint = 
          'Generate a Returns Note|Generate a Returns Note from the current' +
          'ly highlighted line.'
        HelpContext = 1593
        Caption = '&Return'
        TabOrder = 11
        OnClick = RetI1BtnClick
      end
      object btnApplyTTD: TButton
        Left = 2
        Top = 313
        Width = 80
        Height = 21
        Hint = 'Apply Transaction Total Discount to this transaction'
        HelpContext = 8002
        Caption = 'Appl&y TTD'
        TabOrder = 13
        OnClick = btnApplyTTDClick
      end
      object CustTxBtn3: TSBSButton
        Tag = 3
        Left = 2
        Top = 452
        Width = 80
        Height = 21
        Caption = 'Custom 3'
        TabOrder = 16
        OnClick = CustTxBtn1Click
        TextId = 441
      end
      object CustTxBtn4: TSBSButton
        Tag = 4
        Left = 2
        Top = 476
        Width = 80
        Height = 21
        Caption = 'Custom 4'
        TabOrder = 17
        OnClick = CustTxBtn1Click
        TextId = 442
      end
      object CustTxBtn5: TSBSButton
        Tag = 5
        Left = 2
        Top = 500
        Width = 80
        Height = 21
        Caption = 'Custom 5'
        TabOrder = 18
        OnClick = CustTxBtn1Click
        TextId = 443
      end
      object CustTxBtn6: TSBSButton
        Tag = 6
        Left = 2
        Top = 524
        Width = 80
        Height = 21
        Caption = 'Custom 6'
        TabOrder = 19
        OnClick = CustTxBtn1Click
        TextId = 444
      end
      object btnCancelPPD: TButton
        Left = 2
        Top = 335
        Width = 80
        Height = 21
        Hint = 'Apply Transaction Total Discount to this transaction'
        HelpContext = 2212
        Caption = 'Cancel &PPD'
        TabOrder = 20
        OnClick = btnCancelPPDClick
      end
      object btnOPPayment: TSBSButton
        Tag = 1
        Left = 1
        Top = 358
        Width = 80
        Height = 21
        HelpContext = 2208
        Caption = '&Payment'
        TabOrder = 21
        OnClick = btnOPPaymentClick
        TextId = 0
      end
      object btnOPRefund: TSBSButton
        Tag = 1
        Left = 2
        Top = 382
        Width = 80
        Height = 21
        HelpContext = 2209
        Caption = 'Refu&nd'
        TabOrder = 22
        OnClick = btnOPRefundClick
        TextId = 0
      end
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
      TabOrder = 1
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
      TabOrder = 2
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
      TabOrder = 3
      OnClick = ClsI1BtnClick
    end
  end
  object I1FPanel: TSBSPanel
    Left = 2
    Top = 23
    Width = 627
    Height = 89
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 181
      Top = 36
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
    object I1CurrLab: Label8
      Left = 445
      Top = 36
      Width = 45
      Height = 14
      Caption = 'Currency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblAcCode: Label8
      Left = 4
      Top = 10
      Width = 18
      Height = 14
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object I1ExLab: Label8
      Left = 453
      Top = 62
      Width = 37
      Height = 14
      Caption = 'Ex.Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label88: Label8
      Left = 309
      Top = 11
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
    object Label817: Label8
      Left = 452
      Top = 10
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
    object I1DelBtn: TSpeedButton
      Left = 576
      Top = 59
      Width = 45
      Height = 22
      Hint = 'Edit Delivery Address|Displays the Delivery address box.'
      Caption = 'Deli&very'
      OnClick = I1DelBtnClick
    end
    object I1DueDateL: Label8
      Left = 184
      Top = 62
      Width = 19
      Height = 14
      Caption = 'Due'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SBSAccelLabel1: TSBSAccelLabel
      Left = 578
      Top = 44
      Width = 42
      Height = 14
      AccelChars = 'V'
      OnAccel = SBSAccelLabel1Accel
    end
    object I1AccF: Text8Pt
      Tag = 1
      Left = 25
      Top = 7
      Width = 263
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 238
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnDblClick = I1AddrFClick
      OnExit = I1AccFExit
      TextId = 0
      ViaSBtn = False
      ShowHilight = True
    end
    object I1OurRefF: Text8Pt
      Left = 491
      Top = 6
      Width = 78
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
      ReadOnly = True
      TabOrder = 0
      Text = 'SRC000080'
      TextId = 0
      ViaSBtn = False
    end
    object I1OpoF: Text8Pt
      Left = 572
      Top = 6
      Width = 51
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
      ReadOnly = True
      TabOrder = 1
      Text = 'Sally'
      TextId = 0
      ViaSBtn = False
    end
    object I1TransDateF: TEditDate
      Tag = 1
      Left = 208
      Top = 33
      Width = 80
      Height = 22
      HelpContext = 143
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
      TabOrder = 3
      OnExit = I1TransDateFExit
      Placement = cpAbove
    end
    object I1DueDateF: TEditDate
      Tag = 1
      Left = 208
      Top = 59
      Width = 80
      Height = 22
      HelpContext = 149
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
      TabOrder = 4
      OnExit = I1DueDateFExit
      Placement = cpAbove
    end
    object I1EXRateF: TCurrencyEdit
      Tag = 1
      Left = 491
      Top = 59
      Width = 78
      Height = 22
      HelpContext = 242
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      OnEnter = I1EXRateFEnter
      OnExit = I1EXRateFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object I1PrYrF: TEditPeriod
      Tag = 1
      Left = 349
      Top = 7
      Width = 84
      Height = 22
      HelpContext = 239
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
      TabOrder = 5
      Text = '011996'
      OnExit = I1PrYrFExit
      Placement = cpAbove
      EPeriod = 1
      EYear = 96
      ViewMask = '000/0000;0;'
      OnConvDate = I1PrYrFConvDate
      OnShowPeriod = I1PrYrFShowPeriod
    end
    object I1CurrF: TSBSComboBox
      Tag = 1
      Left = 491
      Top = 33
      Width = 78
      Height = 22
      HelpContext = 242
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
      TabOrder = 7
      OnExit = I1CurrFExit
      ExtendedList = True
      MaxListWidth = 90
      ReadOnly = True
      Validate = True
    end
    object I1DumPanel: TSBSPanel
      Left = 576
      Top = 36
      Width = 0
      Height = 0
      BevelOuter = bvNone
      Enabled = False
      TabOrder = 10
      Visible = False
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object FixXRF: TBorCheck
      Tag = 1
      Left = 572
      Top = 35
      Width = 50
      Height = 20
      HelpContext = 1171
      Caption = 'Fixed'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 8
      TabStop = True
      TextId = 0
      Visible = False
    end
    object I1AddrF: TMemo
      Left = 2
      Top = 33
      Width = 175
      Height = 48
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 230
      TabStop = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      WantReturns = False
      OnDblClick = I1AddrFClick
    end
    object TransExtForm1: TSBSExtendedForm
      Left = 288
      Top = 29
      Width = 156
      Height = 58
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 6
      OnEnter = TransExtForm1Enter
      OnExit = TransExtForm1Exit
      OnResize = TransExtForm1Resize
      ArrowPos = alNone
      ArrowY = -4
      OrigHeight = 58
      OrigWidth = 156
      ExpandedWidth = 329
      ExpandedHeight = 289
      OrigTabOrder = 6
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = I1FPanel
      NewParent = Owner
      FocusFirst = I1YrRefF
      FocusLast = edtUdf12
      TabPrev = I1PrYrF
      TabNext = I1CurrF
      OnCloseUp = TransExtForm1CloseUp
      object I4JobCodeL: Label8
        Left = 8
        Top = 72
        Width = 45
        Height = 14
        Caption = 'Job Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object I4JAnalL: Label8
        Left = 172
        Top = 72
        Width = 42
        Height = 14
        Caption = 'Analysis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object I1YrRefL: Label8
        Left = 9
        Top = 8
        Width = 43
        Height = 14
        Caption = 'Your Ref'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object I1YrRef2L: Label8
        Left = 17
        Top = 33
        Width = 36
        Height = 14
        Caption = 'Alt. Ref'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF1L: Label8
        Left = 6
        Top = 142
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF3L: Label8
        Left = 6
        Top = 166
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF2L: Label8
        Left = 163
        Top = 142
        Width = 53
        Height = 14
        AutoSize = False
        Caption = 'UD Field 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF4L: Label8
        Left = 163
        Top = 166
        Width = 53
        Height = 14
        AutoSize = False
        Caption = 'UD Field 4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel1: TBevel
        Left = 7
        Top = 58
        Width = 308
        Height = 2
      end
      object bevBelowJob: TBevel
        Left = 8
        Top = 95
        Width = 308
        Height = 2
      end
      object I5NBL: Label8
        Left = 175
        Top = 33
        Width = 54
        Height = 14
        Caption = 'Box Labels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblOverrideLocation: Label8
        Left = 11
        Top = 107
        Width = 86
        Height = 14
        Caption = 'Override Location'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bevBelowOverrideLocation: TBevel
        Left = 8
        Top = 130
        Width = 308
        Height = 2
      end
      object WkMonthLbl: Label8
        Left = 180
        Top = 8
        Width = 47
        Height = 14
        Caption = 'Wk/Month'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf5: Label8
        Left = 6
        Top = 190
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf6: Label8
        Left = 163
        Top = 190
        Width = 53
        Height = 14
        AutoSize = False
        Caption = 'UD Field 6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf7: Label8
        Left = 6
        Top = 214
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf8: Label8
        Left = 163
        Top = 214
        Width = 53
        Height = 14
        AutoSize = False
        Caption = 'UD Field 8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf9: Label8
        Left = 6
        Top = 238
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf10: Label8
        Left = 163
        Top = 238
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf11: Label8
        Left = 6
        Top = 262
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 11'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblUdf12: Label8
        Left = 163
        Top = 262
        Width = 59
        Height = 14
        AutoSize = False
        Caption = 'UD Field 12'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object THUD1F: Text8Pt
        Tag = 1
        Left = 66
        Top = 138
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD3F: Text8Pt
        Tag = 1
        Left = 66
        Top = 162
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD4F: Text8Pt
        Tag = 1
        Left = 225
        Top = 162
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD2F: Text8Pt
        Tag = 1
        Left = 225
        Top = 138
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object I1YrRefF: Text8Pt
        Tag = 1
        Left = 61
        Top = 6
        Width = 84
        Height = 22
        HelpContext = 148
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnChange = I1YrRefFChange
        OnEnter = I1YrRefFEnter
        OnExit = I1YrRefFExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object I1YrRef2F: Text8Pt
        Tag = 1
        Left = 61
        Top = 30
        Width = 84
        Height = 22
        HelpContext = 240
        CharCase = ecUpperCase
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnChange = I1YrRef2FChange
        OnEnter = I1YrRef2FEnter
        OnExit = I1YrRef2FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object I4JobCodeF: Text8Pt
        Tag = 1
        Left = 66
        Top = 68
        Width = 90
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking or using the down but' +
          'ton will drill down to the record for this field. The up button ' +
          'will search for the nearest match.'
        HelpContext = 465
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        OnExit = I4JobCodeFExit
        TextId = 0
        ViaSBtn = False
        Link_to_Job = True
        ShowHilight = True
      end
      object I4JobAnalF: Text8Pt
        Tag = 1
        Left = 225
        Top = 68
        Width = 90
        Height = 22
        HelpContext = 466
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        OnExit = I4JobAnalFExit
        TextId = 0
        ViaSBtn = False
      end
      object I5NBF: TCurrencyEdit
        Tag = 1
        Left = 249
        Top = 30
        Width = 65
        Height = 22
        HelpContext = 472
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '1-')
        MaxLength = 4
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object edtOverrideLocation: Text8Pt
        Tag = 1
        Left = 112
        Top = 103
        Width = 44
        Height = 22
        HelpContext = 40164
        CharCase = ecUpperCase
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 3
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
        OnExit = edtOverrideLocationExit
        TextId = 0
        ViaSBtn = False
      end
      object WkMonthEdt: TCurrencyEdit
        Tag = 1
        Left = 249
        Top = 6
        Width = 65
        Height = 22
        HelpContext = 472
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '1-')
        MaxLength = 4
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = -0.666666
      end
      object edtUdf5: Text8Pt
        Tag = 1
        Left = 66
        Top = 186
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 11
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf6: Text8Pt
        Tag = 1
        Left = 225
        Top = 186
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf7: Text8Pt
        Tag = 1
        Left = 66
        Top = 210
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 13
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf8: Text8Pt
        Tag = 1
        Left = 224
        Top = 210
        Width = 91
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 14
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf9: Text8Pt
        Tag = 1
        Left = 66
        Top = 234
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 15
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf10: Text8Pt
        Tag = 1
        Left = 224
        Top = 234
        Width = 91
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 16
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf11: Text8Pt
        Tag = 1
        Left = 66
        Top = 258
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 17
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object edtUdf12: Text8Pt
        Tag = 1
        Left = 224
        Top = 258
        Width = 91
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 18
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = 0
    Top = 382
    Width = 660
    Height = 42
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 0
      Width = 652
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 215
      Top = 7
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
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 592
    Top = 4
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
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = DelI1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match'
      Hint = 
        'Displays any matching information for the currently highlighted ' +
        'line.'
      OnClick = MatI1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      Hint = 
        'Choosing this option allows you to move to the next line contain' +
        'ing a specified Stock Code.'
      OnClick = FindI1BtnClick
    end
    object BackOrders1: TMenuItem
      Caption = '&Back Orders'
      Hint = 
        'Shows all outstanding order lines for the same account which cou' +
        'ld be delivered.'
      OnClick = MatI1BtnClick
    end
    object AutoPick1: TMenuItem
      Caption = 'A&uto'
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SwiI1BtnClick
    end
    object Status1: TMenuItem
      Caption = '&Status'
      Hint = 'Displays the bank cleared status for the payment/receipt lines.'
      OnClick = StatI1BtnClick
    end
    object WOR1: TMenuItem
      Caption = '&Works Order'
      Hint = 
        'Generate a Works Order|Generate a Works Order from the currently' +
        ' highlighted line.'
      OnClick = WORI1BtnClick
    end
    object Ret1: TMenuItem
      Caption = '&Return'
      Hint = '|Generate a Returns Note from the currently highlighted line.'
      OnClick = RetI1BtnClick
    end
    object Link1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
      OnClick = LnkI1BtnClick
    end
    object mnuApplyTTD: TMenuItem
      Caption = 'Appl&y TTD'
      OnClick = btnApplyTTDClick
    end
    object mnuCancelPPD: TMenuItem
      Caption = 'Cancel &PPD'
      HelpContext = 2212
      Hint = 'Apply Transaction Total Discount to this transaction'
      OnClick = btnCancelPPDClick
    end
    object mnuOrdPayPayment: TMenuItem
      Caption = '&Payment'
      HelpContext = 2208
      OnClick = btnOPPaymentClick
    end
    object mnuOrdPayRefund: TMenuItem
      Caption = '&Refund'
      HelpContext = 2209
      OnClick = btnOPRefundClick
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = '&Custom 1'
      OnClick = CustTxBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = '&Custom 2'
      OnClick = CustTxBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom 3'
      OnClick = CustTxBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom 4'
      OnClick = CustTxBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom 5'
      OnClick = CustTxBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom 6'
      OnClick = CustTxBtn1Click
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
  object PopupMenu2: TPopupMenu
    Left = 620
    Top = 4
    object AP1: TMenuItem
      Tag = 1
      Caption = '&Pick'
      HelpContext = 52
      Hint = 'Automaticaly picks any outstanding lines with available stock.'
      OnClick = AP1Click
    end
    object AW1: TMenuItem
      Tag = 2
      Caption = '&Write Off'
      HelpContext = 52
      Hint = 'Automaticaly writes off any outstanding lines.'
      OnClick = AP1Click
    end
    object ARW1: TMenuItem
      Tag = 3
      Caption = '&Remove Write Off'
      Hint = 
        'Automaticaly resets the write off qty for all lines with write o' +
        'ff set.'
      OnClick = AP1Click
    end
  end
  object EntCustom3: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'X:\ENTRPRSE\CUSTOM\DEMOHOOK\Daybk1.RC'
    WindowId = 102000
    Left = 536
    Top = 4
  end
  object mnuSwitchNotes: TPopupMenu
    Left = 564
    Top = 4
    object General1: TMenuItem
      Caption = '&General Notes'
      OnClick = General1Click
    end
    object Dated1: TMenuItem
      Caption = '&Dated Notes'
      OnClick = Dated1Click
    end
    object AuditHistory1: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = AuditHistory1Click
    end
  end
end
