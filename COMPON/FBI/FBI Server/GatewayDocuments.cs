using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Text;

namespace IRIS.Systems.InternetFiling
{
    /// <summary>
    /// This class appears to be used simply to write 
    /// the gateway documents to a holding database.
    /// Is this strictly necessary anymore???
    /// </summary>
    class GatewayDocuments
    {
        private SqlConnection cnn;

        public GatewayDocuments()
        {
            // TODO Add Logic to get connection string
            cnn = new SqlConnection(@"Data Source=.\SQLEXPRESS;" +
                "Initial Catalog=IRIS_FBI;Integrated Security=True;Pooling=False");
        }

        public int InsertDocument(GatewayDocument gatewayDoc)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "procInsertGatewayDocument";

            cmd.Parameters.Add(new SqlParameter("@DocumentID", SqlDbType.NChar, 20));
            cmd.Parameters["@DocumentID"].Value = gatewayDoc.DocumentID;

            cmd.Parameters.Add(new SqlParameter("@ApplicationID", SqlDbType.Int));
            cmd.Parameters["@ApplicationID"].Value = gatewayDoc.ApplicationID;

            cmd.Parameters.Add(new SqlParameter("@SubmittedDocument", SqlDbType.Xml));
            cmd.Parameters["@SubmittedDocument"].Value = gatewayDoc.GatewayDoc;

            cmd.Parameters.Add(new SqlParameter("@DocumentType", SqlDbType.NChar, 20));
            cmd.Parameters["@DocumentType"].Value = gatewayDoc.DocumentType;

            cmd.Parameters.Add(new SqlParameter("@IsTestMessage", SqlDbType.Bit));
            cmd.Parameters["@IsTestMessage"].Value = gatewayDoc.IsTestMessage;

            cmd.Parameters.Add(new SqlParameter("@UsesTestGateway", SqlDbType.Bit));
            cmd.Parameters["@UsesTestGateway"].Value = gatewayDoc.UsesTestGateway;

            cmd.Parameters.Add(new SqlParameter("@RequiresAuditing", SqlDbType.Bit));
            cmd.Parameters["@RequiresAuditing"].Value = gatewayDoc.RequiresAuditing;

            cmd.Parameters.Add(new SqlParameter("@RequiresLogging", SqlDbType.Bit));
            cmd.Parameters["@RequiresLogging"].Value = gatewayDoc.RequiresLogging;

            cmd.Parameters.Add(new SqlParameter("@NextPoll", SqlDbType.DateTime));
            cmd.Parameters["@NextPoll"].Value = gatewayDoc.NextPoll;

            cmd.Parameters.Add(new SqlParameter("@Url", SqlDbType.NChar, 256));
            cmd.Parameters["@Url"].Value = gatewayDoc.Url;

            cmd.Parameters.Add(new SqlParameter("@SubmissionID", SqlDbType.Int));
            cmd.Parameters["@SubmissionID"].Direction = ParameterDirection.Output;


            try
            {
                cnn.Open();
                cmd.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                Trace.WriteLine("There was an exception while adding a record to the database");
                Trace.WriteLine("The exception was:");
                Trace.WriteLine(ex.Message);
                cnn.Close();
                return 0;
            }

            cnn.Close();

            string submissionID = cmd.Parameters["@SubmissionID"].Value.ToString();
            Trace.WriteLine("Added GatewayDocument to Database with ID " + submissionID);

            return int.Parse(submissionID);
        }

        public GatewayDocument GetDocument(int submissionID)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetDocument";

            cmd.Parameters.Add(new SqlParameter("@SubmissionID", SqlDbType.Int));
            cmd.Parameters["@SubmissionID"].Value = submissionID;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataSet ds = new DataSet();
            da.Fill(ds, "GatewayDocuments");

            if (ds.Tables["GatewayDocuments"].Rows.Count == 1)
            {
                GatewayDocument gtwDoc = new GatewayDocument(ds.Tables["GatewayDocuments"].Rows[0]);
                return gtwDoc;
            }
            else
            {
                Trace.WriteLine("Query did not return a result");
                return null;
            }
               
        }

        public List<GatewayDocument> GetDocumentsWithStatus(DocumentStatus gtwDocStatus)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "procGetDocumentsWithStatus";

            cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.Int));
            cmd.Parameters["@Status"].Value = gtwDocStatus;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataSet ds = new DataSet();
            da.Fill(ds, "GatewayDocuments");

            int count = ds.Tables["GatewayDocuments"].Rows.Count;
            List<GatewayDocument> gatewayDocsList = new List<GatewayDocument>();

            if (count > 0)
            {
                for (int i = 0; i < count; i++)
                {
                    gatewayDocsList.Add(
                        new GatewayDocument(ds.Tables["GatewayDocuments"].Rows[i]));
                }
            }

            return gatewayDocsList;
        }

        public int UpdateDocument(GatewayDocument gatewayDoc)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "procUpdateGatewayDocument";

            cmd.Parameters.Add(new SqlParameter("@SubmissionID", SqlDbType.Int));
            cmd.Parameters["@SubmissionID"].Value = gatewayDoc.SubmissionID;

            cmd.Parameters.Add(new SqlParameter("@ResponseDocument", SqlDbType.Xml));
            cmd.Parameters["@ResponseDocument"].Value = gatewayDoc.GatewayResponse;

            cmd.Parameters.Add(new SqlParameter("@RequiresAuditing", SqlDbType.Bit));
            cmd.Parameters["@RequiresAuditing"].Value = gatewayDoc.RequiresAuditing;

            cmd.Parameters.Add(new SqlParameter("@NextPoll", SqlDbType.DateTime));
            cmd.Parameters["@NextPoll"].Value = gatewayDoc.NextPoll;

            cmd.Parameters.Add(new SqlParameter("@LastPoll", SqlDbType.DateTime));
            cmd.Parameters["@LastPoll"].Value = gatewayDoc.LastPoll;

            cmd.Parameters.Add(new SqlParameter("@Url", SqlDbType.NChar, 256));
            cmd.Parameters["@Url"].Value = gatewayDoc.Url;

            cmd.Parameters.Add(new SqlParameter("@CorrelationID", SqlDbType.NChar, 32));
            cmd.Parameters["@CorrelationID"].Value = gatewayDoc.CorrelationID;
            
            try
            {
                cnn.Open();
                cmd.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                Trace.WriteLine("There was an exception while adding a record to the database");
                Trace.WriteLine("The exception was:");
                Trace.WriteLine(ex.Message);
                cnn.Close();
                return 0;
            }

            cnn.Close();

            return 1;
        }

        public bool SetStatus(int submissionID, DocumentStatus gtwStatus)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "procSetStatus";

            cmd.Parameters.Add(new SqlParameter("@SubmissionID", SqlDbType.Int));
            cmd.Parameters["@SubmissionID"].Value = submissionID;

            cmd.Parameters.Add(new SqlParameter("@Status", SqlDbType.Int));
            cmd.Parameters["@Status"].Value = (int) gtwStatus;

            try
            {
                cnn.Open();
                cmd.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                Trace.WriteLine("There was an exception while adding a record to the database");
                Trace.WriteLine("The exception was:");
                Trace.WriteLine(ex.Message);
                cnn.Close();
                return false;
            }

            cnn.Close();
            return true;
        }
        
    }
}
