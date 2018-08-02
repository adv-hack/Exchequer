object frmLineDetail: TfrmLineDetail
  Left = 352
  Top = 365
  BorderStyle = bsDialog
  Caption = 'frmLineDetail'
  ClientHeight = 316
  ClientWidth = 445
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
    Left = 4
    Top = 2
    Width = 437
    Height = 311
    ActivePage = tabMain
    TabOrder = 0
    OnChange = PageControl1Change
    object tabMain: TTabSheet
      Caption = 'Data Entry'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 0
        Width = 323
        Height = 68
        TabOrder = 0
        object Label1: TLabel
          Left = 6
          Top = 17
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Stk Code'
        end
        object lblLocation: TLabel
          Left = 240
          Top = 17
          Width = 33
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Locn'
        end
        object edtStockCode: TEdit
          Left = 59
          Top = 14
          Width = 182
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 16
          TabOrder = 0
          OnExit = edtStockCodeExit
        end
        object edtLocation: TEdit
          Left = 277
          Top = 14
          Width = 37
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 3
          TabOrder = 1
          OnExit = edtLocationExit
        end
        object edtDesc: TEdit
          Left = 8
          Top = 39
          Width = 306
          Height = 21
          TabOrder = 2
          OnExit = edtDescExit
        end
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 69
        Width = 165
        Height = 139
        TabOrder = 1
        object lblQtyMul: TLabel
          Left = 3
          Top = 17
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Qty Mul'
        end
        object Label4: TLabel
          Left = 3
          Top = 41
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Qty'
        end
        object Label5: TLabel
          Left = 3
          Top = 65
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'U/Price'
        end
        object Label6: TLabel
          Left = 3
          Top = 88
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Discount'
        end
        object Label7: TLabel
          Left = 3
          Top = 112
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Total'
        end
        object edtQtyMul: TEdit
          Left = 50
          Top = 14
          Width = 65
          Height = 21
          TabOrder = 0
          OnExit = edtQtyMulExit
        end
        object edtQty: TEdit
          Left = 50
          Top = 38
          Width = 65
          Height = 21
          TabOrder = 1
          OnExit = edtQtyExit
        end
        object edtUnitPrice: TEdit
          Left = 50
          Top = 62
          Width = 106
          Height = 21
          TabOrder = 2
          OnExit = edtUnitPriceExit
        end
        object edtDiscount: TEdit
          Left = 50
          Top = 85
          Width = 106
          Height = 21
          TabOrder = 3
          OnExit = edtDiscountExit
        end
        object edtTotal: TEdit
          Left = 50
          Top = 109
          Width = 106
          Height = 21
          TabOrder = 4
        end
      end
      object GroupBox3: TGroupBox
        Left = 176
        Top = 69
        Width = 151
        Height = 139
        TabOrder = 2
        object lblJobCode: TLabel
          Left = 2
          Top = 17
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Job Code'
        end
        object lblAnalCode: TLabel
          Left = 2
          Top = 41
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Analysis'
        end
        object Label10: TLabel
          Left = 2
          Top = 65
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'VAT'
        end
        object Label11: TLabel
          Left = 2
          Top = 88
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'GL Code'
        end
        object Label12: TLabel
          Left = 2
          Top = 112
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Cost Price'
        end
        object edtJobCode: TEdit
          Left = 54
          Top = 14
          Width = 88
          Height = 21
          TabOrder = 0
        end
        object edtAnalCode: TEdit
          Left = 54
          Top = 38
          Width = 88
          Height = 21
          TabOrder = 1
        end
        object edtGLCode: TEdit
          Left = 54
          Top = 85
          Width = 88
          Height = 21
          TabOrder = 3
        end
        object edtCostPrice: TEdit
          Left = 54
          Top = 109
          Width = 88
          Height = 21
          TabOrder = 4
          OnExit = edtCostPriceExit
        end
        object lstVATCode: TComboBox
          Left = 54
          Top = 62
          Width = 57
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          OnClick = lstVATCodeClick
          OnExit = lstVATCodeClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 4
        Top = 210
        Width = 165
        Height = 67
        TabOrder = 3
        object Label13: TLabel
          Left = 3
          Top = 17
          Width = 50
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Line Type'
        end
        object Label14: TLabel
          Left = 4
          Top = 41
          Width = 49
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Line Date'
        end
        object edtLineDate: TEdit
          Left = 56
          Top = 38
          Width = 80
          Height = 21
          TabOrder = 1
        end
        object lstLineType: TComboBox
          Left = 56
          Top = 15
          Width = 80
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
    object tabFooter: TTabSheet
      Caption = 'Footer'
      ImageIndex = 1
      object GroupBox4: TGroupBox
        Left = 4
        Top = 0
        Width = 322
        Height = 119
        Caption = ' User Defined Fields '
        TabOrder = 0
        object lblUserField1: TLabel
          Left = 2
          Top = 21
          Width = 62
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User1'
        end
        object lblUserField2: TLabel
          Left = 2
          Top = 45
          Width = 62
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User2'
        end
        object lblUserField3: TLabel
          Left = 2
          Top = 69
          Width = 62
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User 3'
        end
        object lblUserField4: TLabel
          Left = 2
          Top = 93
          Width = 62
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'User 4'
        end
        object edtUserField1: TEdit
          Left = 66
          Top = 18
          Width = 249
          Height = 21
          TabOrder = 0
        end
        object edtUserField2: TEdit
          Left = 66
          Top = 41
          Width = 249
          Height = 21
          TabOrder = 1
        end
        object edtUserField3: TEdit
          Left = 66
          Top = 66
          Width = 249
          Height = 21
          TabOrder = 2
        end
        object edtUserField4: TEdit
          Left = 66
          Top = 90
          Width = 249
          Height = 21
          TabOrder = 3
        end
      end
      object GroupBox6: TGroupBox
        Left = 4
        Top = 122
        Width = 323
        Height = 156
        Caption = ' Intrastat '
        TabOrder = 1
      end
    end
    object tabshSerial: TTabSheet
      Caption = 'Serial/Batch'
      ImageIndex = 2
      object lvSerial: TListView
        Left = 4
        Top = 4
        Width = 322
        Height = 274
        Columns = <
          item
            Caption = 'Serial Number'
            Width = 145
          end
          item
            Caption = 'Batch Number'
            Width = 145
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object panButtons: TPanel
    Left = 341
    Top = 31
    Width = 91
    Height = 55
    BevelOuter = bvLowered
    TabOrder = 1
    object btnCancel: TButton
      Left = 6
      Top = 29
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 5
      Top = 5
      Width = 80
      Height = 21
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
