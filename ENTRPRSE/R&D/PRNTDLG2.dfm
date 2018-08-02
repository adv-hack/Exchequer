object PrintDlg: TPrintDlg
  Left = 519
  Top = 207
  HelpContext = 302
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Print Setup'
  ClientHeight = 459
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 5
    Top = 4
    Width = 479
    Height = 446
    ActivePage = tabshPrinter
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object tabshPrinter: TTabSheet
      HelpContext = 297
      Caption = 'Printer'
      object SBSBackGroup3: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 383
        Height = 75
        Caption = 'Printer'
        TextId = 0
      end
      object Label81: Label8
        Left = 6
        Top = 25
        Width = 37
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
      object FNLab: Label8
        Left = 142
        Top = 51
        Width = 69
        Height = 24
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 8
        Top = 51
        Width = 36
        Height = 22
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Copies'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup4: TSBSBackGroup
        Left = 3
        Top = 83
        Width = 149
        Height = 43
        Caption = 'Output To'
        TextId = 0
      end
      object bgrpTest: TSBSBackGroup
        Left = 162
        Top = 83
        Width = 98
        Height = 43
        TextId = 0
      end
      object Radio_Printer: TBorRadio
        Left = 11
        Top = 100
        Width = 63
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 300
        Align = alNone
        Caption = 'Printer'
        CheckColor = clWindowText
        Checked = True
        TabOrder = 5
        TabStop = True
        TextId = 0
      end
      object Radio_Preview: TBorRadio
        Left = 78
        Top = 100
        Width = 70
        Height = 20
        Hint = 
          'Send output to Screen|Sends all output to a print preview screen' +
          ', which can optionaly be sent to  the currently selected printer'
        HelpContext = 300
        Align = alRight
        Caption = 'Screen'
        CheckColor = clWindowText
        TabOrder = 6
        TextId = 0
      end
      object Combo_Printers: TSBSComboBox
        Left = 47
        Top = 21
        Width = 252
        Height = 22
        Hint = 
          'Choose which printer|Use this option to select which printer you' +
          ' wish to use. Note, even when printing to screen you must select' +
          ' a valid printer.'
        HelpContext = 298
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = Combo_PrintersClick
        MaxListWidth = 0
      end
      object btnSetupPrinter: TButton
        Left = 303
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Access printer setup|Change the printer settings for the current' +
          'ly selected print device.'
        HelpContext = 302
        Caption = '&Setup'
        TabOrder = 1
        OnClick = SetupPrinter
      end
      object Button_OK: TButton
        Left = 221
        Top = 132
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        Enabled = False
        ModalResult = 1
        TabOrder = 8
        OnClick = Button_OKClick
      end
      object Button_Cancel: TButton
        Left = 310
        Top = 132
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 9
        OnClick = Button_CancelClick
      end
      object FNBtn: TButton
        Left = 303
        Top = 48
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 305
        Caption = '&Browse'
        TabOrder = 4
        OnClick = SelectFormOrFont
      end
      object FNF: Text8Pt
        Left = 216
        Top = 48
        Width = 83
        Height = 22
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 301
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        OnChange = FNFChange
        OnDblClick = SelectFormOrFont
        TextId = 0
        ViaSBtn = False
      end
      object CopiesF: Text8Pt
        Left = 47
        Top = 48
        Width = 38
        Height = 22
        Hint = 
          'Print how many copies?|Allows the number of copies for the selec' +
          'ted form/report to be specified. A default value can be specifie' +
          'd for forms in the Form desginer.'
        AutoSize = False
        Color = clWhite
        EditMask = '   99;0; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 5
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '1'
        OnExit = CopiesFChange
        TextId = 0
        ViaSBtn = False
      end
      object Radio_Test: TBorCheck
        Left = 171
        Top = 97
        Width = 81
        Height = 20
        Hint = 
          'Print the selected form in a test mode|Prints the selected form ' +
          'in a special test mode for alignment purposes.'
        HelpContext = 549
        Align = alRight
        Caption = 'Test Mode'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        ShowHint = True
        TabOrder = 7
        TextId = 0
      end
    end
    object tabshFax: TTabSheet
      HelpContext = 1187
      Caption = 'Fax'
      object SBSBackGroup8: TSBSBackGroup
        Left = 3
        Top = 52
        Width = 215
        Height = 71
        Caption = 'Print Forms'
        TextId = 0
      end
      object SBSBackGroup1: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 383
        Height = 47
        Caption = 'Printer'
        TextId = 0
      end
      object Label84: Label8
        Left = 6
        Top = 25
        Width = 37
        Height = 21
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
      object Label86: Label8
        Left = 7
        Top = 69
        Width = 35
        Height = 24
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblFaxCover: Label8
        Left = 6
        Top = 93
        Width = 36
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Cover'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup2: TSBSBackGroup
        Left = 3
        Top = 124
        Width = 383
        Height = 175
        Caption = 'Fax Information'
        TextId = 0
      end
      object Label88: Label8
        Left = 6
        Top = 145
        Width = 37
        Height = 21
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'From'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label89: Label8
        Left = 6
        Top = 171
        Width = 37
        Height = 20
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'To'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label810: Label8
        Left = 6
        Top = 198
        Width = 37
        Height = 29
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Note'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 224
        Top = 145
        Width = 19
        Height = 21
        Alignment = taRightJustify
        AutoSize = False
        Caption = '#'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label812: Label8
        Left = 224
        Top = 171
        Width = 19
        Height = 21
        Alignment = taRightJustify
        AutoSize = False
        Caption = '#'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup9: TSBSBackGroup
        Left = 226
        Top = 52
        Width = 160
        Height = 71
        Caption = 'Output To'
        TextId = 0
      end
      object Label85: Label8
        Left = 6
        Top = 272
        Width = 37
        Height = 21
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Priority'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lstFaxPrinter: TSBSComboBox
        Left = 47
        Top = 21
        Width = 252
        Height = 22
        Hint = 
          'Choose which printer|Use this option to select which printer you' +
          ' wish to use. Note, even when printing to screen you must select' +
          ' a valid printer.'
        HelpContext = 1191
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 0
        OnClick = SelectPrinter
        MaxListWidth = 0
      end
      object btnFaxSetupPrinter: TButton
        Left = 303
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Access printer setup|Change the printer settings for the current' +
          'ly selected print device.'
        HelpContext = 1191
        Caption = '&Setup'
        TabOrder = 1
        OnClick = SetupPrinter
      end
      object btnFaxOK: TButton
        Left = 220
        Top = 305
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 14
        OnClick = btnFaxOKClick
      end
      object btnFaxCancel: TButton
        Left = 309
        Top = 305
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 15
        OnClick = Button_CancelClick
      end
      object btnFaxBrowseForm: TButton
        Left = 134
        Top = 66
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1194
        Caption = '&Browse'
        TabOrder = 3
        OnClick = btnFaxBrowseFormClick
      end
      object edtFaxForm: Text8Pt
        Left = 47
        Top = 66
        Width = 83
        Height = 22
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1192
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnChange = edtFaxFormChange
        OnDblClick = btnFaxBrowseFormClick
        TextId = 0
        ViaSBtn = False
      end
      object edtFaxCover: Text8Pt
        Left = 47
        Top = 92
        Width = 83
        Height = 22
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1193
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
        OnChange = edtFaxCoverChange
        OnDblClick = btnFaxBrowseCoverClick
        TextId = 0
        ViaSBtn = False
      end
      object btnFaxBrowseCover: TButton
        Left = 134
        Top = 92
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1194
        Caption = 'B&rowse'
        TabOrder = 5
        OnClick = btnFaxBrowseCoverClick
      end
      object edtFaxFromName: Text8Pt
        Left = 47
        Top = 142
        Width = 175
        Height = 22
        HelpContext = 1196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        TextId = 0
        ViaSBtn = False
      end
      object edtFaxToName: Text8Pt
        Left = 47
        Top = 168
        Width = 175
        Height = 22
        Hint = 
          'Double click to drill down|Double clicking or using the down but' +
          'ton will drill down to the record for this field. The up button ' +
          'will search for the nearest match.'
        HelpContext = 1197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnDblClick = edtFaxToNameDblClick
        OnExit = edtFaxToNameExit
        TextId = 0
        ViaSBtn = False
        ShowHilight = True
      end
      object edtFaxFromNo: Text8Pt
        Left = 245
        Top = 142
        Width = 133
        Height = 22
        HelpContext = 1196
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        TextId = 0
        ViaSBtn = False
      end
      object edtFaxToNo: Text8Pt
        Left = 245
        Top = 168
        Width = 133
        Height = 22
        HelpContext = 1197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        TextId = 0
        ViaSBtn = False
      end
      object memFaxMessage: TMemo
        Left = 47
        Top = 195
        Width = 331
        Height = 69
        HelpContext = 1198
        MaxLength = 255
        TabOrder = 12
      end
      object radFaxPrinter: TBorRadio
        Left = 237
        Top = 68
        Width = 63
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 1195
        Align = alNone
        Caption = 'Fax'
        CheckColor = clWindowText
        Checked = True
        TabOrder = 6
        TabStop = True
        TextId = 0
      end
      object radFaxPreview: TBorRadio
        Left = 237
        Top = 92
        Width = 70
        Height = 20
        Hint = 
          'Send output to Screen|Sends all output to a print preview screen' +
          ', which can optionaly be sent to  the currently selected printer'
        HelpContext = 1195
        Align = alRight
        Caption = 'Screen'
        CheckColor = clWindowText
        TabOrder = 7
        TextId = 0
      end
      object lstFaxPriority: TSBSComboBox
        Left = 47
        Top = 268
        Width = 175
        Height = 22
        Hint = 
          'Choose which printer|Use this option to select which printer you' +
          ' wish to use. Note, even when printing to screen you must select' +
          ' a valid printer.'
        HelpContext = 1199
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 13
        OnClick = Combo_PrintersClick
        Items.Strings = (
          'Urgent'
          'Normal'
          'Off Peak')
        MaxListWidth = 0
      end
    end
    object tabshEmail: TTabSheet
      HelpContext = 1188
      Caption = 'Email'
      object SBSBackGroup6: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 215
        Height = 73
        Caption = 'Print Forms'
        TextId = 0
      end
      object Label813: Label8
        Left = 13
        Top = 24
        Width = 29
        Height = 24
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblEmailCover: Label8
        Left = 7
        Top = 51
        Width = 35
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Cover'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup5: TSBSBackGroup
        Left = 318
        Top = 4
        Width = 149
        Height = 73
        Caption = 'Email Options'
        TextId = 0
      end
      object SBSBackGroup10: TSBSBackGroup
        Left = 224
        Top = 4
        Width = 88
        Height = 73
        Caption = 'Output To'
        TextId = 0
      end
      object btnEmlOK: TButton
        Left = 303
        Top = 344
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 9
        OnClick = btnEmlOKClick
      end
      object btnEmlCancel: TButton
        Left = 391
        Top = 344
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 10
        OnClick = Button_CancelClick
      end
      object btnEmlBrowseForm: TButton
        Left = 134
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1194
        Caption = '&Browse'
        TabOrder = 1
        OnClick = btnEmlBrowseFormClick
      end
      object edtEmlForm: Text8Pt
        Left = 47
        Top = 21
        Width = 83
        Height = 22
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1192
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnChange = FNFChange
        OnDblClick = btnEmlBrowseFormClick
        TextId = 0
        ViaSBtn = False
      end
      object edtEmlCover: Text8Pt
        Left = 47
        Top = 48
        Width = 83
        Height = 22
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1193
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnChange = FNFChange
        OnDblClick = btnEmlBrowseCoverClick
        TextId = 0
        ViaSBtn = False
      end
      object btnEmlBrowseCover: TButton
        Left = 134
        Top = 48
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 1194
        Caption = '&Browse'
        TabOrder = 3
        OnClick = btnEmlBrowseCoverClick
      end
      object chkEmlReader: TCheckBox
        Left = 326
        Top = 50
        Width = 128
        Height = 17
        HelpContext = 1201
        Caption = 'Send Reader'
        TabOrder = 7
        OnClick = chkEmlReaderClick
      end
      object raadEmlPrinter: TBorRadio
        Left = 232
        Top = 22
        Width = 63
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 1200
        Align = alNone
        Caption = 'Email'
        CheckColor = clWindowText
        Checked = True
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object radEmlPreview: TBorRadio
        Left = 232
        Top = 47
        Width = 70
        Height = 20
        Hint = 
          'Send output to Screen|Sends all output to a print preview screen' +
          ', which can optionaly be sent to  the currently selected printer'
        HelpContext = 1200
        Align = alRight
        Caption = 'Screen'
        CheckColor = clWindowText
        TabOrder = 5
        TextId = 0
      end
      object grpEmailDets: TSBSGroup
        Left = 3
        Top = 77
        Width = 464
        Height = 261
        Caption = 'Email Information'
        TabOrder = 8
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Label816: Label8
          Left = 2
          Top = 19
          Width = 37
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'From'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label817: Label8
          Left = 2
          Top = 135
          Width = 37
          Height = 20
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Subj.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label818: Label8
          Left = 2
          Top = 161
          Width = 37
          Height = 29
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Mess.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label819: Label8
          Left = 199
          Top = 19
          Width = 40
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Email'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnDblClick = Label819DblClick
          TextId = 0
        end
        object Label820: Label8
          Left = 2
          Top = 66
          Width = 37
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'To/CC'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label82: Label8
          Left = 318
          Top = 135
          Width = 41
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Priority'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label814: Label8
          Left = 2
          Top = 234
          Width = 37
          Height = 20
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Attach.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtEmlSendName: Text8Pt
          Left = 43
          Top = 16
          Width = 153
          Height = 22
          HelpContext = 1202
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
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
        object edtEmlSubject: Text8Pt
          Left = 43
          Top = 132
          Width = 273
          Height = 22
          HelpContext = 1204
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          TextId = 0
          ViaSBtn = False
        end
        object edtEmlSendAddr: Text8Pt
          Left = 243
          Top = 16
          Width = 212
          Height = 22
          HelpContext = 1202
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
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
        object memEmlMessage: TMemo
          Left = 43
          Top = 158
          Width = 391
          Height = 69
          HelpContext = 1198
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10000
          ParentFont = False
          TabOrder = 7
          OnDblClick = btnBigEditClick
        end
        object lstEmlPriority: TSBSComboBox
          Left = 366
          Top = 131
          Width = 90
          Height = 22
          Hint = 
            'Choose which printer|Use this option to select which printer you' +
            ' wish to use. Note, even when printing to screen you must select' +
            ' a valid printer.'
          HelpContext = 1199
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 6
          OnClick = Combo_PrintersClick
          Items.Strings = (
            'Low'
            'Normal'
            'High')
          MaxListWidth = 0
        end
        object btnEmlAdd: TButton
          Left = 379
          Top = 44
          Width = 75
          Height = 25
          HelpContext = 1203
          Caption = '&Add'
          TabOrder = 2
          OnClick = btnEmlAddClick
        end
        object btnEmlEdit: TButton
          Left = 379
          Top = 72
          Width = 75
          Height = 25
          HelpContext = 1203
          Caption = '&Edit'
          TabOrder = 3
          OnClick = btnEmlEditClick
        end
        object btnEmlDelete: TButton
          Left = 379
          Top = 102
          Width = 75
          Height = 25
          HelpContext = 1203
          Caption = '&Delete'
          TabOrder = 4
          OnClick = btnEmlDeleteClick
        end
        object edtEmlAttach: Text8Pt
          Left = 43
          Top = 230
          Width = 391
          Height = 22
          HelpContext = 1205
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 9
          OnDblClick = btnAttachListClick
          TextId = 0
          ViaSBtn = False
        end
        object btnBigEdit: TButton
          Left = 435
          Top = 158
          Width = 21
          Height = 69
          Hint = 
            'Choose Form or Font|Depending whether you are printing a form or' +
            ' a report, you will be able to either change the Form name or Fo' +
            'nt prior to printing.'
          HelpContext = 1205
          Caption = '...'
          TabOrder = 8
          OnClick = btnBigEditClick
        end
        object btnAttachList: TBitBtn
          Left = 435
          Top = 230
          Width = 21
          Height = 22
          TabOrder = 10
          OnClick = btnAttachListClick
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
            DDD0DD8000DDDDDDDDD0D80DD80DDDDDDDD080DDDD80DDDDDDD080DD80080DDD
            DDD080D80D8080DDDDD0D8080DD8080DDDD0DD8080DD8080DDD0DDD8080DD808
            0DD0DDDD8080DD8080D0DDDDD8080DDDD800DDDDDD8080DDD800DDDDDDD8080D
            80D0DDDDDDDDDD800DD0DDDDDDDDDDDDDDD0}
        end
        object panRecips: TPanel
          Left = 43
          Top = 42
          Width = 332
          Height = 86
          BevelOuter = bvLowered
          TabOrder = 11
          object Shape1: TShape
            Left = 1
            Top = 1
            Width = 330
            Height = 84
            Align = alClient
          end
          object lstRecips: TListBox
            Left = 2
            Top = 19
            Width = 329
            Height = 66
            Style = lbOwnerDrawFixed
            BorderStyle = bsNone
            Color = clWhite
            ExtendedSelect = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 5
            ParentFont = False
            TabOrder = 0
            OnDblClick = btnEmlEditClick
            OnDrawItem = lstRecipsDrawItem
            OnMeasureItem = lstRecipsMeasureItem
          end
          object hdrRecips: THeaderControl
            Left = 2
            Top = 2
            Width = 329
            Height = 17
            Align = alNone
            DragReorder = False
            Sections = <
              item
                ImageIndex = -1
                Width = 22
              end
              item
                ImageIndex = -1
                Text = 'Name'
                Width = 108
              end
              item
                AllowClick = False
                ImageIndex = -1
                Text = 'Email Address'
                Width = 200
              end>
            OnSectionResize = hdrRecipsSectionResize
          end
        end
      end
      object lstEmlCompress: TComboBox
        Left = 325
        Top = 22
        Width = 135
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 6
        Items.Strings = (
          'No Compression'
          'PK-ZIP Compression'
          'EDZ Compression')
      end
    end
    object tabshXML: TTabSheet
      HelpContext = 1189
      Caption = 'XML'
      object SBSBackGroup11: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 227
        Height = 41
        Caption = 'Distribution Method'
        TextId = 0
      end
      object grpXMLOptions: TSBSBackGroup
        Left = 237
        Top = 4
        Width = 230
        Height = 41
        Caption = 'XML Options'
        TextId = 0
      end
      object btnXMLOK: TButton
        Left = 302
        Top = 313
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 4
        OnClick = btnXMLOKClick
      end
      object btnXMLCancel: TButton
        Left = 391
        Top = 313
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 5
        OnClick = Button_CancelClick
      end
      object radXMLFile: TBorRadio
        Left = 12
        Top = 20
        Width = 57
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 1206
        Align = alNone
        Caption = 'File'
        CheckColor = clWindowText
        TabOrder = 0
        TextId = 0
        OnClick = radXMLClick
      end
      object radXMLEmail: TBorRadio
        Left = 75
        Top = 20
        Width = 110
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 1206
        Align = alNone
        Caption = 'Email Attachment'
        CheckColor = clWindowText
        Checked = True
        TabOrder = 1
        TabStop = True
        TextId = 0
        OnClick = radXMLClick
      end
      object grpXMLFile: TSBSGroup
        Left = 3
        Top = 46
        Width = 464
        Height = 47
        Caption = 'File Information'
        TabOrder = 3
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Label87: Label8
          Left = 7
          Top = 19
          Width = 55
          Height = 14
          Caption = 'Save File In'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = Label87Click
          TextId = 0
        end
        object edXMLPath: Text8Pt
          Left = 65
          Top = 16
          Width = 370
          Height = 22
          HelpContext = 1206
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
        object btnXMLSetDir: TSBSButton
          Left = 435
          Top = 16
          Width = 20
          Height = 21
          HelpContext = 1206
          Caption = '...'
          TabOrder = 1
          OnClick = btnXMLSetDirClick
          TextId = 0
        end
      end
      object chkXLMHTML: TBorCheck
        Left = 248
        Top = 20
        Width = 189
        Height = 20
        HelpContext = 1207
        Align = alRight
        Caption = 'Create duplicate HTML Document'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
        TabStop = True
        TextId = 0
      end
    end
    object tabshExcel: TTabSheet
      Caption = 'Excel'
      ImageIndex = 4
      object SBSBackGroup7: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 464
        Height = 75
        Caption = ' Report Formatting '
        TextId = 0
      end
      object Label815: Label8
        Left = 6
        Top = 25
        Width = 37
        Height = 21
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
      object Label821: Label8
        Left = 118
        Top = 51
        Width = 93
        Height = 24
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Report Font'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup13: TSBSBackGroup
        Left = 3
        Top = 127
        Width = 464
        Height = 84
        Caption = ' Export Options '
        TextId = 0
      end
      object SBSBackGroup14: TSBSBackGroup
        Left = 3
        Top = 79
        Width = 464
        Height = 47
        Caption = ' Worksheet Information '
        TextId = 0
      end
      object Label822: Label8
        Left = 10
        Top = 98
        Width = 60
        Height = 14
        Caption = 'Save File As'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = Label87Click
        TextId = 0
      end
      object lstExcelPrinter: TSBSComboBox
        Left = 47
        Top = 21
        Width = 332
        Height = 22
        Hint = 
          'Choose printer|The printer details will be used for formatting t' +
          'he report'
        HelpContext = 1191
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = SelectPrinter
        MaxListWidth = 0
      end
      object btnExcelSetupPrinter: TButton
        Left = 383
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Access printer setup|Change the printer settings for the current' +
          'ly selected print device.'
        HelpContext = 1191
        Caption = '&Setup'
        TabOrder = 1
        OnClick = SetupPrinter
      end
      object edtExcelFont: Text8Pt
        Left = 216
        Top = 48
        Width = 163
        Height = 22
        Hint = 'Choose Font|Choose the font to be used when printing the report'
        HelpContext = 301
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnDblClick = BrowseForFont
        TextId = 0
        ViaSBtn = False
      end
      object btnExcelFont: TButton
        Left = 383
        Top = 48
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 305
        Caption = '&Font'
        TabOrder = 3
        OnClick = BrowseForFont
      end
      object btnExcelOK: TButton
        Left = 303
        Top = 217
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 9
        OnClick = btnExcelOKClick
      end
      object btnExcelCancel: TButton
        Left = 392
        Top = 217
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 10
        OnClick = Button_CancelClick
      end
      object chkExcelOpenXLS: TBorCheckEx
        Left = 12
        Top = 144
        Width = 447
        Height = 16
        Align = alRight
        Caption = 'Open the exported Excel Worksheet after it has been created'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
        TextId = 0
      end
      object chkExcelIncludePageHeaders: TBorCheckEx
        Left = 12
        Top = 165
        Width = 446
        Height = 16
        Align = alRight
        Caption = 'Include Page Headers within the exported Excel Worksheet'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
        TextId = 0
      end
      object chkExcelIncludeTotals: TBorCheckEx
        Left = 12
        Top = 185
        Width = 445
        Height = 16
        Align = alRight
        Caption = 'Include the Report Total within the exported Excel Worksheet'
        CheckColor = clWindowText
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 8
        TextId = 0
      end
      object edtExcelPath: Text8Pt
        Left = 74
        Top = 95
        Width = 364
        Height = 22
        HelpContext = 1206
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
        OnDblClick = btnSetPathClick
        TextId = 0
        ViaSBtn = False
      end
      object btnExcelSetPath: TSBSButton
        Left = 438
        Top = 95
        Width = 20
        Height = 21
        HelpContext = 1206
        Caption = '...'
        TabOrder = 5
        OnClick = btnSetPathClick
        TextId = 0
      end
    end
    object tabshHTML: TTabSheet
      Caption = 'HTML'
      ImageIndex = 5
      object SBSBackGroup15: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 383
        Height = 75
        Caption = ' Report Formatting '
        TextId = 0
      end
      object Label823: Label8
        Left = 6
        Top = 25
        Width = 37
        Height = 21
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
      object Label824: Label8
        Left = 118
        Top = 51
        Width = 93
        Height = 24
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Report Font'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup16: TSBSBackGroup
        Left = 392
        Top = 4
        Width = 75
        Height = 75
        Caption = 'Output To'
        TextId = 0
      end
      object SBSBackGroup17: TSBSBackGroup
        Left = 3
        Top = 79
        Width = 464
        Height = 47
        Caption = ' File Information '
        TextId = 0
      end
      object Label825: Label8
        Left = 10
        Top = 98
        Width = 60
        Height = 14
        Caption = 'Save File As'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = Label87Click
        TextId = 0
      end
      object SBSBackGroup18: TSBSBackGroup
        Left = 3
        Top = 127
        Width = 464
        Height = 42
        Caption = ' Export Options '
        TextId = 0
      end
      object lstHTMLPrinter: TSBSComboBox
        Left = 47
        Top = 21
        Width = 252
        Height = 22
        Hint = 
          'Choose printer|The printer details will be used for formatting t' +
          'he report'
        HelpContext = 1191
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 0
        OnClick = SelectPrinter
        MaxListWidth = 0
      end
      object edtHTMLFont: Text8Pt
        Left = 216
        Top = 48
        Width = 83
        Height = 22
        Hint = 'Choose Font|Choose the font to be used when printing the report'
        HelpContext = 301
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnDblClick = BrowseForFont
        TextId = 0
        ViaSBtn = False
      end
      object btnHTMLFont: TButton
        Left = 303
        Top = 48
        Width = 75
        Height = 21
        Hint = 
          'Choose Form or Font|Depending whether you are printing a form or' +
          ' a report, you will be able to either change the Form name or Fo' +
          'nt prior to printing.'
        HelpContext = 305
        Caption = '&Font'
        TabOrder = 3
        OnClick = BrowseForFont
      end
      object btnHTMLSetupPrinter: TButton
        Left = 303
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Access printer setup|Change the printer settings for the current' +
          'ly selected print device.'
        HelpContext = 1191
        Caption = '&Setup'
        TabOrder = 1
        OnClick = SetupPrinter
      end
      object radHTMLFile: TBorRadio
        Left = 400
        Top = 20
        Width = 62
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 1195
        Align = alNone
        Caption = 'HTML'
        CheckColor = clWindowText
        Checked = True
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object radHTMLPreview: TBorRadio
        Left = 400
        Top = 48
        Width = 62
        Height = 20
        Hint = 
          'Send output to Screen|Sends all output to a print preview screen' +
          ', which can optionaly be sent to  the currently selected printer'
        HelpContext = 1195
        Align = alRight
        Caption = 'Screen'
        CheckColor = clWindowText
        TabOrder = 5
        TextId = 0
      end
      object edtHTMLPath: Text8Pt
        Left = 74
        Top = 95
        Width = 364
        Height = 22
        HelpContext = 1206
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = Popup_Forms
        ReadOnly = True
        ShowHint = True
        TabOrder = 6
        OnDblClick = btnSetPathClick
        TextId = 0
        ViaSBtn = False
      end
      object btnHTMLSetPath: TSBSButton
        Left = 438
        Top = 95
        Width = 20
        Height = 21
        HelpContext = 1206
        Caption = '...'
        TabOrder = 7
        OnClick = btnSetPathClick
        TextId = 0
      end
      object btnHTMLOK: TButton
        Left = 303
        Top = 175
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 9
        OnClick = btnHTMLOKClick
      end
      object btnHTMLCancel: TButton
        Left = 392
        Top = 175
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 10
        OnClick = Button_CancelClick
      end
      object chkHTMLOpenHTML: TBorCheckEx
        Left = 12
        Top = 144
        Width = 447
        Height = 16
        Align = alRight
        Caption = 'Open the exported HTML file after it has been created'
        CheckColor = clWindowText
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
        TabStop = True
        TextId = 0
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'All Forms|*.DEF;*.EFX|Form Designer Forms (*.EFX)|*.EFX|PCC Form' +
      's (*.DEF)|*.DEF'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofShareAware]
    Left = 94
    Top = 324
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 223
    Top = 326
  end
  object Popup_Forms: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = Popup_FormsPopup
    Left = 28
    Top = 382
    object Popup_Forms_Clear: TMenuItem
      Caption = 'Clear'
      OnClick = Popup_Forms_ClearClick
    end
    object Popup_Forms_SepBar1: TMenuItem
      Caption = '-'
    end
    object Popup_Forms_Browse: TMenuItem
      Caption = '&Browse'
    end
    object Popup_Forms_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Forms_1: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_2: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_3: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_4: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_5: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_6: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_7: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_8: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_9: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
    object Popup_Forms_10: TMenuItem
      Visible = False
      OnClick = Popup_Forms_CacheClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'XLS'
    Filter = 'Excel Files|*.XLS'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofNoReadOnlyReturn, ofEnableSizing]
    Title = 'Save Report As'
    Left = 160
    Top = 382
  end
  object SpellCheck4Modal1: TSpellCheck4Modal
    Version = 'TSpellCheck4Modal v5.70.001 for Delphi 6.01'
    Left = 266
    Top = 380
  end
end
