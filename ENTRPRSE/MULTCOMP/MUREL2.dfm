inherited frmEntUserCount: TfrmEntUserCount
  Left = 374
  Top = 206
  HelpContext = 13
  ActiveControl = edtFullRel
  Caption = 'Exchequer User Count Licence'
  ClientHeight = 254
  ClientWidth = 571
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  KeyPreview = True
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 209
    Width = 548
  end
  inherited TitleLbl: TLabel
    Width = 396
    Caption = 'Exchequer User Count Licence'
    Font.Charset = ANSI_CHARSET
    Font.Height = -21
    Font.Name = 'Arial'
  end
  inherited InstrLbl: TLabel
    Width = 393
    Caption = 
      'Please contact your Exchequer Technical Support for additional u' +
      'sers, quoting your Site Number and Security Code as shown below.'
  end
  object lblESN: TLabel [4]
    Left = 272
    Top = 90
    Width = 195
    Height = 17
    AutoSize = False
    Caption = '000-000-000-000-000-000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnDblClick = lblESNDblClick
  end
  object Label3: TLabel [5]
    Left = 168
    Top = 136
    Width = 45
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Full'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnDblClick = Label3DblClick
  end
  object Label4: TLabel [6]
    Left = 219
    Top = 117
    Width = 99
    Height = 17
    AutoSize = False
    Caption = 'Security Code'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel [7]
    Left = 327
    Top = 117
    Width = 109
    Height = 17
    AutoSize = False
    Caption = 'Release Code'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel [8]
    Left = 168
    Top = 163
    Width = 45
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = '30-Day'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnDblClick = Label6DblClick
  end
  object Label7: TLabel [9]
    Left = 449
    Top = 117
    Width = 114
    Height = 17
    AutoSize = False
    Caption = 'Status'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblFullStatus: TLabel [10]
    Left = 449
    Top = 136
    Width = 114
    Height = 17
    AutoSize = False
    Caption = 'Status'
  end
  object lbl30Status: TLabel [11]
    Left = 449
    Top = 163
    Width = 114
    Height = 17
    AutoSize = False
    Caption = 'Status'
  end
  object Label10: TLabel [12]
    Left = 172
    Top = 90
    Width = 98
    Height = 14
    Caption = 'Your Site Number is'
  end
  inherited HelpBtn: TButton
    Top = 226
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 192
    inherited Image1: TImage
      Height = 190
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Top = 226
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 394
    Top = 226
    Caption = '&OK'
  end
  inherited NextBtn: TButton
    Left = 480
    Top = 226
    Caption = '&Cancel'
  end
  object edtFullSec: Text8Pt
    Tag = 1
    Left = 216
    Top = 133
    Width = 106
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 11
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 5
    Text = 'ABCDEFGHIJ'
    OnDblClick = edtFullSecDblClick
    TextId = 0
    ViaSBtn = False
  end
  object edtFullRel: Text8Pt
    Tag = 101
    Left = 326
    Top = 133
    Width = 116
    Height = 22
    CharCase = ecUpperCase
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = 'ABCDEFGHIJ'
    OnDblClick = edtFullSecDblClick
    OnExit = edtFullRelExit
    TextId = 0
    ViaSBtn = False
  end
  object edt30Rel: Text8Pt
    Tag = 102
    Left = 327
    Top = 160
    Width = 115
    Height = 22
    CharCase = ecUpperCase
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = 'ABCDEFGHIJ'
    OnDblClick = edtFullSecDblClick
    OnExit = edt30RelExit
    TextId = 0
    ViaSBtn = False
  end
  object edt30Sec: Text8Pt
    Tag = 2
    Left = 216
    Top = 160
    Width = 106
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 11
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 8
    Text = 'ABCDEFGHIJ'
    OnDblClick = edtFullSecDblClick
    TextId = 0
    ViaSBtn = False
  end
end
