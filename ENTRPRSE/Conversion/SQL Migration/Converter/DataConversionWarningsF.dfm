inherited frmDataConversionWarnings: TfrmDataConversionWarnings
  Left = 418
  Top = 91
  Width = 813
  Height = 514
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Data Conversion Warnings'
  OldCreateOrder = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 797
  end
  inherited lblBanner: TLabel
    Width = 306
    Caption = 'Data Conversion Warnings'
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 49
    Width = 760
    Height = 16
    AutoSize = False
    Caption = 
      'The list below contains the warnings raised during the conversio' +
      'n of the Pervasive.SQL Edition data to the MS SQL Edition databa' +
      'se.  Please review the'
    WordWrap = True
  end
  object Label13: TLabel [3]
    Left = 8
    Top = 64
    Width = 761
    Height = 16
    AutoSize = False
    Caption = 
      'warnings in conjunction with the Exchequer Technical Support Tea' +
      'm in order to ascertain whether it is safe to continue the data ' +
      'migration.'
    WordWrap = True
  end
  object Label14: TLabel [4]
    Left = 8
    Top = 82
    Width = 598
    Height = 16
    AutoSize = False
    Caption = 
      'Click the Continue button below to continue the data migration, ' +
      'or the Abort button to abort the data migration.'
    WordWrap = True
  end
  object btnOK: TButton [5]
    Left = 298
    Top = 450
    Width = 80
    Height = 21
    Caption = 'Continue'
    ModalResult = 1
    TabOrder = 1
  end
  object scrlWarnings: TScrollBox [6]
    Left = 8
    Top = 103
    Width = 782
    Height = 340
    BorderStyle = bsNone
    TabOrder = 0
  end
  object btnCancel: TButton [7]
    Left = 394
    Top = 450
    Width = 80
    Height = 21
    Caption = 'Abort'
    ModalResult = 2
    TabOrder = 2
  end
end
