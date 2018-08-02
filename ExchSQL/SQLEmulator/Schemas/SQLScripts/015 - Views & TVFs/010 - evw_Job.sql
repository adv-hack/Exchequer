
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Job]'))
DROP VIEW [!ActiveSchema!].[evw_Job]
GO


CREATE VIEW [!ActiveSchema!].evw_Job
AS
SELECT JobId                    = JH.PositionId
     , JobFolioNo               = JH.JobFolio
     , JobCode                  = RTRIM(JH.JobCode)
     , JobDescription           = JH.JobDesc
     , JobContractTypeCode      = JH.JobType
     , JobType                  = JH.JobAnal
     , JT.JobTypeDescription
     , JH.JobStat
     , JS.JobStatusDescription
     , CustomerCode             = JH.CustCode
     , ParentJobId              = PJ.PositionId
     , ParentContractCode       = RTRIM(PJ.JobCode)
     , JH.ChargeType
     , CT.ChargeTypeDescription
     , JH.CostCentre
     , JH.Department
     , AlternativeJobCode       = JH.JobAltCode
     , IsCompleted              = CONVERT(BIT, JH.Completed)
     , Contact                  = JH.Contact
     , JobManager               = JH.JobMan
     , QuotePrice               = JH.QuotePrice
     , FixedPriceCurrency       = JH.CurrPrice
     , StartDate                = JH.StartDate
     , EndDate                  = JH.EndDate
     , RevisedCompletionDate    = JH.RevEDate
     , SalesOrderReference      = JH.SORRef
     , DefaultVATCode           = JH.VATCode
     , UDF1                     = JH.UserDef1
     , UDF2                     = JH.UserDef2
     , UDF3                     = JH.UserDef3
     , UDF4                     = JH.UserDef4
     , UDF5                     = JH.UserDef5
     , UDF6                     = JH.UserDef6
     , UDF7                     = JH.UserDef7
     , UDF8                     = JH.UserDef8
     , UDF9                     = JH.UserDef9
     , UDF10                    = JH.UserDef10
     , DefaultRetentionCurrency = JH.DefRetCurr
     , JPTOurReference          = JH.JPTOurRef
     , JSTOurReference          = JH.JSTOurRef
     , JQSCode                  = JH.JQSCode
     , NoteLineCount            = JH.NLineCount
     , AnalysisLineCount        = JH.ALineCount
	 , IsAnonymised	    		= JH.jrAnonymised
	 , AnonymisedDate		    = JH.jrAnonymisedDate
	 , AnonymisedTime		    = JH.jrAnonymisedTime
	 
FROM [!ActiveSchema!].JOBHEAD JH
LEFT JOIN [!ActiveSchema!].JOBHEAD        PJ  ON JH.JobCat     = PJ.JobCode
LEFT JOIN [!ActiveSchema!].evw_JobType    JT  ON JH.JobAnal    = JT.JobTypeCode
LEFT JOIN common.evw_JobStatus            JS  ON JH.JobStat    = JS.JobStatusId
LEFT JOIN common.evw_chargeType           CT  ON JH.ChargeType = CT.ChargeTypeId

GO

