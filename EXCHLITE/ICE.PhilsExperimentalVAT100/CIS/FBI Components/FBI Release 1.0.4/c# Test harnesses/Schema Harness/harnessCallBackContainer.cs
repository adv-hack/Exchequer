using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using IRIS.Systems.InternetFiling;

namespace Schema_Harness
{
    public delegate void CallbackEventHandler(string Guid, String XmlDoc);

    class harnessCallBackContainer : CallbackContainer
    {
        public harnessCallBackContainer() { }

        public event CallbackEventHandler onSubmitSuccess;
        public event CallbackEventHandler onSubmitError;
        public event CallbackEventHandler onSubmitAck;
        public event CallbackEventHandler onDeleteSuccess;
        public event CallbackEventHandler onDeleteError;
        public event CallbackEventHandler onDeleteAck;
        
        private string _guid = "";

        public string Guid
        {
            get { return _guid; }
            set { _guid = value; }
        }

        public override void Response(string message)
        {
             if (message == "")
            {
                return;
            }
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);

            XmlNodeList functionNodeList = myXmlDocument.GetElementsByTagName("Function");
            String functionString = functionNodeList.Item(0).InnerText;
            XmlNodeList qualifierXmlNodeList = myXmlDocument.GetElementsByTagName("Qualifier");
            String qualifierString = qualifierXmlNodeList.Item(0).InnerText;
            switch (functionString)
            {
                case "submit":

                    switch (qualifierString)
                    {
                        case "response":
                            if (onSubmitSuccess != null)
                                onSubmitSuccess(_guid, message);
                            break;
                        case "error":
                            if (onSubmitError != null)
                                onSubmitError(_guid, message);
                            break;
                        case "acknowledgement":
                            if (onSubmitAck != null)
                                onSubmitAck(_guid, message);
                            break;
                        default:
                            throw new Exception("unexpectedGatewayResponseToSubmit");
                    }
                    break;
                case "delete":
                    switch (qualifierString)
                    {
                        case "response":
                            if (onDeleteSuccess != null)
                                onDeleteSuccess(_guid, message);
                            break;
                        case "error":
                            if (onDeleteError != null)
                                onDeleteError(_guid, message);
                            break;
                        case "acknowledgement":
                            if (onDeleteAck != null)
                                onDeleteAck(_guid, message);
                            break;
                        default:
                            throw new Exception("unexpectedGatewayResponseToDelete");
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
