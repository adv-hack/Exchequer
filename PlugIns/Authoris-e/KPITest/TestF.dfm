object Form1: TForm1
  Left = 164
  Top = 148
  Width = 342
  Height = 362
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 104
    Width = 321
    Height = 217
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 238
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Get Requests'
      TabOrder = 0
      OnClick = Button1Click
    end
    object lbRequests: TListBox
      Left = 16
      Top = 16
      Width = 209
      Height = 193
      ItemHeight = 13
      TabOrder = 1
    end
    object Button2: TButton
      Left = 238
      Top = 48
      Width = 75
      Height = 25
      Caption = '&Authorise'
      TabOrder = 2
      OnClick = Button2Click
    end
    object btnReject: TButton
      Left = 238
      Top = 80
      Width = 75
      Height = 25
      Caption = '&Reject'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel2'
    TabOrder = 1
    object Label1: TLabel
      Left = 51
      Top = 8
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company'
    end
    object Label2: TLabel
      Left = 48
      Top = 32
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'Authoriser'
    end
    object Label3: TLabel
      Left = 45
      Top = 56
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auth Code'
    end
    object cbCompanies: TComboBox
      Left = 104
      Top = 8
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object edtAuth: TEdit
      Left = 104
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'MANAGER'
    end
    object edtCode: TEdit
      Left = 104
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '12345'
    end
  end
end
