object frmReferralDialog: TfrmReferralDialog
  Left = 583
  Top = 392
  BorderStyle = bsDialog
  Caption = 'Referral'
  ClientHeight = 270
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel3: TBevel
    Left = 8
    Top = 192
    Width = 257
    Height = 41
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 241
    Height = 65
    AutoSize = False
    Caption = 
      'Please call the following phone number and enter the authorisati' +
      'on code given to you by the operator.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 205
    Width = 98
    Height = 14
    Caption = 'Authorisation Code : '
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Phone No : '
    WordWrap = True
  end
  object lPhoneNo: TLabel
    Left = 120
    Top = 72
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Label4: TLabel
    Left = 16
    Top = 96
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Merchant ID : '
    WordWrap = True
  end
  object lMID: TLabel
    Left = 120
    Top = 96
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Label6: TLabel
    Left = 16
    Top = 120
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Card No :'
    WordWrap = True
  end
  object lCardNo: TLabel
    Left = 120
    Top = 120
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Label8: TLabel
    Left = 16
    Top = 136
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Start Date : '
    WordWrap = True
  end
  object lStartDate: TLabel
    Left = 120
    Top = 136
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Label10: TLabel
    Left = 16
    Top = 152
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Expiry Date :'
    WordWrap = True
  end
  object lExpiryDate: TLabel
    Left = 120
    Top = 152
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Label12: TLabel
    Left = 16
    Top = 168
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Issue No : '
    WordWrap = True
  end
  object lIssueNo: TLabel
    Left = 120
    Top = 168
    Width = 45
    Height = 14
    Caption = 'lPhoneNo'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 257
    Height = 57
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 63
    Width = 257
    Height = 131
    Shape = bsFrame
  end
  object edCode: TEdit
    Left = 120
    Top = 200
    Width = 137
    Height = 22
    MaxLength = 20
    TabOrder = 0
    OnChange = edCodeChange
  end
  object btnOK: TButton
    Left = 96
    Top = 240
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 184
    Top = 240
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
