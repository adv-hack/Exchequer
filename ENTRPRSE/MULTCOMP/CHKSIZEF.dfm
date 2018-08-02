inherited frmCheckFileSize: TfrmCheckFileSize
  Left = 397
  Top = 199
  Caption = 'frmCheckFileSize'
  ClientWidth = 493
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Width = 470
  end
  inherited TitleLbl: TLabel
    Width = 318
    Caption = 'Maximum Data Size Warning'
    Font.Charset = ANSI_CHARSET
    Font.Height = -21
    Font.Name = 'Arial'
  end
  inherited InstrLbl: TLabel
    Top = 68
    Width = 315
    Height = 18
    Caption = 'The Data Files listed below are nearing their maximum size:-'
  end
  object lblCompany: TLabel [4]
    Left = 167
    Top = 47
    Width = 315
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Company: '
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel [5]
    Left = 167
    Top = 141
    Width = 315
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please notify your Technical Support immediately to ensure that ' +
      'action is taken before the maximum file size is reached.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Visible = False
  end
  inherited Panel1: TPanel
    inherited Image1: TImage
      Align = alClient
    end
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 316
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 402
    Cancel = True
    Caption = '&Close'
    ModalResult = 1
  end
  object lstFilenames: TListBox
    Left = 184
    Top = 90
    Width = 281
    Height = 48
    BorderStyle = bsNone
    Color = clBtnFace
    ItemHeight = 14
    Items.Strings = (
      'Cust\CustSupp.Dat'#9'2,147,343,563 Bytes')
    TabOrder = 5
    TabWidth = 100
  end
end
