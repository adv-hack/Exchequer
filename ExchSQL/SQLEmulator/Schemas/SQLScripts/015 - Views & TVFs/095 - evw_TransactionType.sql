/****** Object:  View [common].[evw_TransactionType]    Script Date: 20/02/2015 09:53:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_TransactionType]'))
DROP VIEW [common].[evw_TransactionType]
GO

CREATE VIEW [common].[evw_TransactionType] WITH VIEW_METADATA
AS
SELECT *
FROM ( VALUES ( 0, 'SIN', 'Sales Invoice'                , -1, -1,  100, CONVERT(BIT,1), 'N' )
            , ( 1, 'SRC', 'Sales Receipt'                ,  1,  0,  100, CONVERT(BIT,1), 'Y' )
            , ( 2, 'SCR', 'Sales Credit Note'            ,  1,  1,  100, CONVERT(BIT,1), 'Y' )
            , ( 3, 'SJI', 'Sales Journal Invoice'        , -1, -1,  100, CONVERT(BIT,1), 'N' )
            , ( 4, 'SJC', 'Sales Journal Credit Note'    ,  1,  1,  100, CONVERT(BIT,1), 'Y' )
            , ( 5, 'SRF', 'Sales Refund'                 ,  1,  1,  100, CONVERT(BIT,1), 'Y' )
            , ( 6, 'SRI', 'Sales Receipt Invoice'        , -1, -1,  100, CONVERT(BIT,1), 'N' )
            , ( 7, 'SQU', 'Sales Quotation'              , -1,  1,  100, CONVERT(BIT,0), 'N' )
            , ( 8, 'SOR', 'Sales Order'                  , -1,  1,  100, CONVERT(BIT,0), 'N' )
            , ( 9, 'SDN', 'Sales Delivery Note'          , -1, -1,  100, CONVERT(BIT,0), 'N' )
            , (10, 'SBT', 'Sales Batch'                  , -1,  0,  100, CONVERT(BIT,0), 'N' )
            , (11, 'SDG', 'Settlement Discounts Given'   ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (12, 'NDG', 'Standard Discounts Given'     ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (13, 'OVT', 'Output VAT'                   , -1,  0, NULL, CONVERT(BIT,0), 'Y' )
            , (14, 'DEB', 'Debtors Controls A/C'         ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (15, 'PIN', 'Purchase Invoice'             ,  1,  1,  101, CONVERT(BIT,1), 'Y' )
            , (16, 'PPY', 'Purchase Payment'             , -1,  0,  101, CONVERT(BIT,1), 'N' )
            , (17, 'PCR', 'Purchase Credit Note'         , -1, -1,  101, CONVERT(BIT,1), 'N' )
            , (18, 'PJI', 'Purchase Journal Invoice'     ,  1,  1,  101, CONVERT(BIT,1), 'Y' )
            , (19, 'PJC', 'Purchase Journal Credit Note' , -1, -1,  101, CONVERT(BIT,1), 'N' )
            , (20, 'PRF', 'Purchase Refund'              , -1, -1,  101, CONVERT(BIT,1), 'N' )
            , (21, 'PPI', 'Purchase Payment with Invoice',  1,  1,  101, CONVERT(BIT,1), 'Y' )
            , (22, 'PQU', 'Purchase Quotation'           ,  1,  1,  101, CONVERT(BIT,0), 'Y' )
            , (23, 'POR', 'Purchase Order'               ,  1,  1,  101, CONVERT(BIT,0), 'Y' )
            , (24, 'PDN', 'Purchase Delivery Note'       ,  1,  1,  101, CONVERT(BIT,0), 'Y' )
            , (25, 'PBT', 'Purchase Batch'               ,  1,  0,  101, CONVERT(BIT,0), 'Y' )
            , (26, 'SDT', 'Settlement Discount Taken'    ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (27, 'NDT', 'Standard Discounts Taken'     ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (28, 'IVT', 'Input VAT'                    ,  1,  0, NULL, CONVERT(BIT,0), 'N' )
            , (29, 'CRE', 'Creditors Control a/c'        , -1,  0, NULL, CONVERT(BIT,0), 'Y' )
            , (30, 'NOM', 'Nominal Transfer'             ,  1,  0, NULL, CONVERT(BIT,1), 'T' )
            , (31, 'RUN', 'Posting Run'                  ,  1,  0, NULL, CONVERT(BIT,1), 'C' )
            , (32, 'FOL', 'Folio Number'                 ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (33, 'AFL', 'Automatic Folio Number'       ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (34, 'ADC', 'Automatic Document'           ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (35, 'ADJ', 'Stock Adjustment'             ,  1,  1, NULL, CONVERT(BIT,0), 'S' )
            , (36, 'ACQ', 'Automatic Cheque Number'      ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (37, 'API', 'Automatic Pay-In Reference'   ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (38, 'SKF', 'Stock Folio Number'           ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (39, 'JBF', 'Job Folio Number'             ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (40, 'WOR', 'Works Order'                  , -1,  1, NULL, CONVERT(BIT,0), 'C' )
            , (41, 'TSH', 'Timesheet'                    ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (42, 'JRN', 'Job Posting Run'              ,  1,  0, NULL, CONVERT(BIT,0), 'C' )
            , (43, 'WIN', 'Works Issue Note'             , -1,  1, NULL, CONVERT(BIT,0), 'C' )
            , (44, 'SRN', 'Sales Return Note'            , -1,  1,  100, CONVERT(BIT,0), 'C' )
            , (45, 'PRN', 'Purchase Return Note'         ,  1, -1,  101, CONVERT(BIT,0), 'C' )
            , (46, 'JCT', 'Job Contract Terms'           ,  1,  0,  102, CONVERT(BIT,0), 'C' )
            , (47, 'JST', 'Job Sales Terms'              , -1,  0,  102, CONVERT(BIT,0), 'C' )
            , (48, 'JPT', 'Job Purchase Terms'           ,  1,  0,  102, CONVERT(BIT,0), 'C' )
            , (49, 'JSA', 'Job Sales Application'        , -1,  0,  102, CONVERT(BIT,0), 'C' )
            , (50, 'JPA', 'Job Purchase Application'     ,  1,  0,  102, CONVERT(BIT,0), 'C' )
            -- Parents
            , (100, 'STT', 'Sales Transaction Types'     , -1,  0, NULL, CONVERT(BIT,0), NULL )
            , (101, 'PTT', 'Purchase Transaction Types'  ,  1,  0, NULL, CONVERT(BIT,0), NULL )
            , (102, 'JTT', 'Job Transaction Types'       ,  1,  0, NULL, CONVERT(BIT,0), NULL )

     ) AS etb_TransactionType ( TransactionTypeId
                              , TransactionTypeCode
                              , TransactionTypeDescription
                              , TransactionTypeSign
                              , StockMovementSign
                              , ParentTransactionTypeId
                              , IsFinancialType
                              , PaymentType
                              )



GO


