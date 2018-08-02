inherited SetTransLineDateFrm: TSetTransLineDateFrm
  Left = 296
  Top = 219
  ActiveControl = TransactionTxt
  Caption = 'Amend Transaction Line dates'
  ClientHeight = 413
  ClientWidth = 413
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 413
    Height = 372
    inherited TabSheet1: TTabSheet
      Caption = 'Transaction'
      inherited SBSPanel4: TSBSBackGroup
        Height = 308
      end
      object Label2: TLabel [1]
        Left = 17
        Top = 15
        Width = 361
        Height = 14
        AutoSize = False
        Caption = 'Please enter the document reference of the Transaction'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 70
        Top = 42
        Width = 60
        Height = 14
        Caption = 'Transaction:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label3: TLabel [3]
        Left = 32
        Top = 251
        Width = 45
        Height = 14
        Caption = 'Line Date'
      end
      inherited StartBtn: TButton
        Left = 78
        Top = 316
        TabOrder = 5
        Visible = False
      end
      object TransactionTxt: Text8Pt
        Left = 137
        Top = 39
        Width = 130
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 9
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = TransactionTxtChange
        OnKeyPress = TransactionTxtKeyPress
        TextId = 0
        ViaSBtn = False
      end
      object StatusPnl: TPanel
        Left = 9
        Top = 280
        Width = 381
        Height = 25
        BevelOuter = bvLowered
        Caption = ' '
        TabOrder = 4
      end
      object FindBtn: TButton
        Left = 270
        Top = 38
        Width = 75
        Height = 23
        Caption = '&Find'
        TabOrder = 1
        OnClick = FindBtnClick
      end
      object NewDateTxt: TEditDate
        Left = 84
        Top = 247
        Width = 80
        Height = 22
        AutoSelect = False
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        OnChange = NewDateTxtChange
        Placement = cpAbove
      end
      object ApplyBtn: TButton
        Left = 308
        Top = 248
        Width = 75
        Height = 21
        Caption = '&Apply'
        TabOrder = 3
        OnClick = ApplyBtnClick
      end
      object UseTransactionDateChk: TRadioButton
        Left = 172
        Top = 240
        Width = 125
        Height = 17
        Caption = 'Use Transaction Date'
        Checked = True
        TabOrder = 6
        TabStop = True
        OnClick = UseTransactionDateChkClick
      end
      object UseManualDateChk: TRadioButton
        Left = 172
        Top = 260
        Width = 101
        Height = 17
        Caption = 'Use Manual Date'
        TabOrder = 7
        OnClick = UseManualDateChkClick
      end
      object LineList: TMultiList
        Left = 12
        Top = 68
        Width = 376
        Height = 165
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Stock Code'
            Width = 128
          end
          item
            Caption = 'Description'
            Width = 128
          end
          item
            Caption = 'Date'
            Width = 76
          end>
        TabStop = True
        TabOrder = 8
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Arial'
        HeaderFont.Style = []
        HighlightFont.Charset = DEFAULT_CHARSET
        HighlightFont.Color = clWhite
        HighlightFont.Height = -11
        HighlightFont.Name = 'Arial'
        HighlightFont.Style = []
        MultiSelectFont.Charset = DEFAULT_CHARSET
        MultiSelectFont.Color = clWindowText
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
      end
    end
  end
  inherited OkCP1Btn: TButton
    Left = 231
    Top = 382
    Height = 22
    ModalResult = 0
    Visible = False
  end
  inherited ClsCP1Btn: TButton
    Left = 317
    Top = 382
    Height = 22
    Caption = '&Close'
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 413
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Amend Transaction Line Dates'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
