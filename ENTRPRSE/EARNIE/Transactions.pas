unit Transactions;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation
        //generic loop through the transactions accordin to given key and then performing
        //task according to routine passed into the procedure

        Procedure FetchTransactions(


 {loop through all the matching transaction header records}
        status :=  GetTransRecord(B_GetGEq,false,tranRec,tranLinesRec,Keyf,TransactionNoKey); {Get first transaction record matching key}

        While ((Status=true) and (TranRec.TransDocHed=TSH) and (TranRec.OurRef>=FrTSH) and (TranRec.OurRef<=ToTSH)) do
        begin
          With TranRec do {invoice record}
          begin
            TmpStr:=OurRef;
            {* Check for Week/Month No if entered *}
            if CheckWeek(discDays,WkMthNo) and GetEmployee(EmpCode,EmployeeRec) then
            begin
              If (length(EmployeeRec.PayNo + EmployeeRec.EmpName) > 0) and GetPayRollCode(TranRec.EmpCode,tranLinesRec[1].StockCode,earnieYN,payrollcode) then
              begin
                ExportRec := TExportRec.create;
                ExportRec.PayrollNo := EmployeeRec.PayNo;
                ExportRec.Rate := PayRollCode;
                ExportRec.NoHour := GetTotalHours(tranRec,TranLinesRec);
                ExportList.Add(ExportRec);
              end;
            end;
          end; {with EInv do ..}
          { Get next Header record }
          Status:= GetTransRecord(B_GetNext,false,tranRec,tranLinesRec,Keyf,TransactionNoKey);
        end; {while status=0 of EInv..}



end.
