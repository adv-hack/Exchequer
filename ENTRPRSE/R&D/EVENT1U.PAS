Unit Event1U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 12/01/98                      }
{                                                              }
{            Misc Customisation event support Unit             }
{                                                              }
{               Copyright (C) 1998 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  GlobVar,
  ETMiscU,

  {$IFDEF CU}
    CustIntU,
  {$ENDIF}

  VarConst,
  VarRec2U,
  EXWrap1U;


Const
  DoFocusFix = True;



{$IFDEF CU}
  Procedure GenHooks(WID,EID  :  Integer;
                     Var ExLocal  :  TdExLocal;
                     Const DoFocusFix : Boolean = False);

  Function TextExitHook(WID,EID  :  Integer;
                        SCode    :  Str255;
                        Var ExLocal  :  TdExLocal;
                        Const DoFocusFix : Boolean = False)  :  Str255;

  Function ValidExitHook(WID,EID  :  Integer;
                     Var ExLocal  :  TdExLocal;
                     Const DoFocusFix : Boolean = False)  :  Boolean;

  Function ValueExitHook(WID,EID  :  Integer;
                         SValue   :  Double;
                   Var  ExLocal   :  TdExLocal;
                   Const DoFocusFix : Boolean = False)  :  Double;

  Function IntExitHook(WID,EID  :  Integer;
                       SValue   :  LongInt;
                       Var ExLocal  :  TdExLocal)  :  LongInt;

  Function EnableCustBtns(WID,EID  :  Integer)  :  Boolean;

  Function ExecuteCustBtn(WID,EID  :  Integer;
                      Var ExLocal  :  TdExLocal)  :  Boolean;

  Procedure GenTSHooks(WID,EID  :  Integer;
                   Var ExLocal  :  TdExLocal;
                   Var TeleSHed :  MLocRec);

  //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Extend transaction security hooks from daybooks to rest of the system
  //                                      where applicable.
  Function ValidSecurityHook(WID,EID  :  Integer;
                     Var ExLocal  :  TdExLocal)  :  Boolean;


{$ENDIF}


Procedure Date2Pr(CDate  :  LongDate;
              Var PPr,PYr:  Byte;
                  ExLPtr :  Pointer);

Function Pr2Date(PPr,PYr  :  Byte;
                 ExLPtr   :  Pointer)  :  LongDate;

Function ConvInpPr(Const IDate    :  String;
                   Const Date2Pr  :  Boolean;
                         ExLPtr   :  Pointer)  :  String;

{$IFDEF CU}
  Function Get_LineDiscDecs(DefDecs  :  LongInt)  :  LongInt;


{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     SysUtils,
     ETStrU,
     BtrvU2,
     ETDateU,
     BTKeys1U,
     ComnUnit,
     ComnU2,
     CurrncyU,
     {$IFDEF CU}
       CustABSU,
       CustWinU,
       MiscU,
       OJob,
       OTeleHdr,
       OTeleLin,
       Windows,
       Messages,
     {$ENDIF}


     {BTSupU1,}
     SysU2;



{ ================== Implement Inv Hooks =============== }

{$IFDEF CU}
  Procedure GenHooks(WID,EID  :  Integer;
                     Var ExLocal  :  TdExLocal;
                     Const DoFocusFix : Boolean = False);

  Var
    n            :  Byte;
    vl           :  VATType;
    CustomEvent  :  TCustomEvent;

    //PR: 22/11/2017 ABSEXCH-19451
    RestrictedEdit : Boolean;

  Begin
    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          Case ((WId * 1000) + EId) Of

            4000026  :  Begin
                          {$IFDEF CU}
                            CalcVATExLocal(ExLocal,BOff,nil);
                          {$ENDIF}

                        end;
          end; {Case..}


          BuildEvent(ExLocal);

          Case ((WId * 1000) + EId) Of
            5000075,
            5000076  :  Begin {Due to poss data clash, preload Jobbudget object}
                          TJob(EntSysObj.Job).oJobBudget.Assign(wiJobRec, EId, ExLocal.LJobCtrl^);
                        end;


          end; {Case..}

          Execute(DoFocusFix);

          If ValidStatus and DataChanged then
          Begin
            Case ((WId * 1000) + EId) Of

              1000002  :  Begin {* Return from Exit Cust/Supp, and set ud + type and area only at this stage *}

                            If (IsACust(ExLocal.LCust.CustSupp)) then
                            Begin
                              ExLocal.LCust.UserDef1:=EntSysObj.Customer.acUserDef1;
                              ExLocal.LCust.UserDef2:=EntSysObj.Customer.acUserDef2;
                              ExLocal.LCust.UserDef3:=EntSysObj.Customer.acUserDef3;
                              ExLocal.LCust.UserDef4:=EntSysObj.Customer.acUserDef4;
                              //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                              ExLocal.LCust.UserDef5:=EntSysObj.Customer3.acUserDef5;
                              ExLocal.LCust.UserDef6:=EntSysObj.Customer3.acUserDef6;
                              ExLocal.LCust.UserDef7:=EntSysObj.Customer3.acUserDef7;
                              ExLocal.LCust.UserDef8:=EntSysObj.Customer3.acUserDef8;
                              ExLocal.LCust.UserDef9:=EntSysObj.Customer3.acUserDef9;
                              ExLocal.LCust.UserDef10:=EntSysObj.Customer3.acUserDef10;

                              ExLocal.LCust.AreaCode:=EntSysObj.Customer.acArea;
                              ExLocal.LCust.RepCode:=EntSysObj.Customer.acAccType;
                            end
                            else
                            Begin
                              ExLocal.LCust.UserDef1:=EntSysObj.Supplier.acUserDef1;
                              ExLocal.LCust.UserDef2:=EntSysObj.Supplier.acUserDef2;
                              ExLocal.LCust.UserDef3:=EntSysObj.Supplier.acUserDef3;
                              ExLocal.LCust.UserDef4:=EntSysObj.Supplier.acUserDef4;
                              //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                              ExLocal.LCust.UserDef5:=EntSysObj.Supplier3.acUserDef5;
                              ExLocal.LCust.UserDef6:=EntSysObj.Supplier3.acUserDef6;
                              ExLocal.LCust.UserDef7:=EntSysObj.Supplier3.acUserDef7;
                              ExLocal.LCust.UserDef8:=EntSysObj.Supplier3.acUserDef8;
                              ExLocal.LCust.UserDef9:=EntSysObj.Supplier3.acUserDef9;
                              ExLocal.LCust.UserDef10:=EntSysObj.Supplier3.acUserDef10;

                              ExLocal.LCust.AreaCode:=EntSysObj.Supplier.acArea;
                              ExLocal.LCust.RepCode:=EntSysObj.Supplier.acAccType;
                            end;
                          end;

              1000105,
              1000106  :  Begin {* Return from Exit Cust/Supp, and set all fields back from a post code link *}

                            If (IsACust(ExLocal.LCust.CustSupp)) then
                            Begin
                              ExLocal.LCust.UserDef1:=EntSysObj.Customer.acUserDef1;
                              ExLocal.LCust.UserDef2:=EntSysObj.Customer.acUserDef2;
                              ExLocal.LCust.UserDef3:=EntSysObj.Customer.acUserDef3;
                              ExLocal.LCust.UserDef4:=EntSysObj.Customer.acUserDef4;
                              //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                              ExLocal.LCust.UserDef5:=EntSysObj.Customer3.acUserDef5;
                              ExLocal.LCust.UserDef6:=EntSysObj.Customer3.acUserDef6;
                              ExLocal.LCust.UserDef7:=EntSysObj.Customer3.acUserDef7;
                              ExLocal.LCust.UserDef8:=EntSysObj.Customer3.acUserDef8;
                              ExLocal.LCust.UserDef9:=EntSysObj.Customer3.acUserDef9;
                              ExLocal.LCust.UserDef10:=EntSysObj.Customer3.acUserDef10;

                              ExLocal.LCust.AreaCode:=EntSysObj.Customer.acArea;
                              ExLocal.LCust.RepCode:=EntSysObj.Customer.acAccType;
                              ExLocal.LCust.Company:=EntSysObj.Customer.acCompany;
                              ExLocal.LCust.PostCode:=EntSysObj.Customer.acPostCode;

                              // MH 01/10/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                              ExLocal.LCust.acDeliveryPostCode:=TAbsCustomer5(EntSysObj.Customer).acDeliveryPostCode;

                              For n:=Low(ExLocal.LCust.Addr) to High(ExLocal.LCust.Addr) do
                              Begin
                                ExLocal.LCust.Addr[n]:=EntSysObj.Customer.acAddress[n];
                                ExLocal.LCust.DAddr[n]:=EntSysObj.Customer.acDelAddress[n];
                              end;

                              ExLocal.LCust.Phone:=EntSysObj.Customer.acPhone;
                              ExLocal.LCust.Phone2:=EntSysObj.Customer.acPhone2;
                              ExLocal.LCust.Fax:=EntSysObj.Customer.acFax;
                              ExLocal.LCust.emailAddr:=EntSysObj.Customer.acemailAddr;

                              // MH 19/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                              ExLocal.LCust.acCountry:=TAbsCustomer8(EntSysObj.Customer).acCountry;
                              ExLocal.LCust.acDeliveryCountry:=TAbsCustomer8(EntSysObj.Customer).acDeliveryCountry;
                            end
                            else
                            Begin
                              ExLocal.LCust.UserDef1:=EntSysObj.Supplier.acUserDef1;
                              ExLocal.LCust.UserDef2:=EntSysObj.Supplier.acUserDef2;
                              ExLocal.LCust.UserDef3:=EntSysObj.Supplier.acUserDef3;
                              ExLocal.LCust.UserDef4:=EntSysObj.Supplier.acUserDef4;
                              //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                              ExLocal.LCust.UserDef5:=EntSysObj.Supplier3.acUserDef5;
                              ExLocal.LCust.UserDef6:=EntSysObj.Supplier3.acUserDef6;
                              ExLocal.LCust.UserDef7:=EntSysObj.Supplier3.acUserDef7;
                              ExLocal.LCust.UserDef8:=EntSysObj.Supplier3.acUserDef8;
                              ExLocal.LCust.UserDef9:=EntSysObj.Supplier3.acUserDef9;
                              ExLocal.LCust.UserDef10:=EntSysObj.Supplier3.acUserDef10;

                              ExLocal.LCust.AreaCode:=EntSysObj.Supplier.acArea;
                              ExLocal.LCust.RepCode:=EntSysObj.Supplier.acAccType;

                              ExLocal.LCust.Company:=EntSysObj.Supplier.acCompany;
                              ExLocal.LCust.PostCode:=EntSysObj.Supplier.acPostCode;

                              // MH 01/10/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                              ExLocal.LCust.acDeliveryPostCode:=TAbsCustomer5(EntSysObj.Supplier).acDeliveryPostCode;

                              For n:=Low(ExLocal.LCust.Addr) to High(ExLocal.LCust.Addr) do
                              Begin
                                ExLocal.LCust.Addr[n]:=EntSysObj.Supplier.acAddress[n];
                                ExLocal.LCust.DAddr[n]:=EntSysObj.Supplier.acDelAddress[n];
                              end;

                              ExLocal.LCust.Phone:=EntSysObj.Supplier.acPhone;
                              ExLocal.LCust.Phone2:=EntSysObj.Supplier.acPhone2;
                              ExLocal.LCust.Fax:=EntSysObj.Supplier.acFax;
                              ExLocal.LCust.emailAddr:=EntSysObj.Supplier.acemailAddr;

                              // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                              ExLocal.LCust.acCountry:=TAbsCustomer8(EntSysObj.Supplier).acCountry;
                              ExLocal.LCust.acDeliveryCountry:=TAbsCustomer8(EntSysObj.Supplier).acDeliveryCountry;
                            end;
                          end;
              1000109  :
                          If DataChanged then
                          Begin
                            With ExLocal,LCust do
                              For n:=Low(DAddr) to High(DAddr) do
                                DAddr[n]:=EntSysObj.Customer.acDelAddress[n];

                            // MH 01/10/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                            ExLocal.LCust.acDeliveryPostCode:=TAbsCustomer5(EntSysObj.Customer).acDeliveryPostCode;

                            // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                            ExLocal.LCust.acDeliveryCountry := TAbsCustomer8(EntSysObj.Customer).acDeliveryCountry;
                          end;

              2000001  :  Begin { Before Save Transaction }
                            ExLocal.LInv.DocUser1:=EntSysObj.Transaction.thUser1;
                            ExLocal.LInv.DocUser2:=EntSysObj.Transaction.thUser2;
                            ExLocal.LInv.DocUser3:=EntSysObj.Transaction.thUser3;
                            ExLocal.LInv.DocUser4:=EntSysObj.Transaction.thUser4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LInv.DocUser5:=EntSysObj.Transaction3.thUser5;
                            ExLocal.LInv.DocUser6:=EntSysObj.Transaction3.thUser6;
                            ExLocal.LInv.DocUser7:=EntSysObj.Transaction3.thUser7;
                            ExLocal.LInv.DocUser8:=EntSysObj.Transaction3.thUser8;
                            ExLocal.LInv.DocUser9:=EntSysObj.Transaction3.thUser9;
                            ExLocal.LInv.DocUser10:=EntSysObj.Transaction3.thUser10;
                            // MH 16/01/2017 2017-R1 ABSEXCH-18100: Unable to update thUser11/12
                            ExLocal.LInv.thUserField11:=TAbsInvoice13(EntSysObj.Transaction3).thUser11;
                            ExLocal.LInv.thUserField12:=TAbsInvoice13(EntSysObj.Transaction3).thUser12;

                            //PR: 22/11/2017 ABSEXCH-19451 Moved from below to keep fields that
                            //can be edited on posted trans in one block
                            ExLocal.LInv.YourRef:=TAbsInvoice5(EntSysObj.Transaction).thYourRef20;
                            ExLocal.LInv.TransDesc:=EntSysObj.Transaction.thTransDesc;


                            // MH 22/09/2014 v7.1 Order Payments fields
                            //PR: 22/11/2017 ABSEXCH-19451 Check doc status and
                            if not RestrictedEditOnly(ExLocal.LInv) then
                            begin
                              ExLocal.LInv.thCreditCardType := TAbsInvoice11(EntSysObj.Transaction3).thCreditCardType;
                              ExLocal.LInv.thCreditCardNumber := TAbsInvoice11(EntSysObj.Transaction3).thCreditCardNumber;
                              ExLocal.LInv.thCreditCardExpiry := TAbsInvoice11(EntSysObj.Transaction3).thCreditCardExpiry;
                              ExLocal.LInv.thCreditCardAuthorisationNo := TAbsInvoice11(EntSysObj.Transaction3).thCreditCardAuthorisationNo;
                              ExLocal.LInv.thCreditCardReferenceNo := TAbsInvoice11(EntSysObj.Transaction3).thCreditCardReferenceNo;
                              ExLocal.LInv.thCustomData1 := TAbsInvoice11(EntSysObj.Transaction3).thCustomData1;

                              ExLocal.LInv.NoLabels:=EntSysObj.Transaction.thNoLabels;
                              // MH 24/01/08: Modified as it was incorrectly truncating the increased YourRef added for v6.00
                              //ExLocal.LInv.YourRef:=EntSysObj.Transaction.thYourRef;
                              {ExLocal.LInv.YourRef:=TAbsInvoice5(EntSysObj.Transaction).thYourRef20;
                              ExLocal.LInv.TransDesc:=EntSysObj.Transaction.thTransDesc;}
                              ExLocal.LInv.HoldFlg:=EntSysObj.Transaction.thHoldFlg;
                              ExLocal.LInv.Tagged:=EntSysObj.Transaction.thTagNo;

                              ExLocal.LInv.AcYr:=EntSysObj.Transaction.thYear;
                              ExLocal.LInv.AcPr:=EntSysObj.Transaction.thPeriod;
                              ExLocal.LInv.DueDate:=EntSysObj.Transaction.thDueDate;

                              ExLocal.LInv.ILineCount:=EntSysObj.Transaction.thLines.thLineCount;

                              If (EntSysObj.NeedDocRefs) and (EntSysObj.SetDocRefs) then {Doc refs have been set by hook}
                              Begin
                                ExLocal.LSetRefs:=True;
                                Exlocal.LInv.OurRef:=EntSysObj.Transaction.thOurRef;
                                ExLocal.LInv.FolioNum:=EntSysObj.Transaction.thFolioNum;
                              end;

                              If (EntSysObj.ResetDocTotals) then {We have adjusted the totals, so refresh}
                              With ExLocal.LInv do
                              Begin
                                InvNetVal:=EntSysObj.Transaction.thInvNetVal;
                                InvVAT:=EntSysObj.Transaction.thInvVAT;
                                DiscSetl:=EntSysObj.Transaction.thDiscSetl;
                                DiscSetAm:=EntSysObj.Transaction.thDiscSetAm;
                                DiscAmount:=EntSysObj.Transaction.thDiscAmount;
                                TotalWeight:=EntSysObj.Transaction.thTotalWeight;
                                TotalCost:=EntSysObj.Transaction.thTotalCost;


                                For vl:=Low(InvVATAnal) to High(InvVATAnal) do
                                Begin
                                  InvVATAnal[vl]:=EntSysObj.Transaction.thInvVATAnal[cuVATIndex(vl)];
                                end;

                                TotalInvoiced:=EntSysObj.Transaction.thTotalInvoiced;
                                TotalReserved:=EntSysObj.Transaction.thTotalReserved;
                                TotalOrdered:=EntSysObj.Transaction.thTotalOrdered;
                              end;

                              // MH 27/03/2015 v7.0.14: Added new fields for Prompt Payment Discounts
                              ExLocal.LInv.thPPDPercentage  := TAbsInvoice10(EntSysObj.Transaction).thPPDPercentage;
                              ExLocal.LInv.thPPDDays        := TAbsInvoice10(EntSysObj.Transaction).thPPDDays;
                              ExLocal.LInv.thPPDGoodsValue  := TAbsInvoice10(EntSysObj.Transaction).thPPDGoodsValue;
                              ExLocal.LInv.thPPDVATValue    := TAbsInvoice10(EntSysObj.Transaction).thPPDVATValue;
                              Case TAbsInvoice10(EntSysObj.Transaction).thPPDTakenStatus Of
                                CustABSU.ptPPDNotTaken          : ExLocal.LInv.thPPDTaken := VarConst.ptPPDNotTaken;
                                CustABSU.ptPPDTaken             : ExLocal.LInv.thPPDTaken := VarConst.ptPPDTaken;
                                CustABSU.ptPPDTakenOutsideTerms : ExLocal.LInv.thPPDTaken := VarConst.ptPPDTakenOutsideTerms;
                              End; // Case TAbsInvoice10(EntSysObj.Transaction).thPPDTakenStatus

                            end; // if not GDPRFieldsOnly
                          End;

              2000009  :
                          If DataChanged then
                          Begin
                            With ExLocal,LInv do
                            Begin
                              For n:=Low(DAddr) to High(DAddr) do
                                DAddr[n]:=EntSysObj.Transaction.thDelAddr[n];

                              // MH 01/10/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                              thDeliveryPostCode:=TAbsInvoice9(EntSysObj.Transaction).thDeliveryPostCode;

                              // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                              thDeliveryCountry:=TAbsInvoice11(EntSysObj.Transaction).thDeliveryCountry;

                              DJobCode:=EntSysObj.Transaction.thJobCode;
                              
                            end;
                          end;

              2000008,
              2000080  :  Begin { Override Period relative to Date function }
                            ExLocal.LInv.AcYr:=EntSysObj.Transaction.thYear;
                            ExLocal.LInv.AcPr:=EntSysObj.Transaction.thPeriod;
                          End;

              2000081  :  Begin { Override Period relative to Date function }
                            ExLocal.LInv.TransDate:=EntSysObj.Transaction.thTransDate;
                          End;

              2000190  :
                          If DataChanged then
                          Begin
                            With ExLocal,LInv do
                            Begin
                              DJobAnal:=EntSysObj.Transaction.thJobAnal;
                            end;
                          end;

              3000002  :  Begin { Before Save Stock }
                            ExLocal.LStock.BarCode:=EntSysObj.Stock.stBarCode;

                            { HM 04/09/00: Added as EL had forgotten to }
                            ExLocal.LStock.StkUser1 := EntSysObj.Stock.stStkUser1;
                            ExLocal.LStock.StkUser2 := EntSysObj.Stock.stStkUser2;
                            ExLocal.LStock.StkUser3 := EntSysObj.Stock.stStkUser3;
                            ExLocal.LStock.StkUser4 := EntSysObj.Stock.stStkUser4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LStock.StkUser5 := EntSysObj.Stock4.stStkUser5;
                            ExLocal.LStock.StkUser6 := EntSysObj.Stock4.stStkUser6;
                            ExLocal.LStock.StkUser7 := EntSysObj.Stock4.stStkUser7;
                            ExLocal.LStock.StkUser8 := EntSysObj.Stock4.stStkUser8;
                            ExLocal.LStock.StkUser9 := EntSysObj.Stock4.stStkUser9;
                            ExLocal.LStock.StkUser10 := EntSysObj.Stock4.stStkUser10;

                            ExLocal.LStock.SWeight:=EntSysObj.Stock.stSaleUnWeight;
                            ExLocal.LStock.PWeight:=EntSysObj.Stock.stPurchUnWeight;
                            
                          End;

              4000090,
              4000091,
              4000092,
              4000003  :  Begin
                            ExLocal.LId.LineUser1:=EntSysObj.TransAction.thLines.thCurrentLine.tlUserDef1;
                            ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                            ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                            ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LId.LineUser5:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef5;
                            ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                            ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                            ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                            ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef9;
                            ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;
                          end;
              4000006  :  Begin
                            ExLocal.LId.VATCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlVATCode;
                          end;

              4000010  :  Begin
                            //PR: 23/11/2017 ABSEXCH-19451
                            if not RestrictedEditOnly(ExLocal.LInv) then
                            begin
                              ExLocal.LId.NetValue:=EntSysObj.TransAction.thLines.thCurrentLine.tlNetValue;

                              ExLocal.LId.JobCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlJobCode;
                              ExLocal.LId.AnalCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlJobAnal;
                              ExLocal.LId.LWeight:=EntSysObj.TransAction.thLines.thCurrentLine.tlUnitWeight;

                              { EL v5.61 extended to include discounts }
                              ExLocal.LId.Discount:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscount;
                              ExLocal.LId.DiscountChr:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscflag;
                            end;

                            { HM 23/06/00: Added User Fields as we had published their availability but not coded them }
                            ExLocal.LId.LineUser1:=EntSysObj.TransAction.thLines.thCurrentLine.tlUserDef1;
                            ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                            ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                            ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LId.LineUser5:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef5;
                            ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                            ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                            ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                            ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef9;
                            ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;
                          end;
              4000004,
              4000009,
              4000011,
              4000012  :  Begin
                            ExLocal.LId.NetValue:=EntSysObj.TransAction.thLines.thCurrentLine.tlNetValue;


                            ExLocal.LId.IncNetValue:=TABSInvLine2(EntSysObj.TransAction.thLines.thCurrentLine).tlVATInclValue;

                            { EL v5.61 EID 9 extended to include discounts }
                            If (EID In [9,11]) then {Set cost price on exit of stock code}
                            Begin
                              If (EId=11) then
                                ExLocal.LId.CostPrice:=EntSysObj.TransAction.thLines.thCurrentLine.tlCost;

                              ExLocal.LId.Discount:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscount;
                              ExLocal.LId.DiscountChr:=EntSysObj.TransAction.thLines.thCurrentLine.tlDiscflag;

                            end;

                            If (EId=11) then
                              ExLocal.LId.VATCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlVATCode;

                            If (EID=12) then {Set UDfields on exit of stock code}
                            Begin
                              ExLocal.LId.LineUser1:=EntSysObj.TransAction.thLines.thCurrentLine.tlUserDef1;
                              ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                              ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                              ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                              //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                              ExLocal.LId.LineUser5:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef5;
                              ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                              ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                              ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                              ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef9;
                              ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;
                            end;
                          end;

              4000055  :  ExLocal.LId.Costprice:=EntSysObj.TransAction.thLines.thCurrentLine.tlCost;

              5000075  :  Begin

                            ExLocal.LJobCtrl^.JobBudg.UnitPrice:=EntSysObj.JobCosting.Job2.jrBudget.jbUnitPrice;
                            ExLocal.LJobCtrl^.JobBudg.Recharge:=EntSysObj.JobCosting.Job2.jrBudget.jbRecharge;
                            ExLocal.LJobCtrl^.JobBudg.OverCost:=EntSysObj.JobCosting.Job2.jrBudget.jbCostOverhead;

                            ExLocal.LJobCtrl^.JobBudg.BOQty:=EntSysObj.JobCosting.Job2.jrBudget.jbOriginalQty;
                            ExLocal.LJobCtrl^.JobBudg.BRQty:=EntSysObj.JobCosting.Job2.jrBudget.jbRevisedQty;
                            ExLocal.LJobCtrl^.JobBudg.BOValue:=EntSysObj.JobCosting.Job2.jrBudget.jbOriginalValue;
                            ExLocal.LJobCtrl^.JobBudg.BRValue:=EntSysObj.JobCosting.Job2.jrBudget.jbRevisedValue;
                            {ExLocal.LJobCtrl^.JobBudg.CurrBudg:=Customisation.Busget currency}
                          end;

            end;
          end;
        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;


Function TextExitHook(WID,EID  :  Integer;
                        SCode    :  Str255;
                      Var ExLocal  :  TdExLocal;
                      Const DoFocusFix : Boolean = False)  :  Str255;

  Var
    CustomEvent  :  TCustomEvent;
    n            :  Byte;

  Begin
    Result:=SCode;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        
        If (GotEvent) then
        Begin
          Case ((WId * 1000) + EId) Of

            1000100  :  Begin
                          ExLocal.LCust.CustCode:=SCode;

                        end;

            1000107,
            1000108  :  Begin
                          ExLocal.LCust.CustCode:=SCode;

                        end;

          
            2000006  :  Begin
                          ExLocal.LInv.CustCode:=SCode;

                        end;

            2000050  :  Begin
                          ExLocal.LInv.DueDate:=SCode;

                        end;


            2000065  :  Begin
                          ExLocal.LInv.YourRef:=SCode;

                        end;

            2000066  :  Begin
                          ExLocal.LInv.TransDesc:=SCode;

                        end;


            3000001  :  ExLocal.LStock.StockCode:=SCode;

            4000015,
            4000053,
            4000054,
            4000058  :  ExLocal.LId.StockCode:=SCode;

            4000059  :  ExLocal.LId.MLocStk:=SCode;

            4000016,
            4000017  :  ExLocal.LId.CCDep[EId=16]:=SCode;

            5000077  :  ExLocal.LJobRec^.JobCode:=SCode;
            5000078  :  ExLocal.LJobRec^.JobMan:=SCode;
          end;

          BuildEvent(ExLocal);

          Case ((WId * 1000) + EId) Of
            1000111,
            3000111  :  Begin {Renumber routines, set new code via StrResult}
                          EntSysObj.StrResult:=SCode;

                        end;
          end;

          Execute(DoFocusFix);

          If ValidStatus then
          Begin
            Case ((WId * 1000) + EId) Of

            1000100,
            4000053,
            4000054  :  {If DataChanged then}
                          Result:=EntSysObj.StrResult; {Customer.acCode;}

            1000107,
            1000108  :  If DataChanged then
                        Begin
                          If (IsACust(ExLocal.LCust.CustSupp)) then
                            Result:=FullCustCode(EntSysObj.Customer.AcCode)
                          else
                            Result:=FullCustCode(EntSysObj.Supplier.AcCode);
                        end;

            2000006  :  If DataChanged then
                        Begin
                          Result:=EntSysObj.Transaction.thAcCode;
                        end
                        { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
                        { CJS 2013-09-02 - ABSEXCH-14275 - Fix for Transaction Account Code exit hook }
                        else if Trim(EntSysObj.StrResult) <> '' then
                          Result := EntSysObj.StrResult;

            2000050  :  If DataChanged then
                        Begin
                          Result:=EntSysObj.Transaction.thDueDate;

                        end;

            2000065  :  If DataChanged then
                        Begin
                          // MH 24/01/08: Modified as it was incorrectly truncating the increased YourRef added for v6.00
                          //Result:=EntSysObj.Transaction.thYourRef;
                          Result:=TAbsInvoice5(EntSysObj.Transaction).thYourRef20;

                        end;
            2000066  :  If DataChanged then
                        Begin
                          Result:=EntSysObj.Transaction.thTransDesc;

                        end;


            3000001  :  If DataChanged then
                          Result:=EntSysObj.Stock.stCode;

            3100001  :  Result:=IntToStr(EntSysObj.IntResult);


            4000015,
            4000058
                     :  Begin
                          Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlStockCode;

                          If (EId=15) then
                            ExLocal.LId.Qty:=EntSysObj.TransAction.thLines.thCurrentLine.tlQty;
                        end;

            4000016  :  Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlCostCentre;
            4000017  :  Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlDepartment;

            4000059
                     :  Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlLocation;

            5000077  :  Result:=EntSysObj.Job.JrJobCode;
            5000078  :  Result:=EntSysObj.Job.JrJobMan;

            90001005
                     :  Result:=EntSysObj.StrResult; {Current VAT Period;}


            end; {Case..}
          end;


        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;
  end;{Func..}


  Function ValidExitHook(WID,EID  :  Integer;
                         Var ExLocal  :  TdExLocal;
                         Const DoFocusFix : Boolean = False)  :  Boolean;

  Var
    CustomEvent  :  TCustomEvent;

  Begin
    Result:=BOn;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          BuildEvent(ExLocal);

          //PR: 13/10/2010 Check result below and only apply focus fix if result is true and
          // we're not going back to the original control (ABSEXCH-10284)
          Execute(FALSE);

          {$B-}

          If ValidStatus and (((WId = 2000) and (EId In [2,3,51,82..88,100,104,189])) or DataChanged or ((WId = 4000) and (EId In [14,18..24,51,80]))
          or ((WId = 1000) and (EId In [1,5,60,61,103..104])) or ((WId = 3000) and (EId In [40])) or ((WId = 5000) and (EId In [40,50,110])) or ((WId=3100) and (EId In [2..4])))
          then

          Begin
          {$B+}

            Case ((WId * 1000) + EId) Of

              // HM 18/03/03: Split out customer/supplier hook points as causing exception for suppliers
//              1000001,
//              1000005  :  Begin
//                            Result:=(EntSysObj.Customer.acArea<>'');
//                          end;
              1000001   :  Result:=(EntSysObj.Customer.acArea<>'');
              1000005   :  Result:=(EntSysObj.Supplier.acArea<>'');


              1000060,
              1000061,
              1000103..1000104,
              2000002,
              2000003,
              2000051,
              2000082..2000088,
              2000100,
              2000104,
              2000189,
              3000040,
              4000014,
              4000018..4000024,
              4000080,
              5000040,
              5000050,
              5000110
                       :  Result:=(EntSysObj.BoResult);

              3100002  :  If DataChanged then
                          Begin
                            ExLocal.LMLocCtrl^.brBinRec.brBinCode1:=EntSysObj.Bin.brBinCode;
                            Result:=BOn;
                          end;
              3100003,
              3100004  :  If DataChanged then
                          Begin
                            ExLocal.LMiscRecs^.SerialRec.InBinCode:=EntSysObj.BatchSerial2.bsBinCode;
                            Result:=BOn;
                          end;


              4000051  :  Begin
                            Result:=(EntSysObj.BoResult);

                            If (Result) then
                              ExLocal.LId.NomCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlGLCode;
                          end;

            end; {Case..}
          end
          else
            Case ((WId * 1000) + EId) Of  {* Enforce validstaus via result *}
              3100002  :  Result:=ValidStatus;
            end; {case..}
          //PR: 13/10/2010 Only apply focus fix if result is true and we're not going back to the original control (ABSEXCH-10284)
          if Result then
            PostMessage(GetFocus, WM_SETFOCUS, 0, 0);
        end
        else
          Begin
            Case ((WId * 1000) + EId) Of  {* Auto set print labels by lines off *}
              4000014,
              4000051  :  Result:=BOff;
              else        Result:=BOn;
            end; {Case..}
          end;

      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;


  Function ValueExitHook(WID,EID  :  Integer;
                         SValue   :  Double;
                   Var  ExLocal   :  TdExLocal;
                   Const DoFocusFix : Boolean = False)  :  Double;

  Var
    CustomEvent  :  TCustomEvent;

  Begin
    Result:=SValue;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          Case ((WId * 1000) + EId) Of

            4000001,
            4000025,
            4000087  :  ExLocal.LId.Qty:=SValue;

          end;

          BuildEvent(ExLocal);

          Execute(DoFocusFix);

          If ValidStatus and DataChanged then
          Begin
            Case ((WId * 1000) + EId) Of

              2000007  :  Result:=EntSysObj.TransAction.thDailyRate;

              3000051  :  Result:=EntSysObj.Stock.stReOrderQty;

              4000001  :  Begin
                            Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlQty;

                            ExLocal.LId.LineUser1:=EntSysObj.TransAction.thLines.thCurrentLine.tlUserDef1;
                            ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                            ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                            ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LId.LineUser4:= TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef5;
                            ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                            ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                            ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                            ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef9;
                            ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;

                          end;

              4000002  :  Begin
                            Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlQtyMul;

                            ExLocal.LId.LineUser1:=EntSysObj.TransAction.thLines.thCurrentLine.tlUserDef1;
                            ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                            ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                            ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                            //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                            ExLocal.LId.LineUser5:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef5;
                            ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                            ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                            ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                            ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.TransAction3.thLines.thCurrentLine).tlUserDef9;
                            ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;
                          end;

              4000025,
              4000087  :  Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlQty;




              4000013  :  Result:=EntSysObj.TransAction.thLines.thCurrentLine.tlQtyPickedWO;

              4000056
                       :  Begin
                            {Allow override of qty picked}
                            Result:=EntSysObj.Transaction.thLines.thCurrentLine.tlQtyPicked;
                          end;

            end; {Case..}
          end;


        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;                                                                                                       


  Function IntExitHook(WID,EID  :  Integer;
                       SValue   :  LongInt;
                   Var ExLocal  :  TdExLocal)  :  LongInt;

  Var
    CustomEvent  :  TCustomEvent;

  Begin
    Result:=SValue;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          
          BuildEvent(ExLocal);

          Case ((WId * 1000) + EId) Of
            2050102  :  EntSysObj.IntResult:=SValue;

          end; {Case..}

          Execute;

          If ValidStatus or ((WId = 1000) and (EId In [31..36,41..46, 211..216, 231..236]))//GS 24/10/2011 ABSEXCH-11706: Added cust/sup new UDFs v6.9
                         // PR: 14/10/2011 Added Trans Header new UDFs v6.9
                         // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                         or ((WId = 2000) and (EId In [61..64,67,180,181, 211..218]))
                         or ((WId = 3000) and (EId In [31..34, 211..216]))                     //GS 24/10/2011 ABSEXCH-11706: Added stock new UDFs v6.9
                         or ((WId = 4000) and (EId In [31..34,52,56, 211..216]))  //PR: 14/10/2011 Added Trans Header new UDFs v6.9
                         or ((WId = 5000) and (EId In [31..34,38,39,41..44,78, 211..216])) then //GS 25/10/2011 ABSEXCH-11706: Added job rec new UDFs v6.9
          Begin
            Case ((WId * 1000) + EId) Of

              1000031..1000036,
              //GS 24/10/2011 ABSEXCH-11706: added case statements for the new UDEfs
              1000041..1000046,
              1000211..1000216,
              1000231..1000236
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              1000031
                                  :    LCust.UserDef1:=EntSysObj.Customer.acUserDef1;
                              1000032
                                  :    LCust.UserDef2:=EntSysObj.Customer.acUserDef2;
                              1000033
                                  :    LCust.UserDef3:=EntSysObj.Customer.acUserDef3;
                              1000034
                                  :    LCust.UserDef4:=EntSysObj.Customer.acUserDef4;
                              1000035
                                  :    LCust.RepCode:=EntSysObj.Customer.acAccType;
                              1000036
                                  :    LCust.AreaCode:=EntSysObj.Customer.acArea;
                              1000041
                                  :    LCust.UserDef1:=EntSysObj.Supplier.acUserDef1;
                              1000042
                                  :    LCust.UserDef2:=EntSysObj.Supplier.acUserDef2;
                              1000043
                                  :    LCust.UserDef3:=EntSysObj.Supplier.acUserDef3;
                              1000044
                                  :    LCust.UserDef4:=EntSysObj.Supplier.acUserDef4;
                              1000045
                                  :    LCust.RepCode:=EntSysObj.Supplier.acAccType;
                              1000046
                                  :    LCust.AreaCode:=EntSysObj.Supplier.acArea;
                              //GS 24/10/2011 ABSEXCH-11706: case statements for the new UDEFs
                              1000211
                                  :    LCust.UserDef5:=TABSCustomer3(EntSysObj.Customer).acUserDef5;
                              1000212
                                  :    LCust.UserDef6:=TABSCustomer3(EntSysObj.Customer).acUserDef6;
                              1000213
                                  :    LCust.UserDef7:=TABSCustomer3(EntSysObj.Customer).acUserDef7;
                              1000214
                                  :    LCust.UserDef8:=TABSCustomer3(EntSysObj.Customer).acUserDef8;
                              1000215
                                  :    LCust.UserDef9:=TABSCustomer3(EntSysObj.Customer).acUserDef9;
                              1000216
                                  :    LCust.UserDef10:=TABSCustomer3(EntSysObj.Customer).acUserDef10;
                              1000231
                                  :    LCust.UserDef5:=TABSCustomer3(EntSysObj.Supplier).acUserDef5;
                              1000232
                                  :    LCust.UserDef6:=TABSCustomer3(EntSysObj.Supplier).acUserDef6;
                              1000233
                                  :    LCust.UserDef7:=TABSCustomer3(EntSysObj.Supplier).acUserDef7;
                              1000234
                                  :    LCust.UserDef8:=TABSCustomer3(EntSysObj.Supplier).acUserDef8;
                              1000235
                                  :    LCust.UserDef9:=TABSCustomer3(EntSysObj.Supplier).acUserDef9;
                              1000236
                                  :    LCust.UserDef10:=TABSCustomer3(EntSysObj.Supplier).acUserDef10;
                            end; {Case..}
                          end;


              2000004,
              2000005,
              2000067,
              2050102  :  Result:=(EntSysObj.IntResult);

              2000061..2000064,
              2000180,2000181,
              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
              2000211..2000218
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              2000061
                                  :    LInv.DocUser1:=EntSysObj.Transaction.thUser1;
                              2000062
                                  :    LInv.DocUser2:=EntSysObj.Transaction.thUser2;
                              2000063
                                  :    LInv.DocUser3:=EntSysObj.Transaction.thUser3;
                              2000064
                                  :    LInv.DocUser4:=EntSysObj.Transaction.thUser4;
                              // MH 24/01/08: Modified as it was incorrectly truncating the increased YourRef added for v6.00
                              2000180
                                  //:    LInv.YourRef:=EntSysObj.Transaction.thYourRef;
                                  :    LInv.YourRef:=TAbsInvoice5(EntSysObj.Transaction).thYourRef20;
                              2000181
                                  :    LInv.TransDesc:=EntSysObj.Transaction.thTransDesc;

                              //PR: 14/10/2011 Added new UDFs for v6.9
                              2000211
                                  :    LInv.DocUser5:=TAbsInvoice8(EntSysObj.Transaction).thUser5;
                              2000212
                                  :    LInv.DocUser6:=TAbsInvoice8(EntSysObj.Transaction).thUser6;
                              2000213
                                  :    LInv.DocUser7:=TAbsInvoice8(EntSysObj.Transaction).thUser7;
                              2000214
                                  :    LInv.DocUser8:=TAbsInvoice8(EntSysObj.Transaction).thUser8;
                              2000215
                                  :    LInv.DocUser9:=TAbsInvoice8(EntSysObj.Transaction).thUser9;
                              2000216
                                  :    LInv.DocUser10:=TAbsInvoice8(EntSysObj.Transaction).thUser10;
                              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                              2000217
                                  :    LInv.thUserField11:=TAbsInvoice13(EntSysObj.Transaction).thUser11;
                              2000218
                                  :    LInv.thUserField12:=TAbsInvoice13(EntSysObj.Transaction).thUser12;
                            end; {Case..}
                          end;

              3000031..3000034,
              //GS 25/10/2011 ABSEXCH-11706: Added new UDFs for v6.9
              3000211..3000216
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              3000031
                                  :    LStock.StkUser1:=EntSysObj.Stock.stStkUser1;
                              3000032
                                  :    LStock.StkUser2:=EntSysObj.Stock.stStkUser2;
                              3000033
                                  :    LStock.StkUser3:=EntSysObj.Stock.stStkUser3;
                              3000034
                                  :    LStock.StkUser4:=EntSysObj.Stock.stStkUser4;
                              //GS 25/10/2011 ABSEXCH-11706: Added new UDFs for v6.9
                              3000211
                                  :    LStock.StkUser5:=TABSStock4(EntSysObj.Stock).stStkUser5;
                              3000212
                                  :    LStock.StkUser6:=TABSStock4(EntSysObj.Stock).stStkUser6;
                              3000213
                                  :    LStock.StkUser7:=TABSStock4(EntSysObj.Stock).stStkUser7;
                              3000214
                                  :    LStock.StkUser8:=TABSStock4(EntSysObj.Stock).stStkUser8;
                              3000215
                                  :    LStock.StkUser9:=TABSStock4(EntSysObj.Stock).stStkUser9;
                              3000216
                                  :    LStock.StkUser10:=TABSStock4(EntSysObj.Stock).stStkUser10;
                            end; {Case..}
                          end;

              4000031..4000034,
              4000211..4000216
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              4000031
                                  :    LId.LineUser1:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef1;
                              4000032
                                  :    LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                              4000033
                                  :    LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                              4000034
                                  :    LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;

                              //PR: 14/10/2011 Added new UDFs for v6.9
                              4000211
                                  :    LId.LineUser5:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef5;
                              4000212
                                  :    LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef6;
                              4000213
                                  :    LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef7;
                              4000214
                                  :    LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef8;
                              4000215
                                  :    LId.LineUser9:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef9;
                              4000216
                                  :    LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction.thLines.thCurrentLine).tlUserDef10;
                            end; {Case..}
                          end;


              4000050,4000052
                       :  Begin
                            Result:=EntSysObj.IntResult;
                          end;
              //GS 25/10/2011 ABSEXCH-11706: added support for udf 6-10
              5000031..5000034,5000038,5000039, 5000211..5000216
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              5000031
                                  :  LJobRec^.UserDef1:=EntSysObj.Job.jrUserDef1;
                              5000032
                                  :  LJobRec^.UserDef2:=EntSysObj.Job.jrUserDef2;
                              5000033
                                  :  LJobRec^.UserDef3:=EntSysObj.Job.jrUserDef3;
                              5000034
                                  :  LJobRec^.UserDef4:=EntSysObj.Job.jrUserDef4;
                              //GS 25/10/2011 ABSEXCH-11706: added support for UDEF 6-10
                              5000211
                                  :  LJobRec^.UserDef5:=TAbsJob4(EntSysObj.Job).jrUserDef5;
                              5000212
                                  :  LJobRec^.UserDef6:=TAbsJob4(EntSysObj.Job).jrUserDef6;
                              5000213
                                  :  LJobRec^.UserDef7:=TAbsJob4(EntSysObj.Job).jrUserDef7;
                              5000214
                                  :  LJobRec^.UserDef8:=TAbsJob4(EntSysObj.Job).jrUserDef8;
                              5000215
                                  :  LJobRec^.UserDef9:=TAbsJob4(EntSysObj.Job).jrUserDef9;
                              5000216
                                  :  LJobRec^.UserDef10:=TAbsJob4(EntSysObj.Job).jrUserDef10;
                              5000038,5000039
                                  :  LJobRec^.JQSCode:=TABSJob3(EntSysObj.Job).jrQSCode;
                            end; {Case..}
                          end;
              5000041..5000044
                       :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                            With ExLocal do
                            Case ((WId * 1000) + EId) of
                              5000041
                                  :  LJobMisc^.EmplRec.UserDef1:=EntSysObj.Job.jrUserDef1;
                              5000042
                                  :  LJobMisc^.EmplRec.UserDef2:=EntSysObj.Job.jrUserDef2;
                              5000043
                                  :  LJobMisc^.EmplRec.UserDef3:=EntSysObj.Job.jrUserDef3;
                              5000044
                                  :  LJobMisc^.EmplRec.UserDef4:=EntSysObj.Job.jrUserDef4;
                            end; {Case..}
                          end;

              5000078  :  Begin
                            Result:=Ord(ValidStatus);

                            If (ValidStatus) then
                              ExLocal.LJobRec^.JobMan:=EntSysObj.Job.JrJobMan;
                          end;

            end; {Case..}
          end;


        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;


  Function EnableCustBtns(WID,EID  :  Integer)  :  Boolean;

  Var
    CustomEvent  :  TCustomEvent;

  Begin
    Result:=BOff;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        Result:=GotEvent;
      end; {With..}
    finally
      CustomEvent.Free;
    end;

  end;

  Function ExecuteCustBtn(WID,EID  :  Integer;
                      Var ExLocal  :  TdExLocal)  :  Boolean;

  Var
    n            :  Byte;
    CustomEvent  :  TCustomEvent;

  Begin
    Result:=BOn;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          BuildEvent(ExLocal);

          Case ((WId * 1000) + EId) Of
            3000089  :  Begin
                          EntSysObj.DblResult:=ExLocal.LCtrlDbl;

                        end;

          end; {Case..}

          Execute;

          Case ((WId * 1000) + EId) Of

              1000011..1000022,
              2000087..2000088,
              2000131..2000144,
              2000150..2000159,
              2000160,            // Transaction Security - Copy Button
              2000161,            // Transaction Security - Notes Button
              2000162,            // Transaction Security - Copy/Reverse Button
              2000163,            // Transaction Security - Back To Back Button
              // MH 02/02/2016 2016-R1 ABSEXCH-16488: Add new transaction security hook points on Hold for Query / Cancel Hold
              2000164,            // Transaction Security - Hold for Query
              2000165,            // Transaction Security - Cancel Hold
              3000080..3000099,
              5000120..5000138   :  Begin
                                      Result:=(EntSysObj.BoResult);

                                      Case ((WId * 1000) + EId) Of
                                         3000089  :  Begin
                                                       ExLocal.LCtrlDbl:=EntSysObj.DblResult;
                                                     end;
                                      end; {Case..}
                                    end;

              2000031..2000044,
              2000441..2000448,  //PR: 03/06/2013 ABSEXCH-14318 Added cust buttons 3-6 for Sales, Purch, Adj, Wor.
              2000451..2000458   :  Begin
                                      Result:=(EntSysObj.BoResult);

                                      If (ValidStatus) and (DataChanged) then
                                      With ExLocal,LInv do
                                      Begin
                                        For n:=Low(DAddr) to High(DAddr) do
                                          DAddr[n]:=EntSysObj.Transaction.thDelAddr[n];

                                        // MH 01/10/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                                        ExLocal.LInv.thDeliveryPostCode:=TAbsInvoice9(EntSysObj.Transaction).thDeliveryPostCode;

                                        // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                                        ExLocal.LInv.thDeliveryCountry:=TAbsInvoice11(EntSysObj.Transaction).thDeliveryCountry;

                                        ExLocal.LInv.DocUser1:=EntSysObj.Transaction.thUser1;
                                        ExLocal.LInv.DocUser2:=EntSysObj.Transaction.thUser2;
                                        ExLocal.LInv.DocUser3:=EntSysObj.Transaction.thUser3;
                                        ExLocal.LInv.DocUser4:=EntSysObj.Transaction.thUser4;
                                        //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                                        ExLocal.LInv.DocUser5:=EntSysObj.Transaction3.thUser5;
                                        ExLocal.LInv.DocUser6:=EntSysObj.Transaction3.thUser6;
                                        ExLocal.LInv.DocUser7:=EntSysObj.Transaction3.thUser7;
                                        ExLocal.LInv.DocUser8:=EntSysObj.Transaction3.thUser8;
                                        ExLocal.LInv.DocUser9:=EntSysObj.Transaction3.thUser9;
                                        ExLocal.LInv.DocUser10:=EntSysObj.Transaction3.thUser10;
                                        // MH 16/01/2017 2017-R1 ABSEXCH-18100: Unable to update thUser11/12
                                        ExLocal.LInv.thUserField11:=TAbsInvoice13(EntSysObj.Transaction3).thUser11;
                                        ExLocal.LInv.thUserField12:=TAbsInvoice13(EntSysObj.Transaction3).thUser12;
                                      end;
                                    end;

          end; {Case..}
        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;


  Procedure GenTSHooks(WID,EID  :  Integer;
                   Var ExLocal  :  TdExLocal;
                   Var TeleSHed :  MLocRec);

  Var
    n            :  Byte;
    CustomEvent  :  TCustomEvent;

  Begin
    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);


    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin

          BuildEvent(ExLocal);

          Case ((WId * 1000) + EId) Of
            4000070,
            4000071  :  Begin {Due to poss data clash, preload TeleSales Line}
                          TTelesales(EntSysObj.Telesales).Assign(EnterpriseBase+WID,EId,TeleSHed);
                          TTelesales(EntSysObj.Telesales).oSalesLine.Assign(EnterpriseBase+WID,EId,ExLocal.LMLocCtrl^);
                        end;


          end; {Case..}

          Execute;

          If ValidStatus and DataChanged then
          Begin
            Case ((WId * 1000) + EId) Of

              4000070,
              4000071  :  Begin
                            ExLocal.LMLocCtrl^.CuStkRec.csNetValue:=EntSysObj.TeleSales.teSalesLine.telNetValue;

                          end;


            end;
          end;
        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;


  end;

  //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Extend transaction security hooks from daybooks to rest of the system
  //                                      where applicable.
  Function ValidSecurityHook(WID,EID  :  Integer;
                     Var ExLocal  :  TdExLocal)  :  Boolean;
  var
    TempInv : InvRec;
  begin
    TempInv := ExLocal.LInv;
    ExLocal.LInv := Inv;
    Try
      Result := ExecuteCustBtn(WID, EID, ExLocal);
    Finally
      ExLocal.LInv := TempInv;
    End;
  end;



