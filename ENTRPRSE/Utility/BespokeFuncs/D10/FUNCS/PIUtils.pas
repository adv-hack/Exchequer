unit PIUtils;

interface
uses
  StdCtrls, CTKUtil;

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  procedure SelectVATCode(cmbVATRate : TComboBox; sVATCode : string);


implementation

procedure SelectVATCode(cmbVATRate : TComboBox; sVATCode : string);
var
  iPos : integer;
begin
  For iPos := 0 to cmbVATRate.Items.Count -1 do
  begin
    if TVATInfo(cmbVATRate.Items.Objects[iPos]).cCode = sVATCode
    then cmbVATRate.ItemIndex := iPos;
  end;{for}
end;

end.
 