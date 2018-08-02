object frmMain: TfrmMain
  Left = 158
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Exchequer Performance Tester'
  ClientHeight = 446
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 489
    Height = 385
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lvTests: TListView
      Left = 2
      Top = 2
      Width = 485
      Height = 381
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = 'Test'
          Width = 250
        end
        item
          Caption = 'Standard'
          Width = 100
        end
        item
          Caption = 'Client ID'
          Width = 100
        end
        item
          Caption = 'Records'
          Width = 200
        end>
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      GridLines = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      OnInfoTip = lvTestsInfoTip
    end
  end
  object pnlStatus: TPanel
    Left = 8
    Top = 400
    Width = 593
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object TPanel
    Left = 504
    Top = 8
    Width = 97
    Height = 385
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object btnGo: TSBSButton
      Left = 8
      Top = 8
      Width = 80
      Height = 21
      Caption = '&Go'
      TabOrder = 0
      OnClick = btnGoClick
      TextId = 0
    end
    object btnSave: TSBSButton
      Left = 8
      Top = 32
      Width = 80
      Height = 21
      Caption = '&Save'
      TabOrder = 1
      OnClick = btnSaveClick
      TextId = 0
    end
    object btnClose: TSBSButton
      Left = 8
      Top = 56
      Width = 80
      Height = 21
      Caption = '&Close'
      TabOrder = 2
      OnClick = btnCloseClick
      TextId = 0
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Files|*.csv'
    Left = 568
    Top = 360
  end
end
