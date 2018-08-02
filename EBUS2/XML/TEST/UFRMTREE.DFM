object frmXMLBrowse: TfrmXMLBrowse
  Left = 194
  Top = 109
  Width = 483
  Height = 375
  Caption = 'XML Browser'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object tvwXML: TTreeView
    Left = 0
    Top = 33
    Width = 475
    Height = 315
    Align = alClient
    Indent = 19
    TabOrder = 0
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtXMLFileName: TEdit
      Left = 1
      Top = 5
      Width = 269
      Height = 21
      TabOrder = 0
    end
    object btnBrowse: TButton
      Left = 269
      Top = 5
      Width = 22
      Height = 21
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnParse: TButton
      Left = 399
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Parse'
      TabOrder = 2
      OnClick = btnParseClick
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'XML'
    Left = 360
  end
end
