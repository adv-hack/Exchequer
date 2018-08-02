object Form1: TForm1
  Left = 277
  Top = 205
  Width = 783
  Height = 540
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 224
    Top = 72
    Width = 32
    Height = 14
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 88
    Top = 16
    Width = 121
    Height = 22
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 88
    Top = 40
    Width = 121
    Height = 22
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 88
    Top = 64
    Width = 121
    Height = 22
    TabOrder = 2
    Text = 'Edit3'
  end
  object ext8Pt1: Text8Pt
    Left = 272
    Top = 64
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = 'ext8Pt1'
    TextId = 0
    ViaSBtn = False
  end
  object CurrencyEdit1: TCurrencyEdit
    Left = 408
    Top = 64
    Width = 80
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object EditPeriod1: TEditPeriod
    Left = 496
    Top = 64
    Width = 121
    Height = 22
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 5
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '00/0000;0;'
  end
  object Edit4: TEdit
    Left = 88
    Top = 96
    Width = 121
    Height = 22
    TabOrder = 6
    Text = 'Edit4'
  end
  object Memo1: TMemo
    Left = 88
    Top = 128
    Width = 513
    Height = 65
    Lines.Strings = (
      
        'One of the shareware apps I recall from that era is a Macintosh ' +
        'text editor called Alpha '
      
        '<http://www.kelehers.org/alpha/>. I'#39'm not sure if Pete Keleher w' +
        'ould remember me, but I do remember '
      
        'him. It is great to see that Alpha is still available and is sti' +
        'll shareware. However, as far as I can tell, '
      'Alpha has never been a full-time job for Pete. ')
    TabOrder = 7
  end
  object Edit5: TEdit
    Left = 88
    Top = 200
    Width = 121
    Height = 22
    TabOrder = 10
    Text = 'Edit5'
  end
  object ListBox1: TListBox
    Left = 88
    Top = 264
    Width = 305
    Height = 177
    ItemHeight = 14
    TabOrder = 12
  end
  object ComboBox1: TComboBox
    Left = 88
    Top = 232
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 11
    Items.Strings = (
      'Alpha'
      'Bravo'
      'Charlie'
      'Delta'
      'Excho'
      'Foxtrot'
      'Gamma')
  end
  object MultiList1: TMultiList
    Left = 400
    Top = 264
    Width = 321
    Height = 177
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Column 0'
      end
      item
        Caption = 'Column 1'
      end
      item
        Caption = 'Column 2'
      end>
    TabStop = True
    TabOrder = 13
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
    Version = 'v1.12'
  end
  object Button1: TButton
    Left = 608
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Debug'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 608
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Width'
    TabOrder = 9
    OnClick = Button2Click
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.00 for Delphi 6.01'
    Left = 16
    Top = 32
  end
end
