inherited frmPaperConfig: TfrmPaperConfig
  Left = 349
  Top = 147
  HelpContext = 40
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  ClientHeight = 429
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 384
  end
  inherited TitleLbl: TLabel
    Top = 9
    Caption = 'Configure Paperless Module'
  end
  inherited imgSide: TImage [2]
  end
  inherited InstrLbl: TLabel [3]
    Left = 3
    Top = 2
    Width = 52
    Height = 21
    Caption = ''
    Visible = False
  end
  inherited HelpBtn: TButton
    Top = 401
    TabOrder = 2
  end
  inherited Panel1: TPanel
    Height = 369
    TabOrder = 1
    inherited Image1: TImage
      Height = 367
    end
  end
  inherited ExitBtn: TButton
    Top = 401
    TabOrder = 3
  end
  inherited BackBtn: TButton
    Top = 401
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Top = 401
    TabOrder = 5
  end
  object Notebook1: TNotebook
    Left = 167
    Top = 41
    Width = 291
    Height = 344
    Anchors = [akLeft, akTop, akBottom]
    PageIndex = 1
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbEmail'
      object Label81: Label8
        Left = 4
        Top = 5
        Width = 177
        Height = 19
        Caption = 'Method of Sending Emails'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 4
        Top = 23
        Width = 282
        Height = 33
        AutoSize = False
        Caption = 
          'To send emails through the Paperless Module you need to specify ' +
          'which email system you use:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label7: TLabel
        Left = 29
        Top = 72
        Width = 253
        Height = 44
        AutoSize = False
        Caption = 
          'This is the international standard for sending emails which supp' +
          'orted by most Email Clients. e.g. Outlook, OutLook Express, Inte' +
          'rnet Mail, Eudora, etc...'
        WordWrap = True
        OnClick = Label7Click
      end
      object Label8: TLabel
        Left = 29
        Top = 192
        Width = 253
        Height = 35
        AutoSize = False
        Caption = 
          'This is a Microsoft Standard for sending Email and Faxes in Wind' +
          'ows.'
        WordWrap = True
        OnClick = Label8Click
      end
      object Label9: TLabel
        Left = 29
        Top = 117
        Width = 253
        Height = 28
        AutoSize = False
        Caption = 
          'The address of the SMTP Server is required. e.g. ntbox, or mail.' +
          'mydomain.com, or 123.456.789.123, ...'
        WordWrap = True
        OnClick = Label7Click
      end
      object radSMTP: TBorRadio
        Left = 10
        Top = 53
        Width = 259
        Height = 20
        Align = alRight
        Caption = 'SMTP - Simple Mail Transfer Protocol'
        Checked = True
        TabOrder = 0
        TabStop = True
        TextId = 0
      end
      object radMAPI: TBorRadio
        Left = 10
        Top = 173
        Width = 248
        Height = 20
        Align = alRight
        Caption = 'MAPI / Microsoft Exchange'
        TabOrder = 1
        TextId = 0
      end
      object txtEmlSMTP: Text8Pt
        Left = 84
        Top = 148
        Width = 121
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbEmailAttach'
      object Label1: TLabel
        Left = 29
        Top = 72
        Width = 253
        Height = 44
        AutoSize = False
        Caption = 
          'This is our own internal format and is supplied with the Paperle' +
          'ss Module. Specify the printer to be used when creating the emai' +
          'l image:-'
        WordWrap = True
        OnClick = Label1Click
      end
      object Label2: TLabel
        Left = 29
        Top = 163
        Width = 253
        Height = 44
        AutoSize = False
        Caption = 
          'We also support the industry standard Adobe Acrobat format throu' +
          'gh the PDF Writer printer driver which comes with Adobe Acrobat.'
        WordWrap = True
        OnClick = Label2Click
      end
      object Label83: Label8
        Left = 4
        Top = 5
        Width = 159
        Height = 19
        Caption = 'Email Attachment Type'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 4
        Top = 23
        Width = 282
        Height = 33
        AutoSize = False
        Caption = 
          'Documents can now be emailed to Customers, this section allows y' +
          'ou to decide the format of the sent documents:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label6: TLabel
        Left = 29
        Top = 209
        Width = 253
        Height = 30
        AutoSize = False
        Caption = 
          'Customers are responsible for purchasing their own licenced copi' +
          'es of Adobe Acrobat.'
        WordWrap = True
        OnClick = Label2Click
      end
      object Label10: TLabel
        Left = 29
        Top = 260
        Width = 253
        Height = 57
        AutoSize = False
        Caption = 
          'This is a subset of the full Adobe Acrobat format and is supplie' +
          'd free of charge with the Paperless Module. Specify the printer ' +
          'to be used when creating the email image:-'
        WordWrap = True
        OnClick = Label10Click
      end
      object radEmlEDF: TBorRadio
        Left = 10
        Top = 53
        Width = 216
        Height = 20
        Align = alRight
        Caption = 'Internal EDF Format'
        TabOrder = 0
        TextId = 0
      end
      object radEmlAdobe: TBorRadio
        Left = 10
        Top = 144
        Width = 259
        Height = 20
        Align = alRight
        Caption = 'Adobe Acrobat by Adobe Software'
        TabOrder = 1
        TextId = 0
      end
      object lstAttachPrn: TComboBox
        Left = 43
        Top = 117
        Width = 226
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 2
      end
      object radEmlIntPDF: TBorRadio
        Left = 10
        Top = 241
        Width = 216
        Height = 20
        Align = alRight
        Caption = 'Internal PDF Format'
        Checked = True
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object lstAttachPrn2: TComboBox
        Left = 43
        Top = 317
        Width = 226
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 4
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbFaxing'
      object Label3: TLabel
        Left = 28
        Top = 71
        Width = 253
        Height = 42
        AutoSize = False
        Caption = 
          'This is a simple Fax System that is intended for sites without e' +
          'xisting Fax Software. It is limited to sending faxes only.'
        WordWrap = True
        OnClick = Label3Click
      end
      object Label4: TLabel
        Left = 28
        Top = 132
        Width = 253
        Height = 18
        AutoSize = False
        Caption = 'This is a Microsoft'#39's Faxing system for Windows.'
        WordWrap = True
        OnClick = Label4Click
      end
      object Label5: TLabel
        Left = 28
        Top = 169
        Width = 253
        Height = 42
        AutoSize = False
        Caption = 
          'Exchequer allows Third-Party Fax Software to be linked into Exch' +
          'equer through an Interface DLL. Select your preferred software f' +
          'rom the list below:-'
        WordWrap = True
        OnClick = Label5Click
      end
      object Label84: Label8
        Left = 4
        Top = 5
        Width = 170
        Height = 19
        Caption = 'Method of Sending Faxes'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 4
        Top = 23
        Width = 282
        Height = 33
        AutoSize = False
        Caption = 
          'To send faxes through the Paperless Module, Exchequer needs to k' +
          'now which Fax system you want use:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object radFaxEnt: TBorRadio
        Left = 10
        Top = 52
        Width = 241
        Height = 20
        Align = alRight
        Caption = 'Exchequer Fax Server'
        Checked = True
        TabOrder = 0
        TabStop = True
        TextId = 0
        OnClick = CheckyChecky
      end
      object radFaxMAPI: TBorRadio
        Left = 10
        Top = 113
        Width = 241
        Height = 21
        Align = alRight
        Caption = 'MAPI / Microsoft Fax / Microsoft Exchange'
        TabOrder = 1
        TextId = 0
        OnClick = CheckyChecky
      end
      object radFaxThird: TBorRadio
        Left = 10
        Top = 150
        Width = 241
        Height = 21
        Align = alRight
        Caption = 'Third-Party Fax Software'
        TabOrder = 2
        TextId = 0
        OnClick = CheckyChecky
      end
      object lstThirdParty: TComboBox
        Left = 29
        Top = 214
        Width = 242
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 3
        OnClick = Label5Click
        Items.Strings = (
          'Other Third-Party Fax Software'
          'FaxNow3 by Red Rock Technologies'
          'FaxNow5 by Red Rock Technologies')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'nbNames'
      object Label85: Label8
        Left = 5
        Top = 5
        Width = 207
        Height = 19
        Caption = 'Email - Default Sender Details'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label88: Label8
        Left = 4
        Top = 31
        Width = 42
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label89: Label8
        Left = 8
        Top = 57
        Width = 38
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Email'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label810: Label8
        Left = 5
        Top = 81
        Width = 215
        Height = 19
        Caption = 'Faxing - Default Sender Details'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 4
        Top = 107
        Width = 42
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label812: Label8
        Left = 8
        Top = 133
        Width = 38
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Fax No'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object txtEmlName: Text8Pt
        Left = 51
        Top = 28
        Width = 230
        Height = 22
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
      object txtEmailAddr: Text8Pt
        Left = 51
        Top = 54
        Width = 230
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
      object txtFaxName: Text8Pt
        Left = 52
        Top = 104
        Width = 230
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
      object txtFaxNo: Text8Pt
        Left = 52
        Top = 130
        Width = 119
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
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
    end
  end
end
