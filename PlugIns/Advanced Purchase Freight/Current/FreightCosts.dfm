object frmFreightCosts: TfrmFreightCosts
  Left = 323
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Freight Costs'
  ClientHeight = 430
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pcTabs: TPageControl
    Left = 8
    Top = 8
    Width = 689
    Height = 385
    ActivePage = tsFreight
    TabIndex = 0
    TabOrder = 0
    object tsFreight: TTabSheet
      Caption = 'Freight Costs'
      object Bevel1: TBevel
        Left = 8
        Top = 16
        Width = 241
        Height = 161
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 16
        Top = 36
        Width = 51
        Height = 14
        Caption = 'Currency :'
      end
      object Label17: TLabel
        Left = 16
        Top = 76
        Width = 76
        Height = 14
        Caption = 'Total Received :'
      end
      object lTotReceived: TLabel
        Left = 220
        Top = 76
        Width = 21
        Height = 14
        Alignment = taRightJustify
        Caption = '0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 16
        Top = 108
        Width = 106
        Height = 14
        Caption = 'Total Received Value :'
      end
      object lTotReceivedValue: TLabel
        Left = 220
        Top = 108
        Width = 21
        Height = 14
        Alignment = taRightJustify
        Caption = '0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel2: TBevel
        Left = 8
        Top = 200
        Width = 241
        Height = 145
        Shape = bsFrame
      end
      object Label19: TLabel
        Left = 16
        Top = 8
        Width = 33
        Height = 14
        Caption = 'Values'
      end
      object Label20: TLabel
        Left = 16
        Top = 192
        Width = 82
        Height = 14
        Caption = 'Allocation Details'
      end
      object Label22: TLabel
        Left = 24
        Top = 224
        Width = 64
        Height = 14
        Caption = 'Allocate By : '
      end
      object Label2: TLabel
        Left = 16
        Top = 140
        Width = 112
        Height = 14
        Caption = 'Total Received Weight :'
      end
      object lTotReceivedWeight: TLabel
        Left = 220
        Top = 140
        Width = 21
        Height = 14
        Alignment = taRightJustify
        Caption = '0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cmbCurrency: TComboBox
        Left = 72
        Top = 32
        Width = 169
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = cmbCurrencyChange
      end
      object panValues: TPanel
        Left = 264
        Top = 16
        Width = 409
        Height = 329
        BevelOuter = bvNone
        TabOrder = 4
        object Bevel3: TBevel
          Left = 0
          Top = 0
          Width = 409
          Height = 329
          Align = alClient
          Shape = bsFrame
        end
        object Shape1: TShape
          Left = 192
          Top = 24
          Width = 73
          Height = 243
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape20: TShape
          Left = 336
          Top = 24
          Width = 72
          Height = 273
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape16: TShape
          Left = 336
          Top = 24
          Width = 72
          Height = 304
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape13: TShape
          Left = 192
          Top = 170
          Width = 216
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape12: TShape
          Left = 192
          Top = 145
          Width = 216
          Height = 26
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape6: TShape
          Left = 192
          Top = 97
          Width = 145
          Height = 24
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape2: TShape
          Left = 192
          Top = 48
          Width = 216
          Height = 73
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape3: TShape
          Left = 192
          Top = 48
          Width = 145
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object lCat2Desc: TLabel
          Left = 8
          Top = 53
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'Insurance :'
        end
        object lP2: TLabel
          Left = 251
          Top = 53
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP3: TLabel
          Left = 251
          Top = 77
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP4: TLabel
          Left = 251
          Top = 101
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat3Desc: TLabel
          Left = 8
          Top = 77
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'Interest :'
        end
        object lCat4Desc: TLabel
          Left = 8
          Top = 101
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'Duty :'
        end
        object lCat5Desc: TLabel
          Left = 8
          Top = 125
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'Container Costs :'
        end
        object lCat6Desc: TLabel
          Left = 8
          Top = 149
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'HMC :'
        end
        object lCat2: TLabel
          Left = 380
          Top = 53
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat3: TLabel
          Left = 380
          Top = 77
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat4: TLabel
          Left = 380
          Top = 101
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 192
          Top = 275
          Width = 85
          Height = 14
          Caption = 'Total Uplift Value :'
        end
        object lTotalUplift: TLabel
          Left = 380
          Top = 275
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape7: TShape
          Left = 192
          Top = 120
          Width = 216
          Height = 26
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object lUnitUplift: TLabel
          Left = 192
          Top = 305
          Width = 99
          Height = 14
          Caption = 'Uplift Value per unit :'
        end
        object lApportUplift: TLabel
          Left = 380
          Top = 305
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape11: TShape
          Left = 192
          Top = 24
          Width = 145
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object lCat1Desc: TLabel
          Left = 8
          Top = 29
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'Freight :'
        end
        object lCat7Desc: TLabel
          Left = 8
          Top = 174
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'RHD :'
        end
        object lCat1: TLabel
          Left = 380
          Top = 29
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat5: TLabel
          Left = 380
          Top = 125
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat6: TLabel
          Left = 380
          Top = 149
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat7: TLabel
          Left = 380
          Top = 174
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape17: TShape
          Left = 192
          Top = 194
          Width = 216
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape18: TShape
          Left = 192
          Top = 218
          Width = 216
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape19: TShape
          Left = 192
          Top = 242
          Width = 216
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object lCat8: TLabel
          Left = 380
          Top = 198
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat9: TLabel
          Left = 380
          Top = 222
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat10: TLabel
          Left = 380
          Top = 246
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = '0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lCat8Desc: TLabel
          Left = 8
          Top = 198
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'RHD :'
        end
        object lCat9Desc: TLabel
          Left = 8
          Top = 222
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'RHD :'
        end
        object lCat10Desc: TLabel
          Left = 8
          Top = 246
          Width = 177
          Height = 14
          AutoSize = False
          Caption = 'RHD :'
        end
        object lP1: TLabel
          Left = 251
          Top = 29
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP5: TLabel
          Left = 251
          Top = 125
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP6: TLabel
          Left = 251
          Top = 149
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP7: TLabel
          Left = 251
          Top = 174
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP8: TLabel
          Left = 251
          Top = 198
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP9: TLabel
          Left = 251
          Top = 222
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lP10: TLabel
          Left = 251
          Top = 246
          Width = 9
          Height = 14
          Alignment = taRightJustify
          Caption = '%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape4: TShape
          Left = 192
          Top = 72
          Width = 216
          Height = 26
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object edCat1P: TCurrencyEdit
          Left = 192
          Top = 24
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 2
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat2P: TCurrencyEdit
          Left = 192
          Top = 48
          Width = 56
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat3P: TCurrencyEdit
          Left = 192
          Top = 72
          Width = 56
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 6
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat4P: TCurrencyEdit
          Left = 192
          Top = 97
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 8
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat5P: TCurrencyEdit
          Left = 192
          Top = 120
          Width = 56
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 10
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat6P: TCurrencyEdit
          Left = 192
          Top = 145
          Width = 56
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 12
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat7P: TCurrencyEdit
          Left = 192
          Top = 170
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 14
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat8P: TCurrencyEdit
          Left = 192
          Top = 194
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 16
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat9P: TCurrencyEdit
          Left = 192
          Top = 218
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 18
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat10P: TCurrencyEdit
          Left = 192
          Top = 242
          Width = 56
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 20
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object panPercent: TPanel
          Left = 192
          Top = 0
          Width = 73
          Height = 25
          BevelOuter = bvNone
          Caption = 'Percentage'
          TabOrder = 0
          object Shape8: TShape
            Left = 0
            Top = 0
            Width = 73
            Height = 25
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clGray
          end
        end
        object panValue: TPanel
          Left = 264
          Top = 0
          Width = 73
          Height = 25
          BevelOuter = bvNone
          Caption = 'Value'
          TabOrder = 1
          object Shape9: TShape
            Left = 0
            Top = 0
            Width = 73
            Height = 25
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clGray
          end
        end
        object Panel1: TPanel
          Left = 336
          Top = 0
          Width = 72
          Height = 25
          BevelOuter = bvNone
          Caption = 'Total'
          TabOrder = 22
          object Shape5: TShape
            Left = 0
            Top = 0
            Width = 72
            Height = 25
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clGray
          end
        end
        object edCat1: TCurrencyEdit
          Left = 264
          Top = 24
          Width = 73
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 3
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat2: TCurrencyEdit
          Left = 264
          Top = 48
          Width = 73
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 5
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat3: TCurrencyEdit
          Left = 264
          Top = 72
          Width = 73
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 7
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat4: TCurrencyEdit
          Left = 264
          Top = 96
          Width = 73
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 9
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat5: TCurrencyEdit
          Left = 264
          Top = 120
          Width = 73
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 11
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat6: TCurrencyEdit
          Left = 264
          Top = 144
          Width = 73
          Height = 27
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 13
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat7: TCurrencyEdit
          Left = 264
          Top = 170
          Width = 73
          Height = 25
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 15
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat8: TCurrencyEdit
          Left = 264
          Top = 193
          Width = 73
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 17
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat9: TCurrencyEdit
          Left = 264
          Top = 217
          Width = 73
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 19
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edCat10: TCurrencyEdit
          Left = 264
          Top = 241
          Width = 73
          Height = 26
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          TabOrder = 21
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
      end
      object rbQuantity: TRadioButton
        Left = 88
        Top = 240
        Width = 113
        Height = 17
        Caption = 'Quantity'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = RBChange
      end
      object rbValue: TRadioButton
        Left = 88
        Top = 272
        Width = 113
        Height = 17
        Caption = 'Value'
        TabOrder = 2
        OnClick = RBChange
      end
      object rbWeight: TRadioButton
        Left = 88
        Top = 304
        Width = 113
        Height = 17
        Caption = 'Weight'
        TabOrder = 3
        OnClick = RBChange
      end
    end
    object tsExclusions: TTabSheet
      Caption = 'Filtering'
      ImageIndex = 1
      object Bevel4: TBevel
        Left = 8
        Top = 16
        Width = 241
        Height = 161
        Shape = bsFrame
      end
      object cbLineTypes: TCheckBox
        Left = 56
        Top = 48
        Width = 137
        Height = 17
        Caption = 'Include Line Types 0-4'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = IncludeClick
      end
      object cbNonStock: TCheckBox
        Left = 56
        Top = 88
        Width = 145
        Height = 17
        Caption = 'Include Non-Stock Lines'
        TabOrder = 1
        OnClick = IncludeClick
      end
      object cbBOMKits: TCheckBox
        Left = 56
        Top = 128
        Width = 105
        Height = 17
        Caption = 'Include BOM Kits'
        TabOrder = 2
        OnClick = IncludeClick
      end
    end
  end
  object btnApply: TButton
    Left = 528
    Top = 400
    Width = 80
    Height = 21
    Caption = '&Apply'
    TabOrder = 1
    OnClick = btnApplyClick
  end
  object btnCancel: TButton
    Left = 616
    Top = 400
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 24
  end
end
