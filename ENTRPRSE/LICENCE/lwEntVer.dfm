object frmLicWiz2: TfrmLicWiz2
  Left = 398
  Top = 145
  HelpContext = 1006
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 2 of 5'
  ClientHeight = 453
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    303
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 291
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Exchequer Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 33
    Width = 290
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Select the version of Exchequer to be made available and whether' +
      ' it is to be Client-Server or Non Client-Server.'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 8
    Top = 418
    Width = 286
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 306
    Width = 290
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please specify the Exchequer User Count:-'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 21
    Top = 332
    Width = 97
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Users'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 8
    Top = 362
    Width = 290
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please specify the Exchequer Company Count:-'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 21
    Top = 388
    Width = 97
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Companies'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label7: TLabel
    Left = 229
    Top = 388
    Width = 64
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = '(0 = Auto)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lstEntMods: TListBox
    Left = 20
    Top = 164
    Width = 261
    Height = 63
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Core'
      'Stock'
      'SPOP')
    ParentFont = False
    TabOrder = 2
    OnClick = lstEntModsClick
  end
  object btnNext: TButton
    Left = 216
    Top = 428
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Next >>'
    TabOrder = 9
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 130
    Top = 428
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '<< &Previous'
    TabOrder = 8
    OnClick = btnPreviousClick
  end
  object lstClSvr: TListBox
    Left = 20
    Top = 230
    Width = 261
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Pervasive - Non Client-Server'
      'Pervasive - Client-Server'
      'Microsoft - SQL Server')
    ParentFont = False
    TabOrder = 3
    OnClick = lstClSvrClick
  end
  object lstCurrVer: TListBox
    Left = 20
    Top = 98
    Width = 261
    Height = 63
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Professional'
      'Euro'
      'Multi-Currency')
    ParentFont = False
    TabOrder = 1
    OnClick = lstCurrVerClick
  end
  object lstUsers: TComboBox
    Left = 123
    Top = 328
    Width = 85
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 4
    Text = '0'
    OnKeyPress = lstUsersKeyPress
    Items.Strings = (
      '1'
      '4'
      '8'
      '12'
      '16'
      '20'
      '24'
      '28')
  end
  object lstCompanies: TComboBox
    Left = 123
    Top = 384
    Width = 85
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 6
    Text = '0'
    OnKeyPress = lstUsersKeyPress
    Items.Strings = (
      '5'
      '10'
      '15'
      '20')
  end
  object UpDown1: TUpDown
    Left = 208
    Top = 328
    Width = 20
    Height = 27
    Associate = lstUsers
    Min = 0
    Max = 999
    Position = 0
    TabOrder = 5
    Wrap = False
  end
  object UpDown2: TUpDown
    Left = 208
    Top = 384
    Width = 20
    Height = 27
    Associate = lstCompanies
    Min = 0
    Max = 9999
    Position = 0
    TabOrder = 7
    Wrap = False
  end
  object cmbVersion: TComboBox
    Left = 20
    Top = 68
    Width = 262
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 0
    Text = '0'
    Items.Strings = (
      '1'
      '4'
      '8'
      '12'
      '16'
      '20'
      '24'
      '28')
  end
end
