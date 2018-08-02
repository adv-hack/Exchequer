object frmTHDetail: TfrmTHDetail
  Left = 354
  Top = 236
  Width = 555
  Height = 336
  Caption = 'frmTHDetail'
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
    Width = 538
    Height = 301
    ActivePage = tabFooter
    TabOrder = 0
    object tabMain: TTabSheet
      Caption = 'Main'
      object Label4: TLabel
        Left = 186
        Top = 8
        Width = 32
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'A/C'
      end
      object Label6: TLabel
        Left = 184
        Top = 34
        Width = 34
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Date'
      end
      object Label1: TLabel
        Left = 184
        Top = 60
        Width = 34
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Due'
      end
      object Label2: TLabel
        Left = 298
        Top = 8
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Per/Yr'
      end
      object Label3: TLabel
        Left = 298
        Top = 33
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Your Ref'
      end
      object Label5: TLabel
        Left = 300
        Top = 60
        Width = 45
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Alt. Ref'
      end
      object Label18: TLabel
        Left = 375
        Top = 236
        Width = 45
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Total'
      end
      object Label19: TLabel
        Left = 235
        Top = 236
        Width = 89
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'VAT Content'
      end
      object Label20: TLabel
        Left = 146
        Top = 236
        Width = 82
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Net Total'
      end
      object memAcDetails: TMemo
        Left = 4
        Top = 4
        Width = 180
        Height = 75
        ReadOnly = True
        TabOrder = 0
      end
      object edtAcCode: TEdit
        Left = 221
        Top = 4
        Width = 75
        Height = 21
        CharCase = ecUpperCase
        MaxLength = 6
        TabOrder = 1
        OnExit = edtAcCodeExit
      end
      object lvLines: TListView
        Left = 4
        Top = 85
        Width = 419
        Height = 149
        Columns = <
          item
            Caption = 'Stock Code'
            Width = 100
          end
          item
            Alignment = taRightJustify
            Caption = 'Qty'
            Width = 55
          end
          item
            Caption = 'Description'
            Width = 155
          end
          item
            Alignment = taRightJustify
            Caption = 'Line Total'
            Width = 75
          end
          item
            Alignment = taCenter
            Caption = 'VAT'
            Width = 35
          end
          item
            Alignment = taRightJustify
            Caption = 'Unit Price'
            Width = 90
          end
          item
            Alignment = taRightJustify
            Caption = 'Discount'
            Width = 70
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 7
        ViewStyle = vsReport
        OnDblClick = lvLinesDblClick
      end
      object edtPeriodYear: TEdit
        Left = 347
        Top = 4
        Width = 76
        Height = 21
        MaxLength = 6
        TabOrder = 4
      end
      object edtYourRef: TEdit
        Left = 347
        Top = 31
        Width = 76
        Height = 21
        MaxLength = 45
        TabOrder = 5
      end
      object edtAltRef: TEdit
        Left = 347
        Top = 58
        Width = 76
        Height = 21
        MaxLength = 45
        TabOrder = 6
      end
      object edtTHTotal: TEdit
        Left = 328
        Top = 248
        Width = 95
        Height = 21
        MaxLength = 45
        ReadOnly = True
        TabOrder = 10
      end
      object edtTotalVAT: TEdit
        Left = 232
        Top = 248
        Width = 95
        Height = 21
        MaxLength = 45
        ReadOnly = True
        TabOrder = 9
      end
      object edtNetTotal: TEdit
        Left = 136
        Top = 248
        Width = 95
        Height = 21
        MaxLength = 45
        ReadOnly = True
        TabOrder = 8
      end
      object Panel3: TPanel
        Left = 431
        Top = 86
        Width = 93
        Height = 147
        BevelOuter = bvLowered
        TabOrder = 11
        object btnAdd: TButton
          Left = 6
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Add'
          Enabled = False
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnEdit: TButton
          Left = 6
          Top = 30
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditClick
        end
        object btnDelete: TButton
          Left = 6
          Top = 54
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 2
          OnClick = btnDeleteClick
        end
        object btnView: TButton
          Left = 6
          Top = 78
          Width = 80
          Height = 21
          Caption = '&View'
          TabOrder = 3
          OnClick = btnViewClick
        end
      end
      object edtTransDate: TMaskEdit
        Left = 221
        Top = 31
        Width = 75
        Height = 21
        EditMask = '00/00/0000;0;'
        MaxLength = 10
        TabOrder = 2
      end
      object edtDueDate: TMaskEdit
        Left = 221
        Top = 56
        Width = 75
        Height = 21
        EditMask = '00/00/0000;0;'
        MaxLength = 10
        TabOrder = 3
      end
    end
    object tabFooter: TTabSheet
      Caption = 'Footer'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 4
        Top = -1
        Width = 266
        Height = 269
        TabOrder = 0
        object Label7: TLabel
          Left = 141
          Top = 16
          Width = 58
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Control G/L'
        end
        object chkManualVAT: TCheckBox
          Left = 6
          Top = 15
          Width = 129
          Height = 17
          Alignment = taLeftJustify
          Caption = 'VAT Content Amended'
          TabOrder = 0
        end
        object edtVATCtrlGL: TEdit
          Left = 203
          Top = 13
          Width = 55
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 1
          Text = '111'
        end
        object lvVATSplit: TListView
          Left = 8
          Top = 41
          Width = 250
          Height = 219
          Columns = <
            item
              Caption = 'VAT Rate'
              Width = 75
            end
            item
              Alignment = taRightJustify
              Caption = 'Goods'
              Width = 75
            end
            item
              Alignment = taRightJustify
              Caption = 'VAT'
              Width = 75
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 2
          ViewStyle = vsReport
        end
      end
      object GroupBox2: TGroupBox
        Left = 276
        Top = -1
        Width = 148
        Height = 110
        Caption = ' Line Type Totals '
        TabOrder = 1
        object lblLineType1: TLabel
          Left = 8
          Top = 19
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Labour'
        end
        object lblLineType2: TLabel
          Left = 8
          Top = 41
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Materials'
        end
        object lblLineType3: TLabel
          Left = 8
          Top = 63
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Freight'
        end
        object lblLineType4: TLabel
          Left = 8
          Top = 85
          Width = 64
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Discount'
        end
        object edtLineType1: TEdit
          Left = 77
          Top = 16
          Width = 64
          Height = 21
          BiDiMode = bdLeftToRight
          CharCase = ecUpperCase
          MaxLength = 6
          ParentBiDiMode = False
          ReadOnly = True
          TabOrder = 0
          Text = 'N/A'
        end
        object edtLineType2: TEdit
          Left = 77
          Top = 38
          Width = 64
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 1
          Text = 'N/A'
        end
        object edtLineType3: TEdit
          Left = 77
          Top = 60
          Width = 64
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 2
          Text = 'N/A'
        end
        object edtLineType4: TEdit
          Left = 77
          Top = 82
          Width = 64
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 3
          Text = 'N/A'
        end
      end
      object GroupBox3: TGroupBox
        Left = 276
        Top = 111
        Width = 249
        Height = 157
        Caption = ' Totals '
        TabOrder = 2
        object Label8: TLabel
          Left = 5
          Top = 16
          Width = 63
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Settle Disc%'
        end
        object Label9: TLabel
          Left = 110
          Top = 16
          Width = 34
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Days'
        end
        object Label10: TLabel
          Left = 8
          Top = 132
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Total'
        end
        object Label11: TLabel
          Left = 8
          Top = 110
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Discount'
        end
        object Label12: TLabel
          Left = 8
          Top = 88
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'VAT'
        end
        object Label13: TLabel
          Left = 8
          Top = 66
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Net'
        end
        object Label14: TLabel
          Left = 129
          Top = 132
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Total'
        end
        object Label15: TLabel
          Left = 129
          Top = 110
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Discount'
        end
        object Label16: TLabel
          Left = 129
          Top = 88
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'VAT'
        end
        object Label17: TLabel
          Left = 129
          Top = 66
          Width = 46
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Net'
        end
        object chkSettleDiscTaken: TCheckBox
          Left = 184
          Top = 15
          Width = 53
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Taken'
          TabOrder = 0
        end
        object edtSettleDiscPerc: TEdit
          Left = 72
          Top = 13
          Width = 43
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 1
          Text = '111'
        end
        object edtSettleDiscDays: TEdit
          Left = 149
          Top = 13
          Width = 31
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 2
          Text = '111'
        end
        object edtNotTakenTotal: TEdit
          Left = 58
          Top = 129
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 3
          Text = '111'
        end
        object edtNotTakenDisc: TEdit
          Left = 58
          Top = 107
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 4
          Text = '111'
        end
        object edtNotTakenVAT: TEdit
          Left = 58
          Top = 85
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 5
          Text = '111'
        end
        object edtNotTakenNet: TEdit
          Left = 58
          Top = 63
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 6
          Text = '111'
        end
        object Panel1: TPanel
          Left = 8
          Top = 39
          Width = 117
          Height = 21
          Caption = 'Settle Disc Not Taken'
          TabOrder = 7
        end
        object edtTakenTotal: TEdit
          Left = 178
          Top = 129
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 8
          Text = '111'
        end
        object edtTakenDisc: TEdit
          Left = 178
          Top = 107
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 9
          Text = '111'
        end
        object edtTakenVAT: TEdit
          Left = 178
          Top = 85
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 10
          Text = '111'
        end
        object edtTakenNet: TEdit
          Left = 178
          Top = 63
          Width = 65
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 11
          Text = '111'
        end
        object Panel2: TPanel
          Left = 128
          Top = 39
          Width = 117
          Height = 21
          Caption = 'Settle Discount Taken'
          TabOrder = 12
        end
      end
    end
    object tabDelivery: TTabSheet
      Caption = 'Delivery'
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 4
        Top = -1
        Width = 249
        Height = 133
        Caption = ' Delivery Address '
        TabOrder = 0
        object edtDelAddr1: TEdit
          Left = 7
          Top = 16
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 0
        end
        object edtDelAddr2: TEdit
          Left = 7
          Top = 38
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 1
        end
        object edtDelAddr3: TEdit
          Left = 7
          Top = 60
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 2
        end
        object edtDelAddr4: TEdit
          Left = 7
          Top = 82
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 3
        end
        object edtDelAddr5: TEdit
          Left = 7
          Top = 104
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 4
        end
      end
    end
  end
  object panButtonIndent: TPanel
    Left = 440
    Top = 31
    Width = 93
    Height = 57
    BevelOuter = bvLowered
    TabOrder = 1
    object btnSave: TButton
      Left = 6
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Save'
      Enabled = False
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 6
      Top = 30
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
