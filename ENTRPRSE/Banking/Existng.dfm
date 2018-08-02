object frmIncomplete: TfrmIncomplete
  Left = 237
  Top = 114
  HelpContext = 1910
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Incomplete Reconciliation'
  ClientHeight = 181
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 137
    HelpContext = 1910
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblDate: TLabel
      Left = 16
      Top = 8
      Width = 225
      Height = 49
      HelpContext = 1910
      AutoSize = False
      Caption = 
        'You stored an incomplete reconciliation for this bank account on' +
        ' 01/01/2006. '
      WordWrap = True
    end
    object Label2: TLabel
      Left = 16
      Top = 60
      Width = 74
      Height = 14
      Caption = 'Do you want to'
    end
    object rbFinish: TBorRadio
      Left = 32
      Top = 80
      Width = 193
      Height = 20
      HelpContext = 1910
      Align = alRight
      Caption = 'Finish the incomplete reconciliation?'
      TabOrder = 0
      TextId = 0
    end
    object rbStart: TBorRadio
      Left = 32
      Top = 104
      Width = 185
      Height = 20
      HelpContext = 1910
      Align = alRight
      Caption = 'Start a new reconciliation?'
      TabOrder = 1
      TextId = 0
    end
  end
  object SBSButton1: TSBSButton
    Left = 96
    Top = 152
    Width = 80
    Height = 21
    HelpContext = 1910
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
end
