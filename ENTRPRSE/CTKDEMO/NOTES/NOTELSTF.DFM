object frmNotesList: TfrmNotesList
  Left = 257
  Top = 171
  Width = 574
  Height = 297
  Caption = 'frmNotesList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 3
    Width = 558
    Height = 263
    ActivePage = tabshGeneral
    TabOrder = 0
    OnChange = PageControl1Change
    object tabshDated: TTabSheet
      Caption = 'Dated'
      object lvDatedNotes: TListView
        Left = 3
        Top = 4
        Width = 448
        Height = 227
        Columns = <
          item
            Caption = 'Date'
            Width = 80
          end
          item
            Caption = 'Notes'
            Width = 260
          end
          item
            Caption = 'User'
            Width = 80
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tabshGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 1
      object lvGenNotes: TListView
        Left = 3
        Top = 4
        Width = 448
        Height = 227
        Columns = <
          item
            Caption = 'Notes'
            Width = 340
          end
          item
            Caption = 'User'
            Width = 80
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object Panel1: TPanel
    Left = 462
    Top = 31
    Width = 91
    Height = 226
    BevelOuter = bvLowered
    TabOrder = 1
    object btnClose: TButton
      Left = 5
      Top = 5
      Width = 80
      Height = 21
      Caption = '&Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnAdd: TButton
      Left = 5
      Top = 34
      Width = 80
      Height = 21
      Caption = '&Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
  end
end
