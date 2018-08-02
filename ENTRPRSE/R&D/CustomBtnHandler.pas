unit CustomBtnHandler;

{
********************************************************************************
Change History
--------------

Version    Date     Who   JIRA               Description
--------------------------------------------------------------------------------
  1.0   14/01/2013  PKR   ABSEXCH-13449/38   New object that handles custom buttons 
                                             on forms to remove the complexity from
                                             the forms, and to centralise the handling 
                                             of the buttons.
  1.1   21/02/2013  PKR   Code review/test   Job Daybook Text IDs corrected.

  1.2   26/02/2013  PR    ABSEXCH-14079/80/1 Fixed various problems with text ids

  1.3   04/11/2015  PKR   ABSEXCH-16348      Added Custom Buttons to Works Order Daybook.
  

********************************************************************************
NOTE:
All of the custom buttons and custom menu items have their Tag property set to
their custom button number.  i.e. Custom button 1 has its Tag set to 1, custom
button 5 has its Tag set to 5 etc.  It is this value that is passed in as the 
ButtonNo parameter of the following functions.

********************************************************************************
}

interface

uses
  Event1U,
  ExWrap1U;

type
  // State to indicate whether the record is being edited or not
  TRecordState = (rsView, rsEdit, rsAny);

  // The purpose of the form that is being handled.
  // Note that the Trader List form has separate tabs for Customers and Suppliers
  //  but they have their own separate set of Custom Buttons, so they are treated
  //  slightly differently to the other forms.
  TFormPurpose = (fpInvalid = -1,        // 
                  fpCustomerList,        // TTradList   in CustLst2.pas

                  // CJS 06/09/2013 - MRD1.1 - Consumer tab on Trader List
                  fpConsumerList,        // TTradList   in CustLst2.pas

                  fpSupplierList,        // TTradList   in CustLst2.pas
                  fpCustomerRecord,      // TCustRec3   in CustR3U.pas
                  fpSupplierRecord,      // TCustRec3   in CustR3U.pas
                  fpJobRecord,           // TJobRec     in JobMn2u.pas
                  fpSalesDaybook,        // TDayBk1     in DayBk2.pas
                  fpPurchaseDaybook,     // TDayBk1     in DayBk2.pas
                  fpNominalDaybook,      // TDayBk1     in DayBk2.pas
                  fpJobDaybook,          // TJobDayBk   in JobDBk2U.pas
                  fpStockRecord,         // TStockRec   in StockU.pas
                  fpSalesTransaction,    // TSalesTBody in SaleTx2U.pas
                  fpPurchaseTransaction, // TSalesTBody in SaleTx2U.pas
                  fpStockAdjustment,     // TStkAdj     in StkAdjU.pas
                  fpWorksOrder,          // TWOR        in Wordoc2U.pas
                  // PKR. 04/11/2015. ABSEXCH-16348.  Add Custom buttons to Works Order Daybook.
                  fpWorksOrderDaybook    // TDayBk1     in DayBk2.pas
                  );

  TCustButtonNos = (cbCust1=1, cbCust2, cbCust3, cbCust4, cbCust5, cbCust6);
  
  // Some enumerated types that map to the tabs on the various forms.
  // Simply to make it easier to follow the code.
  // CJS 06/09/2013 - MRD1.1 - Consumer tab on Trader List
  TTraderListTabs = (tltCustomer, tltConsumer, tltSupplier);

  //PR: 22/03/2017 ABSEXCH-18143 v2017 R1 Put in missing Roles and Discount tabs
  TCustRecTabs    = (crtMain, crtDefaults, crtEComm, crtRoles, crtNotes, crtDiscounts, crtNultiBuyDiscounts,
                     crtLedger, crtOrders, crtWorksOrders, crtJobApplications,
                     crtReturns);
  TJobRecordTabs  = (jrtMain, jrtNotes, jrtLedger, jrtPurchaseRetentions,
                     jrtSalesRetentions, jrtSubContractTerms, jrtSpare,
                     jrtSalesTerms);
  TDayBookTabs    = (dbtMain, dbtQuotes, dbtAuto, dbtHistory, dbtOrders,
                     dbtOrderHistory);
  TJobDayBookTabs = (jdtJobPrePostings, jdtTimeSheets, jdtTimeSheetHistory,
                     jdtPurchaseApps, jdtPurchaseAppHist, jdtSalesApps,
                     jdtSalesAppHist, jdtPLRetentions, jdtSLRetentions);
  TStockRecordTabs = (srtMain, srtDefaults, srtVatWeb, srtWOP, srtReturns,
                      srtNotes, srtQuantityBreaks, srtMultiBuyDiscounts,
                      srtLedger, srtValue, srtBuild, srtSerial, srtBins);


  //----------------------------------------------------------------------------
  TCustomButtonHandler = class
    private
      //PR: 22/03/2017 ABSEXCH-18143 v2017 R1 Function to resolve Ids for new custom buttons
      function TraderCustomerButtonId(const FormPurpose : TFormPurpose;
                                      const TabNumber : Integer;
                                      const ButtonNumber : Integer) : Integer;
    public
      function IsCustomButtonEnabled(FormPurpose : TFormPurpose;
                                     TabNumber   : Integer;
                                     State       : TRecordState;
                                     ButtonNo    : Integer) : Boolean;
      //PR: 03/06/2013 ABSEXCH-14318 Made ExLocal a var parameter so that changes get passed back.
      function CustomButtonClick(FormPurpose : TFormPurpose;
                                 TabNumber   : Integer;
                                 State       : TRecordState;
                                 ButtonNo    : Integer;
                                 var ExLocal     : TdExLocal) : Boolean;

      function GetEventID(FormPurpose : TFormPurpose;
                          TabNumber   : Integer;
                          State       : TRecordState;
                          ButtonNo    : Integer) : integer;

      function GetTextID(FormPurpose : TFormPurpose;
                         TabNumber   : Integer;
                         State       : TRecordState;
                         ButtonNo    : Integer) : integer;

      function GetWindowID(FormPurpose : TFormPurpose) : integer;
  end;

var
  custBtnHandler : TCustomButtonHandler;

implementation

//==============================================================================
// Determines whether a custom button is enabled or not, based on how it is
//  currently being used.
function TCustomButtonHandler.IsCustomButtonEnabled(FormPurpose : TFormPurpose;
                                                    TabNumber   : Integer;
                                                    State       : TRecordState;
                                                    ButtonNo    : Integer) : Boolean;
var
  WID : integer;
  EID : integer;
begin
  // Get the WindowID
  WID := GetWindowID(FormPurpose);

  // Get the EventID
  EID := GetEventID(FormPurpose, TabNumber, State, ButtonNo);
  
  Result := (EID > 0) and EnableCustBtns(WID, EID);
end;

//==============================================================================
// The Custom Button Click Handlers for the forms that have custom buttons were
//  unnecessarily complex and are replaced by calls to this function which makes
//  it easier to maintain.
// The EID (Event Id) for the button is returned.
// If no EventID exists for the specified values, then -1 is returned.
function TCustomButtonHandler.GetEventID(FormPurpose : TFormPurpose;
                                         TabNumber   : Integer;
                                         State       : TRecordState;
                                         ButtonNo    : Integer)
                                         : integer;

var
  EID : integer;
  custButtonNo : TCustButtonNos;
