object dmDbf: TdmDbf
  OldCreateOrder = False
  Left = 192
  Top = 107
  Height = 150
  Width = 215
  object dsTable: THalcyonDataSet
    About = 'Halcyon Version 6.94 (14 Dec 2001)'
    AutoFlush = False
    Exclusive = False
    LargeIntegerAs = asInteger
    LockProtocol = Default
    TranslateASCII = False
    UseDeleted = False
    UserID = 0
    Left = 48
    Top = 64
  end
  object dsCreate: TCreateHalcyonDataSet
    AutoOverwrite = True
    DBFTable = dsTable
    DBFType = DBaseIII
    Left = 48
    Top = 8
  end
end
