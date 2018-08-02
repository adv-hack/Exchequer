IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Employee]'))
DROP VIEW [!ActiveSchema!].[evw_Employee]
GO

CREATE VIEW !ActiveSchema!.evw_Employee
AS
SELECT EmployeeId         = J.PositionId
     , EmployeeCode       = J.var_code1Trans1
     , EmployeeName       = J.EmpName
     , Surname            = J.var_code3
     , JobTitle           = CASE
                            WHEN J.Phone2 LIKE '%[0-9][0-9][0-9]%' THEN CONVERT(VARCHAR(50), '')
                            ELSE CONVERT(VARCHAR(50), J.Phone2)
                            END
     , CISTypeId          = J.CISType
     , CT.CISTypeDescription             
     , CISSubConTypeId    = J.CISSubType
     , CST.CISSubTypeDescription
     , CISTaxRateId       = CISTaxRate
     , CostCentreCode     = J.CostCentre
     , CC.CostCentreName
     , DepartmentCode     = J.Department
     , DP.DepartmentName
     , EmployeeTypeId     = J.EType
     , EmployeeTypeDescription
     , TimeRateRuleId     = J.UseORate
     , TimeRateRuleDescription
     , TraderCode         = J.var_code4
     , AddressLine1       = J.Addr1
     , AddressLine2       = J.Addr2
     , AddressLine3       = J.Addr3
     , AddressLine4       = J.Addr4
     , AddressLine5       = J.Addr5
     , PhoneNo            = J.Phone
     , MobileNo           = CASE
                            WHEN J.Phone2 LIKE '%[0-9][0-9][0-9]%' THEN CONVERT(VARCHAR(50), J.Phone2)
                            ELSE CONVERT(VARCHAR(50), '')
                            END
     , FaxNo              = J.Fax
     , EMail              = J.EmailAddr
     , CertificateNo      = J.CertNo
     , CertExpiryDate     = J.CertExpiry
     , NINumber           = J.ENINo
     , PayrollNo          = J.PayNo
     , IsTagged           = CONVERT(BIT, J.Tagged)
     , HMRCVerificationNo = J.HMRCVerifyNo
     , UniqueTaxReference = J.UTRCode
     , SelfBill           = J.GSelfBill
     , LabourCostsViaPL   = J.LabPLOnly
     , UDF1               = J.UserDef1
     , UDF2               = J.UserDef2
     , UDF3               = J.UserDef3
     , UDF4               = J.UserDef4

     , EmpVarBinCode1     = J.var_code1
     , EmpVarBinCode2     = J.var_code2
	 
	 , Status				  = J.emStatus
	 , AnonymisationStatus	  = ANONS.AnonymisationStatusDescription
	 , AnonymisedDate		  = J.emAnonymisedDate
	 , AnonymisedTime		  = J.emAnonymisedTime
     
FROM   !ActiveSchema!.JOBMISC J
JOIN   common.evw_EmployeeType ET  ON J.EType      = ET.EmployeeTypeId
JOIN   common.evw_TimeRateRule TRR ON J.UseORate   = TRR.TimeRateRuleId
JOIN   common.evw_CISType      CT  ON J.CISType    = CT.CISTypeId
JOIN   common.evw_CISSubType   CST ON J.CISSubType = CST.CISSubTypeId
LEFT JOIN   common.evw_AnonymisationStatus ANONS ON J.emAnonymisationStatus = ANONS.AnonymisationStatusId

LEFT JOIN !ActiveSchema!.evw_CostCentre CC ON CC.CostCentreCode = J.CostCentre
LEFT JOIN !ActiveSchema!.evw_Department DP ON DP.DepartmentCode = J.Department

WHERE  J.RecPfix = 'J'
AND    J.SubType = 'E'

GO