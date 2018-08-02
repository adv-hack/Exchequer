object fraInstallPerv: TfraInstallPerv
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 324
    Height = 20
    Caption = 'Install Pervasive.SQL Workgroup Engine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblIntro: TLabel
    Left = 9
    Top = 27
    Width = 494
    Height = 33
    AutoSize = False
    Caption = 
      'The Pervasive.SQL Workgroup Engine is now being installed, depen' +
      'ding on the speed of this machine this will take several minutes' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblInfo: TLabel
    Left = 108
    Top = 133
    Width = 279
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Installing Workgroup Engine, Please Wait...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Animate1: TAnimate
    Left = 111
    Top = 67
    Width = 272
    Height = 60
    Active = True
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
end
