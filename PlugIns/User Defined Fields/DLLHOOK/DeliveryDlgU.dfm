object DeliveryDlg: TDeliveryDlg
  Left = 273
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Delivery details'
  ClientHeight = 112
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object DeliveryGrp: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 93
    TabOrder = 0
    object DeliveryDateLbl: TLabel
      Left = 8
      Top = 14
      Width = 63
      Height = 14
      Caption = 'Delivery date'
    end
    object BookinTimeLbl: TLabel
      Left = 8
      Top = 64
      Width = 58
      Height = 14
      Caption = 'Book-in time'
    end
    object WeekCommencingChk: TCheckBox
      Left = 80
      Top = 36
      Width = 121
      Height = 17
      Caption = ' Week commencing'
      TabOrder = 0
    end
    object BookInTimePicker: TDateTimePicker
      Left = 80
      Top = 60
      Width = 61
      Height = 22
      CalAlignment = dtaLeft
      Date = 39072.6041666667
      Format = 'HH:mm'
      Time = 39072.6041666667
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 1
    end
    object DeliveryDateDisplayLbl: TStaticText
      Left = 80
      Top = 12
      Width = 121
      Height = 18
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = ' 11/12/2006 (Tues)'
      TabOrder = 2
    end
  end
  object OkBtn: TButton
    Left = 224
    Top = 16
    Width = 80
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 224
    Top = 44
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 224
    Top = 72
  end
end
