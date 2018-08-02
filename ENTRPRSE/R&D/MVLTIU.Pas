{ ============== TMVMList Methods =============== }


Function TMVMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password do
  Begin
    DumStr:=RecPFix+SubType;
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TMVMList.SetFilter  :  Str255;

Var
  LChk  :  LongInt;

Begin

  Result:=FullNomKey(0);
end;


Function TMVMList.Ok2Del :  Boolean;

Begin
  Result:=BOn;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TMVMList.OutLine(Col  :  Byte)  :  Str255;

Var
  FoundLong
         :  LongInt;
  DocHed :  DocTypes;
  GenStr :  Str255;

Begin

  With Password do
  Begin
    Case DisplayMode of
      1  :
             With MoveNomRec do
             Case Col of

              0  :  Begin
                      Result:=Form_BInt(MoveCode,0);
                    end;
              1  :  If GetNom(Self,Form_Int(MoveCode,0), FoundLong,-1) then
                      Result:=Nom.Desc;

              2  :  Begin
                      Result:=Form_BInt(MoveTo,0);

                    end;
              3  :  If GetNom(Self,Form_Int(MoveTo,0), FoundLong,-1) then
                      Result:=Nom.Desc;

              4  :  Result:=MoveType;

              else
                    Result:='';
            end; {Case..}

      2  :  With MoveStkRec do
            Case Col of

              0  :  Begin
                      Result:=MoveCode;
                    end;
              1  :  Begin
                      Result:=NewStkCode;

                    end;

              2  :  Begin
                      Result:=MFromCode;

                    end;

              3  :  Begin
                      Result:=MToCode;

                    end;

              else
                    Result:='';
            end; {Case..}

     end; {Case..}
   end; {With..}
end;




