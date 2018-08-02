unit WinMapU;

interface

(***************************************************************************)
(*                                                                         *)
(*  NOTE: This module is used by the TCustomisation Component, newly added *)
(*  windows will not be registered until the component library has been    *)
(*  rebuilt.                                                               *)
(*                                                                         *)
(***************************************************************************)


(***************************************************************************)
(*                                                                         *)
(*  EL: Suggested Windows Id's Cust = 1000, Inv = 2000, Stk = 3000         *)
(*                             Id = 4000  Job Record 5000                  *)
(*                                                                         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

{* Events so far

   Win ID                    Event   Desc
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MiscBase+   0001              01     Replacement Line VAT calculation
                              02     Return VATPosted date in StrResult for transaction, compenasate for out of period
                              03     Return Actual VATposted date, no compensation
                              04     Return in StrResult equivalent date for a given vat period contained in StrResult
                              05     Return current VAT Period in StrResult
                              06     Execute Custom Admin module

MiscBase+   0002              08     Notification event that Enterprise is about to change company
                              09     Notification event that Enterprise has changed company. New data path should be in system set-up

MiscBase+   0003              01     Add Button pressed on Paperless module
                              02     Edit Button pressed on Paperless module

--------------------------------------------------------------------------------                              
   1000                       01     Upon exit of Area code on customer account add/edit check payment method ok
                              02     Prior to storing an account record
                                     Have access to UD1-4

                              03     After storing accout record
                              04     After deleteing account record
                              05     Upon exit of Area code on supplier account add/edit check payment method ok

                              08     Upon first display of customer record

                              11     Custom Button 1 Customer List
                              12     Custom Button 2 Customer List
                              
                              15     Custom Button 1 Batch Receipts

                              21     Custom Button 1 Supplier List
                              22     Custom Button 2 Supplier List
                              
                              25     Custom Button 1 Batch Payments
                              
                              31     Upon exit of UD1 code on customer account add/edit.
                              32     Upon exit of UD2 code on customer account add/edit.
                              33     Upon exit of UD3 code on customer account add/edit.
                              34     Upon exit of UD4 code on customer account add/edit.
                              35     Upon exit of Account Type on customer account add/edit.
                              36     Upon exit of Account Area on customer account add/edit.
                              
                              41     Upon exit of UD1 code on supplier account add/edit.
                              42     Upon exit of UD2 code on supplier account add/edit.
                              43     Upon exit of UD3 code on supplier account add/edit.
                              44     Upon exit of UD4 code on supplier account add/edit.
                              45     Upon exit of Account Type supplier account add/edit.
                              46     Upon exit of Account Area on supplier account add/edit.

                              60     Whilst validating the supplier record. Boresult blocks
                              61     Whilst validating the customer record. Boresult blocks
                              62     If Hook enabled, Customer status is NOT automatically updated when notes added to customer record

                             100     Upon exit of Account code in TS window, result returned in CustCode
                             101     During selection of Customers in statement run, BoResult will block
                             102     During selection of Customers in debt chase run, BoResult will block
                             103     Upon OK of statement run dialog, BoResult will block report
                             104     Upon OK of debt chase run dialog, BoResult will block report
                             105     Upon Exit of Post code on customer account add/edit
                             106     Upon Exit of Post code on supplier account add/edit
                             107     Upon entry of Customer account code during account creation only. Allows account code to be set externally.
                             108     Upon entry of Supplier account code during account creation only. Allows account code to be set externally.
                             109     After Account code has been validated, and allows update of delivery address.

                             111     Notification event that account code has changed. Stage1, sends record with original stockcode, new stock code contained in StrResult

                             120     Custom Button 1 Customer Ledger
                             121     Custom Button 2 Customer Ledger

                             130     Custom Button 1 Supplier Ledger
                             131     Custom Button 2 Supplier Ledger

                             135     Allow any Customer field search via ObjectFind to be overridden. StrResult will contain any text typed in to ObjectFind.
                                     The seach using combo box must be set to Any Field in order to trigger the hook.
                                     BoResult must be returned TRUE if the external hook has found a valid match, and return the completed
                                     Primary (AccountCode) key in StrResult. The customisation will then attempt to find the record by the primary
                                     key returned using the primary index.

                             137     Allow any Supplier field search via ObjectFind to be overridden. StrResult will contain any text typed in to ObjectFind.
                                     The seach using combo box must be set to Any Field in order to trigger the hook.
                                     BoResult must be returned TRUE if the external hook has found a valid match, and return the completed
                                     Primary key (AccountCode) in StrResult. The customisation will then attempt to find the record by the primary
                                     key returned using the primary index.

                             140     If Enabled, modifies statement run so that only accounts with o/s items at the time of running the statement run
                                     are included if "Show Matched in the Month" is ticked.
                             141     Custom Button 3 Customer List
                             142     Custom Button 4 Customer List
                             143     Custom Button 5 Customer List
                             144     Custom Button 6 Customer List
                             145     Custom Button 3 Customer Ledger
                             146     Custom Button 4 Customer Ledger
                             147     Custom Button 5 Customer Ledger
                             148     Custom Button 6 Customer Ledger
                             
                             151     Custom Button 3 Supplier List
                             152     Custom Button 4 Supplier List
                             153     Custom Button 5 Supplier List
                             154     Custom Button 6 Supplier List
                             155     Custom Button 3 Supplier Ledger
                             156     Custom Button 4 Supplier Ledger
                             157     Custom Button 5 Supplier Ledger
                             158     Custom Button 6 Supplier Ledger
                             
                             200     Customer Status Changed by User
                             201     Supplier Status Changed by User

                             //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
                             202     Customer Anonymised

                             //PR: 23/03/2017 ABSEXCH-18143 Added custom buttons
                             //     for other tabs on Customer/Supplier record
                             300     Custom Button 1 Customer Main Tab
                             320     Custom Button 2 Customer Main Tab
                             340     Custom Button 3 Customer Main Tab
                             360     Custom Button 4 Customer Main Tab
                             380     Custom Button 5 Customer Main Tab
                             400     Custom Button 6 Customer Main Tab
                             301     Custom Button 1 Customer Defaults Tab
                             321     Custom Button 2 Customer Defaults Tab
                             341     Custom Button 3 Customer Defaults Tab
                             361     Custom Button 4 Customer Defaults Tab
                             381     Custom Button 5 Customer Defaults Tab
                             401     Custom Button 6 Customer Defaults Tab
                             302     Custom Button 1 Customer eComm Tab
                             322     Custom Button 2 Customer eComm Tab
                             342     Custom Button 3 Customer eComm Tab
                             362     Custom Button 4 Customer eComm Tab
                             382     Custom Button 5 Customer eComm Tab
                             402     Custom Button 6 Customer eComm Tab
                             303     Custom Button 1 Customer Roles Tab
                             323     Custom Button 2 Customer Roles Tab
                             343     Custom Button 3 Customer Roles Tab
                             363     Custom Button 4 Customer Roles Tab
                             383     Custom Button 5 Customer Roles Tab
                             403     Custom Button 6 Customer Roles Tab
                             304     Custom Button 1 Customer Notes Tab
                             324     Custom Button 2 Customer Notes Tab
                             344     Custom Button 3 Customer Notes Tab
                             364     Custom Button 4 Customer Notes Tab
                             384     Custom Button 5 Customer Notes Tab
                             404     Custom Button 6 Customer Notes Tab
                             305     Custom Button 1 Customer Discounts Tab
                             325     Custom Button 2 Customer Discounts Tab
                             345     Custom Button 3 Customer Discounts Tab
                             365     Custom Button 4 Customer Discounts Tab
                             385     Custom Button 5 Customer Discounts Tab
                             405     Custom Button 6 Customer Discounts Tab
                             306     Custom Button 1 Customer MB Discounts Tab
                             326     Custom Button 2 Customer MB Discounts Tab
                             346     Custom Button 3 Customer MB Discounts Tab
                             366     Custom Button 4 Customer MB Discounts Tab
                             386     Custom Button 5 Customer MB Discounts Tab
                             406     Custom Button 6 Customer MB Discounts Tab
                             308     Custom Button 1 Customer SORs/PORs Tab
                             328     Custom Button 2 Customer SORs/PORs Tab
                             348     Custom Button 3 Customer SORs/PORs Tab
                             368     Custom Button 4 Customer SORs/PORs Tab
                             388     Custom Button 5 Customer SORs/PORs Tab
                             408     Custom Button 6 Customer SORs/PORs Tab
                             309     Custom Button 1 Customer WORs Tab
                             329     Custom Button 2 Customer WORs Tab
                             349     Custom Button 3 Customer WORs Tab
                             369     Custom Button 4 Customer WORs Tab
                             389     Custom Button 5 Customer WORs Tab
                             409     Custom Button 6 Customer WORs Tab
                             310     Custom Button 1 Customer Applications Tab
                             330     Custom Button 2 Customer Applications Tab
                             350     Custom Button 3 Customer Applications Tab
                             370     Custom Button 4 Customer Applications Tab
                             390     Custom Button 5 Customer Applications Tab
                             410     Custom Button 6 Customer Applications Tab
                             311     Custom Button 1 Customer Returns Tab
                             331     Custom Button 2 Customer Returns Tab
                             351     Custom Button 3 Customer Returns Tab
                             371     Custom Button 4 Customer Returns Tab
                             391     Custom Button 5 Customer Returns Tab
                             411     Custom Button 6 Customer Returns Tab
 
                             500     Custom Button 1 Supplier Main Tab
                             520     Custom Button 2 Supplier Main Tab
                             540     Custom Button 3 Supplier Main Tab
                             560     Custom Button 4 Supplier Main Tab
                             580     Custom Button 5 Supplier Main Tab
                             600     Custom Button 6 Supplier Main Tab
                             501     Custom Button 1 Supplier Defaults Tab
                             521     Custom Button 2 Supplier Defaults Tab
                             541     Custom Button 3 Supplier Defaults Tab
                             561     Custom Button 4 Supplier Defaults Tab
                             581     Custom Button 5 Supplier Defaults Tab
                             601     Custom Button 6 Supplier Defaults Tab
                             502     Custom Button 1 Supplier eComm Tab
                             522     Custom Button 2 Supplier eComm Tab
                             542     Custom Button 3 Supplier eComm Tab
                             562     Custom Button 4 Supplier eComm Tab
                             582     Custom Button 5 Supplier eComm Tab
                             602     Custom Button 6 Supplier eComm Tab
                             503     Custom Button 1 Supplier Roles Tab
                             523     Custom Button 2 Supplier Roles Tab
                             543     Custom Button 3 Supplier Roles Tab
                             563     Custom Button 4 Supplier Roles Tab
                             583     Custom Button 5 Supplier Roles Tab
                             603     Custom Button 6 Supplier Roles Tab
                             504     Custom Button 1 Supplier Notes Tab
                             524     Custom Button 2 Supplier Notes Tab
                             544     Custom Button 3 Supplier Notes Tab
                             564     Custom Button 4 Supplier Notes Tab
                             584     Custom Button 5 Supplier Notes Tab
                             604     Custom Button 6 Supplier Notes Tab
                             505     Custom Button 1 Supplier Discounts Tab
                             525     Custom Button 2 Supplier Discounts Tab
                             545     Custom Button 3 Supplier Discounts Tab
                             565     Custom Button 4 Supplier Discounts Tab
                             585     Custom Button 5 Supplier Discounts Tab
                             605     Custom Button 6 Supplier Discounts Tab
                             506     Custom Button 1 Supplier MB Discounts Tab
                             526     Custom Button 2 Supplier MB Discounts Tab
                             546     Custom Button 3 Supplier MB Discounts Tab
                             566     Custom Button 4 Supplier MB Discounts Tab
                             586     Custom Button 5 Supplier MB Discounts Tab
                             606     Custom Button 6 Supplier MB Discounts Tab
                             508     Custom Button 1 Supplier SORs/PORs Tab
                             528     Custom Button 2 Supplier SORs/PORs Tab
                             548     Custom Button 3 Supplier SORs/PORs Tab
                             568     Custom Button 4 Supplier SORs/PORs Tab
                             588     Custom Button 5 Supplier SORs/PORs Tab
                             608     Custom Button 6 Supplier SORs/PORs Tab
                             509     Custom Button 1 Supplier WORs Tab
                             529     Custom Button 2 Supplier WORs Tab
                             549     Custom Button 3 Supplier WORs Tab
                             569     Custom Button 4 Supplier WORs Tab
                             589     Custom Button 5 Supplier WORs Tab
                             609     Custom Button 6 Supplier WORs Tab
                             510     Custom Button 1 Supplier Applications Tab
                             530     Custom Button 2 Supplier Applications Tab
                             550     Custom Button 3 Supplier Applications Tab
                             570     Custom Button 4 Supplier Applications Tab
                             590     Custom Button 5 Supplier Applications Tab
                             610     Custom Button 6 Supplier Applications Tab
                             511     Custom Button 1 Supplier Returns Tab
                             531     Custom Button 2 Supplier Returns Tab
                             551     Custom Button 3 Supplier Returns Tab
                             571     Custom Button 4 Supplier Returns Tab
                             591     Custom Button 5 Supplier Returns Tab
                             611     Custom Button 6 Supplier Returns Tab



--------------------------------------------------------------------------------                              
   2000                       01     Prior to storing Inv type transaction
                                     Have access to Hold Flg +UD1-4 + Nolabels + LongYRef + Short YRef + Tag value.
                              02     Event immediately after delivery run dialog
                              03     Event during Delivery run selection
                              04     Event to Return No of Copies to print for Delivery Notes.
                              05     Event to Return No of Copies to print for Invoices Notes.
                              06     After account code entered.
                              07     Before daily rate is entered. To allow it to be set externaly
                              08     After period is entered. Used to validate in conjunction with 80/81
                              09     After Account code has been validated, and allows update of delivery address.

                              10     Custom Button 1 on Sales daybook Main tab
                              11     Custom Button 1 on Sales daybook Quotes tab
                              12     Custom Button 1 on Sales daybook Auto tab
                              13     Custom Button 1 on Sales daybook History tab
                              14     Custom Button 1 on Sales daybook Orders tab
                              15     Custom Button 1 on Sales daybook Order History tab
                              
                              16     Reserved for Custom Button 1 on future tab 6
                              17     Reserved for Custom Button 1 on future tab 7
                              18     Reserved for Custom Button 1 on future tab 8
                              19     Reserved for Custom Button 1 on future tab 9

                              20     Custom Button 2 on Sales daybook Main tab
                              21     Custom Button 2 on Sales daybook Quotes tab
                              22     Custom Button 2 on Sales daybook Auto tab
                              23     Custom Button 2 on Sales daybook History tab
                              24     Custom Button 2 on Sales daybook Orders tab
                              25     Custom Button 2 on Sales daybook Order History tab
                              
                              26     Reserved for Custom Button 2 on future tab 6
                              27     Reserved for Custom Button 2 on future tab 7
                              28     Reserved for Custom Button 2 on future tab 8
                              29     Reserved for Custom Button 2 on future tab 9

                              31     Custom Button 1 on Main Sales Transactions
                              32     Custom Button 2 on Main Sales Transactions

                              38     Custom Button 1 on Stk Adj Transaction
                              39     Custom Button 2 on Stk Adj Transaction

                              41     Custom Button 1 on Main Purchase Transactions
                              42     Custom Button 2 on Main Purchase Transactions

                              43     Custom Button 1 on WOR Transaction
                              44     Custom Button 2 on WOR Transaction

                                     All Custom buttons in this mode have access to Delivery address + UD1-4

                              50     Upon exit of Due/Delivery date field on normal transaction.
                              51     When triggered, if returned with BoResult true, any lines added to the body of the transaction
                                     will have their line date set to the same as the delivery date in the header.
                              61     Upon exit of UD1 code on Transaction Header add/edit.
                              62     Upon exit of UD2 code on Transaction Header add/edit.
                              63     Upon exit of UD3 code on Transaction Header add/edit.
                              64     Upon exit of UD4 code on Transaction Header add/edit.
                              65     Before Short Your Ref is entered.
                              66     Before Long Your Ref (Transdesc) is entered.
                              67     Allow Override of hold status on order store & Picking run process.
                              68     Allow Override of hold status on WOR Picking run process.
                              69     Event during WOR Issue & Build run selection
                              70     Event to Return No of Copies to print for WOR Issue Notes.
                              71     Event to Return No of Copies to print for WOR Build Notes.
                              79     Triggered as an order is placed into history during SPOP

                              80     Override calculation of period relative to date.
                              81     Override calculation of date relative to period.
                              82     Whilst Validating the transaction.
                              83     Just Prior to converting a quote to an invoice. BoResult false, Blocks
                              84     Just Prior to converting a quote to an Order.   BoResult false, Blocks
                              85     After converting a quote to an invoice or order, for information purposes only
                              86     Prior to authorising a transaction. BoResult false will block
                              87     Prior to Copy a transaction. BoResult will block.
                              88     Prior to Reversing a transaction. BoResult will block.
                              89-91  Reserved in case we ever want to block auto reversals or back to back.

                              98     After Copy has taken place. New Transaction populated in object.
                              99     After Reverse has taken place. New Transaction populated in object.
                             100     After Confirming deletion of a quotation, BoResult with block.
                             101     After Account code is tabbed out of regardless of edit state
                             103     After Delivery note has been created from SOR/POR
                             104     Custom Filter option during Print Range of documents
                             105     After Dialog box for Print Range of documents is confirmed, BoResult false will abort Print Range of Documents
                             106     During an auto daybook process, this notification event will show the header details in LInv of what has been produced.
                             107     During the conversion of an SOR to an SDN, if this hook is enabled, the tag number of the SOR will be copied to the SDN.
                             108     During the conversion of an SDN to an SIN, if this hook is enabled, the tag number of the SDN will be copied to the SIN.
                             109     During the conversion of an ?DN to an ?IN, if this hook is enabled, the due date of the SIN maybe overridden by the hook.

                             110     Custom Button 1 on Purchase daybook Main tab
                             111     Custom Button 1 on Purchase daybook Quotes tab
                             112     Custom Button 1 on Purchase daybook Auto tab
                             113     Custom Button 1 on Purchase daybook History tab
                             114     Custom Button 1 on Purchase daybook Orders tab
                             115     Custom Button 1 on Purchase daybook Order History tab
                                  
                             116     Reserved for Custom Button 1 on future tab 6
                             117     Reserved for Custom Button 1 on future tab 7
                             118     Reserved for Custom Button 1 on future tab 8
                             119     Reserved for Custom Button 1 on future tab 9

                             120     Custom Button 2 on Purchase daybook Main tab
                             121     Custom Button 2 on Purchase daybook Quotes tab
                             122     Custom Button 2 on Purchase daybook Auto tab
                             123     Custom Button 2 on Purchase daybook History tab
                             124     Custom Button 2 on Purchase daybook Orders tab
                             125     Custom Button 2 on Purchase daybook Order History tab
                             
                             126     Reserved for Custom Button 2 on future tab 6
                             127     Reserved for Custom Button 2 on future tab 7
                             128     Reserved for Custom Button 2 on future tab 8
                             129     Reserved for Custom Button 2 on future tab 9

                             131     Custom Button 1 on Main Sales Transactions View Only
                             132     Custom Button 2 on Main Sales Transactions View Only

                             138     Custom Button 1 on Stk Adj Transaction View Only
                             139     Custom Button 2 on Stk Adj Transaction View Only

                             141     Custom Button 1 on Main Purchase Transactions View Only
                             142     Custom Button 2 on Main Purchase Transactions View Only

                             143     Custom Button 1 on WOR Transaction View Only
                             144     Custom Button 2 on WOR Transaction View Only

                             150     When Edit button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             151     When Print button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             152     When Pick/Receive button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             153     When Match button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             154     When Tag button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             155     When View button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             156     When Daybook list is in scan mode with transaction open.
                             157     When Add button selected on Nom Daybook, BoResult checked if event enabled and button only executed if BoResult True.

                             158     As a transaction is being displayed, BoResult checked, and if False, Transaction is shown as view Only. Used in support of ICE Dripfeed mode.
                             159     As a transaction is being Added to the Block unallocate window, BoResult checked, and if False, Unallocation is disabled. Used in support of ICE Dripfeed mode.

                             160     When Copy button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             161     When Notes button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             162     When Copy/Reverse button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.
                             163     When Back To Back button selected on Daybook, BoResult checked if event enabled and button only executed if BoResult True.

                             164     When Hold-Hold for Query menu option is selected on Daybook, BoResult checked if event enabled and menu only executed if BoResult True.
                             165     When Hold-Cancel Hold menu option is selected on Daybook, BoResult checked if event enabled and menu only executed if BoResult True.

                             170     After store of Transaction.

                             171     Sales Transaction Allocated
                             172     Purchase Transaction Allocated
                             173     Sales Transaction Unallocated
                             174     Purchase Transaction Unallocated

                             180     Upon exit of Short YourRef code on Transaction Header add/edit.
                             181     Upon exit of Short LongRef code on Transaction Header add/edit.
                             182     Allows Writing to UD 1-4 & Delivery address on SOR during back to back creation
                             183     Hook being enabled forces order daybook to show ud1 instead of your ref in the your ref column.

                             185     Allow any Transaction field search via ObjectFind to be overridden. StrResult will contain any text typed in to ObjectFind.
                                     The seach using combo box must be set to Any Field in order to trigger the hook.
                                     BoResult must be returned TRUE if the external hook has found a valid match, and return the completed
                                     Primary key (OurRef) in StrResult. The customisation will then attempt to find the record by the primary
                                     key returned using the primary index.

                             187     Notification Hook prior to b2b being created containing SOR transaction read only.
                             188     Allow unit price on b2b generated POR line to be overridden.
                             189     Allow block on account code to take place after user tabs out of account code on normal transactions containing an account code and
                                     telesales when the transaction is being initially added.  Set BoResult to false to block.

                             190     After Account code has been validated, and allows update of Job Analysis code.
                             191     During Delivery note run, allows manual vat flag, and vat ary to be overridden.

                             192     Custom Credit Status Check

                             193     Transaction Hold Flag changed by User

                             200     During Allocation Wizard part allocation, overrides exchange rate for conversion from Invoice being allocated.

                             211     Upon exit of UD5 code on Transaction Header add/edit.
                             212     Upon exit of UD6 code on Transaction Header add/edit.
                             213     Upon exit of UD7 code on Transaction Header add/edit.
                             214     Upon exit of UD8 code on Transaction Header add/edit.
                             215     Upon exit of UD9 code on Transaction Header add/edit.
                             216     Upon exit of UD10 code on Transaction Header add/edit.
PKR 24/03/2016               217     Upon exit of UD11 code on Transaction Header add/edit.
                             218     Upon exit of UD12 code on Transaction Header add/edit.

                            301-306  Custom Button 1 on Nominal Daybooks (Tabs 1-6)
                            307-310  Reserved for Custom Button 1 on future tabs 7-10
                            
                            311-316  Custom Button 2 on Nominal Daybooks (Tabs 1-6)
                            317-320  Reserved for Custom Button 2 on future tabs 7-10
                            
                            321-326  Custom Button 3 on Nominal Daybooks (Tabs 1-6)
                            327-330  Reserved for Custom Button 3 on Nominal Daybooks for tabs 1-10
                            
                            331-336  Custom Button 4 on Nominal Daybooks (Tabs 1-6)
                            337-340  Reserved for Custom Button 4 on Nominal Daybooks for tabs 1-10
                            
                            341-336  Custom Button 5 on Nominal Daybooks (Tabs 1-6)
                            347-350  Reserved for Custom Button 5 on Nominal Daybooks for tabs 1-10
                            
                            331-336  Custom Button 6 on Nominal Daybooks (Tabs 1-6)
                            351-360  Reserved for Custom Button 6 on Nominal Daybooks for tabs 1-10

                             361     Custom Button 3 on Sales daybook Main tab
                             362     Custom Button 3 on Sales daybook Quotes tab
                             363     Custom Button 3 on Sales daybook Auto tab
                             364     Custom Button 3 on Sales daybook History tab
                             365     Custom Button 3 on Sales daybook Orders tab
                             366     Custom Button 3 on Sales daybook Order History tab
                              
                             371     Custom Button 4 on Sales daybook Main tab
                             372     Custom Button 4 on Sales daybook Quotes tab
                             373     Custom Button 4 on Sales daybook Auto tab
                             374     Custom Button 4 on Sales daybook History tab
                             375     Custom Button 4 on Sales daybook Orders tab
                             376     Custom Button 4 on Sales daybook Order History tab
                              
                             381     Custom Button 5 on Sales daybook Main tab
                             382     Custom Button 5 on Sales daybook Quotes tab
                             383     Custom Button 5 on Sales daybook Auto tab
                             384     Custom Button 5 on Sales daybook History tab
                             385     Custom Button 5 on Sales daybook Orders tab
                             386     Custom Button 5 on Sales daybook Order History tab
                              
                             391     Custom Button 6 on Sales daybook Main tab
                             392     Custom Button 6 on Sales daybook Quotes tab
                             393     Custom Button 6 on Sales daybook Auto tab
                             394     Custom Button 6 on Sales daybook History tab
                             395     Custom Button 6 on Sales daybook Orders tab
                             396     Custom Button 6 on Sales daybook Order History tab
                              
                             401     Custom Button 3 on Purchase daybook Main tab
                             402     Custom Button 3 on Purchase daybook Quotes tab
                             403     Custom Button 3 on Purchase daybook Auto tab
                             404     Custom Button 3 on Purchase daybook History tab
                             405     Custom Button 3 on Purchase daybook Orders tab
                             406     Custom Button 3 on Purchase daybook Order History tab
                                  
                             411     Custom Button 4 on Purchase daybook Main tab
                             412     Custom Button 4 on Purchase daybook Quotes tab
                             413     Custom Button 4 on Purchase daybook Auto tab
                             414     Custom Button 4 on Purchase daybook History tab
                             415     Custom Button 4 on Purchase daybook Orders tab
                             416     Custom Button 4 on Purchase daybook Order History tab
                                  
                             421     Custom Button 5 on Purchase daybook Main tab
                             422     Custom Button 5 on Purchase daybook Quotes tab
                             423     Custom Button 5 on Purchase daybook Auto tab
                             424     Custom Button 5 on Purchase daybook History tab
                             425     Custom Button 5 on Purchase daybook Orders tab
                             426     Custom Button 5 on Purchase daybook Order History tab
                                  
                             431     Custom Button 6 on Purchase daybook Main tab
                             432     Custom Button 6 on Purchase daybook Quotes tab
                             433     Custom Button 6 on Purchase daybook Auto tab
                             434     Custom Button 6 on Purchase daybook History tab
                             435     Custom Button 6 on Purchase daybook Orders tab
                             436     Custom Button 6 on Purchase daybook Order History tab
                                  
                             441     Custom Button 3 on Main Sales Transactions edit mode
                             442     Custom Button 4 on Main Sales Transactions edit mode
                             443     Custom Button 5 on Main Sales Transactions edit mode
                             444     Custom Button 6 on Main Sales Transactions edit mode
                                  
                             445     Custom Button 3 on Main Purchase Transactions edit mode
                             446     Custom Button 4 on Main Purchase Transactions edit mode
                             447     Custom Button 5 on Main Purchase Transactions edit mode
                             448     Custom Button 6 on Main Purchase Transactions edit mode

                             451     Custom Button 3 on Stk Adj Transaction edit mode
                             452     Custom Button 4 on Stk Adj Transaction edit mode
                             453     Custom Button 5 on Stk Adj Transaction edit mode
                             454     Custom Button 6 on Stk Adj Transaction edit mode

                             455     Custom Button 3 on WOR Transaction edit mode
                             456     Custom Button 4 on WOR Transaction edit mode
                             457     Custom Button 5 on WOR Transaction edit mode
                             458     Custom Button 6 on WOR Transaction edit mode
                             
                             541     Custom Button 3 on Main Sales Transactions view only mode
                             542     Custom Button 4 on Main Sales Transactions view only mode
                             543     Custom Button 5 on Main Sales Transactions view only mode
                             544     Custom Button 6 on Main Sales Transactions view only mode
                                  
                             545     Custom Button 3 on Main Purchase Transactions view only mode
                             546     Custom Button 4 on Main Purchase Transactions view only mode
                             547     Custom Button 5 on Main Purchase Transactions view only mode
                             548     Custom Button 6 on Main Purchase Transactions view only mode

                             551     Custom Button 3 on Stk Adj Transaction View Only
                             552     Custom Button 4 on Stk Adj Transaction View Only
                             553     Custom Button 5 on Stk Adj Transaction View Only
                             554     Custom Button 6 on Stk Adj Transaction View Only
                              
                             555     Custom Button 3 on WOR Transaction View Only
                             556     Custom Button 4 on WOR Transaction View Only
                             557     Custom Button 5 on WOR Transaction View Only
                             558     Custom Button 6 on WOR Transaction View Only

                             // PKR. 04/11/2015. ABSEXCH-16348. Add Custom Buttons to Works Order Daybook.
                             561     Custom Button 1 on Works Order daybook Main tab
                             562     Custom Button 2 on Works Order daybook Main tab
                             563     Custom Button 3 on Works Order daybook Main tab
                             564     Custom Button 4 on Works Order daybook Main tab
                             565     Custom Button 5 on Works Order daybook Main tab
                             566     Custom Button 6 on Works Order daybook Main tab

                             571     Custom Button 1 on Works Order daybook History tab
                             572     Custom Button 2 on Works Order daybook History tab
                             573     Custom Button 3 on Works Order daybook History tab
                             574     Custom Button 4 on Works Order daybook History tab
                             575     Custom Button 5 on Works Order daybook History tab
                             576     Custom Button 6 on Works Order daybook History tab

--------------------------------------------------------------------------------
   2050                       01     Override BANK Electronic Payment File (EPF).  This Event must be enabled as an indication that the entire process is under hook control
                              10     On Creation of the EPF file. Create the replacement EPF file at this point.
                              20     On Validation of each customer/supplier, payment type, and bank details
                              30     On Write of each EPF Payment record (Beneficiary)
                              31     On Write of each EPF Contra record (Payor)
                              50     On Close of EPF File
                              60     On Reject EPF (One of the accounts has failed its validation, so whole batch rejected. File must be erased.
                              70     On Erase of EPF (If no entries found to write)
                              80     On finish BACS process.  This event must be called before any other EPF is run as it frees
                                     internal objects within the hook which keep track of running totals etc.  Corruption of
                                     the EPF file will ocurr if this event is not called.

                             100     Allow the cheque number to overwritten as the receipt is being created.
                             101     Allow the cheque number to overwritten as the payment is being created.
                             102     Allows the manual/automatic reconciliation of a G/L account to be blocked.
                                     When executed IntResult is set with the bank rec g/l code.
                                     The hook must return validstaus as true regardless of the desired outcome.
                                     If the same code is returned in IntResult then the reconcilaition will proceed, if IntResult is 0 the
                                     reconcilation is blocked.

                             170     Notification hook that scanning of supplier accounts on batch payments is about to begin.
                             171     Notification hook that scanning of customer accounts on batch receipts is about to begin.

                             172     Allow External hook to control which purchase accounts are included in Batch payments/receipts by setting BoResult to True
                             173     Allow External hook to control which sales accounts are included in Batch payments/receipts by setting BoResult to True

                             174     Allow External hook to control which purchase transactions are included in Batch payments/receipts by setting BoResult to True
                             175     Allow External hook to control which sales transactions are included in Batch payments/receipts by setting BoResult to True
                             176     NF: 23/10/06 : This hook fires just before the processing of Batch Sales Receipts. It holds no information in EventData, as it is merely used as a prompt. This was put in specifically for Braeforge.
                             177     Override allowing pick if credit hold applies. Seddons.

                             
--------------------------------------------------------------------------------                              
   3000                       01     Stock Code exit on add/edit
                              02     Stock Store. With BarCode field set.

                              10-12  Custom Button 1 on Stock List event
                              20-22  Custom Button 2 on Stock List event


                              31     Upon exit of UD1 code on Stock Record add/edit.
                              32     Upon exit of UD2 code on Stock Record add/edit.
                              33     Upon exit of UD3 code on Stock Record add/edit.
                              34     Upon exit of UD4 code on Stock Record add/edit.

                              40     Whilst validating the stock record. Boresult blocks

                              50     As Stock Re-Order list is updated, this event is executed with the currently highlighted stock record.
                              51     Exit Stock Re-Order qty, allows write to re-order qty
                              52     Allows override of Need Qty during Re-order Auto Set Stock Routine.
                              
                              80-89  Custom Button 1 on Stock Record Page 0-9
                              90-99  Custom Button 2 on Stock Record Page 0-9
                                     Page 0 = Main Tab
                                     Page 1 = Defaults
                                     Page 2 = Notes
                                          3 = Qty Breaks
                                          4 = Ledger
                                          5 = Value
                                          6 = Build
                                          7 = WOP
                                          8 = VAT
                                          9 = Serial

                             111     Notification event that Stock code has changed. Stage1, sends record with original stockcode, new stock code contained in StrResult

                             115     Allow any Stock  field search via ObjectFind to be overridden. StrResult will contain any text typed in to ObjectFind.
                                     The seach using combo box must be set to Any Field in order to trigger the hook.
                                     BoResult must be returned TRUE if the external hook has found a valid match, and return the completed
                                     Primary key (Stock Code) in StrResult. The customisation will then attempt to find the record by the primary
                                     key returned using the primary index.

                             221-230 Custom Button 3 on Stock Record Page 0-9
                             231-240 Custom Button 4 on Stock Record Page 0-9
                             241-250 Custom Button 5 on Stock Record Page 0-9
                             251-260 Custom Button 6 on Stock Record Page 0-9


--------------------------------------------------------------------------------                              
   3100                       01     Upon entering the batch no field during an add
                                     on a serial/batch record
                                     A numeric value can be passed into the global variable IntResult,
                                     Which can be passed in as the batch number.

                              02     Upon exiting the bin code no field during an add, the code can be overridden with the contents of
                                     StrResult providing ValidStatus is true
                              03     Upon exiting the bin code no field on a serial record, allows overwrite.
                              04     As per 03, but called as serial record is stored.
                              05     Changes the behaviour of the filtering of Serial/Batch/Bin nos by stock locations.

                              
--------------------------------------------------------------------------------                              
   4000                       01     Qty entry on id line
                              02     Upon entering Qty for overwriting Qty Mul.
                              03     Qty Exit
                              04     discount Exit
                              05     Unit Price exit
                              06     VAT exit
                              07     Line Form Close
                              08     Line Form Activate
                              09     Upon entering Unit Price
                              10     Before Storing Transaction Line
                              11     Stock Code exit - After price calculated, allows unit price to be altered.
                              12     Qty exit - After price calculated.
                              13     Auto Set Qty Written off based on qty picked - qty ordered.
                                     Triggered as qty picked is exited.
                              14     As transaction is stored, prompt for label print.
                              15     Stock Code exit, before any validation of stock code is set, allows stock code to be set.
                              16     Upon exit of CC
                              17     Upon exit of Dep
                              18     Whilst Validating a general transaction Line
                              19     Whilst Validating a Nominal transfer Line
                              20     Whilst Validating an ADJ or WOR Line
                              21     Whilst Validating a TeleSales Line
                              22     Whilst Validating a Batch Line
                              23     Whilst Validating a TimeSheet Line
                              24     Whilst Validating a general Payment Line
                              25     Upon Exit of TeleSales Qty
                              26     When Calculating a sales or purchase line VAT
                              27     Force customer VAT code to be used on line if enabled.


                              31     Upon exit of UD1 code on Transaction Line add/edit.
                              32     Upon exit of UD2 code on Transaction Line add/edit.
                              33     Upon exit of UD3 code on Transaction Line add/edit.
                              34     Upon exit of UD4 code on Transaction Line add/edit.

                              50     Return an integer amount from 0-3 to specify the number of decimal places
                                     used within the line discount field.
                              51     Allow Revalaution unrealised currency variance G/L code to be replaced during
                                     revaluation.
                              52     Allow the cost of sales G/L code to be replaced during posting.

                              53     Upon Entry to JC Timesheet payrate. Payrate is presented in TLStockCode.
                                     New payrate returned in StrResult.

                              54     Upon Exit to JC Timesheet payrate. Payrate is presented in TLStockCode.
                                     New payrate returned in StrResult.

                              55     Upon Exit to JC Timesheet Charge out rate. Charge out rate is presented in TLCost.
                                     New payrate returned in TLCost.
                              56     Upon exit of qty picked. allow qty picked to be set.

                              57     When posting a transaction line, do not overwrite the line date
                              58     Stock Code exit, TeleSales before any validation of stock code is set, allows stock code to be set.
                              59     Upon Entering of Location code, allows setting of line location code. Only fires if Multi location enabled.
                              
                              70     Upon exit of Stock Code in TeleSales, allows unit price to be overridden.
                              71     Upon exit of Qty in TeleSales, allows unit price to be overridden.
                              80     Prior to deletion of a transaction line (Only implemented on main transaction type as of v5.60.001) BoResult
                                     will block deletion if set to false.
                              81     After deletion of a transaction line. (Only implemented on main transaction type as of v5.60.001)
                              85     Allow the Write Off G/L code lines to be replaced during posting of ADJ's
                              86     Allow the Stock Value G/L code lines to be replaced during posting of ADJ's
                              87     Upon exit of qty out on adj, 01 event used for qty in
                              88     During Posting, force the system default user/customer cc/dep into the generated settlement discount ctrl line
                              89     Show Serial/Batch dialog if Line Location changed
                              90     During exit of Qty in, allows UD1-4 to be set
                              91     During exit of Qty out, allows UD1-4 to be set
                              92     Prior to store of Adj Line, allows UD1-4 to be set
                             100     During posting of ADJ line, allow CC/Dep to be overwritten on corresponding NOM Line 
                              
                             211     Upon exit of UD5 code on Transaction Line add/edit.
                             212     Upon exit of UD6 code on Transaction Line add/edit.
                             213     Upon exit of UD7 code on Transaction Line add/edit.
                             214     Upon exit of UD8 code on Transaction Line add/edit.
                             215     Upon exit of UD9 code on Transaction Line add/edit.
                             216     Upon exit of UD10 code on Transaction Line add/edit.
PKR. 24/03/2016. Transaction Headers now have 12 UDFs, but Transaction Lines do not.  In case this changes, reserve 217 and 218 for that purpose

--------------------------------------------------------------------------------                              
   5000                       10-14  Custom button 1 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)
                              20-24  Custom button 2 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)

                              31     Upon exit of UD1 code on Job Record add/edit.
                              32     Upon exit of UD2 code on Job Record add/edit.
                              33     Upon exit of UD3 code on Job Record add/edit.
                              34     Upon exit of UD4 code on Job Record add/edit.
                              40     Whilst validating the Job record. Boresult blocks
                              41     Upon exit of UD1 code on Employee Record add/edit.
                              42     Upon exit of UD2 code on Employee Record add/edit.
                              43     Upon exit of UD3 code on Employee Record add/edit.
                              44     Upon exit of UD4 code on Employee Record add/edit.
                              50     Whilst validating the employee record. Boresult blocks
                              51     Employee Window - After Store Employee

                              //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
                              52     Employee status changed by user

                              60     If Hook present, Job Costing actual update will check if anaylsis line type set to 1, if so, charge
                                     to be set same as cost on job actual line.

                              70     Upon completion of Job invoicing wizard.

                              75     Upon sucessfull exit of Payrate code on job budget or payrate/scode
                              76     Upon store of Job Budget
                              77     Upon Entry of Job Code. Allows JobCode to be set externaly.
                              78     Upon exit of Job Manager.

                              80     Allows overwrite of G/L code (NomCode) during generation of invoice from invoicing wizard.

                              85     Allow any Job field search via ObjectFind to be overridden. StrResult will contain any text typed in to ObjectFind.
                                     The seach using combo box must be set to Any Field in order to trigger the hook.
                                     BoResult must be returned TRUE if the external hook has found a valid match, and return the completed
                                     Primary key (Job Code) in StrResult. The customisation will then attempt to find the record by the primary
                                     key returned using the primary index.

                              90     When this hook is enabled, the LastUsed field on stock master records and corresponding location records
                                     is not updated during stock movements, only during edits. Only applies to SPOP versions

                             100     During the Posting of a timesheet, and the creation of NOM/PPI,PJI lines, when this hook enabled, allow Override of Line Xchange Rate, and UD fields.
                                     When the hook is executed, StrResult contains the Timesheet ouref being posted.
                             101 
                             103     During the creation of the WIP reversal Nom, when this hook is enabled, allows Override of UD fields.
                                     StrResult contains the Ouref of the Transaction being reversed.
                             110     During selection of Completed, or Closed on a Job record, if BoResult is True, then option to transfer WIP is chosen, otherwise
                                     the option is ignored.

                             120-128 Custom button 1 on Job Daybook Page 0-4.
                             130-138 Custom button 2 on Job Daybook Page 0-4.

                             140-144 Custom button 3 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)
                             150-154 Custom button 4 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)
                             160-164 Custom button 5 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)
                             170-174 Custom button 6 on JobRecord Page 0-4. (Note only pages 0 & 2 are available)

                             220-228 Custom button 3 on Job Daybook Page 0-4.
                             230-238 Custom button 4 on Job Daybook Page 0-4.
                             240-248 Custom button 5 on Job Daybook Page 0-4.
                             250-258 Custom button 6 on Job Daybook Page 0-4.

