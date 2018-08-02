inherited frmSecWarn2: TfrmSecWarn2
  Left = 287
  Top = 147
  HelpContext = 12
  ActiveControl = nil
  Caption = 'frmSecWarn2'
  ClientHeight = 398
  ClientWidth = 596
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 353
    Width = 573
  end
  inherited TitleLbl: TLabel
    Width = 419
    Caption = 'Contact Local Distributor'
  end
  inherited InstrLbl: TLabel
    Width = 419
    Height = 34
    Caption = 
      'You can contact your local distributor through Email, Fax or Tel' +
      'ephone. Select the Tab representing your desired method of commu' +
      'nication and follow the instructions.'
  end
  inherited HelpBtn: TButton
    Top = 370
  end
  inherited Panel1: TPanel
    Height = 336
    TabOrder = 5
    inherited Image1: TImage
      Height = 334
    end
  end
  inherited ExitBtn: TButton
    Top = 370
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 414
    Top = 370
    Width = 85
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 506
    Top = 370
    Caption = '&Close'
    Enabled = False
    Visible = False
  end
  object PageControl1: TPageControl
    Left = 169
    Top = 88
    Width = 417
    Height = 263
    ActivePage = tabshFax
    TabIndex = 1
    TabOrder = 0
    object tabshEmail: TTabSheet
      Caption = 'Email'
      object Label7: TLabel
        Left = 5
        Top = 7
        Width = 400
        Height = 29
        AutoSize = False
        Caption = 
          'You can get a new Security Code by emailing your details to your' +
          ' Local Distributor, for security all details are passed in an en' +
          'crypted attachment on the email.'
        WordWrap = True
      end
      object Label10: TLabel
        Left = 5
        Top = 41
        Width = 400
        Height = 16
        AutoSize = False
        Caption = 
          'Before sending an email, you will have to give some details on y' +
          'our email setup'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 9
        Top = 68
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Email Method'
        WordWrap = True
      end
      object Label15: TLabel
        Left = 9
        Top = 92
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SMTP Server'
        WordWrap = True
      end
      object Label16: TLabel
        Left = 238
        Top = 85
        Width = 164
        Height = 31
        AutoSize = False
        Caption = '(e.g. ntbox, or mail.mydomain.com, or 123.456.789.123, etc...)'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 5
        Top = 118
        Width = 400
        Height = 49
        AutoSize = False
        Caption = 
          'Once completed, you can click the Send Email button. This will a' +
          'sk you a few details about your Company and how to contact you a' +
          'nd then it will send the email to '
        WordWrap = True
      end
      object Bevel3: TBevel
        Left = 5
        Top = 201
        Width = 400
        Height = 5
        Shape = bsTopLine
      end
      object lstEmailMthd: TComboBox
        Left = 95
        Top = 65
        Width = 99
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = lstEmailMthdChange
        Items.Strings = (
          'MAPI'
          'SMTP')
      end
      object edtSMTP: Text8Pt
        Left = 95
        Top = 88
        Width = 138
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
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
      object btnEmlSend: TSBSButton
        Left = 227
        Top = 208
        Width = 85
        Height = 23
        Caption = '&Send Email'
        TabOrder = 2
        OnClick = BitBtn1Click
        TextId = 0
      end
      object btnEmlClose: TSBSButton
        Left = 320
        Top = 208
        Width = 85
        Height = 23
        Cancel = True
        Caption = '&Close'
        TabOrder = 3
        OnClick = btnEmlCloseClick
        TextId = 0
      end
    end
    object tabshFax: TTabSheet
      Caption = 'Fax'
      object Label8: TLabel
        Left = 5
        Top = 7
        Width = 400
        Height = 30
        AutoSize = False
        Caption = 
          'You can get a new Security Code by faxing your details through t' +
          'o your local distributor on the number listed below:-'
        WordWrap = True
      end
      object Label13: TLabel
        Left = 10
        Top = 40
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Contact'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 10
        Top = 58
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Fax Number'
        WordWrap = True
      end
      object lblFaxCompany: TLabel
        Left = 95
        Top = 40
        Width = 300
        Height = 17
        AutoSize = False
        ShowAccelChar = False
        WordWrap = True
      end
      object lblFaxNo: TLabel
        Left = 95
        Top = 58
        Width = 300
        Height = 17
        AutoSize = False
        ShowAccelChar = False
        WordWrap = True
      end
      object Label17: TLabel
        Left = 5
        Top = 81
        Width = 400
        Height = 35
        AutoSize = False
        Caption = 
          'Clicking the Print Fax Page button, below, will print out a page' +
          ' containing your details for you to fax through to the distribut' +
          'or.'
        WordWrap = True
      end
      object Bevel2: TBevel
        Left = 5
        Top = 201
        Width = 400
        Height = 5
        Shape = bsTopLine
      end
      object btnFaxPrint: TSBSButton
        Left = 227
        Top = 208
        Width = 85
        Height = 23
        Caption = '&Print Fax Page'
        TabOrder = 0
        OnClick = btnFaxPrintClick
        TextId = 0
      end
      object btnFaxClose: TSBSButton
        Left = 320
        Top = 208
        Width = 85
        Height = 23
        Cancel = True
        Caption = '&Close'
        TabOrder = 1
        OnClick = btnFaxCloseClick
        TextId = 0
      end
    end
    object tabshPhone: TTabSheet
      Caption = 'Telephone'
      object Label1: TLabel
        Left = 6
        Top = 7
        Width = 400
        Height = 19
        AutoSize = False
        Caption = 
          'You can get a new Security Code by contacting your local distrib' +
          'utor:-'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 9
        Top = 102
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'ESN'
        WordWrap = True
        OnDblClick = edtESNDblClick
      end
      object Label4: TLabel
        Left = 10
        Top = 126
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Security Code'
        WordWrap = True
        OnDblClick = Label4DblClick
      end
      object Label2: TLabel
        Left = 10
        Top = 150
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Release Code'
        WordWrap = True
      end
      object Label5: TLabel
        Left = 11
        Top = 26
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Contact'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 11
        Top = 44
        Width = 76
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Phone Number'
        WordWrap = True
      end
      object lblPhoneContact: TLabel
        Left = 95
        Top = 26
        Width = 300
        Height = 17
        AutoSize = False
        ShowAccelChar = False
        WordWrap = True
      end
      object lblPhoneNo: TLabel
        Left = 95
        Top = 44
        Width = 300
        Height = 17
        AutoSize = False
        ShowAccelChar = False
        WordWrap = True
      end
      object Label9: TLabel
        Left = 5
        Top = 65
        Width = 386
        Height = 28
        AutoSize = False
        Caption = 
          'They will ask for the following details, and will give you a Rel' +
          'ease Code to enter into the Release Code field below.'
        WordWrap = True
      end
      object Bevel4: TBevel
        Left = 5
        Top = 201
        Width = 400
        Height = 5
        Shape = bsTopLine
      end
      object Label18: TLabel
        Left = 5
        Top = 178
        Width = 386
        Height = 15
        AutoSize = False
        Caption = 'After typing in the Release Code click the Accept button.'
        WordWrap = True
      end
      object edtRelCode: Text8Pt
        Left = 96
        Top = 147
        Width = 121
        Height = 22
        EditMask = '>cccccccccc;0; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextId = 0
        ViaSBtn = False
      end
      object edtESN: Text8Pt
        Left = 95
        Top = 99
        Width = 205
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
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object edtSecCode: Text8Pt
        Left = 95
        Top = 123
        Width = 121
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
        TabOrder = 1
        OnDblClick = edtSecCodeDblClick
        TextId = 0
        ViaSBtn = False
      end
      object btnTelAccept: TSBSButton
        Left = 227
        Top = 208
        Width = 85
        Height = 23
        Caption = '&Accept'
        TabOrder = 3
        OnClick = btnTelAcceptClick
        TextId = 0
      end
      object btnTelClose: TSBSButton
        Left = 320
        Top = 208
        Width = 85
        Height = 23
        Cancel = True
        Caption = '&Close'
        TabOrder = 4
        OnClick = btnFaxCloseClick
        TextId = 0
      end
    end
  end
  object ReportPrinter1: TReportPrinter
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    OnPrint = ReportPrinter1Print
    OnBeforePrint = ReportPrinter1BeforePrint
    Left = 5
    Top = 5
  end
  object ReportFiler1: TReportFiler
    StatusFormat = 'Printing page %p'
    LineHeightMethod = lhmFont
    Units = unMM
    UnitsFactor = 25.4
    Title = 'ReportPrinter Report'
    Orientation = poPortrait
    ScaleX = 100
    ScaleY = 100
    FileName = 'c:\1.edf'
    StreamMode = smFile
    OnPrint = ReportPrinter1Print
    OnBeforePrint = ReportPrinter1BeforePrint
    Left = 7
    Top = 43
  end
end
