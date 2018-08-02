inherited frmSQLPreRequisits: TfrmSQLPreRequisits
  Left = 365
  Top = 272
  HelpContext = 122
  ActiveControl = nil
  Caption = 'frmSQLPreRequisits'
  ClientHeight = 287
  ClientWidth = 696
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 242
    Width = 673
  end
  inherited TitleLbl: TLabel
    Width = 521
    Caption = 'Pre-Requisites'
  end
  inherited InstrLbl: TLabel
    Width = 522
    Height = 19
    Caption = 
      'This workstation needs the following updates installed before it' +
      ' can use <APPTITLE>.'
  end
  inherited imgSide: TImage
    Height = 131
  end
  inherited HelpBtn: TButton
    Top = 259
  end
  inherited Panel1: TPanel
    Height = 225
    inherited Image1: TImage
      Height = 223
    end
  end
  inherited ExitBtn: TButton
    Top = 259
  end
  inherited BackBtn: TButton
    Left = 519
    Top = 259
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 605
    Top = 259
    Visible = False
  end
  object ScrollBox2: TScrollBox
    Left = 180
    Top = 71
    Width = 504
    Height = 168
    BorderStyle = bsNone
    TabOrder = 5
    object panWinInstaller: TPanel
      Left = 0
      Top = 0
      Width = 487
      Height = 42
      TabOrder = 0
      object lblWinInstallerTitle: TLabel
        Left = 7
        Top = 6
        Width = 123
        Height = 13
        Caption = 'Windows Installer 3.1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblWinInstallerText: TLabel
        Left = 7
        Top = 23
        Width = 474
        Height = 16
        AutoSize = False
        Caption = 'A Windows Installer update is needed on this workstation.'
        WordWrap = True
      end
      object lblWinInstallerInstall: TLabel
        Left = 453
        Top = 6
        Width = 27
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Install'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblWinInstallerInstallClick
      end
    end
    object panSQLNCli: TPanel
      Left = 0
      Top = 42
      Width = 487
      Height = 42
      TabOrder = 1
      object lblSQLNCliTitle: TLabel
        Left = 7
        Top = 6
        Width = 158
        Height = 13
        Caption = 'Microsoft SQL Native Client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSQLNCliText: TLabel
        Left = 6
        Top = 23
        Width = 474
        Height = 16
        AutoSize = False
        Caption = 
          'The SQL Native Client is needed to access Microsoft SQL Server D' +
          'atabase Engines.'
        WordWrap = True
      end
      object lblSQLNCliInstall: TLabel
        Left = 453
        Top = 6
        Width = 27
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Install'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lblSQLNCliInstallClick
      end
    end
  end
end
