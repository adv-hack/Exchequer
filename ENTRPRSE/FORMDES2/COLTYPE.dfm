object Form_FieldType: TForm_FieldType
  Left = 335
  Top = 160
  HelpContext = 710
  ActiveControl = Button_AddField
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Column'
  ClientHeight = 226
  ClientWidth = 344
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
  object Label81: Label8
    Left = 5
    Top = 6
    Width = 305
    Height = 20
    AutoSize = False
    Caption = 'Please select the type of column you wish to add:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Group_Field: TSBSGroup
    Left = 4
    Top = 32
    Width = 334
    Height = 76
    Caption = 'Database Field'
    Enabled = False
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label82: Label8
      Left = 8
      Top = 20
      Width = 238
      Height = 46
      AutoSize = False
      Caption = 
        'A Database Field is an item of data that is loaded from the data' +
        'base when the form is printed. e.g. a customers balance. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
  end
  object Button_Cancel: TButton
    Left = 258
    Top = 195
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = Button_AddFieldClick
  end
  object Group_Formula: TSBSGroup
    Left = 4
    Top = 113
    Width = 334
    Height = 76
    Caption = 'Formula'
    Enabled = False
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label83: Label8
      Left = 8
      Top = 20
      Width = 238
      Height = 46
      AutoSize = False
      Caption = 
        'A Formula is a user-defined field that can consist of database f' +
        'ields, text, numbers or commands.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
  end
  object Button_AddField: TButton
    Left = 257
    Top = 42
    Width = 75
    Height = 61
    Caption = 'Add'
    TabOrder = 1
    OnClick = Button_AddFieldClick
  end
  object Button_AddFormula: TButton
    Left = 257
    Top = 123
    Width = 75
    Height = 61
    Caption = 'Add'
    TabOrder = 3
    OnClick = Button_AddFieldClick
  end
end
