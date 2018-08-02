object WarnUsrs: TWarnUsrs
  Left = 425
  Top = 136
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Other users detected.'
  ClientHeight = 256
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 7
    Top = 9
    Width = 468
    Height = 47
    AutoSize = False
    Caption = 
      'The following users are currently working on this screen.  Altho' +
      'ugh you will be able to work in this screen at the same time, th' +
      'e ReCalc && Process options will not be available until the othe' +
      'r users leave this screen.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lvList: TListView
    Left = 8
    Top = 66
    Width = 465
    Height = 142
    Color = clWhite
    Columns = <
      item
        Caption = 'Username'
        Width = 95
      end
      item
        Caption = 'as at'
        Width = 80
      end
      item
        Caption = 'Time'
        Width = 70
      end
      item
        Caption = 'Windows Logon'
        Width = 100
      end
      item
        Caption = 'CPU Name'
        Width = 100
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnOK: TButton
    Left = 400
    Top = 221
    Width = 73
    Height = 25
    Cancel = True
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
end
