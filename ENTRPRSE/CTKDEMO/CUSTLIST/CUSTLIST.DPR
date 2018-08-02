program CustList;

uses
  Forms,
  ListF in 'ListF.pas' {frmCustList},
  CustDetF in 'CustDetF.pas' {frmCustDetail},
  THDetF in 'THDetF.pas' {frmTHDetail},
  TLDetF in 'TLDetF.pas' {frmLineDetail},
  SelCust in 'SelCust.pas' {frmCustSelect},
  StkSelct in '..\StkList\Stkselct.pas' {frmStkSelect},
  NoteLstF in '..\Notes\NoteLstF.pas' {frmNotesList},
  THMatchF in 'THMatchF.pas' {frmMatchingList},
  acDiscF in 'acDiscF.pas' {frmAccountDiscounts},
  QtyBrkF in 'QtyBrkF.pas' {frmQtyBreak},
  DiscDetF in 'DISCDETF.PAS' {frmAcDiscDetlF};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise COM Toolkit Demo ';
  Application.CreateForm(TfrmCustList, frmCustList);
  Application.CreateForm(TfrmAcDiscDetlF, frmAcDiscDetlF);
  Application.Run;
end.
