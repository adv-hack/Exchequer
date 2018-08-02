object SQLCheckAllJobsWarningFrm: TSQLCheckAllJobsWarningFrm
  Left = 336
  Top = 125
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Check All Jobs - Unable to run in optimised mode'
  ClientHeight = 326
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 476
    Height = 297
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblContinue: TLabel
      Left = 8
      Top = 168
      Width = 457
      Height = 33
      AutoSize = False
      Caption = 
        'If you wish to proceed without resolving the warnings, select '#39'Y' +
        'es'#39' below. The process might take some time to complete as it wi' +
        'll not be optimised for performance.'
      WordWrap = True
    end
    object lblDataDiscrepancies: TLabel
      Left = 8
      Top = 8
      Width = 400
      Height = 14
      Caption = 
        'Unable to run Check All Jobs in optimised mode. [nn] data warnin' +
        'gs were identified.'
    end
    object Label1: TLabel
      Left = 8
      Top = 212
      Width = 457
      Height = 17
      AutoSize = False
      Caption = 
        'Select '#39'No to exit. Please report the warnings to Exchequer supp' +
        'ort.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 240
      Width = 457
      Height = 45
      AutoSize = False
      Caption = 
        '(Please note that we will probably require your data to be sent ' +
        'to us for analysis. If you need to run the check, we recommend r' +
        'unning this anyway, and reporting to Support at a later date.)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ErrorList: TListBox
      Left = 8
      Top = 24
      Width = 457
      Height = 137
      Ctl3D = False
      ItemHeight = 14
      ParentCtl3D = False
      TabOrder = 0
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 297
    Width = 476
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      476
      29)
    object btnNext: TButton
      Left = 298
      Top = 0
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Yes'
      ModalResult = 6
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 386
      Top = 0
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&No'
      ModalResult = 7
      TabOrder = 1
    end
  end
end
