inherited frmCustSurvey: TfrmCustSurvey
  Left = 402
  Top = 140
  ActiveControl = nil
  Caption = 'frmCustSurvey'
  ClientHeight = 461
  ClientWidth = 596
  KeyPreview = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    596
    461)
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 416
    Width = 573
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited TitleLbl: TLabel
    Width = 421
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Details Update'
  end
  inherited InstrLbl: TLabel
    Width = 418
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Please supply the following information so that we can update ou' +
      'r internal records.'
  end
  inherited imgSide: TImage
    Height = 260
    Anchors = [akLeft, akTop, akBottom]
  end
  inherited HelpBtn: TButton
    Top = 433
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 399
    Anchors = [akLeft, akTop, akBottom]
    DesignSize = (
      145
      399)
    inherited Image1: TImage
      Height = 397
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited ExitBtn: TButton
    Top = 433
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 419
    Top = 433
    Anchors = [akRight, akBottom]
  end
  inherited NextBtn: TButton
    Left = 505
    Top = 433
    Anchors = [akRight, akBottom]
  end
  object Notebook1: TNotebook
    Left = 165
    Top = 72
    Width = 418
    Height = 347
    TabOrder = 5
    object TPage
      Left = 0
      Top = 0
      Caption = 'First'
      object Label1: TLabel
        Left = 3
        Top = 56
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Company Name'
      end
      object Label3: TLabel
        Left = 3
        Top = 31
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Contact Name'
      end
      object Label4: TLabel
        Left = 3
        Top = 81
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Address'
      end
      object Label6: TLabel
        Left = 3
        Top = 266
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Email Address'
      end
      object Label7: TLabel
        Left = 3
        Top = 241
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Fax'
      end
      object Label5: TLabel
        Left = 3
        Top = 216
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Telephone'
      end
      object Label8: TLabel
        Left = 3
        Top = 191
        Width = 87
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Post Code'
      end
      object Label9: TLabel
        Left = 3
        Top = 294
        Width = 397
        Height = 29
        AutoSize = False
        Caption = 
          'We would also like a list of your Company Names for our records,' +
          ' please tick the box below to supply this information with the s' +
          'urvey results:-'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 6
        Top = 7
        Width = 155
        Height = 16
        Caption = 'Your Company Details'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtCompanyName: TEdit
        Left = 94
        Top = 53
        Width = 273
        Height = 21
        TabOrder = 1
      end
      object edtContactName: TEdit
        Left = 94
        Top = 28
        Width = 188
        Height = 21
        TabOrder = 0
      end
      object edtAddress1: TEdit
        Left = 94
        Top = 78
        Width = 273
        Height = 21
        TabOrder = 2
      end
      object edtAddress2: TEdit
        Left = 94
        Top = 100
        Width = 273
        Height = 21
        TabOrder = 3
      end
      object edtAddress3: TEdit
        Left = 94
        Top = 122
        Width = 273
        Height = 21
        TabOrder = 4
      end
      object edtAddress5: TEdit
        Left = 94
        Top = 166
        Width = 273
        Height = 21
        TabOrder = 6
      end
      object edtAddress4: TEdit
        Left = 94
        Top = 144
        Width = 273
        Height = 21
        TabOrder = 5
      end
      object edtEmail: TEdit
        Left = 94
        Top = 263
        Width = 273
        Height = 21
        TabOrder = 10
      end
      object edtFax: TEdit
        Left = 94
        Top = 238
        Width = 188
        Height = 21
        TabOrder = 9
      end
      object edtPhone: TEdit
        Left = 94
        Top = 213
        Width = 188
        Height = 21
        TabOrder = 8
      end
      object edtPostCode: TEdit
        Left = 94
        Top = 188
        Width = 101
        Height = 21
        TabOrder = 7
      end
      object chkSendCompanies: TCheckBox
        Left = 20
        Top = 326
        Width = 357
        Height = 17
        Caption = 'Include a list of Company Names in the Survey Results'
        Checked = True
        State = cbChecked
        TabOrder = 11
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Last'
      object Label11: TLabel
        Left = 8
        Top = 28
        Width = 399
        Height = 13
        AutoSize = False
        Caption = 'What Accounting Software did your company use before Exchequer:-'
      end
      object Label13: TLabel
        Left = 6
        Top = 7
        Width = 226
        Height = 16
        Caption = 'When You Purchased Exchequer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 9
        Top = 77
        Width = 110
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Other, please specify'
      end
      object Label15: TLabel
        Left = 8
        Top = 104
        Width = 399
        Height = 13
        AutoSize = False
        Caption = 
          'What was the position of the person responsible for purchasing E' +
          'xchequer:-'
      end
      object Label16: TLabel
        Left = 9
        Top = 153
        Width = 110
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Other, please specify'
      end
      object Label10: TLabel
        Left = 6
        Top = 184
        Width = 215
        Height = 16
        Caption = 'Size && Nature of Your Business'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 4
        Top = 208
        Width = 115
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Approximate Turnover'
      end
      object Label17: TLabel
        Left = 4
        Top = 234
        Width = 115
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Number of Employees'
      end
      object Label18: TLabel
        Left = 8
        Top = 261
        Width = 399
        Height = 13
        AutoSize = False
        Caption = 'What Industry Sector applies to your company:-'
      end
      object Label19: TLabel
        Left = 9
        Top = 309
        Width = 110
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Other, please specify'
      end
      object lstAccountsPackage: TComboBox
        Left = 18
        Top = 48
        Width = 372
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstAccountsPackageClick
      end
      object edtOtherPackage: TEdit
        Left = 124
        Top = 74
        Width = 260
        Height = 21
        TabOrder = 1
      end
      object lstPersonResponsible: TComboBox
        Left = 18
        Top = 124
        Width = 372
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnClick = lstPersonResponsibleClick
      end
      object edtOtherJobPosition: TEdit
        Left = 124
        Top = 150
        Width = 260
        Height = 21
        TabOrder = 3
      end
      object lstCurrency: TComboBox
        Left = 124
        Top = 205
        Width = 58
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
      end
      object lstTurnoverBands: TComboBox
        Left = 185
        Top = 205
        Width = 176
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object lstStaffBands: TComboBox
        Left = 124
        Top = 231
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
      end
      object lstIndustry: TComboBox
        Left = 18
        Top = 281
        Width = 372
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 7
        OnClick = lstIndustryClick
      end
      object edtOtherIndustry: TEdit
        Left = 124
        Top = 306
        Width = 260
        Height = 21
        TabOrder = 8
      end
    end
  end
end
