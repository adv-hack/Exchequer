object Form1: TForm1
  Left = 374
  Top = 20
  Width = 446
  Height = 542
  BorderIcons = [biSystemMenu]
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 12
    Top = 7
    Width = 257
    Height = 18
    Caption = 'Step 1 - Select the Company Dataset'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 13
    Top = 29
    Width = 413
    Height = 35
    AutoSize = False
    Caption = 
      'Select the path of the Comapny Dataset you want to use from the ' +
      'list below and then click the Open Company Dataset button.'
    WordWrap = True
  end
  object lblCopyright: TLabel
    Left = 0
    Top = 494
    Width = 438
    Height = 14
    Align = alBottom
    Alignment = taCenter
    Caption = 'lblCopyright'
  end
  object btnInitSbsForm: TButton
    Left = 98
    Top = 101
    Width = 222
    Height = 25
    Caption = 'Open Company Dataset'
    TabOrder = 1
    OnClick = btnInitSbsFormClick
  end
  object lstCompanyPath: TComboBox
    Left = 74
    Top = 71
    Width = 292
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 128
    Width = 432
    Height = 359
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    object Label1: TLabel
      Left = 12
      Top = 8
      Width = 225
      Height = 18
      Caption = 'Step 2 - Identify the Transaction'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 13
      Top = 30
      Width = 364
      Height = 19
      AutoSize = False
      Caption = 
        'Enter the OurRef of the Transaction to be printed in the edit fi' +
        'eld below:-'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 75
      Top = 57
      Width = 35
      Height = 14
      Caption = 'OurRef'
    end
    object Label7: TLabel
      Left = 12
      Top = 88
      Width = 233
      Height = 18
      Caption = 'Step 3 - Specify the Form to Print'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 13
      Top = 110
      Width = 360
      Height = 19
      AutoSize = False
      Caption = 'Using the Browse button select the EFD Form to be printed:-'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 62
      Top = 138
      Width = 46
      Height = 14
      Caption = 'EFD Form'
    end
    object Label9: TLabel
      Left = 12
      Top = 170
      Width = 183
      Height = 18
      Caption = 'Step 4 - Select the Printer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 13
      Top = 192
      Width = 366
      Height = 19
      AutoSize = False
      Caption = 'Select the output printer to be used from the list below:-'
      WordWrap = True
    end
    object Label81: Label8
      Left = 39
      Top = 220
      Width = 33
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Printer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label11: TLabel
      Left = 11
      Top = 254
      Width = 92
      Height = 18
      Caption = 'Step 5 - Print'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 12
      Top = 276
      Width = 382
      Height = 19
      AutoSize = False
      Caption = 
        'Select the output type and then click the Print button to print ' +
        'the transaction:-'
      WordWrap = True
    end
    object edtOurRef: TEdit
      Left = 115
      Top = 54
      Width = 121
      Height = 22
      TabOrder = 0
      Text = 'SIN000000'
    end
    object edtForm: TEdit
      Left = 116
      Top = 135
      Width = 71
      Height = 22
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 1
      Text = 'NEWINV'
    end
    object FNBtn: TButton
      Left = 191
      Top = 135
      Width = 67
      Height = 21
      Hint = 
        'Choose Form or Font|Depending whether you are printing a form or' +
        ' a report, you will be able to either change the Form name or Fo' +
        'nt prior to printing.'
      HelpContext = 305
      Caption = '&Browse'
      Enabled = False
      TabOrder = 2
      OnClick = FNBtnClick
    end
    object Combo_Printers: TSBSComboBox
      Left = 77
      Top = 218
      Width = 244
      Height = 22
      Hint = 
        'Choose which printer|Use this option to select which printer you' +
        ' wish to use. Note, even when printing to screen you must select' +
        ' a valid printer.'
      HelpContext = 298
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 3
      MaxListWidth = 0
    end
    object btnSetupPrinter: TButton
      Left = 325
      Top = 218
      Width = 67
      Height = 21
      Hint = 
        'Access printer setup|Change the printer settings for the current' +
        'ly selected print device.'
      HelpContext = 302
      Caption = '&Setup'
      Enabled = False
      TabOrder = 4
      OnClick = btnSetupPrinterClick
    end
    object Radio_Printer: TBorRadio
      Left = 151
      Top = 302
      Width = 55
      Height = 20
      Hint = 
        'Send output to Printer|Sends output to the currently selected pr' +
        'int device.'
      HelpContext = 300
      Align = alNone
      Caption = 'Printer'
      Checked = True
      TabOrder = 5
      TabStop = True
      TextId = 0
    end
    object Radio_Preview: TBorRadio
      Left = 218
      Top = 302
      Width = 62
      Height = 20
      Hint = 
        'Send output to Screen|Sends all output to a print preview screen' +
        ', which can optionaly be sent to  the currently selected printer'
      HelpContext = 300
      Align = alRight
      Caption = 'Screen'
      TabOrder = 6
      TextId = 0
    end
    object btnPrint: TButton
      Left = 177
      Top = 333
      Width = 67
      Height = 21
      HelpContext = 303
      Caption = '&Print'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 7
      OnClick = btnPrintClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'All Forms|*.DEF;*.EFD|Form Designer Forms (*.EFD)|*.EFD|PCC Form' +
      's (*.DEF)|*.DEF'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofShareAware]
    Left = 384
    Top = 247
  end
end
