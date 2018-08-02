object dmSettingsSQL: TdmSettingsSQL
  OldCreateOrder = False
  Left = 412
  Top = 313
  Height = 258
  Width = 527
  object ADOConnection_Common: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 24
  end
  object ADOConnection_Company: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 240
    Top = 24
  end
  object qGetCompanyCode: TADOQuery
    Connection = ADOConnection_Common
    Parameters = <
      item
        Name = 'DIR'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'SELECT CAST(SUBSTRING(Companycode1, 2, 6) AS VARCHAR(6)) as Comp' +
        'anyCode'
      'FROM Common.Company'
      
        'WHERE (RecPFix = '#39'C'#39') AND UPPER(RTRIM(CAST(SUBSTRING(Company_cod' +
        'e3, 2, CAST(SUBSTRING(Company_code3, 1, 1) AS INTEGER)) AS VARCH' +
        'AR(255)))) = :DIR')
    Left = 56
    Top = 80
  end
  object qCompanyQuery: TADOQuery
    Connection = ADOConnection_Company
    Parameters = <>
    Left = 240
    Top = 80
  end
  object qCompanyQuery2: TADOQuery
    Connection = ADOConnection_Company
    Parameters = <>
    Left = 240
    Top = 128
  end
  object qCommonQuery: TADOQuery
    Connection = ADOConnection_Common
    Parameters = <>
    Left = 56
    Top = 136
  end
end
