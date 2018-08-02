object frmShowResult: TfrmShowResult
  Left = 192
  Top = 110
  Width = 870
  Height = 675
  Caption = 'Results'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 854
    Height = 584
    ActivePage = tsDB
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object tsDB: TTabSheet
      Caption = 'Database Comparisions'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 846
        Height = 556
        Align = alClient
        DataSource = DataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object tsRes: TTabSheet
      Caption = 'Result Comparisions'
      ImageIndex = 1
      object memResults: TMemo
        Left = 0
        Top = 0
        Width = 841
        Height = 541
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 584
    Width = 854
    Height = 53
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      854
      53)
    object btnShow: TButton
      Left = 688
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Load'
      TabOrder = 0
      OnClick = btnShowClick
    end
    object Button1: TButton
      Left = 768
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 608
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Compare'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object DataSource1: TDataSource
    DataSet = dsADO
    Left = 40
    Top = 544
  end
  object dsADO: TADODataSet
    Parameters = <>
    Left = 72
    Top = 544
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xml'
    Filter = 'Xml Files (*.xml); Test Files (*.txt)|*.xml; *.txt'
    FilterIndex = 0
    Left = 104
    Top = 544
  end
end
