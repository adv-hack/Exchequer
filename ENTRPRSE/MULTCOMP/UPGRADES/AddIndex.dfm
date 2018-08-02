object frmIdxProgress: TfrmIdxProgress
  Left = 444
  Top = 332
  BorderStyle = bsDialog
  Caption = 'Add New Indexes'
  ClientHeight = 268
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 195
    Height = 15
    Caption = 'Please wait -  adding new indexes.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblIndexNo: TLabel
    Left = 16
    Top = 48
    Width = 107
    Height = 15
    Caption = 'Adding Index 1 of 3'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 16
    Top = 75
    Width = 473
    Height = 2
  end
  object Panel1: TPanel
    Left = 16
    Top = 80
    Width = 473
    Height = 177
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 0
      Top = 8
      Width = 461
      Height = 64
      Caption = 
        'PLEASE NOTE: Depending upon the size of your database, this proc' +
        'ess may take some time to complete and the caption on this windo' +
        'w may change to include the words '#39'Not Responding.'#39' This does NO' +
        'T mean that the upgrade has stopped working.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 0
      Top = 80
      Width = 344
      Height = 16
      Caption = 'Please allow the upgrade to finish and do not try to close it.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 0
      Top = 112
      Width = 465
      Height = 57
      AutoSize = False
      Caption = 
        'Terminating the upgrade or switching off the computer will cause' +
        ' the upgrade to fail; if that happens you will need to run the u' +
        'pgrade again after restoring your backup.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
end