================================================================================
  Text Ids
  ~~~~~~~~

  1000                         1     Customer List Custom Button 1
                               2     Customer List Custom Button 2
                               3     Supplier List Custom Button 1
                               4     Supplier List Custom Button 2

                              20     Customer Ledger Custom Button 1
                              21     Customer Ledger Custom Button 2
                              30     Supplier Ledger Custom Button 1
                              31     Supplier Ledger Custom Button 2

                             141     Customer List Custom Button 3
                             142     Customer List Custom Button 4
                             143     Customer List Custom Button 5
                             144     Customer List Custom Button 6

                             145     Customer Ledger Custom Button 3
                             146     Customer Ledger Custom Button 4
                             147     Customer Ledger Custom Button 5
                             148     Customer Ledger Custom Button 6

                             151     Supplier List Custom Button 3
                             152     Supplier List Custom Button 4
                             153     Supplier List Custom Button 5 
                             154     Supplier List Custom Button 6

                             155     Supplier Ledger Custom Button 3
                             156     Supplier Ledger Custom Button 4
                             157     Supplier Ledger Custom Button 5
                             158     Supplier Ledger Custom Button 6


--------------------------------------------------------------------------------                              
  2000                         3     Main Transaction Sales Cust Button 1 
                               4     Main Transaction Sales Cust Button 2 
                               5     Main Transaction Purch Cust Button 1 
                               6     Main Transaction Purch Cust Button 2 

                               1     Sales Daybook Cust Button 1 Failsafe if 11 not working
                               2     Sales Daybook Cust Button 2          "
                               3     Purch Daybook Cust Button 1          "
                               4     Purch Daybook Cust Button 2          "
                              
                              10     Sales Daybook Page 0 Cust Button 1
                              11     Sales Daybook Page 1 Cust Button 1
                              12     Sales Daybook Page 2 Cust Button 1
                              13     Sales Daybook Page 3 Cust Button 1
                              14     Sales Daybook Page 4 Cust Button 1
                              15     Sales Daybook Page 5 Cust Button 1
                             
                              16     Stock Adjustment Custom button 1 Edit & View mode
                              17     Stock Adjustment Custom button 2 Edit & View mode

                              20     Sales Daybook Page 0 Cust Button 2
                              21     Sales Daybook Page 1 Cust Button 2
                              22     Sales Daybook Page 2 Cust Button 2
                              23     Sales Daybook Page 3 Cust Button 2
                              24     Sales Daybook Page 4 Cust Button 2
                              25     Sales Daybook Page 5 Cust Button 2

                              30     WOR Custom button 1 Edit & View mode
                              31     WOR Custom button 2 Edit & View mode

                             110     Purch Daybook Page 0 Cust Button 1
                             111     Purch Daybook Page 1 Cust Button 1
                             112     Purch Daybook Page 2 Cust Button 1
                             113     Purch Daybook Page 3 Cust Button 1
                             114     Purch Daybook Page 4 Cust Button 1
                             115     Purch Daybook Page 5 Cust Button 1
                             
                             120     Purch Daybook Page 0 Cust Button 2
                             121     Purch Daybook Page 1 Cust Button 2
                             122     Purch Daybook Page 2 Cust Button 2
                             123     Purch Daybook Page 3 Cust Button 2
                             124     Purch Daybook Page 4 Cust Button 2
                             125     Purch Daybook Page 5 Cust Button 2

                             301     Nominal Daybook Page 0 Cust Button 1
                             302     Nominal Daybook Page 1 Cust Button 1
                             303     Nominal Daybook Page 2 Cust Button 1
                             304     Nominal Daybook Page 3 Cust Button 1
                             305     Nominal Daybook Page 4 Cust Button 1
                             306     Nominal Daybook Page 5 Cust Button 1
                             
                             311     Nominal Daybook Page 0 Cust Button 2
                             312     Nominal Daybook Page 1 Cust Button 2
                             313     Nominal Daybook Page 2 Cust Button 2
                             314     Nominal Daybook Page 3 Cust Button 2
                             315     Nominal Daybook Page 4 Cust Button 2
                             316     Nominal Daybook Page 5 Cust Button 2
                             
                             321     Nominal Daybook Page 0 Cust Button 3
                             322     Nominal Daybook Page 1 Cust Button 3
                             323     Nominal Daybook Page 2 Cust Button 3
                             324     Nominal Daybook Page 3 Cust Button 3
                             325     Nominal Daybook Page 4 Cust Button 3
                             326     Nominal Daybook Page 5 Cust Button 3
                             
                             331     Nominal Daybook Page 0 Cust Button 4
                             332     Nominal Daybook Page 1 Cust Button 4
                             333     Nominal Daybook Page 2 Cust Button 4
                             334     Nominal Daybook Page 3 Cust Button 4
                             335     Nominal Daybook Page 4 Cust Button 4
                             336     Nominal Daybook Page 5 Cust Button 4
                             
                             341     Nominal Daybook Page 0 Cust Button 5
                             342     Nominal Daybook Page 1 Cust Button 5
                             343     Nominal Daybook Page 2 Cust Button 5
                             344     Nominal Daybook Page 3 Cust Button 5
                             345     Nominal Daybook Page 4 Cust Button 5
                             346     Nominal Daybook Page 5 Cust Button 5
                             
                             351     Nominal Daybook Page 0 Cust Button 6
                             352     Nominal Daybook Page 1 Cust Button 6
                             353     Nominal Daybook Page 2 Cust Button 6
                             354     Nominal Daybook Page 3 Cust Button 6
                             355     Nominal Daybook Page 4 Cust Button 6
                             356     Nominal Daybook Page 5 Cust Button 6
                             
                             361     Sales Daybook Page 0 Cust Button 3
                             362     Sales Daybook Page 1 Cust Button 3
                             363     Sales Daybook Page 2 Cust Button 3
                             364     Sales Daybook Page 3 Cust Button 3
                             365     Sales Daybook Page 4 Cust Button 3
                             366     Sales Daybook Page 5 Cust Button 3

                             371     Sales Daybook Page 0 Cust Button 4
                             372     Sales Daybook Page 1 Cust Button 4
                             373     Sales Daybook Page 2 Cust Button 4
                             374     Sales Daybook Page 3 Cust Button 4
                             375     Sales Daybook Page 4 Cust Button 4
                             376     Sales Daybook Page 5 Cust Button 4

                             381     Sales Daybook Page 0 Cust Button 5
                             382     Sales Daybook Page 1 Cust Button 5
                             383     Sales Daybook Page 2 Cust Button 5
                             384     Sales Daybook Page 3 Cust Button 5
                             385     Sales Daybook Page 4 Cust Button 5
                             386     Sales Daybook Page 5 Cust Button 5

                             391     Sales Daybook Page 0 Cust Button 6
                             392     Sales Daybook Page 1 Cust Button 6
                             393     Sales Daybook Page 2 Cust Button 6
                             394     Sales Daybook Page 3 Cust Button 6
                             395     Sales Daybook Page 4 Cust Button 6
                             396     Sales Daybook Page 5 Cust Button 6

                             401     Purch Daybook Page 0 Cust Button 3
                             402     Purch Daybook Page 1 Cust Button 3
                             403     Purch Daybook Page 2 Cust Button 3
                             404     Purch Daybook Page 3 Cust Button 3
                             405     Purch Daybook Page 4 Cust Button 3
                             406     Purch Daybook Page 5 Cust Button 3
                             
                             411     Purch Daybook Page 0 Cust Button 4
                             412     Purch Daybook Page 1 Cust Button 4
                             413     Purch Daybook Page 2 Cust Button 4
                             414     Purch Daybook Page 3 Cust Button 4
                             415     Purch Daybook Page 4 Cust Button 4
                             416     Purch Daybook Page 5 Cust Button 4

                             421     Purch Daybook Page 0 Cust Button 5
                             422     Purch Daybook Page 1 Cust Button 5
                             423     Purch Daybook Page 2 Cust Button 5
                             424     Purch Daybook Page 3 Cust Button 5
                             425     Purch Daybook Page 4 Cust Button 5
                             426     Purch Daybook Page 5 Cust Button 5
                             
                             431     Purch Daybook Page 0 Cust Button 6
                             432     Purch Daybook Page 1 Cust Button 6
                             433     Purch Daybook Page 2 Cust Button 6
                             434     Purch Daybook Page 3 Cust Button 6
                             435     Purch Daybook Page 4 Cust Button 6
                             436     Purch Daybook Page 5 Cust Button 6

                             441     Main Transaction Sales Cust Button 3 Edit mode
                             442     Main Transaction Sales Cust Button 4 Edit mode 
                             443     Main Transaction Sales Cust Button 5 Edit mode
                             444     Main Transaction Sales Cust Button 6 Edit mode

                             445     Main Transaction Purch Cust Button 3 Edit mode
                             446     Main Transaction Purch Cust Button 4 Edit mode 
                             447     Main Transaction Purch Cust Button 5 Edit mode
                             448     Main Transaction Purch Cust Button 6 Edit mode

                             451     Stock Adjustment Custom button 3 Edit mode
                             452     Stock Adjustment Custom button 4 Edit mode
                             453     Stock Adjustment Custom button 5 Edit mode
                             454     Stock Adjustment Custom button 6 Edit mode
                             
                             455     WOR Custom button 3 Edit mode
                             456     WOR Custom button 4 Edit mode
                             457     WOR Custom button 5 Edit mode
                             458     WOR Custom button 6 Edit mode

                             541     Main Transaction Sales Cust Button 3 View mode
                             542     Main Transaction Sales Cust Button 4 View mode 
                             543     Main Transaction Sales Cust Button 5 View mode
                             544     Main Transaction Sales Cust Button 6 View mode
                               
                             545     Main Transaction Purch Cust Button 3 View mode
                             546     Main Transaction Purch Cust Button 4 View mode
                             547     Main Transaction Purch Cust Button 5 View mode
                             548     Main Transaction Purch Cust Button 6 View mode

                             551     Stock Adjustment Custom button 3 View mode
                             552     Stock Adjustment Custom button 4 View mode
                             553     Stock Adjustment Custom button 5 View mode
                             554     Stock Adjustment Custom button 6 View mode

                             555     WOR Custom button 3 View mode
                             556     WOR Custom button 4 View mode
                             557     WOR Custom button 5 View mode
                             558     WOR Custom button 6 View mode
                             
                             // PKR. 04/11/2015. ABSEXCH-16348 Add Custom Buttons to Works Order Daybook.
                             561     Custom Button 1 on Works Order daybook Main tab
                             562     Custom Button 2 on Works Order daybook Main tab
                             563     Custom Button 3 on Works Order daybook Main tab
                             564     Custom Button 4 on Works Order daybook Main tab
                             565     Custom Button 5 on Works Order daybook Main tab
                             566     Custom Button 6 on Works Order daybook Main tab

                             571     Custom Button 1 on Works Order daybook History tab
                             572     Custom Button 2 on Works Order daybook History tab
                             573     Custom Button 3 on Works Order daybook History tab
                             574     Custom Button 4 on Works Order daybook History tab
                             575     Custom Button 5 on Works Order daybook History tab
                             576     Custom Button 6 on Works Order daybook History tab
                             