begin
  EID := -1;  // Default to a non-existent Event ID.

  custButtonNo := TCustButtonNos(ButtonNo);
  
  case FormPurpose of
    // fcCustomerList and fpSupplierList map to the tab number on the Trader form.
    // fpCustomerList is effectively Tab 0
    // However, they have separate sets of Custom buttons.
    fpCustomerList: begin   // TTradList in CustLst2.pas
                       case custButtonNo of
                         cbCust1: EID :=  11;
                         cbCust2: EID :=  12;
                         cbCust3: EID := 141;
                         cbCust4: EID := 142;
                         cbCust5: EID := 143;
                         cbCust6: EID := 144;
                       end; // case custButtonNo
                    end;

    // CJS 06/09/2013 - MRD1.1 - Consumer tab on Trader List
    // Note that the Consumer custom buttons use the same event IDs as
    // the Customer buttons -- any filtering by Customer/Consumer will
    // have do be done by the customisation plugin.
    fpConsumerList: begin   // TTradList in CustLst2.pas
                       case custButtonNo of
                         cbCust1: EID :=  11;
                         cbCust2: EID :=  12;
                         cbCust3: EID := 141;
                         cbCust4: EID := 142;
                         cbCust5: EID := 143;
                         cbCust6: EID := 144;
                       end; // case custButtonNo
                    end;

    // fpSupplierList is effectively Tab 1
    fpSupplierList: begin   // TTradList in CustLst2.pas
                       case custButtonNo of
                         cbCust1: EID :=  21;
                         cbCust2: EID :=  22;
                         cbCust3: EID := 151;
                         cbCust4: EID := 152;
                         cbCust5: EID := 153;
                         cbCust6: EID := 154;
                       end; // case custButtonNo
                    end;

    //..........................................................................
    fpCustomerRecord: begin   // TCustRec3 in CustR3U.pas
                         //PR: 22/03/2017 ABSEXCH-18143 v2017 R1 New custom buttons
                         if TabNumber <> Ord(crtLedger) then
                         begin
                           //Call function to resolve Ids added for ABSEXCH-18143
                           EID := TraderCustomerButtonId(FormPurpose, TabNumber, Ord(custButtonNo));
                         end
                         else
                         begin //Ledger tab - set existing IDs
                           case custButtonNo of
                             cbCust1: EID := 120;
                             cbCust2: EID := 121;
                             cbCust3: EID := 145;
                             cbCust4: EID := 146;
                             cbCust5: EID := 147;
                             cbCust6: EID := 148;
                           end; // case custButtonNo
                         end; //Not Ledger tab
                      end;

    fpSupplierRecord: begin   // TCustRec3 in CustR3U.pas
                         if TabNumber <> Ord(crtLedger) then
                         begin
                           //Call function to resolve Ids added for ABSEXCH-18143
                           EID := TraderCustomerButtonId(FormPurpose, TabNumber, Ord(custButtonNo));
                         end
                         else
                         begin //Ledger tab - set existing IDs
                           case custButtonNo of
                             cbCust1: EID := 130;
                             cbCust2: EID := 131;
                             cbCust3: EID := 155;
                             cbCust4: EID := 156;
                             cbCust5: EID := 157;
                             cbCust6: EID := 158;
                           end; // case custButtonNo
                         end; //Not Ledger tab
                      end;

    //..........................................................................
    fpJobRecord: begin   // TJobRec   in JobMn2u.pas
                   case TJobRecordTabs(TabNumber) of
                     jrtMain:  begin
                                 case custButtonNo of
                                   cbCust1: EID :=  10;
                                   cbCust2: EID :=  20;
                                   cbCust3: EID := 140;
                                   cbCust4: EID := 150;
                                   cbCust5: EID := 160;
                                   cbCust6: EID := 170;
                                 end; // case custButtonNo
                               end;
                     jrtNotes: begin
                                 case custButtonNo of
                                   cbCust1: EID :=  11;
                                   cbCust2: EID :=  21;
                                   cbCust3: EID := 141;
                                   cbCust4: EID := 151;
                                   cbCust5: EID := 161;
                                   cbCust6: EID := 171;
                                 end; // case custButtonNo
                               end;
                     jrtLedger: begin
                                  case custButtonNo of
                                    cbCust1: EID :=  12;
                                    cbCust2: EID :=  22;
                                    cbCust3: EID := 142;
                                    cbCust4: EID := 152;
                                    cbCust5: EID := 162;
                                    cbCust6: EID := 172;
                                  end; // case custButtonNo
                                end;
                     jrtPurchaseRetentions: begin
                                              case custButtonNo of
                                                cbCust1: EID :=  13;
                                                cbCust2: EID :=  23;
                                                cbCust3: EID := 143;
                                                cbCust4: EID := 153;
                                                cbCust5: EID := 163;
                                                cbCust6: EID := 173;
                                              end; // case custButtonNo
                                            end;
                     jrtSalesRetentions: begin
                                           // PKR.  Not sure if this block is needed.
                                           case custButtonNo of
                                             cbCust1: EID :=  14;
                                             cbCust2: EID :=  24;
                                             cbCust3: EID := 144;
                                             cbCust4: EID := 154;
                                             cbCust5: EID := 164;
                                             cbCust6: EID := 174;
                                           end; // case custButtonNo
                                         end;
                   end; // case TabNumber
                 end;

    //..........................................................................
    fpSalesDaybook: begin   // TDayBk1   in DayBk2.pas
                      case TDayBookTabs(TabNumber) of
                       dbtMain: begin
                            case custButtonNo of
                              cbCust1: EID :=  10;
                              cbCust2: EID :=  20;
                              cbCust3: EID := 361;
                              cbCust4: EID := 371;
                              cbCust5: EID := 381;
                              cbCust6: EID := 391;
                            end; // case custButtonNo
                          end;
                       dbtQuotes: begin
                            case custButtonNo of
                              cbCust1: EID :=  11;
                              cbCust2: EID :=  21;
                              cbCust3: EID := 362;
                              cbCust4: EID := 372;
                              cbCust5: EID := 382;
                              cbCust6: EID := 392;
                            end; // case custButtonNo
                          end;
                       dbtAuto: begin
                            case custButtonNo of
                              cbCust1: EID :=  12;
                              cbCust2: EID :=  22;
                              cbCust3: EID := 363;
                              cbCust4: EID := 373;
                              cbCust5: EID := 383;
                              cbCust6: EID := 393;
                            end; // case custButtonNo
                          end;
                       dbtHistory: begin
                            case custButtonNo of
                              cbCust1: EID :=  13;
                              cbCust2: EID :=  23;
                              cbCust3: EID := 364;
                              cbCust4: EID := 374;
                              cbCust5: EID := 384;
                              cbCust6: EID := 394;
                            end; // case custButtonNo
                          end;
                       dbtOrders: begin
                            case custButtonNo of
                              cbCust1: EID :=  14;
                              cbCust2: EID :=  24;
                              cbCust3: EID := 365;
                              cbCust4: EID := 375;
                              cbCust5: EID := 385;
                              cbCust6: EID := 395;
                            end; // case custButtonNo
                          end;
                       dbtOrderHistory: begin
                            case custButtonNo of
                              cbCust1: EID :=  15;
                              cbCust2: EID :=  25;
                              cbCust3: EID := 366;
                              cbCust4: EID := 376;
                              cbCust5: EID := 386;
                              cbCust6: EID := 396;
                            end; // case custButtonNo
                          end;
                      end; // case TabNumber
                    end;

    fpPurchaseDaybook: begin   // TDayBk1   in DayBk2.pas
                         case TDayBookTabs(TabNumber) of
                           dbtMain: begin
                                      case custButtonNo of
                                        cbCust1: EID := 110;
                                        cbCust2: EID := 120;
                                        cbCust3: EID := 401;
                                        cbCust4: EID := 411;
                                        cbCust5: EID := 421;
                                        cbCust6: EID := 431;
                                      end; // case custButtonNo
                                    end;
                           dbtQuotes: begin
                                        case custButtonNo of
                                          cbCust1: EID := 111;
                                          cbCust2: EID := 121;
                                          cbCust3: EID := 402;
                                          cbCust4: EID := 412;
                                          cbCust5: EID := 422;
                                          cbCust6: EID := 432;
                                        end; // case custButtonNo
                                      end;
                           dbtAuto: begin
                                      case custButtonNo of
                                        cbCust1: EID := 112;
                                        cbCust2: EID := 122;
                                        cbCust3: EID := 403;
                                        cbCust4: EID := 413;
                                        cbCust5: EID := 423;
                                        cbCust6: EID := 433;
                                      end; // case custButtonNo
                                    end;
                           dbtHistory: begin
                                         case custButtonNo of
                                           cbCust1: EID := 113;
                                           cbCust2: EID := 123;
                                           cbCust3: EID := 404;
                                           cbCust4: EID := 414;
                                           cbCust5: EID := 424;
                                           cbCust6: EID := 434;
                                         end; // case custButtonNo
                                       end;
                           dbtOrders: begin
                                        case custButtonNo of
                                          cbCust1: EID := 114;
                                          cbCust2: EID := 124;
                                          cbCust3: EID := 405;
                                          cbCust4: EID := 415;
                                          cbCust5: EID := 425;
                                          cbCust6: EID := 435;
                                        end; // case custButtonNo
                                      end;
                           dbtOrderHistory: begin
                                              case custButtonNo of
                                                cbCust1: EID := 115;
                                                cbCust2: EID := 125;
                                                cbCust3: EID := 406;
                                                cbCust4: EID := 416;
                                                cbCust5: EID := 426;
                                                cbCust6: EID := 436;
                                              end; // case custButtonNo
                                            end;
                             end; // case TabNumber
                       end;

    fpNominalDaybook:  begin   // TDayBk1   in DayBk2.pas
                         case TDayBookTabs(TabNumber) of
                           dbtMain: begin
                                      case custButtonNo of
                                        cbCust1: EID := 301;
                                        cbCust2: EID := 311;
                                        cbCust3: EID := 321;
                                        cbCust4: EID := 331;
                                        cbCust5: EID := 341;
                                        cbCust6: EID := 351;
                                      end; // case custButtonNo
                                    end;
                           dbtQuotes: begin
                                        case custButtonNo of
                                          cbCust1: EID := 302;
                                          cbCust2: EID := 312;
                                          cbCust3: EID := 322;
                                          cbCust4: EID := 332;
                                          cbCust5: EID := 342;
                                          cbCust6: EID := 352;
                                        end; // case custButtonNo
                                      end;
                           dbtAuto: begin
                                      case custButtonNo of
                                        cbCust1: EID := 303;
                                        cbCust2: EID := 313;
                                        cbCust3: EID := 323;
                                        cbCust4: EID := 333;
                                        cbCust5: EID := 343;
                                        cbCust6: EID := 353;
                                      end; // case custButtonNo
                                    end;
                           dbtHistory: begin
                                         case custButtonNo of
                                           cbCust1: EID := 304;
                                           cbCust2: EID := 314;
                                           cbCust3: EID := 324;
                                           cbCust4: EID := 334;
                                           cbCust5: EID := 344;
                                           cbCust6: EID := 354;
                                         end; // case custButtonNo
                                       end;
                           dbtOrders: begin
                                        case custButtonNo of
                                          cbCust1: EID := 305;
                                          cbCust2: EID := 315;
                                          cbCust3: EID := 325;
                                          cbCust4: EID := 335;
                                          cbCust5: EID := 345;
                                          cbCust6: EID := 355;
                                        end; // case custButtonNo
                                      end;
                           dbtOrderHistory: begin
                                              case custButtonNo of
                                                cbCust1: EID := 306;
                                                cbCust2: EID := 316;
                                                cbCust3: EID := 326;
                                                cbCust4: EID := 336;
                                                cbCust5: EID := 346;
                                                cbCust6: EID := 356;
                                              end; // case custButtonNo
                                            end;
                         end; // case TabNumber
                       end;

    //..........................................................................

    //PR: 25/02/2013 Changed buttons 3-6 to handler ids range 220-258 to avoid clash with Job Record UDF handler ids.
    fpJobDaybook: begin   // TJobDayBk in JobDBk2U.pas
                    case TJobDayBookTabs(TabNumber) of
                      jdtJobPrePostings: begin
                                           case custButtonNo of
                                             cbCust1: EID := 120;
                                             cbCust2: EID := 130;
                                             cbCust3: EID := 220;
                                             cbCust4: EID := 230;
                                             cbCust5: EID := 240;
                                             cbCust6: EID := 250;
                                           end; // case custButtonNo
                                         end;
                      jdtTimeSheets: begin
                                       case custButtonNo of
                                         cbCust1: EID := 121;
                                         cbCust2: EID := 131;
                                         cbCust3: EID := 221;
                                         cbCust4: EID := 231;
                                         cbCust5: EID := 241;
                                         cbCust6: EID := 251;
                                       end; // case custButtonNo
                                     end;
                      jdtTimeSheetHistory: begin
                                             case custButtonNo of
                                               cbCust1: EID := 122;
                                               cbCust2: EID := 132;
                                               cbCust3: EID := 222;
                                               cbCust4: EID := 232;
                                               cbCust5: EID := 242;
                                               cbCust6: EID := 252;
                                             end; // case custButtonNo
                                           end;
                      jdtPurchaseApps: begin
                                         case custButtonNo of
                                           cbCust1: EID := 123;
                                           cbCust2: EID := 133;
                                           cbCust3: EID := 223;
                                           cbCust4: EID := 233;
                                           cbCust5: EID := 243;
                                           cbCust6: EID := 253;
                                         end; // case custButtonNo
                                       end;
                      jdtPurchaseAppHist: begin
                                            case custButtonNo of
                                              cbCust1: EID := 124;
                                              cbCust2: EID := 134;
                                              cbCust3: EID := 224;
                                              cbCust4: EID := 234;
                                              cbCust5: EID := 244;
                                              cbCust6: EID := 254;
                                            end; // case custButtonNo
                                          end;
                      jdtSalesApps: begin
                                      case custButtonNo of
                                        cbCust1: EID := 125;
                                        cbCust2: EID := 135;
                                        cbCust3: EID := 225;
                                        cbCust4: EID := 235;
                                        cbCust5: EID := 245;
                                        cbCust6: EID := 255;
                                      end; // case custButtonNo
                                    end;
                      jdtSalesAppHist: begin
                                         case custButtonNo of
                                           cbCust1: EID := 126;
                                           cbCust2: EID := 136;
                                           cbCust3: EID := 226;
                                           cbCust4: EID := 236;
                                           cbCust5: EID := 246;
                                           cbCust6: EID := 256;
                                         end; // case custButtonNo
                                       end;
                      jdtPLRetentions: begin
                                         case custButtonNo of
                                           cbCust1: EID := 127;
                                           cbCust2: EID := 137;
                                           cbCust3: EID := 227;
                                           cbCust4: EID := 237;
                                           cbCust5: EID := 247;
                                           cbCust6: EID := 257;
                                         end; // case custButtonNo
                                       end;
                      jdtSLRetentions: begin
                                         case custButtonNo of
                                           cbCust1: EID := 128;
                                           cbCust2: EID := 138;
                                           cbCust3: EID := 228;
                                           cbCust4: EID := 238;
                                           cbCust5: EID := 248;
                                           cbCust6: EID := 258;
                                         end; // case custButtonNo
                                       end;
                    end; // case TabNumbe
                  end;

    //..........................................................................
    fpStockRecord: begin   // TStockRec in StockU.pas
                     case TStockRecordTabs(TabNumber) of
                       srtMain: begin
                                  case custButtonNo of
                                    cbCust1: EID :=  80;
                                    cbCust2: EID :=  90;
                                    cbCust3: EID := 221;
                                    cbCust4: EID := 231;
                                    cbCust5: EID := 241;
                                    cbCust6: EID := 251;
                                  end; // case custButtonNo
                                end;
                       srtDefaults: begin
                                      case custButtonNo of
                                        cbCust1: EID :=  81;
                                        cbCust2: EID :=  91;
                                        cbCust3: EID := 222;
                                        cbCust4: EID := 232;
                                        cbCust5: EID := 242;
                                        cbCust6: EID := 252;
                                      end; // case custButtonNo
                                    end;
                       srtVatWeb: begin
                                    case custButtonNo of
                                      cbCust1: EID :=  88;
                                      cbCust2: EID :=  98;
                                      cbCust3: EID := 229;
                                      cbCust4: EID := 239;
                                      cbCust5: EID := 249;
                                      cbCust6: EID := 259;
                                    end; // case custButtonNo
                                  end;
                       srtWOP: begin
                                 case custButtonNo of
                                   cbCust1: EID :=  87;
                                   cbCust2: EID :=  97;
                                   cbCust3: EID := 228;
                                   cbCust4: EID := 238;
                                   cbCust5: EID := 248;
                                   cbCust6: EID := 258;
                                 end; // case custButtonNo
                               end;
                       srtReturns: begin
                                     case custButtonNo of
                                       cbCust1: EID :=  82;
                                       cbCust2: EID :=  92;
                                       cbCust3: EID := 223;
                                       cbCust4: EID := 233;
                                       cbCust5: EID := 243;
                                       cbCust6: EID := 253;
                                     end; // case custButtonNo
                                   end;
                       srtNotes: begin
