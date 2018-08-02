object frmPaths: TfrmPaths
  Left = 288
  Top = 154
  BorderStyle = bsToolWindow
  Caption = 'Database Paths'
  ClientHeight = 155
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblCustomers: TLabel
    Left = 14
    Top = 20
    Width = 49
    Height = 13
    Caption = 'Customers'
  end
  object lblSuppliers: TLabel
    Left = 20
    Top = 44
    Width = 43
    Height = 13
    Caption = 'Suppliers'
  end
  object lblJobs: TLabel
    Left = 41
    Top = 68
    Width = 22
    Height = 13
    Caption = 'Jobs'
  end
  object lblMisc: TLabel
    Left = 41
    Top = 92
    Width = 22
    Height = 13
    Caption = 'Misc'
  end
  object sbCustomers: TSpeedButton
    Left = 312
    Top = 16
    Width = 23
    Height = 22
    OnClick = sbCustomersClick
  end
  object sbSuppliers: TSpeedButton
    Left = 312
    Top = 40
    Width = 23
    Height = 22
    OnClick = sbSuppliersClick
  end
  object sbJobs: TSpeedButton
    Left = 312
    Top = 64
    Width = 23
    Height = 22
    OnClick = sbJobsClick
  end
  object sbMisc: TSpeedButton
    Left = 312
    Top = 88
    Width = 23
    Height = 22
    OnClick = sbMiscClick
  end
  object bnCancel: TButton
    Left = 232
    Top = 120
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object bnOK: TButton
    Left = 152
    Top = 120
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object edCustomers: TEdit
    Left = 76
    Top = 16
    Width = 229
    Height = 21
    TabOrder = 2
  end
  object edSuppliers: TEdit
    Left = 76
    Top = 40
    Width = 229
    Height = 21
    TabOrder = 3
  end
  object edJobs: TEdit
    Left = 76
    Top = 64
    Width = 229
    Height = 21
    TabOrder = 4
  end
  object edMisc: TEdit
    Left = 76
    Top = 88
    Width = 229
    Height = 21
    TabOrder = 5
  end
  object OpenDialog: TOpenDialog
    Filter = 'Btrieve Data Files (*.dat)|*.dat'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 8
    Top = 120
  end
end
