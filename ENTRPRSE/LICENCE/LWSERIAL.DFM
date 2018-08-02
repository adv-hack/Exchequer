object frmLicWiz6: TfrmLicWiz6
  Left = 334
  Top = 165
  HelpContext = 1004
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 2 of 5'
  ClientHeight = 237
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 288
    Height = 29
    AutoSize = False
    Caption = 'CD Serial Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 8
    Top = 199
    Width = 351
    Height = 4
    Shape = bsBottomLine
  end
  object btnNext: TButton
    Left = 280
    Top = 209
    Width = 79
    Height = 21
    Caption = '&Next >>'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 193
    Top = 209
    Width = 79
    Height = 21
    Caption = '<< &Previous'
    TabOrder = 1
    OnClick = btnPreviousClick
  end
  object PageControl1: TPageControl
    Left = 9
    Top = 35
    Width = 351
    Height = 158
    HelpContext = 1004
    ActivePage = tabshManual
    TabIndex = 1
    TabOrder = 0
    object tabshCD: TTabSheet
      Caption = 'CD'
      object Label44: Label8
        Left = 18
        Top = 75
        Width = 87
        Height = 21
        AutoSize = False
        Caption = 'Serial No'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label3: TLabel
        Left = 0
        Top = 1
        Width = 340
        Height = 30
        AutoSize = False
        Caption = 
          'Please insert the CD into the specified drive and click the '#39'Rea' +
          'd Serial Number'#39' button to read the CD Serial Number.'
        WordWrap = True
      end
      object lblSNo: Label8
        Left = 109
        Top = 75
        Width = 199
        Height = 23
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object lblISN: Label8
        Left = 110
        Top = 102
        Width = 199
        Height = 23
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 18
        Top = 103
        Width = 87
        Height = 21
        AutoSize = False
        Caption = 'ESN'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object btnReadSNo: TButton
        Left = 271
        Top = 36
        Width = 66
        Height = 25
        Caption = '&Read'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnReadSNoClick
      end
      object drvCD: TDriveComboBox
        Left = 11
        Top = 37
        Width = 255
        Height = 24
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object tabshManual: TTabSheet
      HelpContext = 1005
      Caption = 'Manual'
      object Label1: TLabel
        Left = 0
        Top = 1
        Width = 340
        Height = 21
        AutoSize = False
        Caption = 'Please enter the CD'#39's Serial number into the edit boxes below:'
        WordWrap = True
      end
      object Label81: Label8
        Left = 135
        Top = 26
        Width = 15
        Height = 21
        Alignment = taCenter
        AutoSize = False
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 18
        Top = 63
        Width = 87
        Height = 21
        AutoSize = False
        Caption = 'ESN'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object lblISN2: Label8
        Left = 110
        Top = 62
        Width = 199
        Height = 23
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object edtCDSno1: Text8Pt
        Left = 76
        Top = 23
        Width = 57
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        MaxLength = 4
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = edtCDSno1Change
        OnKeyPress = edtCDSno1KeyPress
        TextId = 0
        ViaSBtn = False
      end
      object edtCDSno2: Text8Pt
        Left = 153
        Top = 23
        Width = 57
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        MaxLength = 4
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = edtCDSno1Change
        OnKeyPress = edtCDSno1KeyPress
        TextId = 0
        ViaSBtn = False
      end
    end
  end
end
