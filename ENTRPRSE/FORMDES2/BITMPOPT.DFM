object Form_BitmapOptions: TForm_BitmapOptions
  Left = 137
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Bitmap Options'
  ClientHeight = 223
  ClientWidth = 327
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  OnCreate = FormCreate
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 5
    Top = 4
    Width = 222
    Height = 213
    TabOrder = 0
    object Image_Bitmap: TImage
      Left = 0
      Top = 0
      Width = 218
      Height = 209
      Align = alClient
      OnDblClick = Image_BitmapDblClick
    end
  end
  object Button_Ok: TButton
    Left = 239
    Top = 44
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button_OkClick
  end
  object Button_Cancel: TButton
    Left = 239
    Top = 73
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = Button_CancelClick
  end
  object Button3: TButton
    Left = 239
    Top = 5
    Width = 80
    Height = 21
    Caption = '&Open Bitmap'
    TabOrder = 3
    OnClick = Image_BitmapDblClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'BMP'
    Filter = 'Bitmap Files (*.BMP)|*.BMP|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist]
    Title = 'Open Bitmap'
    Left = 246
    Top = 143
  end
end
