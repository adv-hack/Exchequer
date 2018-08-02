inherited frmReportingUsers: TfrmReportingUsers
  Left = 324
  Top = 143
  Width = 749
  Height = 418
  HelpContext = 3
  Caption = 'frmReportingUsers'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 741
  end
  inherited lblBanner: TLabel
    Width = 186
    Caption = 'Reporting Users'
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 43
    Width = 741
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object panIntro: TPanel
      Left = 0
      Top = 0
      Width = 741
      Height = 118
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 7
        Width = 723
        Height = 28
        AutoSize = False
        Caption = 
          'The companies shown below will be converted from the specified E' +
          'xchequer Pervasive Edition installation into the specified Exche' +
          'quer SQL Edition installation.  Please note that any data in the' +
          ' Exchequer SQL Edition will be lost.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 8
        Top = 43
        Width = 700
        Height = 28
        Caption = 
          'For each company the conversion will create a Reporting User whi' +
          'ch can be used to access the company data from third-party appli' +
          'cations, the Reporting User Id'#39's must not already exist in the D' +
          'atabase Engine.'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 36
        Top = 101
        Width = 29
        Height = 14
        Caption = 'Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 114
        Top = 101
        Width = 86
        Height = 14
        Caption = 'Company Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 417
        Top = 101
        Width = 96
        Height = 14
        Caption = 'Reporting User Id'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 545
        Top = 101
        Width = 142
        Height = 14
        Caption = 'Reporting User Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 8
        Top = 79
        Width = 707
        Height = 17
        AutoSize = False
        Caption = 
          'Please check that all the companies requiring conversion are lis' +
          'ted below and modify the Reporting User details as required:-'
        WordWrap = True
      end
    end
    object panBody: TPanel
      Left = 0
      Top = 118
      Width = 741
      Height = 102
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        741
        102)
      object scrlCompanies: TScrollBox
        Left = 4
        Top = 0
        Width = 724
        Height = 99
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object panFooter: TPanel
      Left = 0
      Top = 220
      Width = 741
      Height = 121
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        741
        121)
      object Label4: TLabel
        Left = 8
        Top = 3
        Width = 73
        Height = 14
        Caption = 'Security Note'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 17
        Width = 723
        Height = 33
        AutoSize = False
        Caption = 
          'These Reporting Users will give read-only access to your account' +
          's database, please ensure that the passwords are suitably comple' +
          'x and that the User Id'#39's and Passwords are only available to tru' +
          'sted staff who need them.  '
        WordWrap = True
      end
      object Label9: TLabel
        Left = 8
        Top = 49
        Width = 723
        Height = 18
        AutoSize = False
        Caption = 
          'Please ensure that the User Ids and Passwords comply with any co' +
          'mplexity policies you have defined within your Database Engine.'
        WordWrap = True
      end
      object Label10: TLabel
        Left = 8
        Top = 67
        Width = 723
        Height = 18
        AutoSize = False
        Caption = 
          'For more information on defining Strong Passwords go to www.micr' +
          'osoft.com and search for '#39'Strong Password'#39'.'
        WordWrap = True
      end
      object btnContinue: TButton
        Left = 558
        Top = 93
        Width = 80
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Continue'
        TabOrder = 0
        OnClick = btnContinueClick
      end
      object btnClose: TButton
        Left = 650
        Top = 93
        Width = 80
        Height = 21
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Close'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
end
