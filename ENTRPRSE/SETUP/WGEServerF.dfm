inherited frmWorkgroupServerWarning: TfrmWorkgroupServerWarning
  Caption = 'frmWorkgroupServerWarning'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Warning'
  end
  inherited InstrLbl: TLabel
    Height = 44
    Caption = 
      'When using the Pervasive.SQL Workgroup Engine you must run the U' +
      'pgrade on the workstation that is to be used as the Workgroup Se' +
      'rver.'
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 96
    Width = 285
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The last workstation recorded as being setup as the Workgroup Se' +
      'rver was <WG_PREVSERVERPC>.'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 129
    Width = 285
    Height = 43
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you continue with this Upgrade on this workstation then this ' +
      'workstation will be setup as the Workgroup Server instead, this ' +
      'may cause you problems accessing data.'
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 167
    Top = 174
    Width = 285
    Height = 55
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Press the Next button to continue the Upgrade and setup this wor' +
      'kstation as the Workgroup Server or press the Exit Installation ' +
      'button now if you do not want to continue with the Upgrade.'
    WordWrap = True
  end
  inherited BackBtn: TButton
    Visible = False
  end
end
