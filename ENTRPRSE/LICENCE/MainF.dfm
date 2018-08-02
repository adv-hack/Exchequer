object frmMain: TfrmMain
  Left = 443
  Top = 218
  HelpContext = 1000
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer 2018-R1 CD Licence Generator'
  ClientHeight = 158
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    434
    158)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 434
    Height = 5
    Align = alTop
    Shape = bsTopLine
  end
  object btnGenCDLic: TButton
    Left = 7
    Top = 6
    Width = 420
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Generate Exchequer 2018-R1 CD Licence'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnGenCDLicClick
  end
  object btnViewCDLic: TButton
    Left = 7
    Top = 105
    Width = 420
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    Caption = 'View CD Licence'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnViewCDLicClick
  end
  object Button1: TButton
    Left = 7
    Top = 56
    Width = 420
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Edit Existing Exchequer 2018-R1 CD Licence'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = EditExistingCDLicence1Click
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 108
    object Menu_File: TMenuItem
      Caption = '&File'
      ShortCut = 16453
      object Menu_File_GenCDLic: TMenuItem
        Caption = '&Generate CD Licence'
        ShortCut = 16455
        OnClick = btnGenCDLicClick
      end
      object EditExistingCDLicence1: TMenuItem
        Caption = 'Edit Existing CD Licence'
        ShortCut = 16453
        OnClick = EditExistingCDLicence1Click
      end
      object Menu_File_ViewCDLic: TMenuItem
        Caption = '&View CD Licence'
        ShortCut = 16470
        OnClick = btnViewCDLicClick
      end
      object Menu_File_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = Menu_File_ExitClick
      end
    end
    object Utilities1: TMenuItem
      Caption = '&Utilities'
      Visible = False
      object ESNPasswordGenerator1: TMenuItem
        Caption = 'ESN Password Generator'
        OnClick = ESNPasswordGenerator1Click
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_About: TMenuItem
        Caption = '&About'
        ShortCut = 16449
        OnClick = Menu_Help_AboutClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'LIC'
    Filter = 'Licence Files (*.LIC)|*.LIC|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open Exchequer CD Licence'
    Left = 54
    Top = 109
  end
end