// No custom buttons displayed on the Notes tab.
//                                   case custButtonNo of
//                                     cbCust1: EID :=  82;
//                                     cbCust2: EID :=  92;
//                                     cbCust3: EID := 223;
//                                     cbCust4: EID := 233;
//                                     cbCust5: EID := 243;
//                                     cbCust6: EID := 253;
//                                   end; // case custButtonNo
                                 end;
                       srtQuantityBreaks: begin
                                            case custButtonNo of
                                              cbCust1: EID :=  83;
                                              cbCust2: EID :=  93;
                                              cbCust3: EID := 224;
                                              cbCust4: EID := 234;
                                              cbCust5: EID := 244;
                                              cbCust6: EID := 254;
                                            end; // case custButtonNo
                                          end;
                       srtMultiBuyDiscounts: begin
                                               case custButtonNo of
                                                 cbCust1: EID := 101;
                                                 cbCust2: EID := 112; // CJS 2014-07-18 ABSEXCH-14280
                                                 cbCust3: EID := 261;
                                                 cbCust4: EID := 271;
                                                 cbCust5: EID := 281;
                                                 cbCust6: EID := 291;
                                               end; // case custButtonNo
                                             end;
                       srtLedger: begin
                                    case custButtonNo of
                                      cbCust1: EID :=  84;
                                      cbCust2: EID :=  94;
                                      cbCust3: EID := 225;
                                      cbCust4: EID := 235;
                                      cbCust5: EID := 245;
                                      cbCust6: EID := 255;
                                    end; // case custButtonNo
                                  end;
                       srtValue: begin
                                   case custButtonNo of
                                     cbCust1: EID :=  85;
                                     cbCust2: EID :=  95;
                                     cbCust3: EID := 226;
                                     cbCust4: EID := 236;
                                     cbCust5: EID := 246;
                                     cbCust6: EID := 256;
                                   end; // case custButtonNo
                                 end;
                       srtBuild: begin
                                   case custButtonNo of
                                     cbCust1: EID :=  86;
                                     cbCust2: EID :=  96;
                                     cbCust3: EID := 227;
                                     cbCust4: EID := 237;
                                     cbCust5: EID := 247;
                                     cbCust6: EID := 257;
                                   end; // case custButtonNo
                                 end;
                       srtSerial: begin
                                    case custButtonNo of
                                      cbCust1: EID :=  89;
                                      cbCust2: EID :=  99;
                                      cbCust3: EID := 230;
                                      cbCust4: EID := 240;
                                      cbCust5: EID := 250;
                                      cbCust6: EID := 260;
                                    end; // case custButtonNo
                                  end;
                       srtBins: begin
                                  case custButtonNo of
                                    cbCust1: EID :=  89;
                                    cbCust2: EID :=  99;
                                    cbCust3: EID := 230;
                                    cbCust4: EID := 240;
                                    cbCust5: EID := 250;
                                    cbCust6: EID := 260;
                                  end; // case custButtonNo
                                end;
                             end; // case TabNumber
                           end;

                           //...................................................
    fpSalesTransaction: begin   // TSalesTBody in SaleTx2U.pas
                          case State of
                            rsEdit: begin
                                      case custButtonNo of
                                        cbCust1: EID :=  31;
                                        cbCust2: EID :=  32;
                                        cbCust3: EID := 441;
                                        cbCust4: EID := 442;
                                        cbCust5: EID := 443;
                                        cbCust6: EID := 444;
                                      end; // case custButtonNo
                                    end;
                            rsView: begin
                                      case custButtonNo of
                                        cbCust1: EID := 131;
                                        cbCust2: EID := 132;
                                        cbCust3: EID := 541;
                                        cbCust4: EID := 542;
                                        cbCust5: EID := 543;
                                        cbCust6: EID := 544;
                                      end; // case custButtonNo
                                    end;
                          end; // case State
                        end;

    fpPurchaseTransaction: begin   // TSalesTBody in SaleTx2U.pas
                             case State of
                               rsEdit: begin
                                         case custButtonNo of
                                           cbCust1: EID :=  41;
                                           cbCust2: EID :=  42;
                                           cbCust3: EID := 445;
                                           cbCust4: EID := 446;
                                           cbCust5: EID := 447;
                                           cbCust6: EID := 448;
                                         end; // case custButtonNo
                                       end;
                               rsView: begin
                                         case custButtonNo of
                                           cbCust1: EID := 141;
                                           cbCust2: EID := 142;
                                           cbCust3: EID := 545;
                                           cbCust4: EID := 546;
                                           cbCust5: EID := 547;
                                           cbCust6: EID := 548;
                                         end; // case custButtonNo
                                       end;
                             end; // case State
                           end;

                           //...................................................
    fpStockAdjustment: begin   // TStkAdj   in StkAdjU.pas
                         if TabNumber = 0 then
                         begin
                           case State of
                             rsEdit: begin
                                       case custButtonNo of
                                         cbCust1: EID :=  38;
                                         cbCust2: EID :=  39;
                                         cbCust3: EID := 451;
                                         cbCust4: EID := 452;
                                         cbCust5: EID := 453;
                                         cbCust6: EID := 454;
                                       end; // case custButtonNo
                                     end;
                             rsView: begin
                                       case custButtonNo of
                                         cbCust1: EID := 138;
                                         cbCust2: EID := 139;
                                         cbCust3: EID := 551;
                                         cbCust4: EID := 552;
                                         cbCust5: EID := 553;
                                         cbCust6: EID := 554;
                                       end; // case custButtonNo
                                     end;
                           end; // case State
                         end;
                       end;

                           //...................................................
    fpWorksOrder: begin   // TWOR      in Wordoc2U.pas
                    case State of
                      rsEdit: begin
                                case custButtonNo of
                                  cbCust1: EID :=  43;
                                  cbCust2: EID :=  44;
                                  cbCust3: EID := 455;
                                  cbCust4: EID := 456;
                                  cbCust5: EID := 457;
                                  cbCust6: EID := 458;
                                end; // case custButtonNo
                              end;
                      rsView: begin
                                case custButtonNo of
                                  cbCust1: EID := 143;
                                  cbCust2: EID := 144;
                                  cbCust3: EID := 555;
                                  cbCust4: EID := 556;
                                  cbCust5: EID := 557;
                                  cbCust6: EID := 558;
                                end; // case custButtonNo
                              end;
                    end; // case State
                  end;

    // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
    fpWorksOrderDaybook: begin   // TDayBk1   in DayBk2.pas
                      case TDayBookTabs(TabNumber) of
                       dbtMain: begin
                            case custButtonNo of
                              cbCust1: EID := 561;
                              cbCust2: EID := 562;
                              cbCust3: EID := 563;
                              cbCust4: EID := 564;
                              cbCust5: EID := 565;
                              cbCust6: EID := 566;
                            end; // case custButtonNo
                          end;
                       dbtHistory: begin
                            case custButtonNo of
                              cbCust1: EID := 571;
                              cbCust2: EID := 572;
                              cbCust3: EID := 573;
                              cbCust4: EID := 574;
                              cbCust5: EID := 575;
                              cbCust6: EID := 576;
                            end; // case custButtonNo
                          end;
                      end; // case TabNumber
                    end;

  end; // case FormPurpose

  Result := EID;
