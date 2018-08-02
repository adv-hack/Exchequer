inherited frmIAOInstallICE: TfrmIAOInstallICE
  Left = 358
  Top = 260
  ActiveControl = nil
  Caption = 'frmIAOInstallICE'
  ClientHeight = 299
  ClientWidth = 503
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 254
    Width = 480
  end
  inherited TitleLbl: TLabel
    Width = 328
    Caption = 'Install ClientLink Service'
  end
  inherited InstrLbl: TLabel
    Width = 329
    Caption = 
      '<APPTITLE> has a ClientLink Utility which can be used to replica' +
      'te client accounts to an accountancy practice.'
  end
  inherited imgSide: TImage
    Height = 143
  end
  object Label1: TLabel [4]
    Left = 179
    Top = 161
    Width = 90
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User ID'
  end
  object Label2: TLabel [5]
    Left = 179
    Top = 186
    Width = 90
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Password'
  end
  object Label3: TLabel [6]
    Left = 179
    Top = 211
    Width = 90
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Confirm Password'
  end
  object Label4: TLabel [7]
    Left = 167
    Top = 83
    Width = 329
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'A Windows Service must be installed to run the synchronisation p' +
      'rocess, this requires you to specify a valid domain User Id and ' +
      'Password so that the service can access the data files and email' +
      ':-'
    WordWrap = True
  end
  object Label5: TLabel [8]
    Left = 179
    Top = 136
    Width = 90
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Domain'
  end
  inherited HelpBtn: TButton
    Top = 271
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 237
    TabOrder = 4
    inherited Image1: TImage
      Height = 235
    end
  end
  inherited ExitBtn: TButton
    Top = 271
    TabOrder = 6
  end
  inherited BackBtn: TButton
    Left = 326
    Top = 271
    TabOrder = 7
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 412
    Top = 271
    Caption = '&Install'
    TabOrder = 8
  end
  object edtUserId: TEdit
    Left = 273
    Top = 158
    Width = 136
    Height = 21
    TabOrder = 1
  end
  object edtPassword1: TEdit
    Left = 273
    Top = 183
    Width = 97
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtPassword2: TEdit
    Left = 273
    Top = 208
    Width = 97
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object lstDomain: TComboBox
    Left = 273
    Top = 133
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
end
