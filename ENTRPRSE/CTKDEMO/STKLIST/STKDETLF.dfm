object frmStockDetail: TfrmStockDetail
  Left = 356
  Top = 152
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmStockDetail'
  ClientHeight = 355
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 5
    Top = 3
    Width = 504
    Height = 348
    ActivePage = tabDefaults
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    object tabMain: TTabSheet
      Caption = 'Main'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 1
        Width = 240
        Height = 99
        Caption = ' Stock Code / Description '
        TabOrder = 0
        object Label1: TLabel
          Left = 122
          Top = 18
          Width = 31
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Type'
        end
        object edtAcCode: TEdit
          Left = 8
          Top = 15
          Width = 113
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 16
          TabOrder = 0
        end
        object ScrollBox1: TScrollBox
          Left = 8
          Top = 38
          Width = 224
          Height = 53
          HorzScrollBar.Visible = False
          TabOrder = 2
          object Label2: TLabel
            Left = 191
            Top = 5
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '1'
          end
          object Label3: TLabel
            Left = 191
            Top = 24
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '2'
          end
          object Label4: TLabel
            Left = 191
            Top = 46
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '3'
          end
          object Label5: TLabel
            Left = 191
            Top = 67
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '4'
          end
          object Label6: TLabel
            Left = 191
            Top = 88
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '5'
          end
          object Label7: TLabel
            Left = 191
            Top = 108
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '6'
          end
          object edtDesc1: TEdit
            Left = 1
            Top = 0
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 0
          end
          object edtDesc2: TEdit
            Left = 1
            Top = 21
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 1
          end
          object edtDesc3: TEdit
            Left = 1
            Top = 42
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 2
          end
          object edtDesc4: TEdit
            Left = 1
            Top = 63
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 3
          end
          object edtDesc5: TEdit
            Left = 1
            Top = 84
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 4
          end
          object edtDesc6: TEdit
            Left = 1
            Top = 105
            Width = 189
            Height = 21
            MaxLength = 45
            TabOrder = 5
          end
        end
        object lstStockType: TComboBox
          Left = 156
          Top = 15
          Width = 77
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Group'
            'Product'
            'Description'
            'Bill Of Materials'
            'Discontinued')
        end
      end
      object GroupBox2: TGroupBox
        Left = 250
        Top = 1
        Width = 144
        Height = 209
        TabOrder = 1
        object Label8: TLabel
          Left = 5
          Top = 19
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Min Stk'
        end
        object Label9: TLabel
          Left = 5
          Top = 41
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Max Stk'
        end
        object Bevel1: TBevel
          Left = 5
          Top = 66
          Width = 133
          Height = 2
          Shape = bsTopLine
        end
        object Label10: TLabel
          Left = 5
          Top = 78
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'In Stk'
        end
        object Label11: TLabel
          Left = 5
          Top = 101
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '(Posted)'
        end
        object Label12: TLabel
          Left = 5
          Top = 126
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Allocated'
        end
        object Label13: TLabel
          Left = 5
          Top = 149
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Free Stk'
        end
        object Bevel2: TBevel
          Left = 5
          Top = 173
          Width = 133
          Height = 2
          Shape = bsTopLine
        end
        object Label14: TLabel
          Left = 5
          Top = 184
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'On Order'
        end
        object edtMinStock: TEdit
          Left = 59
          Top = 15
          Width = 78
          Height = 21
          TabOrder = 0
        end
        object edtMaxStock: TEdit
          Left = 59
          Top = 38
          Width = 78
          Height = 21
          TabOrder = 1
        end
        object edtQtyInStock: TEdit
          Left = 59
          Top = 74
          Width = 78
          Height = 21
          Enabled = False
          TabOrder = 2
        end
        object edtQtyPosted: TEdit
          Left = 59
          Top = 98
          Width = 78
          Height = 21
          Enabled = False
          TabOrder = 3
        end
        object edtQtyAllocated: TEdit
          Left = 59
          Top = 122
          Width = 78
          Height = 21
          Enabled = False
          TabOrder = 4
        end
        object edtQtyFree: TEdit
          Left = 59
          Top = 146
          Width = 78
          Height = 21
          Enabled = False
          TabOrder = 5
        end
        object edtQtyOnOrder: TEdit
          Left = 59
          Top = 181
          Width = 78
          Height = 21
          Enabled = False
          TabOrder = 6
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 102
        Width = 240
        Height = 159
        TabOrder = 2
        object Label15: TLabel
          Left = 3
          Top = 16
          Width = 47
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Priced by'
        end
        object Label16: TLabel
          Left = 7
          Top = 58
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sales'
        end
        object Label17: TLabel
          Left = 52
          Top = 37
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Currency'
        end
        object Label18: TLabel
          Left = 108
          Top = 37
          Width = 46
          Height = 13
          AutoSize = False
          Caption = 'Value'
        end
        object Label27: TLabel
          Left = 7
          Top = 84
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cost'
        end
        object Label28: TLabel
          Left = 7
          Top = 108
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Re-order'
        end
        object Label30: TLabel
          Left = 3
          Top = 128
          Width = 46
          Height = 27
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Valuation Method'
          WordWrap = True
        end
        object lstPricedBy: TComboBox
          Left = 52
          Top = 13
          Width = 181
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'Stock Unit - '
            'Sales Unit - '
            'Split Pack - ')
        end
        object ScrollBox2: TScrollBox
          Left = 51
          Top = 52
          Width = 181
          Height = 26
          HorzScrollBar.Visible = False
          TabOrder = 1
          object Label19: TLabel
            Left = 150
            Top = 5
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'A'
          end
          object Label20: TLabel
            Left = 150
            Top = 27
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'B'
          end
          object Label21: TLabel
            Left = 150
            Top = 49
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'C'
          end
          object Label22: TLabel
            Left = 150
            Top = 70
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'D'
          end
          object Label23: TLabel
            Left = 150
            Top = 93
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'E'
          end
          object Label24: TLabel
            Left = 149
            Top = 115
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'F'
          end
          object Label25: TLabel
            Left = 149
            Top = 137
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'G'
          end
          object Label26: TLabel
            Left = 149
            Top = 159
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = 'H'
          end
          object lstCcyA: TComboBox
            Left = 1
            Top = 1
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 0
          end
          object edtSalesPriceA: TEdit
            Left = 50
            Top = 1
            Width = 98
            Height = 21
            TabOrder = 1
          end
          object lstCcyB: TComboBox
            Left = 1
            Top = 23
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 2
          end
          object edtSalesPriceB: TEdit
            Left = 50
            Top = 23
            Width = 98
            Height = 21
            TabOrder = 3
          end
          object lstCcyC: TComboBox
            Left = 1
            Top = 45
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 4
          end
          object edtSalesPriceC: TEdit
            Left = 50
            Top = 45
            Width = 98
            Height = 21
            TabOrder = 5
          end
          object lstCcyD: TComboBox
            Left = 1
            Top = 67
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 6
          end
          object edtSalesPriceD: TEdit
            Left = 50
            Top = 67
            Width = 98
            Height = 21
            TabOrder = 7
          end
          object lstCcyE: TComboBox
            Left = 1
            Top = 89
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 8
          end
          object edtSalesPriceE: TEdit
            Left = 50
            Top = 89
            Width = 98
            Height = 21
            TabOrder = 9
          end
          object lstCcyF: TComboBox
            Left = 1
            Top = 111
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 10
          end
          object edtSalesPriceF: TEdit
            Left = 50
            Top = 111
            Width = 98
            Height = 21
            TabOrder = 11
          end
          object lstCcyG: TComboBox
            Left = 1
            Top = 133
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 12
          end
          object edtSalesPriceG: TEdit
            Left = 50
            Top = 133
            Width = 98
            Height = 21
            TabOrder = 13
          end
          object lstCcyH: TComboBox
            Left = 1
            Top = 155
            Width = 47
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 14
          end
          object edtSalesPriceH: TEdit
            Left = 50
            Top = 155
            Width = 98
            Height = 21
            TabOrder = 15
          end
        end
        object lstCcyCost: TComboBox
          Left = 51
          Top = 81
          Width = 47
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 2
        end
        object edtCostPrice: TEdit
          Left = 100
          Top = 81
          Width = 98
          Height = 21
          TabOrder = 3
        end
        object lstCcyReorder: TComboBox
          Left = 51
          Top = 105
          Width = 47
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 4
        end
        object edtReorderPrice: TEdit
          Left = 100
          Top = 105
          Width = 98
          Height = 21
          TabOrder = 5
        end
        object lstValMethod: TComboBox
          Left = 51
          Top = 130
          Width = 147
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
          Items.Strings = (
            'Standard'
            'Last Cost'
            'FIFO'
            'LIFO'
            'Average'
            'Serial/Batch'
            'Serial/Batch Average Cost')
        end
      end
      object GroupBox4: TGroupBox
        Left = 250
        Top = 212
        Width = 145
        Height = 49
        TabOrder = 3
        object Label29: TLabel
          Left = 8
          Top = 12
          Width = 103
          Height = 26
          Caption = 'Show stock levels as sales units (packs)'
          WordWrap = True
          OnClick = Label29Click
        end
        object chkShowAsPacks: TCheckBox
          Left = 110
          Top = 11
          Width = 20
          Height = 29
          Alignment = taLeftJustify
          TabOrder = 0
        end
      end
    end
    object tabDefaults: TTabSheet
      Caption = 'Defaults'
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 4
        Top = 1
        Width = 205
        Height = 139
        TabOrder = 0
        object Label31: TLabel
          Left = 2
          Top = 18
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pref. Supplier'
        end
        object Label32: TLabel
          Left = 2
          Top = 41
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alt. Code'
        end
        object Label43: TLabel
          Left = 2
          Top = 64
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CC / Dept'
        end
        object Label44: TLabel
          Left = 2
          Top = 88
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Location / Bin'
        end
        object Label45: TLabel
          Left = 2
          Top = 113
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bar Code'
        end
        object edtSupplier: TEdit
          Left = 73
          Top = 15
          Width = 87
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 0
          OnDblClick = edtSupplierDblClick
        end
        object edtAltCode: TEdit
          Left = 73
          Top = 38
          Width = 125
          Height = 21
          CharCase = ecUpperCase
          TabOrder = 1
        end
        object edtCC: TEdit
          Left = 73
          Top = 61
          Width = 61
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 2
        end
        object edtDept: TEdit
          Left = 137
          Top = 61
          Width = 61
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 3
        end
        object edtLocation: TEdit
          Left = 73
          Top = 85
          Width = 61
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 4
        end
        object edtBin: TEdit
          Left = 137
          Top = 85
          Width = 61
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 5
        end
        object edtBarCode: TEdit
          Left = 73
          Top = 109
          Width = 125
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 6
        end
      end
      object GroupBox6: TGroupBox
        Left = 215
        Top = 1
        Width = 178
        Height = 139
        TabOrder = 1
        object Label33: TLabel
          Left = 3
          Top = 19
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit of Stock'
        end
        object Label34: TLabel
          Left = 3
          Top = 41
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit of Sale'
        end
        object Label35: TLabel
          Left = 3
          Top = 65
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit of Purchase'
        end
        object Label36: TLabel
          Left = 3
          Top = 88
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sales Units/Stock'
        end
        object Label6756: TLabel
          Left = 3
          Top = 113
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Purch Units/Stock'
        end
        object edtUnitStock: TEdit
          Left = 97
          Top = 15
          Width = 73
          Height = 21
          TabOrder = 0
        end
        object edtUnitSale: TEdit
          Left = 97
          Top = 38
          Width = 73
          Height = 21
          TabOrder = 1
        end
        object edtUnitPurchase: TEdit
          Left = 97
          Top = 61
          Width = 73
          Height = 21
          TabOrder = 2
        end
        object edtSalesUnits: TEdit
          Left = 97
          Top = 85
          Width = 73
          Height = 21
          TabOrder = 3
        end
        object edtPurchUnits: TEdit
          Left = 97
          Top = 109
          Width = 73
          Height = 21
          TabOrder = 4
        end
      end
      object GroupBox7: TGroupBox
        Left = 4
        Top = 142
        Width = 389
        Height = 173
        TabOrder = 2
        object Label37: TLabel
          Left = 2
          Top = 19
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sales'
        end
        object Label38: TLabel
          Left = 2
          Top = 41
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cost Of Sales'
        end
        object Label39: TLabel
          Left = 2
          Top = 65
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Closing Stk/Write Offs'
        end
        object Label40: TLabel
          Left = 2
          Top = 88
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Stock Value'
        end
        object Label41: TLabel
          Left = 2
          Top = 113
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'BOM / Finished Goods'
        end
        object Bevel3: TBevel
          Left = 5
          Top = 136
          Width = 378
          Height = 2
          Shape = bsTopLine
        end
        object Label42: TLabel
          Left = 2
          Top = 148
          Width = 109
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Job Costing Analysis'
        end
        object edtGLSales: TEdit
          Left = 113
          Top = 15
          Width = 51
          Height = 21
          TabOrder = 0
        end
        object edtGLCOS: TEdit
          Left = 113
          Top = 38
          Width = 51
          Height = 21
          TabOrder = 1
        end
        object edtGLWO: TEdit
          Left = 113
          Top = 61
          Width = 51
          Height = 21
          TabOrder = 2
        end
        object edtGLStkVal: TEdit
          Left = 113
          Top = 85
          Width = 51
          Height = 21
          TabOrder = 3
        end
        object edtGLBOM: TEdit
          Left = 113
          Top = 109
          Width = 51
          Height = 21
          TabOrder = 4
        end
        object edtJobAnal: TEdit
          Left = 113
          Top = 144
          Width = 73
          Height = 21
          TabOrder = 5
        end
      end
      object Button1: TButton
        Left = 293
        Top = 166
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 3
        OnClick = Button1Click
      end
    end
    object tabVAT: TTabSheet
      Caption = 'VAT / Web'
      ImageIndex = 2
      object GroupBox8: TGroupBox
        Left = 3
        Top = 1
        Width = 191
        Height = 293
        TabOrder = 0
        object Label46: TLabel
          Left = 11
          Top = 101
          Width = 47
          Height = 13
          Alignment = taRightJustify
          Caption = 'VAT Rate'
        end
        object Label48: TLabel
          Left = 2
          Top = 43
          Width = 83
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Web Catalogue'
        end
        object Label49: TLabel
          Left = 3
          Top = 65
          Width = 82
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Image Filename'
        end
        object Bevel5: TBevel
          Left = 5
          Top = 90
          Width = 180
          Height = 2
          Shape = bsTopLine
        end
        object Label50: TLabel
          Left = 3
          Top = 126
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Commodity Code'
        end
        object Label51: TLabel
          Left = 3
          Top = 150
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'SSD Unit Desc'
        end
        object Label52: TLabel
          Left = 3
          Top = 173
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Stock Units in SSD'
        end
        object Label53: TLabel
          Left = 3
          Top = 198
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sales Unit Weight'
        end
        object Label54: TLabel
          Left = 3
          Top = 220
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Purch Unit Weight'
        end
        object Label55: TLabel
          Left = 3
          Top = 245
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'SSD State Uplift'
        end
        object Label56: TLabel
          Left = 3
          Top = 268
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Country of Origin'
        end
        object lstVATRate: TComboBox
          Left = 62
          Top = 98
          Width = 59
          Height = 21
          ItemHeight = 0
          TabOrder = 3
        end
        object chkInclOnWeb: TCheckBox
          Left = 7
          Top = 18
          Width = 96
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Include on Web'
          TabOrder = 0
        end
        object edtImage: TEdit
          Left = 90
          Top = 63
          Width = 95
          Height = 21
          TabOrder = 2
        end
        object edtWebCat: TEdit
          Left = 90
          Top = 40
          Width = 96
          Height = 21
          TabOrder = 1
        end
        object edtCommodity: TEdit
          Left = 97
          Top = 123
          Width = 87
          Height = 21
          TabOrder = 4
        end
        object edtUnitDesc: TEdit
          Left = 97
          Top = 146
          Width = 87
          Height = 21
          TabOrder = 5
        end
        object edtSKUnits: TEdit
          Left = 97
          Top = 170
          Width = 87
          Height = 21
          TabOrder = 6
        end
        object edtSalesWeight: TEdit
          Left = 97
          Top = 194
          Width = 87
          Height = 21
          TabOrder = 7
        end
        object edtPurchWeight: TEdit
          Left = 97
          Top = 217
          Width = 87
          Height = 21
          TabOrder = 8
        end
        object edtUplift: TEdit
          Left = 97
          Top = 241
          Width = 87
          Height = 21
          TabOrder = 9
        end
        object edtCountry: TEdit
          Left = 97
          Top = 264
          Width = 87
          Height = 21
          TabOrder = 10
        end
      end
      object GroupBox9: TGroupBox
        Left = 201
        Top = 1
        Width = 192
        Height = 150
        TabOrder = 1
        object Label47: TLabel
          Left = 3
          Top = 19
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Default Line Type'
        end
        object lblStkUser1: TLabel
          Left = 3
          Top = 53
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User1'
        end
        object lblStkUser2: TLabel
          Left = 3
          Top = 77
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User2'
        end
        object lblStkUser3: TLabel
          Left = 3
          Top = 100
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User3'
        end
        object lblStkUser4: TLabel
          Left = 3
          Top = 125
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User4'
        end
        object Bevel4: TBevel
          Left = 5
          Top = 42
          Width = 181
          Height = 2
          Shape = bsTopLine
        end
        object edtStkUser1: TEdit
          Left = 97
          Top = 50
          Width = 87
          Height = 21
          TabOrder = 0
        end
        object edtStkUser2: TEdit
          Left = 97
          Top = 73
          Width = 87
          Height = 21
          TabOrder = 1
        end
        object edtStkUser3: TEdit
          Left = 97
          Top = 97
          Width = 87
          Height = 21
          TabOrder = 2
        end
        object edtStkUser4: TEdit
          Left = 97
          Top = 121
          Width = 87
          Height = 21
          TabOrder = 3
        end
        object lstLineType: TComboBox
          Left = 97
          Top = 15
          Width = 86
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 4
        end
      end
      object GroupBox10: TGroupBox
        Left = 201
        Top = 153
        Width = 192
        Height = 141
        Caption = ' Cover '
        TabOrder = 2
        object Label57: TLabel
          Left = 3
          Top = 43
          Width = 73
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cover Periods'
        end
        object Label58: TLabel
          Left = 3
          Top = 67
          Width = 73
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Min Period'
        end
        object Label59: TLabel
          Left = 3
          Top = 91
          Width = 73
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Max Period'
        end
        object Label60: TLabel
          Left = 3
          Top = 115
          Width = 73
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Qty Sold'
        end
        object chkUseCover: TCheckBox
          Left = 7
          Top = 18
          Width = 86
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Use Cover'
          TabOrder = 0
        end
        object edtCovPr: TEdit
          Left = 81
          Top = 39
          Width = 42
          Height = 21
          TabOrder = 1
        end
        object lstCovPrUnits: TComboBox
          Left = 126
          Top = 39
          Width = 58
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'Days'
            'Weeks'
            'Months')
        end
        object edtMinPr: TEdit
          Left = 80
          Top = 63
          Width = 42
          Height = 21
          TabOrder = 3
        end
        object lstMinPrUnits: TComboBox
          Left = 126
          Top = 63
          Width = 58
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Items.Strings = (
            'Days'
            'Weeks'
            'Months')
        end
        object edtMaxPr: TEdit
          Left = 80
          Top = 87
          Width = 42
          Height = 21
          TabOrder = 5
        end
        object lstMaxPrUnits: TComboBox
          Left = 126
          Top = 87
          Width = 58
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Items.Strings = (
            'Days'
            'Weeks'
            'Months')
        end
        object edtQtySold: TEdit
          Left = 80
          Top = 111
          Width = 104
          Height = 21
          TabOrder = 7
        end
      end
    end
    object tabQtyBreaks: TTabSheet
      Caption = 'Qty Breaks'
      ImageIndex = 3
      object lvQtyBreaks: TListView
        Left = 4
        Top = 4
        Width = 390
        Height = 311
        Columns = <
          item
            Caption = 'From'
          end
          item
            Alignment = taRightJustify
            Caption = 'To'
          end
          item
            Alignment = taCenter
            Caption = 'Type'
            Width = 55
          end
          item
            Alignment = taRightJustify
            Caption = 'Unit Price'
            Width = 75
          end
          item
            Alignment = taCenter
            Caption = 'Band'
            Width = 45
          end
          item
            Alignment = taRightJustify
            Caption = 'Disc%'
            Width = 70
          end
          item
            Alignment = taRightJustify
            Caption = 'Disc (Val)'
            Width = 70
          end
          item
            Alignment = taRightJustify
            Caption = 'MU/MG'
            Width = 70
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel1: TPanel
        Left = 399
        Top = 71
        Width = 92
        Height = 82
        BevelOuter = bvLowered
        TabOrder = 1
        object btnAddQBrk: TButton
          Left = 7
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddQBrkClick
        end
        object btnEditQBrk: TButton
          Left = 6
          Top = 30
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditQBrkClick
        end
        object btnViewQBrk: TButton
          Left = 6
          Top = 54
          Width = 80
          Height = 22
          Caption = '&View'
          TabOrder = 2
          OnClick = btnViewQBrkClick
        end
      end
    end
    object tabshBuild: TTabSheet
      Caption = 'Build'
      ImageIndex = 4
      object lvKit: TListView
        Left = 5
        Top = 4
        Width = 390
        Height = 311
        Columns = <
          item
            Caption = 'StockCode'
            Width = 120
          end
          item
            Caption = 'Description'
            Width = 145
          end
          item
            Alignment = taRightJustify
            Caption = 'Qty'
            Width = 40
          end
          item
            Alignment = taRightJustify
            Caption = 'Unit Cost'
            Width = 70
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel2: TPanel
        Left = 399
        Top = 71
        Width = 92
        Height = 134
        BevelOuter = bvLowered
        TabOrder = 1
        object btnAddComp: TButton
          Left = 7
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddCompClick
        end
        object btnEditComp: TButton
          Left = 6
          Top = 30
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditCompClick
        end
        object btnInsComp: TButton
          Left = 6
          Top = 54
          Width = 80
          Height = 22
          Caption = '&Insert'
          TabOrder = 2
          OnClick = btnInsCompClick
        end
        object btnDelComp: TButton
          Left = 6
          Top = 78
          Width = 80
          Height = 22
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnDelCompClick
        end
        object btnCompCheck: TButton
          Left = 6
          Top = 106
          Width = 80
          Height = 22
          Caption = 'C&heck'
          TabOrder = 4
          OnClick = btnCompCheckClick
        end
      end
    end
    object tabshWhere: TTabSheet
      Caption = 'Where Used'
      ImageIndex = 5
      object lvWhereUsed: TListView
        Left = 5
        Top = 4
        Width = 390
        Height = 311
        Columns = <
          item
            Caption = 'StockCode'
            Width = 120
          end
          item
            Caption = 'Description'
            Width = 145
          end
          item
            Alignment = taRightJustify
            Caption = 'Qty'
            Width = 40
          end
          item
            Alignment = taRightJustify
            Caption = 'Unit Cost'
            Width = 70
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tabshSerial: TTabSheet
      Caption = 'Serial/Batch'
      ImageIndex = 6
      object lvSerialNo: TListView
        Left = 5
        Top = 4
        Width = 390
        Height = 311
        Columns = <
          item
            Caption = 'Serial No'
            Width = 90
          end
          item
            Alignment = taCenter
            Caption = 'Sold'
            Width = 40
          end
          item
            Caption = 'Batch No'
            Width = 80
          end
          item
            Caption = 'In Doc'
            Width = 80
          end
          item
            Caption = 'Out Doc'
            Width = 80
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel3: TPanel
        Left = 399
        Top = 71
        Width = 92
        Height = 86
        BevelOuter = bvLowered
        TabOrder = 1
        object btnAddSerial: TButton
          Left = 6
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddSerialClick
        end
        object btnViewSerial: TButton
          Left = 6
          Top = 30
          Width = 80
          Height = 22
          Caption = '&View'
          TabOrder = 1
          OnClick = btnViewSerialClick
        end
        object btnSerialNotes: TButton
          Left = 6
          Top = 58
          Width = 80
          Height = 22
          Caption = '&Notes'
          TabOrder = 2
          OnClick = btnSerialNotesClick
        end
      end
    end
  end
  object panButtonIndent: TPanel
    Left = 408
    Top = 33
    Width = 92
    Height = 60
    BevelOuter = bvLowered
    TabOrder = 1
    object btnSave: TButton
      Left = 6
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 6
      Top = 33
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
