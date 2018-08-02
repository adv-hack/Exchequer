object frmEmailAddForm: TfrmEmailAddForm
  Left = 290
  Top = 182
  BorderStyle = bsDialog
  Caption = 'Email Recipients'
  ClientHeight = 327
  ClientWidth = 448
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 74
    Height = 14
    Caption = 'Email recipients'
  end
  object Label2: TLabel
    Left = 8
    Top = 300
    Width = 27
    Height = 14
    Caption = 'Type:'
  end
  object lvEmContacts: TListView
    Left = 8
    Top = 24
    Width = 361
    Height = 265
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Address'
        Tag = 1
        Width = 207
      end>
    Items.Data = {
      6C0000000200000000000000FFFFFFFFFFFFFFFF01000000000000000F506175
      6C20527574686572666F72640C7061756C4065656B2E636F6D00000000FFFFFF
      FFFFFFFFFF01000000000000000A4120416172647661726B0F61614061617264
      7661726B2E636F6DFFFFFFFF}
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvEmContactsColumnClick
    OnCompare = lvEmContactsCompare
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
  object cbType: TComboBox
    Left = 48
    Top = 296
    Width = 57
    Height = 22
    ItemHeight = 14
    TabOrder = 3
    Text = 'To'
    Items.Strings = (
      'To'
      'CC'
      'BCC')
  end
end