--------------------------------------------------------------------------------                              
  2050                        15     Batch payments/receipts Custom Button 1


--------------------------------------------------------------------------------                              
  3000                         1     Stock Record Custom Button 1 Main tab
                               2     Stock Record Custom Button 1 Defaults tab
                               3     Stock Record Custom Button 1 Returns tab
                               4     Stock Record Custom Button 1 Qty Breaks tab
                               5     Stock Record Custom Button 1 Ledger tab
                               6     Stock Record Custom Button 1 Value tab
                               7     Stock Record Custom Button 1 Build tab
                               8     Stock Record Custom Button 1 Serial tab
                               9     Stock Record Custom Button 1 VAT/Web tab
                              10     Stock Record Custom Button 1 WOP tab
                              21     Stock Record Custom Button 1 Multi-buy tab

                              11     Stock Record Custom Button 2 Main tab
                              12     Stock Record Custom Button 2 Defaults tab
                              19     Stock Record Custom Button 2 VAT/Web tab
                              20     Stock Record Custom Button 2 WOP tab
                              13     Stock Record Custom Button 2 Returns tab
                              14     Stock Record Custom Button 2 Qty Breaks tab
                             112     Stock Record Custom Button 2 Multi-buy tab
                              15     Stock Record Custom Button 2 Ledger tab
                              16     Stock Record Custom Button 2 Value tab
                              17     Stock Record Custom Button 2 Build tab
                              18     Stock Record Custom Button 2 Serial tab

                             221     Stock Record Custom Button 3 Main tab
                             222     Stock Record Custom Button 3 Defaults tab
                             229     Stock Record Custom Button 3 VAT/Web tab
                             228     Stock Record Custom Button 3 WOP tab
                             223     Stock Record Custom Button 3 Returns tab
                             224     Stock Record Custom Button 3 Qty Breaks tab
                             261     Stock Record Custom Button 3 Multi-buy tab
                             225     Stock Record Custom Button 3 Ledger tab
                             226     Stock Record Custom Button 3 Value tab
                             227     Stock Record Custom Button 3 Build tab
                             230     Stock Record Custom Button 3 Serial tab

                             231     Stock Record Custom Button 4 Main tab
                             232     Stock Record Custom Button 4 Defaults tab
                             239     Stock Record Custom Button 4 VAT/Web tab
                             238     Stock Record Custom Button 4 WOP tab
                             233     Stock Record Custom Button 4 Returns tab
                             234     Stock Record Custom Button 4 Qty Breaks tab
                             271     Stock Record Custom Button 4 Multi-buy tab
                             235     Stock Record Custom Button 4 Ledger tab
                             236     Stock Record Custom Button 4 Value tab
                             237     Stock Record Custom Button 4 Build tab
                             240     Stock Record Custom Button 4 Serial tab
                             
                             241     Stock Record Custom Button 5 Main tab
                             242     Stock Record Custom Button 5 Defaults tab
                             249     Stock Record Custom Button 5 VAT/Web tab
                             248     Stock Record Custom Button 5 WOP tab
                             243     Stock Record Custom Button 5 Returns tab
                             244     Stock Record Custom Button 5 Qty Breaks tab
                             281     Stock Record Custom Button 5 Multi-buy tab
                             245     Stock Record Custom Button 5 Ledger tab
                             246     Stock Record Custom Button 5 Value tab
                             247     Stock Record Custom Button 5 Build tab
                             250     Stock Record Custom Button 5 Serial tab
                             
                             251     Stock Record Custom Button 6 Main tab
                             252     Stock Record Custom Button 6 Defaults tab
                             259     Stock Record Custom Button 6 VAT/Web tab
                             258     Stock Record Custom Button 6 WOP tab
                             253     Stock Record Custom Button 6 Returns tab
                             254     Stock Record Custom Button 6 Qty Breaks tab
                             291     Stock Record Custom Button 6 Multi-buy tab
                             255     Stock Record Custom Button 6 Ledger tab
                             256     Stock Record Custom Button 6 Value tab
                             257     Stock Record Custom Button 6 Build tab
                             260     Stock Record Custom Button 6 Serial tab

                             
