object frmGroupDetail: TfrmGroupDetail
  Left = 421
  Top = 251
  Width = 534
  Height = 278
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'frmGroupDetail'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  DesignSize = (
    501
    223)
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 3
    Top = 3
    Width = 520
    Height = 239
    ActivePage = tabshGroupUsers
    TabIndex = 2
    TabOrder = 0
    OnChange = PageControl1Change
    object tabshMain: TTabSheet
      Caption = 'Main'
      ImageIndex = 2
      DesignSize = (
        512
        210)
      object SBSBackGroup1: TSBSBackGroup
        Left = 3
        Top = -2
        Width = 388
        Height = 70
        TextId = 0
      end
      object Label1: TLabel
        Left = 6
        Top = 15
        Width = 42
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Code'
      end
      object Label2: TLabel
        Left = 6
        Top = 41
        Width = 42
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Name'
      end
      object edtName: Text8Pt
        Left = 52
        Top = 38
        Width = 332
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextId = 0
        ViaSBtn = False
      end
      object edtCode: Text8Pt
        Left = 52
        Top = 12
        Width = 188
        Height = 22
        CharCase = ecUpperCase
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
    end
    object tabshGroupCompanies: TTabSheet
      Caption = 'Companies'
      ImageIndex = 1
      DesignSize = (
        512
        210)
      object mulCompanies: TDBMultiList
        Left = 3
        Top = 3
        Width = 390
        Height = 204
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Code'
            Field = '0'
            Searchable = True
            Sortable = True
            Width = 70
          end
          item
            Caption = 'Name'
            Field = '1'
            Width = 270
          end>
        TabStop = True
        OnCellPaint = mulCompaniesCellPaint
        OnRowDblClick = mulCompaniesRowDblClick
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        TabOrder = 0
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Dataset = bdsCompanies
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
    object tabshGroupUsers: TTabSheet
      Caption = 'Users'
      ImageIndex = 2
      DesignSize = (
        512
        210)
      object mulGroupUsers: TDBMultiList
        Left = 3
        Top = 3
        Width = 390
        Height = 204
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'User Id'
            Field = '0'
            Searchable = True
            Sortable = True
          end
          item
            Caption = 'Name'
            Field = '1'
            Searchable = True
            Sortable = True
            Width = 240
            IndexNo = 1
          end>
        TabStop = True
        OnRowDblClick = mulGroupUsersRowDblClick
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        TabOrder = 0
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Dataset = bdsGroupUsers
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
  end
  object panButtons: TPanel
    Left = 405
    Top = 31
    Width = 111
    Height = 204
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      111
      204)
    object btnCancel: TSBSButton
      Left = 4
      Top = 28
      Width = 83
      Height = 21
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      TextId = 0
    end
    object btnClose: TSBSButton
      Left = 4
      Top = 52
      Width = 83
      Height = 21
      Caption = 'C&lose'
      TabOrder = 2
      OnClick = btnCloseClick
      TextId = 0
    end
    object btnOK: TSBSButton
      Left = 4
      Top = 4
      Width = 83
      Height = 21
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
      TextId = 0
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 76
      Width = 107
      Height = 128
      Anchors = [akLeft, akTop, akBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 3
      object btnAdd: TSBSButton
        Left = 4
        Top = 4
        Width = 83
        Height = 21
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddClick
        TextId = 0
      end
      object btnEdit: TSBSButton
        Left = 4
        Top = 28
        Width = 83
        Height = 21
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnEditClick
        TextId = 0
      end
      object btnDelete: TSBSButton
        Left = 4
        Top = 52
        Width = 83
        Height = 21
        Caption = '&Delete'
        TabOrder = 2
        OnClick = btnDeleteClick
        TextId = 0
      end
      object btnView: TSBSButton
        Left = 4
        Top = 76
        Width = 83
        Height = 21
        Caption = '&View'
        TabOrder = 3
        OnClick = btnViewClick
        TextId = 0
      end
      object btnChangePWord: TSBSButton
        Left = 4
        Top = 100
        Width = 83
        Height = 21
        Caption = 'Change &Pword'
        TabOrder = 4
        OnClick = btnChangePWordClick
        TextId = 0
      end
    end
  end
  object bdsCompanies: TBTGlobalDataset
    FileName = 'Property Not Used'
    OnGetFieldValue = bdsCompaniesGetFieldValue
    OnGetFileVar = bdsCompaniesGetFileVar
    OnGetDataRecord = bdsCompaniesGetDataRecord
    OnGetBufferSize = bdsCompaniesGetBufferSize
    Left = 146
    Top = 170
  end
  object bdsGroupUsers: TBTGlobalDataset
    FileName = 'Property Not Used'
    OnGetFieldValue = bdsGroupUsersGetFieldValue
    OnGetFileVar = bdsGroupUsersGetFileVar
    OnGetDataRecord = bdsGroupUsersGetDataRecord
    OnGetBufferSize = bdsGroupUsersGetBufferSize
    Left = 230
    Top = 170
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 310
    Top = 169
    object popAddUser: TMenuItem
      Tag = 1
      Caption = '&Add User'
      OnClick = btnAddClick
    end
    object popEditUser: TMenuItem
      Tag = 2
      Caption = '&Edit User'
      OnClick = btnEditClick
    end
    object popDeleteUser: TMenuItem
      Tag = 3
      Caption = '&Delete User'
      OnClick = btnDeleteClick
    end
    object popViewUser: TMenuItem
      Caption = '&View User'
      OnClick = btnViewClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popChangePassword: TMenuItem
      Caption = '&Change Password'
      OnClick = btnChangePWordClick
    end
    object popLinkCompanies: TMenuItem
      Caption = '&Link Companies'
      OnClick = btnAddClick
    end
    object PopupOpt_SepBar2: TMenuItem
      Caption = '-'
    end
    object popFormProperties: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = popFormPropertiesClick
    end
    object PopupOpt_SepBar3: TMenuItem
      Caption = '-'
    end
    object popSavePosition: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
