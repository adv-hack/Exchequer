object ExtendedSearch: TExtendedSearch
  Left = 460
  Top = 219
  ActiveControl = CustSuppGrid
  BorderStyle = bsDialog
  Caption = ' Extended search...'
  ClientHeight = 389
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    559
    389)
  PixelsPerInch = 96
  TextHeight = 14
  object PageDetails: TPageControl
    Left = 6
    Top = 6
    Width = 549
    Height = 378
    ActivePage = CustSuppTAB
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 0
    TabOrder = 0
    object CustSuppTAB: TTabSheet
      Caption = 'Search criteria...'
      ImageIndex = 7
      DesignSize = (
        541
        349)
      object SearchTxtLbl: TLabel
        Left = 5
        Top = 3
        Width = 288
        Height = 14
        Caption = 'Search details (separate multiple keywords with a space)...'
      end
      object Label3: TLabel
        Left = 4
        Top = 335
        Width = 491
        Height = 14
        Anchors = [akLeft, akBottom]
        Caption = 
          'To select a code, simply press ENTER or dbl-click the item requi' +
          'red.  To cancel, press the ESCAPE key.'
      end
      object SearchText: TEdit
        Left = 5
        Top = 19
        Width = 451
        Height = 22
        TabOrder = 0
      end
      object CustSuppGrid: TListView
        Left = 4
        Top = 59
        Width = 533
        Height = 167
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Lookup Code...'
            Width = 140
          end
          item
            Caption = 'Lookup Description...'
            Width = 365
          end
          item
            Caption = 'Desc1'
            Width = 0
          end
          item
            Caption = 'Desc2'
            Width = 0
          end
          item
            Caption = 'Desc3'
            Width = 0
          end
          item
            Caption = 'Desc4'
            Width = 0
          end
          item
            Caption = 'Desc5'
            Width = 0
          end
          item
            Caption = 'Desc6'
            Width = 0
          end
          item
            Caption = 'UnitStock'
            Width = 0
          end
          item
            Caption = 'UnitSale'
            Width = 0
          end
          item
            Caption = 'UnitPurchase'
            Width = 0
          end
          item
            Caption = 'InStk'
            Width = 0
          end
          item
            Caption = 'OnOrder'
            Width = 0
          end
          item
            Caption = 'Picked'
            Width = 0
          end
          item
            Caption = 'Free'
            Width = 0
          end
          item
            Caption = 'User1'
            Width = 0
          end
          item
            Caption = 'User2'
            Width = 0
          end
          item
            Caption = 'User3'
            Width = 0
          end
          item
            Caption = 'User4'
            Width = 0
          end
          item
            Caption = 'PriceA'
            Width = 0
          end
          item
            Caption = 'PriceB'
            Width = 0
          end
          item
            Caption = 'PriceC'
            Width = 0
          end
          item
            Caption = 'PriceD'
            Width = 0
          end
          item
            Caption = 'PriceE'
            Width = 0
          end
          item
            Caption = 'PriceF'
            Width = 0
          end
          item
            Caption = 'PriceG'
            Width = 0
          end
          item
            Caption = 'PriceH'
            Width = 0
          end
          item
            Caption = 'SalesGL'
            Width = 0
          end
          item
            Caption = 'Desc7'
            Width = 0
          end>
        HideSelection = False
        HotTrack = True
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        ViewStyle = vsReport
        OnChange = CustSuppGridChange
        OnCustomDrawSubItem = CustSuppGridCustomDrawSubItem
        OnDblClick = CustSuppGridDblClick
        OnEnter = CustSuppGridEnter
        OnExit = CustSuppGridExit
      end
      object Panel1: TPanel
        Left = 4
        Top = 225
        Width = 533
        Height = 105
        BevelOuter = bvLowered
        TabOrder = 3
        object Desc1: TLabel
          Left = 4
          Top = 4
          Width = 31
          Height = 14
          Caption = 'Desc1'
        end
        object Desc2: TLabel
          Left = 4
          Top = 18
          Width = 31
          Height = 14
          Caption = 'Desc2'
        end
        object Desc3: TLabel
          Left = 4
          Top = 32
          Width = 31
          Height = 14
          Caption = 'Desc3'
        end
        object Desc4: TLabel
          Left = 4
          Top = 46
          Width = 31
          Height = 14
          Caption = 'Desc4'
        end
        object Desc5: TLabel
          Left = 4
          Top = 61
          Width = 31
          Height = 14
          Caption = 'Desc5'
        end
        object DescValue1: TLabel
          Left = 76
          Top = 4
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object DescValue2: TLabel
          Left = 76
          Top = 18
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object DescValue3: TLabel
          Left = 76
          Top = 32
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object DescValue4: TLabel
          Left = 76
          Top = 46
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object DescValue5: TLabel
          Left = 76
          Top = 61
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object Desc6: TLabel
          Left = 4
          Top = 75
          Width = 31
          Height = 14
          Caption = 'Desc6'
        end
        object DescValue6: TLabel
          Left = 76
          Top = 75
          Width = 43
          Height = 14
          Caption = '<details>'
        end
        object UnitStock: TLabel
          Left = 315
          Top = 74
          Width = 55
          Height = 14
          Caption = 'Unit - Stock'
          Visible = False
        end
        object UnitSale: TLabel
          Left = 389
          Top = 74
          Width = 49
          Height = 14
          Caption = 'Unit - Sale'
          Visible = False
        end
        object UnitPurchase: TLabel
          Left = 456
          Top = 74
          Width = 74
          Height = 14
          Caption = 'Unit - Purchase'
          Visible = False
        end
        object UnitPurchaseVal: TLabel
          Left = 456
          Top = 88
          Width = 43
          Height = 14
          Caption = '<details>'
          Visible = False
        end
        object UnitSaleVal: TLabel
          Left = 389
          Top = 88
          Width = 43
          Height = 14
          Caption = '<details>'
          Visible = False
        end
        object UnitStockVal: TLabel
          Left = 315
          Top = 88
          Width = 43
          Height = 14
          Caption = '<details>'
          Visible = False
        end
        object QtyStk: TLabel
          Left = 367
          Top = 4
          Width = 58
          Height = 14
          Caption = 'Qty In Stock'
          Visible = False
        end
        object QtyStkVal: TLabel
          Left = 464
          Top = 4
          Width = 61
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '<details>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object QtyOrd: TLabel
          Left = 367
          Top = 18
          Width = 65
          Height = 14
          Caption = 'Qty On Order'
          Visible = False
        end
        object QtyOrdVal: TLabel
          Left = 464
          Top = 18
          Width = 61
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '<details>'
          Visible = False
        end
        object QtyPick: TLabel
          Left = 367
          Top = 32
          Width = 79
          Height = 14
          Caption = 'Qty Allloc/Picked'
          Visible = False
        end
        object QtyFree: TLabel
          Left = 367
          Top = 46
          Width = 42
          Height = 14
          Caption = 'Qty Free'
          Visible = False
        end
        object QtyFreeVal: TLabel
          Left = 464
          Top = 46
          Width = 61
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '<details>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object QtyPickVal: TLabel
          Left = 464
          Top = 32
          Width = 61
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '<details>'
          Visible = False
        end
        object Desc7: TLabel
          Left = 4
          Top = 89
          Width = 31
          Height = 14
          Caption = 'Desc7'
        end
        object DescValue7: TLabel
          Left = 76
          Top = 89
          Width = 43
          Height = 14
          Caption = '<details>'
        end
      end
      object SearchBtn: TButton
        Left = 460
        Top = 19
        Width = 76
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '&Search'
        TabOrder = 1
        OnClick = SearchBtnClick
      end
    end
  end
  object ADODataConnection: TADOConnection
    ConnectionString = 'FILE NAME=C:\DEVELOP\DELPHI\ENTHOOKS-DLL\EXTSRCH\EXTSRCH.UDL'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 335
    Top = 6
  end
  object ADOQuery: TADOQuery
    Connection = ADODataConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    Left = 418
    Top = 1
  end
end
