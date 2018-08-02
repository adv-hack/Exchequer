object frmDateFormat: TfrmDateFormat
  Left = 446
  Top = 228
  BorderStyle = bsDialog
  Caption = 'Set Date Format'
  ClientHeight = 133
  ClientWidth = 214
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 201
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 60
    Width = 39
    Height = 14
    Caption = 'Format :'
  end
  object Label2: TLabel
    Left = 24
    Top = 28
    Width = 54
    Height = 14
    Caption = 'Separator :'
  end
  object cmbFormat: TComboBox
    Left = 80
    Top = 56
    Width = 113
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 0
    Text = 'dd/mm/yyyy'
    Items.Strings = (
      'dd/mm/yyyy'
      'dd/mm/yy'
      'dd/mmm/yyyy'
      'dd/mmm/yy'
      'mm/dd/yyyy'
      'mm/dd/yy'
      'mmm/dd/yyyy'
      'mmm/dd/yy'
      'yyyy/mm/dd'
      'yy/mm/dd'
      'yyyy/mmm/dd'
      'yy/mmm/dd'
      'yyyy/dd/mm'
      'yy/dd/mm'
      'yyyy/dd/mmm'
      'yy/dd/mmm')
  end
  object cmbSeparator: TComboBox
    Left = 80
    Top = 24
    Width = 113
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 1
    Text = '/'
    OnChange = cmbSeparatorChange
    Items.Strings = (
      '/'
      '.'
      '-'
      '(none)')
  end
  object Button1: TButton
    Left = 72
    Top = 104
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 144
    Top = 104
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object pmMain: TPopupMenu
    Left = 8
    Top = 8
    object Properties2: TMenuItem
      Caption = 'Properties'
      OnClick = Properties2Click
    end
    object SaveCoordinates2: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
