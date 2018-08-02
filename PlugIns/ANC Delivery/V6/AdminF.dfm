object frmAdminMain: TfrmAdminMain
  Left = 623
  Top = 215
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmAdminMain'
  ClientHeight = 318
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    430
    318)
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 430
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object PageControl1: TPageControl
    Left = 5
    Top = 6
    Width = 420
    Height = 307
    ActivePage = tabshSettings
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 2
    TabOrder = 0
    object tabshServices: TTabSheet
      Caption = 'Service Codes'
      DesignSize = (
        412
        278)
      object Label1: TLabel
        Left = 4
        Top = 3
        Width = 314
        Height = 35
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'These are the ANC Service Codes together with a description of t' +
          'he service.'
        WordWrap = True
      end
      object btnAddService: TButton
        Left = 328
        Top = 52
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddServiceClick
      end
      object btnDeleteService: TButton
        Left = 328
        Top = 100
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Delete'
        TabOrder = 1
        OnClick = btnDeleteServiceClick
      end
      object lvServices: TListView
        Left = 4
        Top = 33
        Width = 318
        Height = 240
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Code'
            Width = 60
          end
          item
            Caption = 'Description'
            Width = 300
          end>
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = btnEditServiceClick
      end
      object btnEditService: TButton
        Left = 328
        Top = 76
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Edit'
        TabOrder = 3
        OnClick = btnEditServiceClick
      end
    end
    object tabshDefaults: TTabSheet
      Caption = 'Default Codes'
      ImageIndex = 1
      DesignSize = (
        412
        278)
      object Label2: TLabel
        Left = 4
        Top = 3
        Width = 314
        Height = 35
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Default Codes are used on the Transaction Header to tell the ANC' +
          ' Delivery Link Plug-In which service is to be used.'
        WordWrap = True
      end
      object btnAddDefault: TButton
        Left = 328
        Top = 52
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddDefaultClick
      end
      object btnDeleteDefault: TButton
        Left = 328
        Top = 78
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Delete'
        TabOrder = 1
        OnClick = btnDeleteDefaultClick
      end
      object lvDefaults: TListView
        Left = 4
        Top = 33
        Width = 318
        Height = 240
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Default Code'
            Width = 90
          end
          item
            Caption = 'Service Code'
            MinWidth = 20
            Width = 90
          end
          item
            Caption = 'Description'
            Width = 250
          end>
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 2
        ViewStyle = vsReport
      end
    end
    object tabshSettings: TTabSheet
      Caption = 'Settings'
      ImageIndex = 2
      DesignSize = (
        412
        278)
      object Label3: TLabel
        Left = 4
        Top = 3
        Width = 314
        Height = 44
        AutoSize = False
        Caption = 
          'The ANC Path points to the directory which contains the ANC Deli' +
          'verANCe software, this path must be common to all workstations u' +
          'sing the Plug-In.'
        WordWrap = True
      end
      object Label4: TLabel
        Left = 9
        Top = 51
        Width = 46
        Height = 14
        Caption = 'ANC Path'
      end
      object Label5: TLabel
        Left = 4
        Top = 76
        Width = 314
        Height = 31
        AutoSize = False
        Caption = 
          'Your ANC Contract Number is required by the ANC Software when im' +
          'porting the delivery details.'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 9
        Top = 112
        Width = 47
        Height = 14
        Caption = 'Contract#'
      end
      object Label7: TLabel
        Left = 23
        Top = 161
        Width = 314
        Height = 31
        AutoSize = False
        Caption = 
          'Your ANC Account Number is required by the ANC Software when imp' +
          'orting the delivery details in the Extended Export Mode.'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 28
        Top = 197
        Width = 47
        Height = 14
        Caption = 'Account#'
      end
      object Label9: TLabel
        Left = 23
        Top = 219
        Width = 314
        Height = 31
        AutoSize = False
        Caption = 
          'The System Id can also be specified when importing the delivery ' +
          'details in the Extended Export Mode.'
        WordWrap = True
      end
      object Label10: TLabel
        Left = 28
        Top = 255
        Width = 53
        Height = 13
        AutoSize = False
        Caption = 'System Id'
      end
      object edtANCPath: TEdit
        Left = 63
        Top = 48
        Width = 221
        Height = 22
        TabOrder = 0
      end
      object btnEditSettings: TButton
        Left = 328
        Top = 4
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '&Edit'
        TabOrder = 6
        OnClick = btnEditSettingsClick
      end
      object btnCancelSettings: TButton
        Left = 328
        Top = 30
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 7
        OnClick = btnCancelSettingsClick
      end
      object edtContractNo: TEdit
        Left = 62
        Top = 109
        Width = 120
        Height = 22
        TabOrder = 2
      end
      object btnBrowse: TButton
        Left = 285
        Top = 48
        Width = 22
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
      object chkExtendedMode: TCheckBox
        Left = 4
        Top = 140
        Width = 212
        Height = 17
        Caption = 'Use Extended Export Mode'
        TabOrder = 3
        OnClick = chkExtendedModeClick
      end
      object edtANCAccountNo: TEdit
        Left = 81
        Top = 194
        Width = 120
        Height = 22
        CharCase = ecUpperCase
        MaxLength = 10
        TabOrder = 4
      end
      object edtSystemId: TEdit
        Left = 81
        Top = 252
        Width = 120
        Height = 22
        TabOrder = 5
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 376
    Top = 87
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 360
    Top = 104
  end
end
