unit uToolkit;

interface
uses
  Enterprise01_TLB;

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;

implementation

end.
