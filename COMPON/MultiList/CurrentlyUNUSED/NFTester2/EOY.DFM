object frmEOY: TfrmEOY
  Left = 385
  Top = 252
  Width = 272
  Height = 211
  Caption = 'End of Year'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 104
    Height = 14
    Caption = 'End of year routine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 241
    Height = 70
    Caption = 
      'This utility will delete any invoices dated before the date show' +
      ' below. Also any expired members still on the system will be rem' +
      'oved if possible.                                               ' +
      '                                     Click on OK to Continue.'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 8
    Top = 116
    Width = 108
    Height = 14
    Caption = 'Delete all data before :'
  end
  object btnCancel: TButton
    Left = 192
    Top = 152
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 120
    Top = 152
    Width = 65
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object edDate: TDateTimePicker
    Left = 120
    Top = 112
    Width = 138
    Height = 22
    CalAlignment = dtaLeft
    Date = 37754.6268557292
    Time = 37754.6268557292
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
  end
end
