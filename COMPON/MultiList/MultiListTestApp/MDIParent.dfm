object frmMDIParent: TfrmMDIParent
  Left = 263
  Top = 174
  Width = 692
  Height = 480
  Caption = 'frmMDIParent'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 684
    Height = 29
    ButtonWidth = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    object Button2: TButton
      Left = 0
      Top = 2
      Width = 25
      Height = 22
      Caption = 'ML'
      TabOrder = 1
      OnClick = MLClick
    end
    object Button1: TButton
      Left = 25
      Top = 2
      Width = 40
      Height = 22
      Caption = 'DBML'
      TabOrder = 0
      OnClick = DBMLClick
    end
    object Button3: TButton
      Left = 65
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Data Dict'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 140
      Top = 2
      Width = 61
      Height = 22
      Caption = 'PP Debt'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
end
