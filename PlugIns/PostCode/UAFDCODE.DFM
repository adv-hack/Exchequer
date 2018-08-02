object frmPostcodes: TfrmPostcodes
  Left = 312
  Top = 175
  BorderStyle = bsDialog
  Caption = 'PostCode xxx xxx'
  ClientHeight = 301
  ClientWidth = 411
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
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 411
    Height = 22
    Align = alTop
    Shape = bsSpacer
  end
  object Label1: TLabel
    Left = 6
    Top = 4
    Width = 399
    Height = 13
    Caption = 
      'The PostCode has returned multiple addresses. Please select one ' +
      'from the list below:'
  end
  object lvAddresses: TListView
    Left = 0
    Top = 22
    Width = 411
    Height = 248
    Align = alTop
    Columns = <
      item
        Caption = 'Street'
        Width = 150
      end
      item
        Caption = 'Locality'
        Width = 120
      end
      item
        Caption = 'Town'
        Width = 120
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnKeyDown = lvAddressesKeyDown
  end
  object bnCancel: TButton
    Left = 214
    Top = 276
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object bnOK: TButton
    Left = 118
    Top = 276
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
end
