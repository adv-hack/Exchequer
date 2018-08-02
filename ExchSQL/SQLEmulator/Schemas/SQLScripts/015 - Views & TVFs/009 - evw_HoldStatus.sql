IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[common].[evw_HoldStatus]'))
DROP VIEW [common].[evw_HoldStatus]
GO

CREATE VIEW common.evw_HoldStatus WITH VIEW_METADATA
AS
SELECT HoldStatusId
     , HoldStatusDescription
     , HoldStatusShortDescription
     , OnHold = CONVERT(BIT, OnHold)
     , IsSuspended = CONVERT(BIT, IsSuspended)
FROM ( VALUES (  0, 'Not Held', '', 0, 0)
            , (  1, 'Hold for Query','Query', 1, 0)
            , (  2, 'Hold Until Allocated','UntilAlloc', 1, 0)
            , (  3, 'Authorised','Authorised', 0, 0)
            , (  4, 'Hold for stock','Wait Stk', 1, 0)
            , (  5, 'Hold for all stock','WaitAllStk', 1, 0)
            , (  6, 'Hold until credit cleared','Credit Hld', 1, 0)
            , ( 32, 'Document has Notes','Notes', 0, 0)
            , ( 33, 'Hold for Query - Document has Notes','Q/N', 1, 0)
            , ( 34, 'Hold Until Allocated - Document has Notes','U/N', 1, 0)
            , ( 35, 'Authorised - Document has Notes','A/N', 0, 0)
            , ( 36, 'Hold for stock - Document has Notes','W/N', 1, 0)
            , ( 37, 'Hold for all stock - Document has Notes','W/N', 1, 0)
            , ( 38, 'Hold until credit cleared - Document has Notes','C/N', 1, 0) 
            , (128, 'Suspend Posting','Suspend', 0, 1)
            , (129, 'Hold for Query - Suspend Posting','Q/S', 1, 1)
            , (130, 'Hold Until Allocated - Suspend Posting','U/S', 1, 1)
            , (131, 'Authorised - Suspend Posting','A/S', 0, 1)
            , (132, 'Hold for stock - Suspend Posting','W/S', 1, 1)
            , (133, 'Hold for all stock - Suspend Posting','W/S', 1, 1)
            , (134, 'Hold until credit cleared - Suspend Posting','C/S', 1, 1)
            , (160, 'Suspend Posting - Document has Notes','S/N', 0, 1)
            , (161, 'Hold for Query - Suspend Posting - Document has Notes','Q/S/N', 1, 1)
            , (162, 'Hold Until Allocated - Suspend Posting - Document has Notes','U/S/N', 1, 1)
            , (163, 'Authorised - Suspend Posting - Document has Notes','A/S/N', 0, 1)
            , (164, 'Hold for stock - Suspend Posting - Document has Notes','W/S/N', 1, 1)
            , (165, 'Hold for all stock - Suspend Posting - Document has Notes','W/S/N', 1, 1)
            , (166, 'Hold until credit cleared - Suspend Posting - Document has Notes','C/S/N', 1, 1)
     ) HS ( HoldStatusId
          , HoldStatusDescription
          , HoldStatusShortDescription
          , OnHold
          , IsSuspended
          )
GO


