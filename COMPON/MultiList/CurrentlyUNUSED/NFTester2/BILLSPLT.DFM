object FrmBillSplit: TFrmBillSplit
  Left = 151
  Top = 171
  Width = 550
  Height = 420
  HelpContext = 19
  Caption = 'Bill Splitting'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000008888888888888800877777777777780087F
    FFFFFF777780087FFFFFFF788780087FFFFFFF77778008733333337887800877
    777777777780087FF7FFF7FFF7800877777777777780087FF7FFF7FFF7800877
    777777777780088888888888888000000000000000000000000000000000FFFF
    0000FFFF00008001000080010000800100008001000080010000800100008001
    00008001000080010000800100008001000080010000FFFF0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object sbCards: TScrollBox
    Left = 8
    Top = 144
    Width = 377
    Height = 241
    VertScrollBar.Visible = False
    TabOrder = 1
    object panCardNo: TSBSPanel
      Tag = 1
      Left = 3
      Top = 28
      Width = 46
      Height = 205
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      OnMouseUp = panCardNoMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object panName: TSBSPanel
      Tag = 1
      Left = 53
      Top = 28
      Width = 124
      Height = 205
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseUp = panCardNoMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object panTitle: TSBSPanel
      Left = 3
      Top = 4
      Width = 367
      Height = 21
      BevelOuter = bvLowered
      Color = clOlive
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object panCardNoTit: TSBSPanel
        Tag = 1
        Left = 1
        Top = 1
        Width = 48
        Height = 19
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Card No'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        OnMouseDown = panNameTitMouseDown
        OnMouseMove = panNameTitMouseMove
        OnMouseUp = panCardNoMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object panNameTit: TSBSPanel
        Tag = 1
        Left = 52
        Top = 1
        Width = 120
        Height = 19
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Name'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 1
        OnMouseDown = panNameTitMouseDown
        OnMouseMove = panNameTitMouseMove
        OnMouseUp = panCardNoMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object panDiscTit: TSBSPanel
        Tag = 1
        Left = 308
        Top = 1
        Width = 56
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Discount'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 2
        OnMouseDown = panNameTitMouseDown
        OnMouseMove = panNameTitMouseMove
        OnMouseUp = panCardNoMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object panBalTit: TSBSPanel
        Tag = 1
        Left = 180
        Top = 1
        Width = 56
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Curr Bal.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 3
        OnMouseDown = panNameTitMouseDown
        OnMouseMove = panNameTitMouseMove
        OnMouseUp = panCardNoMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object panAmountTit: TSBSPanel
        Tag = 1
        Left = 244
        Top = 1
        Width = 56
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvNone
        Caption = 'Amount'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 4
        OnMouseDown = panNameTitMouseDown
        OnMouseMove = panNameTitMouseMove
        OnMouseUp = panCardNoMouseUp
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object panDiscount: TSBSPanel
      Tag = 1
      Left = 309
      Top = 28
      Width = 60
      Height = 205
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnMouseUp = panCardNoMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object panBalance: TSBSPanel
      Tag = 1
      Left = 181
      Top = 28
      Width = 60
      Height = 205
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnMouseUp = panCardNoMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
    object panAmount: TSBSPanel
      Tag = 1
      Left = 245
      Top = 28
      Width = 60
      Height = 205
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnMouseUp = panCardNoMouseUp
      AllowReSize = True
      IsGroupBox = False
      TextId = 0
    end
  end
  object panScrollBar: TSBSPanel
    Left = 392
    Top = 174
    Width = 17
    Height = 211
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object panButtons: TSBSPanel
    Left = 424
    Top = 144
    Width = 110
    Height = 241
    BevelOuter = bvLowered
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object sbButtons: TScrollBox
      Left = 1
      Top = 40
      Width = 108
      Height = 193
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      TabOrder = 1
      object btnDelete: TSBSButton
        Left = 7
        Top = 48
        Width = 82
        Height = 21
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnDeleteClick
        TextId = 0
      end
      object btnAdd: TSBSButton
        Tag = 2
        Left = 7
        Top = 0
        Width = 82
        Height = 21
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddClick
        TextId = 0
      end
      object btnEdit: TSBSButton
        Tag = 1
        Left = 7
        Top = 24
        Width = 82
        Height = 21
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnAddClick
        TextId = 0
      end
      object btnProcess: TSBSButton
        Left = 7
        Top = 80
        Width = 82
        Height = 21
        Caption = '&Process'
        Enabled = False
        TabOrder = 3
        OnClick = btnProcessClick
        TextId = 0
      end
    end
    object btnLClose: TSBSButton
      Left = 8
      Top = 7
      Width = 81
      Height = 21
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 0
      TextId = 0
    end
  end
  object sbHeader: TScrollBox
    Left = 8
    Top = 0
    Width = 526
    Height = 137
    VertScrollBar.Visible = False
    BorderStyle = bsNone
    TabOrder = 0
    object Bevel3: TBevel
      Left = 0
      Top = 84
      Width = 526
      Height = 37
      Shape = bsFrame
    end
    object Bevel2: TBevel
      Left = 0
      Top = 8
      Width = 201
      Height = 78
      Shape = bsFrame
    end
    object Bevel1: TBevel
      Left = 199
      Top = 8
      Width = 327
      Height = 78
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 212
      Top = 16
      Width = 56
      Height = 14
      Alignment = taRightJustify
      Caption = 'Invoice No :'
    end
    object Label2: TLabel
      Left = 223
      Top = 40
      Width = 45
      Height = 14
      Alignment = taRightJustify
      Caption = 'Card No :'
    end
    object Label3: TLabel
      Left = 235
      Top = 64
      Width = 33
      Height = 14
      Alignment = taRightJustify
      Caption = 'Name :'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 69
      Height = 14
      Alignment = taRightJustify
      Caption = 'Card Amount :'
    end
    object Label5: TLabel
      Left = 45
      Top = 16
      Width = 69
      Height = 14
      Alignment = taRightJustify
      Caption = 'Total Amount :'
    end
    object Label6: TLabel
      Left = 12
      Top = 64
      Width = 102
      Height = 14
      Alignment = taRightJustify
      Caption = 'Unallocated Amount :'
    end
    object Label7: TLabel
      Left = 40
      Top = 40
      Width = 74
      Height = 14
      Alignment = taRightJustify
      Caption = 'Total Discount :'
    end
    object Label8: TLabel
      Left = 151
      Top = 96
      Width = 74
      Height = 14
      Alignment = taRightJustify
      Caption = 'Card Discount :'
    end
    object Label9: TLabel
      Left = 280
      Top = 96
      Width = 50
      Height = 14
      Alignment = taRightJustify
      Caption = 'Comment :'
    end
    object lInvoiceNo: TLabel
      Left = 271
      Top = 16
      Width = 56
      Height = 14
      Caption = 'lInvoiceNo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lCardNo: TLabel
      Left = 271
      Top = 40
      Width = 43
      Height = 14
      Caption = 'lCardNo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lName: TLabel
      Left = 271
      Top = 64
      Width = 34
      Height = 14
      Caption = 'lName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lCardDisc: TLabel
      Left = 231
      Top = 96
      Width = 21
      Height = 14
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lTotalAmount: TLabel
      Left = 119
      Top = 16
      Width = 74
      Height = 14
      Caption = 'lTotalAmount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lUnallocated: TLabel
      Left = 119
      Top = 64
      Width = 66
      Height = 14
      Caption = 'lUnallocated'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lTotalDisc: TLabel
      Left = 119
      Top = 40
      Width = 53
      Height = 14
      Caption = 'lTotalDisc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19018
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edComment: Text8Pt
      Left = 333
      Top = 92
      Width = 185
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
    object edAmount: TCurrencyEdit
      Left = 80
      Top = 92
      Width = 57
      Height = 22
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
      OnExit = edAmountExit
      AutoSize = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object pmMain: TPopupMenu
    Left = 21
    Top = 182
  end
end
