object Form1: TForm1
  Left = 160
  Top = 194
  BorderStyle = bsSingle
  Caption = 'Developer Data Test App'
  ClientHeight = 304
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 5
    Top = 4
    Width = 456
    Height = 294
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Developer Info'
      object SBSBackGroup2: TSBSBackGroup
        Left = 4
        Top = 68
        Width = 439
        Height = 71
        Caption = 'Developer Registration Info'
        TextId = 0
      end
      object Label2: TLabel
        Left = 11
        Top = 112
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Company'
      end
      object SBSBackGroup1: TSBSBackGroup
        Left = 4
        Top = 0
        Width = 439
        Height = 66
        Caption = 'Enterprise System Directory'
        TextId = 0
      end
      object Label1: TLabel
        Left = 10
        Top = 16
        Width = 421
        Height = 13
        AutoSize = False
        Caption = 
          'The path to the enterprise System directory containing the main ' +
          'programs.'
      end
      object Label3: TLabel
        Left = 11
        Top = 88
        Width = 54
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'SysId'
      end
      object btnGetDevInfo: TButton
        Left = 338
        Top = 109
        Width = 95
        Height = 21
        Caption = 'Get DevInfo'
        TabOrder = 1
        OnClick = btnGetDevInfoClick
      end
      object edtCompany: TEdit
        Left = 71
        Top = 109
        Width = 261
        Height = 21
        TabOrder = 2
        Text = 'Exchequer Software Ltd'
      end
      object edtSystemDir: TEdit
        Left = 19
        Top = 35
        Width = 386
        Height = 21
        TabOrder = 0
        Text = 'e:\ent430d5'
      end
      object edtSysId: TEdit
        Left = 71
        Top = 85
        Width = 96
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
    end
  end
end
