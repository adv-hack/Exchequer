object frmFtp: TfrmFtp
  Left = 415
  Top = 330
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Sentimail'
  ClientHeight = 105
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 217
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Please wait...sending file'
  end
  object FtpClient: TmsFTPClient
    Version = '2.1'
    Port = 21
    Blocking = True
    PassiveMode = False
    ServerType = stAuto
    TransferType = ttBinary
    ProxyPort = 0
    ProxyType = fpUserNoLogon
    OnLineSent = FtpClientLineSent
    OnLineReceived = FtpClientLineReceived
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 40
    Top = 8
  end
end
