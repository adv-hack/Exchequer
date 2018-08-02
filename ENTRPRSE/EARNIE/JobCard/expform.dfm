object frmExport: TfrmExport
  Left = 211
  Top = 152
  BiDiMode = bdLeftToRight
  BorderStyle = bsDialog
  Caption = 'Export Timesheets'
  ClientHeight = 270
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 257
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 208
      Top = 76
      Width = 12
      Height = 14
      Caption = 'To'
    end
    object Label3: TLabel
      Left = 47
      Top = 20
      Width = 49
      Height = 14
      Alignment = taRightJustify
      Caption = 'Employee:'
    end
    object Label4: TLabel
      Left = 34
      Top = 48
      Width = 62
      Height = 14
      Alignment = taRightJustify
      Caption = 'Week/Month:'
    end
    object Label5: TLabel
      Left = 10
      Top = 96
      Width = 86
      Height = 14
      Alignment = taRightJustify
      Caption = 'Timesheet Range:'
    end
    object Label6: TLabel
      Left = 36
      Top = 124
      Width = 60
      Height = 14
      Alignment = taRightJustify
      Caption = 'Period/Year:'
    end
    object Label7: TLabel
      Left = 104
      Top = 76
      Width = 24
      Height = 14
      Caption = 'From'
    end
    object edtTSFrom: TEdit
      Left = 104
      Top = 92
      Width = 89
      Height = 22
      CharCase = ecUpperCase
      TabOrder = 2
      Text = 'TSH000001'
    end
    object edtTSTo: TEdit
      Left = 208
      Top = 92
      Width = 97
      Height = 22
      CharCase = ecUpperCase
      TabOrder = 3
      Text = 'TSH'
    end
    object chkPosted: TCheckBox
      Left = 104
      Top = 152
      Width = 153
      Height = 17
      Caption = 'Include Posted Timesheets'
      TabOrder = 5
    end
    object edtEmp: TEdit
      Left = 104
      Top = 16
      Width = 89
      Height = 22
      CharCase = ecUpperCase
      TabOrder = 0
      OnExit = edtEmpExit
    end
    object edtWk: TEdit
      Left = 104
      Top = 44
      Width = 49
      Height = 22
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 1
      OnChange = edtWkChange
    end
    object edtPy: TEditPeriod
      Left = 104
      Top = 120
      Width = 85
      Height = 22
      AutoSelect = False
      EditMask = '00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 7
      ParentFont = False
      TabOrder = 4
      Text = '012004'
      Placement = cpAbove
      AllowBlank = True
      EPeriod = 1
      EYear = 104
      ViewMask = '00/0000;0;'
    end
    object chkUseLineRates: TCheckBox
      Left = 104
      Top = 192
      Width = 209
      Height = 17
      Caption = 'Use Time Rates from Timesheet Lines'
      TabOrder = 7
    end
    object chkAllowExported: TCheckBox
      Left = 104
      Top = 172
      Width = 201
      Height = 17
      Caption = 'Include Already Exported Timesheets'
      TabOrder = 6
    end
    object chkExcludeSubs: TCheckBox
      Left = 104
      Top = 212
      Width = 201
      Height = 17
      Caption = 'Exclude Subcontractors'
      TabOrder = 8
    end
    object chkLineFromAnal: TCheckBox
      Left = 104
      Top = 232
      Width = 201
      Height = 17
      Caption = 'Take Line Type from Analysis Type'
      TabOrder = 9
    end
  end
  object SBSButton1: TSBSButton
    Left = 336
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 336
    Top = 36
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
