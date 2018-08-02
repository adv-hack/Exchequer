using System;
using System.Collections.Generic;
using System.Text;
using IRIS.ICE.Common;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels.Tcp;
using System.Runtime.InteropServices;


namespace RemotingClientLib
{
    [ComVisible(true)]
    [Guid("5AB13540-BD08-42ad-B8A2-9392CF3D0AFE")]
    public interface IDSRClient
    {
        uint DSR_Export(string MachineName,
                        int PortNumber,
                        uint pCompany,
                        string pSubj,
                        string pFrom,
                        string pTo,
                        string pParam1,
                        string pParam2,
                        uint pPackageId);

        uint DSR_Import(string MachineName,
                        int PortNumber,
                        uint pCompany,
                        Guid pGuid,
                        uint pPackageId);

        uint DSR_DeleteInboxMessage(string MachineName,
                                    int PortNumber,
                                    uint pCompany,
                                    Guid pGuid);

        uint DSR_DeleteOutboxMessage(string MachineName,
                                     int PortNumber,
                                     uint pCompany,
                                     Guid pGuid);

        uint DSR_GetInboxMessages(string MachineName,
                                  int PortNumber,
                                  uint pCompany,
                                  uint pPackageID,
                                  sbyte pStatus,
                                  DateTime pDate,
                                  uint pMaxRecords,
                                  out object pMessages);

        uint DSR_GetOutboxMessages(string MachineName,
                                   int PortNumber,
                                   uint pCompany,
                                   uint pPackageID,
                                  sbyte pStatus,
                                  DateTime pDate,
                                  uint pMaxRecords,
                                  out object pMessages);

        uint DSR_NewInboxMessage(string MachineName,
                                 int PortNumber,
                                 uint pMaxRecords, out object pMessages);

        uint DSR_TotalOutboxMessages(string MachineName,
                                     int PortNumber,
                                     uint pCompany, out uint pMsgCount);

        string DSR_TranslateErrorCode(string MachineName,
                                      int PortNumber,
                                      uint pErrorCode);

        uint DSR_ResendOutboxMessage(string MachineName,
                                     int PortNumber,
                                     Guid pGuid);

        uint DSR_GetExportPackages(string MachineName,
                                   int PortNumber,
                                   out object pPackage);

        uint DSR_GetImportPackages(string MachineName,
                                   int PortNumber,
                                   out object pPackage);

        void DSR_SendLog(string MachineName,
                         int PortNumber,
                         string pMail);

        uint DSR_DeleteCompany(string MachineName,
                               int PortNumber,
                               uint pCompany);

        uint DSR_GetCompanies(string MachineName,
                              int PortNumber,
                              out object pCompany);

        uint DSR_DeleteSchedule(string MachineName,
                                int PortNumber,
                                Guid pGuid);

        uint DSR_SetDailySchedule(string MachineName, int PortNumber, Guid pGuid, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId, DateTime pStartDate, DateTime pEndDate, DateTime pStartTime, sbyte pAllDays, sbyte pWeekDays, sbyte pEveryDay);

        uint DSR_BulkExport(string MachineName, int PortNumber, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2);

        uint DSR_SyncRequest(string MachineName, int PortNumber, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2);

        uint DSR_CreateCompany(string MachineName, int PortNumber, string pCompanyName, string pCompanyCode);

        uint DSR_AddNewUser(string MachineName, int PortNumber, string pUserName, string pUserLogin, string pUserPassword);

        uint DSR_DeleteUser(string MachineName, int PortNumber, string pUserLogin);

        uint DSR_GetUsers(string MachineName, int PortNumber, out object pUsers);

        uint DSR_GetContacts(string MachineName, int PortNumber, out object pContacts);

        uint DSR_DeleteContact(string MachineName, int PortNumber, string pContactMail);

        uint DSR_AddNewContact(string MachineName, int PortNumber, string pContactName, string pContactMail, uint pContactCompany);

        uint DSR_UpdateDSRSettings(string MachineName, int PortNumber, string pXml);

        uint DSR_UpdateMailSettings(string MachineName, int PortNumber, string pXml);

