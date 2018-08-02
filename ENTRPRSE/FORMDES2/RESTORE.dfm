object Form_Restore: TForm_Restore
  Left = 354
  Top = 177
  HelpContext = 3000
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Restore Deleted Controls'
  ClientHeight = 255
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel_Button: TPanel
    Left = 459
    Top = 0
    Width = 87
    Height = 255
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Button_Restore: TButton
      Left = 3
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Restore'
      TabOrder = 0
      OnClick = Button_RestoreClick
    end
    object Button_Close: TButton
      Left = 3
      Top = 39
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel_List: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 255
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object ListView1: TListView
      Left = 3
      Top = 3
      Width = 453
      Height = 249
      Align = alClient
      Columns = <
        item
          Caption = 'Time'
          Width = 60
        end
        item
          Caption = 'Name'
          Width = 60
        end
        item
          Caption = 'Information'
          Width = 220
        end
        item
          Caption = 'Position'
          Width = 200
        end>
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListView1Click
      OnDblClick = Button_RestoreClick
    end
  end
end
