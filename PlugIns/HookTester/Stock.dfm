object frmStock: TfrmStock
  Left = 298
  Top = 154
  Width = 297
  Height = 480
  BorderStyle = bsSizeToolWin
  Caption = 'Stock Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object vlProperties: TValueListEditor
    Left = 0
    Top = 0
    Width = 289
    Height = 415
    Align = alClient
    TabOrder = 0
    ColWidths = (
      124
      159)
  end
  object Panel1: TPanel
    Left = 0
    Top = 415
    Width = 289
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      289
      38)
    object btnSaveEdits: TButton
      Left = 8
      Top = 8
      Width = 91
      Height = 25
      Caption = '&Save Edits'
      TabOrder = 0
      OnClick = btnSaveEditsClick
    end
    object btnClose: TButton
      Left = 209
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
end
