object Form1: TForm1
  Left = 273
  Top = 115
  Width = 638
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    630
    466)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Btr File'
  end
  object edtBtrieveFile: TEdit
    Left = 55
    Top = 13
    Width = 440
    Height = 21
    TabOrder = 0
    Text = 'C:\Data\v600\Base Blank_MC\TRANS\Document.Dat'
  end
  object btnAnalyse: TButton
    Left = 529
    Top = 11
    Width = 75
    Height = 25
    Caption = 'Analyse'
    TabOrder = 1
    OnClick = btnAnalyseClick
  end
  object btnBrowse: TButton
    Left = 496
    Top = 13
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 2
    OnClick = btnBrowseClick
  end
  object memFileDets: TMemo
    Left = 13
    Top = 69
    Width = 604
    Height = 380
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
  end
  object chkIrfanMode: TCheckBox
    Left = 25
    Top = 42
    Width = 97
    Height = 17
    Caption = 'Irfan Mode'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.dat'
    Filter = 'Btrieve Files|*.dat|All Files|*.*'
    InitialDir = 'C:\Data\v600'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 554
    Top = 58
  end
end
