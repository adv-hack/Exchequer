object BankRecMM: TBankRecMM
  Left = 639
  Top = 223
  Width = 553
  Height = 385
  HelpContext = 600
  Caption = 'Reconciliation Matching - Cashbook v Statement Entries'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 544
    Height = 357
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    object ItemPage: TTabSheet
      Caption = 'Reconciliation Matching - Cashbook v Statement Entries'
      object D1SBox: TScrollBox
        Left = 5
        Top = 5
        Width = 406
        Height = 278
        VertScrollBar.Visible = False
        TabOrder = 0
        object D1HedPanel: TSBSPanel
          Left = 3
          Top = 4
          Width = 452
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object D1CBLab: TSBSPanel
            Left = 115
            Top = 2
            Width = 101
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Cashbook Entries'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = D1DesLabMouseDown
            OnMouseMove = D1DesLabMouseMove
            OnMouseUp = D1DesPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1DetLab: TSBSPanel
            Left = 321
            Top = 2
            Width = 128
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '    Details'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = D1DesLabMouseDown
            OnMouseMove = D1DesLabMouseMove
            OnMouseUp = D1DesPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1DesLab: TSBSPanel
            Left = 1
            Top = 3
            Width = 113
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = ' Reference'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = D1DesLabMouseDown
            OnMouseMove = D1DesLabMouseMove
            OnMouseUp = D1DesPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1StatLab: TSBSPanel
            Left = 217
            Top = 2
            Width = 101
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Statement Entries'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = D1DesLabMouseDown
            OnMouseMove = D1DesLabMouseMove
            OnMouseUp = D1DesPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object D1DesPanel: TSBSPanel
          Left = 3
          Top = 24
          Width = 114
          Height = 232
          HelpContext = 566
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = D1DesPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1CBPanel: TSBSPanel
          Left = 119
          Top = 24
          Width = 100
          Height = 232
          HelpContext = 601
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = D1DesPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1StatPanel: TSBSPanel
          Left = 221
          Top = 24
          Width = 100
          Height = 232
          HelpContext = 602
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = D1DesPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1DetPanel: TSBSPanel
          Left = 323
          Top = 24
          Width = 134
          Height = 232
          HelpContext = 603
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = D1DesPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object D1ListBtnPanel: TSBSPanel
        Left = 413
        Top = 32
        Width = 18
        Height = 231
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object TotalPanel: TSBSPanel
        Left = 0
        Top = 288
        Width = 536
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label82: Label8
          Left = 255
          Top = -1
          Width = 60
          Height = 14
          Caption = 'Total Tagged'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label81: Label8
          Left = 154
          Top = -1
          Width = 60
          Height = 14
          Caption = 'Total Tagged'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label84: Label8
          Left = 380
          Top = -1
          Width = 39
          Height = 14
          Caption = 'Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object TotTag1: TCurrencyEdit
          Left = 130
          Top = 16
          Width = 95
          Height = 22
          TabStop = False
          Color = clBtnFace
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0.00 ')
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
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
        object TotTag2: TCurrencyEdit
          Left = 232
          Top = 16
          Width = 95
          Height = 22
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0.00 ')
          ParentFont = False
          ReadOnly = True
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
        object TotBal: TCurrencyEdit
          Left = 335
          Top = 16
          Width = 95
          Height = 22
          TabStop = False
          Color = clBtnFace
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0.00 ')
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
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
    end
  end
  object D1BtnPanel: TSBSPanel
    Left = 437
    Top = 29
    Width = 102
    Height = 321
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object D1BSBox: TScrollBox
      Left = 0
      Top = 89
      Width = 99
      Height = 228
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object TagD1Btn: TButton
        Left = 2
        Top = 0
        Width = 80
        Height = 21
        Hint = 
          'Tag the currently highlighted entry|Choosing this option will ta' +
          'g, or untag the currently highlighted entry. When tagging you mu' +
          'st tag two corresponding entries.'
        HelpContext = 604
        Caption = '&Tag'
        TabOrder = 0
        OnClick = TagD1BtnClick
      end
      object FindD1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 'Find an entry|Find an entry by amount or by reference.'
        HelpContext = 587
        Caption = '&Find'
        TabOrder = 1
        OnClick = FindD1BtnClick
      end
      object ViewD1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'View the highlihted entry|Choosing this option will drill down t' +
          'o the transaction shown within the details section of the list.'
        HelpContext = 605
        Caption = '&View'
        TabOrder = 2
        OnClick = ViewD1BtnClick
      end
      object RefD1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Refresh list|Choosing this option will search for any new unclea' +
          'red items added to the G/L since the list was first created.'
        HelpContext = 606
        Caption = 'R&efresh'
        TabOrder = 3
        OnClick = RefD1BtnClick
      end
      object ChkD1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Recalculate screen totals|If for some reason the screen totals d' +
          'o not represent the entries on the list, choosing this option wi' +
          'll correct the problem.'
        HelpContext = 572
        Caption = '&Check'
        TabOrder = 7
        OnClick = ChkD1BtnClick
      end
      object ProcD1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Process all tagged items|Clears all tagged entries. Note, the ba' +
          'lance at the bottom of the screen should read 0 before processin' +
          'g will be allowed.'
        HelpContext = 607
        Caption = '&Process'
        TabOrder = 4
        OnClick = ProcD1BtnClick
      end
      object RepD1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 'Print a report of the entries|Print a report of the entries.'
        HelpContext = 608
        Caption = '&Report'
        TabOrder = 5
        OnClick = RepD1BtnClick
      end
      object SplitD1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Split the list into two separate lists|Choosing this list will s' +
          'plit the Cashbook entries from the Statement entries, making it ' +
          'easier to find both parts.'
        HelpContext = 610
        Caption = '&Split List'
        TabOrder = 6
        OnClick = SplitD1BtnClick
      end
    end
    object Clsd1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = Clsd1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 512
    Top = 65531
    object Tag1: TMenuItem
      Caption = '&Tag'
      OnClick = TagD1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindD1BtnClick
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = ViewD1BtnClick
    end
    object Ref1: TMenuItem
      Caption = 'R&efresh'
      OnClick = RefD1BtnClick
    end
    object Process1: TMenuItem
      Caption = '&Process'
      OnClick = ProcD1BtnClick
    end
    object Report1: TMenuItem
      Caption = '&Report'
      OnClick = RepD1BtnClick
    end
    object SplitList1: TMenuItem
      Caption = '&Split List'
    end
    object Check1: TMenuItem
      Caption = '&Check'
      OnClick = ChkD1BtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 493
    Top = 65532
    object Amount1: TMenuItem
      Tag = 20
      Caption = '&Amount'
      OnClick = Amount1Click
    end
    object Details1: TMenuItem
      Tag = 23
      Caption = '&Details'
      OnClick = Amount1Click
    end
  end
end
