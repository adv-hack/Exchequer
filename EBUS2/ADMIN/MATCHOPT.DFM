object frmMatchOptions: TfrmMatchOptions
  Left = 295
  Top = 214
  Width = 492
  Height = 202
  BorderIcons = [biSystemMenu]
  Caption = 'Matching Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 400
    Top = 14
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 400
    Top = 38
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 161
    Caption = 'Show lines within these ranges  '
    TabOrder = 2
    object Label1: TLabel
      Left = 112
      Top = 26
      Width = 113
      Height = 13
      AutoSize = False
      Caption = 'Start'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 248
      Top = 26
      Width = 113
      Height = 13
      AutoSize = False
      Caption = 'End'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object chkAc: TCheckBox
      Left = 16
      Top = 42
      Width = 95
      Height = 17
      Caption = 'Account Code'
      TabOrder = 0
    end
    object edtAcCode1: TEdit
      Left = 112
      Top = 40
      Width = 113
      Height = 21
      TabOrder = 1
    end
    object edtAcCode2: TEdit
      Left = 248
      Top = 40
      Width = 113
      Height = 21
      TabOrder = 2
    end
    object chkStock: TCheckBox
      Left = 16
      Top = 82
      Width = 81
      Height = 17
      Caption = 'Stock Code'
      TabOrder = 3
    end
    object edtStockCode1: TEdit
      Left = 112
      Top = 80
      Width = 113
      Height = 21
      TabOrder = 4
    end
    object edtStockCode2: TEdit
      Left = 248
      Top = 80
      Width = 113
      Height = 21
      TabOrder = 5
    end
    object chkDate: TCheckBox
      Left = 16
      Top = 118
      Width = 105
      Height = 17
      Caption = 'Date Range'
      TabOrder = 6
    end
    object dtpDate1: TExtendedDateTimePicker
      Left = 112
      Top = 116
      Width = 113
      Height = 21
      CalAlignment = dtaLeft
      Date = 18264.5693502893
      Time = 18264.5693502893
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 7
      OnDropDown = dtpDate1DropDown
    end
    object dtpDate2: TExtendedDateTimePicker
      Left = 248
      Top = 116
      Width = 113
      Height = 21
      CalAlignment = dtaLeft
      Date = 54788.5694363657
      Time = 54788.5694363657
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 8
      OnDropDown = dtpDate1DropDown
    end
  end
end
