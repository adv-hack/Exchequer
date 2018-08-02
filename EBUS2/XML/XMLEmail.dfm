object dmoXMLPolling: TdmoXMLPolling
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 188
  Top = 121
  Height = 266
  Width = 482
  object tmrPoll: TTimer
    Enabled = False
    OnTimer = tmrPollTimer
    Left = 25
    Top = 8
  end
  object msPOP1: TmsPOPClient
    Version = '2.1'
    Port = 110
    MailMessage = msMessage1
    Left = 168
    Top = 8
  end
  object msMessage1: TmsMessage
    ContentType = 'text/plain'
    Version = '2.1'
    ReturnReceipt = False
    Left = 96
    Top = 8
  end
  object Blowfish1: TBlowfish
    CipherMode = CBC
    StringMode = smEncode
    Left = 72
    Top = 64
  end
end
