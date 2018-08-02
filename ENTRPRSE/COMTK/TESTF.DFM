object Form1: TForm1
  Left = 413
  Top = 167
  Width = 499
  Height = 499
  ActiveControl = PageControl1
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    491
    468)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 484
    Height = 443
    ActivePage = tabEmpl
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 5
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'Open/Close'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 4
        Top = 1
        Width = 470
        Height = 107
        Caption = 'OpenToolkit'
        TabOrder = 0
        object Label1: TLabel
          Left = 5
          Top = 18
          Width = 97
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Enterprise Directory'
        end
        object Label2: TLabel
          Left = 5
          Top = 41
          Width = 97
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Data Directory'
        end
        object edtEntDir: TEdit
          Left = 106
          Top = 15
          Width = 356
          Height = 21
          TabOrder = 0
        end
        object edtDataDir: TEdit
          Left = 106
          Top = 38
          Width = 356
          Height = 21
          TabOrder = 1
        end
        object btnOpenToolkit: TButton
          Left = 100
          Top = 68
          Width = 270
          Height = 30
          Caption = 'Open Toolkit'
          TabOrder = 2
          OnClick = btnOpenToolkitClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 111
        Width = 470
        Height = 53
        Caption = 'CloseToolkit'
        TabOrder = 1
        object btnCloseToolkit: TButton
          Left = 100
          Top = 14
          Width = 270
          Height = 30
          Caption = 'Close Toolkit'
          TabOrder = 0
          OnClick = btnCloseToolkitClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 166
        Width = 470
        Height = 53
        Caption = 'Status'
        TabOrder = 2
        object lblToolkitStatus: TLabel
          Left = 12
          Top = 21
          Width = 168
          Height = 13
          AutoSize = False
          Caption = 'Status: '
        end
        object btnGetTKStatus: TButton
          Left = 191
          Top = 13
          Width = 270
          Height = 30
          Caption = 'Get Status'
          TabOrder = 0
          OnClick = btnGetTKStatusClick
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Customer'
      DesignSize = (
        476
        415)
      object lstCustomer: TListBox
        Left = 2
        Top = 30
        Width = 234
        Height = 381
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = lstCustomerDblClick
      end
      object btnGetFirstCust: TButton
        Left = 241
        Top = 31
        Width = 75
        Height = 25
        Caption = 'GetFirst'
        TabOrder = 1
        OnClick = btnGetFirstCustClick
      end
      object btnGetNextCust: TButton
        Left = 241
        Top = 83
        Width = 75
        Height = 25
        Caption = 'GetNext'
        TabOrder = 2
        OnClick = btnGetNextCustClick
      end
      object lstCustomerIdx: TComboBox
        Left = 2
        Top = 7
        Width = 234
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnClick = lstCustomerIdxClick
        Items.Strings = (
          'acIdxCode'
          'acIdxName'
          'acIdxAltCode'
          'acIdxVATRegNo'
          'acIdxEmail'
          'acIdxPhone'
          'acIdxPostCode'
          'acIdxOurCode'
          'acIdxInvTo')
      end
      object btnGetPreviousCust: TButton
        Left = 241
        Top = 57
        Width = 75
        Height = 25
        Caption = 'GetPrevious'
        TabOrder = 4
        OnClick = btnGetPreviousCustClick
      end
      object btnGetLastCust: TButton
        Left = 241
        Top = 109
        Width = 75
        Height = 25
        Caption = 'GetLast'
        TabOrder = 5
        OnClick = btnGetLastCustClick
      end
      object GroupBox4: TGroupBox
        Left = 241
        Top = 244
        Width = 233
        Height = 99
        Caption = ' Search '
        TabOrder = 6
        object Label3: TLabel
          Left = 11
          Top = 20
          Width = 52
          Height = 13
          Caption = 'SearchKey'
        end
        object Label4: TLabel
          Left = 13
          Top = 43
          Width = 51
          Height = 13
          Caption = 'Search Op'
        end
        object edtSearchKey: TEdit
          Left = 69
          Top = 16
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object lstSearchOp: TComboBox
          Left = 69
          Top = 40
          Width = 152
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Get Less'
            'Get Less Than or Equal'
            'Get Equal'
            'Get Greater Than or Equal'
            'Get Greater')
        end
        object btnSearchCommand: TButton
          Left = 80
          Top = 66
          Width = 75
          Height = 25
          Caption = 'Execute'
          TabOrder = 2
          OnClick = btnSearchCommandClick
        end
      end
    end
    object tabshTransaction: TTabSheet
      Caption = 'Transaction'
      ImageIndex = 2
      DesignSize = (
        476
        415)
      object lstTrans: TListBox
        Left = 2
        Top = 30
        Width = 234
        Height = 381
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = lstCustomerDblClick
      end
      object btnGetFirstTH: TButton
        Left = 242
        Top = 31
        Width = 75
        Height = 25
        Caption = 'GetFirst'
        TabOrder = 1
        OnClick = btnGetFirstTHClick
      end
      object btnGetNextTH: TButton
        Left = 242
        Top = 83
        Width = 75
        Height = 25
        Caption = 'GetNext'
        TabOrder = 2
        OnClick = btnGetNextTHClick
      end
      object lstTransIdx: TComboBox
        Left = 2
        Top = 7
        Width = 234
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnClick = lstTransIdxClick
        Items.Strings = (
          'thIdxOurRef'
          'thIdxFolio'
          'thIdxAccount'
          'thIdxYourRef'
          'thIdxLongYourRef'
          'thIdxRunNo'
          'thIdxAccountDue'
          'thIdxPostedDate'
          'thIdxBatchLink'
          'thIdxTransDate'
          'thIdxYearPeriod'
          'thIdxOutStanding')
      end
      object btnGetPrevTH: TButton
        Left = 242
        Top = 57
        Width = 75
        Height = 25
        Caption = 'GetPrevious'
        TabOrder = 4
        OnClick = btnGetPrevTHClick
      end
      object btnGetLastTH: TButton
        Left = 242
        Top = 109
        Width = 75
        Height = 25
        Caption = 'GetLast'
        TabOrder = 5
        OnClick = btnGetLastTHClick
      end
      object btnStepFirstTH: TButton
        Left = 320
        Top = 30
        Width = 75
        Height = 25
        Caption = 'StepFirst'
        TabOrder = 6
        OnClick = btnStepFirstTHClick
      end
      object btnStepNextTH: TButton
        Left = 320
        Top = 83
        Width = 75
        Height = 25
        Caption = 'StepNext'
        TabOrder = 7
        OnClick = btnStepNextTHClick
      end
      object btnStepPrevTH: TButton
        Left = 320
        Top = 57
        Width = 75
        Height = 25
        Caption = 'StepPrevious'
        TabOrder = 8
        OnClick = btnStepPrevTHClick
      end
      object btnStepLastTH: TButton
        Left = 320
        Top = 109
        Width = 75
        Height = 25
        Caption = 'StepLast'
        TabOrder = 9
        OnClick = btnStepLastTHClick
      end
      object GroupBox5: TGroupBox
        Left = 241
        Top = 244
        Width = 233
        Height = 99
        Caption = ' Search '
        TabOrder = 10
        object Label5: TLabel
          Left = 11
          Top = 20
          Width = 52
          Height = 13
          Caption = 'SearchKey'
        end
        object Label6: TLabel
          Left = 13
          Top = 43
          Width = 51
          Height = 13
          Caption = 'Search Op'
        end
        object edtSearchTHKey: TEdit
          Left = 70
          Top = 16
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object lstSearchTHOp: TComboBox
          Left = 69
          Top = 40
          Width = 152
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Get Less'
            'Get Less Than or Equal'
            'Get Equal'
            'Get Greater Than or Equal'
            'Get Greater')
        end
        object btnSearchTH: TButton
          Left = 80
          Top = 66
          Width = 75
          Height = 25
          Caption = 'Execute'
          TabOrder = 2
          OnClick = btnSearchTHClick
        end
      end
      object btnBrowwseTrans: TButton
        Left = 242
        Top = 141
        Width = 75
        Height = 25
        Caption = 'Browse'
        TabOrder = 11
        OnClick = btnBrowwseTransClick
      end
    end
    object ts_CreateTrans: TTabSheet
      Caption = 'Create Transaction'
      ImageIndex = 3
      object grpTransHeader: TGroupBox
        Left = 5
        Top = 66
        Width = 347
        Height = 126
        Caption = ' Transaction Header'
        Enabled = False
        TabOrder = 0
        object lbl4: TLabel
          Left = 9
          Top = 20
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Our Ref'
        end
        object lbl5: TLabel
          Left = 9
          Top = 72
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Your Ref'
        end
        object lbl6: TLabel
          Left = 9
          Top = 46
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alt Ref'
        end
        object lbl7: TLabel
          Left = 26
          Top = 99
          Width = 28
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'A/C'
        end
        object lbl8: TLabel
          Left = 223
          Top = 23
          Width = 28
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Date'
        end
        object lbl9: TLabel
          Left = 213
          Top = 46
          Width = 38
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Per/Yr'
        end
        object edtOurRef: TEdit
          Left = 60
          Top = 17
          Width = 91
          Height = 21
          Color = clBtnFace
          TabOrder = 0
        end
        object edtYourRef: TEdit
          Left = 60
          Top = 67
          Width = 109
          Height = 21
          MaxLength = 10
          TabOrder = 4
        end
        object edtAltRef: TEdit
          Left = 60
          Top = 42
          Width = 131
          Height = 21
          Color = clBtnFace
          TabOrder = 2
        end
        object edtTransDate: TEdit
          Left = 255
          Top = 20
          Width = 84
          Height = 21
          Color = clBtnFace
          TabOrder = 1
        end
        object edtPeriodYear: TEdit
          Left = 255
          Top = 43
          Width = 84
          Height = 21
          Color = clBtnFace
          TabOrder = 3
        end
        object edtAcctCode: TEdit
          Left = 60
          Top = 93
          Width = 109
          Height = 21
          MaxLength = 10
          TabOrder = 5
          OnExit = edtAcctCodeExit
        end
      end
      object grpTransDet: TGroupBox
        Left = 4
        Top = 191
        Width = 348
        Height = 170
        Caption = 'Transaction Detail'
        Enabled = False
        TabOrder = 1
        object lbl10: TLabel
          Left = 208
          Top = 21
          Width = 39
          Height = 13
          Caption = 'Quantity'
        end
        object lbl11: TLabel
          Left = 27
          Top = 21
          Width = 28
          Height = 13
          Caption = 'Stock'
        end
        object lbl12: TLabel
          Left = 41
          Top = 81
          Width = 14
          Height = 13
          Caption = 'CC'
        end
        object lbl13: TLabel
          Left = 227
          Top = 83
          Width = 20
          Height = 13
          Caption = 'Dep'
        end
        object lbl14: TLabel
          Left = 16
          Top = 111
          Width = 42
          Height = 13
          Caption = 'GLCode '
        end
        object lbl15: TLabel
          Left = 211
          Top = 52
          Width = 36
          Height = 13
          Caption = 'Amount'
        end
        object lbl1: TLabel
          Left = 31
          Top = 51
          Width = 30
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Price'
        end
        object lbl2: TLabel
          Left = 12
          Top = 141
          Width = 49
          Height = 13
          Caption = 'Anal Code'
        end
        object lbl3: TLabel
          Left = 202
          Top = 115
          Width = 45
          Height = 13
          Caption = 'Job Code'
        end
        object edtQty: TEdit
          Left = 258
          Top = 17
          Width = 84
          Height = 21
          TabOrder = 1
          OnExit = edtQtyExit
        end
        object edtStock: TEdit
          Left = 66
          Top = 19
          Width = 84
          Height = 21
          HelpType = htKeyword
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnExit = edtStockExit
        end
        object edtGL: TEdit
          Left = 66
          Top = 110
          Width = 84
          Height = 21
          TabOrder = 6
        end
        object edtDep: TEdit
          Left = 258
          Top = 81
          Width = 84
          Height = 21
          TabOrder = 5
        end
        object edtCC: TEdit
          Left = 66
          Top = 80
          Width = 84
          Height = 21
          TabOrder = 4
        end
        object edtStkPrice: TEdit
          Left = 66
          Top = 50
          Width = 84
          Height = 21
          TabOrder = 2
          OnExit = edtQtyExit
        end
        object edtAnalCode: TEdit
          Left = 66
          Top = 141
          Width = 84
          Height = 21
          TabOrder = 8
        end
        object edtJobcode: TEdit
          Left = 258
          Top = 113
          Width = 84
          Height = 21
          TabOrder = 7
        end
        object edtAmt: TEdit
          Left = 258
          Top = 49
          Width = 84
          Height = 21
          Color = clBtnFace
          Enabled = False
          TabOrder = 3
        end
      end
      object grpTrans: TGroupBox
        Left = 6
        Top = 8
        Width = 347
        Height = 57
        Caption = 'Select Transaction'
        TabOrder = 2
        object btnCreate: TButton
          Left = 206
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Create Trans.'
          TabOrder = 1
          OnClick = btnCreateClick
        end
        object cboTrans: TComboBox
          Left = 12
          Top = 24
          Width = 153
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object btnSaveTrans: TButton
        Left = 362
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Save Trans'
        Enabled = False
        TabOrder = 3
        OnClick = btnSaveTransClick
      end
      object btnCancelTrans: TButton
        Left = 363
        Top = 47
        Width = 75
        Height = 25
        Caption = 'Cancel Trans'
        Enabled = False
        TabOrder = 4
        OnClick = btnCancelTransClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'User Authentication'
      ImageIndex = 4
      object GroupBox6: TGroupBox
        Left = 2
        Top = 3
        Width = 353
        Height = 103
        Caption = 'Login Credential'
        TabOrder = 0
        object Label7: TLabel
          Left = 8
          Top = 22
          Width = 53
          Height = 13
          Caption = 'User Name'
        end
        object Label8: TLabel
          Left = 15
          Top = 46
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object Label9: TLabel
          Left = 26
          Top = 70
          Width = 35
          Height = 13
          Caption = 'Access'
        end
        object edtUserID: TEdit
          Left = 68
          Top = 18
          Width = 202
          Height = 21
          TabOrder = 0
        end
        object edtPwd: TEdit
          Left = 68
          Top = 45
          Width = 202
          Height = 21
          PasswordChar = '*'
          TabOrder = 1
        end
        object cboAccess: TComboBox
          Left = 68
          Top = 73
          Width = 269
          Height = 21
          ItemHeight = 13
          TabOrder = 2
        end
      end
      object btnChkLogin: TButton
        Left = 367
        Top = 9
        Width = 100
        Height = 30
        Caption = 'Check Login'
        TabOrder = 1
        OnClick = btnChkLoginClick
      end
      object btnChkAccess: TButton
        Left = 367
        Top = 50
        Width = 100
        Height = 30
        Caption = 'Check Access'
        TabOrder = 2
        OnClick = btnChkAccessClick
      end
    end
    object tabEmpl: TTabSheet
      Caption = 'GDPR'
      ImageIndex = 5
      object lst1: TListBox
        Left = 8
        Top = 160
        Width = 425
        Height = 97
        ItemHeight = 13
        Items.Strings = (
          'Result')
        TabOrder = 0
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 8
        Width = 425
        Height = 73
        Caption = 'Employee'
        TabOrder = 1
        object Label10: TLabel
          Left = 8
          Top = 22
          Width = 28
          Height = 13
          Caption = 'Code:'
        end
        object Label11: TLabel
          Left = 8
          Top = 47
          Width = 33
          Height = 13
          Caption = 'Status:'
        end
        object edtEmpCode: TEdit
          Left = 44
          Top = 18
          Width = 150
          Height = 21
          TabOrder = 0
        end
        object edEmpStatus: TEdit
          Left = 44
          Top = 43
          Width = 150
          Height = 21
          TabOrder = 1
        end
        object Save: TButton
          Left = 198
          Top = 43
          Width = 81
          Height = 21
          Caption = 'Save'
          TabOrder = 2
          OnClick = SaveClick
        end
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 82
        Width = 425
        Height = 73
        Caption = 'Trader'
        TabOrder = 2
        object Label12: TLabel
          Left = 8
          Top = 19
          Width = 28
          Height = 13
          Caption = 'Code:'
        end
        object Label13: TLabel
          Left = 8
          Top = 47
          Width = 33
          Height = 13
          Caption = 'Status:'
        end
        object Label14: TLabel
          Left = 200
          Top = 19
          Width = 27
          Height = 13
          Caption = 'Type:'
        end
        object edtTraderCode: TEdit
          Left = 44
          Top = 15
          Width = 150
          Height = 21
          TabOrder = 0
        end
        object edtTraderStatus: TEdit
          Left = 44
          Top = 43
          Width = 150
          Height = 21
          TabOrder = 1
        end
        object SaveTrader: TButton
          Left = 198
          Top = 43
          Width = 81
          Height = 21
          Caption = 'Save'
          TabOrder = 2
          OnClick = SaveTraderClick
        end
        object TraderType: TComboBox
          Left = 232
          Top = 15
          Width = 48
          Height = 21
          ItemHeight = 13
          TabOrder = 3
          Text = 'S'
          Items.Strings = (
            'S'
            'C')
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 445
    Width = 491
    Height = 23
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Panels = <>
    SimplePanel = True
    SimpleText = 'Enterprise COM Toolkit v?.??'
    UseSystemFont = False
  end
end
