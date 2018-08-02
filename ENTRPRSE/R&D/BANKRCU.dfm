object BankARec: TBankARec
  Left = 551
  Top = 313
  Width = 554
  Height = 386
  HelpContext = 575
  VertScrollBar.Position = 26
  Caption = 'Reconciliation Entry & Automatic Matching'
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
  ShowHint = True
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
    Top = -26
    Width = 544
    Height = 357
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    object ItemPage: TTabSheet
      Caption = 'Statement Entries'
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
          Width = 471
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object D1PayLab: TSBSPanel
            Left = 115
            Top = 2
            Width = 101
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Payments  '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = D1RefLabMouseDown
            OnMouseMove = D1RefLabMouseMove
            OnMouseUp = D1RefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1StatLab: TSBSPanel
            Left = 321
            Top = 2
            Width = 100
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = '  Status'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = D1RefLabMouseDown
            OnMouseMove = D1RefLabMouseMove
            OnMouseUp = D1RefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1RefLab: TSBSPanel
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
            OnMouseDown = D1RefLabMouseDown
            OnMouseMove = D1RefLabMouseMove
            OnMouseUp = D1RefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object D1RecLab: TSBSPanel
            Left = 217
            Top = 2
            Width = 101
            Height = 13
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Receipts  '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = D1RefLabMouseDown
            OnMouseMove = D1RefLabMouseMove
            OnMouseUp = D1RefPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object D1RefPanel: TSBSPanel
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
          OnMouseUp = D1RefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1PayPanel: TSBSPanel
          Left = 119
          Top = 24
          Width = 100
          Height = 232
          HelpContext = 577
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
          OnMouseUp = D1RefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1RecPanel: TSBSPanel
          Left = 221
          Top = 24
          Width = 100
          Height = 232
          HelpContext = 577
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
          OnMouseUp = D1RefPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object D1StatPanel: TSBSPanel
          Left = 323
          Top = 24
          Width = 150
          Height = 232
          HelpContext = 576
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
          OnMouseUp = D1RefPanelMouseUp
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
          Left = 244
          Top = -1
          Width = 67
          Height = 14
          Caption = 'Total Receipts'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label81: Label8
          Left = 149
          Top = -1
          Width = 72
          Height = 14
          Caption = 'Total Payments'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label83: Label8
          Left = 40
          Top = -1
          Width = 82
          Height = 14
          Caption = 'Opening Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label84: Label8
          Left = 347
          Top = -1
          Width = 77
          Height = 14
          Caption = 'Closing Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object TotPay: TCurrencyEdit
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
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
        object TotRec: TCurrencyEdit
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
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
        object TotOB: TCurrencyEdit
          Left = 27
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
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
        object TotCB: TCurrencyEdit
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
          TabOrder = 3
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
          ShowCurrency = True
          TextId = 0
          Value = 1E-10
        end
      end
    end
  end
  object D1BtnPanel: TSBSPanel
    Left = 437
    Top = 3
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
      object AddD1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add a manual statement entry|Adds a manual statement entry to th' +
          'e list for subseqent matching by reference.'
        HelpContext = 585
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddD1BtnClick
      end
      object EditCD1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit the currently highlighted entry|Edit the currently highligh' +
          'ted entry.'
        HelpContext = 585
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddD1BtnClick
      end
      object DelD1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Delete the currently highlighted entry|Delete the currently high' +
          'lighted entry.'
        HelpContext = 586
        Caption = '&Delete'
        TabOrder = 2
        OnClick = DelD1BtnClick
      end
      object FindD1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 'Find an entry|Find an entry by amount or by reference.'
        HelpContext = 587
        Caption = '&Find'
        TabOrder = 3
        OnClick = FindD1BtnClick
      end
      object ChkD1Btn: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Recalculate screen totals|If for some reason the screen totals d' +
          'o not represent the entries on the list, choosing this option wi' +
          'll correct the problem.'
        HelpContext = 591
        Caption = '&Check'
        TabOrder = 8
        OnClick = ChkD1BtnClick
      end
      object BankD1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Open the manual bank rec screen|Opens the manual bank reconcilia' +
          'tion screen to manualy match entries which remain unmatched afte' +
          'r automatic matching.'
        HelpContext = 600
        Caption = '&Bank-Rec'
        TabOrder = 4
        OnClick = BankD1BtnClick
      end
      object RepD1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Print a report of current entries|Print a report of current entr' +
          'ies.'
        HelpContext = 589
        Caption = '&Report'
        TabOrder = 6
        OnClick = RepD1BtnClick
      end
      object MatchD1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Automatically match entries|Choosing this option will start the ' +
          'matching process by reference and value.'
        HelpContext = 588
        Caption = '&Match'
        TabOrder = 5
        OnClick = MatchD1BtnClick
      end
      object ProcD1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Process all matched entries|Process all entries previously match' +
          'ed, and clear the corresponding item on the main bank reconcilia' +
          'tion screen.'
        HelpContext = 607
        Caption = '&Process'
        TabOrder = 7
        OnClick = MatchD1BtnClick
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
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = AddD1BtnClick
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = AddD1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = DelD1BtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
    end
    object BankRec1: TMenuItem
      Caption = '&Bank-Rec'
      OnClick = BankD1BtnClick
    end
    object Match1: TMenuItem
      Caption = '&Match'
      OnClick = MatchD1BtnClick
    end
    object Report1: TMenuItem
      Caption = '&Report'
    end
    object Process1: TMenuItem
      Caption = '&Process'
      OnClick = MatchD1BtnClick
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
  object PopupMenu3: TPopupMenu
    Left = 475
    Top = 65532
    object AllEntries1: TMenuItem
      Tag = 1
      Caption = '&All Entries'
      OnClick = AllEntries1Click
    end
    object UnmatchedEntries1: TMenuItem
      Tag = 2
      Caption = '&Unmatched Entries'
      OnClick = AllEntries1Click
    end
    object MatchedEntries1: TMenuItem
      Tag = 3
      Caption = '&Matched Entries'
      OnClick = AllEntries1Click
    end
    object NewEntries1: TMenuItem
      Tag = 4
      Caption = '&New Entries'
      OnClick = AllEntries1Click
    end
  end
end
