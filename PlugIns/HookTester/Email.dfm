object FrmEmail: TFrmEmail
  Left = 353
  Top = 131
  Width = 274
  Height = 480
  BorderStyle = bsSizeToolWin
  Caption = 'Email Details'
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
    Width = 266
    Height = 415
    Align = alClient
    TabOrder = 0
    ColWidths = (
      127
      133)
  end
  object Panel1: TPanel
    Left = 0
    Top = 415
    Width = 266
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      266
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
      Left = 186
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object Button1: TButton
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Add'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object pmAdd: TPopupMenu
    Left = 72
    Top = 184
    object AddToRecipient1: TMenuItem
      Caption = 'Add To Recipient'
      OnClick = AddToRecipient1Click
    end
    object AddCCRecipient1: TMenuItem
      Caption = 'Add CC Recipient'
      OnClick = AddCCRecipient1Click
    end
    object AddBCCRecipient1: TMenuItem
      Caption = 'Add BCC Recipient'
      OnClick = AddBCCRecipient1Click
    end
  end
end
