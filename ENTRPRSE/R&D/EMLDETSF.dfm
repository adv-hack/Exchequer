object frmEmailDets: TfrmEmailDets
  Left = 461
  Top = 228
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Email Details'
  ClientHeight = 122
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label81: Label8
    Left = 27
    Top = 8
    Width = 23
    Height = 14
    Caption = 'Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 24
    Top = 35
    Width = 27
    Height = 14
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 9
    Top = 62
    Width = 42
    Height = 14
    Caption = 'Address'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object edtName: Text8Pt
    Left = 55
    Top = 32
    Width = 235
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 50
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnDblClick = edtNameDblClick
    OnExit = edtNameExit
    TextId = 0
    ViaSBtn = False
    ShowHilight = True
  end
  object edtAddr: Text8Pt
    Left = 55
    Top = 59
    Width = 235
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 100
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object lstTo: TSBSComboBox
    Left = 55
    Top = 5
    Width = 57
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    Items.Strings = (
      'TO'
      'CC')
    MaxListWidth = 0
  end
  object btnOK: TSBSButton
    Left = 64
    Top = 94
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 158
    Top = 94
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
    TextId = 0
  end
  object SpellCheck4Modal1: TSpellCheck4Modal
    Version = 'TSpellCheck4Modal v5.70.001 for Delphi 6.01'
    Left = 200
    Top = 12
  end
end
