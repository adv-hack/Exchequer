object frmCardDetails: TfrmCardDetails
  Left = 367
  Top = 290
  BorderStyle = bsDialog
  Caption = 'Please enter the card details'
  ClientHeight = 294
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel3: TBevel
    Left = 8
    Top = 8
    Width = 545
    Height = 50
    Shape = bsFrame
  end
  object Label5: TLabel
    Left = 8
    Top = 264
    Width = 89
    Height = 14
    Caption = '* Only if applicable'
  end
  object lAuthorise: TLabel
    Left = 16
    Top = 20
    Width = 219
    Height = 22
    Caption = 'Amount to be Authorised :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lCcy: TLabel
    Left = 352
    Top = 20
    Width = 11
    Height = 22
    Caption = #163
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 384
    Top = 264
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 472
    Top = 264
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object edAmount: TCurrencyEdit
    Left = 384
    Top = 17
    Width = 153
    Height = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object panDetails: TPanel
    Left = 8
    Top = 56
    Width = 545
    Height = 201
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 273
      Height = 201
      Shape = bsFrame
    end
    object Bevel2: TBevel
      Left = 271
      Top = 0
      Width = 274
      Height = 201
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 16
      Top = 52
      Width = 63
      Height = 14
      Caption = 'Card Number'
    end
    object Label2: TLabel
      Left = 16
      Top = 84
      Width = 55
      Height = 14
      Caption = 'Start Date *'
    end
    object Label3: TLabel
      Left = 16
      Top = 108
      Width = 55
      Height = 14
      Caption = 'Expiry Date'
    end
    object Label4: TLabel
      Left = 16
      Top = 140
      Width = 73
      Height = 14
      Caption = 'Issue Number *'
    end
    object lSecurityNo: TLabel
      Left = 16
      Top = 164
      Width = 63
      Height = 14
      Caption = 'Security No *'
    end
    object Label8: TLabel
      Left = 280
      Top = 52
      Width = 83
      Height = 14
      Caption = 'House No / Name'
    end
    object Label9: TLabel
      Left = 280
      Top = 164
      Width = 45
      Height = 14
      Caption = 'Postcode'
    end
    object Label11: TLabel
      Left = 16
      Top = 20
      Width = 50
      Height = 14
      Caption = 'Card Type'
    end
    object Label12: TLabel
      Left = 280
      Top = 20
      Width = 42
      Height = 14
      Caption = 'Address'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object edExpiryDate: TEdit
      Left = 96
      Top = 104
      Width = 57
      Height = 22
      MaxLength = 5
      TabOrder = 3
    end
    object edStartDate: TEdit
      Left = 96
      Top = 80
      Width = 57
      Height = 22
      MaxLength = 5
      TabOrder = 2
    end
    object edCardNo: TEdit
      Left = 96
      Top = 48
      Width = 161
      Height = 22
      MaxLength = 20
      TabOrder = 1
    end
    object edIssueNo: TEdit
      Left = 96
      Top = 136
      Width = 57
      Height = 22
      MaxLength = 2
      TabOrder = 4
    end
    object Button1: TButton
      Left = 160
      Top = 80
      Width = 25
      Height = 25
      Caption = '1'
      TabOrder = 11
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 184
      Top = 80
      Width = 25
      Height = 25
      Caption = '2'
      TabOrder = 12
      Visible = False
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 208
      Top = 80
      Width = 25
      Height = 25
      Caption = '3'
      TabOrder = 13
      Visible = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 232
      Top = 80
      Width = 25
      Height = 25
      Caption = '4'
      TabOrder = 14
      Visible = False
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 159
      Top = 104
      Width = 25
      Height = 25
      Caption = '5'
      TabOrder = 15
      Visible = False
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 183
      Top = 104
      Width = 26
      Height = 25
      Caption = '6'
      TabOrder = 16
      Visible = False
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 207
      Top = 104
      Width = 25
      Height = 25
      Caption = '7'
      TabOrder = 17
      Visible = False
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 231
      Top = 104
      Width = 25
      Height = 25
      Caption = '8'
      TabOrder = 18
      Visible = False
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 159
      Top = 128
      Width = 25
      Height = 25
      Caption = '9'
      TabOrder = 19
      Visible = False
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 183
      Top = 128
      Width = 25
      Height = 25
      Caption = '10'
      TabOrder = 20
      Visible = False
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 207
      Top = 128
      Width = 25
      Height = 25
      Caption = '11'
      TabOrder = 21
      Visible = False
      OnClick = Button11Click
    end
    object Button12: TButton
      Left = 231
      Top = 128
      Width = 25
      Height = 25
      Caption = '12'
      TabOrder = 22
      Visible = False
      OnClick = Button12Click
    end
    object Button13: TButton
      Left = 159
      Top = 152
      Width = 25
      Height = 25
      Caption = '13'
      TabOrder = 23
      Visible = False
      OnClick = Button13Click
    end
    object Button14: TButton
      Left = 183
      Top = 152
      Width = 25
      Height = 25
      Caption = '14'
      Enabled = False
      TabOrder = 24
      Visible = False
      OnClick = Button14Click
    end
    object Button15: TButton
      Left = 207
      Top = 152
      Width = 25
      Height = 25
      Caption = '15'
      Enabled = False
      TabOrder = 25
      Visible = False
      OnClick = Button15Click
    end
    object Button16: TButton
      Left = 231
      Top = 152
      Width = 25
      Height = 25
      Caption = '16'
      Enabled = False
      TabOrder = 26
      Visible = False
      OnClick = Button16Click
    end
    object edSecurityNo: TEdit
      Left = 96
      Top = 160
      Width = 57
      Height = 22
      MaxLength = 4
      TabOrder = 5
    end
    object edAddress1: TEdit
      Left = 376
      Top = 48
      Width = 153
      Height = 22
      MaxLength = 35
      TabOrder = 6
    end
    object edAddress2: TEdit
      Left = 376
      Top = 80
      Width = 153
      Height = 22
      MaxLength = 35
      TabOrder = 7
    end
    object edAddress3: TEdit
      Left = 376
      Top = 104
      Width = 153
      Height = 22
      MaxLength = 35
      TabOrder = 8
    end
    object edAddress4: TEdit
      Left = 376
      Top = 128
      Width = 153
      Height = 22
      MaxLength = 35
      TabOrder = 9
    end
    object edPostcode: TEdit
      Left = 376
      Top = 160
      Width = 89
      Height = 22
      MaxLength = 10
      TabOrder = 10
    end
    object cmbCardType: TComboBox
      Left = 96
      Top = 16
      Width = 161
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
    end
    object Button17: TButton
      Left = 159
      Top = 176
      Width = 25
      Height = 25
      Caption = '17'
      Enabled = False
      TabOrder = 27
      Visible = False
      OnClick = Button17Click
    end
    object Button18: TButton
      Left = 183
      Top = 176
      Width = 25
      Height = 25
      Caption = '18'
      Enabled = False
      TabOrder = 28
      Visible = False
      OnClick = Button18Click
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 104
    Top = 264
  end
end
