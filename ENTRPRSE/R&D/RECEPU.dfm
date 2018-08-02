object RecepForm: TRecepForm
  Left = 461
  Top = 240
  Width = 643
  Height = 455
  HelpContext = 236
  VertScrollBar.Tracking = True
  Caption = 'Payment/Receipt'
  Color = clBtnFace
  Constraints.MinHeight = 385
  Constraints.MinWidth = 636
  Font.Charset = DEFAULT_CHARSET
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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 624
    Height = 347
    ActivePage = RecepPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object RecepPage: TTabSheet
      Caption = 'Receipt'
      object Label817: Label8
        Left = 381
        Top = 12
        Width = 38
        Height = 14
        Caption = 'Our Ref'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object R1SBox: TScrollBox
        Left = 2
        Top = 118
        Width = 493
        Height = 184
        HelpContext = 405
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object R1HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 599
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object R1NomLab: TSBSPanel
            Left = 1
            Top = 3
            Width = 53
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
          end
          object R1NomD2Lab: TSBSPanel
            Left = 54
            Top = 3
            Width = 102
            Height = 13
            BevelOuter = bvNone
            Caption = 'G/L Description'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1ChQLab: TSBSPanel
            Left = 156
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Cheque No.'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1PayLab: TSBSPanel
            Left = 245
            Top = 3
            Width = 86
            Height = 13
            BevelOuter = bvNone
            Caption = 'Amount'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1BaseLab: TSBSPanel
            Left = 334
            Top = 3
            Width = 87
            Height = 13
            BevelOuter = bvNone
            Caption = 'Base Equiv.'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1PayInLab: TSBSPanel
            Left = 422
            Top = 3
            Width = 85
            Height = 13
            BevelOuter = bvNone
            Caption = 'Pay-In Ref'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object R1ReconLab: TSBSPanel
            Left = 507
            Top = 4
            Width = 94
            Height = 13
            BevelOuter = bvNone
            Caption = 'Recon Date'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object R1PayPanel: TSBSPanel
          Left = 246
          Top = 22
          Width = 88
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1NomPanel: TSBSPanel
          Left = 2
          Top = 22
          Width = 54
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1NomD2Panel: TSBSPanel
          Left = 57
          Top = 22
          Width = 100
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1BasePanel: TSBSPanel
          Left = 335
          Top = 22
          Width = 89
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1ChqPanel: TSBSPanel
          Left = 158
          Top = 22
          Width = 87
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1PayInPanel: TSBSPanel
          Left = 425
          Top = 22
          Width = 87
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object R1ReconPanel: TSBSPanel
          Left = 513
          Top = 22
          Width = 87
          Height = 140
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object R1ListBtnPanel: TSBSPanel
        Left = 497
        Top = 141
        Width = 18
        Height = 141
        BevelOuter = bvLowered
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object StatusPnl: TSBSPanel
        Left = 0
        Top = 296
        Width = 616
        Height = 22
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object SBSPanel4: TSBSPanel
          Left = 274
          Top = 5
          Width = 179
          Height = 17
          HelpContext = 407
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object ReqdTit: Label8
            Left = 3
            Top = 2
            Width = 85
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Base Equiv Reqd:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object ReqdLab: Label8
            Left = 91
            Top = 2
            Width = 86
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object VarPanel: TSBSPanel
          Left = 121
          Top = 5
          Width = 150
          Height = 17
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object VarTit: Label8
            Left = 3
            Top = 2
            Width = 46
            Height = 14
            Caption = 'Variance:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object VarLab: Label8
            Left = 52
            Top = 2
            Width = 95
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object CCPanel: TSBSPanel
          Left = 0
          Top = 5
          Width = 118
          Height = 17
          HelpContext = 414
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object CCTit: Label8
            Left = 3
            Top = 2
            Width = 17
            Height = 14
            Caption = 'CC:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DepTit: Label8
            Left = 57
            Top = 2
            Width = 22
            Height = 14
            Caption = 'Dep:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object CCLab: Label8
            Left = 23
            Top = 2
            Width = 30
            Height = 14
            AutoSize = False
            Caption = 'AAA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
          object DepLab: Label8
            Left = 81
            Top = 2
            Width = 30
            Height = 14
            AutoSize = False
            Caption = 'AAA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
        object DiscPanel: TSBSPanel
          Left = 456
          Top = 5
          Width = 150
          Height = 17
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 3
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puFrame
          object Label81: Label8
            Left = 3
            Top = 2
            Width = 48
            Height = 14
            Caption = 'Discount :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DiscLab: Label8
            Left = 52
            Top = 2
            Width = 95
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TextId = 0
          end
        end
      end
      object R1OrefF: Text8Pt
        Left = 421
        Top = 7
        Width = 74
        Height = 22
        HelpContext = 142
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = 'SRC000080'
        TextId = 0
        ViaSBtn = False
      end
      object R1OpoF: Text8Pt
        Left = 498
        Top = 7
        Width = 71
        Height = 22
        HelpContext = 241
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        Text = 'Sally'
        TextId = 0
        ViaSBtn = False
      end
    end
    object NotesPage: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
      object TCNScrollBox: TScrollBox
        Left = 2
        Top = 118
        Width = 493
        Height = 201
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = 2
          Top = 3
          Width = 485
          Height = 16
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object NDateLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 65
            Height = 13
            BevelOuter = bvNone
            Caption = 'Date'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NDescLab: TSBSPanel
            Left = 67
            Top = 1
            Width = 345
            Height = 13
            BevelOuter = bvNone
            Caption = 'Notes'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object NUserLab: TSBSPanel
            Left = 417
            Top = 1
            Width = 65
            Height = 13
            BevelOuter = bvNone
            Caption = 'User'
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
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object NDatePanel: TSBSPanel
          Left = 2
          Top = 22
          Width = 66
          Height = 157
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NDescPanel: TSBSPanel
          Left = 70
          Top = 22
          Width = 344
          Height = 157
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object NUserPanel: TSBSPanel
          Left = 416
          Top = 22
          Width = 70
          Height = 157
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
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object TcNListBtnPanel: TSBSPanel
        Left = 497
        Top = 141
        Width = 18
        Height = 157
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object R1BtnPanel: TSBSPanel
    Left = 521
    Top = 129
    Width = 101
    Height = 197
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Shape1: TShape
      Left = 0
      Top = 0
      Width = 65
      Height = 65
      Pen.Style = psClear
      Visible = False
    end
    object I1StatLab: Label8
      Left = 9
      Top = 19
      Width = 84
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1BSBox: TScrollBox
      Left = 0
      Top = 83
      Width = 98
      Height = 111
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      PopupMenu = PopupMenu1
      TabOrder = 0
      object AddR1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the receipt/payment.'
        HelpContext = 260
        Caption = '&Add'
        Enabled = False
        TabOrder = 0
        OnClick = AddR1BtnClick
      end
      object EditR1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 261
        Caption = '&Edit'
        Enabled = False
        TabOrder = 1
        OnClick = AddR1BtnClick
      end
      object DelR1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Delete current line|Choosing this option allows you to delete th' +
          'e currently highlighted line.'
        HelpContext = 263
        Caption = '&Delete'
        Enabled = False
        TabOrder = 2
        OnClick = DelR1BtnClick
      end
      object InsR1Btn: TButton
        Left = 2
        Top = 73
        Width = 80
        Height = 21
        Hint = 
          'Insert new line|Choosing this option allows you to Insert a new ' +
          'line before the currently highlighted line.'
        HelpContext = 86
        Caption = '&Insert'
        TabOrder = 3
        OnClick = AddR1BtnClick
      end
      object SwiR1Btn: TButton
        Left = 2
        Top = 97
        Width = 80
        Height = 21
        Hint = 
          'Switch between alternative notepads|Switches the display of the ' +
          'notepad between dated notepad, & general notepad.'
        HelpContext = 90
        Caption = '&Switch To'
        TabOrder = 4
        OnClick = SwiR1BtnClick
      end
      object DefR1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Access default bank settings|Allows a default bank account to be' +
          ' used with all Receipt/Payments'
        HelpContext = 548
        Caption = 'Defa&ults'
        TabOrder = 5
        OnClick = DefR1BtnClick
      end
      object StatR1Btn: TButton
        Left = 2
        Top = 145
        Width = 80
        Height = 21
        Hint = 
          'Show Line cleared status|Alternates the last column to display t' +
          'he bank cleared status/pay-In reference of the currently highlig' +
          'hted line.'
        HelpContext = 408
        Caption = '&Status'
        TabOrder = 6
        OnClick = StatR1BtnClick
      end
      object LnkR1Btn: TButton
        Left = 2
        Top = 193
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 408
        Caption = 'Lin&ks'
        TabOrder = 8
        OnClick = LnkR1BtnClick
      end
      object chkI1Btn: TButton
        Left = 2
        Top = 169
        Width = 80
        Height = 21
        Hint = 
          'Recalculate total|Choosing this option will recalculate the tota' +
          'l in cases where the total does not agree with the sum of the in' +
          'dividual entries.'
        HelpContext = 1032
        Caption = 'Chec&k'
        Enabled = False
        TabOrder = 7
        OnClick = chkI1BtnClick
      end
      object PayR1Btn: TButton
        Left = 2
        Top = 217
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 1164
        Caption = '&Pay Details'
        TabOrder = 9
        OnClick = PayR1BtnClick
      end
    end
    object OkR1Btn: TButton
      Tag = 1
      Left = 2
      Top = 14
      Width = 80
      Height = 21
      HelpContext = 257
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 1
      OnClick = OkR1BtnClick
    end
    object CanR1Btn: TButton
      Tag = 1
      Left = 2
      Top = 37
      Width = 80
      Height = 21
      HelpContext = 258
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsR1BtnClick
    end
    object ClsR1Btn: TButton
      Left = 2
      Top = 61
      Width = 80
      Height = 21
      HelpContext = 259
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 3
      OnClick = ClsR1BtnClick
    end
  end
  object R1FPanel: TSBSPanel
    Left = 8
    Top = 29
    Width = 374
    Height = 112
    BevelInner = bvRaised
    BevelOuter = bvLowered
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 8
      Top = 62
      Width = 41
      Height = 14
      Caption = 'Date/Per'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label87: Label8
      Left = 5
      Top = 36
      Width = 43
      Height = 14
      Caption = 'Your Ref'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1CurrLab: Label8
      Left = 212
      Top = 10
      Width = 45
      Height = 14
      Caption = 'Currency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 220
      Top = 62
      Width = 37
      Height = 14
      Caption = 'Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1XRateLab: Label8
      Left = 205
      Top = 36
      Width = 52
      Height = 14
      Caption = 'Exch. Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1Base2Lab: Label8
      Left = 204
      Top = 89
      Width = 56
      Height = 14
      Caption = 'Base Equiv.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 5
      Top = 13
      Width = 43
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object R1TDateF: TEditDate
      Tag = 1
      Left = 50
      Top = 57
      Width = 74
      Height = 22
      HelpContext = 143
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnExit = R1TDateFExit
      Placement = cpAbove
    end
    object R1TPerF: TEditPeriod
      Tag = 1
      Left = 127
      Top = 57
      Width = 65
      Height = 22
      HelpContext = 239
      AutoSelect = False
      Color = clWhite
      EditMask = '00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 7
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = 'mmyyyy'
      Placement = cpAbove
      EPeriod = 1
      EYear = 1996
      ViewMask = '000/0000;0;'
      OnConvDate = R1TPerFConvDate
      OnShowPeriod = R1TPerFShowPeriod
    end
    object R1YrefF: Text8Pt
      Tag = 1
      Left = 50
      Top = 31
      Width = 142
      Height = 22
      HelpContext = 240
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      OnChange = R1YrefFChange
      OnExit = THUD1FExit
      TextId = 0
      ViaSBtn = False
      OnEntHookEvent = THUD1FEntHookEvent
    end
    object R1RValF: TCurrencyEdit
      Tag = 1
      Left = 263
      Top = 58
      Width = 106
      Height = 22
      HelpContext = 402
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.00')
      MaxLength = 12
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      WantReturns = False
      WordWrap = False
      OnExit = R1RValFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object R1XRateF: TCurrencyEdit
      Tag = 1
      Left = 263
      Top = 32
      Width = 106
      Height = 22
      HelpContext = 403
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      MaxLength = 8
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      WantReturns = False
      WordWrap = False
      OnEnter = R1XRateFEnter
      OnExit = R1XRateFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object R1CurrF: TSBSComboBox
      Tag = 1
      Left = 263
      Top = 6
      Width = 106
      Height = 22
      HelpContext = 242
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 5
      OnExit = R1CurrFExit
      ExtendedList = True
      MaxListWidth = 120
      ReadOnly = True
      Validate = True
    end
    object R1BaseF: TCurrencyEdit
      Left = 263
      Top = 84
      Width = 106
      Height = 22
      HelpContext = 404
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      WantReturns = False
      WordWrap = False
      OnEnter = R1BaseFEnter
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object R1AccF: Text8Pt
      Tag = 1
      Left = 50
      Top = 8
      Width = 143
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 238
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 47
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnDblClick = R1AddrFDblClick
      OnEnter = R1AccFEnter
      OnExit = R1AccFExit
      TextId = 0
      ViaSBtn = False
      ShowHilight = True
    end
    object TransExtForm1: TSBSExtendedForm
      Left = 5
      Top = 81
      Width = 197
      Height = 29
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 4
      ArrowPos = alTop
      ArrowX = 92
      ArrowY = 3
      OrigHeight = 29
      OrigWidth = 197
      ExpandedWidth = 317
      ExpandedHeight = 187
      OrigTabOrder = 4
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = R1FPanel
      NewParent = Owner
      FocusFirst = DMDCNomF
      FocusLast = THUD4F
      TabPrev = R1TPerF
      TabNext = R1CurrF
      object UDF1L: Label8
        Left = 3
        Top = 41
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF3L: Label8
        Left = 3
        Top = 65
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF2L: Label8
        Left = 158
        Top = 41
        Width = 58
        Height = 14
        AutoSize = False
        Caption = 'UD Field 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF4L: Label8
        Left = 158
        Top = 65
        Width = 58
        Height = 14
        AutoSize = False
        Caption = 'UD Field 4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 1
        Top = 7
        Width = 43
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Ctrl GL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF5L: Label8
        Left = 3
        Top = 89
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF7L: Label8
        Left = 3
        Top = 113
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF9L: Label8
        Left = 3
        Top = 137
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF6L: Label8
        Left = 158
        Top = 89
        Width = 58
        Height = 14
        AutoSize = False
        Caption = 'UD Field 6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF8L: Label8
        Left = 158
        Top = 113
        Width = 58
        Height = 14
        AutoSize = False
        Caption = 'UD Field 8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF10L: Label8
        Left = 158
        Top = 137
        Width = 67
        Height = 14
        AutoSize = False
        Caption = 'UD Field 10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF11L: Label8
        Left = 3
        Top = 161
        Width = 62
        Height = 14
        AutoSize = False
        Caption = 'UD Field 11'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF12L: Label8
        Left = 158
        Top = 161
        Width = 67
        Height = 14
        AutoSize = False
        Caption = 'UD Field 12'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object THUD1F: Text8Pt
        Tag = 1
        Left = 64
        Top = 37
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD3F: Text8Pt
        Tag = 1
        Left = 64
        Top = 61
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD4F: Text8Pt
        Tag = 1
        Left = 223
        Top = 61
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD2F: Text8Pt
        Tag = 1
        Left = 223
        Top = 37
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object DMDCNomF: Text8Pt
        Tag = 1
        Left = 45
        Top = 3
        Width = 65
        Height = 22
        HelpContext = 551
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnExit = DMDCNomFExit
        TextId = 0
        ViaSBtn = False
      end
      object THUD5F: Text8Pt
        Tag = 1
        Left = 64
        Top = 85
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD7F: Text8Pt
        Tag = 1
        Left = 64
        Top = 109
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD9F: Text8Pt
        Tag = 1
        Left = 64
        Top = 133
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 9
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD6F: Text8Pt
        Tag = 1
        Left = 223
        Top = 85
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD8F: Text8Pt
        Tag = 1
        Left = 223
        Top = 109
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD10F: Text8Pt
        Tag = 1
        Left = 223
        Top = 133
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 10
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD11F: Text8Pt
        Tag = 1
        Left = 64
        Top = 157
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 11
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object THUD12F: Text8Pt
        Tag = 1
        Left = 223
        Top = 157
        Width = 90
        Height = 22
        HelpContext = 283
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
    end
  end
  object SBSPanel2: TSBSPanel
    Left = 386
    Top = 65
    Width = 235
    Height = 74
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = clPurple
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object R1AddrF: TMemo
      Left = 2
      Top = 2
      Width = 231
      Height = 70
      HelpContext = 230
      TabStop = False
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      OnDblClick = R1AddrFDblClick
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = 0
    Top = 382
    Width = 635
    Height = 42
    BevelOuter = bvNone
    TabOrder = 4
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 1
      Width = 625
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 215
      Top = 8
      Width = 240
      Height = 24
      Alignment = taCenter
      Caption = 'Anonymised 30/09/2017'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 576
    Top = 65516
    object Add1: TMenuItem
      Caption = '&Add'
      Hint = 
        'Choosing this option allows you to Add a new line which will be ' +
        'placed at the end of the receipt/payment.'
      OnClick = AddR1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
      OnClick = AddR1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted line.'
      OnClick = DelR1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = AddR1BtnClick
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SwiR1BtnClick
    end
    object Defaults1: TMenuItem
      Caption = 'Defa&ults'
      Hint = 
        'Allows a default bank account to be used with all Receipt/Paymen' +
        'ts'
      OnClick = DefR1BtnClick
    end
    object Cleared1: TMenuItem
      Caption = '&Status'
      Hint = 
        'Alternates the last column to display the bank cleared status/pa' +
        'y-In reference of the currently highlighted line.'
      OnClick = StatR1BtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
      OnClick = chkI1BtnClick
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
      OnClick = LnkR1BtnClick
    end
    object Pay1: TMenuItem
      Caption = '&Pay Details'
      OnClick = PayR1BtnClick
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
  object PMenu_Notes: TPopupMenu
    Left = 97
    Top = 186
    object MenItem_General: TMenuItem
      Caption = '&General Notes'
      OnClick = MenItem_GeneralClick
    end
    object MenItem_Dated: TMenuItem
      Caption = '&Dated Notes'
      OnClick = MenItem_DatedClick
    end
    object MenItem_Audit: TMenuItem
      Caption = '&Audit History Notes'
      OnClick = MenItem_AuditClick
    end
  end
end
