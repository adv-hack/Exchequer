unit ICENom;

interface

Procedure ApplyPracticeLimitations;

implementation

Uses GlobVar, VarConst, EntLicence, uIceDripFeed;

Procedure ApplyPracticeLimitations;
Begin // ApplyPracticeLimitations
  Try
    { Set by external class to indicate drip feed mode is on }
    If (EnterpriseLicence.elProductType = ptLITEAcct) And GetDripFeed.IsActive Then
    Begin
      With EntryRec^ Do
      Begin
        // Sales Transactions
        {Access[355] := 0; // Sales - Ability to create Invoice (SIN)
        Access[356] := 0; // Sales - Ability to create Receipt (SRC)
        Access[410] := 0; // Sales - Use Wizard to Create Sales Receipt
        Access[357] := 0; // Sales - Ability to create Credit Note (SCR)
        Access[358] := 0; // Sales - Ability to create Quotation (SQU)
        Access[359] := 0; // Sales - Ability to create Journal Invoice (SJI)
        Access[360] := 0; // Sales - Ability to create Journal Credit (SJC)
        Access[361] := 0; // Sales - Ability to create Receipt with Invoice (SRI)
        Access[362] := 0; // Sales - Ability to create Refund (SRF)
        Access[363] := 0; // Sales - Ability to create Batch (SBT)}

        // Sales Daybook
        Access[002] := 0; // Sales - Add a Transaction
        Access[007] := 0; // Sales - Convert Quotation to Invoice
        Access[283] := 0; // Sales - Convert Quotation to Order
        Access[101] := 0; // Sales - Copy/Reverse a Transaction

        // Sales Order Daybook
        Access[145] := 0; // Sales Orders - Add a Transaction
        Access[161] := 0; // Sales Orders - Process Orders
        Access[163] := 0; // Sales Orders - Copy/Reverse Transaction
        Access[183] := 0; // Sales Orders - Deliver Individual Order
        Access[184] := 0; // Sales Orders - Deliver Picked Orders
        Access[185] := 0; // Sales Orders - Invoice Single Delivery
        Access[186] := 0; // Sales Orders - Invoice All Deliveries

        // Purchase Transactions
        {Access[364] := 0; // Purchase - Ability to create Invoice (PIN)
        Access[365] := 0; // Purchase - Ability to create Payment (PPY)
        Access[413] := 0; // Purchase - Use Wizard to Create Purchase Payment
        Access[366] := 0; // Purchase - Ability to create Credit Note (PCR)
        Access[367] := 0; // Purchase - Ability to create Quotation (PQU)
        Access[368] := 0; // Purchase - Ability to create Journal Invoice (PJI)
        Access[369] := 0; // Purchase - Ability to create Journal Credit (PJC)
        Access[370] := 0; // Purchase - Ability to create Payment with Invoice (PPI)
        Access[371] := 0; // Purchase - Ability to create Refund (PRF)
        Access[372] := 0; // Purchase - Ability to create Batch (PBT)}

        // Purchase Daybook
        Access[011] := 0; // Purchase - Add a Transaction
        Access[016] := 0; // Purchase - Convert Quotation to Invoice
        Access[284] := 0; // Purchase - Convert Quotation to Order
        Access[102] := 0; // Purchase - Copy/Reverse a Transaction

        // Purchase Order Daybook
        Access[165] := 0; // Purchase Orders - Add a Transaction
        Access[170] := 0; // Purchase Orders - Receive Orders
        Access[171] := 0; // Purchase Orders - Process Orders
        Access[173] := 0; // Purchase Orders - Copy/Reverse Transaction
        Access[188] := 0; // Purchase Orders - Deliver Individual Order
        Access[189] := 0; // Purchase Orders - Deliver Received Orders
        Access[190] := 0; // Purchase Orders - Invoice Single Delivery
        Access[191] := 0; // Purchase Orders - Invoice Tagged Deliveries

        // Stock Adjustments
        Access[117] := 0; // Stock Adjustment - Add
        Access[118] := 0; // Stock Adjustment - Edit
        Access[120] := 0; // Stock Adjustment - Suspend
        Access[121] := 0; // Stock Adjustment - Hold
        Access[122] := 0; // Stock Adjustment - Daybook Post
        Access[123] := 0; // Stock Adjustment - Copy/Reverse

        // Customer Miscellaneous
        Access[036] := 0; // Customer Details - Check/Re-Calc Allocations

        // Supplier Miscellaneous
        Access[046] := 0; // Supplier Details - Check/Re-Calc Allocations

        // Stock Records
        Access[473] := 0; // Stock Records - Check

        // Utilities
        Access[195] := 0; // Utilities - Access Data Recovery
      End; // With EntryRec^
    End; // If (EnterpriseLicence.elProductType = ptLITEAcct) And GetDripFeed.IsActive
  Except
    ; // Bury Errors
  End; // Try..Except

End; // ApplyPracticeLimitations


end.
