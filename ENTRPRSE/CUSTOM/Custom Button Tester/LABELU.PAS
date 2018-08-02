unit LabelU;

interface

Uses Classes, Dialogs, Graphics, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

implementation

Uses ChainU, CustWinU;


{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
//  Result := (WindowId = wiTransaction);

  Result := (WindowId = wiAccount)     or
            (WindowId = wiTransaction) or
            (WindowId = wiStock)       or
            (WindowId = wiJobRec);

  If (Not Result) Then
    { Not Customised - pass on to next customisation DLL }
    Result := DLLChain.EntDoCustomText(WindowId);
End;


{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Begin { EntGetCustomText }
  With CustomText Do
  Begin
    // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
    case WindowId of
      wiAccount:      begin // 1000
                        case TextId of
                          // Traders.  (custlst2.pas)
                          // Custom Button 1 on Customer/Supplier List event
                          1   : Caption := 'Cust List 1';
                          3   : Caption := 'Supp List 1';
                          // Custom Button 2 on Customer List event
                          2   : Caption := 'Cust List 2';
                          4   : Caption := 'Supp List 2';
                          // Custom Button 3 on Customer List event
                          141 : Caption := 'Cust List 3';
                          151 : Caption := 'Supp List 3';
                          // Custom Button 4 on Customer List event
                          142 : Caption := 'Cust List 4';
                          152 : Caption := 'Supp List 4';
                          // Custom Button 5 on Customer List event
                          143 : Caption := 'Cust List 5';
                          153 : Caption := 'Supp List 5';
                          // Custom Button 6 on Customer List event
                          144 : Caption := 'Cust List 6';
                          154 : Caption := 'Supp List 6';

                          // Trader Records.  (custr3u.pas)
                          // Custom Button 1 on Customer/Supplier Ledger event
                          120 : Caption := 'Cust Ledger 1';
                          130 : Caption := 'Supp Ledger 1';
                          // Custom Button 2 on Customer/Supplier Ledger event
                          121 : Caption := 'Cust Ledger 2';
                          131 : Caption := 'Supp Ledger 2';
                          // Custom Button 3 on Customer/Supplier Ledger event
                          145 : Caption := 'Cust Ledger 3';
                          155 : Caption := 'Supp Ledger 3';
                          // Custom Button 4 on Customer/Supplier Ledger event
                          146 : Caption := 'Cust Ledger 4';
                          156 : Caption := 'Supp Ledger 4';
                          // Custom Button 5 on Customer/Supplier Ledger event
                          147 : Caption := 'Cust Ledger 5';
                          157 : Caption := 'Supp Ledger 5';
                          // Custom Button 6 on Customer/Supplier Ledger event
                          148 : Caption := 'Cust Ledger 6';
                          158 : Caption := 'Supp Ledger 6';
                        else
                          Caption := 'Meh!';
                        end; // case TextId
                      end;
                      
      wiTransaction:  begin // 2000
                        Case TextId Of
                          // Daybooks.  (daybk2.pas)
                          //  10-15  Custom Button 1 on Sales daybook event - 16-19  Reserved for Custom Button 1 on future tabs 6-9
                          10  : Caption := 'SDbk/Main/1';
                          11  : Caption := 'SDbk/Quotes/1';
                          12  : Caption := 'SDbk/Auto/1';
                          13  : Caption := 'SDbk/Histry/1';
                          14  : Caption := 'SDbk/Orders/1';
                          15  : Caption := 'SDbk/OrdHis/1';
                          //  20-25  Custom Button 2 on Sales daybook event - 26-29  Reserved for Custom Button 2 on future tabs 6-9
                          20  : Caption := 'SDbk/Main/2';
                          21  : Caption := 'SDbk/Quotes/2';
                          22  : Caption := 'SDbk/Auto/2';
                          23  : Caption := 'SDbk/Histry/2';
                          24  : Caption := 'SDbk/Orders/2';
                          25  : Caption := 'SDbk/OrdHis/2';
                          // Custom Button 3 on Sales daybook event
                          361 : Caption := 'SDbk/Main/3';
                          362 : Caption := 'SDbk/Quotes/3';
                          363 : Caption := 'SDbk/Auto/3';
                          364 : Caption := 'SDbk/Histry/3';
                          365 : Caption := 'SDbk/Orders/3';
                          366 : Caption := 'SDbk/OrdHis/3';
                          // Custom Button 4 on Sales daybook event
                          371 : Caption := 'SDbk/Main/4';
                          372 : Caption := 'SDbk/Quotes/4';
                          373 : Caption := 'SDbk/Auto/4';
                          374 : Caption := 'SDbk/Histry/4';
                          375 : Caption := 'SDbk/Orders/4';
                          376 : Caption := 'SDbk/OrdHis/4';
                          // Custom Button 5 on Sales daybook event
                          381 : Caption := 'SDbk/Main/5';
                          382 : Caption := 'SDbk/Quotes/5';
                          383 : Caption := 'SDbk/Auto/5';
                          384 : Caption := 'SDbk/Histry/5';
                          385 : Caption := 'SDbk/Orders/5';
                          386 : Caption := 'SDbk/OrdHis/5';
                          // Custom Button 6 on Sales daybook event
                          391 : Caption := 'SDbk/Main/6';
                          392 : Caption := 'SDbk/Quotes/6';
                          393 : Caption := 'SDbk/Auto/6';
                          394 : Caption := 'SDbk/Histry/6';
                          395 : Caption := 'SDbk/Orders/6';
                          396 : Caption := 'SDbk/OrdHis/6';

                          //----------------------------------------------------
                          // 110-115  Custom Button 1 on Purchase daybook event - 116-119  Reserved for Custom Button 1 on future tabs 6-9
                          110 : Caption := 'PDbk/Main/1';
                          111 : Caption := 'PDbk/Quotes/1';
                          112 : Caption := 'PDbk/Auto/1';
                          113 : Caption := 'PDbk/Histry/1';
                          114 : Caption := 'PDbk/Orders/1';
                          115 : Caption := 'PDbk/OrdHis/1';
                          // 120-125  Custom Button 2 on Purchase daybook event - 126-129  Reserved for Custom Button 2 on future tabs 6-9
                          120 : Caption := 'PDbk/Main/2';
                          121 : Caption := 'PDbk/Quotes/2';
                          122 : Caption := 'PDbk/Auto/2';
                          123 : Caption := 'PDbk/Histry/2';
                          124 : Caption := 'PDbk/Orders/2';
                          125 : Caption := 'PDbk/OrdHis/2';
                          // Custom Button 3 on Purchase Daybook event
                          401 : Caption := 'PDbk/Main/3';
                          402 : Caption := 'PDbk/Quotes/3';
                          403 : Caption := 'PDbk/Auto/3';
                          404 : Caption := 'PDbk/Histry/3';
                          405 : Caption := 'PDbk/Orders/3';
                          406 : Caption := 'PDbk/OrdHis/3';
                          // Custom Button 4 on Purchase Daybook event
                          411 : Caption := 'PDbk/Main/4';
                          412 : Caption := 'PDbk/Quotes/4';
                          413 : Caption := 'PDbk/Auto/4';
                          414 : Caption := 'PDbk/Histry/4';
                          415 : Caption := 'PDbk/Orders/4';
                          416 : Caption := 'PDbk/OrdHis/4';
                          // Custom Button 5 on Purchase Daybook event
                          421 : Caption := 'PDbk/Main/5';
                          422 : Caption := 'PDbk/Quotes/5';
                          423 : Caption := 'PDbk/Auto/5';
                          424 : Caption := 'PDbk/Histry/5';
                          425 : Caption := 'PDbk/Orders/5';
                          426 : Caption := 'PDbk/OrdHis/5';
                          // Custom Button 6 on Purchase Daybook event
                          431 : Caption := 'PDbk/Main/6';
                          432 : Caption := 'PDbk/Quotes/6';
                          433 : Caption := 'PDbk/Auto/6';
                          434 : Caption := 'PDbk/Histry/6';
                          435 : Caption := 'PDbk/Orders/6';
                          436 : Caption := 'PDbk/OrdHis/6';

                          //----------------------------------------------------
                          // 301-306  Custom Button 1 on Nominal Daybooks (Tabs 1-6) - 307-310  Reserved for Custom Button 1 on future tabs 7-10
                          301 : Caption := 'NDbk/Main/1';
                          302 : Caption := 'NDbk/Quotes/1';
                          303 : Caption := 'NDbk/Auto/1';
                          304 : Caption := 'NDbk/Histry/1';
                          305 : Caption := 'NDbk/Orders/1';
                          306 : Caption := 'NDbk/OrdHis/1';
                          // 311-316  Custom Button 2 on Nominal Daybooks (Tabs 1-6) - 317-320  Reserved for Custom Button 2 on future tabs 7-10
                          311 : Caption := 'NDbk/Main/2';
                          312 : Caption := 'NDbk/Quotes/2';
                          313 : Caption := 'NDbk/Auto/2';
                          314 : Caption := 'NDbk/Histry/2';
                          315 : Caption := 'NDbk/Orders/2';
                          316 : Caption := 'NDbk/OrdHis/2';
                          // Custom Button 3 on Nominal Daybook event
                          321 : Caption := 'NDbk/Main/3';
                          322 : Caption := 'NDbk/Quotes/3';
                          323 : Caption := 'NDbk/Auto/3';
                          324 : Caption := 'NDbk/Histry/3';
                          325 : Caption := 'NDbk/Orders/3';
                          326 : Caption := 'NDbk/OrdHis/3';
                          // Custom Button 4 on Nominal Daybook event
                          331 : Caption := 'NDbk/Main/4';
                          332 : Caption := 'NDbk/Quotes/4';
                          333 : Caption := 'NDbk/Auto/4';
                          334 : Caption := 'NDbk/Histry/4';
                          335 : Caption := 'NDbk/Orders/4';
                          336 : Caption := 'NDbk/OrdHis/4';
                          // Custom Button 5 on Nominal Daybook event
                          341 : Caption := 'NDbk/Main/5';
                          342 : Caption := 'NDbk/Quotes/5';
                          343 : Caption := 'NDbk/Auto/5';
                          344 : Caption := 'NDbk/Histry/5';
                          345 : Caption := 'NDbk/Orders/5';
                          346 : Caption := 'NDbk/OrdHis/5';
                          // Custom Button 6 on Nominal Daybook event
                          351 : Caption := 'NDbk/Main/6';
                          352 : Caption := 'NDbk/Quotes/6';
                          353 : Caption := 'NDbk/Auto/6';
                          354 : Caption := 'NDbk/Histry/6';
                          355 : Caption := 'NDbk/Orders/6';
                          356 : Caption := 'NDbk/OrdHis/6';

                          //====================================================
                          // (saletx2u.pas)
                          // Custom Button 1
                          3   : Caption := 'Sales/1';
                          5   : Caption := 'Purchases/1';
                          // Custom Button 2
                          4   : Caption := 'Sales/2';
                          6   : Caption := 'Purchases/2';
                          // Custom Button 3
                          441 : Caption := 'Sales/3';
                          445 : Caption := 'Purchases/3';
                          // Custom Button 4
                          442 : Caption := 'Sales/4';
                          446 : Caption := 'Purchases/4';
                          // Custom Button 5
                          443 : Caption := 'Sales/5';
                          447 : Caption := 'Purchases/5';
                          // Custom Button 6
                          444 : Caption := 'Sales/6';
                          448 : Caption := 'Purchases/6';

                          //====================================================
                          // (stkadju.pas)
                          // Custom Button 1 on Stock Adjustment
                          16  : Caption := 'StkAdj/Edt/1';
                          // Custom Button 2 on Stock Adjustment
                          17  : Caption := 'StkAdj/Edt/2';
                          // Custom Button 3 on Stock Adjustment
                          451 : Caption := 'StkAdj/Edt/3';
                          // Custom Button 4 on Stock Adjustment
                          452 : Caption := 'StkAdj/Edt/4';
                          // Custom Button 5 on Stock Adjustment
                          453 : Caption := 'StkAdj/Edt/5';
                          // Custom Button 6 on Stock Adjustment
                          454 : Caption := 'StkAdj/Edt/6';
                          
                          // Custom Button 1 on Stock Adjustment
                          116 : Caption := 'StkAdj/Vw/1';
                          // Custom Button 2 on Stock Adjustment
                          117 : Caption := 'StkAdj/Vw/2';
                          // Custom Button 3 on Stock Adjustment
                          551 : Caption := 'StkAdj/Vw/3';
                          // Custom Button 4 on Stock Adjustment
                          552 : Caption := 'StkAdj/Vw/4';
                          // Custom Button 5 on Stock Adjustment
                          553 : Caption := 'StkAdj/Vw/5';
                          // Custom Button 6 on Stock Adjustment
                          554 : Caption := 'StkAdj/Vw/6';
                          
                          //====================================================
                          // (wordoc2u.pas)
                          // Custom Button 1 on Works Order
                          30  : Caption := 'WOR 1';
                          // Custom Button 2 on Works Order
                          31  : Caption := 'WOR 2';
                          // Custom Button 3 on Works Order
                          455 : Caption := 'WOR Edit/3';
                          555 : Caption := 'WOR View/3';
                          // Custom Button 4 on Works Order
                          456 : Caption := 'WOR Edit/4';
                          556 : Caption := 'WOR View/4';
                          // Custom Button 5 on Works Order
                          457 : Caption := 'WOR Edit/5';
                          557 : Caption := 'WOR View/5';
                          // Custom Button 6 on Works Order
                          458 : Caption := 'WOR Edit/6';
                          558 : Caption := 'WOR View/6';

                          // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
                          // (daybk2.pas)
                          561 : Caption := 'WDbk/Main/1';   // Custom Button 1 on Works Order daybook Main tab
                          562 : Caption := 'WDbk/Main/2';   // Custom Button 2 on Works Order daybook Main tab
                          563 : Caption := 'WDbk/Main/3';   // Custom Button 3 on Works Order daybook Main tab
                          564 : Caption := 'WDbk/Main/4';   // Custom Button 4 on Works Order daybook Main tab
                          565 : Caption := 'WDbk/Main/5';   // Custom Button 5 on Works Order daybook Main tab
                          566 : Caption := 'WDbk/Main/6';   // Custom Button 6 on Works Order daybook Main tab

                          571 : Caption := 'WDbk/Hist/1';   // Custom Button 1 on Works Order daybook History tab
                          572 : Caption := 'WDbk/Hist/2';   // Custom Button 2 on Works Order daybook History tab
                          573 : Caption := 'WDbk/Hist/3';   // Custom Button 3 on Works Order daybook History tab
                          574 : Caption := 'WDbk/Hist/4';   // Custom Button 4 on Works Order daybook History tab
                          575 : Caption := 'WDbk/Hist/5';   // Custom Button 5 on Works Order daybook History tab
                          576 : Caption := 'WDbk/Hist/6';   // Custom Button 6 on Works Order daybook History tab
                        else
                          Caption := 'Meh!';
                        end; // case TextId
                      end;
                     
      wiStockDetail:  begin // 3001
                        Case TextId Of
                          // Custom Button 1 on Stock (stocku.pas)
                          // Tabs 0..12
                          1   : Caption := 'Stk/Main/1';
                          2   : Caption := 'Stk/Deflts/1';
                          9   : Caption := 'Stk/VATWeb/1';
                          10  : Caption := 'Stk/WOP /1';
                          3   : Caption := 'Stk/Retrns/1';
//                          3   : Caption := 'Stk/Notes/1';
                          4   : Caption := 'Stk/QtyBrk/1';
                          21  : Caption := 'Stk/MultBD/1';
                          5   : Caption := 'Stk/Ledger/1';
                          6   : Caption := 'Stk/Value/1';
                          7   : Caption := 'Stk/Build/1';
                          8   : Caption := 'Stk/Serial/1';

                          // Custom Button 2 on Stock (stocku.pas)
                          11  : Caption := 'Stk/Main/2';
                          12  : Caption := 'Stk/Deflts/2';
                          19  : Caption := 'Stk/VATWeb/2';
                          20  : Caption := 'Stk/WOP /2';
                          13  : Caption := 'Stk/Retrns/2';
//                          13  : Caption := 'Stk/Notes/2';
                          14  : Caption := 'Stk/QtyBrk/2';
                          31  : Caption := 'Stk/MultBD/2';
                          15  : Caption := 'Stk/Ledger/2';
                          16  : Caption := 'Stk/Value/2';
                          17  : Caption := 'Stk/Build/2';
                          18  : Caption := 'Stk/Serial/2';

                          // Custom Button 3 on Stock (stocku.pas)
                          221 : Caption := 'Stk/Main/3';
                          222 : Caption := 'Stk/Deflts/3';
                          229 : Caption := 'Stk/VATWeb/3';
                          228 : Caption := 'Stk/WOP /3';
                          223 : Caption := 'Stk/Retrns/3';
                          // No entry for Notes tab
                          224 : Caption := 'Stk/QtyBrk/3';
                          261 : Caption := 'Stk/MultBD/3';
                          225 : Caption := 'Stk/Ledger/3';
                          226 : Caption := 'Stk/Value/3';
                          227 : Caption := 'Stk/Build/3';
                          230 : Caption := 'Stk/Serial/3';

                          // Custom Button 4 on Stock (stocku.pas)
                          231 : Caption := 'Stk/Main/4';
                          232 : Caption := 'Stk/Deflts/4';
                          239 : Caption := 'Stk/VATWeb/4';
                          238 : Caption := 'Stk/WOP /4';
                          233 : Caption := 'Stk/Retrns/4';
                          // No entry for Notes tab
                          234 : Caption := 'Stk/QtyBrk/4';
                          271 : Caption := 'Stk/MultBD/4';
                          235 : Caption := 'Stk/Ledger/4';
                          236 : Caption := 'Stk/Value/4';
                          237 : Caption := 'Stk/Build/4';
                          240 : Caption := 'Stk/Serial/4';

                          // Custom Button 5 on Stock (stocku.pas)
                          241 : Caption := 'Stk/Main/5';
                          242 : Caption := 'Stk/Deflts/5';
                          249 : Caption := 'Stk/VATWeb/5';
                          248 : Caption := 'Stk/WOP /5';
                          243 : Caption := 'Stk/Retrns/5';
                          // No entry for Notes tab
                          244 : Caption := 'Stk/QtyBrk/5';
                          281 : Caption := 'Stk/MultBD/5';
                          245 : Caption := 'Stk/Ledger/5';
                          246 : Caption := 'Stk/Value/5';
                          247 : Caption := 'Stk/Build/5';
                          250 : Caption := 'Stk/Serial/5';

                          // Custom Button 6 on Stock (stocku.pas)
                          251 : Caption := 'Stk/Main/6';
                          252 : Caption := 'Stk/Deflts/6';
                          259 : Caption := 'Stk/VATWeb/6';
                          258 : Caption := 'Stk/WOP /6';
                          253 : Caption := 'Stk/Retrns/6';
                          // No entry for Notes tab
                          254 : Caption := 'Stk/QtyBrk/6';
                          291 : Caption := 'Stk/MultBD/6';
                          255 : Caption := 'Stk/Ledger/6';
                          256 : Caption := 'Stk/Value/6';
                          257 : Caption := 'Stk/Build/6';
                          260 : Caption := 'Stk/Serial/6';
                        else
                         Caption := 'Meh!';
                        end; // case TextId
                      end;

      wiJobRec:       begin // 5000
                        Case TextId Of
                        // NOTE. Due to a clash of Window ID/Text ID combinations
                        // on the Job Record and Job Daybook forms, the captions
                        // for Custom Buttons 1 and 2 are common to both forms.
                        // They cannot be changed as they may already be in use.
                          // Custom Button 1 on Job Records (jobmn2u.pas)
                          // Custom Button 1 on Job Daybook (jobdbk2u.pas)
                          10  : Caption := 'Job/Text 10';
                          11  : Caption := 'Job/Text 11';
                          12  : Caption := 'Job/Text 12';
                          13  : Caption := 'Job/Text 13';
                          14  : Caption := 'Job/Text 14';
                          // Custom Button 2 on Job Records (jobmn2u.pas)
                          // Custom Button 2 on Job Daybook (jobdbk2u.pas)
                          20  : Caption := 'Job/Text 20';
                          21  : Caption := 'Job/Text 21';
                          22  : Caption := 'Job/Text 22';
                          23  : Caption := 'Job/Text 23';
                          24  : Caption := 'Job/Text 24';
                          // Custom Button 3 on Job Records (jobmn2u.pas)
                          140 : Caption := 'Job/Main/3';
                          141 : Caption := 'Job/Notes/3';
                          142 : Caption := 'Job/Ledger/3';
                          143 : Caption := 'Job/PurRet/3';
                          144 : Caption := 'Job/SlsRet/3';
                          // Custom Button 4 on Job Records (jobmn2u.pas)
                          150 : Caption := 'Job/Main/4';
                          151 : Caption := 'Job/Notes/4';
                          152 : Caption := 'Job/Ledger/4';
                          153 : Caption := 'Job/PurRet/4';
                          154 : Caption := 'Job/SlsRet/4';
                          // Custom Button 5 on Job Records (jobmn2u.pas)
                          160 : Caption := 'Job/Main/5';
                          161 : Caption := 'Job/Notes/5';
                          162 : Caption := 'Job/Ledger/5';
                          163 : Caption := 'Job/PurRet/5';
                          164 : Caption := 'Job/SlsRet/5';
                          // Custom Button 6 on Job Records (jobmn2u.pas)
                          170 : Caption := 'Job/Main/6';
                          171 : Caption := 'Job/Notes/6';
                          172 : Caption := 'Job/Ledger/6';
                          173 : Caption := 'Job/PurRet/6';
                          174 : Caption := 'Job/SlsRet/6';
                       
                          //----------------------------------------------------
                          // Custom Button 1 on Job Daybook (jobdbk2u.pas)
                           17 : Caption := 'JDbk/PLRet/1';
                           18 : Caption := 'JDbk/SLRet/1';
                          // Custom Button 2 on Job Daybook (jobdbk2u.pas)
                           27 : Caption := 'JDbk/PLRet/2';
                           28 : Caption := 'JDbk/SLRet/2';
                          // Custom Button 3 on Job Daybook (jobdbk2u.pas)
                          220 : Caption := 'JDbk/PrePo/3';
                          221 : Caption := 'JDbk/TimSh/3';
                          222 : Caption := 'JDbk/TimeH/3';
                          223 : Caption := 'JDbk/PurAp/3';
                          224 : Caption := 'JDbk/PrApH/3';
                          225 : Caption := 'JDbk/SlsAp/3';
                          226 : Caption := 'JDbk/SlApH/3';
                          227 : Caption := 'JDbk/PLRet/3';
                          228 : Caption := 'JDbk/SLRet/3';
                          // Custom Button 4 on Job Daybook (jobdbk2u.pas)
                          230 : Caption := 'JDbk/PrePo/4';
                          231 : Caption := 'JDbk/TimSh/4';
                          232 : Caption := 'JDbk/TimeH/4';
                          233 : Caption := 'JDbk/PurAp/4';
                          234 : Caption := 'JDbk/PrApH/4';
                          235 : Caption := 'JDbk/SlsAp/4';
                          236 : Caption := 'JDbk/SlApH/4';
                          237 : Caption := 'JDbk/PLRet/4';
                          238 : Caption := 'JDbk/SLRet/4';
                          // Custom Button 5 on Job Daybook (jobdbk2u.pas)
                          240 : Caption := 'JDbk/PrePo/5';
                          241 : Caption := 'JDbk/TimSh/5';
                          242 : Caption := 'JDbk/TimeH/5';
                          243 : Caption := 'JDbk/PurAp/5';
                          244 : Caption := 'JDbk/PrApH/5';
                          245 : Caption := 'JDbk/SlsAp/5';
                          246 : Caption := 'JDbk/SlApH/5';
                          247 : Caption := 'JDbk/PLRet/5';
                          248 : Caption := 'JDbk/SLRet/5';
                          // Custom Button 6 on Job Daybook (jobdbk2u.pas)
                          250 : Caption := 'JDbk/PrePo/6';
                          251 : Caption := 'JDbk/TimSh/6';
                          252 : Caption := 'JDbk/TimeH/6';
                          253 : Caption := 'JDbk/PurAp/6';
                          254 : Caption := 'JDbk/PrApH/6';
                          255 : Caption := 'JDbk/SlsAp/6';
                          256 : Caption := 'JDbk/SlApH/6';
                          257 : Caption := 'JDbk/PLRet/6';
                          258 : Caption := 'JDbk/SLRet/6';
                        else
                          Caption := 'Meh!'; // Original MH code.
                        end; // case TextId
                      end;
    else
      { Not customised by this DLL - pass onto next in chain }
      DLLChain.EntGetCustomText (CustomText);
    end;
  end; { with CustomText }
End;  { EntGetCustomText }

end.
