object frmEmpList: TfrmEmpList
  Left = 278
  Top = 415
  BorderStyle = bsDialog
  Caption = 'Employee Account Groups'
  ClientHeight = 217
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    508
    217)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 497
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      497
      201)
    object mlEmp: TDBMultiList
      Left = 8
      Top = 8
      Width = 353
      Height = 185
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Code'
          Field = 'C'
          Searchable = True
          Sortable = True
          Width = 75
        end
        item
          Caption = 'Name'
          Field = 'N'
          Width = 126
        end
        item
          Caption = 'Account Group'
          Field = 'A'
          Width = 110
        end>
      TabStop = True
      OnRowDblClick = mlEmpRowDblClick
      TabOrder = 0
      Anchors = [akLeft, akTop, akBottom]
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Arial'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
      Dataset = bdEmp
      Active = False
      SortColIndex = 0
      SortAsc = True
    end
    object Panel2: TPanel
      Left = 368
      Top = 8
      Width = 121
      Height = 185
      Anchors = [akTop, akRight, akBottom]
      BevelInner = bvLowered
      BevelOuter = bvLowered
      TabOrder = 1
      object SBSButton1: TSBSButton
        Left = 8
        Top = 8
        Width = 80
        Height = 21
        Caption = '&Close'
        ModalResult = 2
        TabOrder = 0
        TextId = 0
      end
      object ScrollBox1: TScrollBox
        Left = 2
        Top = 72
        Width = 117
        Height = 111
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 1
        object btnEdit: TSBSButton
          Left = 8
          Top = 32
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 0
          OnClick = btnEditClick
          TextId = 0
        end
        object btnAdd: TSBSButton
          Left = 8
          Top = 8
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 1
          OnClick = btnAddClick
          TextId = 0
        end
        object SBSButton4: TSBSButton
          Left = 8
          Top = 56
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 2
          OnClick = SBSButton4Click
          TextId = 0
        end
        object btnImport: TSBSButton
          Left = 8
          Top = 80
          Width = 80
          Height = 21
          Caption = '&Import'
          TabOrder = 3
          OnClick = btnImportClick
          TextId = 0
        end
      end
    end
  end
  object bdEmp: TBtrieveDataset
    FileName = 'jc\emppay.dat'
    OnGetFieldValue = bdEmpGetFieldValue
    Left = 24
    Top = 40
  end
end
