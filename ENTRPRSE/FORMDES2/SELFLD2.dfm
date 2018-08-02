object Form_SelectField2: TForm_SelectField2
  Left = 366
  Top = 141
  HelpContext = 1200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Field'
  ClientHeight = 352
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 4
    Top = 2
    Width = 554
    Height = 346
    ActivePage = tabDetail
    MultiLine = True
    TabIndex = 2
    TabOrder = 2
    OnChange = PageControl1Change
    object tabAccount: TTabSheet
      Hint = 'Displays fields for accessing Customer/Supplier information'
      Caption = 'Account'
      object lstAccount: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 14
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabTrans: TTabSheet
      Hint = 'Displays fields for accessing Transaction Header information'
      Caption = 'Doc'
      object lstTrans: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 14
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabDetail: TTabSheet
      Caption = 'Lines'
      object lstDetail: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 14
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabStock: TTabSheet
      Caption = 'Stock'
      object lstStock: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabLocation: TTabSheet
      Caption = 'Location'
      object lstLocation: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabSerialNo: TTabSheet
      Caption = 'Serial/Bin'
      object lstSerialNo: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 14
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabJobCost: TTabSheet
      Caption = 'Job Cost'
      object lstJobCost: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabMisc: TTabSheet
      Caption = 'Misc'
      object lstMisc: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
    object tabSystem: TTabSheet
      Caption = 'System'
      object lstSystem: TListBox
        Left = 2
        Top = 3
        Width = 454
        Height = 252
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 0
        TabWidth = 60
        OnClick = lstAccountClick
        OnDblClick = Button_SelectClick
      end
    end
  end
  object Button_Select: TButton
    Left = 470
    Top = 31
    Width = 80
    Height = 21
    Caption = '&Select'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button_SelectClick
  end
  object Button_Cancel: TButton
    Left = 470
    Top = 58
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = Button_CancelClick
  end
  object lstNotes: TListBox
    Left = 10
    Top = 284
    Width = 454
    Height = 57
    ItemHeight = 14
    TabOrder = 3
  end
  object chkLoadAsXRef: TBorCheck
    Left = 467
    Top = 263
    Width = 81
    Height = 20
    Align = alRight
    Caption = 'Show XRef'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TextId = 0
    OnClick = chkLoadAsXRefClick
  end
end
