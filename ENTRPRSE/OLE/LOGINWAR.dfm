object Form_LogonWarn: TForm_LogonWarn
  Left = 548
  Top = 230
  HelpContext = 1002
  ActiveControl = btnYes
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Cancel Company Login'
  ClientHeight = 155
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 6
    Top = 9
    Width = 32
    Height = 32
  end
  object Label81: Label8
    Left = 46
    Top = 105
    Width = 209
    Height = 14
    Caption = 'Are you sure you want to cancel the login?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 46
    Top = 8
    Width = 292
    Height = 34
    AutoSize = False
    Caption = 
      'If you cancel this company login then all subsequent logins will' +
      ' be cancelled automatically.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label83: Label8
    Left = 45
    Top = 48
    Width = 292
    Height = 52
    AutoSize = False
    Caption = 
      'Normal Logins can be restored by selecting the '#39'Reset &Login Ski' +
      'pping'#39' option on the OLE Server'#39's System Menu. See the On-Line H' +
      'elp for further details.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object btnYes: TButton
    Left = 93
    Top = 128
    Width = 80
    Height = 21
    Caption = '&Yes'
    Default = True
    ModalResult = 6
    TabOrder = 0
  end
  object btnNo: TButton
    Left = 186
    Top = 128
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&No'
    ModalResult = 7
    TabOrder = 1
  end
end
