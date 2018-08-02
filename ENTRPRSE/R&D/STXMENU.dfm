object InvAddForm: TInvAddForm
  Left = 369
  Top = 354
  HelpContext = 9
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add a Transaction'
  ClientHeight = 139
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = -1
    Top = 0
    Width = 421
    Height = 139
    ActivePage = SalesPage
    TabIndex = 1
    TabOrder = 2
    OnChange = PageControl1Change
    object PurchPage: TTabSheet
      Caption = 'Purchase'
      object PinBtn: TBorRadio
        Tag = 1
        Left = 16
        Top = 6
        Width = 89
        Height = 20
        HelpContext = 34
        Align = alRight
        Caption = '&Invoice'
        Checked = True
        GroupIndex = 1
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object PPYBtn: TBorRadio
        Tag = 2
        Left = 16
        Top = 30
        Width = 89
        Height = 20
        HelpContext = 35
        Align = alRight
        Caption = '&Payment'
        GroupIndex = 1
        TabOrder = 1
        TextId = 0
        OnClick = SRCBtnClick
      end
      object PCRBtn: TBorRadio
        Tag = 3
        Left = 16
        Top = 54
        Width = 89
        Height = 20
        HelpContext = 36
        Align = alRight
        Caption = '&Credit Note'
        GroupIndex = 1
        TabOrder = 2
        TextId = 0
      end
      object PJIBtn: TBorRadio
        Tag = 4
        Left = 112
        Top = 30
        Width = 145
        Height = 20
        HelpContext = 38
        Align = alRight
        Caption = '&Journal Invoice'
        GroupIndex = 1
        TabOrder = 4
        TextId = 0
      end
      object PJCBtn: TBorRadio
        Tag = 5
        Left = 112
        Top = 54
        Width = 145
        Height = 20
        HelpContext = 39
        Align = alRight
        Caption = 'Journa&l Credit Note'
        GroupIndex = 1
        TabOrder = 5
        TextId = 0
      end
      object PPIBtn: TBorRadio
        Tag = 7
        Left = 264
        Top = 6
        Width = 137
        Height = 20
        HelpContext = 40
        Align = alRight
        Caption = 'Payment with In&voice'
        GroupIndex = 1
        TabOrder = 6
        TextId = 0
      end
      object PRFBtn: TBorRadio
        Tag = 6
        Left = 264
        Top = 30
        Width = 137
        Height = 20
        HelpContext = 41
        Align = alRight
        Caption = 'Credit with Re&fund'
        GroupIndex = 1
        TabOrder = 7
        TextId = 0
      end
      object PQUBtn: TBorRadio
        Tag = 8
        Left = 112
        Top = 6
        Width = 145
        Height = 20
        HelpContext = 37
        Align = alRight
        Caption = '&Quote/Order'
        GroupIndex = 1
        TabOrder = 3
        TextId = 0
      end
      object PBTBtn: TBorRadio
        Tag = 9
        Left = 264
        Top = 54
        Width = 137
        Height = 20
        HelpContext = 40099
        Align = alRight
        Caption = '&Batch'
        GroupIndex = 1
        TabOrder = 8
        TextId = 0
      end
    end
    object SalesPage: TTabSheet
      Caption = 'Sales'
      object SINBtn: TBorRadio
        Tag = 1
        Left = 16
        Top = 6
        Width = 89
        Height = 20
        HelpContext = 34
        Align = alRight
        Caption = '&Invoice'
        Checked = True
        GroupIndex = 2
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object SRCBtn: TBorRadio
        Tag = 2
        Left = 16
        Top = 30
        Width = 89
        Height = 20
        HelpContext = 35
        Align = alRight
        Caption = '&Receipt'
        GroupIndex = 2
        TabOrder = 1
        TextId = 0
        OnClick = SRCBtnClick
      end
      object SCRBtn: TBorRadio
        Tag = 3
        Left = 16
        Top = 54
        Width = 89
        Height = 20
        HelpContext = 36
        Align = alRight
        Caption = '&Credit Note'
        GroupIndex = 2
        TabOrder = 2
        TextId = 0
      end
      object SJIBtn: TBorRadio
        Tag = 4
        Left = 112
        Top = 30
        Width = 145
        Height = 20
        HelpContext = 38
        Align = alRight
        Caption = '&Journal Invoice'
        GroupIndex = 2
        TabOrder = 4
        TextId = 0
      end
      object SJCBtn: TBorRadio
        Tag = 5
        Left = 112
        Top = 54
        Width = 145
        Height = 20
        HelpContext = 39
        Align = alRight
        Caption = 'Journa&l Credit Note'
        GroupIndex = 2
        TabOrder = 5
        TextId = 0
      end
      object SRIBtn: TBorRadio
        Tag = 7
        Left = 264
        Top = 6
        Width = 137
        Height = 20
        HelpContext = 40
        Align = alRight
        Caption = 'Receipt with In&voice'
        GroupIndex = 2
        TabOrder = 6
        TextId = 0
      end
      object SRFBtn: TBorRadio
        Tag = 6
        Left = 264
        Top = 30
        Width = 137
        Height = 20
        HelpContext = 41
        Align = alRight
        Caption = 'Credit with Re&fund'
        GroupIndex = 2
        TabOrder = 7
        TextId = 0
      end
      object SQUBtn: TBorRadio
        Tag = 8
        Left = 112
        Top = 6
        Width = 145
        Height = 20
        HelpContext = 37
        Align = alRight
        Caption = '&Quote/Order/Pro-Forma'
        GroupIndex = 2
        TabOrder = 3
        TextId = 0
      end
      object SBTBtn: TBorRadio
        Tag = 9
        Left = 264
        Top = 54
        Width = 137
        Height = 20
        HelpContext = 40099
        Align = alRight
        Caption = '&Batch'
        GroupIndex = 2
        TabOrder = 8
        TextId = 0
      end
    end
    object tsCashbook: TTabSheet
      Caption = 'Cashbook'
      ImageIndex = 2
      object rbPayment: TBorRadio
        Tag = 1
        Left = 16
        Top = 6
        Width = 106
        Height = 20
        Align = alRight
        Caption = 'Bank Payment'
        Checked = True
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object rbReceipt: TBorRadio
        Tag = 2
        Left = 16
        Top = 30
        Width = 106
        Height = 20
        Align = alRight
        Caption = 'Bank Receipt'
        TabOrder = 1
        TextId = 0
      end
      object rbTransfer: TBorRadio
        Tag = 3
        Left = 16
        Top = 54
        Width = 107
        Height = 20
        Align = alRight
        Caption = 'Bank Transfer'
        TabOrder = 2
        TextId = 0
      end
      object rbStandard: TBorRadio
        Tag = 4
        Left = 128
        Top = 6
        Width = 121
        Height = 20
        Align = alRight
        Caption = 'Standard Journal'
        TabOrder = 3
        TextId = 0
      end
      object cbRecurring: TBorCheckEx
        Tag = 5
        Left = 256
        Top = 6
        Width = 137
        Height = 20
        Align = alRight
        Caption = 'Recurring Transaction'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
    end
  end
  object ClsCP1Btn: TButton
    Left = 212
    Top = 108
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = ClsCP1BtnClick
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 126
    Top = 108
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OkCP1BtnClick
  end
end
