object frmCustDetail: TfrmCustDetail
  Left = 346
  Top = 232
  BorderStyle = bsSingle
  Caption = 'frmCustDetail'
  ClientHeight = 285
  ClientWidth = 546
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
    Width = 537
    Height = 277
    ActivePage = tabBalances
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    object tabMain: TTabSheet
      Caption = 'Main'
      object GroupBox1: TGroupBox
        Left = 4
        Top = -1
        Width = 419
        Height = 67
        TabOrder = 0
        object Label4: TLabel
          Left = 5
          Top = 16
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Acc No.'
        end
        object Label5: TLabel
          Left = 138
          Top = 16
          Width = 82
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alt Search Ref.'
        end
        object Label6: TLabel
          Left = 5
          Top = 40
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Company'
        end
        object edtAcCode: TEdit
          Left = 56
          Top = 12
          Width = 78
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAcAltRef: TEdit
          Left = 223
          Top = 13
          Width = 188
          Height = 21
          MaxLength = 20
          TabOrder = 1
        end
        object edtAcCompany: TEdit
          Left = 56
          Top = 38
          Width = 355
          Height = 21
          MaxLength = 45
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 67
        Width = 250
        Height = 177
        TabOrder = 1
        object Label2: TLabel
          Left = 7
          Top = 10
          Width = 48
          Height = 12
          AutoSize = False
          Caption = 'Contact'
          OnClick = btnCancelClick
        end
        object Label3: TLabel
          Left = 7
          Top = 46
          Width = 127
          Height = 12
          AutoSize = False
          Caption = 'Address and Post Code'
          OnClick = btnCancelClick
        end
        object Label7: TLabel
          Left = 118
          Top = 151
          Width = 41
          Height = 12
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Po. Cd.'
          OnClick = btnCancelClick
        end
        object edtAcContact: TEdit
          Left = 7
          Top = 23
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAddr1: TEdit
          Left = 7
          Top = 59
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 1
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAddr2: TEdit
          Left = 7
          Top = 81
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 2
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAddr3: TEdit
          Left = 7
          Top = 103
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 3
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAddr4: TEdit
          Left = 7
          Top = 125
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 4
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAddr5: TEdit
          Left = 7
          Top = 147
          Width = 109
          Height = 21
          MaxLength = 6
          TabOrder = 5
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtPostCode: TEdit
          Left = 162
          Top = 148
          Width = 79
          Height = 21
          MaxLength = 6
          TabOrder = 6
          OnKeyDown = edtAcCodeKeyDown
        end
      end
      object GroupBox4: TGroupBox
        Left = 260
        Top = 66
        Width = 163
        Height = 178
        TabOrder = 2
        object Label8: TLabel
          Left = 7
          Top = 10
          Width = 127
          Height = 12
          AutoSize = False
          Caption = 'Email Address'
          OnClick = btnCancelClick
        end
        object Label9: TLabel
          Left = 7
          Top = 46
          Width = 137
          Height = 12
          AutoSize = False
          Caption = 'Telephone, Fax and Mobile:-'
          OnClick = btnCancelClick
        end
        object Label1: TLabel
          Left = 9
          Top = 152
          Width = 41
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Balance'
        end
        object Bevel1: TBevel
          Left = 5
          Top = 136
          Width = 152
          Height = 5
          Shape = bsTopLine
        end
        object edtEmailAddr: TEdit
          Left = 7
          Top = 23
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtPhone: TEdit
          Left = 7
          Top = 59
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 1
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtFax: TEdit
          Left = 7
          Top = 81
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 2
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtMobile: TEdit
          Left = 7
          Top = 103
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 3
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAcBalance: TEdit
          Left = 55
          Top = 149
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 4
          OnKeyDown = edtAcCodeKeyDown
        end
      end
    end
    object tabBalances: TTabSheet
      Caption = 'Balances'
      ImageIndex = 3
      object GroupBox7: TGroupBox
        Left = 4
        Top = -1
        Width = 419
        Height = 67
        TabOrder = 0
        object Label15: TLabel
          Left = 5
          Top = 16
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Acc No.'
        end
        object Label16: TLabel
          Left = 138
          Top = 16
          Width = 82
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alt Search Ref.'
        end
        object Label17: TLabel
          Left = 5
          Top = 40
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Company'
        end
        object edtAcCode3: TEdit
          Left = 56
          Top = 12
          Width = 78
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          ReadOnly = True
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAcAltRef3: TEdit
          Left = 223
          Top = 13
          Width = 188
          Height = 21
          MaxLength = 20
          ReadOnly = True
          TabOrder = 1
        end
        object edtAcCompany3: TEdit
          Left = 56
          Top = 38
          Width = 355
          Height = 21
          MaxLength = 45
          ReadOnly = True
          TabOrder = 2
        end
      end
      object GroupBox8: TGroupBox
        Left = 4
        Top = 67
        Width = 182
        Height = 177
        TabOrder = 1
        object Bevel2: TBevel
          Left = 8
          Top = 88
          Width = 166
          Height = 5
          Shape = bsTopLine
        end
        object Label18: TLabel
          Left = 11
          Top = 16
          Width = 57
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'This Period'
        end
        object Label19: TLabel
          Left = 11
          Top = 40
          Width = 57
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'This YTD'
        end
        object Label20: TLabel
          Left = 11
          Top = 64
          Width = 57
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Last YTD'
        end
        object Label21: TLabel
          Left = 11
          Top = 100
          Width = 57
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Credit Limit'
        end
        object Label22: TLabel
          Left = 11
          Top = 124
          Width = 57
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Committed'
        end
        object Label23: TLabel
          Left = 5
          Top = 148
          Width = 63
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Credit Avail'
        end
        object edtthisPr: TEdit
          Left = 75
          Top = 13
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtThisYTD: TEdit
          Left = 75
          Top = 37
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 1
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtLastYTD: TEdit
          Left = 75
          Top = 61
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 2
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtCrLimit: TEdit
          Left = 75
          Top = 97
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 3
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtCommitted: TEdit
          Left = 75
          Top = 121
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 4
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtCrAvail: TEdit
          Left = 75
          Top = 145
          Width = 99
          Height = 21
          MaxLength = 6
          ReadOnly = True
          TabOrder = 5
          OnKeyDown = edtAcCodeKeyDown
        end
      end
    end
    object tabDefaults: TTabSheet
      Caption = 'Defaults'
      ImageIndex = 2
      object GroupBox2: TGroupBox
        Left = 4
        Top = -1
        Width = 419
        Height = 67
        TabOrder = 0
        object Label10: TLabel
          Left = 5
          Top = 16
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Acc No.'
        end
        object Label11: TLabel
          Left = 138
          Top = 16
          Width = 82
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alt Search Ref.'
        end
        object Label12: TLabel
          Left = 5
          Top = 40
          Width = 48
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Company'
        end
        object edtAcCode2: TEdit
          Left = 56
          Top = 12
          Width = 78
          Height = 21
          CharCase = ecUpperCase
          Enabled = False
          MaxLength = 6
          ReadOnly = True
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtAcAltRef2: TEdit
          Left = 223
          Top = 13
          Width = 188
          Height = 21
          Enabled = False
          MaxLength = 20
          ReadOnly = True
          TabOrder = 1
        end
        object edtAcCompany2: TEdit
          Left = 57
          Top = 38
          Width = 355
          Height = 21
          Enabled = False
          MaxLength = 45
          ReadOnly = True
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 4
        Top = 67
        Width = 250
        Height = 140
        TabOrder = 1
        object Label14: TLabel
          Left = 7
          Top = 9
          Width = 127
          Height = 12
          AutoSize = False
          Caption = 'Delivery Address'
          OnClick = btnCancelClick
        end
        object edtDelAddr1: TEdit
          Left = 7
          Top = 22
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtDelAddr2: TEdit
          Left = 7
          Top = 44
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 1
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtDelAddr3: TEdit
          Left = 7
          Top = 66
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 2
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtDelAddr4: TEdit
          Left = 7
          Top = 88
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 3
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtDelAddr5: TEdit
          Left = 7
          Top = 110
          Width = 234
          Height = 21
          MaxLength = 6
          TabOrder = 4
          OnKeyDown = edtAcCodeKeyDown
        end
      end
      object GroupBox6: TGroupBox
        Left = 260
        Top = 67
        Width = 163
        Height = 120
        TabOrder = 2
        object Label13: TLabel
          Left = 7
          Top = 9
          Width = 127
          Height = 12
          AutoSize = False
          Caption = 'User Fields'
          OnClick = btnCancelClick
        end
        object edtUser1: TEdit
          Left = 7
          Top = 22
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 0
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtUser2: TEdit
          Left = 7
          Top = 44
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 1
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtUser3: TEdit
          Left = 7
          Top = 67
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 2
          OnKeyDown = edtAcCodeKeyDown
        end
        object edtUser4: TEdit
          Left = 7
          Top = 90
          Width = 147
          Height = 21
          MaxLength = 6
          TabOrder = 3
          OnKeyDown = edtAcCodeKeyDown
        end
      end
    end
    object tabLedger: TTabSheet
      Caption = 'Ledger'
      ImageIndex = 1
      object lvTrans: TListView
        Left = 4
        Top = 4
        Width = 418
        Height = 241
        Columns = <
          item
            Caption = 'OurRef'
            Width = 90
          end
          item
            Width = 18
          end
          item
            Caption = 'Date'
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = 'Total'
            Width = 90
          end
          item
            Alignment = taRightJustify
            Caption = 'Your Ref'
            Width = 90
          end
          item
            Alignment = taRightJustify
            Caption = 'Alt Ref'
            Width = 90
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = btnViewClick
      end
      object Panel1: TPanel
        Left = 431
        Top = 68
        Width = 92
        Height = 176
        BevelOuter = bvLowered
        TabOrder = 1
        object btnAdd: TButton
          Left = 6
          Top = 7
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnEdit: TButton
          Left = 6
          Top = 31
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditClick
        end
        object btnView: TButton
          Left = 6
          Top = 55
          Width = 80
          Height = 21
          Caption = '&View'
          TabOrder = 2
          OnClick = btnViewClick
        end
        object btnViewNotes: TButton
          Left = 6
          Top = 83
          Width = 80
          Height = 21
          Caption = '&Notes'
          TabOrder = 3
          OnClick = btnViewNotesClick
        end
        object btnMatching: TButton
          Left = 6
          Top = 110
          Width = 80
          Height = 21
          Caption = '&Matching'
          TabOrder = 4
          OnClick = btnMatchingClick
        end
      end
    end
  end
  object panButtonIndent: TPanel
    Left = 440
    Top = 31
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
