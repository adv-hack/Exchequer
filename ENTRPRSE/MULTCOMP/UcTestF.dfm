object frmUCountTest: TfrmUCountTest
  Left = 246
  Top = 135
  Width = 612
  Height = 547
  Caption = 'Global User Count Information [All Companies]'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    604
    520)
  PixelsPerInch = 96
  TextHeight = 13
  object lvUCounts: TListView
    Left = 5
    Top = 172
    Width = 435
    Height = 259
    Anchors = [akLeft, akRight, akBottom]
    Columns = <
      item
        Caption = 'Company Id'
        Width = 80
      end
      item
        Caption = 'WStation Id'
        Width = 120
      end
      item
        Caption = 'User Id'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = 'Ref#'
      end
      item
        Alignment = taCenter
        Width = 25
      end
      item
        Caption = 'Idx'
        Width = 400
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvUCountsDblClick
  end
  object GroupBox1: TGroupBox
    Left = 445
    Top = 167
    Width = 154
    Height = 212
    Anchors = [akRight, akBottom]
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 4
      Top = 66
      Width = 29
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'WSID'
    end
    object Label2: TLabel
      Left = 4
      Top = 41
      Width = 29
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'CID'
    end
    object Label3: TLabel
      Left = 4
      Top = 91
      Width = 29
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'UID'
    end
    object LabelSys: TLabel
      Left = 4
      Top = 16
      Width = 29
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Sys Id'
    end
    object lstCID: TComboBox
      Left = 35
      Top = 38
      Width = 111
      Height = 21
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
    end
    object btnAddLoginRef: TButton
      Left = 9
      Top = 115
      Width = 136
      Height = 28
      Caption = 'Login'
      TabOrder = 1
      OnClick = btnAddLoginRefClick
    end
    object lstWID: TComboBox
      Left = 35
      Top = 63
      Width = 111
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'DEC001'
        'DEC002'
        'DELL01'
        'DELL02'
        'DELL03'
        'HP01'
        '40LONGCOMPUTERNAME_____________________<')
    end
    object lstUID: TComboBox
      Left = 35
      Top = 88
      Width = 111
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'ARNIE'
        'BOD'
        'DARTHVADER'
        'FLUMP'
        'GEEK'
        'RAMBO'
        'SADMUPPET'
        'WALLY'
        '40LONGUSERNAME_________________________<')
    end
    object btnLogout: TButton
      Left = 9
      Top = 145
      Width = 136
      Height = 28
      Caption = 'Logout'
      TabOrder = 4
      OnClick = btnLogoutClick
    end
    object btnResetCIDCounts: TButton
      Left = 9
      Top = 175
      Width = 136
      Height = 28
      Caption = 'Remove CID UCounts'
      TabOrder = 5
      OnClick = btnResetCIDCountsClick
    end
    object lstSysId: TComboBox
      Left = 35
      Top = 13
      Width = 111
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
  end
  object lvCompanies: TListView
    Left = 5
    Top = 3
    Width = 435
    Height = 166
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Company'
        Width = 65
      end
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 'Comp Id'
        Width = 65
      end
      item
        Alignment = taCenter
        Caption = 'Chk'
        Width = 35
      end
      item
        Alignment = taCenter
        Caption = 'UC#'
        Width = 35
      end
      item
        Alignment = taCenter
        Caption = 'TK#'
        Width = 35
      end
      item
        Alignment = taCenter
        Caption = 'TR#'
        Width = 35
      end
      item
        Caption = 'Path'
        Width = 400
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = lvCompaniesDblClick
  end
  object lvLicence: TListView
    Left = 5
    Top = 434
    Width = 435
    Height = 80
    Anchors = [akLeft, akRight, akBottom]
    Columns = <
      item
        Caption = 'System'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = 'Licenced'
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'In Use'
        Width = 90
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
    OnDblClick = lvUCountsDblClick
  end
  object btnRefresh: TButton
    Left = 445
    Top = 58
    Width = 154
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 4
    OnClick = btnRefreshClick
  end
  object btnClose: TButton
    Left = 445
    Top = 22
    Width = 154
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object btnAutoRefresh: TButton
    Left = 445
    Top = 85
    Width = 154
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start Auto-Refresh'
    TabOrder = 6
    OnClick = btnAutoRefreshClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 396
    Top = 28
  end
end
