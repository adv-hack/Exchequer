inherited frmResults: TfrmResults
  Left = 358
  Top = 137
  ActiveControl = nil
  Caption = 'frmResults'
  ClientHeight = 427
  ClientWidth = 566
  KeyPreview = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    566
    427)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 382
    Width = 543
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited TitleLbl: TLabel
    Width = 391
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Survey Results'
  end
  inherited InstrLbl: TLabel
    Left = 43
    Top = 76
    Width = 88
    Anchors = [akLeft, akTop, akRight]
    Caption = ''
    Visible = False
  end
  object Label1: TLabel
    Left = 167
    Top = 49
    Width = 393
    Height = 32
    AutoSize = False
    Caption = 
      'The easiest way to submit the Survey Results is by Email, howeve' +
      'r if you do not have access to email you can also submit the res' +
      'ults by Post or Fax.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Left = 24
    Top = 399
    Anchors = [akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 365
    Anchors = [akLeft, akTop, akBottom]
    DesignSize = (
      145
      365)
    inherited Image1: TImage
      Height = 363
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Left = 104
    Top = 399
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 389
    Top = 399
    Anchors = [akRight, akBottom]
    Caption = '<< &Details'
    TabOrder = 2
  end
  inherited NextBtn: TButton
    Left = 475
    Top = 399
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    TabOrder = 3
  end
  object PageControl1: TPageControl
    Left = 167
    Top = 87
    Width = 390
    Height = 145
    ActivePage = tabshEmail
    TabIndex = 0
    TabOrder = 5
    object tabshEmail: TTabSheet
      Caption = 'Submit via Email'
      object Label2: TLabel
        Left = 6
        Top = 8
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
      object Label5: TLabel
        Left = 18
        Top = 5
        Width = 356
        Height = 29
        AutoSize = False
        Caption = 
          'Click the Copy button below the Survey Results to copy the resul' +
          'ts into the clipboard.'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 6
        Top = 38
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
      object Label4: TLabel
        Left = 18
        Top = 35
        Width = 358
        Height = 29
        AutoSize = False
        Caption = 
          'In your Email application create a new Email and paste the Surve' +
          'y Results from the clipboard into the message text.'
        WordWrap = True
      end
      object lblSendEmailTo: TLabel
        Left = 18
        Top = 65
        Width = 358
        Height = 32
        AutoSize = False
        Caption = 
          'Set the recipient address on the Email to ''@@@'' and set the subj' +
          'ect on the Email to ''Survey Results''.'
        WordWrap = True
      end
      object Label7: TLabel
        Left = 6
        Top = 68
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
      object Label10: TLabel
        Left = 18
        Top = 96
        Width = 347
        Height = 19
        AutoSize = False
        Caption = 'Send the Email.'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 6
        Top = 99
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
    end
    object TabSheet2: TTabSheet
      Caption = 'Submit via Post'
      ImageIndex = 1
      object Label8: TLabel
        Left = 6
        Top = 8
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
        Left = 18
        Top = 5
        Width = 347
        Height = 17
        AutoSize = False
        Caption = 'Insert a blank floppy disk into your floppy disk drive'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 6
        Top = 28
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
      object Label13: TLabel
        Left = 18
        Top = 25
        Width = 347
        Height = 29
        AutoSize = False
        Caption = 
          'Click the ''Save As'' button below the Survey Results to save the ' +
          'Survey Results as a Text File onto the blank floppy disk.'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 6
        Top = 58
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
      object Label15: TLabel
        Left = 18
        Top = 55
        Width = 347
        Height = 38
        AutoSize = False
        Caption = 'Send the disk to your Authorised Exchequer Reseller'
        WordWrap = True
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Submit via Fax'
      ImageIndex = 2
      object Label16: TLabel
        Left = 6
        Top = 8
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
      object Label17: TLabel
        Left = 18
        Top = 5
        Width = 347
        Height = 29
        AutoSize = False
        Caption = 
          'Click the ''Save As'' button below the Survey Results to save the ' +
          'Survey Results as a Text File onto your machine.'
        WordWrap = True
      end
      object Label18: TLabel
        Left = 6
        Top = 39
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
      object Label19: TLabel
        Left = 18
        Top = 36
        Width = 347
        Height = 44
        AutoSize = False
        Caption = 
          'Open the Text File in a word processing application like WordPad' +
          ' or Microsoft Word and print the results.  Please ensure that th' +
          'ey are printed in a large bold font to ensure that the fax will ' +
          'be readable on receipt.'
        WordWrap = True
      end
      object Label20: TLabel
        Left = 6
        Top = 83
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
      object Label21: TLabel
        Left = 18
        Top = 80
        Width = 347
        Height = 29
        AutoSize = False
        Caption = 'Send the fax to your Authorised Exchequer Reseller'
        WordWrap = True
      end
    end
  end
  object memSurveyOutput: TMemo
    Left = 167
    Top = 241
    Width = 390
    Height = 119
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object btnCopy: TButton
    Left = 262
    Top = 365
    Width = 100
    Height = 21
    Caption = 'Copy'
    TabOrder = 7
    OnClick = btnCopyClick
  end
  object btnSaveAs: TButton
    Left = 372
    Top = 365
    Width = 100
    Height = 21
    Caption = 'Save As'
    TabOrder = 8
    OnClick = btnSaveAsClick
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Exchequer Survey.Txt'
    Filter = 'Text Files|*.TXT|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 114
    Top = 30
  end
end
