unit Odbcposf;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    tabshRecord: TTabSheet;
    tabshCode: TTabSheet;
    memRecStructure: TMemo;
    edtStructName: TEdit;
    Label1: TLabel;
    btnProcess: TButton;
    memCode: TMemo;
    TabSheet1: TTabSheet;
    memOutput: TMemo;
    btnTestCustRec: TButton;
    btnTestInvRec: TButton;
    btnTestIDetail: TButton;
    btnTestStockRec: TButton;
    btnTestNominalRec: TButton;
    procedure btnProcessClick(Sender: TObject);
    procedure btnTestCustRecClick(Sender: TObject);
    procedure btnTestInvRecClick(Sender: TObject);
    procedure btnTestIDetailClick(Sender: TObject);
    procedure btnTestStockRecClick(Sender: TObject);
    procedure btnTestNominalRecClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure ODBCRecPos;

implementation

{$R *.DFM}

Uses GlobVar, VarConst;

Procedure ODBCRecPos;
var
  Form1: TForm1;
Begin { ODBCRecPos }
  Form1 := TForm1.Create(Application.MainForm);
  Try
    Form1.ShowModal;
  Finally
    Form1.Free;
  End;
End; { ODBCRecPos }


procedure TForm1.btnProcessClick(Sender: TObject);
Var
  TmpStr : String;
  I, J   : SmallInt;
