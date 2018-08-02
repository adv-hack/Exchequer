unit HandlerU;

{ Hook Customisation Unit - Allows standard Exchequer behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

{ Following functions required to be Exported by Exchequer }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  CustomHandlersRef : TAbsCustomHandlers;

implementation

Uses Classes, Dialogs, Forms, SysUtils, ChainU, EnableButtonsF, AdvGlowButton;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Exchequer to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  MemStream : TMemoryStream;

  //------------------------------

  Procedure RestoreGraphics (Const LegacyBtn, LiveBtn : TAdvGlowButton);
  Begin // RestoreGraphics
    MemStream.Clear;
    LegacyBtn.Picture.SaveToStream(MemStream);
    LiveBtn.Picture.LoadFromStream(MemStream);

    MemStream.Clear;
    LegacyBtn.HotPicture.SaveToStream(MemStream);
    LiveBtn.HotPicture.LoadFromStream(MemStream);
  End; // RestoreGraphics

  //------------------------------

Begin
  CustomOn := False;

  { Enable Hooks and Set About Message here }
  With CustomHandlers Do
  Begin
    AddAboutString ('----------------------------');
    AddAboutString ('Name : Custom Button Tester v1.0');
    AddAboutString ('');
    AddAboutString (StringOfChar('-',79));
    AddAboutString ('');
  End; // With CustomHandlers

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);

  // Stach reference to hook point configuration object and display the window for twaeking it on the fly
  CustomHandlersRef := CustomHandlers;
  frmEnablecustomButtons := TfrmEnablecustomButtons.Create(Application.MainForm);
  frmEnablecustomButtons.Show;
End;

