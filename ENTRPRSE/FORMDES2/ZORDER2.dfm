object Form_ZOrder: TForm_ZOrder
  Left = 354
  Top = 162
  HelpContext = 2000
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Current Controls'
  ClientHeight = 361
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
  object Panel_Buttons: TPanel
    Left = 459
    Top = 0
    Width = 87
    Height = 361
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Button_Options: TButton
      Left = 4
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Options'
      TabOrder = 0
      OnClick = Button_OptionsClick
    end
    object Button_Close: TButton
      Left = 4
      Top = 193
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      TabOrder = 6
      OnClick = Button_CloseClick
    end
    object Button_If: TButton
      Left = 4
      Top = 33
      Width = 80
      Height = 21
      Caption = '&If'
      TabOrder = 1
      OnClick = Button_IfClick
    end
    object Button_MoveUp: TButton
      Left = 4
      Top = 130
      Width = 80
      Height = 21
      Caption = 'Move &Up'
      TabOrder = 4
      OnClick = Button_MoveUpClick
    end
    object Button_MoveDown: TButton
      Left = 4
      Top = 157
      Width = 80
      Height = 21
      Caption = 'Move D&own'
      TabOrder = 5
      OnClick = Button_MoveUpClick
    end
    object Button_Delete: TButton
      Left = 4
      Top = 69
      Width = 80
      Height = 21
      Caption = '&Delete'
      TabOrder = 2
      OnClick = Button_DeleteClick
    end
    object Button_Find: TButton
      Left = 4
      Top = 95
      Width = 80
      Height = 21
      Caption = '&Find'
      TabOrder = 3
      OnClick = Button_FindClick
    end
  end
  object Panel_List: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 361
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object ListView1: TListView
      Left = 3
      Top = 3
      Width = 453
      Height = 355
      Align = alClient
      Columns = <
        item
          Caption = 'Name'
          Width = 60
        end
        item
          Caption = 'Information'
          Width = 180
        end
        item
          Caption = 'Print If'
          Width = 100
        end
        item
          Caption = 'Position'
          Width = 200
        end>
      ReadOnly = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListView1Click
      OnDblClick = Button_OptionsClick
    end
  end
end
