object RootPathEditDlg: TRootPathEditDlg
  Left = 446
  Top = 190
  Width = 387
  Height = 259
  Caption = 'Select Root Path'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    379
    225)
  PixelsPerInch = 96
  TextHeight = 16
  object Button1: TButton
    Left = 197
    Top = 183
    Width = 75
    Height = 31
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 295
    Top = 183
    Width = 75
    Height = 31
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 14
    Width = 366
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    DesignSize = (
      366
      80)
    object cbFolderType: TComboBox
      Left = 20
      Top = 34
      Width = 326
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 0
    end
  end
  object rbUseFolder: TRadioButton
    Left = 15
    Top = 14
    Width = 151
    Height = 21
    Caption = 'Use Standard &Folder'
    TabOrder = 2
    OnClick = rbUseFolderClick
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 102
    Width = 365
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      365
      70)
    object ePath: TEdit
      Left = 20
      Top = 25
      Width = 301
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'C:\'
    end
    object rbUsePath: TRadioButton
      Left = 10
      Top = 0
      Width = 79
      Height = 21
      Caption = 'Use &Path'
      TabOrder = 1
      OnClick = rbUsePathClick
    end
    object btnBrowse: TButton
      Left = 324
      Top = 20
      Width = 34
      Height = 30
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 2
      OnClick = btnBrowseClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 154
  end
end