end;


//==============================================================================
function TCustomButtonHandler.GetTextID(FormPurpose : TFormPurpose;
                       TabNumber   : Integer;
                       State       : TRecordState;
                       ButtonNo    : Integer) : integer;
var
  TID : integer;
  custButtonNo : TCustButtonNos;
begin
  TID := -1;  // Default to an illegal Event ID.

  custButtonNo := TCustButtonNos(ButtonNo);

  case FormPurpose of
    // fcCustomerList and fpSupplierList map to the tab number on the Trader form.
    // fpCustomerList is effectively Tab 0
    // However, they have separate sets of Custom buttons.
    fpCustomerList: begin   // TTradList in CustLst2.pas
                       case custButtonNo of
                         cbCust1: TID :=   1;
                         cbCust2: TID :=   2;
                         cbCust3: TID := 141;
                         cbCust4: TID := 142;
                         cbCust5: TID := 143;
                         cbCust6: TID := 144;
                       end; // case custButtonNo
                    end;

    // fpSupplierList is effectively Tab 1
    fpSupplierList: begin   // TTradList in CustLst2.pas
                       case custButtonNo of
                         cbCust1: TID :=   3;
                         cbCust2: TID :=   4;
                         cbCust3: TID := 151;
                         cbCust4: TID := 152;
                         cbCust5: TID := 153;
                         cbCust6: TID := 154;
                       end; // case custButtonNo
                    end;

    //..........................................................................
    fpCustomerRecord: begin   // TCustRec3 in CustR3U.pas
    // Although WinMapu.pas lists 20, 21, 30, 31 as Text IDs for custom buttons
    // 1 & 2, they actually use the Event IDs 120, 121, 130, 131.
                         if TabNumber <> Ord(crtLedger) then
                         begin
                           //Call function to resolve Ids added for ABSEXCH-18143
                           TID := TraderCustomerButtonId(FormPurpose, TabNumber, Ord(custButtonNo));
                         end
                         else
                         begin //Ledger tab - set existing IDs
                           case custButtonNo of
                             cbCust1: TID := 120;
                             cbCust2: TID := 121;
                             cbCust3: TID := 145;
                             cbCust4: TID := 146;
                             cbCust5: TID := 147;
                             cbCust6: TID := 148;
                           end; // case custButtonNo
                         end;
                      end;

    fpSupplierRecord: begin   // TCustRec3 in CustR3U.pas
                         if TabNumber <> Ord(crtLedger) then
                         begin
                           //Call function to resolve Ids added for ABSEXCH-18143
                           TID := TraderCustomerButtonId(FormPurpose, TabNumber, Ord(custButtonNo));
                         end
                         else
                         begin //Ledger tab - set existing IDs
                           case custButtonNo of
                             cbCust1: TID := 130;
                             cbCust2: TID := 131;
                             cbCust3: TID := 155;
                             cbCust4: TID := 156;
                             cbCust5: TID := 157;
                             cbCust6: TID := 158;
                           end; // case custButtonNo
                         end;
                      end;

    //..........................................................................
    fpJobRecord: begin   // TJobRec   in JobMn2u.pas
                   case TJobRecordTabs(TabNumber) of
                     jrtMain:  begin
                                 case custButtonNo of
                                   cbCust1: TID :=  10;
                                   cbCust2: TID :=  20;
                                   cbCust3: TID := 140;
                                   cbCust4: TID := 150;
                                   cbCust5: TID := 160;
                                   cbCust6: TID := 170;
                                 end; // case custButtonNo
                               end;
                     jrtNotes: begin
                                 case custButtonNo of
                                   cbCust1: TID :=  11;
                                   cbCust2: TID :=  21;
                                   cbCust3: TID := 141;
                                   cbCust4: TID := 151;
                                   cbCust5: TID := 161;
                                   cbCust6: TID := 171;
                                 end; // case custButtonNo
                               end;
                     jrtLedger: begin
                                  case custButtonNo of
                                    cbCust1: TID :=  12;
                                    cbCust2: TID :=  22;
                                    cbCust3: TID := 142;
                                    cbCust4: TID := 152;
                                    cbCust5: TID := 162;
                                    cbCust6: TID := 172;
                                  end; // case custButtonNo
                                end;
                     jrtPurchaseRetentions: begin
                                              case custButtonNo of
                                                cbCust1: TID :=  13;
                                                cbCust2: TID :=  23;
                                                cbCust3: TID := 143;
                                                cbCust4: TID := 153;
                                                cbCust5: TID := 163;
                                                cbCust6: TID := 173;
                                              end; // case custButtonNo
                                            end;
                     jrtSalesRetentions: begin
                                           // PKR.  Not sure if this block is needed.
                                           case custButtonNo of
                                             cbCust1: TID :=  14;
                                             cbCust2: TID :=  24;
                                             cbCust3: TID := 144;
                                             cbCust4: TID := 154;
                                             cbCust5: TID := 164;
                                             cbCust6: TID := 174;
                                           end; // case custButtonNo
                                         end;
                   end; // case TabNumber
                 end;

    //..........................................................................
    fpSalesDaybook: begin   // TDayBk1   in DayBk2.pas
                     case TDayBookTabs(TabNumber) of
                       dbtMain: begin
                            case custButtonNo of
                              cbCust1: TID :=  10;
                              cbCust2: TID :=  20;
                              cbCust3: TID := 361;
                              cbCust4: TID := 371;
                              cbCust5: TID := 381;
                              cbCust6: TID := 391;
                            end; // case custButtonNo
                          end;
                       dbtQuotes: begin
                            case custButtonNo of
                              cbCust1: TID :=  11;
                              cbCust2: TID :=  21;
                              cbCust3: TID := 362;
                              cbCust4: TID := 372;
                              cbCust5: TID := 382;
                              cbCust6: TID := 392;
                            end; // case custButtonNo
                          end;
                       dbtAuto: begin
                            case custButtonNo of
                              cbCust1: TID :=  12;
                              cbCust2: TID :=  22;
                              cbCust3: TID := 363;
                              cbCust4: TID := 373;
                              cbCust5: TID := 383;
                              cbCust6: TID := 393;
                            end; // case custButtonNo
                          end;
                       dbtHistory: begin
                            case custButtonNo of
                              cbCust1: TID :=  13;
                              cbCust2: TID :=  23;
                              cbCust3: TID := 364;
                              cbCust4: TID := 374;
                              cbCust5: TID := 384;
                              cbCust6: TID := 394;
                            end; // case custButtonNo
                          end;
                       dbtOrders: begin
                            case custButtonNo of
                              cbCust1: TID :=  14;
                              cbCust2: TID :=  24;
                              cbCust3: TID := 365;
                              cbCust4: TID := 375;
                              cbCust5: TID := 385;
                              cbCust6: TID := 395;
                            end; // case custButtonNo
                          end;
                       dbtOrderHistory: begin
                            case custButtonNo of
                              cbCust1: TID :=  15;
                              cbCust2: TID :=  25;
                              cbCust3: TID := 366;
                              cbCust4: TID := 376;
                              cbCust5: TID := 386;
                              cbCust6: TID := 396;
                            end; // case custButtonNo
                          end;
                     end; // case TabNumber
                    end;

    fpPurchaseDaybook: begin   // TDayBk1   in DayBk2.pas
                         case TDayBookTabs(TabNumber) of
                           dbtMain: begin
                                      case custButtonNo of
                                        cbCust1: TID := 110;
                                        cbCust2: TID := 120;
                                        cbCust3: TID := 401;
                                        cbCust4: TID := 411;
                                        cbCust5: TID := 421;
                                        cbCust6: TID := 431;
                                      end; // case custButtonNo
                                    end;
                           dbtQuotes: begin
                                        case custButtonNo of
                                          cbCust1: TID := 111;
                                          cbCust2: TID := 121;
                                          cbCust3: TID := 402;
                                          cbCust4: TID := 412;
                                          cbCust5: TID := 422;
                                          cbCust6: TID := 432;
                                        end; // case custButtonNo
                                      end;
                           dbtAuto: begin
                                      case custButtonNo of
                                        cbCust1: TID := 112;
                                        cbCust2: TID := 122;
                                        cbCust3: TID := 403;
                                        cbCust4: TID := 413;
                                        cbCust5: TID := 423;
                                        cbCust6: TID := 433;
                                      end; // case custButtonNo
                                    end;
                           dbtHistory: begin
                                         case custButtonNo of
                                           cbCust1: TID := 113;
                                           cbCust2: TID := 123;
                                           cbCust3: TID := 404;
                                           cbCust4: TID := 414;
                                           cbCust5: TID := 424;
                                           cbCust6: TID := 434;
                                         end; // case custButtonNo
                                       end;
                           dbtOrders: begin
                                        case custButtonNo of
                                          cbCust1: TID := 114;
                                          cbCust2: TID := 124;
                                          cbCust3: TID := 405;
                                          cbCust4: TID := 415;
                                          cbCust5: TID := 425;
                                          cbCust6: TID := 435;
                                        end; // case custButtonNo
                                      end;
                           dbtOrderHistory: begin
                                              case custButtonNo of
                                                cbCust1: TID := 115;
                                                cbCust2: TID := 125;
                                                cbCust3: TID := 406;
                                                cbCust4: TID := 416;
                                                cbCust5: TID := 426;
                                                cbCust6: TID := 436;
                                              end; // case custButtonNo
                                            end;
                             end; // case TabNumber
                       end;

    fpNominalDaybook:  begin   // TDayBk1   in DayBk2.pas
                         case TDayBookTabs(TabNumber) of
                           dbtMain: begin
                                      case custButtonNo of
                                        cbCust1: TID := 301;
                                        cbCust2: TID := 311;
                                        cbCust3: TID := 321;
                                        cbCust4: TID := 331;
                                        cbCust5: TID := 341;
                                        cbCust6: TID := 351;
                                      end; // case custButtonNo
                                    end;
                           dbtQuotes: begin
                                        case custButtonNo of
                                          cbCust1: TID := 302;
                                          cbCust2: TID := 312;
                                          cbCust3: TID := 322;
                                          cbCust4: TID := 332;
                                          cbCust5: TID := 342;
                                          cbCust6: TID := 352;
                                        end; // case custButtonNo
                                      end;
                           dbtAuto: begin
                                      case custButtonNo of
                                        cbCust1: TID := 303;
                                        cbCust2: TID := 313;
                                        cbCust3: TID := 323;
                                        cbCust4: TID := 333;
                                        cbCust5: TID := 343;
                                        cbCust6: TID := 353;
                                      end; // case custButtonNo
                                    end;
                           dbtHistory: begin
                                         case custButtonNo of
                                           cbCust1: TID := 304;
                                           cbCust2: TID := 314;
                                           cbCust3: TID := 324;
                                           cbCust4: TID := 334;
                                           cbCust5: TID := 344;
                                           cbCust6: TID := 354;
                                         end; // case custButtonNo
                                       end;
                           dbtOrders: begin
                                        case custButtonNo of
                                          cbCust1: TID := 305;
                                          cbCust2: TID := 315;
                                          cbCust3: TID := 325;
                                          cbCust4: TID := 335;
                                          cbCust5: TID := 345;
                                          cbCust6: TID := 355;
                                        end; // case custButtonNo
                                      end;
                           dbtOrderHistory: begin
                                              case custButtonNo of
                                                cbCust1: TID := 306;
                                                cbCust2: TID := 316;
                                                cbCust3: TID := 326;
                                                cbCust4: TID := 336;
                                                cbCust5: TID := 346;
                                                cbCust6: TID := 356;
                                              end; // case custButtonNo
                                            end;
                         end; // case TabNumber
                       end;

    //..........................................................................
    //PR: 25/02/2013 Changed buttons 3-6 to text ids range 220-258 to match handler ids.
    //PR: 26/02/2013 Changed buttons 1 & 2 on Apps/Apps Hist to match original text ids
    fpJobDaybook: begin   // TJobDayBk in JobDBk2U.pas
                    case TJobDayBookTabs(TabNumber) of
                      jdtJobPrePostings: begin
                                           case custButtonNo of
                                             cbCust1: TID := 10;  // PKR was 120;
                                             cbCust2: TID := 20;  // PKR was 130;
                                             cbCust3: TID := 220;
                                             cbCust4: TID := 230;
                                             cbCust5: TID := 240;
                                             cbCust6: TID := 250;
                                           end; // case custButtonNo
                                         end;
                      jdtTimeSheets: begin
                                       case custButtonNo of
                                         cbCust1: TID := 11;  // PKR was 121;
                                         cbCust2: TID := 21;  // PKR was 131;
                                         cbCust3: TID := 221;
                                         cbCust4: TID := 231;
                                         cbCust5: TID := 241;
                                         cbCust6: TID := 251;
                                       end; // case custButtonNo
                                     end;
                      jdtTimeSheetHistory: begin
                                             case custButtonNo of
                                               cbCust1: TID := 12;  // PKR was 122;
                                               cbCust2: TID := 22;  // PKR was 132;
                                               cbCust3: TID := 222;
                                               cbCust4: TID := 232;
                                               cbCust5: TID := 242;
                                               cbCust6: TID := 252;
                                             end; // case custButtonNo
                                           end;
                      jdtPurchaseApps: begin
                                         case custButtonNo of
                                           cbCust1: TID := 13;
                                           cbCust2: TID := 23;
                                           cbCust3: TID := 223;
                                           cbCust4: TID := 233;
                                           cbCust5: TID := 243;
                                           cbCust6: TID := 253;
                                         end; // case custButtonNo
                                       end;
                      jdtPurchaseAppHist: begin
                                            case custButtonNo of
                                              cbCust1: TID := 14;
                                              cbCust2: TID := 24;
                                              cbCust3: TID := 224;
                                              cbCust4: TID := 234;
                                              cbCust5: TID := 244;
                                              cbCust6: TID := 254;
                                            end; // case custButtonNo
                                          end;
                      jdtSalesApps: begin
                                      case custButtonNo of
                                        cbCust1: TID := 15;
                                        cbCust2: TID := 25;
                                        cbCust3: TID := 225;
                                        cbCust4: TID := 235;
                                        cbCust5: TID := 245;
                                        cbCust6: TID := 255;
                                      end; // case custButtonNo
                                    end;
                      jdtSalesAppHist: begin
                                         case custButtonNo of
                                           cbCust1: TID := 16;
                                           cbCust2: TID := 26;
                                           cbCust3: TID := 226;
                                           cbCust4: TID := 236;
                                           cbCust5: TID := 246;
                                           cbCust6: TID := 256;
                                         end; // case custButtonNo
                                       end;
                      jdtPLRetentions: begin
                                         case custButtonNo of
                                           cbCust1: TID := 17;  // PKR was 127;
                                           cbCust2: TID := 27;  // PKR was 137;
                                           cbCust3: TID := 227;
                                           cbCust4: TID := 237;
                                           cbCust5: TID := 247;
                                           cbCust6: TID := 257;
                                         end; // case custButtonNo
                                       end;
                      jdtSLRetentions: begin
                                         case custButtonNo of
                                           cbCust1: TID := 18;  // PKR was 128;
                                           cbCust2: TID := 28;  // PKR was 138;
                                           cbCust3: TID := 228;
                                           cbCust4: TID := 238;
                                           cbCust5: TID := 248;
                                           cbCust6: TID := 258;
                                         end; // case custButtonNo
                                       end;
                    end; // case TabNumbe
                  end;

    //..........................................................................
    fpStockRecord: begin   // TStockRec in StockU.pas
                     case TStockRecordTabs(TabNumber) of
                       srtMain: begin
                                  case custButtonNo of
                                    cbCust1: TID :=   1;
                                    cbCust2: TID :=  11;
                                    cbCust3: TID := 221;
                                    cbCust4: TID := 231;
                                    cbCust5: TID := 241;
                                    cbCust6: TID := 251;
                                  end; // case custButtonNo
                                end;
                       srtDefaults: begin
                                      case custButtonNo of
                                        cbCust1: TID :=   2;
                                        cbCust2: TID :=  12;
                                        cbCust3: TID := 222;
                                        cbCust4: TID := 232;
                                        cbCust5: TID := 242;
                                        cbCust6: TID := 252;
                                      end; // case custButtonNo
                                    end;
                       srtVatWeb: begin
                                    case custButtonNo of
                                      cbCust1: TID :=   9;
                                      cbCust2: TID :=  19;
                                      cbCust3: TID := 229;
                                      cbCust4: TID := 239;
                                      cbCust5: TID := 249;
                                      cbCust6: TID := 259;
                                    end; // case custButtonNo
                                  end;
                       srtWOP: begin
                                 case custButtonNo of
                                   cbCust1: TID :=  10;
                                   cbCust2: TID :=  20;
                                   cbCust3: TID := 228;
                                   cbCust4: TID := 238;
                                   cbCust5: TID := 248;
                                   cbCust6: TID := 258;
                                 end; // case custButtonNo
                               end;
                       srtReturns: begin
                                     case custButtonNo of
                                       cbCust1: TID :=   3;
                                       cbCust2: TID :=  13;
                                       cbCust3: TID := 223;
                                       cbCust4: TID := 233;
                                       cbCust5: TID := 243;
                                       cbCust6: TID := 253;
                                     end; // case custButtonNo
                                   end;
                       srtNotes: begin
