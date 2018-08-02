object frmFreightCosts: TfrmFreightCosts
  Left = 333
  Top = 192
  BorderStyle = bsDialog
  Caption = 'Freight Costs'
  ClientHeight = 354
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
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
    Width = 265
    Height = 337
    ActivePage = tsFreight
    TabIndex = 0
    TabOrder = 0
    object tsFreight: TTabSheet
      Caption = 'Freight Costs'
      object Label1: TLabel
        Left = 8
        Top = 12
        Width = 51
        Height = 14
        Caption = 'Currency :'
      end
      object Label17: TLabel
        Left = 8
        Top = 44
        Width = 77
        Height = 14
        Caption = 'Total Received :'
      end
      object lTotReceived: TLabel
        Left = 188
        Top = 44
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
        Left = 8
        Top = 60
        Width = 108
        Height = 14
        Caption = 'Total Received Value :'
      end
      object lTotReceivedValue: TLabel
        Left = 188
        Top = 60
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
        Left = 80
        Top = 8
        Width = 169
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = cmbCurrencyChange
      end
      object Panel1: TPanel
        Left = 8
        Top = 91
        Width = 209
        Height = 222
        BevelOuter = bvNone
        TabOrder = 1
        object Shape10: TShape
          Left = 136
          Top = 8
          Width = 73
          Height = 169
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape5: TShape
          Left = 72
          Top = 72
          Width = 137
          Height = 26
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape1: TShape
          Left = 136
          Top = 0
          Width = 73
          Height = 209
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape2: TShape
          Left = 72
          Top = 24
          Width = 137
          Height = 74
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape4: TShape
          Left = 72
          Top = 48
          Width = 137
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape3: TShape
          Left = 72
          Top = 24
          Width = 137
          Height = 25
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Label2: TLabel
          Left = 0
          Top = 28
          Width = 57
          Height = 14
          Caption = 'Commision :'
        end
        object Label3: TLabel
          Left = 123
          Top = 28
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
        object Label4: TLabel
          Left = 123
          Top = 52
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
        object Label5: TLabel
          Left = 123
          Top = 76
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
        object Label6: TLabel
          Left = 0
          Top = 52
          Width = 60
          Height = 14
          Caption = 'Import Duty :'
        end
        object Label7: TLabel
          Left = 0
          Top = 76
          Width = 39
          Height = 14
          Caption = 'Freight :'
        end
        object Label8: TLabel
          Left = 0
          Top = 100
          Width = 48
          Height = 14
          Caption = 'Ticketing :'
        end
        object Label9: TLabel
          Left = 0
          Top = 124
          Width = 60
          Height = 14
          Caption = 'Processing :'
        end
        object lCommission: TLabel
          Left = 180
          Top = 28
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
        object lImportDuty: TLabel
          Left = 180
          Top = 52
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
        object lFreight: TLabel
          Left = 180
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
        object Label13: TLabel
          Left = 32
          Top = 156
          Width = 87
          Height = 14
          Caption = 'Total Uplift Value :'
        end
        object lTotalUplift: TLabel
          Left = 180
          Top = 156
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
        object Shape6: TShape
          Left = 72
          Top = 97
          Width = 137
          Height = 24
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Shape7: TShape
          Left = 72
          Top = 120
          Width = 137
          Height = 26
          Brush.Style = bsClear
          Pen.Color = clGray
        end
        object Label15: TLabel
          Left = 73
          Top = 98
          Width = 63
          Height = 17
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 73
          Top = 122
          Width = 63
          Height = 17
          Alignment = taCenter
          AutoSize = False
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object label21: TLabel
          Left = 32
          Top = 188
          Width = 100
          Height = 14
          Caption = 'Uplift Value per unit :'
        end
        object lApportUplift: TLabel
          Left = 180
          Top = 188
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
        object edCommission: TCurrencyEdit
          Left = 73
          Top = 24
          Width = 49
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
          TabOrder = 0
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edImportDuty: TCurrencyEdit
          Left = 73
          Top = 48
          Width = 49
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
          TabOrder = 1
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edFreight: TCurrencyEdit
          Left = 73
          Top = 72
          Width = 49
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
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edTicketing: TCurrencyEdit
          Left = 137
          Top = 96
          Width = 71
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
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object edProcessing: TCurrencyEdit
          Left = 137
          Top = 120
          Width = 71
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
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          OnChange = ChangeValues
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object Panel2: TPanel
          Left = 72
          Top = 0
          Width = 65
          Height = 25
          BevelOuter = bvNone
          Caption = 'Percentage'
          TabOrder = 5
          object Shape8: TShape
            Left = 0
            Top = 0
            Width = 65
            Height = 25
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clGray
          end
        end
        object Panel5: TPanel
          Left = 136
          Top = 0
          Width = 73
          Height = 25
          BevelOuter = bvNone
          Caption = 'Value'
          TabOrder = 6
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
      end
    end
    object tsExclusions: TTabSheet
      Caption = 'Filtering'
      ImageIndex = 1
      object cbLineTypes: TCheckBox
        Left = 24
        Top = 24
        Width = 137
        Height = 17
        Caption = 'Include Line Types 0-4'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = IncludeClick
      end
      object cbNonStock: TCheckBox
        Left = 24
        Top = 56
        Width = 145
        Height = 17
        Caption = 'Include Non-Stock Lines'
        TabOrder = 1
        OnClick = IncludeClick
      end
      object cbBOMKits: TCheckBox
        Left = 24
        Top = 88
        Width = 105
        Height = 17
        Caption = 'Include BOM Kits'
        TabOrder = 2
        OnClick = IncludeClick
      end
    end
  end
  object btnApply: TButton
    Left = 280
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Apply'
    TabOrder = 1
    OnClick = btnApplyClick
  end
  object btnCancel: TButton
    Left = 280
    Top = 56
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
