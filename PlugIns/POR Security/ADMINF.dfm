object frmAdmin: TfrmAdmin
  Left = 376
  Top = 176
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer POR Security Plug-In Administrator'
  ClientHeight = 320
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 404
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 4
    Top = 10
    Width = 84
    Height = 14
    Caption = 'Current Company'
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 32
    Width = 392
    Height = 282
    ActivePage = tabshUsers
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object tabshDept: TTabSheet
      Caption = 'Department Codes'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 0
        Width = 270
        Height = 249
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 14
          Width = 251
          Height = 37
          AutoSize = False
          Caption = 
            'Use this section to maintain the list of Department Codes.  Code' +
            's are up to 20 characters long.'
          WordWrap = True
        end
        object btnAddDept: TButton
          Left = 181
          Top = 54
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 1
          OnClick = btnAddDeptClick
        end
        object btnDeleteDept: TButton
          Left = 181
          Top = 79
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 2
          OnClick = btnDeleteDeptClick
        end
        object lvDepartments: TListView
          Left = 8
          Top = 53
          Width = 169
          Height = 188
          Columns = <
            item
              Caption = 'Department Code'
              Width = 250
            end>
          ReadOnly = True
          RowSelect = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object tabshUsers: TTabSheet
      Caption = 'User Rights'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 4
        Top = 0
        Width = 376
        Height = 249
        TabOrder = 0
        object Label2: TLabel
          Left = 7
          Top = 14
          Width = 360
          Height = 33
          AutoSize = False
          Caption = 
            'Use this section to maintain the list of Users allows to view PO' +
            'R/PDN Transactions.  The hook will prevent undefined users from ' +
            'seeing POR'#39's.'
          WordWrap = True
        end
        object btnAddUser: TButton
          Left = 287
          Top = 54
          Width = 80
          Height = 21
          Caption = '&Add'
          TabOrder = 1
          OnClick = btnAddUserClick
        end
        object btnEditUser: TButton
          Left = 287
          Top = 80
          Width = 80
          Height = 21
          Caption = '&Edit'
          TabOrder = 2
          OnClick = btnEditUserClick
        end
        object btnDeleteUser: TButton
          Left = 287
          Top = 106
          Width = 80
          Height = 21
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnDeleteUserClick
        end
        object lvUsers: TListView
          Left = 8
          Top = 53
          Width = 275
          Height = 188
          Columns = <
            item
              Caption = 'User Code'
              Width = 85
            end
            item
              Caption = 'Type'
              MinWidth = 20
              Width = 60
            end
            item
              Caption = 'Department'
              Width = 150
            end>
          ReadOnly = True
          RowSelect = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = btnEditUserClick
        end
      end
    end
  end
  object lstCompanies: TComboBox
    Left = 89
    Top = 6
    Width = 300
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 1
    OnClick = lstCompaniesClick
  end
  object MainMenu1: TMainMenu
    Left = 303
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuoptExit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = mnuoptExitClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      object mnuoptAbout: TMenuItem
        Caption = '&About'
        OnClick = mnuoptAboutClick
      end
    end
  end
end
