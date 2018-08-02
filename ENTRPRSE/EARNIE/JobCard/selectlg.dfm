object frmSelectLog: TfrmSelectLog
  Left = 318
  Top = 147
  BorderStyle = bsDialog
  Caption = 'Select Log File'
  ClientHeight = 352
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 91
    Height = 13
    Caption = 'Available Log  Files'
  end
  object lvLogs: TListView
    Left = 8
    Top = 24
    Width = 249
    Height = 313
    Columns = <
      item
        Caption = 'Company'
        Width = 60
      end
      item
        Caption = 'Payroll ID'
        Width = 65
      end
      item
        Caption = 'Date/Time'
        Width = 120
      end
      item
        Caption = 'Filename'
        Width = 200
      end>
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvLogsDblClick
  end
  object SBSButton1: TSBSButton
    Left = 264
    Top = 24
    Width = 80
    Height = 21
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object btnView: TSBSButton
    Left = 264
    Top = 88
    Width = 80
    Height = 21
    Caption = '&View'
    TabOrder = 2
    OnClick = btnViewClick
    TextId = 0
  end
  object SBSButton3: TSBSButton
    Left = 264
    Top = 120
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = SBSButton3Click
    TextId = 0
  end
end
