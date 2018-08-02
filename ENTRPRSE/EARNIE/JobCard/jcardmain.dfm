object frmCoPayLink: TfrmCoPayLink
  Left = 291
  Top = 189
  Width = 539
  Height = 317
  Caption = 'Exchequer Payroll Export v5.70.015'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    531
    283)
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 8
    Width = 529
    Height = 274
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    DesignSize = (
      529
      274)
    object dmlCompany: TDBMultiList
      Left = 8
      Top = 8
      Width = 393
      Height = 233
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Company Code'
          Field = 'C'
          Sortable = True
        end
        item
          Caption = 'Company Name'
          Field = 'N'
          Width = 200
        end
        item
          Caption = 'Payroll ID'
          Field = 'P'
          Width = 50
          IndexNo = 1
        end
        item
          Caption = 'File Name'
          Field = 'F'
          Width = 200
        end>
      TabStop = True
      OnRowDblClick = dmlCompanyRowDblClick
      TabOrder = 0
      Anchors = [akLeft, akTop, akRight]
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
      Dataset = BtrieveDataset1
      Active = False
      SortColIndex = 0
      SortAsc = True
    end
    object Panel2: TPanel
      Left = 408
      Top = 8
      Width = 113
      Height = 242
      Anchors = [akTop, akRight, akBottom]
      BevelInner = bvLowered
      BevelOuter = bvLowered
      TabOrder = 1
      object SBSButton1: TSBSButton
        Left = 4
        Top = 8
        Width = 80
        Height = 21
        Caption = 'Close'
        TabOrder = 0
        OnClick = SBSButton1Click
        TextId = 0
      end
      object ScrollBox1: TScrollBox
        Left = 2
        Top = 82
        Width = 109
        Height = 158
        Align = alBottom
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        object btnAdd: TSBSButton
          Left = 4
          Top = 0
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnAddClick
          TextId = 0
        end
        object btnEdit: TSBSButton
          Left = 4
          Top = 24
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnEditClick
          TextId = 0
        end
        object btnDelete: TSBSButton
          Left = 4
          Top = 48
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 2
          OnClick = btnDeleteClick
          TextId = 0
        end
        object btnOpts: TSBSButton
          Left = 4
          Top = 72
          Width = 80
          Height = 21
          Caption = '&Options'
          TabOrder = 3
          OnClick = btnOptsClick
          TextId = 0
        end
        object SBSButton3: TSBSButton
          Left = 4
          Top = 96
          Width = 80
          Height = 21
          Caption = 'E&xport'
          TabOrder = 4
          OnClick = SBSButton3Click
          TextId = 0
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 252
      Width = 527
      Height = 21
      Align = alBottom
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 2
      object lblProgress: TLabel
        Left = 8
        Top = 5
        Width = 3
        Height = 14
      end
    end
  end
  object BtrieveDataset1: TBtrieveDataset
    FileName = 'JC\MCPAY.DAT'
    OnGetFieldValue = BtrieveDataset1GetFieldValue
    Left = 56
    Top = 40
  end
  object mnuOpts: TPopupMenu
    Left = 24
    Top = 40
    object Directories1: TMenuItem
      Caption = '&Directories'
      OnClick = Directories1Click
    end
    object Employees1: TMenuItem
      Caption = '&Employees'
      OnClick = Employees1Click
    end
    object ViewLogFiles1: TMenuItem
      Caption = '&View Log Files'
      OnClick = ViewLogFiles1Click
    end
  end
end
