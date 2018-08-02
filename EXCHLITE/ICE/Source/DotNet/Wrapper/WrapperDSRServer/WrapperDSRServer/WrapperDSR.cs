using System;
using System.Collections.Generic;
using System.Text;
using DSR;
using IRIS.ICE.Common;
using System.Runtime.CompilerServices;


namespace WrapperDSRServer
{
    internal class WrapperDSR: MarshalByRefObject, IWrapperDSR
    {
        #region IWrapperDSR Members

        private const uint GENERIC_FAIL = 10000;
        private Guid instanceID;

        public WrapperDSR()
        {         
 
            // Get an instance identifier, so we can check which instance is executing
            // at a given time.
            instanceID = Guid.NewGuid();
            new DebugFileCtrl(false).WriteLog("Create WrapperDSR instance. Guid: " + instanceID.ToString());
        }

        // Returning null, should ensure that the object is not automatically disposed
        // of by the .NET remoting subsystem.
        public override Object InitializeLifetimeService()
        {
            return null;
        }

        public uint DSR_DeleteInboxMessage(uint pCompany, Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteInboxMessage from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteInboxMessage(pCompany, pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteInboxMessage): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_DeleteOutboxMessage(uint pCompany, Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteOutboxMessage from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteOutboxMessage(pCompany, pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteOutboxMessage): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_Export(uint pCompany,
                               string pSubj,
                               string pFrom,
                               string pTo,
                               string pParam1,
                               string pParam2,
                               uint pPackageId)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_Export from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_Export(pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_Export): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetInboxMessages(uint pCompany, uint pPackageID, sbyte pStatus, DateTime pDate, uint pMaxRecords, out object pMessages)
        {
            pMessages = null;

            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetInboxMessages from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetInboxMessages(pCompany, pPackageID, pStatus, pDate, pMaxRecords, out pMessages);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetInboxMessages): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetOutboxMessages(uint pCompany,
                                          uint pPackageID,
                                          sbyte pStatus,
                                          DateTime pDate,
                                          uint pMaxRecords,
                                          out object pMessages)
        {
            pMessages = null;

            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetOutboxMessages from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetOutboxMessages(pCompany, pPackageID, pStatus, pDate, pMaxRecords, out pMessages);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetOutboxMessages): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_Import(uint pCompany, Guid pGuid, uint pPackageId)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_Import from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_Import(pCompany, pGuid, pPackageId);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_Import): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_NewInboxMessage(uint pMaxRecords, out object pMessages)
        {
            pMessages = null;

            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_NewInboxMessage from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_NewInboxMessage(pMaxRecords, out pMessages);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_NewInboxMessage): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_TotalOutboxMessages(uint pCompany, out uint pMsgCount)
        {
            pMsgCount = 0;
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_TotalOutboxMessages from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_TotalOutboxMessages(pCompany, out pMsgCount);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_TotalOutboxMessages): " + err.Message);
                return GENERIC_FAIL;
            }
        }

