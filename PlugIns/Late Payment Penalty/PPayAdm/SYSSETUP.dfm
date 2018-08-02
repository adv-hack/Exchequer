object frmSystemSetup: TfrmSystemSetup
  Left = 362
  Top = 300
  BorderStyle = bsDialog
  Caption = 'System Setup'
  ClientHeight = 141
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 139
    Height = 14
    Caption = 'Days Interest Charged Field :'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 114
    Height = 14
    Caption = 'Custom Hold Flag Field :'
  end
  object cmbDaysField: TComboBox
    Left = 150
    Top = 8
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 0
    Text = 'User Defined Field #1'
    Items.Strings = (
      'User Defined Field #1'
      'User Defined Field #2'
      'User Defined Field #3'
      'User Defined Field #4')
  end
  object cmbHoldFlagField: TComboBox
    Left = 150
    Top = 40
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 1
    Text = 'User Defined Field #1'
    Items.Strings = (
      'User Defined Field #1'
      'User Defined Field #2'
      'User Defined Field #3'
      'User Defined Field #4')
  end
  object btnCancel: TButton
    Left = 208
    Top = 112
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 120
    Top = 112
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object cbBaseInterestOnDueDate: TCheckBox
    Left = 120
    Top = 80
    Width = 161
    Height = 17
    Caption = 'Base Interest On Due Date'
    TabOrder = 4
  end
  object pmMain: TPopupMenu
    Left = 8
    Top = 104
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