begin
  edtStructName.Text := Trim(edtStructName.Text);

  If (memRecStructure.Lines.Count > 0) And (edtStructName.Text <> '') Then Begin
    With memCode.Lines Do Begin
      Add ('Procedure Test' + edtStructName.Text + ';');
      Add ('Var');
      Add ('  TheRec : ' + edtStructName.Text + ';');
      Add ('Begin { Test' + edtStructName.Text + ' }');
      Add ('  With memOutPut.Lines Do Begin');

      I := 0;
      While (I < memRecStructure.Lines.Count) Do Begin
        TmpStr := memRecStructure.Lines[I];

        { Trim blanks }
        TmpStr := Trim(TmpStr);
        If (TmpStr <> '') Then Begin
          { get rid of leading comments }
          If (TmpStr[1] = '{') Then Begin
            J := Pos('}', TmpStr);
            If (J > 0) Then Begin
              System.Delete (TmpStr, 1, J);
            End { If (J > 0) }
            Else Begin
              ShowMessage ('No end comment found');
              Break;
            End; { Else }
          End; { If (TmpStr[1] = '{')  }

          { Trim blanks }
          TmpStr := Trim(TmpStr);

          If (TmpStr <> '') Then Begin
            J := Pos(' ', TmpStr);
            If (J > 0) Then
              System.Delete (TmpStr, J, Length(TmpStr));
          End; { If }

          If (TmpStr <> '') Then Begin
            J := Pos(':', TmpStr);
            If (J > 0) Then
              System.Delete (TmpStr, J, Length(TmpStr));

            Add ('    Add (''' + TmpStr + ','' + IntToStr (CalcRecPos (@TheRec, @TheRec.' + TmpStr + ')) + '','' + ' +
                 'IntToStr (SizeOf (TheRec.' + TmpStr + ')));');

            //Add ('CustCode: ' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCode)));

            memRecStructure.Lines[I] := TmpStr;

            Inc(I);
          End { If (TmpStr <> '') }
          Else
            { Delete blank lines }
            memRecStructure.Lines.Delete(I);
        End { If (TmpStr <> '') }
        Else
          { Delete blank lines }
          memRecStructure.Lines.Delete(I);
      End; { While (I < Pred(memRecStructure.Lines.Count) }

      Add ('  End; { With memOutPut }');
      Add ('End; { Test' + edtStructName.Text + ' }');
    End; { With memCode.Lines }
  End { If }
  Else
    ShowMessage ('No Structure found');
end;

Function CalcRecPos (Const RecPtr, FieldPtr : Pointer) : LongInt;
Begin
  Result := LongInt (FieldPtr) - LongInt (RecPtr) + 1;
End;

procedure TForm1.btnTestCustRecClick(Sender: TObject);
Var
  TheRec : CustRec;
Begin { TestCustRec }
  With memOutPut.Lines Do Begin
    Add ('CustCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCode)) + ',' + IntToStr (SizeOf (TheRec.CustCode)));
    Add ('CustSupp,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustSupp)) + ',' + IntToStr (SizeOf (TheRec.CustSupp)));
    Add ('Company,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Company)) + ',' + IntToStr (SizeOf (TheRec.Company)));
    Add ('AreaCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AreaCode)) + ',' + IntToStr (SizeOf (TheRec.AreaCode)));
    Add ('RepCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RepCode)) + ',' + IntToStr (SizeOf (TheRec.RepCode)));
    Add ('RemitCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RemitCode)) + ',' + IntToStr (SizeOf (TheRec.RemitCode)));
    Add ('VATRegNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATRegNo)) + ',' + IntToStr (SizeOf (TheRec.VATRegNo)));
    Add ('Addr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Addr)) + ',' + IntToStr (SizeOf (TheRec.Addr)));
    Add ('DespAddr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DespAddr)) + ',' + IntToStr (SizeOf (TheRec.DespAddr)));
    Add ('DAddr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DAddr)) + ',' + IntToStr (SizeOf (TheRec.DAddr)));
    Add ('Contact,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Contact)) + ',' + IntToStr (SizeOf (TheRec.Contact)));
    Add ('Phone,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Phone)) + ',' + IntToStr (SizeOf (TheRec.Phone)));
    Add ('Fax,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Fax)) + ',' + IntToStr (SizeOf (TheRec.Fax)));
    Add ('RefNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RefNo)) + ',' + IntToStr (SizeOf (TheRec.RefNo)));
    Add ('TradTerm,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TradTerm)) + ',' + IntToStr (SizeOf (TheRec.TradTerm)));
    Add ('STerms,' + IntToStr (CalcRecPos (@TheRec, @TheRec.STerms)) + ',' + IntToStr (SizeOf (TheRec.STerms)));
    Add ('Currency,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Currency)) + ',' + IntToStr (SizeOf (TheRec.Currency)));
    Add ('VATCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATCode)) + ',' + IntToStr (SizeOf (TheRec.VATCode)));
    Add ('PayTerms,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PayTerms)) + ',' + IntToStr (SizeOf (TheRec.PayTerms)));
    Add ('CreditLimit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CreditLimit)) + ',' + IntToStr (SizeOf (TheRec.CreditLimit)));
    Add ('Discount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Discount)) + ',' + IntToStr (SizeOf (TheRec.Discount)));
    Add ('CreditStatus,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CreditStatus)) + ',' + IntToStr (SizeOf (TheRec.CreditStatus)));
    Add ('CustCC,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCC)) + ',' + IntToStr (SizeOf (TheRec.CustCC)));
    Add ('CDiscCh,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CDiscCh)) + ',' + IntToStr (SizeOf (TheRec.CDiscCh)));
    Add ('OrdConsMode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OrdConsMode)) + ',' + IntToStr (SizeOf (TheRec.OrdConsMode)));
    Add ('DefSetDDays,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefSetDDays)) + ',' + IntToStr (SizeOf (TheRec.DefSetDDays)));
    Add ('Spare5,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare5)) + ',' + IntToStr (SizeOf (TheRec.Spare5)));
    Add ('Balance,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Balance)) + ',' + IntToStr (SizeOf (TheRec.Balance)));
    Add ('CustDep,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustDep)) + ',' + IntToStr (SizeOf (TheRec.CustDep)));
    Add ('EECMember,' + IntToStr (CalcRecPos (@TheRec, @TheRec.EECMember)) + ',' + IntToStr (SizeOf (TheRec.EECMember)));
    Add ('NLineCount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NLineCount)) + ',' + IntToStr (SizeOf (TheRec.NLineCount)));
    Add ('IncStat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.IncStat)) + ',' + IntToStr (SizeOf (TheRec.IncStat)));
    Add ('DefNomCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefNomCode)) + ',' + IntToStr (SizeOf (TheRec.DefNomCode)));
    Add ('DefMLocStk,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefMLocStk)) + ',' + IntToStr (SizeOf (TheRec.DefMLocStk)));
    Add ('AccStatus,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AccStatus)) + ',' + IntToStr (SizeOf (TheRec.AccStatus)));
    Add ('PayType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PayType)) + ',' + IntToStr (SizeOf (TheRec.PayType)));
    Add ('BankSort,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BankSort)) + ',' + IntToStr (SizeOf (TheRec.BankSort)));
    Add ('BankAcc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BankAcc)) + ',' + IntToStr (SizeOf (TheRec.BankAcc)));
    Add ('BankRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BankRef)) + ',' + IntToStr (SizeOf (TheRec.BankRef)));
    Add ('AvePay,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AvePay)) + ',' + IntToStr (SizeOf (TheRec.AvePay)));
    Add ('Phone2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Phone2)) + ',' + IntToStr (SizeOf (TheRec.Phone2)));
    Add ('DefCOSNom,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefCOSNom)) + ',' + IntToStr (SizeOf (TheRec.DefCOSNom)));
    Add ('DefCtrlNom,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefCtrlNom)) + ',' + IntToStr (SizeOf (TheRec.DefCtrlNom)));
    Add ('LastUsed,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LastUsed)) + ',' + IntToStr (SizeOf (TheRec.LastUsed)));
    Add ('UserDef1,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UserDef1)) + ',' + IntToStr (SizeOf (TheRec.UserDef1)));
    Add ('UserDef2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UserDef2)) + ',' + IntToStr (SizeOf (TheRec.UserDef2)));
    Add ('SOPInvCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SOPInvCode)) + ',' + IntToStr (SizeOf (TheRec.SOPInvCode)));
    Add ('SOPAutoWOff,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SOPAutoWOff)) + ',' + IntToStr (SizeOf (TheRec.SOPAutoWOff)));
    Add ('FDefPageNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.FDefPageNo)) + ',' + IntToStr (SizeOf (TheRec.FDefPageNo)));
    Add ('BOrdVal,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BOrdVal)) + ',' + IntToStr (SizeOf (TheRec.BOrdVal)));
    Add ('DirDeb,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DirDeb)) + ',' + IntToStr (SizeOf (TheRec.DirDeb)));
    Add ('CCDSDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDSDate)) + ',' + IntToStr (SizeOf (TheRec.CCDSDate)));
    Add ('CCDEDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDEDate)) + ',' + IntToStr (SizeOf (TheRec.CCDEDate)));
    Add ('CCDName,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDName)) + ',' + IntToStr (SizeOf (TheRec.CCDName)));
    Add ('CCDCardNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDCardNo)) + ',' + IntToStr (SizeOf (TheRec.CCDCardNo)));
    Add ('CCDSARef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDSARef)) + ',' + IntToStr (SizeOf (TheRec.CCDSARef)));
    Add ('DefSetDisc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefSetDisc)) + ',' + IntToStr (SizeOf (TheRec.DefSetDisc)));
    Add ('StatDMode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StatDMode)) + ',' + IntToStr (SizeOf (TheRec.StatDMode)));
    Add ('EmailAddr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.EmailAddr)) + ',' + IntToStr (SizeOf (TheRec.EmailAddr)));
    Add ('EmlSndRdr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.EmlSndRdr)) + ',' + IntToStr (SizeOf (TheRec.EmlSndRdr)));
    Add ('ebusPwrd,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ebusPwrd)) + ',' + IntToStr (SizeOf (TheRec.ebusPwrd)));
    Add ('PostCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PostCode)) + ',' + IntToStr (SizeOf (TheRec.PostCode)));
    Add ('CustCode2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCode2)) + ',' + IntToStr (SizeOf (TheRec.CustCode2)));
    Add ('AllowWeb,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AllowWeb)) + ',' + IntToStr (SizeOf (TheRec.AllowWeb)));
    Add ('EmlZipAtc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.EmlZipAtc)) + ',' + IntToStr (SizeOf (TheRec.EmlZipAtc)));
    Add ('UserDef3,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UserDef3)) + ',' + IntToStr (SizeOf (TheRec.UserDef3)));
    Add ('UserDef4,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UserDef4)) + ',' + IntToStr (SizeOf (TheRec.UserDef4)));
    Add ('WebLiveCat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.WebLiveCat)) + ',' + IntToStr (SizeOf (TheRec.WebLiveCat)));
    Add ('WebPrevCat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.WebPrevCat)) + ',' + IntToStr (SizeOf (TheRec.WebPrevCat)));
    Add ('TimeChange,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TimeChange)) + ',' + IntToStr (SizeOf (TheRec.TimeChange)));
    Add ('VATRetRegC,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATRetRegC)) + ',' + IntToStr (SizeOf (TheRec.VATRetRegC)));
    Add ('SSDDelTerms,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDDelTerms)) + ',' + IntToStr (SizeOf (TheRec.SSDDelTerms)));
    Add ('CVATIncFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CVATIncFlg)) + ',' + IntToStr (SizeOf (TheRec.CVATIncFlg)));
    Add ('SSDModeTr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDModeTr)) + ',' + IntToStr (SizeOf (TheRec.SSDModeTr)));
    Add ('PrivateRec,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrivateRec)) + ',' + IntToStr (SizeOf (TheRec.PrivateRec)));
    Add ('LastOpo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LastOpo)) + ',' + IntToStr (SizeOf (TheRec.LastOpo)));
    Add ('InvDMode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.InvDMode)) + ',' + IntToStr (SizeOf (TheRec.InvDMode)));
    Add ('EmlSndHTML,' + IntToStr (CalcRecPos (@TheRec, @TheRec.EmlSndHTML)) + ',' + IntToStr (SizeOf (TheRec.EmlSndHTML)));
    Add ('Spare,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare)) + ',' + IntToStr (SizeOf (TheRec.Spare)));
  End; { With memOutPut }
end;

procedure TForm1.btnTestInvRecClick(Sender: TObject);
Var
  TheRec : InvRec;
Begin
  With memOutPut.Lines Do Begin
    Add ('RunNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RunNo)) + ',' + IntToStr (SizeOf (TheRec.RunNo)));
    Add ('CustCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCode)) + ',' + IntToStr (SizeOf (TheRec.CustCode)));
    Add ('NomAuto,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomAuto)) + ',' + IntToStr (SizeOf (TheRec.NomAuto)));
    Add ('OurRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OurRef)) + ',' + IntToStr (SizeOf (TheRec.OurRef)));
    Add ('FolioNum,' + IntToStr (CalcRecPos (@TheRec, @TheRec.FolioNum)) + ',' + IntToStr (SizeOf (TheRec.FolioNum)));
    Add ('Currency,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Currency)) + ',' + IntToStr (SizeOf (TheRec.Currency)));
    Add ('AcYr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AcYr)) + ',' + IntToStr (SizeOf (TheRec.AcYr)));
    Add ('AcPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AcPr)) + ',' + IntToStr (SizeOf (TheRec.AcPr)));
    Add ('DueDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DueDate)) + ',' + IntToStr (SizeOf (TheRec.DueDate)));
    Add ('VATPostDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATPostDate)) + ',' + IntToStr (SizeOf (TheRec.VATPostDate)));
    Add ('TransDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TransDate)) + ',' + IntToStr (SizeOf (TheRec.TransDate)));
    Add ('CustSupp,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustSupp)) + ',' + IntToStr (SizeOf (TheRec.CustSupp)));
    Add ('CXrate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CXrate)) + ',' + IntToStr (SizeOf (TheRec.CXrate)));
    Add ('YourRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.YourRef)) + ',' + IntToStr (SizeOf (TheRec.YourRef)));
    Add ('BatchLink,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BatchLink)) + ',' + IntToStr (SizeOf (TheRec.BatchLink)));
    Add ('AllocStat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AllocStat)) + ',' + IntToStr (SizeOf (TheRec.AllocStat)));
    Add ('ILineCount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ILineCount)) + ',' + IntToStr (SizeOf (TheRec.ILineCount)));
    Add ('NLineCount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NLineCount)) + ',' + IntToStr (SizeOf (TheRec.NLineCount)));
    Add ('InvDocHed,' + IntToStr (CalcRecPos (@TheRec, @TheRec.InvDocHed)) + ',' + IntToStr (SizeOf (TheRec.InvDocHed)));
    Add ('InvVatAnal,' + IntToStr (CalcRecPos (@TheRec, @TheRec.InvVatAnal)) + ',' + IntToStr (SizeOf (TheRec.InvVatAnal)));
    Add ('InvNetVal,' + IntToStr (CalcRecPos (@TheRec, @TheRec.InvNetVal)) + ',' + IntToStr (SizeOf (TheRec.InvNetVal)));
    Add ('InvVat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.InvVat)) + ',' + IntToStr (SizeOf (TheRec.InvVat)));
    Add ('DiscSetl,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscSetl)) + ',' + IntToStr (SizeOf (TheRec.DiscSetl)));
    Add ('DiscSetAm,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscSetAm)) + ',' + IntToStr (SizeOf (TheRec.DiscSetAm)));
    Add ('DiscAmount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscAmount)) + ',' + IntToStr (SizeOf (TheRec.DiscAmount)));
    Add ('DiscDays,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscDays)) + ',' + IntToStr (SizeOf (TheRec.DiscDays)));
    Add ('DiscTaken,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscTaken)) + ',' + IntToStr (SizeOf (TheRec.DiscTaken)));
    Add ('Settled,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Settled)) + ',' + IntToStr (SizeOf (TheRec.Settled)));
    Add ('AutoInc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AutoInc)) + ',' + IntToStr (SizeOf (TheRec.AutoInc)));
    Add ('UnYr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnYr)) + ',' + IntToStr (SizeOf (TheRec.UnYr)));
    Add ('UnPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnPr)) + ',' + IntToStr (SizeOf (TheRec.UnPr)));
    Add ('TransNat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TransNat)) + ',' + IntToStr (SizeOf (TheRec.TransNat)));
    Add ('TransMode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TransMode)) + ',' + IntToStr (SizeOf (TheRec.TransMode)));
    Add ('RemitNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RemitNo)) + ',' + IntToStr (SizeOf (TheRec.RemitNo)));
    Add ('AutoIncBy,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AutoIncBy)) + ',' + IntToStr (SizeOf (TheRec.AutoIncBy)));
    Add ('HoldFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.HoldFlg)) + ',' + IntToStr (SizeOf (TheRec.HoldFlg)));
    Add ('AuditFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AuditFlg)) + ',' + IntToStr (SizeOf (TheRec.AuditFlg)));
    Add ('TotalWeight,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotalWeight)) + ',' + IntToStr (SizeOf (TheRec.TotalWeight)));
    Add ('DAddr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DAddr)) + ',' + IntToStr (SizeOf (TheRec.DAddr)));
    Add ('Variance,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Variance)) + ',' + IntToStr (SizeOf (TheRec.Variance)));
    Add ('TotalOrdered,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotalOrdered)) + ',' + IntToStr (SizeOf (TheRec.TotalOrdered)));
    Add ('TotalReserved,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotalReserved)) + ',' + IntToStr (SizeOf (TheRec.TotalReserved)));
    Add ('TotalCost,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotalCost)) + ',' + IntToStr (SizeOf (TheRec.TotalCost)));
    Add ('TotalInvoiced,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotalInvoiced)) + ',' + IntToStr (SizeOf (TheRec.TotalInvoiced)));
    Add ('TransDesc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TransDesc)) + ',' + IntToStr (SizeOf (TheRec.TransDesc)));
    Add ('UntilDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UntilDate)) + ',' + IntToStr (SizeOf (TheRec.UntilDate)));
    Add ('Expansion,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Expansion)) + ',' + IntToStr (SizeOf (TheRec.Expansion)));
    Add ('ExternalDoc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ExternalDoc)) + ',' + IntToStr (SizeOf (TheRec.ExternalDoc)));
    Add ('PrintedDoc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrintedDoc)) + ',' + IntToStr (SizeOf (TheRec.PrintedDoc)));
    Add ('ReValueAdj,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ReValueAdj)) + ',' + IntToStr (SizeOf (TheRec.ReValueAdj)));
    Add ('CurrSettled,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CurrSettled)) + ',' + IntToStr (SizeOf (TheRec.CurrSettled)));
    Add ('SettledVAT,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SettledVAT)) + ',' + IntToStr (SizeOf (TheRec.SettledVAT)));
    Add ('VATClaimed,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATClaimed)) + ',' + IntToStr (SizeOf (TheRec.VATClaimed)));
    Add ('BatchNom,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BatchNom)) + ',' + IntToStr (SizeOf (TheRec.BatchNom)));
    Add ('AutoPost,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AutoPost)) + ',' + IntToStr (SizeOf (TheRec.AutoPost)));
    Add ('ManVAT,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ManVAT)) + ',' + IntToStr (SizeOf (TheRec.ManVAT)));
    Add ('DelTerms,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DelTerms)) + ',' + IntToStr (SizeOf (TheRec.DelTerms)));
    Add ('OnPickRun,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OnPickRun)) + ',' + IntToStr (SizeOf (TheRec.OnPickRun)));
    Add ('OpName,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OpName)) + ',' + IntToStr (SizeOf (TheRec.OpName)));
    Add ('NoLabels,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NoLabels)) + ',' + IntToStr (SizeOf (TheRec.NoLabels)));
    Add ('Tagged,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Tagged)) + ',' + IntToStr (SizeOf (TheRec.Tagged)));
    Add ('PickRunNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PickRunNo)) + ',' + IntToStr (SizeOf (TheRec.PickRunNo)));
    Add ('OrdMatch,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OrdMatch)) + ',' + IntToStr (SizeOf (TheRec.OrdMatch)));
    Add ('DeliverRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DeliverRef)) + ',' + IntToStr (SizeOf (TheRec.DeliverRef)));
    Add ('VATCRate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATCRate)) + ',' + IntToStr (SizeOf (TheRec.VATCRate)));
    Add ('OrigRates,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OrigRates)) + ',' + IntToStr (SizeOf (TheRec.OrigRates)));
    Add ('PostDiscAm,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PostDiscAm)) + ',' + IntToStr (SizeOf (TheRec.PostDiscAm)));
    Add ('FRNomCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.FRNomCode)) + ',' + IntToStr (SizeOf (TheRec.FRNomCode)));
    Add ('PDiscTaken,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PDiscTaken)) + ',' + IntToStr (SizeOf (TheRec.PDiscTaken)));
    Add ('CtrlNom,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CtrlNom)) + ',' + IntToStr (SizeOf (TheRec.CtrlNom)));
    Add ('DJobCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DJobCode)) + ',' + IntToStr (SizeOf (TheRec.DJobCode)));
    Add ('DJobAnal,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DJobAnal)) + ',' + IntToStr (SizeOf (TheRec.DJobAnal)));
    Add ('TotOrdOS,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TotOrdOS)) + ',' + IntToStr (SizeOf (TheRec.TotOrdOS)));
    Add ('FRCCDep,' + IntToStr (CalcRecPos (@TheRec, @TheRec.FRCCDep)) + ',' + IntToStr (SizeOf (TheRec.FRCCDep)));
    Add ('DocUser1,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocUser1)) + ',' + IntToStr (SizeOf (TheRec.DocUser1)));
    Add ('DocUser2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocUser2)) + ',' + IntToStr (SizeOf (TheRec.DocUser2)));
    Add ('DocLSplit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocLSplit)) + ',' + IntToStr (SizeOf (TheRec.DocLSplit)));
    Add ('LastLetter,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LastLetter)) + ',' + IntToStr (SizeOf (TheRec.LastLetter)));
    Add ('BatchNow,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BatchNow)) + ',' + IntToStr (SizeOf (TheRec.BatchNow)));
    Add ('BatchThen,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BatchThen)) + ',' + IntToStr (SizeOf (TheRec.BatchThen)));
    Add ('UnTagged,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnTagged)) + ',' + IntToStr (SizeOf (TheRec.UnTagged)));
    Add ('OBaseEquiv,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OBaseEquiv)) + ',' + IntToStr (SizeOf (TheRec.OBaseEquiv)));
    Add ('UseORate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UseORate)) + ',' + IntToStr (SizeOf (TheRec.UseORate)));
    Add ('OldORates,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OldORates)) + ',' + IntToStr (SizeOf (TheRec.OldORates)));
    Add ('SOPKeepRate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SOPKeepRate)) + ',' + IntToStr (SizeOf (TheRec.SOPKeepRate)));
    Add ('DocUser3,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocUser3)) + ',' + IntToStr (SizeOf (TheRec.DocUser3)));
    Add ('DocUser4,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocUser4)) + ',' + IntToStr (SizeOf (TheRec.DocUser4)));
    Add ('SSDProcess,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDProcess)) + ',' + IntToStr (SizeOf (TheRec.SSDProcess)));
    Add ('ExtSource,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ExtSource)) + ',' + IntToStr (SizeOf (TheRec.ExtSource)));
    Add ('CurrTriR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CurrTriR)) + ',' + IntToStr (SizeOf (TheRec.CurrTriR)));
    Add ('VATTriR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATTriR)) + ',' + IntToStr (SizeOf (TheRec.VATTriR)));
    Add ('OrigTriR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OrigTriR)) + ',' + IntToStr (SizeOf (TheRec.OrigTriR)));
    Add ('OldORTriR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OldORTriR)) + ',' + IntToStr (SizeOf (TheRec.OldORTriR)));
    Add ('PostDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PostDate)) + ',' + IntToStr (SizeOf (TheRec.PostDate)));
    Add ('PORPickSOR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PORPickSOR)) + ',' + IntToStr (SizeOf (TheRec.PORPickSOR)));
    Add ('BDiscount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BDiscount)) + ',' + IntToStr (SizeOf (TheRec.BDiscount)));
    Add ('PrePostFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrePostFlg)) + ',' + IntToStr (SizeOf (TheRec.PrePostFlg)));
    Add ('Spare5,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare5)) + ',' + IntToStr (SizeOf (TheRec.Spare5)));
  End; { With memOutPut }
end;

procedure TForm1.btnTestIDetailClick(Sender: TObject);
Var
  TheRec : IDetail;
Begin { TestIDetail }
  With memOutPut.Lines Do Begin
    Add ('FolioRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.FolioRef)) + ',' + IntToStr (SizeOf (TheRec.FolioRef)));
    Add ('LineNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineNo)) + ',' + IntToStr (SizeOf (TheRec.LineNo)));
    Add ('PostedRun,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PostedRun)) + ',' + IntToStr (SizeOf (TheRec.PostedRun)));
    Add ('NomCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomCode)) + ',' + IntToStr (SizeOf (TheRec.NomCode)));
    Add ('NomMode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomMode)) + ',' + IntToStr (SizeOf (TheRec.NomMode)));
    Add ('Currency,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Currency)) + ',' + IntToStr (SizeOf (TheRec.Currency)));
    Add ('PYr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PYr)) + ',' + IntToStr (SizeOf (TheRec.PYr)));
    Add ('PPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PPr)) + ',' + IntToStr (SizeOf (TheRec.PPr)));
    Add ('CCDep,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDep)) + ',' + IntToStr (SizeOf (TheRec.CCDep)));
    Add ('StockCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StockCode)) + ',' + IntToStr (SizeOf (TheRec.StockCode)));
    Add ('ABSLineNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ABSLineNo)) + ',' + IntToStr (SizeOf (TheRec.ABSLineNo)));
    Add ('LineType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineType)) + ',' + IntToStr (SizeOf (TheRec.LineType)));
    Add ('IdDocHed,' + IntToStr (CalcRecPos (@TheRec, @TheRec.IdDocHed)) + ',' + IntToStr (SizeOf (TheRec.IdDocHed)));
    //Add ('Spare3,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare3)) + ',' + IntToStr (SizeOf (TheRec.Spare3)));
    Add ('OldSerQty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OldSerQty)) + ',' + IntToStr (SizeOf (TheRec.OldSerQty)));
    Add ('Qty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Qty)) + ',' + IntToStr (SizeOf (TheRec.Qty)));
    Add ('QtyMul,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyMul)) + ',' + IntToStr (SizeOf (TheRec.QtyMul)));
    Add ('NetValue,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NetValue)) + ',' + IntToStr (SizeOf (TheRec.NetValue)));
    Add ('Discount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Discount)) + ',' + IntToStr (SizeOf (TheRec.Discount)));
    Add ('VATCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATCode)) + ',' + IntToStr (SizeOf (TheRec.VATCode)));
    Add ('VAT,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VAT)) + ',' + IntToStr (SizeOf (TheRec.VAT)));
    Add ('Payment,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Payment)) + ',' + IntToStr (SizeOf (TheRec.Payment)));
    Add ('PreviousBal,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PreviousBal)) + ',' + IntToStr (SizeOf (TheRec.PreviousBal)));
    Add ('Reconcile,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Reconcile)) + ',' + IntToStr (SizeOf (TheRec.Reconcile)));
    Add ('DiscountChr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DiscountChr)) + ',' + IntToStr (SizeOf (TheRec.DiscountChr)));
    Add ('QtyWOFF,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyWOFF)) + ',' + IntToStr (SizeOf (TheRec.QtyWOFF)));
    Add ('QtyDel,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyDel)) + ',' + IntToStr (SizeOf (TheRec.QtyDel)));
    Add ('CostPrice,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CostPrice)) + ',' + IntToStr (SizeOf (TheRec.CostPrice)));
    Add ('CustCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CustCode)) + ',' + IntToStr (SizeOf (TheRec.CustCode)));
    Add ('PDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PDate)) + ',' + IntToStr (SizeOf (TheRec.PDate)));
    Add ('Item,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Item)) + ',' + IntToStr (SizeOf (TheRec.Item)));
    Add ('Desc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Desc)) + ',' + IntToStr (SizeOf (TheRec.Desc)));
    Add ('JobCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.JobCode)) + ',' + IntToStr (SizeOf (TheRec.JobCode)));
    Add ('AnalCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AnalCode)) + ',' + IntToStr (SizeOf (TheRec.AnalCode)));
    Add ('CXrate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CXrate)) + ',' + IntToStr (SizeOf (TheRec.CXrate)));
    Add ('LWeight,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LWeight)) + ',' + IntToStr (SizeOf (TheRec.LWeight)));
    Add ('DeductQty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DeductQty)) + ',' + IntToStr (SizeOf (TheRec.DeductQty)));
    Add ('KitLink,' + IntToStr (CalcRecPos (@TheRec, @TheRec.KitLink)) + ',' + IntToStr (SizeOf (TheRec.KitLink)));
    Add ('SOPLink,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SOPLink)) + ',' + IntToStr (SizeOf (TheRec.SOPLink)));
    Add ('SOPLineNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SOPLineNo)) + ',' + IntToStr (SizeOf (TheRec.SOPLineNo)));
    Add ('MLocStk,' + IntToStr (CalcRecPos (@TheRec, @TheRec.MLocStk)) + ',' + IntToStr (SizeOf (TheRec.MLocStk)));
    Add ('QtyPick,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyPick)) + ',' + IntToStr (SizeOf (TheRec.QtyPick)));
    Add ('QtyPWOff,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyPWOff)) + ',' + IntToStr (SizeOf (TheRec.QtyPWOff)));
    Add ('UsePack,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UsePack)) + ',' + IntToStr (SizeOf (TheRec.UsePack)));
    Add ('SerialQty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SerialQty)) + ',' + IntToStr (SizeOf (TheRec.SerialQty)));
    Add ('COSNomCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.COSNomCode)) + ',' + IntToStr (SizeOf (TheRec.COSNomCode)));
    Add ('DocPRef,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocPRef)) + ',' + IntToStr (SizeOf (TheRec.DocPRef)));
    Add ('DocLTLink,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DocLTLink)) + ',' + IntToStr (SizeOf (TheRec.DocLTLink)));
    Add ('PrxPack,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrxPack)) + ',' + IntToStr (SizeOf (TheRec.PrxPack)));
    Add ('QtyPack,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyPack)) + ',' + IntToStr (SizeOf (TheRec.QtyPack)));
    Add ('ReconDate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ReconDate)) + ',' + IntToStr (SizeOf (TheRec.ReconDate)));
    Add ('ShowCase,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ShowCase)) + ',' + IntToStr (SizeOf (TheRec.ShowCase)));
    Add ('sdbFolio,' + IntToStr (CalcRecPos (@TheRec, @TheRec.sdbFolio)) + ',' + IntToStr (SizeOf (TheRec.sdbFolio)));
    Add ('OBaseEquiv,' + IntToStr (CalcRecPos (@TheRec, @TheRec.OBaseEquiv)) + ',' + IntToStr (SizeOf (TheRec.OBaseEquiv)));
    Add ('UseORate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UseORate)) + ',' + IntToStr (SizeOf (TheRec.UseORate)));
    Add ('LineUser1,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineUser1)) + ',' + IntToStr (SizeOf (TheRec.LineUser1)));
    Add ('LineUser2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineUser2)) + ',' + IntToStr (SizeOf (TheRec.LineUser2)));
    Add ('LineUser3,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineUser3)) + ',' + IntToStr (SizeOf (TheRec.LineUser3)));
    Add ('LineUser4,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LineUser4)) + ',' + IntToStr (SizeOf (TheRec.LineUser4)));
    Add ('SSDUplift,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDUplift)) + ',' + IntToStr (SizeOf (TheRec.SSDUplift)));
    Add ('SSDCountry,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDCountry)) + ',' + IntToStr (SizeOf (TheRec.SSDCountry)));
    Add ('VATIncFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATIncFlg)) + ',' + IntToStr (SizeOf (TheRec.VATIncFlg)));
    Add ('SSDCommod,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDCommod)) + ',' + IntToStr (SizeOf (TheRec.SSDCommod)));
    Add ('SSDSPUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDSPUnit)) + ',' + IntToStr (SizeOf (TheRec.SSDSPUnit)));
    Add ('PriceMulx,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PriceMulx)) + ',' + IntToStr (SizeOf (TheRec.PriceMulx)));
    Add ('B2BLink,' + IntToStr (CalcRecPos (@TheRec, @TheRec.B2BLink)) + ',' + IntToStr (SizeOf (TheRec.B2BLink)));
    Add ('B2BLineNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.B2BLineNo)) + ',' + IntToStr (SizeOf (TheRec.B2BLineNo)));
    Add ('CurrTriR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CurrTriR)) + ',' + IntToStr (SizeOf (TheRec.CurrTriR)));
    Add ('SSDUseLine,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDUseLine)) + ',' + IntToStr (SizeOf (TheRec.SSDUseLine)));
    Add ('Spare2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare2)) + ',' + IntToStr (SizeOf (TheRec.Spare2)));
  End; { With memOutPut }
End; { TestIDetail }

procedure TForm1.btnTestStockRecClick(Sender: TObject);
Var
  TheRec : StockRec;
Begin { TestStockRec }
  With memOutPut.Lines Do Begin
    Add ('StockCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StockCode)) + ',' + IntToStr (SizeOf (TheRec.StockCode)));
    Add ('Desc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Desc)) + ',' + IntToStr (SizeOf (TheRec.Desc)));
    Add ('AltCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AltCode)) + ',' + IntToStr (SizeOf (TheRec.AltCode)));
    Add ('SuppTemp,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SuppTemp)) + ',' + IntToStr (SizeOf (TheRec.SuppTemp)));
    Add ('NomCodeS,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomCodeS)) + ',' + IntToStr (SizeOf (TheRec.NomCodeS)));
    Add ('ROFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ROFlg)) + ',' + IntToStr (SizeOf (TheRec.ROFlg)));
    Add ('MinFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.MinFlg)) + ',' + IntToStr (SizeOf (TheRec.MinFlg)));
    Add ('StockFolio,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StockFolio)) + ',' + IntToStr (SizeOf (TheRec.StockFolio)));
    Add ('StockCat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StockCat)) + ',' + IntToStr (SizeOf (TheRec.StockCat)));
    Add ('StockType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StockType)) + ',' + IntToStr (SizeOf (TheRec.StockType)));
    Add ('UnitK,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnitK)) + ',' + IntToStr (SizeOf (TheRec.UnitK)));
    Add ('UnitS,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnitS)) + ',' + IntToStr (SizeOf (TheRec.UnitS)));
    Add ('UnitP,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnitP)) + ',' + IntToStr (SizeOf (TheRec.UnitP)));
    Add ('PCurrency,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PCurrency)) + ',' + IntToStr (SizeOf (TheRec.PCurrency)));
    Add ('CostPrice,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CostPrice)) + ',' + IntToStr (SizeOf (TheRec.CostPrice)));
    Add ('SaleBands,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SaleBands)) + ',' + IntToStr (SizeOf (TheRec.SaleBands)));
    Add ('SellUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SellUnit)) + ',' + IntToStr (SizeOf (TheRec.SellUnit)));
    Add ('BuyUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BuyUnit)) + ',' + IntToStr (SizeOf (TheRec.BuyUnit)));
    Add ('Spare,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare)) + ',' + IntToStr (SizeOf (TheRec.Spare)));
    Add ('VATCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.VATCode)) + ',' + IntToStr (SizeOf (TheRec.VATCode)));
    Add ('CCDep,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CCDep)) + ',' + IntToStr (SizeOf (TheRec.CCDep)));
    Add ('QtyInStock,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyInStock)) + ',' + IntToStr (SizeOf (TheRec.QtyInStock)));
    Add ('QtyPosted,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyPosted)) + ',' + IntToStr (SizeOf (TheRec.QtyPosted)));
    Add ('QtyAllocated,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyAllocated)) + ',' + IntToStr (SizeOf (TheRec.QtyAllocated)));
    Add ('QtyOnOrder,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyOnOrder)) + ',' + IntToStr (SizeOf (TheRec.QtyOnOrder)));
    Add ('QtyMin,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyMin)) + ',' + IntToStr (SizeOf (TheRec.QtyMin)));
    Add ('QtyMax,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyMax)) + ',' + IntToStr (SizeOf (TheRec.QtyMax)));
    Add ('ROQty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ROQty)) + ',' + IntToStr (SizeOf (TheRec.ROQty)));
    Add ('NLineCount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NLineCount)) + ',' + IntToStr (SizeOf (TheRec.NLineCount)));
    Add ('SubAssyFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SubAssyFlg)) + ',' + IntToStr (SizeOf (TheRec.SubAssyFlg)));
    Add ('ShowasKit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ShowasKit)) + ',' + IntToStr (SizeOf (TheRec.ShowasKit)));
    Add ('BLineCount,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BLineCount)) + ',' + IntToStr (SizeOf (TheRec.BLineCount)));
    Add ('CommodCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CommodCode)) + ',' + IntToStr (SizeOf (TheRec.CommodCode)));
    Add ('SWeight,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SWeight)) + ',' + IntToStr (SizeOf (TheRec.SWeight)));
    Add ('PWeight,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PWeight)) + ',' + IntToStr (SizeOf (TheRec.PWeight)));
    Add ('UnitSupp,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UnitSupp)) + ',' + IntToStr (SizeOf (TheRec.UnitSupp)));
    Add ('SuppSUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SuppSUnit)) + ',' + IntToStr (SizeOf (TheRec.SuppSUnit)));
    Add ('BinLoc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BinLoc)) + ',' + IntToStr (SizeOf (TheRec.BinLoc)));
    Add ('StkFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkFlg)) + ',' + IntToStr (SizeOf (TheRec.StkFlg)));
    Add ('CovPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovPr)) + ',' + IntToStr (SizeOf (TheRec.CovPr)));
    Add ('CovPrUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovPrUnit)) + ',' + IntToStr (SizeOf (TheRec.CovPrUnit)));
    Add ('CovMinPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovMinPr)) + ',' + IntToStr (SizeOf (TheRec.CovMinPr)));
    Add ('CovMinUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovMinUnit)) + ',' + IntToStr (SizeOf (TheRec.CovMinUnit)));
    Add ('Supplier,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Supplier)) + ',' + IntToStr (SizeOf (TheRec.Supplier)));
    Add ('QtyFreeze,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyFreeze)) + ',' + IntToStr (SizeOf (TheRec.QtyFreeze)));
    Add ('CovSold,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovSold)) + ',' + IntToStr (SizeOf (TheRec.CovSold)));
    Add ('UseCover,' + IntToStr (CalcRecPos (@TheRec, @TheRec.UseCover)) + ',' + IntToStr (SizeOf (TheRec.UseCover)));
    Add ('CovMaxPr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovMaxPr)) + ',' + IntToStr (SizeOf (TheRec.CovMaxPr)));
    Add ('CovMaxUnit,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CovMaxUnit)) + ',' + IntToStr (SizeOf (TheRec.CovMaxUnit)));
    Add ('ROCurrency,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ROCurrency)) + ',' + IntToStr (SizeOf (TheRec.ROCurrency)));
    Add ('ROCPrice,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ROCPrice)) + ',' + IntToStr (SizeOf (TheRec.ROCPrice)));
    Add ('RODate,' + IntToStr (CalcRecPos (@TheRec, @TheRec.RODate)) + ',' + IntToStr (SizeOf (TheRec.RODate)));
    Add ('QtyTake,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyTake)) + ',' + IntToStr (SizeOf (TheRec.QtyTake)));
    Add ('StkValType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkValType)) + ',' + IntToStr (SizeOf (TheRec.StkValType)));
    Add ('HasSerNo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.HasSerNo)) + ',' + IntToStr (SizeOf (TheRec.HasSerNo)));
    Add ('QtyPicked,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyPicked)) + ',' + IntToStr (SizeOf (TheRec.QtyPicked)));
    Add ('LastUsed,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LastUsed)) + ',' + IntToStr (SizeOf (TheRec.LastUsed)));
    Add ('CalcPack,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CalcPack)) + ',' + IntToStr (SizeOf (TheRec.CalcPack)));
    Add ('JAnalCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.JAnalCode)) + ',' + IntToStr (SizeOf (TheRec.JAnalCode)));
    Add ('StkUser1,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkUser1)) + ',' + IntToStr (SizeOf (TheRec.StkUser1)));
    Add ('StkUser2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkUser2)) + ',' + IntToStr (SizeOf (TheRec.StkUser2)));
    Add ('BarCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.BarCode)) + ',' + IntToStr (SizeOf (TheRec.BarCode)));
    Add ('ROCCDep,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ROCCDep)) + ',' + IntToStr (SizeOf (TheRec.ROCCDep)));
    Add ('DefMLoc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefMLoc)) + ',' + IntToStr (SizeOf (TheRec.DefMLoc)));
    Add ('PricePack,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PricePack)) + ',' + IntToStr (SizeOf (TheRec.PricePack)));
    Add ('DPackQty,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DPackQty)) + ',' + IntToStr (SizeOf (TheRec.DPackQty)));
    Add ('KitPrice,' + IntToStr (CalcRecPos (@TheRec, @TheRec.KitPrice)) + ',' + IntToStr (SizeOf (TheRec.KitPrice)));
    Add ('KitOnPurch,' + IntToStr (CalcRecPos (@TheRec, @TheRec.KitOnPurch)) + ',' + IntToStr (SizeOf (TheRec.KitOnPurch)));
    Add ('StkLinkLT,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkLinkLT)) + ',' + IntToStr (SizeOf (TheRec.StkLinkLT)));
    Add ('QtyReturn,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyReturn)) + ',' + IntToStr (SizeOf (TheRec.QtyReturn)));
    Add ('QtyAllocWOR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyAllocWOR)) + ',' + IntToStr (SizeOf (TheRec.QtyAllocWOR)));
    Add ('QtyIssueWOR,' + IntToStr (CalcRecPos (@TheRec, @TheRec.QtyIssueWOR)) + ',' + IntToStr (SizeOf (TheRec.QtyIssueWOR)));
    Add ('WebInclude,' + IntToStr (CalcRecPos (@TheRec, @TheRec.WebInclude)) + ',' + IntToStr (SizeOf (TheRec.WebInclude)));
    Add ('WebLiveCat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.WebLiveCat)) + ',' + IntToStr (SizeOf (TheRec.WebLiveCat)));
    Add ('WebPrevCat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.WebPrevCat)) + ',' + IntToStr (SizeOf (TheRec.WebPrevCat)));
    Add ('StkUser3,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkUser3)) + ',' + IntToStr (SizeOf (TheRec.StkUser3)));
    Add ('StkUser4,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkUser4)) + ',' + IntToStr (SizeOf (TheRec.StkUser4)));
    Add ('SerNoWAvg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SerNoWAvg)) + ',' + IntToStr (SizeOf (TheRec.SerNoWAvg)));
    Add ('StkSizeCol,' + IntToStr (CalcRecPos (@TheRec, @TheRec.StkSizeCol)) + ',' + IntToStr (SizeOf (TheRec.StkSizeCol)));
    Add ('SSDDUplift,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDDUplift)) + ',' + IntToStr (SizeOf (TheRec.SSDDUplift)));
    Add ('SSDCountry,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDCountry)) + ',' + IntToStr (SizeOf (TheRec.SSDCountry)));
    Add ('TimeChange,' + IntToStr (CalcRecPos (@TheRec, @TheRec.TimeChange)) + ',' + IntToStr (SizeOf (TheRec.TimeChange)));
    Add ('SVATIncFlg,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SVATIncFlg)) + ',' + IntToStr (SizeOf (TheRec.SVATIncFlg)));
    Add ('SSDAUpLift,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SSDAUpLift)) + ',' + IntToStr (SizeOf (TheRec.SSDAUpLift)));
    Add ('PrivateRec,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrivateRec)) + ',' + IntToStr (SizeOf (TheRec.PrivateRec)));
    Add ('LastOpo,' + IntToStr (CalcRecPos (@TheRec, @TheRec.LastOpo)) + ',' + IntToStr (SizeOf (TheRec.LastOpo)));
    Add ('ImageFile,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ImageFile)) + ',' + IntToStr (SizeOf (TheRec.ImageFile)));
    Add ('Spare2,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare2)) + ',' + IntToStr (SizeOf (TheRec.Spare2)));
  End; { With memOutPut }
End; { TestStockRec }

procedure TForm1.btnTestNominalRecClick(Sender: TObject);
Var
  TheRec : NominalRec;
Begin { TestNominalRec }
  With memOutPut.Lines Do Begin
    Add ('NomCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomCode)) + ',' + IntToStr (SizeOf (TheRec.NomCode)));
    Add ('Desc,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Desc)) + ',' + IntToStr (SizeOf (TheRec.Desc)));
    Add ('Cat,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Cat)) + ',' + IntToStr (SizeOf (TheRec.Cat)));
    Add ('NomType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomType)) + ',' + IntToStr (SizeOf (TheRec.NomType)));
    Add ('NomPage,' + IntToStr (CalcRecPos (@TheRec, @TheRec.NomPage)) + ',' + IntToStr (SizeOf (TheRec.NomPage)));
    Add ('SubType,' + IntToStr (CalcRecPos (@TheRec, @TheRec.SubType)) + ',' + IntToStr (SizeOf (TheRec.SubType)));
    Add ('Total,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Total)) + ',' + IntToStr (SizeOf (TheRec.Total)));
    Add ('CarryF,' + IntToStr (CalcRecPos (@TheRec, @TheRec.CarryF)) + ',' + IntToStr (SizeOf (TheRec.CarryF)));
    Add ('ReValue,' + IntToStr (CalcRecPos (@TheRec, @TheRec.ReValue)) + ',' + IntToStr (SizeOf (TheRec.ReValue)));
    Add ('AltCode,' + IntToStr (CalcRecPos (@TheRec, @TheRec.AltCode)) + ',' + IntToStr (SizeOf (TheRec.AltCode)));
    Add ('PrivateRec,' + IntToStr (CalcRecPos (@TheRec, @TheRec.PrivateRec)) + ',' + IntToStr (SizeOf (TheRec.PrivateRec)));
    Add ('DefCurr,' + IntToStr (CalcRecPos (@TheRec, @TheRec.DefCurr)) + ',' + IntToStr (SizeOf (TheRec.DefCurr)));
    Add ('Spare,' + IntToStr (CalcRecPos (@TheRec, @TheRec.Spare)) + ',' + IntToStr (SizeOf (TheRec.Spare)));
  End; { With memOutPut }
End; { TestNominalRec }



end.
