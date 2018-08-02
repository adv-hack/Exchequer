object frmSelectCompany: TfrmSelectCompany
  Left = 377
  Top = 199
  HelpContext = 2
  ActiveControl = lvCompanies
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Exchequer Data Query Wizard'
  ClientHeight = 288
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  HelpFile = 'EnterOle.Hlp'
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 12
    Top = 240
    Width = 440
    Height = 11
    Shape = bsBottomLine
  end
  object TitleLbl: TLabel
    Left = 167
    Top = 10
    Width = 288
    Height = 28
    AutoSize = False
    Caption = 'Select Company'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object lblInstructions: TLabel
    Left = 167
    Top = 49
    Width = 285
    Height = 30
    AutoSize = False
    Caption = 'Please select the Company Data Set that you wish to import the '
    WordWrap = True
  end
  object imgSide: TImage
    Left = 5
    Top = 161
    Width = 76
    Height = 84
    Visible = False
  end
  object btnHelp: TButton
    Left = 13
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Help'
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object Panel1: TPanel
    Left = 12
    Top = 15
    Width = 145
    Height = 223
    BevelOuter = bvLowered
    TabOrder = 2
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 143
      Height = 221
    end
  end
  object btnClose: TButton
    Left = 100
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnBack: TButton
    Left = 286
    Top = 257
    Width = 79
    Height = 23
    Caption = '<< &Back'
    TabOrder = 4
    Visible = False
  end
  object btnNext: TButton
    Left = 372
    Top = 257
    Width = 79
    Height = 23
    Caption = '&Next >>'
    TabOrder = 5
    OnClick = btnNextClick
  end
  object lvCompanies: TListView
    Left = 167
    Top = 87
    Width = 285
    Height = 152
    Columns = <
      item
        Caption = 'Code'
        Width = 65
      end
      item
        Caption = 'Company'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnNextClick
  end
end