--------------------------------------------------------------------------------                              
  3001                         1     Stock Record Custom button 1 Main Tab
                               2     Stock Record Custom button 1 Defaults Tab
                               3     Stock Record Custom button 1 Notes Tab
                               4     Stock Record Custom button 1 Qty Breaks Tab
                               5     Stock Record Custom button 1 Ledger Tab
                               6     Stock Record Custom button 1 Value Tab
                               7     Stock Record Custom button 1 Build Tab
                               8     Stock Record Custom button 1 Serial Tab
                               9     Stock Record Custom button 1 VAT Tab
                              10     Stock Record Custom button 1 WOP Tab

                              11     Stock Record Custom button 2 Main Tab
                              12     Stock Record Custom button 2 Defaults Tab
                              13     Stock Record Custom button 2 Notes Tab
                              14     Stock Record Custom button 2 Qty Breaks Tab
                              15     Stock Record Custom button 2 Ledger Tab
                              16     Stock Record Custom button 2 Value Tab
                              17     Stock Record Custom button 2 Build Tab
                              18     Stock Record Custom button 2 Serial Tab
                              19     Stock Record Custom button 2 VAT Tab
                              20     Stock Record Custom button 2 WOP Tab

--------------------------------------------------------------------------------                              
  5000                        10     Job Daybook Custom Button 1 Main Tab
                              11     Job Daybook Custom Button 1 Timesheet Tab
                              12     Job Daybook Custom Button 1 Timesheet History Tab
                              13     Apps Daybook Custom Button 1 Purchase Tab
                              14     Apps Daybook Custom Button 1 Purchase History Tab
                              15     Apps Daybook Custom Button 1 Sales Tab
                              16     Apps Daybook Custom Button 1 Sales History Tab
                              17     Job Daybook Custom Button 1 P/L Retentions Tab
                              18     Job Daybook Custom Button 1 S/L Retentions Tab
                              20     Job Daybook Custom Button 2 Main Tab
                              21     Job Daybook Custom Button 2 Timesheet Tab
                              22     Job Daybook Custom Button 2 Timesheet History Tab
                              23     Apps Daybook Custom Button 2 Purchase Tab
                              24     Apps Daybook Custom Button 2 Purchase History Tab
                              25     Apps Daybook Custom Button 2 Sales Tab
                              26     Apps Daybook Custom Button 2 Sales History Tab
                              27     Job Daybook Custom Button 2 P/L Retentions Tab
                              28     Job Daybook Custom Button 2 S/L Retentions Tab

                             140     Job Record Custom Button 3 Main Tab
                             141     Job Record Custom Button 3 Notes Tab
                             142     Job Record Custom Button 3 ledger Tab
                             143     Job Record Custom Button 3 Purch Retentions Tab
                             144     Job Record Custom Button 3 Sales Retentions Tab
                             
                             150     Job Record Custom Button 4 Main Tab
                             151     Job Record Custom Button 4 Notes Tab
                             152     Job Record Custom Button 4 ledger Tab
                             153     Job Record Custom Button 4 Purch Retentions Tab
                             154     Job Record Custom Button 4 Sales Retentions Tab
                             
                             160     Job Record Custom Button 5 Main Tab
                             161     Job Record Custom Button 5 Notes Tab
                             162     Job Record Custom Button 5 ledger Tab
                             163     Job Record Custom Button 5 Purch Retentions Tab
                             164     Job Record Custom Button 5 Sales Retentions Tab
                             
                             170     Job Record Custom Button 6 Main Tab
                             171     Job Record Custom Button 6 Notes Tab
                             172     Job Record Custom Button 6 ledger Tab
                             173     Job Record Custom Button 6 Purch Retentions Tab
                             174     Job Record Custom Button 6 Sales Retentions Tab
                             
                             220     Job Daybook Custom Button 3 Job Pre-Postings Tab
                             221     Job Daybook Custom Button 3 Timesheets Tab
                             222     Job Daybook Custom Button 3 Time Sheet History Tab
                             223     Job Daybook Custom Button 3 Purchase Apps Tab
                             224     Job Daybook Custom Button 3 Purchase Apps History Tab
                             225     Job Daybook Custom Button 3 Sales Apps Tab
                             226     Job Daybook Custom Button 3 Sales App History Tab
                             227     Job Daybook Custom Button 3 P/L Retentions Tab
                             228     Job Daybook Custom Button 3 S/L Retentions Tab
                             
                             230     Job Daybook Custom Button 4 Job Pre-Postings Tab
                             231     Job Daybook Custom Button 4 Timesheets Tab
                             232     Job Daybook Custom Button 4 Time Sheet History Tab
                             233     Job Daybook Custom Button 4 Purchase Apps Tab
                             234     Job Daybook Custom Button 4 Purchase Apps History Tab
                             235     Job Daybook Custom Button 4 Sales Apps Tab
                             236     Job Daybook Custom Button 4 Sales App History Tab
                             237     Job Daybook Custom Button 4 P/L Retentions Tab
                             238     Job Daybook Custom Button 4 S/L Retentions Tab
                             
                             240     Job Daybook Custom Button 5 Job Pre-Postings Tab
                             241     Job Daybook Custom Button 5 Timesheets Tab
                             242     Job Daybook Custom Button 5 Time Sheet History Tab
                             243     Job Daybook Custom Button 5 Purchase Apps Tab
                             244     Job Daybook Custom Button 5 Purchase Apps History Tab
                             245     Job Daybook Custom Button 5 Sales Apps Tab
                             246     Job Daybook Custom Button 5 Sales App History Tab
                             247     Job Daybook Custom Button 5 P/L Retentions Tab
                             248     Job Daybook Custom Button 5 S/L Retentions Tab
                             
                             250     Job Daybook Custom Button 5 Job Pre-Postings Tab
                             251     Job Daybook Custom Button 5 Timesheets Tab
                             252     Job Daybook Custom Button 5 Time Sheet History Tab
                             253     Job Daybook Custom Button 5 Purchase Apps Tab
                             254     Job Daybook Custom Button 5 Purchase Apps History Tab
                             255     Job Daybook Custom Button 5 Sales Apps Tab
                             256     Job Daybook Custom Button 5 Sales App History Tab
                             257     Job Daybook Custom Button 5 P/L Retentions Tab
                             258     Job Daybook Custom Button 5 S/L Retentions Tab
