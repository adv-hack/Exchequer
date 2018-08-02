object vatHistoryForm: TvatHistoryForm
  Left = 271
  Top = 238
  HelpContext = 2225
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VAT 100 Submission History'
  ClientHeight = 342
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object vatReturnList: TListView
    Left = 0
    Top = 0
    Width = 377
    Height = 342
    Align = alLeft
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'VAT Period'
        Width = 75
      end
      item
        Caption = 'Date Submitted'
        Width = 120
      end
      item
        Caption = 'Status'
        Width = 75
      end
      item
        Caption = 'Submitted by'
        Width = 100
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = vatReturnListColumnClick
    OnCompare = vatReturnListCompare
    OnCustomDrawItem = vatReturnListCustomDrawItem
    OnCustomDrawSubItem = vatReturnListCustomDrawSubItem
    OnSelectItem = vatReturnListSelectItem
  end
  object btnClose: TButton
    Left = 390
    Top = 24
    Width = 80
    Height = 21
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnView: TButton
    Left = 390
    Top = 56
    Width = 80
    Height = 21
    Caption = 'View Detail'
    Enabled = False
    TabOrder = 2
    OnClick = btnViewClick
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 418
    Top = 113
  end
end
