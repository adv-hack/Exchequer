object EmplList: TEmplList
  Left = 340
  Top = 148
  Width = 592
  Height = 372
  HelpContext = 952
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  Caption = 'Employee/Sub-contractor List'
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
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 3
    Top = 4
    Width = 580
    Height = 334
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object TabSheet1: TTabSheet
      Caption = 'Employees/Sub Contractors'
      object ScrolBox5: TScrollBox
        Left = -2
        Top = -1
        Width = 441
        Height = 307
        VertScrollBar.Visible = False
        BorderStyle = bsNone
        TabOrder = 0
        object TLCompPanel: TSBSPanel
          Left = 65
          Top = 24
          Width = 128
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
          TabOrder = 0
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLAccPanel: TSBSPanel
          Left = 4
          Top = 24
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
          Left = 318
          Top = 24
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
          TabOrder = 2
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object TLBalPanel: TSBSPanel
          Left = 195
          Top = 24
          Width = 120
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
          Width = 503
          Height = 19
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 4
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object TLAccLab: TSBSPanel
            Left = 3
            Top = 3
            Width = 59
            Height = 14
            BevelOuter = bvNone
            Caption = 'Emp/SC'
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
            Left = 62
            Top = 3
            Width = 128
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
          object TLBalLab: TSBSPanel
            Left = 193
            Top = 3
            Width = 120
            Height = 14
            BevelOuter = bvNone
            Caption = 'Supplier'
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
            Left = 317
            Top = 3
            Width = 102
            Height = 14
            BevelOuter = bvNone
            Caption = 'Type'
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
          object TLStatusLab: TSBSPanel
            Left = 422
            Top = 3
            Width = 65
            Height = 14
            BevelOuter = bvNone
            Caption = 'Status'
            Color = clWhite
            TabOrder = 4
            OnMouseDown = TLAccLabMouseDown
            OnMouseMove = TLAccLabMouseMove
            OnMouseUp = TLAccPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object TLStatusPanel: TSBSPanel
          Left = 427
          Top = 24
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
          TabOrder = 5
          OnMouseUp = TLAccPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object Panel1: TSBSPanel
        Left = 439
        Top = 3
        Width = 123
        Height = 303
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object SBSPanel14: TSBSPanel
          Left = 0
          Top = 20
          Width = 18
          Height = 266
          BevelOuter = bvLowered
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object Button13: TButton
          Left = 22
          Top = 20
          Width = 80
          Height = 21
          Hint = 'Close this window|Closes the current Trader list.'
          HelpContext = 728
          Cancel = True
          Caption = '&Close'
          ModalResult = 2
          TabOrder = 1
          OnClick = TLCloseBtnClick
        end
        object ScrolBox6: TScrollBox
          Left = 22
          Top = 82
          Width = 100
          Height = 220
          HorzScrollBar.Visible = False
          BorderStyle = bsNone
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          object TLCAddBtn: TButton
            Left = 0
            Top = 3
            Width = 80
            Height = 21
            Hint = 'Add a new record|Allows a new record to be added.'
            HelpContext = 1082
            Caption = '&Add'
            TabOrder = 0
            OnClick = TLCAddBtnClick
          end
          object TLCEditBtn: TButton
            Left = 0
            Top = 27
            Width = 80
            Height = 21
            Hint = 
              'Edit current record|Allows the currently selected record to be e' +
              'dited.'
            HelpContext = 1082
            Caption = '&Edit'
            TabOrder = 1
            OnClick = TLCAddBtnClick
          end
          object TLCFindBtn: TButton
            Left = 0
            Top = 51
            Width = 80
            Height = 21
            Hint = 'Find record.|Find a record using the ObjectFind window.'
            HelpContext = 1093
            Caption = '&Find'
            TabOrder = 2
            OnClick = TLCFindBtnClick
          end
          object TLCDelBtn: TButton
            Left = 0
            Top = 75
            Width = 80
            Height = 21
            Hint = 'Delete record|Delete the currently selected record.'
            HelpContext = 1097
            Caption = '&Delete'
            Enabled = False
            TabOrder = 3
            OnClick = TLCAddBtnClick
          end
          object TLCNoteBtn: TButton
            Left = 0
            Top = 145
            Width = 80
            Height = 21
            Hint = 
              'Display notepad|Displays the notepad for the currently selected ' +
              'record.'
            HelpContext = 844
            Caption = '&Notes'
            TabOrder = 6
            OnClick = TLCAddBtnClick
          end
          object TLCChkBtn: TButton
            Left = 0
            Top = 193
            Width = 80
            Height = 21
            Hint = 
              'Access global time rates|Allows default time rates to be setup f' +
              'or all employees.'
            HelpContext = 924
            Caption = '&Global Rates'
            TabOrder = 8
            OnClick = TLCAddBtnClick
          end
          object TLCPrnBtn: TButton
            Left = 0
            Top = 241
            Width = 80
            Height = 21
            Hint = 
              'Print this record|Gives the option to print the currently select' +
              'ed record to screen or printer.'
            HelpContext = 82
            Caption = '&Print'
            TabOrder = 10
          end
          object TLCLedBtn: TButton
            Left = 0
            Top = 99
            Width = 80
            Height = 21
            Hint = 
              'Display Ledger|Displays the ledger screen for the currently sele' +
              'cted record.'
            HelpContext = 1098
            Caption = '&Ledger'
            TabOrder = 4
            OnClick = TLCAddBtnClick
          end
          object TLCHistBtn: TButton
            Left = 0
            Top = 122
            Width = 80
            Height = 21
            Hint = 
              'Show History balances|Displays the trading history by period, or' +
              ' margin history for Customers.'
            HelpContext = 1096
            Caption = '&History'
            TabOrder = 5
            OnClick = TLCHistBtnClick
          end
          object TLCLetrBtn: TButton
            Left = 0
            Top = 265
            Width = 80
            Height = 21
            Hint = 
              'Generate a Word document|Links to Word so that a new document ma' +
              'ybe produced, or an exisiting on changed for this account. '
            HelpContext = 81
            Caption = 'L&inks'
            TabOrder = 11
            OnClick = TLCLetrBtnClick
          end
          object TLCSABtn: TButton
            Tag = 20
            Left = 0
            Top = 217
            Width = 80
            Height = 21
            Hint = 
              'Change the list order|Allows the employee list to be sorted by c' +
              'ode, surnname, or sub contract employees.'
            HelpContext = 1099
            Caption = '&Sort'
            TabOrder = 9
            OnClick = TLCSABtnClick
          end
          object TLCTSBtn: TButton
            Tag = 21
            Left = 0
            Top = 169
            Width = 80
            Height = 21
            Hint = 
              'Access time rates|Allows unique time rates to be setup for this ' +
              'employee.'
            HelpContext = 953
            Caption = 'Empl &Rates'
            TabOrder = 7
            OnClick = TLCAddBtnClick
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Sales Leads'
      Enabled = False
      TabVisible = False
    end
    object TabSheet4: TTabSheet
      Caption = 'Other Contacts'
      TabVisible = False
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 494
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
      OnClick = TLCFindBtnClick
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
    object Rate1: TMenuItem
      Caption = 'Employee &Rates'
      Hint = 
        'Access time rates|Allows unique time rates to be setup for this ' +
        'employee.'
      OnClick = TLCAddBtnClick
    end
    object Rate2: TMenuItem
      Caption = '&Global Rates'
      Hint = 
        'Access global time rates|Allows default time rates to be setup f' +
        'or all employees.'
      OnClick = TLCAddBtnClick
    end
    object StkAnal1: TMenuItem
      Tag = 20
      Caption = '&Sort'
      Hint = 
        'Allows the employee list to be sorted by code, surnname, or sub ' +
        'contract employees.'
      OnClick = TLCSABtnClick
    end
    object Print1: TMenuItem
      Caption = '&Print'
      HelpContext = 82
      Hint = 
        'Gives the option to print the currently selected record to scree' +
        'n or printer.'
    end
    object Leters1: TMenuItem
      Caption = 'L&inks'
      HelpContext = 81
      Hint = 
        'Links to Word so that a new document maybe produced, or an exisi' +
        'ting on changed for this account. '
      OnClick = TLCLetrBtnClick
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
    Left = 477
    object SEC1: TMenuItem
      Caption = 'by Employee &Code'
      HelpContext = 79
      OnClick = SEC1Click
    end
    object SES1: TMenuItem
      Tag = 1
      Caption = 'by Employee &Surname'
      HelpContext = 79
      OnClick = SEC1Click
    end
    object SES2: TMenuItem
      Tag = 2
      Caption = 'by Employee S&ubcontract'
      OnClick = SEC1Click
    end
  end
  object WindowExport: TWindowExport
    OnEnableExport = WindowExportEnableExport
    OnExecuteCommand = WindowExportExecuteCommand
    OnGetExportDescription = WindowExportGetExportDescription
    Left = 280
    Top = 176
  end
end