// No custom buttons displayed on Notes tab.
//                                   case custButtonNo of
//                                     cbCust1: TID :=   3;
//                                     cbCust2: TID :=  13;
//                                     cbCust3: TID := 223;
//                                     cbCust4: TID := 233;
//                                     cbCust5: TID := 243;
//                                     cbCust6: TID := 253;
//                                   end; // case custButtonNo
                                 end;
                       srtQuantityBreaks: begin
                                            case custButtonNo of
                                              cbCust1: TID :=   4;
                                              cbCust2: TID :=  14;
                                              cbCust3: TID := 224;
                                              cbCust4: TID := 234;
                                              cbCust5: TID := 244;
                                              cbCust6: TID := 254;
                                            end; // case custButtonNo
                                          end;
                       srtMultiBuyDiscounts: begin
                                               case custButtonNo of
                                                 cbCust1: TID :=  21;
                                                 cbCust2: TID :=  31;
                                                 cbCust3: TID := 261;
                                                 cbCust4: TID := 271;
                                                 cbCust5: TID := 281;
                                                 cbCust6: TID := 291;
                                               end; // case custButtonNo
                                             end;
                       srtLedger: begin
                                    case custButtonNo of
                                      cbCust1: TID :=   5;
                                      cbCust2: TID :=  15;
                                      cbCust3: TID := 225;
                                      cbCust4: TID := 235;
                                      cbCust5: TID := 245;
                                      cbCust6: TID := 255;
                                    end; // case custButtonNo
                                  end;
                       srtValue: begin
                                   case custButtonNo of
                                     cbCust1: TID :=   6;
                                     cbCust2: TID :=  16;
                                     cbCust3: TID := 226;
                                     cbCust4: TID := 236;
                                     cbCust5: TID := 246;
                                     cbCust6: TID := 256;
                                   end; // case custButtonNo
                                 end;
                       srtBuild: begin
                                   case custButtonNo of
                                     cbCust1: TID :=   7;
                                     cbCust2: TID :=  17;
                                     cbCust3: TID := 227;
                                     cbCust4: TID := 237;
                                     cbCust5: TID := 247;
                                     cbCust6: TID := 257;
                                   end; // case custButtonNo
                                 end;
                       srtSerial: begin
                                    case custButtonNo of
                                      cbCust1: TID :=   8;
                                      cbCust2: TID :=  18;
                                      cbCust3: TID := 230;
                                      cbCust4: TID := 240;
                                      cbCust5: TID := 250;
                                      cbCust6: TID := 260;
                                    end; // case custButtonNo
                                  end;
                       srtBins: begin
                                  case custButtonNo of
                                    cbCust1: TID :=   8;
                                    cbCust2: TID :=  18;
                                    cbCust3: TID := 230;
                                    cbCust4: TID := 240;
                                    cbCust5: TID := 250;
                                    cbCust6: TID := 260;
                                  end; // case custButtonNo
                                end;
                             end; // case TabNumber
                           end;

                           //...................................................
    fpSalesTransaction: begin   // TSalesTBody in SaleTx2U.pas
                          case State of
                            rsEdit: begin
                                      case custButtonNo of
                                        cbCust1: TID :=   3;
                                        cbCust2: TID :=   4;
                                        cbCust3: TID := 441;
                                        cbCust4: TID := 442;
                                        cbCust5: TID := 443;
                                        cbCust6: TID := 444;
                                      end; // case custButtonNo
                                    end;
                            rsView: begin
                                      case custButtonNo of
                                        cbCust1: TID :=   3;
                                        cbCust2: TID :=   4;
                                        cbCust3: TID := 541;
                                        cbCust4: TID := 542;
                                        cbCust5: TID := 543;
                                        cbCust6: TID := 544;
                                      end; // case custButtonNo
                                    end;
                          end; // case State
                        end;

    fpPurchaseTransaction: begin   // TSalesTBody in SaleTx2U.pas
                             case State of
                               rsEdit: begin
                                         case custButtonNo of
                                           cbCust1: TID :=   5;
                                           cbCust2: TID :=   6;
                                           cbCust3: TID := 445;
                                           cbCust4: TID := 446;
                                           cbCust5: TID := 447;
                                           cbCust6: TID := 448;
                                         end; // case custButtonNo
                                       end;
                               rsView: begin
                                         case custButtonNo of
                                           cbCust1: TID :=   5;
                                           cbCust2: TID :=   6;
                                           cbCust3: TID := 545;
                                           cbCust4: TID := 546;
                                           cbCust5: TID := 547;
                                           cbCust6: TID := 548;
                                         end; // case custButtonNo
                                       end;
                             end; // case State
                           end;

                           //...................................................
    fpStockAdjustment: begin   // TStkAdj   in StkAdjU.pas
                         case State of
                           rsEdit: begin
                                     case custButtonNo of
                                       cbCust1: TID :=  16;
                                       cbCust2: TID :=  17;
                                       cbCust3: TID := 451;
                                       cbCust4: TID := 452;
                                       cbCust5: TID := 453;
                                       cbCust6: TID := 454;
                                     end; // case custButtonNo
                                   end;
                           rsView: begin
                                     case custButtonNo of
                                       cbCust1: TID :=  16;  //PR: 26/02/2013 ABSEXCH-14080 Revert button 1 & 2 to original text id
                                       cbCust2: TID :=  17;
                                       cbCust3: TID := 551;
                                       cbCust4: TID := 552;
                                       cbCust5: TID := 553;
                                       cbCust6: TID := 554;
                                     end; // case custButtonNo
                                   end;
                         end; // case State
                       end;

                           //...................................................
    fpWorksOrder: begin   // TWOR      in Wordoc2U.pas
                    case State of
                      rsEdit: begin
                                case custButtonNo of
                                  cbCust1: TID :=  30;
                                  cbCust2: TID :=  31;
                                  cbCust3: TID := 455;
                                  cbCust4: TID := 456;
                                  cbCust5: TID := 457;
                                  cbCust6: TID := 458;
                                end; // case custButtonNo
                              end;
                      rsView: begin
                                case custButtonNo of
                                  cbCust1: TID :=  30;  //PR: 26/02/2013 ABSEXCH-14080 Revert button 1 & 2 to original text id
                                  cbCust2: TID :=  31;
                                  cbCust3: TID := 555;
                                  cbCust4: TID := 556;
                                  cbCust5: TID := 557;
                                  cbCust6: TID := 558;
                                end; // case custButtonNo
                              end;
                    end; // case State
                  end;

    // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
    fpWorksOrderDaybook: begin   // TDayBk1   in DayBk2.pas
                     case TDayBookTabs(TabNumber) of
                       dbtMain: begin
                            case custButtonNo of
                              cbCust1: TID := 561;
                              cbCust2: TID := 562;
                              cbCust3: TID := 563;
                              cbCust4: TID := 564;
                              cbCust5: TID := 565;
                              cbCust6: TID := 566;
                            end; // case custButtonNo
                          end;
                       dbtHistory: begin
                            case custButtonNo of
                              cbCust1: TID := 571;
                              cbCust2: TID := 572;
                              cbCust3: TID := 573;
                              cbCust4: TID := 574;
                              cbCust5: TID := 575;
                              cbCust6: TID := 576;
                            end; // case custButtonNo
                          end;
                     end; // case TabNumber
                   end;

  end; // case FormPurpose

  Result := TID;
