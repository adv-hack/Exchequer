object frmCommslogViewer: TfrmCommslogViewer
  Left = 133
  Top = 119
  Width = 696
  Height = 480
  Caption = 'Commslog Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 43
      Height = 14
      Caption = 'Log File :'
    end
    object lDate: TLabel
      Left = 216
      Top = 12
      Width = 66
      Height = 14
      Caption = 'Date Started :'
    end
    object lTime: TLabel
      Left = 360
      Top = 12
      Width = 66
      Height = 14
      Caption = 'Time Started :'
    end
    object cmbLogFile: TComboBox
      Left = 56
      Top = 8
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      Sorted = True
      TabOrder = 0
      OnChange = cmbLogFileChange
    end
  end
  object memo1: TRichEdit
    Left = 0
    Top = 41
    Width = 688
    Height = 412
    Align = alClient
    PlainText = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
