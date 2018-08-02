object Form_AddFieldCol: TForm_AddFieldCol
  Left = 378
  Top = 168
  HelpContext = 730
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Field column'
  ClientHeight = 218
  ClientWidth = 469
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Button_Save: TButton
    Left = 384
    Top = 24
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 384
    Top = 52
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = Button_CancelClick
  end
  object PageControl1: TPageControl
    Left = 4
    Top = 3
    Width = 375
    Height = 211
    ActivePage = TabSh_Field
    TabIndex = 0
    TabOrder = 0
    object TabSh_Field: TTabSheet
      Caption = 'Field'
      object SBSBackGroup1: TSBSBackGroup
        Left = 5
        Top = 0
        Width = 356
        Height = 137
        TextId = 0
      end
      object Label89: Label8
        Left = 36
        Top = 112
        Width = 43
        Height = 14
        Caption = 'Decimals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 32
        Top = 86
        Width = 47
        Height = 14
        Caption = 'Alignment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 55
        Top = 62
        Width = 24
        Height = 14
        Caption = 'Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 25
        Top = 43
        Width = 54
        Height = 14
        Caption = 'Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 54
        Top = 14
        Width = 25
        Height = 14
        Caption = 'Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label_Description: Label8
        Left = 86
        Top = 43
        Width = 230
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
      object Label_Type: Label8
        Left = 86
        Top = 62
        Width = 161
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
      object Panel_Font: TSBSPanel
        Left = 5
        Top = 141
        Width = 356
        Height = 36
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'Panel_Font'
        Enabled = False
        TabOrder = 4
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_Font: Label8
          Left = 9
          Top = 5
          Width = 250
          Height = 25
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
        Left = 276
        Top = 146
        Width = 80
        Height = 25
        Caption = '&Font'
        TabOrder = 5
        OnClick = Button_SelectFontClick
      end
      object Button_Select: TButton
        Left = 274
        Top = 12
        Width = 80
        Height = 21
        Caption = '&Select'
        TabOrder = 1
        OnClick = Button_SelectClick
      end
      object Text_ShortCode: Text8Pt
        Left = 86
        Top = 11
        Width = 121
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = Button_SelectClick
        OnExit = Text_ShortCodeExit
        TextId = 0
        ViaSBtn = False
      end
      object Combo_Align: TSBSComboBox
        Left = 86
        Top = 83
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
        Left = 86
        Top = 109
        Width = 32
        Height = 22
        Enabled = False
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
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
    end
    object TabSh_Column: TTabSheet
      Caption = 'Column'
      object SBSBackGroup2: TSBSBackGroup
        Left = 5
        Top = 0
        Width = 356
        Height = 133
        TextId = 0
      end
      object Label85: Label8
        Left = 23
        Top = 15
        Width = 57
        Height = 14
        Caption = 'Column Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 15
        Top = 42
        Width = 65
        Height = 14
        Caption = 'Column Width'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 137
        Top = 42
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
      object Text_Title: Text8Pt
        Left = 86
        Top = 12
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
      object Check_ColSep: TBorCheck
        Left = 13
        Top = 67
        Width = 337
        Height = 20
        Align = alRight
        Caption = 'Show Column Separating Line at right end of column'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        TabStop = True
        TextId = 0
      end
      object CcyVal_Width: TCurrencyEdit
        Left = 86
        Top = 39
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
        OnDblClick = RecalcColWidth
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 40
      end
      object Check_HideCol: TBorCheck
        Left = 13
        Top = 87
        Width = 337
        Height = 20
        Align = alRight
        Caption = 'Hide Column'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object BorChk_BlankZero: TBorCheck
        Left = 13
        Top = 108
        Width = 276
        Height = 20
        Align = alRight
        Caption = 'Leave blank if value is 0.00'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
        TextId = 0
      end
      object SBSPanel3: TSBSPanel
        Left = 5
        Top = 137
        Width = 356
        Height = 36
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'SBSPanel3'
        TabOrder = 5
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_If: Label8
          Left = 6
          Top = 6
          Width = 265
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
        Left = 273
        Top = 142
        Width = 80
        Height = 25
        Caption = '&If'
        TabOrder = 6
        OnClick = Button_IfClick
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
    Left = 390
    Top = 86
  end
end
