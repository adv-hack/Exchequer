using System;
using System.Collections.Generic;
using System.Text;

//-------------------------------------------------------------------------------------------------
// History
//   Date       Who   Description
//-------------------------------------------------------------------------------------------------
// 24/06/2013   PKR   Added DSR_ViewVAT100Response for VAT 100 XML support.
//
//-------------------------------------------------------------------------------------------------

namespace IRIS.ICE.Common
{

    #region IWrapperDSR Interface

    // Declaration of methods exposed by the Remoting server's DSRWrapper class
    public interface IWrapperDSR
    {
        uint DSR_Export(uint pCompany, string pSubj,
                        string pFrom, string pTo,
                        string pParam1, string pParam2, uint pPackageId);

        uint DSR_Import(uint pCompany, Guid pGuid, uint pPackageId); 

        uint DSR_DeleteInboxMessage(uint pCompany, Guid pGuid); 

        uint DSR_DeleteOutboxMessage(uint pCompany,
                                     Guid pGuid); 

        uint DSR_GetInboxMessages(uint pCompany, uint pPackageID,
                                  sbyte pStatus, DateTime pDate,
                                  uint pMaxRecords, out object pMessages);

        uint DSR_GetOutboxMessages(uint pCompany, uint pPackageID,
                                  sbyte pStatus, DateTime pDate,
                                  uint pMaxRecords, out object pMessages); 

        uint DSR_NewInboxMessage(uint pMaxRecords, out object pMessages);

        uint DSR_TotalOutboxMessages(uint pCompany, out uint pMsgCount); 

        string DSR_TranslateErrorCode(uint pErrorCode); 

        uint DSR_ResendOutboxMessage(Guid pGuid);

        uint DSR_GetExportPackages(out object pPackage);

        uint DSR_GetImportPackages(out object pPackage);

        void DSR_SendLog(string pMail);

        uint DSR_DeleteCompany(uint pCompany);

        uint DSR_GetCompanies(out object pCompany);

        uint DSR_DeleteSchedule(Guid pGuid);
        
        // changed 04-05-2006
        uint DSR_SetDailySchedule(Guid pGuid, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId, DateTime pStartDate, DateTime pEndDate, DateTime pStartTime, sbyte pAllDays, sbyte pWeekDays, sbyte pEveryDay);
        
        uint DSR_BulkExport(uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2);

        // new 03-05-2006
        uint DSR_SyncRequest(uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2);

        uint DSR_CreateCompany(string pCompanyName, string pCompanyCode);
        
        uint DSR_AddNewUser(string pUserName, string pUserLogin, string pUserPassword);
        
        uint DSR_DeleteUser(string pUserLogin);
        
        uint DSR_GetUsers(out object pUsers);
        
        uint DSR_GetContacts(out object pContacts);
        
        uint DSR_DeleteContact(string pContactMail);

        uint DSR_AddNewContact(string pContactName, string pContactMail, uint pContactCompany);
        
        uint DSR_UpdateDSRSettings(string pXml);

        uint DSR_UpdateMailSettings(string pXml);

        // new 04-05-2006
        uint DSR_GetDsrSettings(out string pXml);

        uint DSR_GetMailSettings(out string pXml);

        uint DSR_ReCreateCompany(uint pCompany);

        // new 11-05-2006
        uint DSR_Alive();
        uint DSR_CheckCompanies();
        uint DSR_CheckMailNow();

        uint DSR_CheckDripFeed(uint pCompany, out uint pStatus);
        uint DSR_RemoveDripFeed(uint pCompany, string pFrom, string pTo, string pSubject);

        // 22-05-2006
        uint DSR_SetAdminPassword(string pAdminPass);

        // 14/06/2006
        uint DSR_GetDripFeedParams(uint pCompany, out string pPeriodYear1, out string pPeriodYear2);

        // 29/06/2006
        uint DSR_DeactivateCompany(uint pCompany);
        uint DSR_ActivateCompany(uint pCompany);

        string DSR_Version  { get; }

        uint DSR_Sync(uint pCompany, string pSubj,
                        string pFrom, string pTo,
                        string pParam1, string pParam2, uint pPackageId);

        // 09/08/2006
        uint DSR_IsVAO();
        uint DSR_ExProductType();

        // 11/08/2006
        uint DSR_GetInboxXml(Guid pGuid, uint pOrder, out string pXML);
        uint DSR_GetOutboxXml(Guid pGuid, uint pOrder, out string pXML);
        uint DSR_ViewCISResponse(Guid pOutboxGuid, Guid pFileGuid, out string pXML);

        // 24/06/2013. PKR. Added for VAT 100 XML support.
        uint DSR_ViewVAT100Response(Guid pOutboxGuid, Guid pFileGuid, out string pXML);

        // 19/10/2006
        uint DSR_GetExPeriodYear(uint pCompany, out string pPeriodYear1, out string pPeriodYear2);

        // 01/11/2006
        uint DSR_DenySyncRequest(uint pCompany, Guid pGuid);

        // 16/11/2006
        uint DSR_CancelDripfeed(uint pCompany, string pFrom, string pTo, string pSubject);

        // 28/11/2006 
        uint DSR_RestoreMessage(Guid pGuid);
    }


    #endregion
}
