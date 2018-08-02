object frmWorkstationSetup: TfrmWorkstationSetup
  Left = 257
  Top = 257
  BorderStyle = bsDialog
  Caption = 'Sentimail Workstation Settings'
  ClientHeight = 194
  ClientWidth = 277
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Tag = 16
    Left = 8
    Top = 8
    Width = 265
    Height = 153
    ActivePage = tabAlerts
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabAlerts: TTabSheet
      Caption = 'Alerts'
      ImageIndex = 3
      object Panel4: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object chkRunAlerts: TCheckBox
          Left = 24
          Top = 20
          Width = 145
          Height = 17
          Caption = 'Can run Alerts'
          TabOrder = 0
        end
        object chkRunReports: TCheckBox
          Left = 24
          Top = 52
          Width = 169
          Height = 17
          Caption = 'Can run Exchequer Reports'
          TabOrder = 1
        end
      end
    end
    object TabSheet1: TTabSheet
      Tag = 20
      Caption = 'Transport'
      object Panel1: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object chkSMS: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = 'SMS Available'
          TabOrder = 0
          OnClick = chkSMSClick
        end
        object chkEmail: TCheckBox
          Left = 16
          Top = 56
          Width = 97
          Height = 17
          Caption = 'Email Available'
          TabOrder = 1
        end
        object chkFax: TCheckBox
          Left = 120
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Fax Available'
          TabOrder = 2
        end
        object chkPrint: TCheckBox
          Left = 72
          Top = 92
          Width = 105
          Height = 17
          Caption = 'Printer Available'
          TabOrder = 3
          Visible = False
        end
        object chkFTP: TCheckBox
          Left = 120
          Top = 56
          Width = 97
          Height = 17
          Caption = 'FTP Available'
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Tag = 21
      Caption = 'Queries'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object chkHigh: TCheckBox
          Left = 24
          Top = 20
          Width = 153
          Height = 17
          Caption = 'Run High Priority Queries'
          TabOrder = 0
        end
        object chkLow: TCheckBox
          Left = 24
          Top = 52
          Width = 145
          Height = 17
          Caption = 'Run Low Priority Queries'
          TabOrder = 1
        end
      end
    end
    object TabSheet3: TTabSheet
      Tag = 27
      Caption = 'Email'
      ImageIndex = 2
      object Panel3: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label1: TLabel
          Left = 32
          Top = 12
          Width = 36
          Height = 14
          Caption = 'Server:'
        end
        object Label2: TLabel
          Left = 12
          Top = 36
          Width = 56
          Height = 14
          Caption = 'User Name:'
        end
        object Label3: TLabel
          Left = 23
          Top = 60
          Width = 45
          Height = 14
          Alignment = taRightJustify
          Caption = 'Address:'
        end
        object edtServer: TEdit
          Left = 80
          Top = 8
          Width = 145
          Height = 22
          TabOrder = 0
        end
        object edtUser: TEdit
          Left = 80
          Top = 32
          Width = 145
          Height = 22
          TabOrder = 1
        end
        object edtAddress: TEdit
          Left = 80
          Top = 56
          Width = 145
          Height = 22
          TabOrder = 2
        end
        object chkUseMapi: TCheckBox
          Left = 80
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Use MAPI'
          TabOrder = 3
        end
      end
    end
    object TabSheet5: TTabSheet
      Tag = 28
      Caption = 'Offline'
      ImageIndex = 4
      object Panel5: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label4: TLabel
          Left = 48
          Top = 16
          Width = 74
          Height = 14
          Caption = 'Offline period 1'
        end
        object Label5: TLabel
          Left = 144
          Top = 16
          Width = 74
          Height = 14
          Caption = 'Offline period 2'
        end
        object Label6: TLabel
          Left = 16
          Top = 36
          Width = 26
          Height = 14
          Alignment = taRightJustify
          Caption = 'Start:'
        end
        object Label7: TLabel
          Left = 11
          Top = 68
          Width = 31
          Height = 14
          Alignment = taRightJustify
          Caption = 'Finish:'
        end
        object edtOff1Start: TEdit
          Left = 48
          Top = 32
          Width = 81
          Height = 22
          TabOrder = 0
          OnExit = edtOff1StartExit
        end
        object edtOff2Start: TEdit
          Left = 144
          Top = 32
          Width = 81
          Height = 22
          TabOrder = 2
          OnExit = edtOff1StartExit
        end
        object edtOff2End: TEdit
          Left = 144
          Top = 64
          Width = 81
          Height = 22
          TabOrder = 3
          OnExit = edtOff1StartExit
        end
        object edtOff1End: TEdit
          Left = 48
          Top = 64
          Width = 81
          Height = 22
          TabOrder = 1
          OnExit = edtOff1StartExit
        end
      end
    end
    object tabSMS: TTabSheet
      Tag = 29
      Caption = 'SMS'
      ImageIndex = 5
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 241
        Height = 117
        Caption = 'Available SMS Senders'
        TabOrder = 0
        Visible = False
        object lbSenders: TListBox
          Left = 8
          Top = 16
          Width = 225
          Height = 93
          ItemHeight = 14
          TabOrder = 0
          OnClick = lbSendersClick
        end
      end
      object Panel6: TPanel
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Label13: TLabel
          Left = 8
          Top = 8
          Width = 225
          Height = 41
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Use the Configure button to change the settings for sending SMS ' +
            'messages.'
          WordWrap = True
        end
        object Label14: TLabel
          Left = 8
          Top = 48
          Width = 225
          Height = 33
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Use the Account button to check how much SMS credit you have lef' +
            't on your account.'
          WordWrap = True
        end
        object Label15: TLabel
          Left = 8
          Top = 88
          Width = 113
          Height = 14
          AutoSize = False
          Caption = 'Inform me when I have'
        end
        object Label16: TLabel
          Left = 168
          Top = 88
          Width = 54
          Height = 14
          Caption = 'credits left.'
        end
        object spnSmsWarn: TSpinEdit
          Left = 120
          Top = 84
          Width = 41
          Height = 23
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Polling'
      ImageIndex = 6
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 241
        Height = 113
        Caption = 'Polling interval (seconds)'
        TabOrder = 0
        object Label8: TLabel
          Left = 24
          Top = 48
          Width = 6
          Height = 14
          Caption = '0'
        end
        object Label9: TLabel
          Left = 204
          Top = 48
          Width = 12
          Height = 14
          Alignment = taRightJustify
          Caption = '10'
        end
        object lblInterval: TLabel
          Left = 96
          Top = 40
          Width = 45
          Height = 14
          Alignment = taCenter
          Caption = 'lblInterval'
        end
        object tbPollSpeed: TTrackBar
          Left = 16
          Top = 64
          Width = 209
          Height = 33
          Max = 20
          Orientation = trHorizontal
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 0
          TickMarks = tmBottomRight
          TickStyle = tsAuto
          OnChange = tbPollSpeedChange
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Administrator'
      ImageIndex = 7
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 241
        Height = 105
        Caption = 'Notify errors to the following:'
        TabOrder = 0
        object Label10: TLabel
          Left = 22
          Top = 20
          Width = 27
          Height = 14
          Caption = 'Email:'
        end
        object Label11: TLabel
          Left = 24
          Top = 52
          Width = 25
          Height = 14
          Caption = 'SMS:'
        end
        object Label12: TLabel
          Left = 4
          Top = 80
          Width = 229
          Height = 14
          Alignment = taCenter
          AutoSize = False
          Caption = '(Notification settings apply to all workstations)'
          WordWrap = True
        end
        object edtAdminEmail: TEdit
          Left = 56
          Top = 16
          Width = 153
          Height = 22
          TabOrder = 0
        end
        object edtAdminSMS: TEdit
          Left = 56
          Top = 48
          Width = 153
          Height = 22
          TabOrder = 1
        end
      end
    end
  end
  object Button1: TButton
    Left = 144
    Top = 168
    Width = 61
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object btnCancel: TButton
    Left = 212
    Top = 168
    Width = 61
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnRegister: TButton
    Left = 8
    Top = 168
    Width = 61
    Height = 25
    Caption = '&Account'
    TabOrder = 3
    Visible = False
    OnClick = btnRegisterClick
  end
  object btnSetupSMS: TButton
    Left = 76
    Top = 168
    Width = 61
    Height = 25
    Caption = '&Configure'
    TabOrder = 4
    Visible = False
    OnClick = btnSetupSMSClick
  end
end
