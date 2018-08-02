object Form1: TForm1
  Left = 80
  Top = 117
  Width = 604
  Height = 300
  Caption = 'Form1'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 3
    Top = 4
    Width = 495
    Height = 69
    Caption = 'xmlInitDLL'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 19
      Width = 48
      Height = 13
      Caption = 'Data Path'
    end
    object Label2: TLabel
      Left = 19
      Top = 44
      Width = 37
      Height = 13
      Caption = 'Ccy Ver'
    end
    object edtInitPath: TEdit
      Left = 63
      Top = 16
      Width = 289
      Height = 21
      TabOrder = 0
      Text = 'c:\wibble\'
    end
    object lstCcyVer: TComboBox
      Left = 63
      Top = 41
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      Items.Strings = (
        'Professional'
        'Euro'
        'Global')
      TabOrder = 1
    end
    object btnInit: TButton
      Left = 361
      Top = 9
      Width = 129
      Height = 56
      Caption = 'xmlInitDLL'
      TabOrder = 2
      OnClick = btnInitClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 3
    Top = 76
    Width = 495
    Height = 69
    Caption = 'xmlInitDLL'
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 19
      Width = 50
      Height = 13
      Caption = 'Save Path'
    end
    object Label4: TLabel
      Left = 19
      Top = 44
      Width = 34
      Height = 13
      Caption = 'OurRef'
    end
    object edtSavePath: TEdit
      Left = 63
      Top = 16
      Width = 289
      Height = 21
      TabOrder = 0
      Text = 'c:\wibble\'
    end
    object btnTrans: TButton
      Left = 361
      Top = 9
      Width = 129
      Height = 56
      Caption = 'xmlTransXMLFile'
      TabOrder = 2
      OnClick = btnTransClick
    end
    object edtOurRef: TEdit
      Left = 63
      Top = 40
      Width = 104
      Height = 21
      TabOrder = 1
      Text = 'POR000102'
    end
  end
  object GroupBox3: TGroupBox
    Left = 3
    Top = 147
    Width = 495
    Height = 69
    Caption = 'xmlCloseDLL'
    TabOrder = 2
    object btnClose: TButton
      Left = 361
      Top = 9
      Width = 129
      Height = 56
      Caption = 'xmlCloseDLL'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
