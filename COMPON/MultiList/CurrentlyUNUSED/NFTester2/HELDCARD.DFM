object FrmHeldCardsList: TFrmHeldCardsList
  Left = 459
  Top = 248
  HelpContext = 34
  BorderStyle = bsDialog
  Caption = 'Held Cards'
  ClientHeight = 231
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 193
    Height = 28
    Caption = 'Please select the type of cards you wish to list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 193
    Height = 153
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 16
    Top = 112
    Width = 177
    Height = 73
    Shape = bsFrame
  end
  object chkExpired: TCheckBox
    Left = 24
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Expired Cards'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = chkExpiredClick
  end
  object chkSuspended: TCheckBox
    Left = 24
    Top = 80
    Width = 113
    Height = 17
    Caption = 'Suspended Cards'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = chkExpiredClick
  end
  object chkOverLimit: TCheckBox
    Left = 24
    Top = 104
    Width = 113
    Height = 17
    Caption = 'Cards Over Limit'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = chkExpiredClick
  end
  object btnOK: TButton
    Left = 64
    Top = 200
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 136
    Top = 200
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object chkOnHold: TCheckBox
    Left = 48
    Top = 130
    Width = 113
    Height = 17
    Caption = 'Cards On Hold'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = chkExpiredClick
  end
  object chkAllowedCredit: TCheckBox
    Left = 48
    Top = 154
    Width = 129
    Height = 17
    Caption = 'Cards Allowed Credit'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = chkExpiredClick
  end
end
