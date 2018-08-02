object frmLicenceTest: TfrmLicenceTest
  Left = 272
  Top = 242
  Width = 814
  Height = 565
  Caption = 'Licence Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    806
    538)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 3
    Width = 799
    Height = 531
    ActivePage = tabshMain
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 0
    TabOrder = 0
    object tabshMain: TTabSheet
      Caption = 'Main'
      DesignSize = (
        791
        503)
      object Label1: TLabel
        Left = 5
        Top = 12
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'CDKey'
      end
      object Label2: TLabel
        Left = 5
        Top = 67
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Components'
      end
      object Label4: TLabel
        Left = 5
        Top = 42
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Customer#'
      end
      object Label5: TLabel
        Left = 28
        Top = 135
        Width = 55
        Height = 26
        Alignment = taRightJustify
        Caption = 'Initial Restrictions'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 5
        Top = 212
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Licence Codes'
      end
      object Label6: TLabel
        Left = 5
        Top = 475
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'LITE Licence'
      end
      object Label7: TLabel
        Left = 28
        Top = 328
        Width = 55
        Height = 26
        Alignment = taRightJustify
        Caption = 'Licence Restrictions'
        WordWrap = True
      end
      object edtCDKey: TEdit
        Left = 88
        Top = 9
        Width = 324
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = '2ZW9JGQQ4QQQQQQQQQQQQQQQ'
      end
      object btnDecodeCDKey: TButton
        Left = 417
        Top = 8
        Width = 107
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Decode CDKey'
        TabOrder = 1
        OnClick = btnDecodeCDKeyClick
      end
      object btnGetLicCodes: TButton
        Left = 530
        Top = 8
        Width = 107
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Get Lic Codes'
        TabOrder = 2
        OnClick = btnGetLicCodesClick
      end
      object edtCustomerNo: TEdit
        Left = 88
        Top = 39
        Width = 185
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object lstComponents: TListBox
        Left = 88
        Top = 64
        Width = 546
        Height = 66
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ItemHeight = 13
        TabOrder = 4
      end
      object lstInitialRestrictions: TListBox
        Left = 88
        Top = 133
        Width = 546
        Height = 66
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ItemHeight = 13
        TabOrder = 5
      end
      object btnLITEEquiv: TButton
        Left = 639
        Top = 471
        Width = 107
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Calc LITE Equiv'
        TabOrder = 14
        OnClick = btnLITEEquivClick
      end
      object lstLicenceCodes: TListBox
        Left = 88
        Top = 209
        Width = 546
        Height = 114
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 6
      end
      object edtLITEVersion: TEdit
        Left = 88
        Top = 472
        Width = 546
        Height = 21
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 13
      end
      object lstLicenceRestrictions: TListBox
        Left = 88
        Top = 326
        Width = 546
        Height = 136
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ItemHeight = 13
        TabOrder = 12
      end
      object btnAddLicenceKey: TButton
        Left = 640
        Top = 209
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Add Licence Key'
        TabOrder = 7
        OnClick = btnAddLicenceKeyClick
      end
      object btnEditLicenceKey: TButton
        Left = 640
        Top = 232
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Edit Licence Key'
        TabOrder = 8
        OnClick = btnEditLicenceKeyClick
      end
      object btnDeleteLicenceKey: TButton
        Left = 640
        Top = 255
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Delete Licence Key'
        TabOrder = 9
        OnClick = btnDeleteLicenceKeyClick
      end
      object btnValidateLicenceKey: TButton
        Left = 640
        Top = 301
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Validate Licence Key'
        TabOrder = 11
        OnClick = btnValidateLicenceKeyClick
      end
      object btnClearAllKeys: TButton
        Left = 640
        Top = 278
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Clear All Keys'
        TabOrder = 10
        OnClick = btnClearAllKeysClick
      end
      object btnEnterLicenceDetails: TButton
        Left = 640
        Top = 327
        Width = 111
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Enter Licence Details'
        TabOrder = 15
        OnClick = btnEnterLicenceDetailsClick
      end
    end
    object tabshLogging: TTabSheet
      Caption = 'Logging'
      ImageIndex = 1
      DesignSize = (
        791
        503)
      object memLogging: TMemo
        Left = 3
        Top = 4
        Width = 784
        Height = 495
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
end
