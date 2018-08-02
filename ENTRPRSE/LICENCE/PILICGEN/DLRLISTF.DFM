object frmDealerList: TfrmDealerList
  Left = 201
  Top = 170
  Width = 559
  Height = 251
  Caption = 'frmDealerList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    551
    205)
  PixelsPerInch = 96
  TextHeight = 13
  object lvDealers: TListView
    Left = 5
    Top = 5
    Width = 453
    Height = 195
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 70
      end
      item
        Caption = 'Company'
        Width = 250
      end
      item
        Caption = 'Expires'
        Width = 100
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnEditDlrClick
  end
  object btnAddDlr: TButton
    Left = 465
    Top = 26
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddDlrClick
  end
  object btnEditDlr: TButton
    Left = 465
    Top = 51
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Edit'
    TabOrder = 2
    OnClick = btnEditDlrClick
  end
  object btnDeleteDlr: TButton
    Left = 465
    Top = 76
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    TabOrder = 3
    OnClick = btnDeleteDlrClick
  end
  object btnWriteLic: TButton
    Left = 465
    Top = 106
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Write Lic File'
    TabOrder = 4
    OnClick = btnWriteLicClick
  end
  object MainMenu1: TMainMenu
    Left = 33
    Top = 30
    object Menu_File: TMenuItem
      Caption = '&File'
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = Menu_File_ExitClick
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_About: TMenuItem
        Caption = '&About'
        OnClick = Menu_Help_AboutClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'PIL'
    FileName = 'ENPLUGIN.PIL'
    Filter = 'Plug-In Licence Files|*.PIL'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 507
    Top = 152
  end
end
