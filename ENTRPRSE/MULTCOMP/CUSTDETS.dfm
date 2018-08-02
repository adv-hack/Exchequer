inherited frmCustDets: TfrmCustDets
  Left = 302
  Top = 154
  HelpContext = 8
  ActiveControl = nil
  Caption = 'frmCustDets'
  ClientHeight = 415
  ClientWidth = 596
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 372
    Width = 573
    Height = 9
  end
  inherited TitleLbl: TLabel
    Width = 419
    Caption = 'Dealer and Customer Details'
  end
  inherited InstrLbl: TLabel
    Top = 47
    Width = 419
    Height = 16
    Caption = 
      'The following details are needed for the Fax or Email. Click the' +
      ' OK button to continue.'
  end
  object Label1: TLabel [3]
    Left = 166
    Top = 87
    Width = 87
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Name'
    WordWrap = True
  end
  object Label3: TLabel [4]
    Left = 172
    Top = 160
    Width = 81
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Contact Name'
    WordWrap = True
  end
  object Label4: TLabel [5]
    Left = 172
    Top = 211
    Width = 81
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Address'
    WordWrap = True
  end
  object Label5: TLabel [6]
    Left = 172
    Top = 325
    Width = 81
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Phone'
    WordWrap = True
  end
  object Label6: TLabel [7]
    Left = 406
    Top = 325
    Width = 29
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Fax'
    WordWrap = True
  end
  object Label2: TLabel [8]
    Left = 172
    Top = 350
    Width = 81
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Email'
    WordWrap = True
  end
  object Label7: TLabel [9]
    Left = 172
    Top = 185
    Width = 81
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Name'
    WordWrap = True
  end
  object Bevel2: TBevel [10]
    Left = 171
    Top = 133
    Width = 405
    Height = 4
    Shape = bsTopLine
  end
  object Label8: TLabel [11]
    Left = 172
    Top = 139
    Width = 136
    Height = 16
    AutoSize = False
    Caption = 'Your Company Details:-'
    WordWrap = True
  end
  object Label9: TLabel [12]
    Left = 166
    Top = 111
    Width = 87
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Town/City'
    WordWrap = True
  end
  object Label10: TLabel [13]
    Left = 172
    Top = 68
    Width = 136
    Height = 16
    AutoSize = False
    Caption = 'Purchased From:-'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 387
    TabOrder = 12
  end
  inherited Panel1: TPanel
    Height = 353
    TabOrder = 16
    inherited Image1: TImage
      Height = 351
    end
  end
  inherited ExitBtn: TButton
    Top = 387
    TabOrder = 13
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 414
    Top = 387
    Width = 85
    Height = 24
    Caption = 'O&K'
    TabOrder = 14
    OnClick = NextBtnClick
  end
  inherited NextBtn: TButton
    Left = 506
    Top = 387
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 15
    OnClick = BackBtnClick
  end
  object edtDealer: Text8Pt
    Left = 259
    Top = 84
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object edtContact: Text8Pt
    Left = 259
    Top = 157
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object edtAddr1: Text8Pt
    Left = 259
    Top = 208
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
  object edtAddr2: Text8Pt
    Left = 259
    Top = 230
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    TextId = 0
    ViaSBtn = False
  end
  object edtAddr3: Text8Pt
    Left = 259
    Top = 252
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    TextId = 0
    ViaSBtn = False
  end
  object edtAddr4: Text8Pt
    Left = 259
    Top = 274
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    TextId = 0
    ViaSBtn = False
  end
  object edtAddr5: Text8Pt
    Left = 259
    Top = 296
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    TextId = 0
    ViaSBtn = False
  end
  object edtPhone: Text8Pt
    Left = 259
    Top = 322
    Width = 135
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    TextId = 0
    ViaSBtn = False
  end
  object edtFax: Text8Pt
    Left = 441
    Top = 322
    Width = 135
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    TextId = 0
    ViaSBtn = False
  end
  object edtemail: Text8Pt
    Left = 259
    Top = 347
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 50
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    TextId = 0
    ViaSBtn = False
  end
  object edtCompany: Text8Pt
    Left = 259
    Top = 182
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object edtDealerTown: Text8Pt
    Left = 259
    Top = 108
    Width = 317
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
end
