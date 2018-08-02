inherited frmSecPhone: TfrmSecPhone
  Left = 202
  ActiveControl = nil
  Caption = 'frmSecPhone'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'By Telephone'
  end
  inherited InstrLbl: TLabel
    Width = 286
    Caption = 
      'You can get a new Security Code by contacting your local distrib' +
      'uter on the number listed below:-'
    ParentFont = False
  end
  object Label3: TLabel [3]
    Left = 178
    Top = 145
    Width = 53
    Height = 17
    AutoSize = False
    Caption = 'ISN'
    WordWrap = True
  end
  object Label4: TLabel [4]
    Left = 178
    Top = 169
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Security Code'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 178
    Top = 194
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Release Code'
    WordWrap = True
  end
  object Label1: TLabel [6]
    Left = 177
    Top = 83
    Width = 53
    Height = 17
    AutoSize = False
    Caption = 'Contact'
    WordWrap = True
  end
  object Label5: TLabel [7]
    Left = 177
    Top = 100
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Phone No'
    WordWrap = True
  end
  object Label7: TLabel [8]
    Left = 262
    Top = 83
    Width = 185
    Height = 17
    AutoSize = False
    Caption = 'ISN'
    WordWrap = True
  end
  object Label8: TLabel [9]
    Left = 262
    Top = 100
    Width = 185
    Height = 17
    AutoSize = False
    Caption = 'Security Code'
    WordWrap = True
  end
  object Label6: TLabel [10]
    Left = 167
    Top = 123
    Width = 286
    Height = 17
    AutoSize = False
    Caption = 'The distributer will need the following details:-'
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label9: TLabel [11]
    Left = 167
    Top = 220
    Width = 286
    Height = 17
    AutoSize = False
    Caption = 'Use the back button to contact the Distributer another way.'
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 0
  end
  inherited Panel1: TPanel
    TabOrder = 4
  end
  inherited ExitBtn: TButton
    TabOrder = 1
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 281
    Width = 85
    Cancel = True
    TabOrder = 2
  end
  inherited NextBtn: TButton
    Caption = '&Finish'
    Enabled = False
    TabOrder = 3
  end
  object edtRelCode: Text8Pt
    Left = 266
    Top = 191
    Width = 121
    Height = 22
    EditMask = '>cccccccccc;0; '
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = 'edtRelCode'
    TextId = 0
    ViaSBtn = False
  end
  object edtISN: Text8Pt
    Left = 266
    Top = 143
    Width = 179
    Height = 22
    Enabled = False
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = 'edtISN'
    TextId = 0
    ViaSBtn = False
  end
  object edtSecCode: Text8Pt
    Left = 266
    Top = 167
    Width = 121
    Height = 22
    Enabled = False
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = 'edtSecCode'
    TextId = 0
    ViaSBtn = False
  end
end
