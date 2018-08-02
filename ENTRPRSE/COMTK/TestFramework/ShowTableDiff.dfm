object frmShowTableDifferences: TfrmShowTableDifferences
  Left = 461
  Top = 365
  Width = 545
  Height = 402
  Caption = 'frmShowTableDifferences'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 327
    Width = 537
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      537
      41)
    object Button1: TButton
      Left = 441
      Top = 8
      Width = 87
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 327
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object lvDiffs: TListView
      Left = 1
      Top = 1
      Width = 535
      Height = 325
      Align = alClient
      Columns = <
        item
          Caption = 'Field'
          Width = 120
        end
        item
          Caption = 'Db1'
          Width = 200
        end
        item
          Caption = 'Db2'
          Width = 200
        end>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
