object dmPoll: TdmPoll
  Left = 150
  Top = 196
  Width = 696
  Height = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Email1: TEmail
    DownLoadFirst = True
    NewSession = False
    TruncAttFN = False
    UnreadOnly = True
    UseDefProfile = True
    Left = 21
    Top = 61
  end
  object msMessage1: TmsMessage
    ContentType = 'text/plain'
    Version = '2.02'
    ReturnReceipt = False
    Left = 96
    Top = 8
  end
  object msPOP1: TmsPOPClient
    Version = '2.02'
    Port = 110
    MailMessage = msMessage1
    Left = 168
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 24
    Top = 16
  end
end