--------------------------------------------------------------------------------                              
*}

Const
  WinHandle_NumWindows  = 14;
  WinHandle_NumHandlers = 999;      { Number of events per window }


{ Validates the Window ID and Returns the remapped Id }
Function GetWinMapping(Var ArrayId, WinId : LongInt) : Boolean;
Function GetStringIndex(Const WinIdx : LongInt) : LongInt;

implementation

Uses Classes, Dialogs, SysUtils, Windows, CustWinU;

{ Validates the Window ID and Returns the remapped Id }
Function GetWinMapping(Var ArrayId, WinId : LongInt) : Boolean;
Const
  { Setup the Window remapping }
  WinMapping  : Array [1..WinHandle_NumWindows] Of LongInt =
                (190001,  { 01: Enterprise - Miscellaneous - VAT }
                 101000,  { 02: Enterprise - Account MP OCU validation }
                 102000,  { 03: Enterprise - Pre Store new/edit document }
                 102001,  { 04: Enterprise - Transaction Window Id for labels }
                 102050,  { 04: Enterprise - BACS Control }
                 103000,  { 05: Enterprise - Stock Record Stock Code Exit}
                 103001,  { 06: Enterprise - Stock Record Stock Wind}
                 103100,  { 07: Enterprise - Stock Batch Wind}
                 104000,  { 08: Enterprise - Id Line entry, Stock Code Entry...}
                 105000,  { 09: Enterprise - Job Record...}
                 190002,  { 10: Enterprise - System (Open/Close data) }
                 wiLocation, // v5.70 - Locations
                 wiStockLoc, // v5.70 - Stock-Locations
                 wiPrint     // v5.70 - Print Dialog
                );

Var
  I  : SmallInt;
Begin
  Result := False;

  If (ArrayId = -1) Then Begin
    { Set Array Id from WinId }
    For I := Low(WinMapping) To High(WinMapping) Do Begin
      If (WinMapping[I] = WinId) Then Begin
        ArrayId := I;
        Result := True;
        Break;
      End; { If }
    End; { For }
  End { If }
  Else Begin
    { Set WinId from Array Id }
    If (ArrayId >= 1) And (ArrayId  <= WinHandle_NumWindows) Then Begin
      WinId := WinMapping[ArrayId];
      Result := True;
    End; { If }
  End; { Else }
End;

{ Calculates and returns the start index of resource strings for the Window }
Function GetStringIndex(Const WinIdx : LongInt) : LongInt;
Var
  tArrId, tWinId : LongInt;
Begin
  Result := 0;

  tArrId := -1;
  tWinId := WinIdx;
  If GetWinMapping(tArrId, tWinId) Then Begin
    Result := tArrId * 400;
  End; { If }
End;

end.
