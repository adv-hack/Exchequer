object Form_IfOptions: TForm_IfOptions
  Left = 355
  Top = 120
  HelpContext = 1100
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'If Expression Options'
  ClientHeight = 359
  ClientWidth = 537
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
  object SBSBackGroup1: TSBSBackGroup
    Left = 6
    Top = 1
    Width = 527
    Height = 327
    TextId = 0
  end
  object Label_Formula: Label8
    Left = 14
    Top = 236
    Width = 9
    Height = 14
    Caption = 'If:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Save: TButton
    Left = 358
    Top = 333
    Width = 82
    Height = 21
    Caption = '&OK'
    TabOrder = 7
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 448
    Top = 333
    Width = 82
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = Button_CancelClick
  end
  object Memo_If: TMemo
    Left = 13
    Top = 251
    Width = 509
    Height = 43
    MaxLength = 200
    TabOrder = 2
    WantReturns = False
  end
  object TabSheet1: TTabSheet
    Caption = 'Commands'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    object ListBox1: TListBox
      Left = 3
      Top = 4
      Width = 493
      Height = 224
      ItemHeight = 13
      TabOrder = 0
      TabWidth = 80
      OnDblClick = DblClickOnList
    end
  end
  object TabSheet2: TTabSheet
    Caption = 'Commands'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    object ListBox2: TListBox
      Left = 3
      Top = 4
      Width = 493
      Height = 224
      ItemHeight = 13
      TabOrder = 0
      TabWidth = 80
      OnDblClick = DblClickOnList
    end
  end
  object PageControl1: TPageControl
    Left = 14
    Top = 11
    Width = 509
    Height = 222
    ActivePage = TabSh_FormFields
    TabIndex = 0
    TabOrder = 0
    object TabSh_FormFields: TTabSheet
      Caption = 'Form Fields'
      object List_FormFields: TListBox
        Left = 3
        Top = 4
        Width = 495
        Height = 185
        ItemHeight = 14
        TabOrder = 0
        TabWidth = 80
        OnDblClick = DblClickOnList
      end
    end
    object TabSh_Commands: TTabSheet
      Caption = 'Commands'
      object List_Commands: TListBox
        Left = 3
        Top = 4
        Width = 495
        Height = 185
        ItemHeight = 14
        TabOrder = 0
        TabWidth = 80
        OnDblClick = DblClickOnList
      end
    end
  end
  object Button_Validate: TButton
    Left = 437
    Top = 300
    Width = 82
    Height = 21
    Caption = 'C&heck If'
    TabOrder = 3
    OnClick = Button_ValidateClick
  end
  object btnSelDbField: TButton
    Left = 349
    Top = 300
    Width = 82
    Height = 21
    Caption = '&Db Field'
    TabOrder = 1
    OnClick = btnSelDbFieldClick
  end
end
