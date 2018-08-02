object Form1: TForm1
  Left = 354
  Top = 153
  ActiveControl = PageControl1
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 318
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 520
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 5
    Width = 510
    Height = 281
    ActivePage = tabshCustDetails
    TabIndex = 0
    TabOrder = 0
    object tabshCustDetails: TTabSheet
      Caption = 'Customer'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 1
        Width = 494
        Height = 54
        Caption = ' Dealer Details '
        TabOrder = 0
        object Label24: TLabel
          Left = 3
          Top = 16
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Name'
        end
        object lblDealer: TLabel
          Left = 77
          Top = 16
          Width = 406
          Height = 18
          AutoSize = False
        end
        object Label4: TLabel
          Left = 3
          Top = 33
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Town'
        end
        object lblDealerTown: TLabel
          Left = 77
          Top = 33
          Width = 406
          Height = 18
          AutoSize = False
        end
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 58
        Width = 494
        Height = 190
        Caption = ' Customer Details '
        TabOrder = 1
        object Label25: TLabel
          Left = 3
          Top = 16
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contact'
        end
        object lblContact: TLabel
          Left = 77
          Top = 16
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblContact'
        end
        object Label27: TLabel
          Left = 3
          Top = 33
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Company'
        end
        object lblCompany: TLabel
          Left = 76
          Top = 33
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblCompany'
        end
        object Label26: TLabel
          Left = 3
          Top = 50
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Address'
        end
        object lblAddress1: TLabel
          Left = 76
          Top = 50
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblAddress1'
        end
        object lblAddress2: TLabel
          Left = 76
          Top = 67
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblAddress2'
        end
        object lblAddress3: TLabel
          Left = 76
          Top = 84
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblAddress3'
        end
        object lblAddress4: TLabel
          Left = 76
          Top = 101
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblAddress4'
        end
        object lblAddress5: TLabel
          Left = 76
          Top = 118
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblAddress5'
        end
        object Label1: TLabel
          Left = 3
          Top = 135
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Phone'
        end
        object lblPhone: TLabel
          Left = 76
          Top = 135
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblPhone'
        end
        object Label3: TLabel
          Left = 3
          Top = 152
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Fax'
        end
        object lblFax: TLabel
          Left = 76
          Top = 152
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblFax'
        end
        object Label9: TLabel
          Left = 3
          Top = 169
          Width = 60
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-Mail'
        end
        object lblEmail: TLabel
          Left = 76
          Top = 169
          Width = 406
          Height = 18
          AutoSize = False
          Caption = 'lblEmail'
        end
      end
    end
    object tabshModules: TTabSheet
      Caption = 'Modules'
      object GroupBox4: TGroupBox
        Left = 4
        Top = 1
        Width = 494
        Height = 200
        Caption = ' Dealer Details '
        TabOrder = 0
        object Label2: TLabel
          Left = 18
          Top = 18
          Width = 92
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Module'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 235
          Top = 18
          Width = 85
          Height = 18
          AutoSize = False
          Caption = 'Release Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 127
          Top = 18
          Width = 64
          Height = 18
          AutoSize = False
          Caption = 'Security'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label21: TLabel
          Left = 4
          Top = 35
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Full Multi Currency:'
        end
        object Label22: TLabel
          Left = 4
          Top = 71
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Report Writer:'
        end
        object Label23: TLabel
          Left = 4
          Top = 89
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Toolkit DLL:'
        end
        object Label28: TLabel
          Left = 4
          Top = 125
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Account Stk Analysis:'
        end
        object Label30: TLabel
          Left = 4
          Top = 53
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Job Costing:'
        end
        object Label31: TLabel
          Left = 4
          Top = 107
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telesales:'
        end
        object Label6: TLabel
          Left = 350
          Top = 18
          Width = 113
          Height = 18
          AutoSize = False
          Caption = 'Status'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object lblModSec1: TLabel
          Left = 127
          Top = 35
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec3: TLabel
          Left = 127
          Top = 71
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec4: TLabel
          Left = 127
          Top = 89
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec6: TLabel
          Left = 127
          Top = 125
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec2: TLabel
          Left = 127
          Top = 53
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec5: TLabel
          Left = 127
          Top = 107
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel1: TLabel
          Left = 235
          Top = 35
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel2: TLabel
          Left = 235
          Top = 53
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel3: TLabel
          Left = 235
          Top = 71
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel4: TLabel
          Left = 235
          Top = 89
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel5: TLabel
          Left = 235
          Top = 107
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel6: TLabel
          Left = 235
          Top = 125
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModStatus1: TLabel
          Left = 350
          Top = 35
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus2: TLabel
          Left = 350
          Top = 53
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus3: TLabel
          Left = 350
          Top = 71
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus4: TLabel
          Left = 350
          Top = 89
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus5: TLabel
          Left = 350
          Top = 107
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus6: TLabel
          Left = 350
          Top = 125
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object Label8: TLabel
          Left = 4
          Top = 143
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-Business:'
        end
        object Label13: TLabel
          Left = 4
          Top = 179
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'OLE Save Functions:'
        end
        object Label14: TLabel
          Left = 4
          Top = 161
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Paperless:'
        end
        object lblModSec7: TLabel
          Left = 127
          Top = 143
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec9: TLabel
          Left = 127
          Top = 179
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModSec8: TLabel
          Left = 127
          Top = 161
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel7: TLabel
          Left = 235
          Top = 143
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel8: TLabel
          Left = 235
          Top = 161
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModRel9: TLabel
          Left = 235
          Top = 179
          Width = 103
          Height = 18
          AutoSize = False
          Caption = 'xxx'
        end
        object lblModStatus7: TLabel
          Left = 350
          Top = 143
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus8: TLabel
          Left = 350
          Top = 161
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
        object lblModStatus9: TLabel
          Left = 350
          Top = 179
          Width = 127
          Height = 18
          AutoSize = False
          Caption = 'Unknown'
        end
      end
    end
    object tabshFaxVer: TTabSheet
      Caption = 'Fax Info'
      object GroupBox5: TGroupBox
        Left = 4
        Top = 1
        Width = 494
        Height = 214
        Caption = ' Version Info '
        TabOrder = 0
        object Label18: TLabel
          Left = 7
          Top = 19
          Width = 110
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Version Code'
          WordWrap = True
        end
        object Bevel1: TBevel
          Left = 7
          Top = 45
          Width = 477
          Height = 4
          Shape = bsTopLine
        end
        object Label10: TLabel
          Left = 7
          Top = 55
          Width = 110
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Licence Version'
          WordWrap = True
        end
        object Label11: TLabel
          Left = 7
          Top = 72
          Width = 110
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Enterprise Version'
          WordWrap = True
        end
        object Bevel3: TBevel
          Left = 7
          Top = 93
          Width = 477
          Height = 4
          Shape = bsTopLine
        end
        object lblLicVer: TLabel
          Left = 125
          Top = 55
          Width = 350
          Height = 17
          AutoSize = False
          WordWrap = True
        end
        object lblEntVer: TLabel
          Left = 125
          Top = 72
          Width = 350
          Height = 17
          AutoSize = False
          WordWrap = True
        end
        object Label2545: TLabel
          Left = 7
          Top = 102
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Full Multi Currency:'
        end
        object Label19: TLabel
          Left = 7
          Top = 138
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Report Writer:'
        end
        object Label121: TLabel
          Left = 7
          Top = 156
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Toolkit DLL:'
        end
        object Label29: TLabel
          Left = 7
          Top = 192
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Account Stk Analysis:'
        end
        object lblModMC: TLabel
          Left = 125
          Top = 102
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblModRepWrt: TLabel
          Left = 125
          Top = 138
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblModToolkit: TLabel
          Left = 125
          Top = 156
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblModASA: TLabel
          Left = 125
          Top = 192
          Width = 90
          Height = 18
          AutoSize = False
        end
        object Label34: TLabel
          Left = 234
          Top = 120
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Paperless:'
        end
        object Label35: TLabel
          Left = 234
          Top = 138
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'OLE Save Functions:'
        end
        object Label36: TLabel
          Left = 234
          Top = 156
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = '10'
        end
        object lblModPaper: TLabel
          Left = 350
          Top = 120
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblModOLESave: TLabel
          Left = 350
          Top = 138
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblMod10: TLabel
          Left = 350
          Top = 156
          Width = 90
          Height = 18
          AutoSize = False
        end
        object Label40: TLabel
          Left = 7
          Top = 120
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Job Costing:'
        end
        object lblModJC: TLabel
          Left = 125
          Top = 120
          Width = 90
          Height = 18
          AutoSize = False
        end
        object Label88: TLabel
          Left = 7
          Top = 174
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Telesales:'
        end
        object lblModTele: TLabel
          Left = 125
          Top = 174
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblModEBus: TLabel
          Left = 350
          Top = 102
          Width = 90
          Height = 18
          AutoSize = False
        end
        object Label45: TLabel
          Left = 234
          Top = 102
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'E-Business:'
        end
        object Label17: TLabel
          Left = 234
          Top = 174
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = '11'
        end
        object Label20: TLabel
          Left = 234
          Top = 192
          Width = 110
          Height = 18
          Alignment = taRightJustify
          AutoSize = False
          Caption = '12'
        end
        object lblMod11: TLabel
          Left = 350
          Top = 174
          Width = 90
          Height = 18
          AutoSize = False
        end
        object lblMod12: TLabel
          Left = 350
          Top = 192
          Width = 90
          Height = 18
          AutoSize = False
        end
        object edtFaxVerCode: Text8Pt
          Left = 125
          Top = 16
          Width = 179
          Height = 22
          EditMask = '>aa-aa-aa-aaaaaaaa;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 17
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = '  -  -  -        '
          OnChange = edtFaxVerCodeChange
          OnKeyPress = edtFaxVerCodeKeyPress
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object tabshReleaseCodes: TTabSheet
      Caption = 'Release Codes'
      object GroupBox3: TGroupBox
        Left = 4
        Top = 1
        Width = 494
        Height = 93
        Caption = ' System Release Code '
        TabOrder = 0
        object Label12: TLabel
          Left = 7
          Top = 19
          Width = 76
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'ESN'
          WordWrap = True
        end
        object Label15: TLabel
          Left = 7
          Top = 43
          Width = 76
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Security Code'
          WordWrap = True
        end
        object Label16: TLabel
          Left = 7
          Top = 67
          Width = 76
          Height = 17
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Release Code'
          WordWrap = True
        end
        object lblSecExpiry: Label8
          Left = 222
          Top = 45
          Width = 208
          Height = 14
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtRelCode: Text8Pt
          Left = 92
          Top = 64
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
          TabOrder = 0
          Text = 'Sorry, Not Implemented'
          TextId = 0
          ViaSBtn = False
        end
        object edtESN: Text8Pt
          Left = 92
          Top = 16
          Width = 179
          Height = 22
          Enabled = False
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
        object edtSecCode: Text8Pt
          Left = 92
          Top = 40
          Width = 121
          Height = 22
          Enabled = False
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
        object btnClip: TButton
          Left = 284
          Top = 12
          Width = 201
          Height = 25
          Caption = 'Copy ESN/SecCode to Clipboard'
          TabOrder = 3
          OnClick = btnClipClick
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 292
    Width = 520
    Height = 26
    Panels = <
      item
        Text = 'ErcFile'
        Width = 500
      end>
    SimplePanel = False
    SizeGrip = False
  end
  object MainMenu1: TMainMenu
    Left = 385
    Top = 6
    object Menu_File: TMenuItem
      Caption = '&File'
      object Menu_File_Open: TMenuItem
        Caption = '&Open'
        OnClick = Menu_File_OpenClick
      end
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = Menu_File_ExitClick
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_About: TMenuItem
        Caption = '&About'
        OnClick = Menu_Help_AboutClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'LIC'
    Filter = 'ERC Files (*.ERC)|*.ERC|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open ERC File'
    Left = 415
    Top = 6
  end
end
