unit MCMIntF;

interface

Uses
  Classes, Dialogs, Forms, StdCtrls, SysUtils, Windows, FileUtil;

Type
  // Record type added into lists to store info
  TCompanyInfo = Class
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;{with}

procedure FillCompanyList(cmbComp : TComboBox);

implementation

type
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;

  TCompanies = Array[1..99] of TCompanyType;
  PCompanies = ^TCompanies;

Function EX_GETCOMPANY(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall; external 'EntComp.dll';

{-------------------------------------------}

procedure FillCompanyList(cmbComp : TComboBox);
var
  CompDir : array[0..255] of char;
  CompArray : PCompanies;
  iArrayItems, iPos : longint;
  iStatus : smallint;
  CompanyInfo : TCompanyInfo;
begin
  new(CompArray);
//  StrPCopy(CompDir, ExtractFilePath(Application.ExeName));
  StrPCopy(CompDir, GetEnterpriseDirectory);
  iArrayItems := SizeOf(CompArray^);
  iStatus := EX_GETCOMPANY(CompDir, CompArray, iArrayItems);
  if iStatus = 0 then
    begin
      for iPos := 1 to iArrayItems do begin
        with CompArray^[iPos] do begin

          CompanyInfo := TCompanyInfo.Create;
          with CompanyInfo do begin
            Name := CompName;
            Code := CompCode;
            Path := CompPath;
          end;{with}
          cmbComp.Items.AddObject(CompName, CompanyInfo);
        end;{with}
      end;{for}

      if cmbComp.Items.Count <> 0 then begin
        cmbComp.ItemIndex := 0;
        cmbComp.Enabled := cmbComp.Items.Count > 1;
      end;{if}
    end
  else ShowMessage('Error ' + IntToStr(iStatus) + ' occured whilst reading the company list');
  dispose(CompArray);
end;

end.