{$ENDIF}


{ == Misc rotuines we are allowing the hooks to be used within basic routines == }

{ =========== Procedure to Calculate a Period from a date ========== }




{== Replictaed in ExBtTh1U ==}

Procedure Date2Pr(CDate  :  LongDate;
              Var PPr,PYr:  Byte;
                  ExLPtr :  Pointer);


Var
  ExLocal    :  ^TdExLocal;


Begin
  {$IFDEF CU}
    If (Assigned(ExLPtr)) then
      ExLocal:=ExLPtr
    else
    Begin
      New(ExLocal,Create);

      try

        With ExLocal^,LInv do
        Begin
          FolioNum:=-1;
        end;

      except
        Dispose(ExLocal,Destroy);
        ExLocal:=nil;

      end;
    end;

  {$ELSE}
    ExLocal:=nil;
  {$ENDIF}


  SimpleDate2Pr(CDate,PPr,PYr);

  {$IFDEF CU}
     If (Assigned(ExLocal)) then
     With ExLocal^ do
     Begin
       LInv.AcYr:=PYr;
       LInv.AcPr:=PPr;
       LInv.TransDate:=CDate;

       GenHooks(2000,80,ExLocal^);

       PYr:=LInv.AcYr;
       PPr:=LInv.AcPr;

       If (Not Assigned(ExLPtr)) then
         Dispose(ExLocal,Destroy);
     end;
  {$ENDIF}

