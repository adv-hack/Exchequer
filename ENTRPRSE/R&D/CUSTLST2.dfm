object TradList: TTradList
  Left = -786
  Top = -63
  Width = 478
  Height = 377
  HelpContext = 62
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = False
  VertScrollBar.Tracking = True
  VertScrollBar.Visible = False
  Caption = 'Trader List'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
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
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 453
    Height = 334
    ActivePage = CustomerPage
    Images = ImageRepos.MulCtrlImages
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object CustomerPage: TTabSheet
      Caption = 'Customers'
      ImageIndex = -1
      object ScrolBox5: TScrollBox
        Left = -2
        Top = -1
        Width = 317
        Height = 307
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object TLCompPanel: TSBSPanel
          Left = 66
          Top = 23
          Width = 148
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAccPanel: TSBSPanel
          Left = 4
          Top = 23
          Width = 59
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLTelPanel: TSBSPanel
          Left = 324
          Top = 23
          Width = 106
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLBalPanel: TSBSPanel
          Left = 217
          Top = 23
          Width = 104
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object SBSPanel1: TSBSPanel
          Left = 2
          Top = 4
          Width = 1563
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object TLAccLab: TSBSPanel
            Left = 4
            Top = 3
            Width = 55
            Height = 14
            BevelOuter = bvNone
            Caption = 'A/C Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLCompLab: TSBSPanel
            Left = 66
            Top = 3
            Width = 144
            Height = 14
            BevelOuter = bvNone
            Caption = 'Company'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLBalLab: TSBSPanel
            Left = 217
            Top = 3
            Width = 99
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Balance'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLTelLab: TSBSPanel
            Left = 324
            Top = 3
            Width = 102
            Height = 14
            BevelOuter = bvNone
            Caption = 'Telephone'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLAddr1Lab: TSBSPanel
            Left = 433
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 1'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLAddr2Lab: TSBSPanel
            Left = 612
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 2'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLAddr3Lab: TSBSPanel
            Left = 791
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 3'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLAddr4Lab: TSBSPanel
            Left = 970
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 4'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLAddr5Lab: TSBSPanel
            Left = 1149
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 5'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLPCLab: TSBSPanel
            Left = 1328
            Top = 3
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'Post Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 9
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SBSEmail: TSBSPanel
            Left = 1415
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Email'
            Color = clWhite
            TabOrder = 10
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SBSStatus: TSBSPanel
            Left = 1488
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Status'
            Color = clWhite
            TabOrder = 11
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object TLAddr1Panel: TSBSPanel
          Left = 433
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAddr2Panel: TSBSPanel
          Left = 612
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAddr3Panel: TSBSPanel
          Left = 791
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAddr4Panel: TSBSPanel
          Left = 970
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAddr5Panel: TSBSPanel
          Left = 1149
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLPCPanel: TSBSPanel
          Left = 1328
          Top = 23
          Width = 85
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLEmailPanel: TSBSPanel
          Left = 1416
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLStatusPanel: TSBSPanel
          Left = 1489
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object Panel1: TSBSPanel
        Left = 340
        Top = 4
        Width = 103
        Height = 297
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Button13: TButton
          Left = 2
          Top = 20
          Width = 80
          Height = 21
          Hint = 'Close this window|Closes the current Trader list.'
          HelpContext = 24
          Cancel = True
          Caption = '&Close'
          ModalResult = 2
          TabOrder = 0
          OnClick = TLCloseBtnClick
        end
        object ScrolBox6: TScrollBox
          Left = 2
          Top = 77
          Width = 100
          Height = 220
          HorzScrollBar.Visible = False
          VertScrollBar.Position = 215
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          object TLCAddBtn: TButton
            Left = 0
            Top = -215
            Width = 80
            Height = 21
            Hint = 'Add a new record|Allows a new record to be added.'
            HelpContext = 76
            Caption = '&Add'
            TabOrder = 0
            OnClick = TLCAddBtnClick
          end
          object TLCEditBtn: TButton
            Left = 0
            Top = -192
            Width = 80
            Height = 21
            Hint = 
              'Edit current record|Allows the currently selected record to be e' +
              'dited.'
            HelpContext = 75
            Caption = '&Edit'
            TabOrder = 1
            OnClick = TLCAddBtnClick
          end
          object TLCFindBtn: TButton
            Left = 0
            Top = -169
            Width = 80
            Height = 21
            Hint = 'Find record.|Find a record using the ObjectFind window.'
            HelpContext = 72
            Caption = '&Find'
            TabOrder = 2
            OnClick = TLCFindBtnClick
          end
          object TLCDelBtn: TButton
            Left = 0
            Top = -146
            Width = 80
            Height = 21
            Hint = 'Delete record|Delete the currently selected record.'
            HelpContext = 77
            Caption = '&Delete'
            Enabled = False
            TabOrder = 3
            OnClick = TLCAddBtnClick
          end
          object TLCNoteBtn: TButton
            Left = 0
            Top = -54
            Width = 80
            Height = 21
            Hint = 
              'Display notepad|Displays the notepad for the currently selected ' +
              'record.'
            HelpContext = 80
            Caption = '&Notes'
            TabOrder = 7
            OnClick = TLCAddBtnClick
          end
          object TLCChkBtn: TButton
            Left = 0
            Top = 60
            Width = 80
            Height = 22
            Hint = 
              'Check current ledger|Recalculates all balances for the currently' +
              ' selected record. Also gives option to unallocate all transactio' +
              'ns within the ledger.'
            HelpContext = 84
            Caption = 'Chec&k'
            TabOrder = 12
            OnClick = TLCChkBtnClick
          end
          object TLCPrnBtn: TButton
            Left = 0
            Top = 38
            Width = 80
            Height = 21
            Hint = 
              'Print this record|Gives the option to print the currently select' +
              'ed record to screen or printer.'
            HelpContext = 82
            Caption = '&Print'
            TabOrder = 11
            OnClick = TLCPrnBtnClick
          end
          object TLCLedBtn: TButton
            Left = 0
            Top = -123
            Width = 80
            Height = 21
            Hint = 
              'Display Ledger|Displays the ledger screen for the currently sele' +
              'cted record.'
            HelpContext = 78
            Caption = '&Ledger'
            TabOrder = 4
            OnClick = TLCAddBtnClick
          end
          object TLCHistBtn: TButton
            Left = 0
            Top = -77
            Width = 80
            Height = 21
            Hint = 
              'Show History balances|Displays the trading history by period, or' +
              ' margin history for Customers.'
            HelpContext = 79
            Caption = '&History'
            TabOrder = 6
            OnClick = TLCHistBtnClick
          end
          object TLCLetrBtn: TButton
            Left = 0
            Top = -31
            Width = 80
            Height = 21
            Hint = 
              'Generate a Word document|Links to Word so that a new document ma' +
              'ybe produced, or an exisiting on changed for this account. '
            HelpContext = 81
            Caption = 'L&inks'
            TabOrder = 8
            OnClick = TLCLetrBtnClick
          end
          object TLCSABtn: TButton
            Tag = 20
            Left = 0
            Top = -8
            Width = 80
            Height = 21
            Hint = 
              'View Stock Analysis|Display a list of stock items purchased by t' +
              'his account'
            HelpContext = 810
            Caption = 'Stoc&k Analysis'
            TabOrder = 9
            OnClick = TLCSABtnClick
          end
          object TLCTSBtn: TButton
            Tag = 21
            Left = 0
            Top = 15
            Width = 80
            Height = 21
            Hint = 
              'Generate Sales Order|Alter the ledger display to show either all' +
              ' transactions, or outstanding only transactions.'
            HelpContext = 780
            Caption = '&TeleSales'
            TabOrder = 10
            OnClick = TLCSABtnClick
          end
          object CustCuBtn1: TSBSButton
            Tag = 1
            Left = 0
            Top = 84
            Width = 80
            Height = 21
            Caption = 'Custom1'
            TabOrder = 13
            OnClick = CustCuBtn1Click
            TextId = 1
          end
          object CustCuBtn2: TSBSButton
            Tag = 2
            Left = 0
            Top = 107
            Width = 80
            Height = 21
            Caption = 'Custom2'
            TabOrder = 14
            OnClick = CustCuBtn1Click
            TextId = 2
          end
          object TLCSortBtn: TButton
            Left = 0
            Top = -100
            Width = 80
            Height = 21
            Hint = 
              'Sort View options|Apply or change the column sorting for the lis' +
              't.'
            HelpContext = 8059
            Caption = 'Sort &View'
            TabOrder = 5
            OnClick = TLSSortBtnClick
          end
          object CustCuBtn3: TSBSButton
            Tag = 3
            Left = 0
            Top = 130
            Width = 80
            Height = 21
            Caption = 'Custom3'
            TabOrder = 15
            OnClick = CustCuBtn1Click
            TextId = 141
          end
          object CustCuBtn4: TSBSButton
            Tag = 4
            Left = 0
            Top = 153
            Width = 80
            Height = 21
            Caption = 'Custom4'
            TabOrder = 16
            OnClick = CustCuBtn1Click
            TextId = 142
          end
          object CustCuBtn5: TSBSButton
            Tag = 5
            Left = 0
            Top = 176
            Width = 80
            Height = 21
            Caption = 'Custom5'
            TabOrder = 17
            OnClick = CustCuBtn1Click
            TextId = 143
          end
          object CustCuBtn6: TSBSButton
            Tag = 6
            Left = 0
            Top = 199
            Width = 80
            Height = 21
            Caption = 'Custom6'
            TabOrder = 18
            OnClick = CustCuBtn1Click
            TextId = 144
          end
        end
      end
      object panCustUpDown: TSBSPanel
        Left = 316
        Top = 23
        Width = 18
        Height = 266
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object ConsumerPage: TTabSheet
      HelpContext = 8097
      Caption = 'Consumers'
      ImageIndex = -1
      object ConsumerListScrollBox: TScrollBox
        Left = -2
        Top = -2
        Width = 317
        Height = 307
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object ConsumerListCompanyPanel: TSBSPanel
          Left = 118
          Top = 23
          Width = 148
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListCodePanel: TSBSPanel
          Left = 4
          Top = 23
          Width = 111
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListTelephonePanel: TSBSPanel
          Left = 376
          Top = 23
          Width = 106
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListBalancePanel: TSBSPanel
          Left = 269
          Top = 23
          Width = 104
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListHeaderPanel: TSBSPanel
          Left = 2
          Top = 4
          Width = 1609
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object ConsumerListCodeLabel: TSBSPanel
            Left = 4
            Top = 3
            Width = 109
            Height = 14
            BevelOuter = bvNone
            Caption = 'A/C Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListCompanyLabel: TSBSPanel
            Left = 112
            Top = 3
            Width = 153
            Height = 14
            BevelOuter = bvNone
            Caption = 'Name'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListBalanceLabel: TSBSPanel
            Left = 261
            Top = 3
            Width = 108
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Balance'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListTelephoneLabel: TSBSPanel
            Left = 368
            Top = 3
            Width = 102
            Height = 14
            BevelOuter = bvNone
            Caption = 'Telephone'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListAddressLine1Label: TSBSPanel
            Left = 477
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 1'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListAddressLine2Label: TSBSPanel
            Left = 656
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 2'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListAddressLine3Label: TSBSPanel
            Left = 835
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 3'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListAddressLine4Label: TSBSPanel
            Left = 1014
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 4'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListAddressLine5Label: TSBSPanel
            Left = 1193
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 5'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListPostCodeLabel: TSBSPanel
            Left = 1372
            Top = 3
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'Post Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 9
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListEmailLabel: TSBSPanel
            Left = 1459
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Email'
            Color = clWhite
            TabOrder = 10
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object ConsumerListStatusLabel: TSBSPanel
            Left = 1532
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Status'
            Color = clWhite
            TabOrder = 11
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object ConsumerListAddressLine1Panel: TSBSPanel
          Left = 485
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListAddressLine2Panel: TSBSPanel
          Left = 664
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListAddressLine3Panel: TSBSPanel
          Left = 843
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListAddressLine4Panel: TSBSPanel
          Left = 1022
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListAddressLine5Panel: TSBSPanel
          Left = 1201
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListPostCodePanel: TSBSPanel
          Left = 1380
          Top = 23
          Width = 85
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListEmailPanel: TSBSPanel
          Left = 1468
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object ConsumerListStatusPanel: TSBSPanel
          Left = 1541
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object ConsumerListScrollBar: TSBSPanel
        Left = 316
        Top = 23
        Width = 18
        Height = 266
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object ConsumerListButtonPanel: TSBSPanel
        Left = 340
        Top = 4
        Width = 103
        Height = 297
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object ConsumerListCloseButton: TButton
          Left = 2
          Top = 20
          Width = 80
          Height = 21
          Hint = 'Close this window|Closes the current Trader list.'
          HelpContext = 24
          Cancel = True
          Caption = '&Close'
          ModalResult = 2
          TabOrder = 0
          OnClick = TLCloseBtnClick
        end
        object ConsumerListButtonBox: TScrollBox
          Left = 2
          Top = 77
          Width = 100
          Height = 220
          HorzScrollBar.Visible = False
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          object ConsumerListAddButton: TButton
            Left = 0
            Top = 0
            Width = 80
            Height = 21
            Hint = 'Add a new record|Allows a new record to be added.'
            HelpContext = 76
            Caption = '&Add'
            TabOrder = 0
            OnClick = TLCAddBtnClick
          end
          object ConsumerListEditButton: TButton
            Left = 0
            Top = 23
            Width = 80
            Height = 21
            Hint = 
              'Edit current record|Allows the currently selected record to be e' +
              'dited.'
            HelpContext = 75
            Caption = '&Edit'
            TabOrder = 1
            OnClick = TLCAddBtnClick
          end
          object ConsumerListFindButton: TButton
            Left = 0
            Top = 46
            Width = 80
            Height = 21
            Hint = 'Find record.|Find a record using the ObjectFind window.'
            HelpContext = 72
            Caption = '&Find'
            TabOrder = 2
            OnClick = TLCFindBtnClick
          end
          object ConsumerListDeleteButton: TButton
            Left = 0
            Top = 69
            Width = 80
            Height = 21
            Hint = 'Delete record|Delete the currently selected record.'
            HelpContext = 77
            Caption = '&Delete'
            Enabled = False
            TabOrder = 3
            OnClick = TLCAddBtnClick
          end
          object ConsumerListNotesButton: TButton
            Left = 0
            Top = 161
            Width = 80
            Height = 21
            Hint = 
              'Display notepad|Displays the notepad for the currently selected ' +
              'record.'
            HelpContext = 80
            Caption = '&Notes'
            TabOrder = 7
            OnClick = TLCAddBtnClick
          end
          object ConsumerListCheckButton: TButton
            Left = 0
            Top = 275
            Width = 80
            Height = 22
            Hint = 
              'Check current ledger|Recalculates all balances for the currently' +
              ' selected record. Also gives option to unallocate all transactio' +
              'ns within the ledger.'
            HelpContext = 84
            Caption = 'Chec&k'
            TabOrder = 12
            OnClick = TLCChkBtnClick
          end
          object ConsumerListPrintButton: TButton
            Left = 0
            Top = 253
            Width = 80
            Height = 21
            Hint = 
              'Print this record|Gives the option to print the currently select' +
              'ed record to screen or printer.'
            HelpContext = 82
            Caption = '&Print'
            TabOrder = 11
            OnClick = TLCPrnBtnClick
          end
          object ConsumerListLedgerButton: TButton
            Left = 0
            Top = 92
            Width = 80
            Height = 21
            Hint = 
              'Display Ledger|Displays the ledger screen for the currently sele' +
              'cted record.'
            HelpContext = 78
            Caption = '&Ledger'
            TabOrder = 4
            OnClick = TLCAddBtnClick
          end
          object ConsumerListHistoryButton: TButton
            Left = 0
            Top = 138
            Width = 80
            Height = 21
            Hint = 
              'Show History balances|Displays the trading history by period, or' +
              ' margin history for Customers.'
            HelpContext = 79
            Caption = '&History'
            TabOrder = 6
            OnClick = TLCHistBtnClick
          end
          object ConsumerListLinksButton: TButton
            Left = 0
            Top = 184
            Width = 80
            Height = 21
            Hint = 
              'Generate a Word document|Links to Word so that a new document ma' +
              'ybe produced, or an exisiting on changed for this account. '
            HelpContext = 81
            Caption = 'L&inks'
            TabOrder = 8
            OnClick = TLCLetrBtnClick
          end
          object ConsumerListStockAnalysisButton: TButton
            Tag = 20
            Left = 0
            Top = 207
            Width = 80
            Height = 21
            Hint = 
              'View Stock Analysis|Display a list of stock items purchased by t' +
              'his account'
            HelpContext = 810
            Caption = 'Stoc&k Analysis'
            TabOrder = 9
            OnClick = TLCSABtnClick
          end
          object ConsumerListTeleSalesButton: TButton
            Tag = 21
            Left = 0
            Top = 230
            Width = 80
            Height = 21
            Hint = 
              'Generate Sales Order|Alter the ledger display to show either all' +
              ' transactions, or outstanding only transactions.'
            HelpContext = 780
            Caption = '&TeleSales'
            TabOrder = 10
            OnClick = TLCSABtnClick
          end
          object ConsumerListCustomButton1: TSBSButton
            Tag = 1
            Left = 0
            Top = 299
            Width = 80
            Height = 21
            Caption = 'Custom1'
            TabOrder = 13
            OnClick = CustCuBtn1Click
            TextId = 1
          end
          object ConsumerListCustomButton2: TSBSButton
            Tag = 2
            Left = 0
            Top = 322
            Width = 80
            Height = 21
            Caption = 'Custom2'
            TabOrder = 14
            OnClick = CustCuBtn1Click
            TextId = 2
          end
          object ConsumerListSortViewButton: TButton
            Left = 0
            Top = 115
            Width = 80
            Height = 21
            Hint = 
              'Sort View options|Apply or change the column sorting for the lis' +
              't.'
            HelpContext = 8059
            Caption = 'Sort &View'
            TabOrder = 5
            OnClick = TLSSortBtnClick
          end
          object ConsumerListCustomButton3: TSBSButton
            Tag = 3
            Left = 0
            Top = 345
            Width = 80
            Height = 21
            Caption = 'Custom3'
            TabOrder = 15
            OnClick = CustCuBtn1Click
            TextId = 141
          end
          object ConsumerListCustomButton4: TSBSButton
            Tag = 4
            Left = 0
            Top = 368
            Width = 80
            Height = 21
            Caption = 'Custom4'
            TabOrder = 16
            OnClick = CustCuBtn1Click
            TextId = 142
          end
          object ConsumerListCustomButton5: TSBSButton
            Tag = 5
            Left = 0
            Top = 391
            Width = 80
            Height = 21
            Caption = 'Custom5'
            TabOrder = 17
            OnClick = CustCuBtn1Click
            TextId = 143
          end
          object ConsumerListCustomButton6: TSBSButton
            Tag = 6
            Left = 0
            Top = 414
            Width = 80
            Height = 21
            Caption = 'Custom6'
            TabOrder = 18
            OnClick = CustCuBtn1Click
            TextId = 144
          end
        end
      end
    end
    object SupplierPage: TTabSheet
      Caption = 'Suppliers'
      ImageIndex = -1
      object TLSScrollBox: TScrollBox
        Left = -2
        Top = -1
        Width = 317
        Height = 307
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object TLSCompPanel: TSBSPanel
          Left = 66
          Top = 23
          Width = 148
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSAccPanel: TSBSPanel
          Left = 4
          Top = 23
          Width = 59
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSTelPanel: TSBSPanel
          Left = 324
          Top = 23
          Width = 106
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSBalPanel: TSBSPanel
          Left = 217
          Top = 23
          Width = 104
          Height = 265
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
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLHedPanel: TSBSPanel
          Left = 2
          Top = 4
          Width = 1561
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object TLSAccLab: TSBSPanel
            Left = 4
            Top = 3
            Width = 55
            Height = 14
            BevelOuter = bvNone
            Caption = 'A/C Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSCompLab: TSBSPanel
            Left = 66
            Top = 3
            Width = 144
            Height = 14
            BevelOuter = bvNone
            Caption = 'Company'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSBalLab: TSBSPanel
            Left = 217
            Top = 3
            Width = 99
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Balance'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSTelLab: TSBSPanel
            Left = 324
            Top = 3
            Width = 102
            Height = 14
            BevelOuter = bvNone
            Caption = 'Telephone'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSAdd1Lab: TSBSPanel
            Left = 433
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 1'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSAdd2Lab: TSBSPanel
            Left = 612
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 2'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSAdd3Lab: TSBSPanel
            Left = 791
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 3'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 6
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSAdd4Lab: TSBSPanel
            Left = 970
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 4'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 7
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSAdd5Lab: TSBSPanel
            Left = 1149
            Top = 3
            Width = 172
            Height = 14
            BevelOuter = bvNone
            Caption = 'Address Line 5'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 8
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object TLSPCLab: TSBSPanel
            Left = 1328
            Top = 3
            Width = 81
            Height = 14
            BevelOuter = bvNone
            Caption = 'Post Code'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 9
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SBSSEmail: TSBSPanel
            Left = 1415
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Email'
            Color = clWhite
            TabOrder = 10
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object SBSSStatus: TSBSPanel
            Left = 1487
            Top = 3
            Width = 66
            Height = 14
            BevelOuter = bvNone
            Caption = 'Status'
            Color = clWhite
            TabOrder = 11
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object TLSAdd1Pan: TSBSPanel
          Left = 433
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSAdd2Pan: TSBSPanel
          Left = 612
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSAdd3Pan: TSBSPanel
          Left = 791
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSAdd4Pan: TSBSPanel
          Left = 970
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSAdd5Pan: TSBSPanel
          Left = 1149
          Top = 23
          Width = 176
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSPCPanel: TSBSPanel
          Left = 1328
          Top = 23
          Width = 85
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSEmailPanel: TSBSPanel
          Left = 1416
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLSStatusPanel: TSBSPanel
          Left = 1489
          Top = 23
          Width = 70
          Height = 265
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object TPSCtrlPanel: TSBSPanel
        Left = 340
        Top = 4
        Width = 103
        Height = 297
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Button1: TButton
          Left = 2
          Top = 20
          Width = 80
          Height = 21
          HelpContext = 24
          Cancel = True
          Caption = '&Close'
          ModalResult = 2
          TabOrder = 0
          OnClick = TLCloseBtnClick
        end
        object TPSScrollBox: TScrollBox
          Left = 2
          Top = 77
          Width = 100
          Height = 220
          HorzScrollBar.Visible = False
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          object TLSAddBtn: TButton
            Left = 0
            Top = 0
            Width = 80
            Height = 21
            Hint = 'Add a new record|Allows a new record to be added.'
            HelpContext = 76
            Caption = '&Add'
            TabOrder = 0
            OnClick = TLCAddBtnClick
          end
          object TLSEditBtn: TButton
            Left = 0
            Top = 23
            Width = 80
            Height = 21
            Hint = 
              'Edit current record|Allows the currently selected record to be e' +
              'dited.'
            HelpContext = 75
            Caption = '&Edit'
            TabOrder = 1
            OnClick = TLCAddBtnClick
          end
          object TLSFindBtn: TButton
            Left = 0
            Top = 46
            Width = 80
            Height = 21
            Hint = 'Find record.|Find a record using the ObjectFind window.'
            HelpContext = 72
            Caption = '&Find'
            TabOrder = 2
            OnClick = TLCFindBtnClick
          end
          object TLSDelBtn: TButton
            Left = 0
            Top = 69
            Width = 80
            Height = 21
            Hint = 'Delete record|Delete the currently selected record.'
            HelpContext = 77
            Caption = '&Delete'
            Enabled = False
            TabOrder = 3
            OnClick = TLCAddBtnClick
          end
          object TLSNoteBtn: TButton
            Left = 0
            Top = 161
            Width = 80
            Height = 21
            Hint = 
              'Display notepad|Displays the notepad for the currently selected ' +
              'record.'
            HelpContext = 80
            Caption = '&Notes'
            TabOrder = 7
            OnClick = TLCAddBtnClick
          end
          object TLSChkBtn: TButton
            Left = 0
            Top = 276
            Width = 80
            Height = 21
            Hint = 
              'Check current ledger|Recalculates all balances for the currently' +
              ' selected record. Also gives option to unallocate all transactio' +
              'ns within the ledger.'
            HelpContext = 84
            Caption = '&Check'
            TabOrder = 12
            OnClick = TLCChkBtnClick
          end
          object TLSPrnBtn: TButton
            Left = 0
            Top = 253
            Width = 80
            Height = 21
            Hint = 
              'Print this record|Gives the option to print the currently select' +
              'ed record to screen or printer.'
            HelpContext = 82
            Caption = '&Print'
            TabOrder = 11
            OnClick = TLCPrnBtnClick
          end
          object TLSLedBtn: TButton
            Left = 0
            Top = 92
            Width = 80
            Height = 21
            Hint = 
              'Display Ledger|Displays the ledger screen for the currently sele' +
              'cted record.'
            HelpContext = 78
            Caption = '&Ledger'
            TabOrder = 4
            OnClick = TLCAddBtnClick
          end
          object TLSHistBtn: TButton
            Left = 0
            Top = 138
            Width = 80
            Height = 21
            Hint = 
              'Show History balances|Displays the trading history by period, or' +
              ' margin history for Customers.'
            HelpContext = 79
            Caption = '&History'
            TabOrder = 6
            OnClick = TLCHistBtnClick
          end
          object TLSLetrBtn: TButton
            Left = 0
            Top = 184
            Width = 80
            Height = 21
            Hint = 
              'Generate a Word document|Links to Word so that a new document ma' +
              'ybe produced, or an exisiting on changed for this account. '
            HelpContext = 81
            Caption = 'L&inks'
            TabOrder = 8
            OnClick = TLCLetrBtnClick
          end
          object TLSSABtn: TButton
            Tag = 20
            Left = 0
            Top = 207
            Width = 80
            Height = 21
            Hint = 
              'View Stock Analysis|Display a list of stock items purchased by t' +
              'his account'
            HelpContext = 462
            Caption = 'Stoc&k Analysis'
            TabOrder = 9
            OnClick = TLCSABtnClick
          end
          object TLSTSBtn: TButton
            Tag = 21
            Left = 0
            Top = 230
            Width = 80
            Height = 21
            Hint = 
              'Generate Sales Order|Alter the ledger display to show either all' +
              ' transactions, or outstanding only transactions.'
            HelpContext = 462
            Caption = '&TeleSales'
            TabOrder = 10
            OnClick = TLCSABtnClick
          end
          object CustSuBtn1: TSBSButton
            Tag = 1
            Left = 0
            Top = 299
            Width = 80
            Height = 21
            Caption = 'Custom1'
            TabOrder = 13
            OnClick = CustCuBtn1Click
            TextId = 3
          end
          object CustSuBtn2: TSBSButton
            Tag = 2
            Left = 0
            Top = 322
            Width = 80
            Height = 21
            Caption = 'Custom2'
            TabOrder = 14
            OnClick = CustCuBtn1Click
            TextId = 4
          end
          object TLSSortBtn: TButton
            Left = 0
            Top = 115
            Width = 80
            Height = 21
            Hint = 
              'Sort View options|Apply or change the column sorting for the lis' +
              't.'
            HelpContext = 8059
            Caption = 'Sort &View'
            TabOrder = 5
            OnClick = TLSSortBtnClick
          end
          object CustSuBtn3: TSBSButton
            Tag = 3
            Left = 0
            Top = 345
            Width = 80
            Height = 21
            Caption = 'Custom3'
            TabOrder = 15
            OnClick = CustCuBtn1Click
            TextId = 151
          end
          object CustSuBtn4: TSBSButton
            Tag = 4
            Left = 0
            Top = 368
            Width = 80
            Height = 21
            Caption = 'Custom4'
            TabOrder = 16
            OnClick = CustCuBtn1Click
            TextId = 152
          end
          object CustSuBtn5: TSBSButton
            Tag = 5
            Left = 0
            Top = 391
            Width = 80
            Height = 21
            Caption = 'Custom5'
            TabOrder = 17
            OnClick = CustCuBtn1Click
            TextId = 153
          end
          object CustSuBtn6: TSBSButton
            Tag = 6
            Left = 0
            Top = 414
            Width = 80
            Height = 21
            Caption = 'Custom6'
            TabOrder = 18
            OnClick = CustCuBtn1Click
            TextId = 154
          end
        end
      end
      object TLSCtrlPanel: TSBSPanel
        Left = 316
        Top = 23
        Width = 18
        Height = 266
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 16
    Top = 60
    object Add1: TMenuItem
      Caption = '&Add'
      HelpContext = 76
      Hint = 'Allows a new record to be added.'
      OnClick = TLCAddBtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      HelpContext = 75
      Hint = 'Allows the currently selected record to be edited.'
      Visible = False
      OnClick = TLCAddBtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      HelpContext = 72
      Hint = 'Find a record using the ObjectFind window.'
    end
    object Delete1: TMenuItem
      Tag = 1
      Caption = '&Delete'
      HelpContext = 77
      Hint = 'Delete the currently selected record.'
      Visible = False
      OnClick = TLCAddBtnClick
    end
    object Ledger1: TMenuItem
      Tag = 1
      Caption = '&Ledger'
      HelpContext = 78
      Hint = 'Displays the ledger screen for the currently selected record.'
      Visible = False
      OnClick = TLCAddBtnClick
    end
    object SortView1: TMenuItem
      Caption = 'Sort &View'
      object RefreshView2: TMenuItem
        Caption = 'Refresh View'
        OnClick = RefreshView1Click
      end
      object CloseView2: TMenuItem
        Caption = 'Close View'
        OnClick = CloseView1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object SortViewOptions2: TMenuItem
        Caption = 'Sort View Options'
        OnClick = SortViewOptions1Click
      end
    end
    object Hist1: TMenuItem
      Caption = '&History'
      HelpContext = 79
      Hint = 
        'Displays the trading history by period, or margin history for Cu' +
        'stomers.'
      OnClick = TLCHistBtnClick
    end
    object Notes1: TMenuItem
      Tag = 1
      Caption = '&Notes'
      HelpContext = 80
      Hint = 'Displays the notepad for the currently selected record.'
      Visible = False
      OnClick = TLCAddBtnClick
    end
    object Letters1: TMenuItem
      Caption = 'L&inks'
      HelpContext = 81
      Hint = 
        'Links to Word so that a new document maybe produced, or an exisi' +
        'ting on changed for this account. '
      OnClick = TLCLetrBtnClick
    end
    object StkAnal1: TMenuItem
      Tag = 20
      Caption = 'Stoc&k Analysis'
      Hint = 'Display a list of stock items purchased by this account'
      OnClick = TLCSABtnClick
    end
    object TeleSales1: TMenuItem
      Tag = 21
      Caption = '&TeleSales'
      Hint = 
        'Generate an order, invoice, or quotation for this account, using' +
        ' the Stock Analysis list.'
      OnClick = TLCSABtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      HelpContext = 82
      Hint = 
        'Gives the option to print the currently selected record to scree' +
        'n or printer.'
      OnClick = TLCPrnBtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      HelpContext = 84
      Hint = 
        'Recalculates all balances for the currently selected record. Als' +
        'o gives option to unallocate all transactions within the ledger.'
      OnClick = TLCChkBtnClick
    end
    object Custom1: TMenuItem
      Tag = 1
      Caption = '&Custom Btn 1'
      OnClick = CustCuBtn1Click
    end
    object Custom2: TMenuItem
      Tag = 2
      Caption = '&Custom Btn 2'
      OnClick = CustCuBtn1Click
    end
    object Custom3: TMenuItem
      Tag = 3
      Caption = 'Custom Btn 3'
      OnClick = CustCuBtn1Click
    end
    object Custom4: TMenuItem
      Tag = 4
      Caption = 'Custom Btn 4'
      OnClick = CustCuBtn1Click
    end
    object Custom5: TMenuItem
      Tag = 5
      Caption = 'Custom Btn 5'
      OnClick = CustCuBtn1Click
    end
    object Custom6: TMenuItem
      Tag = 6
      Caption = 'Custom Btn 6'
      OnClick = CustCuBtn1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 44
    Top = 60
    object Bal1: TMenuItem
      Tag = 1
      Caption = '&Balances'
      HelpContext = 79
      Hint = 
        'Shows the balance history by period for the currently selected r' +
        'ecord.'
      OnClick = Bal1Click
    end
    object Profit1: TMenuItem
      Tag = 3
      Caption = '&Profitability'
      HelpContext = 79
      Hint = 
        'Shows the profitablilty history by period for the currently sele' +
        'cted record.'
      OnClick = Bal1Click
    end
  end
  object EntCustom2: TCustomisation
    DLLId = SysDll_Ent
    Enabled = True
    ExportPath = 'c:\mh.RC'
    WindowId = 101000
    Left = 128
    Top = 60
  end
  object PopupMenu3: TPopupMenu
    Left = 72
    Top = 60
    object FindAc1: TMenuItem
      Caption = '&Find Account Code'
      HelpContext = 79
      Hint = 
        'Shows the balance history by period for the currently selected r' +
        'ecord.'
      OnClick = FindAc1Click
    end
    object MenuItem2: TMenuItem
      Tag = 3
      Caption = '-'
      HelpContext = 79
      Hint = 
        'Shows the profitablilty history by period for the currently sele' +
        'cted record.'
      OnClick = Bal1Click
    end
    object FiltBal1: TMenuItem
      Tag = 1
      Caption = 'Filter on &Balance'
      OnClick = FindAc1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object FiltBal2: TMenuItem
      Tag = 2
      Caption = '&No Filter'
      OnClick = FindAc1Click
    end
  end
  object SortViewPopupMenu: TPopupMenu
    Left = 100
    Top = 60
    object RefreshView1: TMenuItem
      Caption = '&Refresh View'
      OnClick = RefreshView1Click
    end
    object CloseView1: TMenuItem
      Caption = '&Close View'
      OnClick = CloseView1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object SortViewOptions1: TMenuItem
      Caption = 'Sort View &Options'
      OnClick = SortViewOptions1Click
    end
  end
  object SQLDatasets1: TSQLDatasets
    UseWindowsAuthentication = False
    Left = 225
    Top = 174
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 104
    Top = 138
  end
end
