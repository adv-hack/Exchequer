object frmFTP: TfrmFTP
  Left = 462
  Top = 318
  Width = 112
  Height = 68
  Caption = 'FTP Transfers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object msFTPClient: TmsFTPClient
    Version = '2.01'
    TimeOut = 30
    OnConnected = msFTPClientConnected
    OnDisconnected = msFTPClientDisconnected
    Port = 21
    OnTransferProgress = msFTPClientTransferProgress
    OnConnecting = msFTPClientConnecting
    UserName = 'USER'
    Password = '0123456789'
    PassiveMode = True
    ServerType = stAuto
    TransferType = ttBinary
    Proxy = 'ntbox'
    ProxyPort = 21
    ProxyType = fpUserNoLogon
    OnDataTransferStart = msFTPClientDataTransferStart
    OnDataTransferTerminate = msFTPClientDataTransferTerminate
    OnDataTransferProgress = msFTPClientDataTransferProgress
    OnLineSent = msFTPClientLineSent
    OnLineReceived = msFTPClientLineReceived
    Left = 8
    Top = 8
  end
  object FTPTimeoutCheck: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = FTPTimeoutCheckTimer
    Left = 40
    Top = 8
  end
end
