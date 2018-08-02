inherited frmPasswordEntry: TfrmPasswordEntry
  Left = 675
  Top = 336
  HelpContext = 1
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer v6.00 Conversion'
  ClientHeight = 220
  ClientWidth = 342
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 342
  end
  inherited lblBanner: TLabel
    Width = 181
    Caption = 'Enter Password'
  end
  object Label3: TLabel [2]
    Left = 8
    Top = 49
    Width = 325
    Height = 29
    AutoSize = False
    Caption = 
      'To prevent unauthorised use of the Exchequer Pervasive to SQL Co' +
      'nversion a password is required to continue.'
    WordWrap = True
  end
  object Label4: TLabel [3]
    Left = 8
    Top = 84
    Width = 325
    Height = 46
    AutoSize = False
    Caption = 
      'You can get the password from your normal Technical Support cont' +
      'act, they will also be able to answer any questions you have on ' +
      'the conversion process.'
    WordWrap = True
  end
  object Label1: TLabel [4]
    Left = 53
    Top = 140
    Width = 108
    Height = 14
    Alignment = taRightJustify
    Caption = 'Conversion Password'
    WordWrap = True
    OnDblClick = Label1DblClick
  end
  object lblVersionWarning: TLabel [5]
    Left = 0
    Top = 167
    Width = 342
    Height = 22
    Alignment = taCenter
    AutoSize = False
    Caption = 'For use with v?.? Only'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
  end
  object mePassword: TMaskEdit [6]
    Left = 171
    Top = 138
    Width = 117
    Height = 22
    MaxLength = 10
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnClose: TButton [7]
    Left = 177
    Top = 193
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnContinue: TButton [8]
    Left = 85
    Top = 193
    Width = 80
    Height = 21
    Caption = 'Continue'
    TabOrder = 1
    OnClick = btnContinueClick
  end
end
