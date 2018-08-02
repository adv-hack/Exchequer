Unit CuStkA4U;


Interface

Uses GlobVar,
     VarRec2U,
     VarConst;


  Type
     CKQtyBrkType=  Record
                      QBRange  :  Str40;
                      QBPrice  :  Double;
                    end;

     CKAnalType  =  Record
                     CCode  :  Str10;
                     SCode  :  Str20;

                     SFolio :  LongInt;

                     LocFilt:  Str5;
                     RCCDep :  CCDepType;

                     RCr,
                     RTxCr,
                     ScanMode,
                     DispMode,
                     ScaleMode,
                     OrdMode,
                     QBCount
                            :  Byte;

                     OwnPNo,
                     IsaC,
                     RCCDFilt,
                     QBrkMode,
                     QBrkShown,
                     IsTeleS,
                     IsCCDep
                            :  Boolean;

                     Dvals  :  Array[1..4] of Double;

                     QBAnal :  Array[0..20] of CKQtyBrkType;

                    end;


  Function Full_CuStkKey(cc  :  Str10;
                         sc  :  Str20)  :  Str30;


  Function Full_CuStkIKey(cc       :  Str10;
                          sc       :  Str20)  :  Str30;

  Function Full_CuStkLKey(cc       :  Str10;
                          LineNo   :  LongInt)  :  Str30;


  Function Full_CuStkKey2(cc  :  Str10;
                          sc  :  Str20)  :  Str30;

  Function Full_CuStkHKey1(cc  :  Str10;
                           sc  :  LongInt)  :  Str30;

  Function Full_CuStkHKey2(cc    :  Str10;
                           sc    :  LongInt;
                           RCCDep:  Str10)  :  Str30;

  Function Full_CuStkHKey3(cc    :  Str10;
                           sc    :  LongInt;
                           RCCDep:  Str10)  :  Str30;

  Function Calc_CStkKeyHist(CKAnal     :  CKAnalType)  :  Str255;

  Function Calc_CStkNHKeyHist(CKAnal     :  TNHCtrlRec)  :  Str255;

  Function CK_Title(CKAnal     :  CKAnalType)  :  Str255;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   BTKeys1U,
   BtrvU2;



   { ======= Return Full Stk Anal Key ======== }

    // CJS - 03/02/2010 - There is a copy of Full_CuStkKey in the
    // SQLRedirectorU.pas file in BtrvSQL.DLL.

    Function Full_CuStkKey(cc       :  Str10;
                           sc       :  Str20)  :  Str30;


    Begin

      Full_CuStkKey:=FullCustCode(cc)+ConstStr(#0,4)+FullStockCode(sc);

    end;



    Function Full_CuStkIKey(cc       :  Str10;
                            sc       :  Str20)  :  Str30;

    Begin

      Full_CuStkIKey:=Full_CuStkKey(cc,sc)+ConstStr(#0,4);

    end;


    // CJS - 03/02/2010 - There are copies of Full_CuStkLKey and Full_CuStkKey2 in
    // the SQLRedirectorU.pas file in BtrvSQL.DLL.

    Function Full_CuStkLKey(cc       :  Str10;
                            LineNo   :  LongInt)  :  Str30;
    Begin

      Full_CuStkLKey:=FullCustCode(cc)+ConstStr(#0,4)+Dec2Hex(LineNo);

    end;



    Function Full_CuStkKey2(cc  :  Str10;
                            sc  :  Str20)  :  Str30;


    Begin

      Full_CuStkKey2:=FullStockCode(sc)+ConstStr(#0,4)+FullCustCode(cc);

    end;


    Function Full_CuStkHKey1(cc  :  Str10;
                             sc  :  LongInt)  :  Str30;


    Begin

      Full_CuStkHKey1:=FullCustCode(cc)+ConstStr(#0,4)+FullNomKey(sc)+HelpKStop;

    end;


    Function Full_CuStkHKey2(cc    :  Str10;
                             sc    :  LongInt;
                             RCCDep:  Str10)  :  Str30;


    Begin

      Full_CuStkHKey2:=#1+Full_CuStkHKey1(cc,sc)+RCCDep;

    end;


    Function Full_CuStkHKey3(cc    :  Str10;
                             sc    :  LongInt;
                             RCCDep:  Str10)  :  Str30;


    Begin

      Full_CuStkHKey3:=#2+Full_CuStkHKey1(cc,sc)+RCCDep;

    end;


    { ===== Function to Return History Key based on filters ===== }

    Function Calc_CStkKeyHist(CKAnal     :  CKAnalType)  :  Str255;

    Var
      Loop    :  Boolean;

    Begin
      Result:='';

      With CKAnal do
      Begin
        {$IFDEF SOP}
          If Not EmptyKey(LocFilt,MLocKeyLen) and (Syss.UseMLoc) then
          Begin
            Result:=Full_CuStkHKey3(CCode,SFolio,LocFilt);
          end
          else
        {$ENDIF}
          If (Not EmptyKeyS(RCCDep[BOff],CCKeyLen,BOff)) or (Not EmptyKeyS(RCCDep[BOn],ccKeyLen,BOff)) then
          Begin
            Loop:=BOff;
            Repeat
              If (Not EmptyKeyS(RCCDep[Loop],ccKeyLen,BOff)) then
              Begin
                Result:=Full_CuStkHKey2(CCode,SFolio,PostCCKey(Loop,RCCDep[Loop]));
                Break;
              end;

            Loop:=Not Loop;

            until (Not Loop);
          end
          else
          Begin
            Result:=Full_CuStkHKey1(CCode,SFolio);
          end;
      end;

      Calc_CStkKeyHist:=Result;
    end;


    { ===== Function to Return History Key based on filters ===== }

    Function Calc_CStkNHKeyHist(CKAnal     :  TNHCtrlRec)  :  Str255;

    Var
      Loop    :  Boolean;

    Begin
      Result:='';

      With CKAnal do
      Begin
        {$IFDEF SOP}
          If Not EmptyKey(NHLocCode,MLocKeyLen) and (Syss.UseMLoc) then
          Begin
            Result:=Full_CuStkHKey3(NHCuCode,NHNomCode,NHLocCode);
          end
          else
        {$ENDIF}
          If (Not EmptyKeyS(NHCDCode,CCKeyLen,BOff)) then
          Begin
            Loop:=BOff;
            Result:=Full_CuStkHKey2(NHCuCode,NHNomCode,PostCCKey(NHCCMode,NHCDCode));
          end
          else
          Begin
            Result:=Full_CuStkHKey1(NHCuCode,NHNomCode);
          end;
      end;

      Calc_CStkNHKeyHist:=Result;
    end;


    { ===== Function to Return Current View ===== }

    Function CK_Title(CKAnal     :  CKAnalType)  :  Str255;

    Const
      CCDepTit  :  Array[BOff..BOn] of Str20 = ('Dp','Cc');


    Var
      CKFilt   :  Str20;
      CKTitle  :  Str255;
      TmpBo    :  Boolean;


    Begin
      CKTitle:=''; CKFilt:=' ------- ';

      With CKAnal do
      Begin


        If (OrdMode In [0,2,3]) then
        Begin

          Case OrdMode of
            0  :  CKTitle:='Invoiced';
            2  :  CKTitle:='Ordered ';
            3  :  CKTitle:='Chosen  ';
          end; {case..}

          If (Not IsTeleS) then
          Begin
            CKTitle:='Scale: '+CKTitle+' ';


            Case ScaleMode of

              1  :  CKTitle:=CKTitle+'Today -';
              2  :  CKTitle:=CKTitle+'This Wk';
              3  :  CKTitle:=CKTitle+'2 Weeks';
              4  :  CKTitle:=CKTitle+'Y-T-D -';
              else  CKTitle:=CKTitle+'This Pr';
            end; {Case..}
          end;
        end
        else
          CKTitle:='Outstanding Orders -';

        {$IFDEF SOP}
          If (Not EmptyKey(LocFilt,MLocKeyLen)) then
          Begin
            CKFilt:='.Loc : '+LocFilt;

          end;
        {$ENDIF}

        If (Syss.UseCCDep) and (Syss.PostCCNom) then
        For TmpBo :=BOff to BOn do
        Begin

          If (Not EmptyKeyS(RCCDep[TmpBo],ccKeyLen,BOff)) then
          Begin
            CKFilt:='.'+CCDepTit[TmpBo]+' : '+RCCDep[TmpBo];

          end;
        end;


      end;

      CK_Title:=CKTitle+CKFilt;
    end;

    

Begin

end.