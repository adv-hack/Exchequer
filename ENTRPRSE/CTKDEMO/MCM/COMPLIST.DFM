object frmMCM: TfrmMCM
  Left = 350
  Top = 236
  Width = 491
  Height = 329
  HorzScrollBar.Visible = False
  Caption = 'Enterprise COM Toolkit - Company List'
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
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 95
    Height = 13
    Caption = 'Main Company Path'
  end
  object lvCompanies: TListView
    Left = 6
    Top = 37
    Width = 471
    Height = 259
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 70
      end
      item
        Caption = 'Company'
        Width = 200
      end
      item
        Caption = 'Path'
        Width = 300
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object edtEnterpriseDir: TEdit
    Left = 107
    Top = 8
    Width = 290
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'e:\ent430d5\'
  end
  object btnUpdate: TButton
    Left = 403
    Top = 9
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Update'
    TabOrder = 2
    OnClick = btnUpdateClick
  end
end
