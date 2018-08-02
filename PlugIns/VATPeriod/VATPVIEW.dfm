object frmPeriodList: TfrmPeriodList
  Left = 301
  Top = 107
  Width = 406
  Height = 421
  BorderIcons = [biSystemMenu]
  Caption = 'VAT Period Administration'
  Color = clBtnFace
  Constraints.MinHeight = 303
  Constraints.MinWidth = 303
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    398
    367)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 7
    Top = 0
    Width = 385
    Height = 336
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      385
      336)
    object lblCurrentPeriod: TLabel
      Left = 88
      Top = 317
      Width = 3
      Height = 13
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 313
      Width = 91
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Current Tax Period:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lvPeriods: TListView
      Left = 8
      Top = 16
      Width = 281
      Height = 287
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Period'
          Width = 45
        end
        item
          Caption = 'Year'
          Width = 45
        end
        item
          Caption = 'Start Date'
          Width = 85
        end
        item
          Caption = 'End Date'
          Width = 85
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnAdvancedCustomDrawItem = lvPeriodsAdvancedCustomDrawItem
      OnDblClick = btnEditClick
    end
    object btnEdit: TButton
      Left = 298
      Top = 80
      Width = 75
      Height = 25
      Hint = 'Edit the selected period'
      Anchors = [akTop, akRight]
      Caption = '&Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnAdd: TButton
      Left = 298
      Top = 16
      Width = 75
      Height = 25
      Hint = 'Add a period to the end of the table'
      Anchors = [akTop, akRight]
      Caption = '&Add'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnInsert: TButton
      Left = 298
      Top = 48
      Width = 75
      Height = 25
      Hint = 'Insert a period at the start of the table'
      Anchors = [akTop, akRight]
      Caption = '&Insert'
      TabOrder = 3
      OnClick = btnInsertClick
    end
    object edtCurrentPeriod: TEdit
      Left = 104
      Top = 309
      Width = 57
      Height = 21
      Anchors = [akLeft, akBottom]
      ReadOnly = True
      TabOrder = 4
    end
    object Button1: TButton
      Left = 298
      Top = 112
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Close Period'
      TabOrder = 5
      OnClick = CloseCurrentPeriod2Click
    end
  end
  object Button2: TButton
    Left = 313
    Top = 339
    Width = 78
    Height = 25
    Hint = 'Exit from the VAT Period Administration form'
    Anchors = [akRight, akBottom]
    Caption = 'E&xit'
    TabOrder = 1
    OnClick = Button2Click
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 40
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        Hint = 'Exit from the VAT Period Administration form'
        OnClick = Button2Click
      end
    end
    object Period1: TMenuItem
      Caption = '&Period'
      object AddatEnd1: TMenuItem
        Caption = '&Add'
        Hint = 'Add a period to the end of the table'
        OnClick = btnAddClick
      end
      object Insert1: TMenuItem
        Caption = '&Insert'
        Hint = 'Insert a period at the start of the table'
        OnClick = btnInsertClick
      end
      object Edit1: TMenuItem
        Caption = '&Edit'
        Hint = 'Edit the selected period'
        OnClick = btnEditClick
      end
      object Autofill1: TMenuItem
        Caption = 'Auto&fill'
        Hint = 'Create periods for next year based upon the current year'
        OnClick = Autofill1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SetCurrentPeriod1: TMenuItem
        Caption = '&Set Current Tax Period'
        Hint = 'Change the current period to the selected period'
        OnClick = SetCurrentPeriod1Click
      end
      object CloseCurrentPeriod2: TMenuItem
        Caption = '&Close Current Tax Period'
        Hint = 'Close the current period'
        OnClick = CloseCurrentPeriod2Click
      end
    end
    object Tools1: TMenuItem
      Caption = '&Tools'
      object CopyPeriodTable1: TMenuItem
        Caption = '&Copy Period Table to Another Company'
        Hint = 'Copy the VAT period table to another company'
        OnClick = CopyPeriodTable1Click
      end
      object Options1: TMenuItem
        Caption = '&Options'
        Hint = 'Show the Options dialog'
        OnClick = Options1Click
      end
    end
  end
end