end;




{ =========== Function to Calculate the Date from the period ========= }
{== Replictaed in ExBtTh1U ==}

Function Pr2Date(PPr,PYr  :  Byte;
                 ExLPtr   :  Pointer)  :  LongDate;


Var
  ExLocal    :  ^TdExLocal;


Begin
  {$IFDEF CU}
    If (Assigned(ExLPtr)) then
      ExLocal:=ExLPtr
    else
    Begin
      New(ExLocal,Create);

      try

        With ExLocal^,LInv do
        Begin
          FolioNum:=-1;
        end;

      except
        Dispose(ExLocal,Destroy);
        ExLocal:=nil;

      end;
    end;

  {$ELSE}
    ExLocal:=nil;
  {$ENDIF}

  Result:=SimplePr2Date(PPr,PYr);

  {$IFDEF CU}
     If (Assigned(ExLocal)) then
     With ExLocal^ do
     Begin
       LInv.AcYr:=PYr;
       LInv.AcPr:=PPr;
       LInv.TransDate:=Result;

       GenHooks(2000,81,ExLocal^);

       Result:=LInv.TransDate;


       If (Not Assigned(ExLPtr)) then {* We must have created a local copy*}
         Dispose(ExLocal,Destroy);
     end;
  {$ENDIF}

end; {Func..}


Function ConvInpPr(Const IDate    :  String;
                   Const Date2Pr  :  Boolean;
                         ExLPtr   :  Pointer)  :  String;


Var
  TPr,TYr  :  Word;
  BPr,BYr  :  Byte;

  TDate    :  LongDate;


begin

  TDate:=IDate;

  Case Date2Pr of

    BOff  :  Begin
               PeriodStr(TDate,TPr,TYr);
               Result:=Pr2Date(TPr,TxlateYrVal(TYr,BOn),ExLPtr);
             end;

    BOn   :  Begin
               Event1U.Date2Pr(TDate,BPr,BYr,ExLPtr);
               Result:=StrPeriod(ConvTxYrVal(BYr,BOff),BPr);
             end;

  end; {Case..}

end; {Func..}





{ == Function to return number of decimals for line discount == }

{$IFDEF CU}
  Function Get_LineDiscDecs(DefDecs  :  LongInt)  :  LongInt;


  Var
    ExLocal  :  ^TdExLocal;


  Begin
    New(ExLocal,Create);

    Result:=IntExitHook(4000,50,DefDecs,ExLocal^);

    Dispose(ExLocal,Destroy);
  end;



{$ENDIF}


Initialization


end.
