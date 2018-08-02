object frmAcDiscDetlF: TfrmAcDiscDetlF
  Left = 346
  Top = 263
  BorderStyle = bsDialog
  Caption = 'frmAcDiscDetlF'
  ClientHeight = 274
  ClientWidth = 527
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
  object btnSave: TButton
    Left = 443
    Top = 25
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 443
    Top = 51
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 4
    Width = 432
    Height = 266
    ActivePage = tabshQtyBreaks
    TabOrder = 2
    OnChange = PageControl1Change
    object tabshDiscount: TTabSheet
      Caption = 'Discount'
      object Label6: TLabel
        Left = 7
        Top = 149
        Width = 408
        Height = 66
        AutoSize = False
        Caption = 
          'NOTE: Minor design flaw in Test Program - when adding a quantity' +
          ' break discount you must save the Discount record and then re-ed' +
          'it it to add the Qty Breaks.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object GroupBox1: TGroupBox
        Left = 4
        Top = -1
        Width = 417
        Height = 139
        TabOrder = 0
        object Label1: TLabel
          Left = 5
          Top = 16
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Stock Code'
        end
        object lblStkDesc: TLabel
          Left = 206
          Top = 16
          Width = 165
          Height = 13
          AutoSize = False
        end
        object Label3: TLabel
          Left = 5
          Top = 41
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Type'
        end
        object Label7: TLabel
          Left = 10
          Top = 66
          Width = 55
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit Price'
        end
        object Label8: TLabel
          Left = 10
          Top = 88
          Width = 55
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Discount %'
        end
        object Label2: TLabel
          Left = 248
          Top = 41
          Width = 91
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sales Price Band'
        end
        object Label4: TLabel
          Left = 237
          Top = 88
          Width = 37
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Value'
        end
        object Label5: TLabel
          Left = 10
          Top = 112
          Width = 55
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Mkup/Mgn'
        end
        object edtStockCode: TEdit
          Left = 70
          Top = 13
          Width = 114
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 0
        end
        object edtUnitPrice: TEdit
          Left = 141
          Top = 62
          Width = 110
          Height = 21
          MaxLength = 50
          TabOrder = 1
        end
        object edtDiscPerc: TEdit
          Left = 70
          Top = 86
          Width = 129
          Height = 21
          MaxLength = 50
          TabOrder = 2
        end
        object lstDiscType: TComboBox
          Left = 70
          Top = 38
          Width = 132
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnClick = lstDiscTypeClick
          Items.Strings = (
            'Special Price'
            'Band Price'
            'Margin'
            'Markup'
            'Qty Break')
        end
        object lstBands: TComboBox
          Left = 346
          Top = 38
          Width = 63
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          Items.Strings = (
            'A'
            'B'
            'C'
            'D'
            'E'
            'F'
            'G'
            'H')
        end
        object lstCcy: TComboBox
          Left = 70
          Top = 62
          Width = 68
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 5
        end
        object edtDiscVal: TEdit
          Left = 279
          Top = 86
          Width = 130
          Height = 21
          MaxLength = 50
          TabOrder = 6
        end
        object edtMarkUp: TEdit
          Left = 70
          Top = 110
          Width = 129
          Height = 21
          MaxLength = 50
          TabOrder = 7
        end
        object btnSelectStk: TButton
          Left = 184
          Top = 13
          Width = 16
          Height = 20
          Caption = '...'
          TabOrder = 8
          OnClick = btnSelectStkClick
        end
      end
    end
    object tabshQtyBreaks: TTabSheet
      Caption = 'Qty Breaks'
      ImageIndex = 1
      object lvQtyBreaks: TListView
        Left = 2
        Top = 3
        Width = 419
        Height = 205
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
      object btnAddQBrk: TButton
        Left = 3
        Top = 213
        Width = 80
        Height = 21
        Caption = '&Add'
        TabOrder = 1
        OnClick = btnAddQBrkClick
      end
      object btnEditQBrk: TButton
        Left = 88
        Top = 213
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 2
        OnClick = btnEditQBrkClick
      end
      object btnViewQBrk: TButton
        Left = 173
        Top = 213
        Width = 80
        Height = 21
        Caption = '&View'
        TabOrder = 3
        OnClick = btnViewQBrkClick
      end
    end
  end
end
