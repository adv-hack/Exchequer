object frmFieldDetails: TfrmFieldDetails
  Left = 151
  Top = 103
  BorderStyle = bsDialog
  Caption = 'frmFieldDetails'
  ClientHeight = 519
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape3: TShape
    Left = 360
    Top = 16
    Width = 353
    Height = 465
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape6: TShape
    Left = 360
    Top = 16
    Width = 169
    Height = 465
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape2: TShape
    Left = 8
    Top = 224
    Width = 353
    Height = 145
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape1: TShape
    Left = 8
    Top = 16
    Width = 137
    Height = 209
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object lFieldNAme: TLabel
    Left = 16
    Top = 68
    Width = 57
    Height = 13
    Caption = 'Field Code :'
  end
  object Label1: TLabel
    Left = 16
    Top = 36
    Width = 63
    Height = 13
    Caption = 'Var Number :'
  end
  object Label2: TLabel
    Left = 16
    Top = 92
    Width = 60
    Height = 13
    Caption = 'Description :'
  end
  object Label3: TLabel
    Left = 16
    Top = 236
    Width = 57
    Height = 13
    Caption = 'Data Type :'
  end
  object Label4: TLabel
    Left = 16
    Top = 260
    Width = 40
    Height = 13
    Caption = 'Length :'
  end
  object Label5: TLabel
    Left = 16
    Top = 284
    Width = 105
    Height = 13
    Caption = 'Fixed Decimal Places :'
  end
  object Label6: TLabel
    Left = 16
    Top = 116
    Width = 120
    Height = 13
    Caption = 'Title default on Reports :'
  end
  object Label7: TLabel
    Left = 16
    Top = 140
    Width = 68
    Height = 13
    Caption = 'Format Mask :'
  end
  object Label8: TLabel
    Left = 16
    Top = 172
    Width = 60
    Height = 13
    Caption = 'Input Type :'
  end
  object Label9: TLabel
    Left = 368
    Top = 8
    Width = 74
    Height = 13
    Caption = 'Available Files :'
  end
  object Label10: TLabel
    Left = 536
    Top = 8
    Width = 96
    Height = 13
    Caption = 'Exchequer Version :'
  end
  object lVarDecPlaceType: TLabel
    Left = 16
    Top = 340
    Width = 125
    Height = 13
    Caption = 'Variable Dec. Place Type :'
  end
  object Label12: TLabel
    Left = 16
    Top = 8
    Width = 67
    Height = 13
    Caption = 'Field Details : '
  end
  object Shape4: TShape
    Left = 144
    Top = 16
    Width = 217
    Height = 209
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object Shape5: TShape
    Left = 144
    Top = 224
    Width = 217
    Height = 145
    Brush.Style = bsClear
    Pen.Color = clOlive
  end
  object edFieldCode: TEdit
    Left = 160
    Top = 64
    Width = 121
    Height = 21
    MaxLength = 8
    TabOrder = 1
    OnExit = edFieldCodeExit
  end
  object edDescription: TEdit
    Left = 160
    Top = 88
    Width = 185
    Height = 21
    MaxLength = 30
    TabOrder = 2
    OnExit = edDescriptionExit
  end
  object cmbDataType: TComboBox
    Left = 160
    Top = 232
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnChange = cmbDataTypeChange
  end
  object edLength: TCurrencyEdit
    Left = 160
    Top = 256
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
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object edFixedDPs: TCurrencyEdit
    Left = 160
    Top = 280
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
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object btnOK: TButton
    Left = 544
    Top = 488
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 14
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 632
    Top = 488
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 15
    OnClick = btnCancelClick
  end
  object edRepTitle: TEdit
    Left = 160
    Top = 112
    Width = 185
    Height = 21
    MaxLength = 30
    TabOrder = 3
  end
  object cbVariableDPs: TCheckBox
    Left = 160
    Top = 316
    Width = 135
    Height = 17
    Caption = 'Variable Decimal Places'
    TabOrder = 10
    OnClick = cbVariableDPsClick
  end
  object cmbVarDecType: TComboBox
    Left = 160
    Top = 336
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
  end
  object edFormatMask: TEdit
    Left = 160
    Top = 136
    Width = 185
    Height = 21
    MaxLength = 30
    TabOrder = 4
  end
  object cbPeriodSelect: TCheckBox
    Left = 160
    Top = 196
    Width = 113
    Height = 17
    Caption = 'Period Selectable'
    TabOrder = 6
    OnClick = cbVariableDPsClick
  end
  object cmbInputType: TComboBox
    Left = 160
    Top = 168
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object lbAvailableFiles: TCheckListBox
    Left = 368
    Top = 24
    Width = 153
    Height = 449
    ItemHeight = 13
    PopupMenu = pmFiles
    TabOrder = 12
  end
  object lbExchVersions: TCheckListBox
    Left = 536
    Top = 24
    Width = 169
    Height = 449
    ItemHeight = 13
    PopupMenu = pmVersions
    TabOrder = 13
  end
  object edVarNo: TCurrencyEdit
    Left = 160
    Top = 32
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
  object pmFiles: TPopupMenu
    Left = 376
    Top = 32
    object SelectAll1: TMenuItem
      Tag = 2
      Caption = 'Select All'
      OnClick = SelectDeselectAll
    end
    object DeselectAll1: TMenuItem
      Caption = 'Deselect All'
      OnClick = SelectDeselectAll
    end
  end
  object pmVersions: TPopupMenu
    Left = 544
    Top = 32
    object MenuItem1: TMenuItem
      Tag = 3
      Caption = 'Select All'
      OnClick = SelectDeselectAll
    end
    object MenuItem2: TMenuItem
      Tag = 1
      Caption = 'Deselect All'
      OnClick = SelectDeselectAll
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelectAllProfessional1: TMenuItem
      Caption = 'Select All Professional'
      OnClick = SelectAllProfessional1Click
    end
    object SelectAllMultiCurrency1: TMenuItem
      Caption = 'Select All Multi-Currency'
      OnClick = SelectAllMultiCurrency1Click
    end
    object SelectAllStock1: TMenuItem
      Caption = 'Select All Stock'
      OnClick = SelectAllStock1Click
    end
    object SelectAllSPOP1: TMenuItem
      Caption = 'Select All SPOP'
      OnClick = SelectAllSPOP1Click
    end
    object SelectAllJC1: TMenuItem
      Caption = 'Select All JC'
      OnClick = SelectAllJC1Click
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 376
  end
end
