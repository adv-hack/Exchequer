object frmLineProperties: TfrmLineProperties
  Left = 320
  Top = 138
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Line Properties'
  ClientHeight = 275
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object lblColor: TLabel
    Left = 13
    Top = 15
    Width = 31
    Height = 14
    Caption = 'Color :'
  end
  object edtLineStyle: TLabeledEdit
    Left = 168
    Top = 30
    Width = 105
    Height = 22
    EditLabel.Width = 53
    EditLabel.Height = 14
    EditLabel.Caption = 'Line Style :'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 0
  end
  object edtLineWidth: TLabeledEdit
    Left = 285
    Top = 30
    Width = 55
    Height = 22
    EditLabel.Width = 33
    EditLabel.Height = 14
    EditLabel.Caption = 'Width :'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 1
  end
  object cbColor: TColorBox
    Left = 13
    Top = 30
    Width = 145
    Height = 22
    Style = [cbStandardColors, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 170
    Top = 170
    Width = 80
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 260
    Top = 170
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object lbStyle: TListBox
    Left = 168
    Top = 60
    Width = 105
    Height = 74
    IntegralHeight = True
    ItemHeight = 14
    Items.Strings = (
      'Solid'
      'Dash'
      'Dot'
      'Dash Dot'
      'Dash Dot Dot')
    TabOrder = 5
  end
  object lbWidth: TListBox
    Left = 285
    Top = 60
    Width = 55
    Height = 74
    IntegralHeight = True
    ItemHeight = 14
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    TabOrder = 6
  end
  object sbSample: TGroupBox
    Left = 13
    Top = 160
    Width = 145
    Height = 95
    Caption = ' Sample '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    object shSample: TShape
      Left = 10
      Top = 25
      Width = 125
      Height = 55
      Brush.Color = clBtnFace
    end
  end
  object rgOrientation: TRadioGroup
    Left = 13
    Top = 60
    Width = 145
    Height = 95
    Caption = 'Line Orientation'
    ItemIndex = 1
    Items.Strings = (
      'Vertical'
      'Horizontial')
    TabOrder = 8
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.01 for Delphi 6.01'
    Left = 186
    Top = 201
  end
end
