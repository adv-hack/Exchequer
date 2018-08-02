object frmSMSAdd: TfrmSMSAdd
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'SMS Recipients'
  ClientHeight = 327
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 72
    Height = 14
    Caption = 'SMS recipients'
  end
  object lvSMSContacts: TListView
    Left = 8
    Top = 24
    Width = 361
    Height = 297
    Columns = <
      item
        Caption = 'Name'
        Width = 160
      end
      item
        Caption = 'Number'
        Width = 170
      end>
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvSMSContactsColumnClick
    OnCompare = lvSMSContactsCompare
    OnDblClick = Button1Click
  end
  object Button1: TButton
    Left = 376
    Top = 24
    Width = 65
    Height = 25
    Caption = '&Select'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 376
    Top = 56
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
