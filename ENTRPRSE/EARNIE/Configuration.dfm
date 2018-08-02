object FrmConfiguration: TFrmConfiguration
  Left = 193
  Top = 147
  BorderStyle = bsSingle
  Caption = 'Export Configuration'
  ClientHeight = 232
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 353
    Height = 1
    Align = alTop
    Shape = bsTopLine
  end
  object Label5: TLabel
    Left = 96
    Top = 152
    Width = 32
    Height = 14
    Caption = 'Label1'
  end
  object pcConfig: TPageControl
    Left = 8
    Top = 8
    Width = 337
    Height = 185
    ActivePage = tsDirectories
    TabIndex = 0
    TabOrder = 0
    OnDrawTab = pcConfigDrawTab
    object tsDirectories: TTabSheet
      Caption = 'Directories'
      DesignSize = (
        329
        156)
      object SpeedButton2: TSpeedButton
        Left = 294
        Top = 72
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        NumGlyphs = 2
        OnClick = SpeedButton2Click
      end
      object Label7: TLabel
        Left = 8
        Top = 56
        Width = 84
        Height = 14
        Caption = 'Export Directory :'
      end
      object Label8: TLabel
        Left = 8
        Top = 104
        Width = 105
        Height = 14
        Caption = 'Exchequer Directory :'
      end
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 90
        Height = 14
        Caption = 'Log File Directory :'
      end
      object SpeedButton1: TSpeedButton
        Left = 294
        Top = 24
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        NumGlyphs = 2
        OnClick = SpeedButton1Click
      end
      object SpeedButton3: TSpeedButton
        Left = 294
        Top = 120
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        NumGlyphs = 2
        OnClick = SpeedButton3Click
      end
      object EdtEnterprise: TEdit
        Left = 8
        Top = 120
        Width = 287
        Height = 22
        Hint = 'Value from ExchDll.ini'
        ReadOnly = True
        TabOrder = 0
      end
      object EdtDefaultExportDir: TEdit
        Left = 8
        Top = 72
        Width = 287
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 1
      end
      object EdtLogFiledir: TEdit
        Left = 8
        Top = 24
        Width = 287
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 2
      end
    end
    object tsFilenames: TTabSheet
      Caption = 'Filenames'
      ImageIndex = 2
      DesignSize = (
        329
        156)
      object Label1: TLabel
        Left = 97
        Top = 24
        Width = 35
        Height = 14
        Alignment = taRightJustify
        Caption = 'Classic'
      end
      object Label2: TLabel
        Left = 6
        Top = 48
        Width = 126
        Height = 14
        Alignment = taRightJustify
        Caption = 'Earnie / Exchequer Payroll'
      end
      object Label3: TLabel
        Left = 92
        Top = 72
        Width = 40
        Height = 14
        Alignment = taRightJustify
        Caption = 'JobCard'
      end
      object Label4: TLabel
        Left = 101
        Top = 96
        Width = 31
        Height = 14
        Alignment = taRightJustify
        Caption = 'Bonus'
      end
      object Label6: TLabel
        Left = 98
        Top = 120
        Width = 34
        Height = 14
        Alignment = taRightJustify
        Caption = 'LogFile'
      end
      object EdtClassic: TEdit
        Left = 136
        Top = 20
        Width = 165
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'TSClassic.Exp'
      end
      object EdtEarnie: TEdit
        Left = 136
        Top = 44
        Width = 165
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Text = 'clockin.exp'
      end
      object EdtJobCard: TEdit
        Left = 136
        Top = 67
        Width = 165
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Text = 'TSJobCard.Exp'
      end
      object EdtBonus: TEdit
        Left = 136
        Top = 91
        Width = 165
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        Text = 'TSBonus.Exp'
      end
      object EdtLogfile: TEdit
        Left = 136
        Top = 114
        Width = 165
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        Text = 'TSLog.exp'
      end
    end
  end
  object BtnOk: TBitBtn
    Left = 208
    Top = 200
    Width = 65
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BtnOkClick
    NumGlyphs = 2
  end
  object BtnCancel: TBitBtn
    Left = 280
    Top = 200
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = BtnCancelClick
    NumGlyphs = 2
  end
end