end;



//==============================================================================
// Get the Window ID based on the Form Purpose
function TCustomButtonHandler.GetWindowID(FormPurpose : TFormPurpose) : integer;
begin
  case FormPurpose of
    fpInvalid             : Result := -1;
    fpCustomerList        : Result := 1000;
    fpSupplierList        : Result := 1000;
    fpCustomerRecord      : Result := 1000;
    fpSupplierRecord      : Result := 1000;
    fpJobRecord           : Result := 5000;
    fpSalesDaybook        : Result := 2000;
    fpPurchaseDaybook     : Result := 2000;
    fpNominalDaybook      : Result := 2000;
    fpJobDaybook          : Result := 5000;
    fpStockRecord         : Result := 3000;
    fpSalesTransaction    : Result := 2000;
    fpPurchaseTransaction : Result := 2000;
    fpStockAdjustment     : Result := 2000;
    fpWorksOrder          : Result := 2000;
    // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
    fpWorksOrderDaybook   : Result := 2000;
  else
    Result := -1;
  end; //case FormPurpose
end;

//==============================================================================
//PR: 03/06/2013 ABSEXCH-14318 Made ExLocal a var parameter so that changes get passed back.
function TCustomButtonHandler.CustomButtonClick(FormPurpose : TFormPurpose;
                                                 TabNumber   : Integer;
                                                 State       : TRecordState;
                                                 ButtonNo    : Integer;
                                                 var ExLocal     : TdExLocal)
                                                 : Boolean;
var
  eventID  : integer;
  windowID : integer;
begin
  eventID := GetEventID(FormPurpose,
                        TabNumber,
                        State,
                        ButtonNo);
  windowID := GetWindowID(FormPurpose);

  Result := ExecuteCustBtn(windowID, eventID, ExLocal);
end;

//==============================================================================
//PR: 22/03/2017 ABSEXCH-18143 v2017 R1 Function to resolve Ids for new custom buttons
function TCustomButtonHandler.TraderCustomerButtonId(const FormPurpose : TFormPurpose;
                                                     const TabNumber, ButtonNumber: Integer): Integer;
var
  BaseIdx : Integer;
begin
{Ids start at 300 for customer and 500 for supplier, add 20 for each button after the first, add
 1 for each tab after the first. Should never be called for Ledger tab as those buttons have IDs
 which don't fit the formula.
}
  if FormPurpose = fpCustomerRecord then
    BaseIdx := 300
  else
    BaseIdx := 500;

  Result := BaseIdx + ((ButtonNumber - 1) * 20) + TabNumber;
end;

initialization
  // Instantiate the custom button handler
  custBtnHandler := TCustomButtonHandler.Create;

finalization
  // free up the custom button handler
  custBtnHandler.Free;

end.