{ Called by Exchequer to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
  CustomHandlersRef := NIL;
End;

{ Called by Exchequer whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  // 22/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons

  case EventData.WinId of
    wiAccount:      begin // = EnterpriseBase + 1000;
                      case EventData.HandlerId of
                        11  : ShowMessage('Customer List 1');
                        21  : ShowMessage('Supplier List 1');
                        12  : ShowMessage('Customer List 2');
                        22  : ShowMessage('Supplier List 2');
                        141 : ShowMessage('Customer List 3');
                        151 : ShowMessage('Supplier List 3');
                        142 : ShowMessage('Customer List 4');
                        152 : ShowMessage('Supplier List 4');
                        143 : ShowMessage('Customer List 5');
                        153 : ShowMessage('Supplier List 5');
                        144 : ShowMessage('Customer List 6');
                        154 : ShowMessage('Supplier List 6');

                        120 : ShowMessage('Customer Ledger 1');
                        130 : ShowMessage('Supplier Ledger 1');
                        121 : ShowMessage('Customer Ledger 2');
                        131 : ShowMessage('Supplier Ledger 2');
                        145 : ShowMessage('Customer Ledger 3');
                        155 : ShowMessage('Supplier Ledger 3');
                        146 : ShowMessage('Customer Ledger 4');
                        156 : ShowMessage('Supplier Ledger 4');
                        147 : ShowMessage('Customer Ledger 5');
                        157 : ShowMessage('Supplier Ledger 5');
                        148 : ShowMessage('Customer Ledger 6');
                        158 : ShowMessage('Supplier Ledger 6');
                      end; // Case HandlerId
                    end; {case wiAccount}
                    
    wiTransaction:  begin // = EnterpriseBase + 2000;
                      Case EventData.HandlerId Of
                        //  10-15  Custom Button 1 on Sales daybook event - 16-19  Reserved for Custom Button 1 on future tabs 6-9
                        10  : ShowMessage('Sales Daybook/Main/1');
                        11  : ShowMessage('Sales Daybook/Quotes/1');
                        12  : ShowMessage('Sales Daybook/Auto/1');
                        13  : ShowMessage('Sales Daybook/History/1');
                        14  : ShowMessage('Sales Daybook/Orders/1');
                        15  : ShowMessage('Sales Daybook/Order History/1');

                        //  20-25  Custom Button 2 on Sales daybook event - 26-29  Reserved for Custom Button 2 on future tabs 6-9
                        20  : ShowMessage('Sales Daybook/Main/2');
                        21  : ShowMessage('Sales Daybook/Quotes/2');
                        22  : ShowMessage('Sales Daybook/Auto/2');
                        23  : ShowMessage('Sales Daybook/History/2');
                        24  : ShowMessage('Sales Daybook/Orders/2');
                        25  : ShowMessage('Sales Daybook/Order History/2');

                        //  361-366  Custom Button 3 on Sales daybook event
                        361 : ShowMessage('Sales Daybook/Main/3');
                        362 : ShowMessage('Sales Daybook/Quotes/3');
                        363 : ShowMessage('Sales Daybook/Auto/3');
                        364 : ShowMessage('Sales Daybook/History/3');
                        365 : ShowMessage('Sales Daybook/Orders/3');
                        366 : ShowMessage('Sales Daybook/Order History/3');

                        //  371-376  Custom Button 4 on Sales daybook event
                        371 : ShowMessage('Sales Daybook/Main/4');
                        372 : ShowMessage('Sales Daybook/Quotes/4');
                        373 : ShowMessage('Sales Daybook/Auto/4');
                        374 : ShowMessage('Sales Daybook/History/4');
                        375 : ShowMessage('Sales Daybook/Orders/4');
                        376 : ShowMessage('Sales Daybook/Order History/4');

                        //  381-386  Custom Button 5 on Sales daybook event
                        381 : ShowMessage('Sales Daybook/Main/5');
                        382 : ShowMessage('Sales Daybook/Quotes/5');
                        383 : ShowMessage('Sales Daybook/Auto/5');
                        384 : ShowMessage('Sales Daybook/History/5');
                        385 : ShowMessage('Sales Daybook/Orders/5');
                        386 : ShowMessage('Sales Daybook/Order History/5');

                        //  391-396  Custom Button 6 on Sales daybook event
                        391 : ShowMessage('Sales Daybook/Main/6');
                        392 : ShowMessage('Sales Daybook/Quotes/6');
                        393 : ShowMessage('Sales Daybook/Auto/6');
                        394 : ShowMessage('Sales Daybook/History/6');
                        395 : ShowMessage('Sales Daybook/Orders/6');
                        396 : ShowMessage('Sales Daybook/Order History/6');

                        //......................................................
                        // 110-115  Custom Button 1 on Purchase daybook event - 116-119  Reserved for Custom Button 1 on future tabs 6-9
                        110 : ShowMessage('Purchase Daybook/Main/1');
                        111 : ShowMessage('Purchase Daybook/Quotes/1');
                        112 : ShowMessage('Purchase Daybook/Auto/1');
                        113 : ShowMessage('Purchase Daybook/History/1');
                        114 : ShowMessage('Purchase Daybook/Orders/1');
                        115 : ShowMessage('Purchase Daybook/Order History/1');

                        // 120-125  Custom Button 2 on Purchase daybook event - 126-129  Reserved for Custom Button 2 on future tabs 6-9
                        120 : ShowMessage('Purchase Daybook/Main/2');
                        121 : ShowMessage('Purchase Daybook/Quotes/2');
                        122 : ShowMessage('Purchase Daybook/Auto/2');
                        123 : ShowMessage('Purchase Daybook/History/2');
                        124 : ShowMessage('Purchase Daybook/Orders/2');
                        125 : ShowMessage('Purchase Daybook/Order History/2');

                        // 401-406  Custom Button 3 on Purchase daybook event
                        401 : ShowMessage('Purchase Daybook/Main/3');
                        402 : ShowMessage('Purchase Daybook/Quotes/3');
                        403 : ShowMessage('Purchase Daybook/Auto/3');
                        404 : ShowMessage('Purchase Daybook/History/3');
                        405 : ShowMessage('Purchase Daybook/Orders/3');
                        406 : ShowMessage('Purchase Daybook/Order History/3');

                        // 411-416  Custom Button 4 on Purchase daybook event
                        411 : ShowMessage('Purchase Daybook/Main/4');
                        412 : ShowMessage('Purchase Daybook/Quotes/4');
                        413 : ShowMessage('Purchase Daybook/Auto/4');
                        414 : ShowMessage('Purchase Daybook/History/4');
                        415 : ShowMessage('Purchase Daybook/Orders/4');
                        416 : ShowMessage('Purchase Daybook/Order History/4');

                        // 421-426  Custom Button 5 on Purchase daybook event
                        421 : ShowMessage('Purchase Daybook/Main/5');
                        422 : ShowMessage('Purchase Daybook/Quotes/5');
                        423 : ShowMessage('Purchase Daybook/Auto/5');
                        424 : ShowMessage('Purchase Daybook/History/5');
                        425 : ShowMessage('Purchase Daybook/Orders/5');
                        426 : ShowMessage('Purchase Daybook/Order History/5');

                        // 431-436  Custom Button 6 on Purchase daybook event
                        431 : ShowMessage('Purchase Daybook/Main/6');
                        432 : ShowMessage('Purchase Daybook/Quotes/6');
                        433 : ShowMessage('Purchase Daybook/Auto/6');
                        434 : ShowMessage('Purchase Daybook/History/6');
                        435 : ShowMessage('Purchase Daybook/Orders/6');
                        436 : ShowMessage('Purchase Daybook/Order History/6');
                        
                        //......................................................
                        // 301-306  Custom Button 1 on Nominal Daybooks (Tabs 1-6) - 307-310  Reserved for Custom Button 1 on future tabs 7-10
                        301 : ShowMessage('Nominal Daybook/Main/1');
                        302 : ShowMessage('Nominal Daybook/Quotes/1');
                        303 : ShowMessage('Nominal Daybook/Auto/1');
                        304 : ShowMessage('Nominal Daybook/History/1');
                        305 : ShowMessage('Nominal Daybook/Orders/1');
                        306 : ShowMessage('Nominal Daybook/Order History/1');

                        // 311-316  Custom Button 2 on Nominal Daybooks (Tabs 1-6) - 317-320  Reserved for Custom Button 2 on future tabs 7-10
                        311 : ShowMessage('Nominal Daybook/Main/2');
                        312 : ShowMessage('Nominal Daybook/Quotes/2');
                        313 : ShowMessage('Nominal Daybook/Auto/2');
                        314 : ShowMessage('Nominal Daybook/History/2');
                        315 : ShowMessage('Nominal Daybook/Orders/2');
                        316 : ShowMessage('Nominal Daybook/Order History/2');
                        
                        // 321-326  Custom Button 3 on Nominal Daybooks (Tabs 1-6)
                        321 : ShowMessage('Nominal Daybook/Main/3');
                        322 : ShowMessage('Nominal Daybook/Quotes/3');
                        323 : ShowMessage('Nominal Daybook/Auto/3');
                        324 : ShowMessage('Nominal Daybook/History/3');
                        325 : ShowMessage('Nominal Daybook/Orders/3');
                        326 : ShowMessage('Nominal Daybook/Order History/3');

                        // 331-336  Custom Button 4 on Nominal Daybooks (Tabs 1-6)
                        331 : ShowMessage('Nominal Daybook/Main/4');
                        332 : ShowMessage('Nominal Daybook/Quotes/4');
                        333 : ShowMessage('Nominal Daybook/Auto/4');
                        334 : ShowMessage('Nominal Daybook/History/4');
                        335 : ShowMessage('Nominal Daybook/Orders/4');
                        336 : ShowMessage('Nominal Daybook/Order History/4');
                        
                        // 341-346  Custom Button 5 on Nominal Daybooks (Tabs 1-6)
                        341 : ShowMessage('Nominal Daybook/Main/5');
                        342 : ShowMessage('Nominal Daybook/Quotes/5');
                        343 : ShowMessage('Nominal Daybook/Auto/5');
                        344 : ShowMessage('Nominal Daybook/History/5');
                        345 : ShowMessage('Nominal Daybook/Orders/5');
                        346 : ShowMessage('Nominal Daybook/Order History/5');

                        // 341-346  Custom Button 6 on Nominal Daybooks (Tabs 1-6)
                        351 : ShowMessage('Nominal Daybook/Main/6');
                        352 : ShowMessage('Nominal Daybook/Quotes/6');
                        353 : ShowMessage('Nominal Daybook/Auto/6');
                        354 : ShowMessage('Nominal Daybook/History/6');
                        355 : ShowMessage('Nominal Daybook/Orders/6');
                        356 : ShowMessage('Nominal Daybook/Order History/6');

                        //------------------------------------------------------
                        // Sales/Purchases Transactions Custom Button 1 (saletx2u.pas)
                        31  : ShowMessage('Sales/Edit/1');
                        41  : ShowMessage('Purchases/Edit/1');
                        131 : ShowMessage('Sales/View/1');
                        141 : ShowMessage('Purchases/View/1');
                        // Sales/Purchasesases Transactions Custom Button 2 (saletx2u.pas)
                        32  : ShowMessage('Sales/Edit/2');
                        42  : ShowMessage('Purchases/Edit/2');
                        132 : ShowMessage('Sales/View/2');
                        142 : ShowMessage('Purchases/View/2');
                        // Sales/Purchasesases Transactions Custom Button 3 (saletx2u.pas)
                        441 : ShowMessage('Sales/Edit/3');
                        445 : ShowMessage('Purchases/Edit/3');
                        541 : ShowMessage('Sales/View/3');
                        545 : ShowMessage('Purchases/View/3');
                        // Sales/Purchasesases Transactions Custom Button 4 (saletx2u.pas)
                        442 : ShowMessage('Sales/Edit/4');
                        446 : ShowMessage('Purchases/Edit/4');
                        542 : ShowMessage('Sales/View/4');
                        546 : ShowMessage('Purchases/View/4');
                        // Sales/Purchasesases Transactions Custom Button 5 (saletx2u.pas)
                        443 : ShowMessage('Sales/Edit/5');
                        447 : ShowMessage('Purchases/Edit/5');
                        543 : ShowMessage('Sales/View/5');
                        547 : ShowMessage('Purchases/View/5');
                        // Sales/Purchasesases Transactions Custom Button 6 (saletx2u.pas)
                        444 : ShowMessage('Sales/Edit/6');
                        448 : ShowMessage('Purchases/Edit/6');
                        544 : ShowMessage('Sales/View/6');
                        548 : ShowMessage('Purchases/View/6');

                        //------------------------------------------------------
                        // Stock Adjustment Custom Button 1 (stkadju.pas)
                        38  : ShowMessage('Stock Adjustment/Edit/1');
                        138 : ShowMessage('Stock Adjustment/View/1');
                        // Stock Adjustment Custom Button 2 (stkadju.pas)
                        39  : ShowMessage('Stock Adjustment/Edit/2');
                        139 : ShowMessage('Stock Adjustment/View/2');
                        // Stock Adjustment Custom Button 3 (stkadju.pas)
                        451 : ShowMessage('Stock Adjustment/Edit/3');
                        551 : ShowMessage('Stock Adjustment/View/3');
                        // Stock Adjustment Custom Button 4 (stkadju.pas)
                        452 : ShowMessage('Stock Adjustment/Edit/4');
                        552 : ShowMessage('Stock Adjustment/View/4');
                        // Stock Adjustment Custom Button 5 (stkadju.pas)
                        453 : ShowMessage('Stock Adjustment/Edit/5');
                        553 : ShowMessage('Stock Adjustment/View/5');
                        // Stock Adjustment Custom Button 6 (stkadju.pas)
                        454 : ShowMessage('Stock Adjustment/Edit/6');
                        554 : ShowMessage('Stock Adjustment/View/6');

                        //------------------------------------------------------
                        // Works Order Custom Button 1 (wordoc2u.pas)
                        43  : ShowMessage('Works Order/Edit/1');
                        143 : ShowMessage('Works Order/View/1');
                        // Works Order Custom Button 2 (wordoc2u.pas)
                        44  : ShowMessage('Works Order/Edit/2');
                        144 : ShowMessage('Works Order/View/2');
                        // Works Order Custom Button 3 (wordoc2u.pas)
                        455 : ShowMessage('Works Order/Edit/3');
                        555 : ShowMessage('Works Order/View/3');
                        // Works Order Custom Button 4 (wordoc2u.pas)
                        456 : ShowMessage('Works Order/Edit/4');
                        556 : ShowMessage('Works Order/View/4');
                        // Works Order Custom Button 5 (wordoc2u.pas)
                        457 : ShowMessage('Works Order/Edit/5');
                        557 : ShowMessage('Works Order/View/5');
                        // Works Order Custom Button 6 (wordoc2u.pas)
                        458 : ShowMessage('Works Order/Edit/6');
                        558 : ShowMessage('Works Order/View/6');

                        // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
                        // Custom Button 1 on Works Order daybook Main tab
                        561 : ShowMessage('Works Order Daybook/Main/1');
                        // Custom Button 2 on Works Order daybook Main tab
                        562 : ShowMessage('Works Order Daybook/Main/2');
                        // Custom Button 3 on Works Order daybook Main tab
                        563 : ShowMessage('Works Order Daybook/Main/3');
                        // Custom Button 4 on Works Order daybook Main tab
                        564 : ShowMessage('Works Order Daybook/Main/4');
                        // Custom Button 5 on Works Order daybook Main tab
                        565 : ShowMessage('Works Order Daybook/Main/5');
                        // Custom Button 6 on Works Order daybook Main tab
                        566 : ShowMessage('Works Order Daybook/Main/6');

                        // Custom Button 1 on Works Order daybook History tab
                        571 : ShowMessage('Works Order Daybook/History/1');
                        // Custom Button 2 on Works Order daybook History tab
                        572 : ShowMessage('Works Order Daybook/History/2');
                        // Custom Button 3 on Works Order daybook History tab
                        573 : ShowMessage('Works Order Daybook/History/3');
                        // Custom Button 4 on Works Order daybook History tab
                        574 : ShowMessage('Works Order Daybook/History/4');
                        // Custom Button 5 on Works Order daybook History tab
                        575 : ShowMessage('Works Order Daybook/History/5');
                        // Custom Button 6 on Works Order daybook History tab
                        576 : ShowMessage('Works Order Daybook/History/6');
                      end; // Case HandlerId
                    end; {case wiTransaction}
                    
    wiStock:        begin // = EnterpriseBase + 3000;
                      case EventData.HandlerId of
                        80  : ShowMessage('Stock Record/Main/1');
                        81  : ShowMessage('Stock Record/Defaults/1');
                        88  : ShowMessage('Stock Record/VAT/Web/1');
                        87  : ShowMessage('Stock Record/WOP/1');
                        82  : ShowMessage('Stock Record/Returns/1');
                        83  : ShowMessage('Stock Record/Qty Breaks/1');
                        101 : ShowMessage('Stock Record/Multi-Buy Discounts/1');
                        84  : ShowMessage('Stock Record/ledger/1');
                        85  : ShowMessage('Stock Record/Value/1');
                        86  : ShowMessage('Stock Record/Build/1');
                        89  : ShowMessage('Stock Record/Serial/1');

                        90  : ShowMessage('Stock Record/Main/2');
                        91  : ShowMessage('Stock Record/Defaults/2');
                        98  : ShowMessage('Stock Record/VAT/Web/2');
                        97  : ShowMessage('Stock Record/WOP/2');
                        92  : ShowMessage('Stock Record/Returns/2');
                        93  : ShowMessage('Stock Record/Qty Breaks/2');
                        111 : ShowMessage('Stock Record/Multi-Buy Discounts/2');
                        94  : ShowMessage('Stock Record/ledger/2');
                        95  : ShowMessage('Stock Record/Value/2');
                        96  : ShowMessage('Stock Record/Build/2');
                        99  : ShowMessage('Stock Record/Serial/2');

                        221 : ShowMessage('Stock Record/Main/3');
                        222 : ShowMessage('Stock Record/Defaults/3');
                        229 : ShowMessage('Stock Record/VAT/Web/3');
                        228 : ShowMessage('Stock Record/WOP/3');
                        223 : ShowMessage('Stock Record/Returns/3');
                        224 : ShowMessage('Stock Record/Qty Breaks/3');
                        261 : ShowMessage('Stock Record/Multi-Buy Discounts/3');
                        225 : ShowMessage('Stock Record/ledger/3');
                        226 : ShowMessage('Stock Record/Value/3');
                        227 : ShowMessage('Stock Record/Build/3');
                        230 : ShowMessage('Stock Record/Serial/3');

                        231 : ShowMessage('Stock Record/Main/4');
                        232 : ShowMessage('Stock Record/Defaults/4');
                        239 : ShowMessage('Stock Record/VAT/Web/4');
                        238 : ShowMessage('Stock Record/WOP/4');
                        233 : ShowMessage('Stock Record/Returns/4');
                        234 : ShowMessage('Stock Record/Qty Breaks/4');
                        271 : ShowMessage('Stock Record/Multi-Buy Discounts/4');
                        235 : ShowMessage('Stock Record/ledger/4');
                        236 : ShowMessage('Stock Record/Value/4');
                        237 : ShowMessage('Stock Record/Build/4');
                        240 : ShowMessage('Stock Record/Serial/4');

                        241 : ShowMessage('Stock Record/Main/5');
                        242 : ShowMessage('Stock Record/Defaults/5');
                        249 : ShowMessage('Stock Record/VAT/Web/5');
                        248 : ShowMessage('Stock Record/WOP/5');
                        243 : ShowMessage('Stock Record/Returns/5');
                        244 : ShowMessage('Stock Record/Qty Breaks/5');
                        281 : ShowMessage('Stock Record/Multi-Buy Discounts/5');
                        245 : ShowMessage('Stock Record/ledger/5');
                        246 : ShowMessage('Stock Record/Value/5');
                        247 : ShowMessage('Stock Record/Build/5');
                        250 : ShowMessage('Stock Record/Serial/5');

                        251 : ShowMessage('Stock Record/Main/6');
                        252 : ShowMessage('Stock Record/Defaults/6');
                        259 : ShowMessage('Stock Record/VAT/Web/6');
                        258 : ShowMessage('Stock Record/WOP/6');
                        253 : ShowMessage('Stock Record/Returns/6');
                        254 : ShowMessage('Stock Record/Qty Breaks/6');
                        291 : ShowMessage('Stock Record/Multi-Buy Discounts/6');
                        255 : ShowMessage('Stock Record/ledger/6');
                        256 : ShowMessage('Stock Record/Value/6');
                        257 : ShowMessage('Stock Record/Build/6');
                        260 : ShowMessage('Stock Record/Serial/6');
                      end; // Case HandlerId
                    end; {wiStock}
                    
    wiJobRec:       begin // = EnterpriseBase + 5000;
                      case EventData.HandlerId Of
                        10  : ShowMessage('Job Record/Main/1');
                        11  : ShowMessage('Job Record/Notes/1');
                        12  : ShowMessage('Job Record/Ledger/1');
                        13  : ShowMessage('Job Record/Purchase Retentions/1');
                        14  : ShowMessage('Job Record/Sales Retentions/1');

                        20  : ShowMessage('Job Record/Main/2');
                        21  : ShowMessage('Job Record/Notes/2');
                        22  : ShowMessage('Job Record/Ledger/2');
                        23  : ShowMessage('Job Record/Purchase Retentions/2');
                        24  : ShowMessage('Job Record/Sales Retentions/2');

                        140 : ShowMessage('Job Record/Main/3');
                        141 : ShowMessage('Job Record/Notes/3');
                        142 : ShowMessage('Job Record/Ledger/3');
                        143 : ShowMessage('Job Record/Purchase Retentions/3');
                        144 : ShowMessage('Job Record/Sales Retentions/3');

                        150 : ShowMessage('Job Record/Main/4');
                        151 : ShowMessage('Job Record/Notes/4');
                        152 : ShowMessage('Job Record/Ledger/4');
                        153 : ShowMessage('Job Record/Purchase Retentions/4');
                        154 : ShowMessage('Job Record/Sales Retentions/4');

                        160 : ShowMessage('Job Record/Main/5');
                        161 : ShowMessage('Job Record/Notes/5');
                        162 : ShowMessage('Job Record/Ledger/5');
                        163 : ShowMessage('Job Record/Purchase Retentions/5');
                        164 : ShowMessage('Job Record/Sales Retentions/5');

                        170 : ShowMessage('Job Record/Main/6');
                        171 : ShowMessage('Job Record/Notes/6');
                        172 : ShowMessage('Job Record/Ledger/6');
                        173 : ShowMessage('Job Record/Purchase Retentions/6');
                        174 : ShowMessage('Job Record/Sales Retentions/6');

                        // Job Daybook
                        120 : ShowMessage('Job daybook/Pre-Postings/1');
                        121 : ShowMessage('Job daybook/Timesheets/1');
                        122 : ShowMessage('Job daybook/Timesheet History/1');
                        123 : ShowMessage('Job daybook/Purchase Apps/1');
                        124 : ShowMessage('Job daybook/Purchase App History/1');
                        125 : ShowMessage('Job daybook/Sales Apps/1');
                        126 : ShowMessage('Job daybook/Sales Apps History/1');
                        127 : ShowMessage('Job daybook/P/L Retentions/1');
                        128 : ShowMessage('Job daybook/S/L Retentions/1');

                        130 : ShowMessage('Job daybook/Pre-Postings/2');
                        131 : ShowMessage('Job daybook/Timesheets/2');
                        132 : ShowMessage('Job daybook/Timesheet History/2');
                        133 : ShowMessage('Job daybook/Purchase Apps/2');
                        134 : ShowMessage('Job daybook/Purchase App History/2');
                        135 : ShowMessage('Job daybook/Sales Apps/2');
                        136 : ShowMessage('Job daybook/Sales Apps History/2');
                        137 : ShowMessage('Job daybook/P/L Retentions/2');
                        138 : ShowMessage('Job daybook/S/L Retentions/2');

                        180 : ShowMessage('Job daybook/Pre-Postings/3');
                        181 : ShowMessage('Job daybook/Timesheets/3');
                        182 : ShowMessage('Job daybook/Timesheet History/3');
                        183 : ShowMessage('Job daybook/Purchase Apps/3');
                        184 : ShowMessage('Job daybook/Purchase App History/3');
                        185 : ShowMessage('Job daybook/Sales Apps/3');
                        186 : ShowMessage('Job daybook/Sales Apps History/3');
                        187 : ShowMessage('Job daybook/P/L Retentions/3');
                        188 : ShowMessage('Job daybook/S/L Retentions/3');

                        190 : ShowMessage('Job daybook/Pre-Postings/4');
                        191 : ShowMessage('Job daybook/Timesheets/4');
                        192 : ShowMessage('Job daybook/Timesheet History/4');
                        193 : ShowMessage('Job daybook/Purchase Apps/4');
                        194 : ShowMessage('Job daybook/Purchase App History/4');
                        195 : ShowMessage('Job daybook/Sales Apps/4');
                        196 : ShowMessage('Job daybook/Sales Apps History/4');
                        197 : ShowMessage('Job daybook/P/L Retentions/4');
                        198 : ShowMessage('Job daybook/S/L Retentions/4');

                        200 : ShowMessage('Job daybook/Pre-Postings/5');
                        201 : ShowMessage('Job daybook/Timesheets/5');
                        202 : ShowMessage('Job daybook/Timesheet History/5');
                        203 : ShowMessage('Job daybook/Purchase Apps/5');
                        204 : ShowMessage('Job daybook/Purchase App History/5');
                        205 : ShowMessage('Job daybook/Sales Apps/5');
                        206 : ShowMessage('Job daybook/Sales Apps History/5');
                        207 : ShowMessage('Job daybook/P/L Retentions/5');
                        208 : ShowMessage('Job daybook/S/L Retentions/5');

                        210 : ShowMessage('Job daybook/Pre-Postings/6');
                        211 : ShowMessage('Job daybook/Timesheets/6');
                        212 : ShowMessage('Job daybook/Timesheet History/6');
                        213 : ShowMessage('Job daybook/Purchase Apps/6');
                        214 : ShowMessage('Job daybook/Purchase App History/6');
                        215 : ShowMessage('Job daybook/Sales Apps/6');
                        216 : ShowMessage('Job daybook/Sales Apps History/6');
                        217 : ShowMessage('Job daybook/P/L Retentions/6');
                        218 : ShowMessage('Job daybook/S/L Retentions/6');
    
                      end; // Case HandlerId
                    end; {wiJobRec}
  
  end; // case EventData.WinId

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
