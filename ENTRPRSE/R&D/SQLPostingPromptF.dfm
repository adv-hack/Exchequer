object frmSQLPostingPrompt: TfrmSQLPostingPrompt
  Left = 535
  Top = 370
  HelpContext = 2315
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Check SQL Posting Compatibility'
  ClientHeight = 134
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 5
    Top = 5
    Width = 430
    Height = 28
    Caption = 
      'The SQL Posting Optimisations are currently disabled for this co' +
      'mpany and the system is configured to use the original Exchequer' +
      ' Posting routines.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 5
    Top = 39
    Width = 401
    Height = 28
    Caption = 
      'The SQL Posting Optimisations, which shall deliver significant p' +
      'osting performance improvements, can be enabled by running a Dat' +
      'a Validation Check on this company.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 5
    Top = 73
    Width = 418
    Height = 28
    Caption = 
      'The Data Validation Check can be run by clicking the '#39'Run Check ' +
      'Now'#39' button below or using the '#39'Check SQL Posting Compatibility'#39 +
      ' menu option on the Utilities menu.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object btnRunCheckNow: TButton
    Left = 7
    Top = 108
    Width = 100
    Height = 21
    Caption = 'Run Check Now'
    TabOrder = 0
    OnClick = btnRunCheckNowClick
  end
  object btnAskLater: TButton
    Left = 117
    Top = 108
    Width = 100
    Height = 21
    Caption = 'Ask Later'
    TabOrder = 1
    OnClick = btnAskLaterClick
  end
  object btnHide: TButton
    Left = 227
    Top = 108
    Width = 100
    Height = 21
    Caption = 'Hide'
    TabOrder = 2
    OnClick = btnHideClick
  end
  object btnMoreInfo: TButton
    Left = 337
    Top = 108
    Width = 100
    Height = 21
    Caption = 'More Info'
    TabOrder = 3
    OnClick = btnMoreInfoClick
  end
end
