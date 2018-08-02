object frmAdmin: TfrmAdmin
  Left = 430
  Top = 162
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmAdmin'
  ClientHeight = 315
  ClientWidth = 740
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 656
    Top = 5
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 656
    Top = 32
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object PageControl1: TPageControl
    Left = 6
    Top = 5
    Width = 645
    Height = 304
    ActivePage = tabshCustomers
    TabIndex = 0
    TabOrder = 0
    object tabshCustomers: TTabSheet
      Caption = 'Customers / Consumers / Suppliers'
      PopupMenu = CustomerPopumMenu
      object Label4: TLabel
        Left = 10
        Top = 41
        Width = 335
        Height = 14
        Caption = 
          'Select the fields below which you want to include within the sea' +
          'rch:-'
      end
      object chkCUCode: TCheckBox
        Left = 25
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Code'
        TabOrder = 1
      end
      object chkCUAddress1: TCheckBox
        Left = 25
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Address Line 1'
        TabOrder = 6
      end
      object chkCUDelAddress1: TCheckBox
        Left = 25
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Del Addr Line 1'
        TabOrder = 11
      end
      object chkCUPhone2: TCheckBox
        Left = 25
        Top = 161
        Width = 97
        Height = 17
        Caption = 'Fax No'
        TabOrder = 16
      end
      object chkCUAccType: TCheckBox
        Left = 25
        Top = 191
        Width = 97
        Height = 17
        Caption = 'Account Type'
        TabOrder = 21
      end
      object chkCUVATNo: TCheckBox
        Left = 134
        Top = 251
        Width = 97
        Height = 17
        Caption = 'VAT Number'
        TabOrder = 32
      end
      object chkCUArea: TCheckBox
        Left = 243
        Top = 251
        Width = 97
        Height = 17
        Caption = 'Area'
        TabOrder = 33
      end
      object chkCUUser1: TCheckBox
        Left = 134
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 1'
        TabOrder = 22
      end
      object chkCUPhone3: TCheckBox
        Left = 134
        Top = 161
        Width = 97
        Height = 17
        Caption = 'Mobile No'
        TabOrder = 17
      end
      object chkCUDelAddress2: TCheckBox
        Left = 134
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Del Addr Line 2'
        TabOrder = 12
      end
      object chkCUAddress2: TCheckBox
        Left = 134
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Address Line 2'
        TabOrder = 7
      end
      object chkCUCompany: TCheckBox
        Left = 134
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Company'
        TabOrder = 2
      end
      object chkCUContact: TCheckBox
        Left = 243
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Contact'
        TabOrder = 3
      end
      object chkCUAddress3: TCheckBox
        Left = 243
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Address Line 3'
        TabOrder = 8
      end
      object chkCUDelAddress3: TCheckBox
        Left = 243
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Del Addr Line 3'
        TabOrder = 13
      end
      object chkCUEMailID: TCheckBox
        Left = 243
        Top = 161
        Width = 97
        Height = 17
        Caption = 'Email Address'
        TabOrder = 18
      end
      object chkCUUser2: TCheckBox
        Left = 243
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 2'
        TabOrder = 23
      end
      object chkCUUser3: TCheckBox
        Left = 351
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 3'
        TabOrder = 24
      end
      object chkCUTheirAccount: TCheckBox
        Left = 352
        Top = 161
        Width = 97
        Height = 17
        Caption = 'Their Account'
        TabOrder = 19
      end
      object chkCUDelAddress4: TCheckBox
        Left = 352
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Del Addr Line 4'
        TabOrder = 14
      end
      object chkCUAddress4: TCheckBox
        Left = 352
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Address Line 4'
        TabOrder = 9
      end
      object chkCUPhone1: TCheckBox
        Left = 352
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Telephone No'
        TabOrder = 4
      end
      object chkCUPostCode: TCheckBox
        Left = 461
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Post Code'
        TabOrder = 5
      end
      object chkCUAddress5: TCheckBox
        Left = 461
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Address Line 5'
        TabOrder = 10
      end
      object chkCUDelAddress5: TCheckBox
        Left = 461
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Del Addr Line 5'
        TabOrder = 15
      end
      object chkCUInvoiceTo: TCheckBox
        Left = 461
        Top = 161
        Width = 97
        Height = 17
        Caption = 'Invoice To'
        TabOrder = 20
      end
      object chkCUUser4: TCheckBox
        Left = 461
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 4'
        TabOrder = 25
      end
      object chkCUUser5: TCheckBox
        Left = 25
        Top = 221
        Width = 97
        Height = 17
        Caption = 'User Field 5'
        TabOrder = 26
      end
      object chkCUUser6: TCheckBox
        Left = 134
        Top = 221
        Width = 97
        Height = 17
        Caption = 'User Field 6'
        TabOrder = 27
      end
      object chkCUUser7: TCheckBox
        Left = 243
        Top = 221
        Width = 97
        Height = 17
        Caption = 'User Field 7'
        TabOrder = 28
      end
      object chkCUUser8: TCheckBox
        Left = 351
        Top = 221
        Width = 97
        Height = 17
        Caption = 'User Field 8'
        TabOrder = 29
      end
      object chkCUUser9: TCheckBox
        Left = 461
        Top = 221
        Width = 97
        Height = 17
        Caption = 'User Field 9'
        TabOrder = 30
      end
      object chkCUUser10: TCheckBox
        Left = 25
        Top = 251
        Width = 97
        Height = 17
        Caption = 'User Field 10'
        TabOrder = 31
      end
      object chkCULinkActive: TCheckBox
        Left = 10
        Top = 8
        Width = 395
        Height = 17
        Caption = 'Enable Extended Search for Customers / Consumers / Suppliers'
        TabOrder = 0
        OnClick = chkCULinkActiveClick
      end
    end
    object tabshStock: TTabSheet
      Caption = 'Stock'
      ImageIndex = 1
      PopupMenu = StockPopumMenu
      object Label11: TLabel
        Left = 10
        Top = 221
        Width = 467
        Height = 14
        Caption = 
          'The option below allows you to control how much of the Stock'#39's D' +
          'escription is shown in the list:-'
      end
      object Label5: TLabel
        Left = 10
        Top = 41
        Width = 335
        Height = 14
        Caption = 
          'Select the fields below which you want to include within the sea' +
          'rch:-'
      end
      object chkSTCode: TCheckBox
        Left = 25
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Code'
        TabOrder = 0
      end
      object chkSTDesc5: TCheckBox
        Left = 25
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Descr Line 5'
        TabOrder = 5
      end
      object chkSTBarCode: TCheckBox
        Left = 25
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Bar Code'
        TabOrder = 10
      end
      object chkSTUser1: TCheckBox
        Left = 25
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 1'
        TabOrder = 15
      end
      object cmbDescLines: TComboBox
        Left = 21
        Top = 251
        Width = 372
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 25
        Items.Strings = (
          'Show only the first Description Line in the list'
          'Show all Description Lines in the list')
      end
      object chkSTUser2: TCheckBox
        Left = 134
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 2'
        TabOrder = 16
      end
      object chkSTBinCode: TCheckBox
        Left = 134
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Bin Code'
        TabOrder = 11
      end
      object chkSTDesc6: TCheckBox
        Left = 134
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Descr Line 6'
        TabOrder = 6
      end
      object chkSTDesc1: TCheckBox
        Left = 134
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Descr Line 1'
        TabOrder = 1
      end
      object chkSTDesc2: TCheckBox
        Left = 243
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Descr Line 2'
        TabOrder = 2
      end
      object chkSTPrefSupp: TCheckBox
        Left = 243
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Preferred Supp'
        TabOrder = 7
      end
      object chkSTUnitStock: TCheckBox
        Left = 243
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Unit of Stock'
        TabOrder = 12
      end
      object chkSTUser3: TCheckBox
        Left = 243
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 3'
        TabOrder = 17
      end
      object chkSTUser4: TCheckBox
        Left = 352
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 4'
        TabOrder = 18
      end
      object chkSTUnitPurchase: TCheckBox
        Left = 352
        Top = 131
        Width = 99
        Height = 17
        Caption = 'Unit of Purchase'
        TabOrder = 13
      end
      object chkSTAltCode: TCheckBox
        Left = 352
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Alternate Code'
        TabOrder = 8
      end
      object chkSTDesc3: TCheckBox
        Left = 352
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Descr Line 3'
        TabOrder = 3
      end
      object chkSTDesc4: TCheckBox
        Left = 461
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Descr Line 4'
        TabOrder = 4
      end
      object chkSTLocation: TCheckBox
        Left = 461
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Location'
        TabOrder = 9
      end
      object chkSTUnitSale: TCheckBox
        Left = 461
        Top = 131
        Width = 97
        Height = 17
        Caption = 'Unit of Sale'
        TabOrder = 14
      end
      object chkSTUser5: TCheckBox
        Left = 461
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 5'
        TabOrder = 19
      end
      object chkSTUser6: TCheckBox
        Left = 24
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 6'
        TabOrder = 20
      end
      object chkSTUser7: TCheckBox
        Left = 133
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 7'
        TabOrder = 21
      end
      object chkSTUser8: TCheckBox
        Left = 241
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 8'
        TabOrder = 22
      end
      object chkSTUser9: TCheckBox
        Left = 351
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 9'
        TabOrder = 23
      end
      object chkSTUser10: TCheckBox
        Left = 461
        Top = 191
        Width = 97
        Height = 17
        Caption = 'User Field 10'
        TabOrder = 24
      end
      object chkSTLinkActive: TCheckBox
        Left = 10
        Top = 11
        Width = 187
        Height = 17
        Caption = 'Enable Extended Search for Stock'
        TabOrder = 26
        OnClick = chkSTLinkActiveClick
      end
    end
    object tabshJobCosting: TTabSheet
      Caption = 'Job Costing'
      ImageIndex = 2
      PopupMenu = JobCostingPopupMenu1
      object Label6: TLabel
        Left = 10
        Top = 41
        Width = 335
        Height = 14
        Caption = 
          'Select the fields below which you want to include within the sea' +
          'rch:-'
      end
      object chkJCCode: TCheckBox
        Left = 25
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Code'
        TabOrder = 0
      end
      object chkJCAltCode: TCheckBox
        Left = 25
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Alt Code'
        TabOrder = 5
      end
      object chkJCUser3: TCheckBox
        Left = 25
        Top = 131
        Width = 97
        Height = 17
        Caption = 'User Field 3'
        TabOrder = 10
      end
      object chkJCUser4: TCheckBox
        Left = 134
        Top = 131
        Width = 97
        Height = 17
        Caption = 'User Field 4'
        TabOrder = 11
      end
      object chkJCJobType: TCheckBox
        Left = 134
        Top = 101
        Width = 97
        Height = 17
        Caption = 'Job Type'
        TabOrder = 6
      end
      object chkJCDesc1: TCheckBox
        Left = 134
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Description'
        TabOrder = 1
      end
      object chkJCJobContact: TCheckBox
        Left = 243
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Contact'
        TabOrder = 2
      end
      object chkJCSORRef: TCheckBox
        Left = 243
        Top = 101
        Width = 97
        Height = 17
        Caption = 'SOR Ref'
        TabOrder = 7
      end
      object chkJCUser1: TCheckBox
        Left = 352
        Top = 101
        Width = 97
        Height = 17
        Caption = 'User Field 1'
        TabOrder = 8
      end
      object chkJCJobManager: TCheckBox
        Left = 352
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Manager'
        TabOrder = 3
      end
      object chkJCCustCode: TCheckBox
        Left = 461
        Top = 71
        Width = 97
        Height = 17
        Caption = 'Customer Code'
        TabOrder = 4
      end
      object chkJCUser2: TCheckBox
        Left = 461
        Top = 101
        Width = 97
        Height = 17
        Caption = 'User Field 2'
        TabOrder = 9
      end
      object chkJCUser5: TCheckBox
        Left = 243
        Top = 131
        Width = 97
        Height = 17
        Caption = 'User Field 5'
        TabOrder = 12
      end
      object chkJCUser6: TCheckBox
        Left = 352
        Top = 131
        Width = 97
        Height = 17
        Caption = 'User Field 6'
        TabOrder = 13
      end
      object chkJCUser7: TCheckBox
        Left = 461
        Top = 131
        Width = 97
        Height = 17
        Caption = 'User Field 7'
        TabOrder = 14
      end
      object chkJCUser8: TCheckBox
        Left = 25
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 8'
        TabOrder = 15
      end
      object chkJCUser9: TCheckBox
        Left = 134
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 9'
        TabOrder = 16
      end
      object chkJCUser10: TCheckBox
        Left = 243
        Top = 161
        Width = 97
        Height = 17
        Caption = 'User Field 10'
        TabOrder = 17
      end
      object chkJCLinkActive: TCheckBox
        Left = 10
        Top = 11
        Width = 216
        Height = 17
        Caption = 'Enable Extended Search for Job Costing'
        TabOrder = 18
        OnClick = chkJCLinkActiveClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'SQL Settings'
      ImageIndex = 3
      object lblMaxRows: TLabel
        Left = 10
        Top = 10
        Width = 540
        Height = 29
        AutoSize = False
        Caption = 
          'The performance of the Extended Search dialog will depend on the' +
          ' maximum number of rows you choose to display.  The higher the n' +
          'umber of rows you display the longer it will take to retrieve th' +
          'e data.'
        WordWrap = True
      end
      object Label1: TLabel
        Left = 25
        Top = 61
        Width = 107
        Height = 14
        Caption = 'Display a maximum of '
      end
      object Label7: TLabel
        Left = 211
        Top = 60
        Width = 71
        Height = 14
        Caption = 'rows (1-9999)'
      end
      object Label8: TLabel
        Left = 10
        Top = 101
        Width = 540
        Height = 44
        AutoSize = False
        Caption = 
          'During periods of heavy/volume traffic you may get timeout error' +
          's when trying to retrieve the data, the settings below allow you' +
          ' to customise how long the Extended Search plug-in will wait for' +
          ' MS SQL Server to respond:-'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 33
        Top = 151
        Width = 94
        Height = 14
        Caption = 'Connection Timeout'
      end
      object Label3: TLabel
        Left = 40
        Top = 191
        Width = 87
        Height = 14
        Caption = 'Command Timeout'
      end
      object Label10: TLabel
        Left = 190
        Top = 190
        Width = 42
        Height = 14
        Caption = 'seconds'
      end
      object Label9: TLabel
        Left = 190
        Top = 150
        Width = 42
        Height = 14
        Caption = 'seconds'
      end
      object edtMaxRows: TEdit
        Left = 134
        Top = 57
        Width = 54
        Height = 22
        TabOrder = 0
        Text = '1'
      end
      object edtConnectionTimeout: TEdit
        Left = 134
        Top = 147
        Width = 35
        Height = 22
        TabOrder = 2
        Text = '1'
      end
      object edtCommandTimeout: TEdit
        Left = 134
        Top = 187
        Width = 35
        Height = 22
        TabOrder = 4
        Text = '1'
      end
      object udMaxRows: TUpDown
        Left = 188
        Top = 57
        Width = 16
        Height = 22
        Associate = edtMaxRows
        Min = 1
        Max = 9999
        Position = 1
        TabOrder = 1
        Wrap = False
      end
      object udConnectionTimeout: TUpDown
        Left = 169
        Top = 147
        Width = 16
        Height = 22
        Associate = edtConnectionTimeout
        Min = 1
        Max = 300
        Position = 1
        TabOrder = 3
        Wrap = False
      end
      object udCommandTimeout: TUpDown
        Left = 169
        Top = 187
        Width = 16
        Height = 22
        Associate = edtCommandTimeout
        Min = 1
        Max = 300
        Position = 1
        TabOrder = 5
        Wrap = False
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 690
    Top = 81
  end
  object CustomerPopumMenu: TPopupMenu
    Left = 552
    Top = 36
    object CustomerCheckAll1: TMenuItem
      Caption = 'Check All'
      OnClick = CustomerCheckAll1Click
    end
    object CustomerUnCheckAll1: TMenuItem
      Caption = 'Uncheck All'
      OnClick = CustomerUnCheckAll1Click
    end
  end
  object StockPopumMenu: TPopupMenu
    Left = 584
    Top = 36
    object StockCheckAll1: TMenuItem
      Caption = 'Check All'
      OnClick = StockCheckAll1Click
    end
    object StockUnCheckAll1: TMenuItem
      Caption = 'Uncheck All'
      OnClick = StockUnCheckAll1Click
    end
  end
  object JobCostingPopupMenu1: TPopupMenu
    Left = 616
    Top = 36
    object JobCostingCheckAll1: TMenuItem
      Caption = 'Check All'
      OnClick = JobCostingCheckAll1Click
    end
    object JobCostingUnCheckAll1: TMenuItem
      Caption = 'Uncheck All'
      OnClick = JobCostingUnCheckAll1Click
    end
  end
end
