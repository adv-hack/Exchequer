Government Gateway Sample VB Client
===================================
Last updated: 1 July 2002


Prerequisites
-------------
This sample application is dependent on the Microsoft XML Parser 3.0 
(MSXML3).  MSXML3 is available for download from 
http://msdn.microsoft.com/xml/general/xmlparser.asp.  To work with the Visual 
Basic source code you will need Visual Basic 6 SP4.


Quick Start
-----------
1. Start the application by running VBInjector_DOM.exe.

2. Select a GovTalk XML document to send to the Government Gateway.  Your 
selected document will be displayed on the Source XML tab.  If you want, you 
can edit this document here before you send it. It will not be saved to disk.

3. Specify the URL of the Government Gateway server you wish to test with.  If 
the Gateway requires username/password authentication then enter these too.  
The Government Gateway test service always requires authentication.  Use your 
assigned vendor ID as the username.  The URL for the Government Gateway test 
service is https://secure.dev.gateway.gov.uk/submission/.

4. Click the Submit button.  This starts the GovTalk submission process by 
sending the XML source document to the Gateway.  For each request sent to the 
Gateway an entry is placed in the list on the Protocol Events tab showing the 
result of the request.  Double click an item in the list to see the request/
response pair of XML documents for that event.  The Response XML tab on the 
main form always shows the most recently received message from the Gateway 
server."


Breakpoints
-----------
A single GovTalk submission consists of number of request and response 
messages sent between the client and the Government Gateway.  The breakpoint 
facility allows you to view any GovTalk request in this conversation, and make 
changes to it before it is sent.  Set a breakpoint by checking the boxes on 
the Breakpoint tab.  When a response is received that matches the breakpoint 
the application will pause just before the next message is sent to the 
server.  At this point you can review and/or edit the message that is about to 
be sent, or abort the submission process altogether.


Tips and Known Issues
---------------------
* The working  folder includes a file WorkingSubmissionRequest.xml that you 
  can use as a source XML file to send to the Government Gateway test service.  
  You should edit the file so that the SenderID element contains your assigned 
  vendor ID.  Enter this same vendor ID in the username control in the 
  application before you submit the document.

* The working folder includes the files WorkingDeleteRequest.xml and 
  WorkingSubmissionPoll.xml.  These files are used by the sample application at 
  runtime as templates for the delete request and submission poll messages.  Be 
  aware that if you remove or change these documents you may cause the sample 
  application to malfunction.

* When working with the sample application, MSXML3 can occasionally raise the 
  errors 'Method Send of IXMLHTTPRequest failed', 'Method Open of 
  IXMLHTTPRequest failed' or 'Automation Error'.  This is often due to invalid 
  characters in the URL.  Check that the URL is correct and try again.

* If the application raises the error 'ActiveX Can't Create Object' when you 
  attempt to submit a GovTalk message this may mean that you have not installed, 
  or do not have the correct version of the Microsoft XML Parser.  You should 
  have version 3.0.  This can be downloaded from 
  http://www.microsoft.com/downloads/.

* When working with the sample application, MSXML3 can occasionally raise the 
  error 'Method '~' of object '~' failed'.  This can be due to specifying a URL 
  that cannot be found or invalid characters in the URL.  Check that the URL is 
  correct and try again.

* Whenever you start a new submission process the record of protocol events 
  and messages from the previous submission is cleared.  If you need to save 
  an XML request or response message use CTRL-C to copy the text of the message 
  from a text box to the clipboard, and paste it into Notepad where it can be 
  saved or printed.