         public string DSR_TranslateErrorCode(uint pErrorCode)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_TranslateErrorCode from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_TranslateErrorCode(pErrorCode);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_TranslateErrorCode): " + err.Message);
                return string.Empty;
            }
        }

        public uint DSR_ResendOutboxMessage(Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_ResendOutboxMessage from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_ResendOutboxMessage(pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_ResendOutboxMessage): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetExportPackages(out object pPackage)
        {
            pPackage = null;

            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetExportPackages from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetExportPackages(out pPackage);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetExportPackages): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetImportPackages(out object pPackage)
        {
            pPackage = null;

            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetImportPackages from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetImportPackages(out pPackage);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetImportPackages): " + err.Message);
                return GENERIC_FAIL;
            }
        }


        public void DSR_SendLog(string pMail)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_SendLog from within the remoting server. Guid: " + instanceID.ToString());

                GlobalDSR.WithDSR().DSR_SendLog(pMail);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_SendLog): " + err.Message);
            }
        }

        public uint DSR_DeleteCompany(uint pCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteCompany from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteCompany(pCompany);
                
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteCompany): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetCompanies(out object pCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetCompanies from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetCompanies(out pCompany);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetCompanies): " + err.Message);
                pCompany = null;
                return GENERIC_FAIL;
            }
        }

        public uint DSR_DeleteSchedule(Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteSchedule from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteSchedule(pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteSchedule): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_SetDailySchedule(Guid pGuid, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId, DateTime pStartDate, DateTime pEndDate, DateTime pStartTime, sbyte pAllDays, sbyte pWeekDays, sbyte pEveryDay)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_SetDailySchedule from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_SetDailySchedule(pGuid, pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId, pStartDate, pEndDate, pStartTime, pAllDays, pWeekDays, pEveryDay);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_SetDailySchedule): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_BulkExport(uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_BulkExport from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_BulkExport(pCompany, pSubj, pFrom, pTo, pParam1, pParam2);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_BulkExport): " + err.Message);
                return GENERIC_FAIL;
            }
        }


        public uint DSR_SyncRequest(uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_SyncRequest from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_SyncRequest(pCompany, pSubj, pFrom, pTo, pParam1, pParam2);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_SyncRequest): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_CreateCompany(string pCompanyName, string pCompanyCode)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_CreateCompany from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_CreateCompany(pCompanyName, pCompanyCode);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_CreateCompany): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_AddNewUser(string pUserName, string pUserLogin, string pUserPassword)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_AddNewUser from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_AddNewUser(pUserName, pUserLogin, pUserPassword);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_AddNewUser): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_DeleteUser(string pUserLogin)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteUser from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteUser(pUserLogin);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteUser): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetUsers(out object pUsers)
        {
            pUsers = string.Empty;
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetUsers from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetUsers(out pUsers);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetUsers): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetContacts(out object pContacts)
        {
            pContacts = string.Empty;
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetContacts from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetContacts(out pContacts);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetContacts): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_DeleteContact(string pContactMail)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeleteContact from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeleteContact(pContactMail);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeleteContact): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_AddNewContact(string pContactName, string pContactMail, uint pContactCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_AddNewContact from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_AddNewContact(pContactName, pContactMail, pContactCompany);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_AddNewContact): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_UpdateDSRSettings(string pXml)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_UpdateDSRSettings from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_UpdateDSRSettings(pXml);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_UpdateDSRSettings): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_UpdateMailSettings(string pXml)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_UpdateMailSettings from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_UpdateMailSettings(pXml);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_UpdateMailSettings): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetDsrSettings(out string pXml)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pXml = "";
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetDsrSettings from within the remoting server. Guid: " + instanceID.ToString());
               
                return GlobalDSR.WithDSR().DSR_GetDsrSettings(out pXml);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_UpdateMailSettings): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetMailSettings(out string pXml)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pXml = "";
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetMailSettings from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetMailSettings(out pXml);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_UpdateMailSettings): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_ReCreateCompany(uint pCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_ReCreateCompany from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_ReCreateCompany(pCompany);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_ReCreateCompany): " + err.Message);
                return GENERIC_FAIL;
            }

        }

        public uint DSR_Alive()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_Alive from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_Alive();
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_Alive): " + err.Message);
                return GENERIC_FAIL;
            }
        }
    
        public uint DSR_CheckCompanies()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_CheckCompanies from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_CheckCompanies();
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_CheckCompanies): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_CheckMailNow()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_CheckMailNow from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_CheckMailNow();
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_CheckMailNow): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_CheckDripFeed(uint pCompany, out uint pStatus)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pStatus = 0;
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_CheckDripFeed from within the remoting server. Guid: " + instanceID.ToString());
              
                return GlobalDSR.WithDSR().DSR_CheckDripFeed(pCompany, out pStatus);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_CheckDripFeed): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_RemoveDripFeed(uint pCompany, string pFrom, string pTo, string pSubject)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_RemoveDripFeed from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_RemoveDripFeed(pCompany, pFrom, pTo, pSubject);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_RemoveDripFeed): " + err.Message);
                return GENERIC_FAIL;
            }
        }


        public uint DSR_SetAdminPassword(string pAdminPass)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_SetAdminPassword from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_SetAdminPassword(pAdminPass);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_SetAdminPassword): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetDripFeedParams(uint pCompany, out string pPeriodYear1, out string pPeriodYear2)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pPeriodYear1 = "";
            pPeriodYear2 = "";

            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetDripFeedParams from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetDripFeedParams(pCompany, out pPeriodYear1, out pPeriodYear2);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetDripFeedParams): " + err.Message);
                return GENERIC_FAIL;
            }

        }

        public uint DSR_DeactivateCompany(uint pCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DeactivateCompany from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DeactivateCompany(pCompany);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DeactivateCompany): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_ActivateCompany(uint pCompany)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_ActivateCompany from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_ActivateCompany(pCompany);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_ActivateCompany): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public string DSR_Version
        {
            get
            {
                DebugFileCtrl debug = new DebugFileCtrl(false);
                try
                {
                    if (Program.LogEvents)
                        debug.WriteLog("Calling DSR_Version from within the remoting server. Guid: " + instanceID.ToString());

                    return GlobalDSR.WithDSR().DSR_Version;
                }
                catch (System.Exception err)
                {
                    debug.WriteLog("EXCEPTION (DSR_Version): " + err.Message);
                    return "";
                }
            }
        }

        public uint DSR_Sync(uint pCompany, string pSubj, string pFrom, string pTo,
                               string pParam1, string pParam2, uint pPackageId)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_Sync from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_Sync(pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_Sync): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_IsVAO()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_IsVAO from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_IsVAO();
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_IsVAO): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_ExProductType()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_ExProductType from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_ExProductType();
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_ExProductType): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetInboxXml(Guid pGuid, uint pOrder, out string pXML)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pXML = "";
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetInboxXml from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_GetInboxXml(pGuid, pOrder, out pXML);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetInboxXml): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetOutboxXml(Guid pGuid, uint pOrder, out string pXML)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pXML = "";
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetOutboxXml from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_GetOutboxXml(pGuid, pOrder, out pXML);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetOutboxXml): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_ViewCISResponse(Guid pOutboxGuid, Guid pFileGuid, out string pXML)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pXML = "";
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_ViewCISResponse from within the remoting server. Guid: " + instanceID.ToString());
                return GlobalDSR.WithDSR().DSR_ViewCISResponse(pOutboxGuid, pFileGuid, out pXML);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_ViewCISResponse): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_GetExPeriodYear(uint pCompany, out string pPeriodYear1, out string pPeriodYear2)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            pPeriodYear1 = "";
            pPeriodYear2 = "";

            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_GetExPeriodYear from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_GetExPeriodYear(pCompany, out pPeriodYear1, out pPeriodYear2);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_GetExPeriodYear): " + err.Message);
                return GENERIC_FAIL;
            }

        }

        public uint DSR_DenySyncRequest(uint pCompany, Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_DenySyncRequest from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_DenySyncRequest(pCompany, pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_DenySyncRequest): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_CancelDripfeed(uint pCompany, string pFrom, string pTo, string pSubject)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_CancelDripfeed from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_CancelDripfeed(pCompany, pFrom, pTo, pSubject);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_CancelDripfeed): " + err.Message);
                return GENERIC_FAIL;
            }
        }

        public uint DSR_RestoreMessage(Guid pGuid)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                if (Program.LogEvents)
                    debug.WriteLog("Calling DSR_RestoreMessage from within the remoting server. Guid: " + instanceID.ToString());

                return GlobalDSR.WithDSR().DSR_RestoreMessage(pGuid);
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (DSR_RestoreMessage): " + err.Message);
                return GENERIC_FAIL;
            }
        }



        #endregion
    }

    #region Singleton DSR Access
    // Class to implement simple singleton access to the DSR COM object
    // First access creates the object, after that it returns the instance
    public class GlobalDSR
    {
        private static IDSRSERVER _dsr;
        private static Guid instanceID;
        private static bool bInitializing = false;

        internal static void DsrInitialize()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            
            if (bInitializing)
            {              
                return; 
            }

            bInitializing = true;

            try
            {

              if (Program.LogEvents)
                debug.WriteLog("Preparing to create DSR main COM object");

              instanceID = Guid.NewGuid();

              if (Program.LogEvents)
                debug.WriteLog("About to create DSR main COM object (Pre-Initialization), Guid: " + instanceID.ToString());

              _dsr = new DSRSERVERClass();

              if (Program.LogEvents)
                debug.WriteLog("DSR main COM object created successfully (Pre-Initialization). Guid: " + instanceID.ToString());
            }
            finally
            {
                bInitializing = false;
            }
        }

        public static IDSRSERVER WithDSR()
        {
            int lCounter = 0;
            DebugFileCtrl debug = new DebugFileCtrl(false);

            if (bInitializing)
            {
                
                while (bInitializing) 
                {
                    
                    System.Threading.Thread.Sleep(500);                    

                    lCounter = lCounter + 1;                    
                    
                    if (lCounter >= 180)
                    {
                        if (Program.LogEvents)
                            debug.WriteLog("DSR did not respond in a timely fashion"); 
                        throw new Exception("DSR did not respond in a timely fashion");
                    }
                }
            }

            

            if (_dsr == null)
            {
                if (Program.LogEvents)
                    debug.WriteLog("About to create DSR main COM object");
                
                instanceID = Guid.NewGuid();
                try
                {
                    _dsr = new DSRSERVERClass();

                    if (Program.LogEvents)
                        debug.WriteLog("DSR main COM object created successfully. Guid: " + instanceID.ToString());

                    return _dsr;
                }
                catch (System.Exception err)
                {
                    debug.WriteLog("EXCEPTION (WrapperDSR ctor): " + err.Message);
                    return null;
                }
            }
            else
            {
                if (Program.LogEvents)
                    debug.WriteLog("Returning instance of DSR COM object. Guid: " + instanceID.ToString());
                
                return _dsr;
            }
        }
    }

    #endregion
}
