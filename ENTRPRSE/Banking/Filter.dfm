object frmFilterInput: TfrmFilterInput
  Left = 237
  Top = 114
  HelpContext = 1995
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Filter'
  ClientHeight = 233
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblFormFilters: TLabel
    Left = 8
    Top = 8
    Width = 257
    Height = 25
    AutoSize = False
    Caption = 'Current filters: '
    WordWrap = True
  end
  object Panel1: TPanel
    Left = 8
    Top = 40
    Width = 257
    Height = 145
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 36
      Top = 20
      Width = 54
      Height = 14
      Alignment = taRightJustify
      Caption = 'Filter list by'
    end
    object lblFrom: TLabel
      Left = 22
      Top = 56
      Width = 24
      Height = 14
      Caption = 'From'
    end
    object lblTo: TLabel
      Left = 142
      Top = 56
      Width = 11
      Height = 14
      Caption = 'To'
    end
    object pnlDocType: TPanel
      Left = 2
      Top = 69
      Width = 252
      Height = 65
      BevelOuter = bvNone
      TabOrder = 1
      object cbTypeFrom: TComboBox
        Left = 20
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1997
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 0
        Text = 'NOM'
        Items.Strings = (
          'NOM'
          'PPI'
          'PPY'
          'SRC'
          'SRI')
      end
      object cbTypeTo: TComboBox
        Left = 140
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1998
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'NOM'
        Items.Strings = (
          'NOM'
          'PPI'
          'PPY'
          'SRC'
          'SRI')
      end
    end
    object pnlAmount: TPanel
      Left = 2
      Top = 69
      Width = 252
      Height = 73
      BevelOuter = bvNone
      TabOrder = 2
      object ceFrom: TCurrencyEdit
        Left = 20
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1997
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object ceTo: TCurrencyEdit
        Left = 140
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1998
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
    object pnlDate: TPanel
      Left = 2
      Top = 69
      Width = 252
      Height = 73
      BevelOuter = bvNone
      TabOrder = 3
      object edDateFrom: TEditDate
        Left = 20
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1997
        AutoSelect = False
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 0
        Placement = cpAbove
      end
      object edDateTo: TEditDate
        Left = 140
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1998
        AutoSelect = False
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 1
        Placement = cpAbove
      end
    end
    object pnlText: TPanel
      Left = 2
      Top = 69
      Width = 251
      Height = 57
      BevelOuter = bvNone
      TabOrder = 4
      object edtFrom: Text8Pt
        Left = 20
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1997
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnExit = edtFromExit
        TextId = 0
        ViaSBtn = False
      end
      object edtTo: Text8Pt
        Left = 140
        Top = 0
        Width = 101
        Height = 22
        HelpContext = 1998
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnExit = edtFromExit
        TextId = 0
        ViaSBtn = False
      end
    end
    object cbFilterBy: TSBSComboBox
      Left = 98
      Top = 16
      Width = 122
      Height = 22
      HelpContext = 1996
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'Document Type'
      OnChange = cbFilterByChange
      Items.Strings = (
        'Document Type'
        'Account Code'
        'Reference'
        'Amount'
        'Status'
        'Date')
      MaxListWidth = 0
    end
    object pnlStatusCb: TPanel
      Left = 2
      Top = 69
      Width = 251
      Height = 68
      BevelOuter = bvNone
      TabOrder = 5
      object Label4: TLabel
        Left = 53
        Top = 8
        Width = 37
        Height = 14
        Alignment = taRightJustify
        Caption = 'Include '
      end
      object cbFrom: TComboBox
        Left = 96
        Top = 4
        Width = 121
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        Items.Strings = (
          'Uncleared'
          'Cleared'
          'Cancelled'
          'Returned'
          'Not Cleared'
          'All')
      end
    end
  end
  object btnOK: TSBSButton
    Left = 52
    Top = 200
    Width = 80
    Height = 21
    HelpContext = 1999
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 140
    Top = 200
    Width = 80
    Height = 21
    HelpContext = 2000
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 144
  end
end
