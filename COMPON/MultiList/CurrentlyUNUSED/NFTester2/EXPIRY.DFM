object frmReleaseCode: TfrmReleaseCode
  Left = 256
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Release Code Expiry'
  ClientHeight = 297
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel3: TBevel
    Left = 8
    Top = 8
    Width = 401
    Height = 106
    Shape = bsFrame
  end
  object Bevel1: TBevel
    Left = 8
    Top = 112
    Width = 401
    Height = 145
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 39
    Top = 168
    Width = 69
    Height = 14
    Alignment = taRightJustify
    Caption = 'Today'#39's Date :'
  end
  object Label2: TLabel
    Left = 34
    Top = 196
    Width = 74
    Height = 14
    Alignment = taRightJustify
    Caption = 'Security Code :'
  end
  object Label3: TLabel
    Left = 35
    Top = 228
    Width = 73
    Height = 14
    Alignment = taRightJustify
    Caption = 'Release Code :'
  end
  object lDate: TLabel
    Left = 112
    Top = 168
    Width = 27
    Height = 14
    Caption = 'lDate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 16
    Width = 379
    Height = 14
    Caption = 
      'You can get a new Release Code by contacting your local distribu' +
      'tor :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 65
    Top = 56
    Width = 43
    Height = 14
    Alignment = taRightJustify
    Caption = 'Contact :'
  end
  object Label6: TLabel
    Left = 32
    Top = 80
    Width = 76
    Height = 14
    Alignment = taRightJustify
    Caption = 'Phone Number :'
  end
  object Label7: TLabel
    Left = 112
    Top = 56
    Width = 173
    Height = 14
    Caption = 'Club Systems International Ltd.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 112
    Top = 80
    Width = 98
    Height = 14
    Caption = '+44 (0)1663 766999'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 24
    Top = 40
    Width = 369
    Height = 2
    Shape = bsFrame
  end
  object Label9: TLabel
    Left = 16
    Top = 120
    Width = 385
    Height = 33
    AutoSize = False
    Caption = 
      'They will ask you for the following details, and will give you a' +
      ' release code to enter into the release code field below.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object edSecurity: Text8Pt
    Left = 112
    Top = 192
    Width = 193
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object edRelease: Text8Pt
    Left = 112
    Top = 224
    Width = 193
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
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
  object btnOK: TButton
    Left = 256
    Top = 264
    Width = 73
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 335
    Top = 264
    Width = 73
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
