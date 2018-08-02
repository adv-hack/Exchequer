inherited frmServerPCName: TfrmServerPCName
  ActiveControl = lstServerName
  Caption = 'frmServerPCName'
  ClientHeight = 298
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 253
  end
  inherited TitleLbl: TLabel
    Caption = 'WGE Server PC Name'
  end
  inherited InstrLbl: TLabel
    Height = 45
    Caption = 
      'This utility allows you to change the name of the workstation wh' +
      'ich runs the Pervasive.SQL Workgroup Engine for your accounts so' +
      'ftware.'
  end
  inherited imgSide: TImage
    Height = 142
  end
  object Label1: TLabel [4]
    Left = 180
    Top = 195
    Width = 88
    Height = 13
    Caption = 'Workstation Name'
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 96
    Width = 285
    Height = 43
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'You should not be using this utility unless expressly directed t' +
      'o do so by the technical support staff for your accounts softwar' +
      'e.'
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 167
    Top = 141
    Width = 285
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please enter the name of the workstation which will be acting as' +
      ' the database server in the field below and click the &Update bu' +
      'tton to update the system:-'
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 167
    Top = 221
    Width = 285
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Alternatively, click the &Cancel button to exit this utility wit' +
      'hout making any changes.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 270
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 236
    inherited Image1: TImage
      Height = 234
    end
  end
  inherited ExitBtn: TButton
    Top = 270
    Visible = False
  end
  inherited BackBtn: TButton
    Top = 270
    Cancel = True
    Caption = '&Cancel'
  end
  inherited NextBtn: TButton
    Top = 270
    Caption = '&Update'
  end
  object lstServerName: TComboBox
    Left = 275
    Top = 192
    Width = 156
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'lstServerName'
  end
end
