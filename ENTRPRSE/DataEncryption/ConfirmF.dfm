object frmConfirmation: TfrmConfirmation
  Left = 266
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Confirm Data File Encrypton'
  ClientHeight = 280
  ClientWidth = 676
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblEstimate: TLabel
    Left = 5
    Top = 55
    Width = 663
    Height = 14
    AutoSize = False
  end
  object Label4: TLabel
    Left = 5
    Top = 73
    Width = 329
    Height = 14
    Caption = 
      'The encryption process is performed by the Pervasive.SQL Engine:' +
      '-'
  end
  object Label3: TLabel
    Left = 21
    Top = 91
    Width = 327
    Height = 14
    Caption = 
      'Once the encryption process has been started it cannot be stoppe' +
      'd'
  end
  object Label6: TLabel
    Left = 12
    Top = 91
    Width = 6
    Height = 9
    Caption = 'l'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clBlack
    Font.Height = -8
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 21
    Top = 109
    Width = 440
    Height = 14
    Caption = 
      'We cannot display any progress information or any estimated time' +
      ' to completion information'
  end
  object Label8: TLabel
    Left = 12
    Top = 109
    Width = 6
    Height = 9
    Caption = 'l'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clBlack
    Font.Height = -8
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 5
    Top = 136
    Width = 306
    Height = 14
    Caption = 'You must acknowledge the following risks in order to proceed:-'
  end
  object lblRequested: TRTFLabel
    Left = 4
    Top = 5
    Width = 650
    Height = 14
    RichText = 
      '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil A' +
      'rial;}}'#13#10'\viewkind4\uc1\pard\lang2057\fs16 abcde  \b efgh\b0  ij' +
      'kl\f1 '#13#10'\par }'#13#10#0
    WordWrap = True
    Version = '1.3.0.0'
  end
  object lblProceed: TRTFLabel
    Left = 4
    Top = 234
    Width = 650
    Height = 14
    WordWrap = True
    Version = '1.3.0.0'
  end
  object lblExclusive: TRTFLabel
    Left = 4
    Top = 23
    Width = 668
    Height = 14
    RichText = 
      '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil Arial;}}'#13#10'\viewkind4\uc1\par' +
      'd\lang2057\f0\fs16 '#13#10'\par }'#13#10#0
    WordWrap = True
    Version = '1.3.0.0'
  end
  object Label1: TLabel
    Left = 5
    Top = 37
    Width = 668
    Height = 14
    AutoSize = False
    Caption = 'process is interrupted you MUST restore a backup.'
  end
  object chkDamaged: TCheckBox
    Left = 12
    Top = 171
    Width = 620
    Height = 17
    Caption = 
      'I understand that in the event of a failure the data file will b' +
      'e irreversably damaged and I must restore the backup'
    TabOrder = 1
    OnClick = chkNoEstimateClick
  end
  object chkExclusive: TCheckBox
    Left = 12
    Top = 189
    Width = 620
    Height = 17
    Caption = 
      'I understand that no other users or applications can use this co' +
      'mpany whilst the encryption is in progress'
    TabOrder = 2
    OnClick = chkNoEstimateClick
  end
  object chkBackup: TCheckBox
    Left = 12
    Top = 153
    Width = 620
    Height = 17
    Caption = 
      'I have a known good backup of this data file that I can restore ' +
      'in the event of a hardware or software failure'
    TabOrder = 0
    OnClick = chkNoEstimateClick
  end
  object chkNoEstimate: TCheckBox
    Left = 12
    Top = 207
    Width = 620
    Height = 17
    Caption = 
      'I understand that the estimated encryption time may be inaccurat' +
      'e due to local conditions and have taken that into account'
    TabOrder = 3
    OnClick = chkNoEstimateClick
  end
  object btnYes: TButton
    Left = 253
    Top = 254
    Width = 80
    Height = 21
    Caption = '&Yes'
    Enabled = False
    ModalResult = 6
    TabOrder = 4
  end
  object btnNo: TButton
    Left = 340
    Top = 254
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&No'
    ModalResult = 7
    TabOrder = 5
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 624
    Top = 272
  end
end
