object FrmProgress: TFrmProgress
  Left = 380
  Top = 273
  HelpContext = 1
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Please Wait...'
  ClientHeight = 105
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 80
    Width = 273
    Height = 17
    Min = 0
    Max = 100
    Step = 1
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 65
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Image1: TImage
      Left = 8
      Top = 16
      Width = 33
      Height = 25
      Picture.Data = {
        07544269746D6170E6010000424DE60100000000000076000000280000001F00
        0000170000000100040000000000700100000000000000000000100000001000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00111111111111111111111111111111101180000000000000000081111111
        1110180FFFFFFFFFFFFFFFFF08111111111010FFFF2FFFFFFFFFFFFFF0111111
        111010F2F222F2FF222F22F2F0008111111010FF22222FFFFFFFFFFFF0F70811
        111010FF2F2F2FFF22F2F222F07F7011111010F2F222F2FFFFFFFFFFF0F2F000
        811010F2F222F2FF2F222F22F07F7077081010F2F222F2FFFFFFFFFFF022F077
        701010F222F222FF222F2F22F07F7072701010FF22F22FFFFFFFFFFFF022F077
        701010FF2FFF2FFF2222F222F07F7022701010FFFFFFFFFFFFFFFFFFF022F077
        7010180FFFFFFFFFFFFFFFFF087F70227010118000000000000000008222F077
        70101111107F7F7F7F7F7F7F7F7F7022701011111807F7F7F7F7F7F7F7F70877
        7010111111800000000000000000822270101111111110777777777777777777
        7010111111111807777777777777777708101111111111800000000000000000
        811011111111111111111111111111111110}
      Transparent = True
    end
    object Label2: TLabel
      Left = 48
      Top = 16
      Width = 40
      Height = 14
      Caption = 'Status : '
    end
    object lStatus: TLabel
      Left = 88
      Top = 16
      Width = 185
      Height = 14
      AutoSize = False
      Caption = 'Initialising'
    end
    object Label1: TLabel
      Left = 48
      Top = 32
      Width = 36
      Height = 14
      Caption = 'Name : '
    end
    object lName: TLabel
      Left = 88
      Top = 32
      Width = 177
      Height = 14
      AutoSize = False
    end
  end
end
