object Form1: TForm1
  Left = 300
  Top = 99
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 521
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 15
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Product Name'
  end
  object Label2: TLabel
    Left = 17
    Top = 43
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Short Description'
  end
  object Bevel1: TBevel
    Left = 18
    Top = 142
    Width = 403
    Height = 2
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 22
    Top = 197
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Product Name'
  end
  object Label4: TLabel
    Left = 22
    Top = 224
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Licence No'
  end
  object Label5: TLabel
    Left = 17
    Top = 72
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Expiry Date'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 450
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object edtLicenceeProduct: TEdit
    Left = 122
    Top = 12
    Width = 275
    Height = 21
    MaxLength = 45
    TabOrder = 0
    Text = 'Exchequer COM Toolkit'
  end
  object mskShortDesc: TMaskEdit
    Left = 122
    Top = 40
    Width = 77
    Height = 21
    CharCase = ecUpperCase
    EditMask = '>aaaaaaaa;1;_'
    MaxLength = 8
    TabOrder = 1
    Text = 'EXENTCTK'
  end
  object btnCalcLicenceStrings: TButton
    Left = 43
    Top = 154
    Width = 346
    Height = 25
    Caption = 'Calc Forms Toolkit Licencing'
    TabOrder = 2
    OnClick = btnCalcLicenceStringsClick
  end
  object edtProductName: TEdit
    Left = 127
    Top = 194
    Width = 241
    Height = 21
    TabOrder = 3
  end
  object edtLicenceNo: TEdit
    Left = 127
    Top = 221
    Width = 241
    Height = 21
    TabOrder = 4
  end
  object dtpExpiry: TDateTimePicker
    Left = 122
    Top = 68
    Width = 110
    Height = 21
    CalAlignment = dtaLeft
    Date = 37545.4919836227
    Time = 37545.4919836227
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
  end
  object chkInfiniteLicence: TCheckBox
    Left = 243
    Top = 70
    Width = 167
    Height = 17
    Caption = 'Licence Never Expires'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object chkDemo: TCheckBox
    Left = 39
    Top = 99
    Width = 167
    Height = 17
    Caption = 'Demo Licence'
    TabOrder = 7
  end
  object btnTestLicence: TButton
    Left = 43
    Top = 251
    Width = 346
    Height = 25
    Caption = 'Test Forms Toolkit Licencing'
    TabOrder = 8
    OnClick = btnTestLicenceClick
  end
  object ListBox1: TListBox
    Left = 20
    Top = 288
    Width = 417
    Height = 225
    ItemHeight = 13
    TabOrder = 9
    TabWidth = 120
  end
  object MainMenu1: TMainMenu
    Left = 410
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
end
