inherited frmMainForm: TfrmMainForm
  Left = 404
  Top = 145
  Caption = 'frmMainForm'
  ClientHeight = 287
  ClientWidth = 474
  DesignSize = (
    474
    287)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 242
    Width = 451
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited TitleLbl: TLabel
    Width = 299
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Pre-Upgrade Survey'
  end
  inherited InstrLbl: TLabel
    Width = 296
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'This Pre-Upgrade Survey should be used before upgrading to Exche' +
      'quer v5.00 and performs two tasks:-'
  end
  object Label3: TLabel [4]
    Left = 183
    Top = 115
    Width = 274
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'It contains a short survey that will allow us to update your det' +
      'ails in our internal records.'
    WordWrap = True
  end
  object Label4: TLabel [5]
    Left = 167
    Top = 150
    Width = 296
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please note that this utility should only be used on machines th' +
      'at are correctly configured to run Exchequer, otherwise the util' +
      'ity may experience errors attempting to access the data.'
    WordWrap = True
  end
  object Label5: TLabel [6]
    Left = 183
    Top = 83
    Width = 278
    Height = 29
    AutoSize = False
    Caption = 
      'It scans your accounts checking for issues that may cause a prob' +
      'lem during the upgrade to Exchequer v5.00.'
    WordWrap = True
  end
  object Label1: TLabel [7]
    Left = 171
    Top = 86
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
  object Label6: TLabel [8]
    Left = 171
    Top = 118
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
  inherited HelpBtn: TButton
    Top = 259
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 225
    Anchors = [akLeft, akTop, akBottom]
    DesignSize = (
      145
      225)
    inherited Image1: TImage
      Left = 2
      Height = 223
      Anchors = [akLeft, akTop, akBottom]
    end
    object Label2: TLabel
      Left = 3
      Top = 3
      Width = 138
      Height = 14
      AutoSize = False
      Caption = 'v2.01'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  inherited ExitBtn: TButton
    Top = 259
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 297
    Top = 259
    Anchors = [akRight, akBottom]
    TabOrder = 1
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 383
    Top = 259
    Anchors = [akRight, akBottom]
    Caption = '&Continue'
    Default = True
  end
end
