object Form_AddFormulaCol: TForm_AddFormulaCol
  Left = 329
  Top = 107
  HelpContext = 740
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Formula Options'
  ClientHeight = 375
  ClientWidth = 533
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
    Left = 358
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
    Height = 339
    ActivePage = TabSh_Formula
    TabIndex = 0
    TabOrder = 0
    object TabSh_Formula: TTabSheet
      Caption = 'Formula'
      object Label_Formula: Label8
        Left = 3
        Top = 211
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
        Top = 288
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
        Top = 288
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
      object PageControl1: TPageControl
        Left = 3
        Top = 1
        Width = 509
        Height = 205
        ActivePage = TabSh_Commands
        TabIndex = 1
        TabOrder = 0
        object TabSh_FormFields: TTabSheet
          Caption = 'Form Fields'
          object List_FormFields: TListBox
            Left = 3
            Top = 4
            Width = 495
            Height = 170
            ItemHeight = 13
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
            Width = 495
            Height = 170
            ItemHeight = 14
            TabOrder = 0
            TabWidth = 80
            OnDblClick = DblClickOnList
          end
        end
      end
      object Memo_Formula: TMemo
        Left = 3
        Top = 224
        Width = 509
        Height = 58
        MaxLength = 200
        TabOrder = 1
        WantReturns = False
        OnChange = Memo_FormulaChange
      end
      object Button_Validate: TButton
        Left = 427
        Top = 287
        Width = 82
        Height = 21
        Caption = 'C&heck Formula'
        TabOrder = 3
        OnClick = Button_ValidateClick
      end
      object btrDbField: TButton
        Left = 338
        Top = 287
        Width = 82
        Height = 21
        Caption = '&Db Field'
        TabOrder = 2
        OnClick = btrDbFieldClick
      end
    end
    object TabSh_Column: TTabSheet
      Caption = 'Column'
      object SBSBackGroup2: TSBSBackGroup
        Left = 5
        Top = 0
        Width = 505
        Height = 191
        TextId = 0
      end
      object Label85: Label8
        Left = 51
        Top = 16
        Width = 19
        Height = 14
        Alignment = taRightJustify
        Caption = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 28
        Top = 43
        Width = 42
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Width'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 23
        Top = 70
        Width = 47
        Height = 14
        Alignment = taRightJustify
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
        Left = 27
        Top = 97
        Width = 43
        Height = 14
        Alignment = taRightJustify
        Caption = 'Decimals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 127
        Top = 44
        Width = 68
        Height = 14
        Caption = '(in millimeters)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Panel_Font: TSBSPanel
        Left = 5
        Top = 195
        Width = 505
        Height = 43
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Enabled = False
        TabOrder = 7
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_Font: Label8
          Left = 6
          Top = 5
          Width = 361
          Height = 34
          AutoSize = False
          Caption = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnDblClick = Button_SelectFontClick
          TextId = 0
        end
      end
      object Button_SelectFont: TButton
        Left = 427
        Top = 202
        Width = 75
        Height = 29
        Caption = '&Font'
        TabOrder = 8
        OnClick = Button_SelectFontClick
      end
      object Combo_Align: TSBSComboBox
        Left = 75
        Top = 67
        Width = 264
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          'Left Justified'
          'Centred Horizontally'
          'Right Justified')
        MaxListWidth = 0
      end
      object Ccy_Decs: TCurrencyEdit
        Left = 75
        Top = 94
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
      object Text_Title: Text8Pt
        Left = 75
        Top = 13
        Width = 265
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object CcyVal_Width: TCurrencyEdit
        Left = 75
        Top = 40
        Width = 44
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '40 ')
        MaxLength = 3
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
        Value = 40
      end
      object Check_ColSep: TBorCheck
        Left = 15
        Top = 121
        Width = 337
        Height = 20
        Align = alRight
        Caption = 'Show Column Separating Line at right end of column'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object Check_HideCol: TBorCheck
        Left = 15
        Top = 143
        Width = 162
        Height = 20
        Align = alRight
        Caption = 'Hide Column'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object BorChk_BlankZero: TBorCheck
        Left = 15
        Top = 165
        Width = 276
        Height = 20
        Align = alRight
        Caption = 'Leave blank if value is 0.00'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        TextId = 0
      end
      object SBSPanel3: TSBSPanel
        Left = 5
        Top = 242
        Width = 505
        Height = 42
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'SBSPanel3'
        TabOrder = 9
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_If: Label8
          Left = 9
          Top = 11
          Width = 333
          Height = 26
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
        Top = 249
        Width = 75
        Height = 29
        Caption = '&If'
        TabOrder = 10
        OnClick = Button_IfClick
      end
    end
    object TabSh_BarCode: TTabSheet
      Caption = 'BarCode'
      object SBSBackGroup1: TSBSBackGroup
        Left = 5
        Top = 0
        Width = 505
        Height = 303
        TextId = 0
      end
      object Label83: Label8
        Left = 16
        Top = 18
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
        Left = 91
        Top = 13
        Width = 237
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
          'EAN-13')
        MaxListWidth = 0
      end
      object ListPan: TPanel
        Left = 14
        Top = 39
        Width = 477
        Height = 225
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
        object Panel1: TPanel
          Left = 0
          Top = 189
          Width = 477
          Height = 27
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 4
          object Label81: Label8
            Left = 5
            Top = 2
            Width = 314
            Height = 14
            Caption = 
              'Don'#39't forget to select the correct BarCode font for these settin' +
              'gs.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TextId = 0
          end
        end
      end
    end
  end
  object Popup_Commands: TPopupMenu
    Left = 715
    Top = 133
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
    Left = 704
    Top = 29
  end
end
