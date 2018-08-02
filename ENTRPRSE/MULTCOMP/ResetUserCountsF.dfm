object frmResetUserCounts: TfrmResetUserCounts
  Left = 616
  Top = 156
  Width = 623
  Height = 338
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Reset Individual User Counts'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object lvUserCounts: TListView
    Left = 5
    Top = 5
    Width = 510
    Height = 290
    Columns = <
      item
        Caption = 'Type'
        Width = 100
      end
      item
        Caption = 'Company'
        Width = 80
      end
      item
        Caption = 'Workstation'
        Width = 120
      end
      item
        Caption = 'Windows User Id'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = 'Count'
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvUserCountsColumnClick
    OnCompare = lvUserCountsCompare
    OnDblClick = btnRemoveClick
  end
  object btnClose: TButton
    Left = 521
    Top = 5
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
  object btnRemove: TButton
    Left = 521
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Remove'
    TabOrder = 2
    OnClick = btnRemoveClick
  end
  object btnRefresh: TButton
    Left = 521
    Top = 60
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Re&fresh'
    TabOrder = 3
    OnClick = btnRefreshClick
  end
end
