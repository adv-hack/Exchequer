object frmEngines: TfrmEngines
  Left = 192
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Sentimail engines running'
  ClientHeight = 224
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 241
    Height = 209
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 217
      Height = 33
      AutoSize = False
      Caption = 'Sentimail engines are currently providing these functions:'
      WordWrap = True
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 40
      Width = 105
      Height = 153
      Caption = 'Transport'
      TabOrder = 0
      object chkEmail: TCheckBox
        Left = 16
        Top = 24
        Width = 57
        Height = 17
        Caption = 'Email'
        TabOrder = 0
      end
      object chkSMS: TCheckBox
        Left = 16
        Top = 53
        Width = 57
        Height = 17
        Caption = 'SMS'
        TabOrder = 1
      end
      object chkFax: TCheckBox
        Left = 16
        Top = 82
        Width = 57
        Height = 17
        Caption = 'Fax'
        TabOrder = 2
      end
      object chkFTP: TCheckBox
        Left = 16
        Top = 112
        Width = 49
        Height = 17
        Caption = 'FTP'
        TabOrder = 3
      end
    end
    object GroupBox2: TGroupBox
      Left = 120
      Top = 40
      Width = 105
      Height = 73
      Caption = 'Sentinel types'
      TabOrder = 1
      object chkAlerts: TCheckBox
        Left = 16
        Top = 24
        Width = 73
        Height = 17
        Caption = 'Alerts'
        TabOrder = 0
      end
      object chkReports: TCheckBox
        Left = 16
        Top = 48
        Width = 65
        Height = 17
        Caption = 'Reports'
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 120
      Top = 120
      Width = 105
      Height = 73
      Caption = 'Priority'
      TabOrder = 2
      object chkHigh: TCheckBox
        Left = 16
        Top = 24
        Width = 57
        Height = 17
        Caption = 'High'
        TabOrder = 0
      end
      object chkLow: TCheckBox
        Left = 16
        Top = 48
        Width = 57
        Height = 17
        Caption = 'Low'
        TabOrder = 1
      end
    end
  end
  object Button1: TButton
    Left = 256
    Top = 8
    Width = 73
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
  end
end