        uint DSR_GetDsrSettings(string MachineName, int PortNumber, out string pXml);

        uint DSR_GetMailSettings(string MachineName, int PortNumber, out string pXml);

        uint DSR_ReCreateCompany(string MachineName, int PortNumber, uint pCompany);

        // new 11-05-2006
        uint DSR_Alive(string MachineName, int PortNumber);
        uint DSR_CheckCompanies(string MachineName, int PortNumber);
        uint DSR_CheckMailNow(string MachineName, int PortNumber);
        uint DSR_CheckDripFeed(string MachineName, int PortNumber, uint pCompany, out uint pStatus);
        uint DSR_RemoveDripFeed(string MachineName, int PortNumber, uint pCompany, string pFrom, string pTo, string pSubject);

        // new 22-05-2006
        uint DSR_SetAdminPassword(string MachineName, int PortNumber, string pAdminPass);

        // 14/06/2006
        uint DSR_GetDripFeedParams(string MachineName, int PortNumber, uint pCompany, out string pPeriodYear1, out string pPeriodYear2);                                           

        // 29/06/2006
        uint DSR_DeactivateCompany(string MachineName, int PortNumber, uint pCompany);
        uint DSR_ActivateCompany(string MachineName, int PortNumber, uint pCompany);

        string DSR_Version(string MachineName, int PortNumber);

        uint DSR_Sync(string MachineName, int PortNumber, uint pCompany, string pSubj,
                        string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId);

        // 09/08/2006
        uint DSR_IsVAO(string MachineName, int PortNumber);
        uint DSR_ExProductType(string MachineName, int PortNumber);

        // 11/08/2006
        uint DSR_GetInboxXml(string MachineName, int PortNumber, Guid pGuid, uint pOrder, out string pXML);
        uint DSR_GetOutboxXml(string MachineName, int PortNumber, Guid pGuid, uint pOrder, out string pXML);
        uint DSR_ViewCISResponse(string MachineName, int PortNumber, Guid pOutboxGuid, Guid pFileGuid, out string pXML);

        // 19/10/2006
        uint DSR_GetExPeriodYear(string MachineName, int PortNumber, uint pCompany, out string pPeriodYear1, out string pPeriodYear2);

        // 01/11/2006

        uint DSR_DenySyncRequest(string MachineName, int PortNumber, uint pCompany, Guid pGuid);

        // 16/11/2006
        uint DSR_CancelDripfeed(string MachineName, int PortNumber, uint pCompany, string pFrom, string pTo, string pSubject);

