object frmRange: TfrmRange
  Left = 266
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Set File / Version on Var Range'
  ClientHeight = 234
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape4: TShape
    Left = 8
    Top = 48
    Width = 297
    Height = 145
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape1: TShape
    Left = 8
    Top = 8
    Width = 89
    Height = 41
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Label1: TLabel
    Left = 16
    Top = 22
    Width = 73
    Height = 13
    Caption = 'Var No Range :'
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 49
    Height = 13
    Caption = 'Property :'
  end
  object Shape2: TShape
    Left = 96
    Top = 64
    Width = 193
    Height = 57
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape3: TShape
    Left = 96
    Top = 120
    Width = 193
    Height = 57
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Label3: TLabel
    Left = 16
    Top = 200
    Width = 38
    Height = 13
    Caption = 'Set To :'
  end
  object Label4: TLabel
    Left = 104
    Top = 22
    Width = 31
    Height = 13
    Caption = 'From :'
  end
  object Label5: TLabel
    Left = 208
    Top = 22
    Width = 19
    Height = 13
    Caption = 'To :'
  end
  object Shape7: TShape
    Left = 8
    Top = 192
    Width = 89
    Height = 33
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape6: TShape
    Left = 96
    Top = 8
    Width = 209
    Height = 41
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape5: TShape
    Left = 96
    Top = 192
    Width = 209
    Height = 33
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object edVarStart: TCurrencyEdit
    Left = 144
    Top = 16
    Width = 49
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edVarEnd: TCurrencyEdit
    Left = 240
    Top = 16
    Width = 49
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object rbFile: TRadioButton
    Left = 104
    Top = 56
    Width = 41
    Height = 17
    Caption = 'File'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = ThingsChange
  end
  object rbVersion: TRadioButton
    Left = 104
    Top = 112
    Width = 57
    Height = 17
    Caption = 'Version'
    TabOrder = 3
    OnClick = ThingsChange
  end
  object cmbFile: TComboBox
    Left = 112
    Top = 80
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ThingsChange
  end
  object cmbVersion: TComboBox
    Left = 112
    Top = 136
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = ThingsChange
  end
  object cbSetTo: TCheckBox
    Left = 104
    Top = 200
    Width = 97
    Height = 17
    Caption = 'Unselected'
    TabOrder = 6
  end
  object btnOK: TButton
    Left = 312
    Top = 32
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 312
    Top = 8
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
end
