object TSheetForm: TTSheetForm
  Left = 511
  Top = 241
  Width = 648
  Height = 408
  HelpContext = 930
  Caption = 'Timesheet Record'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
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
    Left = 0
    Top = 0
    Width = 630
    Height = 330
    ActivePage = RecepPage
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object RecepPage: TTabSheet
      Caption = 'Timesheet'
      object N1SBox: TScrollBox
        Left = 0
        Top = 68
        Width = 494
        Height = 211
        HelpContext = 425
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        TabOrder = 0
        object N1HedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 487
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object N1DLab: TSBSPanel
            Left = 2
            Top = 2
            Width = 71
            Height = 13
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'Job Code'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1NomLab: TSBSPanel
            Left = 77
            Top = 2
            Width = 64
            Height = 13
            BevelOuter = bvNone
            Caption = 'Rate Code'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1CrLab: TSBSPanel
            Left = 408
            Top = 2
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Total'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1DrLab: TSBSPanel
            Left = 289
            Top = 2
            Width = 42
            Height = 13
            BevelOuter = bvNone
            Caption = 'Hours'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1TCLab: TSBSPanel
            Left = 332
            Top = 2
            Width = 77
            Height = 13
            BevelOuter = bvNone
            Caption = 'Time Cost'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1CCLab: TSBSPanel
            Left = 216
            Top = 2
            Width = 35
            Height = 13
            BevelOuter = bvNone
            Caption = 'CC'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1DepLab: TSBSPanel
            Left = 252
            Top = 2
            Width = 34
            Height = 13
            BevelOuter = bvNone
            Caption = 'Dept'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object N1ALab: TSBSPanel
            Left = 154
            Top = 2
            Width = 59
            Height = 13
            BevelOuter = bvNone
            Caption = 'Analysis'
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
            OnMouseDown = N1DLabMouseDown
            OnMouseMove = N1DLabMouseMove
            OnMouseUp = N1DPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object N1DPanel: TSBSPanel
          Left = 2
          Top = 22
          Width = 73
          Height = 168
          HelpContext = 1019
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1DrPanel: TSBSPanel
          Left = 289
          Top = 22
          Width = 45
          Height = 168
          HelpContext = 1021
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1NomPanel: TSBSPanel
          Left = 77
          Top = 22
          Width = 76
          Height = 168
          HelpContext = 1020
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1CrPanel: TSBSPanel
          Left = 412
          Top = 22
          Width = 76
          Height = 168
          HelpContext = 1023
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1CCPanel: TSBSPanel
          Left = 217
          Top = 22
          Width = 35
          Height = 168
          HelpContext = 272
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1DepPanel: TSBSPanel
          Left = 253
          Top = 22
          Width = 35
          Height = 168
          HelpContext = 272
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1APanel: TSBSPanel
          Left = 155
          Top = 22
          Width = 61
          Height = 168
          HelpContext = 976
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object N1TCPanel: TSBSPanel
          Left = 335
          Top = 22
          Width = 76
          Height = 168
          HelpContext = 1022
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
          OnMouseUp = N1DPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
      object N1BtmPanel: TSBSPanel
        Left = 0
        Top = 281
        Width = 622
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        PopupMenu = PopupMenu1
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object SBSPanel5: TSBSPanel
          Left = 2
          Top = 3
          Width = 225
          Height = 17
          HelpContext = 426
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object DrReqdTit: Label8
            Left = 4
            Top = 2
            Width = 52
            Height = 14
            Caption = 'Pay Desc.:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object PayDescF: Label8
            Left = 64
            Top = 2
            Width = 158
            Height = 14
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
        object SBSPanel1: TSBSPanel
          Left = 357
          Top = 3
          Width = 137
          Height = 17
          HelpContext = 426
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label83: Label8
            Left = 4
            Top = 2
            Width = 25
            Height = 14
            Caption = 'Total:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object CrReqdLab: Label8
            Left = 33
            Top = 2
            Width = 96
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
        object SBSPanel2: TSBSPanel
          Left = 229
          Top = 3
          Width = 124
          Height = 17
          HelpContext = 426
          BevelOuter = bvLowered
          Caption = 'SBSPanel2'
          ParentColor = True
          TabOrder = 2
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          object Label86: Label8
            Left = 4
            Top = 2
            Width = 26
            Height = 14
            Caption = 'Hrs .:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object DrReqdLab: Label8
            Left = 33
            Top = 2
            Width = 88
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
      object N1ListBtnPanel: TSBSPanel
        Left = 498
        Top = 92
        Width = 18
        Height = 168
        BevelOuter = bvLowered
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
    object NotesPage: TTabSheet
      HelpContext = 438
      Caption = 'Notes'
      object TCNScrollBox: TScrollBox
        Left = 0
        Top = 68
        Width = 493
        Height = 229
        VertScrollBar.Visible = False
        TabOrder = 0
        object TNHedPanel: TSBSPanel
          Left = -1
          Top = 2
          Width = 487
          Height = 17
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
          Left = 1
          Top = 22
          Width = 67
          Height = 184
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
          Height = 184
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
          Height = 184
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = ANSI_CHARSET
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
      object TCNListBtnPanel: TSBSPanel
        Left = 496
        Top = 92
        Width = 18
        Height = 184
        BevelOuter = bvLowered
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
    end
  end
  object N1BtnPanel: TSBSPanel
    Left = 524
    Top = 28
    Width = 100
    Height = 278
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
    object N1StatLab: Label8
      Left = 7
      Top = 7
      Width = 84
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'N1StatLab'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object OkN1Btn: TButton
      Tag = 1
      Left = 2
      Top = 2
      Width = 80
      Height = 21
      HelpContext = 257
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = OkN1BtnClick
    end
    object CanN1Btn: TButton
      Tag = 1
      Left = 2
      Top = 25
      Width = 80
      Height = 21
      HelpContext = 258
      Cancel = True
      Caption = '&Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsN1BtnClick
    end
    object ClsN1Btn: TButton
      Left = 2
      Top = 49
      Width = 80
      Height = 21
      HelpContext = 259
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 2
      OnClick = ClsN1BtnClick
    end
    object N1BSBox: TScrollBox
      Left = 1
      Top = 99
      Width = 97
      Height = 175
      HorzScrollBar.Tracking = True
      HorzScrollBar.Visible = False
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      object AddN1Btn: TButton
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add new line|Choosing this option allows you to Add a new line w' +
          'hich will be placed at the end of the nominal transfer.'
        HelpContext = 427
        Caption = '&Add'
        Enabled = False
        TabOrder = 0
        OnClick = AddN1BtnClick
      end
      object EditN1Btn: TButton
        Left = 2
        Top = 25
        Width = 80
        Height = 21
        Hint = 
          'Edit current line|Choosing this option allows you to edit the cu' +
          'rrently highlighted line.'
        HelpContext = 428
        Caption = '&Edit'
        Enabled = False
        TabOrder = 1
        OnClick = AddN1BtnClick
      end
      object DelN1Btn: TButton
        Left = 2
        Top = 49
        Width = 80
        Height = 21
        Hint = 
          'Delete current line|Choosing this option allows you to delete th' +
          'e currently highlighted line.'
        HelpContext = 429
        Caption = '&Delete'
        Enabled = False
        TabOrder = 2
        OnClick = DelN1BtnClick
      end
      object InsN1Btn: TButton
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
        OnClick = AddN1BtnClick
      end
      object SWiN1Btn: TButton
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
        OnClick = SWiN1BtnClick
      end
      object LnkN1Btn: TButton
        Left = 2
        Top = 144
        Width = 80
        Height = 21
        Hint = 
          'Link to additional information|Displays a list of any additional' +
          ' information attached to this transaction.'
        HelpContext = 90
        Caption = 'Lin&ks'
        TabOrder = 6
        OnClick = LnkN1BtnClick
      end
      object chkI1Btn: TButton
        Left = 2
        Top = 121
        Width = 80
        Height = 21
        Hint = 
          'Recalculate total|Choosing this option will recalculate the tota' +
          'l in cases where the total does not agree with the sum of the in' +
          'dividual entries.'
        HelpContext = 1032
        Caption = 'Chec&k'
        Enabled = False
        TabOrder = 5
        OnClick = chkI1BtnClick
      end
    end
  end
  object N1FPanel: TSBSPanel
    Left = 2
    Top = 23
    Width = 517
    Height = 68
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label817: Label8
      Left = 323
      Top = 14
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
    object Label84: Label8
      Left = 199
      Top = 14
      Width = 22
      Height = 14
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 313
      Top = 41
      Width = 50
      Height = 14
      Caption = ' Wk/Month'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 6
      Top = 15
      Width = 46
      Height = 14
      Caption = 'Employee'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object N1OrefF: Text8Pt
      Left = 365
      Top = 10
      Width = 79
      Height = 22
      HelpContext = 1009
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = 'SRC000080'
      TextId = 0
      ViaSBtn = False
    end
    object N1OpoF: Text8Pt
      Left = 447
      Top = 10
      Width = 50
      Height = 22
      HelpContext = 1009
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = 'Sally'
      TextId = 0
      ViaSBtn = False
    end
    object N1TDateF: TEditDate
      Tag = 1
      Left = 224
      Top = 10
      Width = 78
      Height = 22
      HelpContext = 1010
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
      TabOrder = 1
      OnExit = N1TDateFExit
      Placement = cpAbove
    end
    object EmpAc: Text8Pt
      Tag = 1
      Left = 54
      Top = 11
      Width = 69
      Height = 22
      HelpContext = 830
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnExit = EmpAcExit
      TextId = 0
      ViaSBtn = False
    end
    object N1TSWkF: TCurrencyEdit
      Tag = 1
      Left = 365
      Top = 37
      Width = 79
      Height = 22
      HelpContext = 1011
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 4
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object TransExtForm1: TSBSExtendedForm
      Left = 1
      Top = 36
      Width = 316
      Height = 30
      HelpContext = 1169
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 2
      ArrowPos = alTop
      ArrowX = 151
      ArrowY = 6
      OrigHeight = 30
      OrigWidth = 316
      ExpandedWidth = 318
      ExpandedHeight = 183
      OrigTabOrder = 2
      ShowHorzSB = True
      ShowVertSB = True
      OrigParent = N1FPanel
      NewParent = Owner
      FocusFirst = N1YRefF
      FocusLast = THUD4F
      TabPrev = N1TDateF
      TabNext = N1TSWkF
      object UDF1L: Label8
        Left = 7
        Top = 41
        Width = 58
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
        Left = 7
        Top = 65
        Width = 58
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
        Left = 156
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
        Left = 156
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
      object Label87: Label8
        Left = 25
        Top = 10
        Width = 25
        Height = 14
        Caption = 'Desc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 190
        Top = 10
        Width = 31
        Height = 14
        Caption = 'Per/Yr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object UDF5L: Label8
        Left = 7
        Top = 89
        Width = 58
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
        Left = 7
        Top = 113
        Width = 58
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
        Left = 7
        Top = 137
        Width = 58
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
        Left = 156
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
        Left = 156
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
        Left = 156
        Top = 137
        Width = 66
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
        Left = 7
        Top = 161
        Width = 58
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
        Left = 156
        Top = 161
        Width = 66
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
        Left = 66
        Top = 37
        Width = 87
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
      object THUD3F: Text8Pt
        Tag = 1
        Left = 66
        Top = 61
        Width = 87
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
      object THUD4F: Text8Pt
        Tag = 1
        Left = 223
        Top = 61
        Width = 88
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
      object THUD2F: Text8Pt
        Tag = 1
        Left = 223
        Top = 37
        Width = 88
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
      object N1YRefF: Text8Pt
        Tag = 1
        Left = 52
        Top = 6
        Width = 131
        Height = 22
        HelpContext = 830
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
      object N1TPerF: TEditPeriod
        Tag = 1
        Left = 224
        Top = 6
        Width = 78
        Height = 22
        HelpContext = 1010
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
        TabOrder = 1
        Text = 'mmyyyy'
        Placement = cpAbove
        EPeriod = 1
        EYear = 1996
        ViewMask = '000/0000;0;'
        OnConvDate = N1TPerFConvDate
        OnShowPeriod = N1TPerFShowPeriod
      end
      object THUD5F: Text8Pt
        Tag = 1
        Left = 66
        Top = 85
        Width = 87
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
      object THUD7F: Text8Pt
        Tag = 1
        Left = 66
        Top = 109
        Width = 87
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
      object THUD9F: Text8Pt
        Tag = 1
        Left = 66
        Top = 133
        Width = 87
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
      object THUD6F: Text8Pt
        Tag = 1
        Left = 223
        Top = 85
        Width = 88
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
      object THUD8F: Text8Pt
        Tag = 1
        Left = 223
        Top = 109
        Width = 88
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
      object THUD10F: Text8Pt
        Tag = 1
        Left = 223
        Top = 133
        Width = 88
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
      object THUD11F: Text8Pt
        Tag = 1
        Left = 66
        Top = 157
        Width = 87
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
      object THUD12F: Text8Pt
        Tag = 1
        Left = 223
        Top = 157
        Width = 88
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
        TabOrder = 13
        OnExit = THUD1FExit
        TextId = 0
        ViaSBtn = False
        OnEntHookEvent = THUD1FEntHookEvent
      end
    end
  end
  object pnlAnonymisationStatus: TPanel
    Left = 2
    Top = 335
    Width = 631
    Height = 42
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object shpNotifyStatus: TShape
      Left = 5
      Top = 0
      Width = 623
      Height = 38
      Brush.Color = clRed
      Shape = stRoundRect
    end
    object lblAnonStatus: TLabel
      Left = 205
      Top = 7
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
        'placed at the end of the nominal transfer.'
      OnClick = AddN1BtnClick
    end
    object Edit1: TMenuItem
      Tag = 1
      Caption = '&Edit'
      Hint = 
        'Choosing this option allows you to edit the currently highlighte' +
        'd line.'
      Visible = False
      OnClick = AddN1BtnClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      Hint = 
        'Choosing this option allows you to delete the currently highligh' +
        'ted line.'
      OnClick = DelN1BtnClick
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      Hint = 
        'Choosing this option allows you to Insert a new line before the ' +
        'currently highlighted line.'
      OnClick = AddN1BtnClick
    end
    object Switch1: TMenuItem
      Caption = '&Switch'
      Hint = 
        'Switches the display of the notepad between dated notepad, & gen' +
        'eral notepad.'
      OnClick = SWiN1BtnClick
    end
    object Check1: TMenuItem
      Caption = 'Chec&k'
    end
    object Links1: TMenuItem
      Caption = 'Lin&ks'
      Hint = 
        'Displays a list of any additional information attached to this t' +
        'ransaction.'
      OnClick = LnkN1BtnClick
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
    Left = 161
    Top = 117
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
