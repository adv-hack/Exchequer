object frmScriptDetails: TfrmScriptDetails
  Left = 388
  Top = 207
  Width = 498
  Height = 504
  Caption = 'Script Details'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object bev1: TBevel
    Left = 8
    Top = 8
    Width = 473
    Height = 425
    Shape = bsFrame
  end
  object bev2: TBevel
    Left = 8
    Top = 8
    Width = 473
    Height = 73
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 19
    Top = 28
    Width = 64
    Height = 14
    Caption = 'Script Name :'
  end
  object btnCancel: TButton
    Left = 400
    Top = 440
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 312
    Top = 440
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object memScript: TMemo
    Left = 16
    Top = 96
    Width = 457
    Height = 297
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnRunScript: TButton
    Left = 392
    Top = 400
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Run Script'
    TabOrder = 3
    OnClick = btnRunScriptClick
  end
  object edName: TEdit
    Left = 88
    Top = 24
    Width = 385
    Height = 22
    TabOrder = 4
  end
  object cbCreateDatabase: TCheckBox
    Left = 88
    Top = 56
    Width = 145
    Height = 17
    Caption = 'Create Database Script ?'
    TabOrder = 5
  end
end
