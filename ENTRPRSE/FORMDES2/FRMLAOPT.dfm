object Form_FormulaOptions: TForm_FormulaOptions
  Left = 391
  Top = 110
  HelpContext = 810
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Formula Options'
  ClientHeight = 375
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Button_Save: TButton
    Left = 356
    Top = 349
    Width = 82
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 446
    Top = 349
    Width = 82
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = Button_CancelClick
  end
  object PageControl2: TPageControl
    Left = 5
    Top = 4
    Width = 523
    Height = 337
    ActivePage = TabSh_Formula
    TabIndex = 0
    TabOrder = 0
    object TabSh_Formula: TTabSheet
      Caption = 'Formula'
      object Label_Formula: Label8
        Left = 3
        Top = 209
        Width = 41
        Height = 14
        Caption = 'Formula:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblResType: Label8
        Left = 73
        Top = 286
        Width = 180
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 3
        Top = 286
        Width = 59
        Height = 14
        Caption = 'Result Type:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Memo_Formula: TMemo
        Left = 3
        Top = 223
        Width = 509
        Height = 58
        MaxLength = 200
        TabOrder = 0
        WantReturns = False
        OnChange = Memo_FormulaChange
      end
      object PageControl1: TPageControl
        Left = 3
        Top = 1
        Width = 509
        Height = 205
        ActivePage = TabSh_FormFields
        TabIndex = 0
        TabOrder = 1
        object TabSh_FormFields: TTabSheet
          Caption = 'Form Fields'
          object List_FormFields: TListBox
            Left = 3
            Top = 4
            Width = 494
            Height = 168
            ItemHeight = 14
            TabOrder = 0
            TabWidth = 80
            OnDblClick = DblClickOnList
          end
        end
        object TabSh_Commands: TTabSheet
          Caption = 'Commands'
          PopupMenu = Popup_Commands
          object List_Commands: TListBox
            Left = 3
            Top = 4
            Width = 494
            Height = 168
            ItemHeight = 13
            TabOrder = 0
            TabWidth = 80
            OnDblClick = DblClickOnList
          end
        end
      end
      object btnSelDbField: TButton
        Left = 336
        Top = 286
        Width = 82
        Height = 21
        Caption = '&Db Field'
        TabOrder = 2
        OnClick = btnSelDbFieldClick
      end
      object Button_Validate: TButton
        Left = 426
        Top = 286
        Width = 82
        Height = 21
        Caption = 'C&heck Formula'
        TabOrder = 3
        OnClick = Button_ValidateClick
      end
    end
    object TabSh_Format: TTabSheet
      Caption = 'Format'
      object SBSBackGroup2: TSBSBackGroup
        Left = 6
        Top = 1
        Width = 503
        Height = 117
        TextId = 0
      end
      object Label81: Label8
        Left = 17
        Top = 17
        Width = 50
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Alignment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 21
        Top = 44
        Width = 46
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Decimals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Panel_Font: TSBSPanel
        Left = 6
        Top = 121
        Width = 503
        Height = 76
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 4
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_Font: Label8
          Left = 9
          Top = 6
          Width = 397
          Height = 64
          AutoSize = False
          Caption = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object Button_SelectFont: TButton
        Left = 427
        Top = 127
        Width = 75
        Height = 64
        Caption = '&Font'
        TabOrder = 5
        OnClick = Button_SelectFontClick
      end
      object Combo_Align: TSBSComboBox
        Left = 72
        Top = 14
        Width = 148
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        Items.Strings = (
          'Left Justified'
          'Centred Horizontally'
          'Right Justified')
        MaxListWidth = 0
      end
      object Ccy_Decs: TCurrencyEdit
        Left = 72
        Top = 41
        Width = 32
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 1
        ParentFont = False
        TabOrder = 1
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
      object BorChk_BlankZero: TBorCheck
        Left = 17
        Top = 69
        Width = 276
        Height = 20
        Align = alRight
        Caption = 'Leave blank if value is 0.00'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TextId = 0
      end
      object SBSPanel3: TSBSPanel
        Left = 6
        Top = 200
        Width = 503
        Height = 42
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 6
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_If: Label8
          Left = 9
          Top = 11
          Width = 411
          Height = 28
          AutoSize = False
          Caption = 'Print If:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object Button_If: TButton
        Left = 427
        Top = 206
        Width = 75
        Height = 29
        Caption = '&If'
        TabOrder = 7
        OnClick = Button_IfClick
      end
      object Check_Hide: TBorCheck
        Left = 17
        Top = 91
        Width = 162
        Height = 20
        Align = alRight
        Caption = 'Hide (Overrides '#39'Print If'#39')'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
    end
    object TabSh_BarCode: TTabSheet
      Caption = 'BarCode'
      object SBSBackGroup1: TSBSBackGroup
        Left = 6
        Top = 1
        Width = 503
        Height = 303
        TextId = 0
      end
      object Label83: Label8
        Left = 17
        Top = 20
        Width = 68
        Height = 14
        Caption = 'BarCode Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Combo_Type: TSBSComboBox
        Left = 98
        Top = 13
        Width = 231
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnChange = Combo_TypeChange
        Items.Strings = (
          'None'
          'Code 3 of 9'
          'Code 128'
          'Interleaved 2 of 5'
          'Codabar'
          'Postnet'
          'UPC-A'
          'UPC-E'
          'EAN-8'
          'EAN-13'
          'Health Industry Bar Code (HIBC)')
        MaxListWidth = 0
      end
      object ListPan: TPanel
        Left = 15
        Top = 39
        Width = 477
        Height = 204
        BevelOuter = bvNone
        TabOrder = 1
        object FNCPan: TPanel
          Left = 0
          Top = 0
          Width = 477
          Height = 75
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Chk_FNC1: TBorCheck
            Left = 1
            Top = 4
            Width = 107
            Height = 20
            Align = alRight
            Caption = 'Include FNC1'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TextId = 0
          end
          object Chk_FNC2: TBorCheck
            Left = 1
            Top = 29
            Width = 99
            Height = 20
            Align = alRight
            Caption = 'Include FNC2'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 1
            TextId = 0
          end
          object Chk_FNC3: TBorCheck
            Left = 1
            Top = 53
            Width = 108
            Height = 20
            Align = alRight
            Caption = 'Include FNC3'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 2
            TextId = 0
          end
        end
        object ExtPan: TPanel
          Left = 0
          Top = 75
          Width = 477
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Chk_Extend: TBorCheck
            Left = 1
            Top = 4
            Width = 156
            Height = 20
            Align = alRight
            Caption = 'Extended Character Set'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TextId = 0
          end
        end
        object CheckPan: TPanel
          Left = 0
          Top = 103
          Width = 477
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Chk_CheckChar: TBorCheck
            Left = 1
            Top = 4
            Width = 156
            Height = 20
            Align = alRight
            Caption = 'Include Check Character'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TextId = 0
          end
        end
        object StrtPan: TPanel
          Left = 0
          Top = 131
          Width = 477
          Height = 58
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object LblStart: Label8
            Left = 4
            Top = 9
            Width = 51
            Height = 14
            Caption = 'Start Code'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object LblStop: Label8
            Left = 4
            Top = 34
            Width = 50
            Height = 14
            Caption = 'Stop Code'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
          object Combo_Stop: TSBSComboBox
            Left = 63
            Top = 31
            Width = 49
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 1
            Items.Strings = (
              'A'
              'B'
              'C'
              'D')
            MaxListWidth = 0
          end
          object Combo_Start: TSBSComboBox
            Left = 63
            Top = 6
            Width = 49
            Height = 22
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 14
            ParentFont = False
            TabOrder = 0
            Items.Strings = (
              'A'
              'B'
              'C'
              'D')
            MaxListWidth = 0
          end
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    HelpContext = 20200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdShowHelp]
    Left = 250
    Top = 347
  end
  object Popup_Commands: TPopupMenu
    Left = 216
    Top = 347
  end
end