        // 28/11/2006
        uint DSR_RestoreMessage(string MachineName, int PortNumber, Guid pGuid);
    }

    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.None)]
    [Guid("AF030C57-798F-4a36-B997-E12FD0207680")]
    public class DSRClient: IDSRClient
    {
        private const uint GENERIC_FAIL = 10000;

        #region IDSRClient Members

        public uint DSR_Export(string MachineName, int PortNumber, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_Export(pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_Import(string MachineName, int PortNumber, uint pCompany, Guid pGuid, uint pPackageId)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_Import(pCompany, pGuid, pPackageId);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_DeleteInboxMessage(string MachineName, int PortNumber, uint pCompany, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteInboxMessage(pCompany, pGuid);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_DeleteOutboxMessage(string MachineName, int PortNumber, uint pCompany, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteOutboxMessage(pCompany, pGuid);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_GetInboxMessages(string MachineName, int PortNumber, uint pCompany, uint pPackageID, sbyte pStatus, DateTime pDate, uint pMaxRecords, out object pMessages)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetInboxMessages(pCompany, pPackageID, pStatus, pDate, pMaxRecords, out pMessages);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_GetOutboxMessages(string MachineName, int PortNumber, uint pCompany, uint pPackageID, sbyte pStatus, DateTime pDate, uint pMaxRecords, out object pMessages)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetOutboxMessages(pCompany, pPackageID, pStatus, pDate, pMaxRecords, out pMessages);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_NewInboxMessage(string MachineName, int PortNumber, uint pMaxRecords, out object pMessages)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_NewInboxMessage(pMaxRecords, out pMessages);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_TotalOutboxMessages(string MachineName, int PortNumber, uint pCompany, out uint pMsgCount)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_TotalOutboxMessages(pCompany, out pMsgCount);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public string DSR_TranslateErrorCode(string MachineName, int PortNumber, uint pErrorCode)
        {
            string result = string.Empty;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_TranslateErrorCode(pErrorCode);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_ResendOutboxMessage(string MachineName, int PortNumber, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_ResendOutboxMessage(pGuid);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_GetExportPackages(string MachineName, int PortNumber, out object pPackage)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetExportPackages(out pPackage);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public uint DSR_GetImportPackages(string MachineName, int PortNumber, out object pPackage)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetImportPackages(out pPackage);
            }
            catch (Exception err)
            {
                throw err;
            }
            
            return result;
        }

        public void DSR_SendLog(string MachineName, int PortNumber, string pMail)
        {
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                _dsr.DSR_SendLog(pMail);
            }
            catch (Exception err)
            {
                throw err;
            }
        }

        public uint DSR_DeleteCompany(string MachineName, int PortNumber, uint pCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteCompany(pCompany);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetCompanies(string MachineName, int PortNumber, out object pCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetCompanies(out pCompany);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_DeleteSchedule(string MachineName, int PortNumber, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteSchedule(pGuid);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_SetDailySchedule(string MachineName, int PortNumber, Guid pGuid, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId, DateTime pStartDate, DateTime pEndDate, DateTime pStartTime, sbyte pAllDays, sbyte pWeekDays, sbyte pEveryDay)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_SetDailySchedule(pGuid, pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId, pStartDate, pEndDate, pStartTime, pAllDays, pWeekDays, pEveryDay);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_BulkExport(string MachineName, int PortNumber, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_BulkExport(pCompany, pSubj, pFrom, pTo, pParam1, pParam2);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_SyncRequest(string MachineName, int PortNumber, uint pCompany, string pSubj, string pFrom, string pTo, string pParam1, string pParam2)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_SyncRequest(pCompany, pSubj, pFrom, pTo, pParam1, pParam2);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }


        public uint DSR_CreateCompany(string MachineName, int PortNumber, string pCompanyName, string pCompanyCode)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_CreateCompany(pCompanyName, pCompanyCode);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_AddNewUser(string MachineName, int PortNumber, string pUserName, string pUserLogin, string pUserPassword)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_AddNewUser(pUserName, pUserLogin, pUserPassword);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_DeleteUser(string MachineName, int PortNumber, string pUserLogin)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteUser(pUserLogin);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetUsers(string MachineName, int PortNumber, out object pUsers)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetUsers(out pUsers);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetContacts(string MachineName, int PortNumber, out object pContacts)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetContacts(out pContacts);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_DeleteContact(string MachineName, int PortNumber, string pContactMail)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeleteContact(pContactMail);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_AddNewContact(string MachineName, int PortNumber, string pContactName, string pContactMail, uint pContactCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_AddNewContact(pContactName, pContactMail, pContactCompany);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_UpdateDSRSettings(string MachineName, int PortNumber, string pXml)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_UpdateDSRSettings(pXml);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_UpdateMailSettings(string MachineName, int PortNumber, string pXml)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_UpdateMailSettings(pXml);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }


        public uint DSR_GetDsrSettings(string MachineName, int PortNumber, out string pXml)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetDsrSettings(out pXml);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetMailSettings(string MachineName, int PortNumber, out string pXml)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetMailSettings(out pXml);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_ReCreateCompany(string MachineName, int PortNumber, uint pCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_ReCreateCompany(pCompany);                
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_Alive(string MachineName, int PortNumber)
        {
            uint result = GENERIC_FAIL;

                try
                {
                    IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");

                    try
                    {
                       result = _dsr.DSR_Alive();
                    }
                    catch (Exception err)
                    {
                        //throw new Exception("Exception thrown at Client Sync Service level from Remoting Client testing alive. Inner Exception: \"" + err.Message + "\"");
                        throw new Exception("An exception has occurred checking Client Sync Service. \"" + err.Message + "\"");
                    }
                }
                catch (Exception ex)
                {
                    //throw new Exception("Exception thrown at DSR level from Remoting Client getting object. Inner Exception: \"" + ex.Message + "\"");

                    throw ex;
                }

            return result;
        }

        public uint DSR_CheckCompanies(string MachineName, int PortNumber)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_CheckCompanies();
            }
            catch (Exception err)
            { 
                throw err;
            }

            return result;
        }

        public uint DSR_CheckMailNow(string MachineName, int PortNumber)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_CheckMailNow();
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_CheckDripFeed(string MachineName, int PortNumber, uint pCompany, out uint pStatus)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_CheckDripFeed(pCompany, out pStatus);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_RemoveDripFeed(string MachineName, int PortNumber, uint pCompany, string pFrom, string pTo, string pSubject)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_RemoveDripFeed(pCompany, pFrom, pTo, pSubject);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_SetAdminPassword(string MachineName, int PortNumber, string pAdminPass)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_SetAdminPassword(pAdminPass);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetDripFeedParams(string MachineName, int PortNumber, uint pCompany, out string pPeriodYear1, out string pPeriodYear2)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetDripFeedParams(pCompany, out pPeriodYear1, out pPeriodYear2);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_DeactivateCompany(string MachineName, int PortNumber, uint pCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DeactivateCompany(pCompany);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_ActivateCompany(string MachineName, int PortNumber, uint pCompany)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_ActivateCompany(pCompany);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public string DSR_Version(string MachineName, int PortNumber)
        {
            string result = "";
            try 
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_Version;
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_Sync(string MachineName, int PortNumber, uint pCompany, string pSubj,
                        string pFrom, string pTo, string pParam1, string pParam2, uint pPackageId)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_Sync(pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;

        }

        public uint DSR_IsVAO(string MachineName, int PortNumber)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_IsVAO();
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_ExProductType(string MachineName, int PortNumber)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_ExProductType();
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetInboxXml(string MachineName, int PortNumber, Guid pGuid, uint pOrder, out string pXML)
        {
            uint result = GENERIC_FAIL;
            pXML = "";
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetInboxXml(pGuid, pOrder, out pXML);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetOutboxXml(string MachineName, int PortNumber, Guid pGuid, uint pOrder, out string pXML)
        {
            uint result = GENERIC_FAIL;
            pXML = "";
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetOutboxXml(pGuid, pOrder, out pXML);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_ViewCISResponse(string MachineName, int PortNumber, Guid pOutboxGuid, Guid pFileGuid, out string pXML)
        {
            uint result = GENERIC_FAIL;
            pXML = "";
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_ViewCISResponse(pOutboxGuid, pFileGuid, out pXML);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_GetExPeriodYear(string MachineName, int PortNumber, uint pCompany, out string pPeriodYear1, out string pPeriodYear2)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_GetExPeriodYear(pCompany, out pPeriodYear1, out pPeriodYear2);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_DenySyncRequest(string MachineName, int PortNumber, uint pCompany, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_DenySyncRequest(pCompany, pGuid);
            }
            catch (Exception err)
            {  
                throw err;
            }

            return result;
        }

        public uint DSR_CancelDripfeed(string MachineName, int PortNumber, uint pCompany, string pFrom, string pTo, string pSubject)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_CancelDripfeed(pCompany, pFrom, pTo, pSubject);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        public uint DSR_RestoreMessage(string MachineName, int PortNumber, Guid pGuid)
        {
            uint result = GENERIC_FAIL;
            try
            {
                IWrapperDSR _dsr = (IWrapperDSR)Activator.GetObject(typeof(IWrapperDSR), "tcp://" + MachineName + ":" + PortNumber.ToString() + "/WrapperDSR");
                result = _dsr.DSR_RestoreMessage(pGuid);
            }
            catch (Exception err)
            {
                throw err;
            }

            return result;
        }

        #endregion
    }
}
