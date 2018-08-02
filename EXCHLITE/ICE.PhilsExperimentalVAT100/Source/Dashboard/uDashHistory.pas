(*-----------------------------------------------------------------------------
 Unit Name: uDashHistory
 Author:    vmoura
 Purpose:
 History:

      v6.00.003    13/11/2007

      1) Defaulted required MS SQL Server instance name to IRISSOFTWARE.

      v6.00.002    14/08/2007

      1) new help file in html

      v5.71.001

      1) name changes... (IRIS GovLink)
      2) help file has changed to Dashboard.hlp


      0.0.0.0r  13/02/2007
      1) CIS Dashboard
      2) CIS Subcontractor interface (export and import)
      3) New POP/SMTP/IMAP/MAPI configuration wizard
      4) POP3/SMTP/IMAP Authentication support (currently being tested by development)

      0.0.0.0q
      1) Client Sync has changed to ClientLink
        (ps: see note 11 about component names)

      0.0.0.0p	29/11/2006

      1) ICE336-WJ If a Sync Request is denied the denied email no longer shows in the Inbox New. Linked with ICE304-QA
              Denied messages will appear under the company that made the request (as requested in ICE304-QA) and the subject of the message will contain the company that denied the request
      2) ICE339-WJ If you delete an item by accident, there is no way of restoring from deleted items back to the company
              The following conditions must be valid for restoring an item from deleted/failed folder: The Company must exist and be active; the message must be a Bulk or Dripfeed data (unless another situation is required) and the whole batch must be valid
      3) ICE340-WJ Accountant deleted bulk export without importing. No message sent to client. No event in accountant event log.
              No message will be sent due the new functionality of restoring and resending messages…

      New features:
      1) Progress bar during the sync steps
      2) Subject preview on messages (similar to Outlook)
      3) Restore messages
      4) Resend messages
      5) New dialogs (following the Dashboard components)

      0.0.0.0o	20/11/2006

      1) ICE156-SG Completed sync request and sent bulk export which was intercepted to simulate failure.  Sync and End Sync options were availble from customer view.  Need more handshaking.
      2) ICE302-QA Terminology Client click Request Dripfeed to send a message titled 'sync request', at accountant the message status is 'Ready to import' but right-click option to do this is Accept.
      3) ICE304-QA If practice denies synch request, the customer receives email in global inbox but the with no indication of which company has had synch denied.  This will be a problem if they sent off a synch request for more than one of their companies.
      4) ICE305-QA When customer receives a Synch Denied e-mail it sends a synch denied e-mail back to the pracice
      5) ICE307-QA Customer sends Bulk Export followed by dripfeed before Practice has imported the bulk export. Pracice could import dripfeed prior to bulk expot causing failure
      6) ICE311-QA The option to show 'Location' in the event log is meaningless unless we document how to use the information. Or is it intended only to help IRIS support staff when someone calls in?
 Only available in DEBUG mode
      7) ICE313-QA There is no Acknowledgement email to confirm dripfeed has been imported
      8) ICE317-QA Client received End of Dripfeed from Accountant - Dripfeed option was greyed out but Scheduled Dripfeed wasn't. Company Info said 'Can make a request' but couldn't.
      9) ICE318-QA In the Company Info pane: The company name has 'Description' against it - it should be 'Company' or 'Name'. Similarly the Account number has 'Code' against it
      10) ICE326-WJ The Dashboard appears to disappear from view and reappear briefly when selecting Check Mail. If you have another application full screen behind the Dashboard and double click on Check Mail, the app behind get the view.
      11) ICE327-WJ If you select to recreate a company that still exists on the MCM, you get a Unrecognised error recreating the company on the Event Log
      12) ICE328-WJ It is possible to resize the Dripfeed column to nothng
      13) ICE331-WJ Deleted email in Bulk Export prior to accountant receiving to test handshaking when some emails fail. No handshaking appear to occur and received only 1785/2367. Company still showed Receiving Client Data
      14) ICE332-WJ Invalid XML[C:\IAOFFICE\Inbox\{A4C8C453-0E2A-4535-892E-F5E8DDA95B6F}\477.xml]. Full details emailed to Vini

      The following items have received updates (or completely fixed):
      1) ICE249-WJ When receiving a Bulk Export, the Dashboard goes into a "Not Responding" state.
      2) ICE282-SH When accountant accepts new request, inbox message shows 'processed' but no message appears in outbox. As an email has been sent - why not show it?
      3) ICE306-QA When practice accepts a Synch request the status shows processed.
 The message changes its status after 8 seconds as request at ICE074
      4) ICE308-QA Accountant deleted bulk export without importing. No message sent to client. No event in accountant event log. Client sent end of dripfeed - accountant got this and could right-click to end dripfeed - but nothing happens because the company never was in dripfeed. End of dripfeed button was enabled even though company was not in dripfeed. Company remained in dripfeed pane, message remained bold in inbox. Company info said 'waiting dripfeed'. At accountant, company could not be deleted from MCM. Multiple instances of ENTTOOLKIT were running (one for every attempt at ending dripfeed?) - ending all of these allowed company to be deleted from MCM.
      5) ICE319-QA Button order not Logical
      6) ICE320-QA Event log entries include company name but not account code on Customer Version
      7) ICE321-WJ It is not possible to delete multiple items across muliple days
 Tested and error not identified.
      8) ICE324-WJ If you select to delete a Sync Request there is no Are You Sure option
 Tested error not identified.
      9) ICE325-WJ It is possible to delete all items from the outbox while one of the items is being processed, ie. Bulk Export being created.
 The item being processed will not be deleted if all messages have been selected
      10) ICE329-WJ If you stop the service on the Dashboard, the Dashboard starts returning TDSR.DSR_CheckMailNow :- An exception has occurred: An existing connection was forcibly closed by the remote host
      11) ICE330-WJ If you stop the service via the Dashboard you can also get the following error: Exception thrown at DSR level from Remoting Client getting object. Inner Exception: "Exception thrown at DSR level from Remoting Client testing alive. Inner Exception: "An existing connection was forcibly closed by the remote host""

      New features:
      1) Cancel Dripfeed process option available
      2) Update and/or create the ICE database when starting DSR Service

      0.0.0.0n	02/11/2006

      ICE271-WJ Dashboard is unable to tell if DSR is running under a Server/Workstation environment which means most functionality is disabled.
              OBS: Next CD build
      ICE282-SH When accountant accepts new request, inbox message shows 'processed' but no message appears in outbox. As an email has been sent - why not show it?
      ICE285-SH User Login record: uses 'Logins' plural when it's only one. The help text is bad English (using 'them' to refer to a single person)
      ICE289-SH When you end dripfeed, the message says "The company ....... is going to be removed of Dripfeed mode. Do you want to continue?" This is bad english.
      ICE297-WJ Can an option be added for clearing the Event Log
      ICE298-WJ If you delete a Sync Request rather than Accept or Deny, can this just delete the message and not send a deny back to the Customer.
      ICE299-WJ If you Deny a message the Are You Sure message displays, 'Are you sure you want to Delete' rather than are you shure you want to deny
      ICE300-WJ Can the DSR Service be made more pro-active. On my PC the DSR started kept returning errors in the Log until I stopped and restarted it. Could the DSR detect th error and try a restart automatically?
      Inbox/Outbox/Delete "Select All" option available
      Screen refresh (inbox/outbox…) updated (it was flicking when changing from one mailbox to another)

      0.0.0.0m	27/10/2006

      ICE203-RH Change system setting in client before acknowledge of bulk export. Vini, introduce a message into the company info, and alert window that the "During Bulk Export Dashboard message to inform user not to access Acc Office"
      ICE232-WJ Bulk Export received on Practice version, but no visual alert appeared when the email arrived.
      ICE245-WJ Can the Automatic Dripfeed time to changed to allow the user to set how often they want to dripfeed as every 5 mins may to be frequent. Vini: Set the frequency to be now based on a 60 minute frequency.
      ICE249-WJ When receiving a Bulk Export, the Dashboard goes into a "Not Responding" state.
      ICE273-WJ When restoring, CSBackup prompts for BAK files rather than BCK files
      ICE-276-WJ Warning message to appear if you select 'Delete non related Client Sync emails' allowing confirmation
      ICE277-WJ Denied request on Accountant. Sent additional request, on receipt Sync Request with status Receiving Client Data and Sync Request with Ready to Import received.
      ICE278-WJ Can the Restore option gives the same default folder as Backup. Currently shows as My Documents for default
      Improved speed on deleting items
      Help contexts available (ClientSync.hlp must be copied under the IAO directory)
      ICE280-SH View | Reminder Window does nothing unless there are reminders - better to show a message to say no reminders.
      ICE281-SH System | Contacts opens a screen called Address Book - suggest using same wording for both the menu and the screen
      ICE283-SH Email Contact details window says 'E-mail Contacts' - why plural when only one? And the help text on this screen isn't very good English.
      ICE284-SH Not sure how useful the search feature in the address book is - is this ever going to be a long list? And - if so - isn't the company name (i.e. the 'Default Receiver...' ) more relevant for searching on? Also - in the contact record the field labelled 'company' equates to the 'Default receiver' column in the address book - not consistent.
           The search follows the similarity with Outlook Search Contacts. Also, the Default Receiver item is not mandatory and that is the reason for searching by name.
      ICE286-SH The dashboard title bar doesn't identify the application
           Dashboard is the temporarily/final name
      ICE287-SH You request drip-feed for a de-activated company that is in History
      ICE290-SH The Status bar does not update the number of emails if you select a company who has none.
      ICE291-SH When you choose 'Dripfeed Scheduled Task', the subsequent screen says simply 'Schedule'
      ICE292-WJ It is not possible to edit a Dripfeed Schedule once created.
      ICE293-WJ Once a Bulk Export has been sent from the Customer and is in the process of being received at the Practice, it is possible to start another Bulk Export
           Latest version blocks multiple bulk export and after a bulk export process, the company is automatically set to Dripfeed mode.
      ICE294-WJ Error Code: 10606 - Invalid company code[This company must to be recreated.]. Can this be changed to [This company must be recreated]

         0.0.0.0l	23/10/2006

      ICE091-WJ If a Sync Fails due to a Company Licence Exceeded, the customer sees this reason on their version. On the customer version should report Sync Denied/Failed and not this reason. QA: At the previous meeting this was classed as Priority2 : Vini, we have agreed to change the message to "Please contact your Accountant to confirm licence status."
      ICE115-WJ Requested sync for period different to suggested. When going to run bulk export suggested periods displayed and not revised entered periods.
      ICE224-RH The data separator is affecting the range of period for request drip-feed. QA: Still occurs in v0.0.0.0k
      ICE241-WJ Sync Accepted email received on Dashboard but option status not automatically updated to Bulk Export, had to select different company before updated.
      ICE242-WJ Can the dripfeed period range be shown in the Company Info display.
      ICE243-WJ Can an additional button be added for Import as the only way to get to this is through right click on the email which is not obvious.  Vini, Provide access to the Import button via the File Menu options
      ICE244-WJ Can Accept and Deny buttons also be added for use when the Sync Request if received to make it easier for the end user and delet is not the obvious way for denying a request. ** Additional item for file menu
      ICE245-WJ Can the Automatic Dripfeed time to changed to allow the user to set how often they want to dripfeed as every 5 mins may to be frequent. Vini: Set the frequency to be now based on a 60 minute frequency.
      ICE246-WJ Can the file extension of the Backup file be changed from BAK as some users may see this type of file as a temporary backup file and delete it. Vini: File extension should be changed from BAK to BCK
      ICE256-WJ If you right click on an End of Dripfeed message the menu says End of Sync and status. QA: Still occurs in v0.0.0.0k
      ICE260-WJ Refresh time after all Syncs for buttons
      ICE261-WJ Right click for menu on Email Accounts, click back on email list, refresh issue on horizontal scroll bar
      ICE262-WJ Able to delete Bulk Export Processing message while system is still processing. QA: Timing issue on large data sets
      ICE266-WJ It is possible to sync between two customer versions
      ICE267-WJ It is possible to sync between two Practice versions

    0.0.0.0k    06/10/2006
      ICE074-WJ The Sync accepted email notification does not change from bold to normal text when highlighted for a short period
                Only a message whose status is Sync Denied, Sync Failed or Sync accepted.
      ICE247-WJ Once the import of a Sync has been completed, the message remains in Bold as if it is still outstanding.
                The read pane and the message status indicate the current status of the message.
      ICE237-Once the import of a Bulk Export has been completed, the message remains in Bold as if it is still outstanding.
      ICE225-WJ Right Click menu on User Logins shows Update option where button is Change
      ICE226-WJ Right Click menu on Dashboard E-Mail Address Book does not show Change option.
      ICE227-WJ Right Click menu on Dashboard E-Mail Address Book appears in reverse order, should start with Add New rather than Delete
      ICE229-WJ On Practice version, if you select one of the Practices own companies, the dripfeed status shows as 'Company can make a request…'. This is not possible from Practice version.
      ICE232-WJ Bulk Export received on Practice version, but no visual alert appeared when the email arrived.
      ICE233-WJ If a sync is denied, the status on the client version still shows as Waiting Dripfeed Confirmation
      ICE235-WJ If a sync request is denied and you delete the original sync request from the Outbox of the company on the Customer version, the company list doesn't automatically refresh to hide the Inbox and Outbox for the company., you have to manually refresh the list.
              The inbox will refresh after 5 minutes, leaving the dashboard or doing it manually. Also, the message delete still belongs to the mail box and the company can make another request to override the old message using the same inbox/outbox.
      ICE238-WJ End of Sync applied on Practice version but not automatically applied to Customer version.
              There is no automatically end of sync.
      ICE239-WJ Email generated by Ebus Test via SMTP is not deleted so keeps being picked up the receiving emails.
      ICE104-WJ Unable to get Recreate Companies to work from History tab.
      ICE250-WJ Dashboard incorrectly spelt on Login dialog
      ICE256-WJ If you right click on an End of Dripfeed message the menu says End of Sync
      ICE254-WJ It is possible to start multiple Bulk Exports on the same company at the same time
      ICE156-SG Completed sync request and sent bulk export which was intercepted to simulate failure.  Sync and End Sync options were available from customer view.  Need more handshaking
              Straight after sending a bulk export, we set the company to dripfeed mode. This item was discussed and agreed with Kevin.
      SMTP/POP3 advanced options for setting different ports
      ICE224-RH The data separator is affecting the range of period for request drip-feed
      ICE100-WJ Last Audit Date being set to todays date instead of the last day of the synced period.
              The new UDPeriod.dll must be used in case IAO running with use defined period option available.
      ICE230-WJ On Customer version, after a Sync Request has been accepted, the status changes to 'Waiting Dripfeed confirmation…' should the staus be 'awaiting bulk export' or something like that.
      ICE231-WJ On Practice version, when a Sync Request has been received, the status shows as 'Company can make a request…' is this correct or should to show 'Awaiting acceptance of Sync Request' or something like that.
      ICE234-WJ When a Bulk Export has been received but is in a Ready to Import state, the status message says 'Company can make a request…' should this be 'Awaiting import of .. From ..' or something like that.

 0.0.0.0k    03/10/2006
         1) bug fix when refreshing inbox/outbox archived messages after deleting one or more messages
         2) new configuration settings
         3) new user inferface
         4) fix bug when adding a message to a group and the date was one day difference
         5) fix error when changing values on period fields and the subject was not updated
         6) New Reminder window (optional configuration)
         7) ICE096-WJ - If you lengthen the companies list the icons for other views display with white around them.
         8) ICE165-DR If on sent mail or deleted mail list, with no items selected, can still right click anywhere on screen and get delete option.
         9) ICE166-DR When deleting emails the email must be selected and highlighted.  This is obvious, but if email is not highlighted, you should not get the delete option
.        10) ICE167-DR After deleting all emails still have bulk export option available to for last company export that had failed and option to request dripfeed is greyed out.  Had to deactivate and then reactive to reset for dipfeed request
.        11) ICE174-RH same as ICE167 (Log in screen does not follow Accounts office conventions when validating user name.)
         12) ICE178-RH Different between Add and Ok and Cancel & Close
         13) ICE144-SG Logs created using date as filename.  Require identity prefix code
                      name of the application will appear in front of it
         14) ICE177-RH Need a system password override in case login password forgotten
         15) ICE122-WJ Only able to set Scheduled dripfeed from Outbox on Customer Version. It would be better if this could be set by also right cicking on Company or through a global schedule for all companies in sync mode.
         16) ICE154-SG Backup and restore did not restore data stored in SQL database.
                     Client Sync Backup Utility (CSBackup.exe)
         17) ICE124-WJ If Dripfeed is set to Automatic, how often does the dripfeed/sync occur
                     It happens every five minutes
         18) ICE123-WJ Can scheduling be added to the Accountant Version.

   0.0.0.0j  01/09/2006
         1) Access violation when leaving the dashboard
         2) ICE139-DR The messge confirming company deavtivation reads ' The Company 'xxx'' is going to be deactivated of the Dashboard….  Should read deactivated from the Dashboard.
         3) ICE117-WJ Last Audit Date should no longer be set when creating the company as this causes history transactions not to post after initial dripfeed
            Fix by the import plugins
         4) ICE160-DR DSR Settings - Connection type reads as Exchequer MAPI and Exchequer SMTP
         5) ICE074 The Sync accepted email notification does not change from bold to normal text when highlighted for a short period
                After 2 seconds not configurable
         6) ICE112 When you startup the Dashboard, if you on previous days had received new mail accepting syncs etc. you still get the new mail received message because the mail is still in bold as new mail even though you have read it.
            Same as ICE074

   0.0.0.0i  24/08/2006
         1) VAO compatible
         2) filter aplied for VAO when loading companies for a specific installation
         3) Screen adjustment for 800 x 600 and bigger
         4) Company creation is only available for Customer versions
         5) new panel for visualize the message info
         6) fix date groups was showing wrong information
         7) perfomace improvements
         8) ICE115 Requested sync for period different to suggested. When going to run bulk export suggested periods displayed and not revised entered periods.
            Dashboard loads the information set in the Dripfeed file

   0.0.0.0h   27/07/2006
         1) Bug fix when refreshing recycle/failed messages
         2) company view improvment

   0.0.0.0g    10/07/2006
         1) ICE093 If you End Sync the email address is not populated.
         2) ICE095 Mixture of MS San Serif and Arial used around the Dashboard
         3) ICE094 If you delete a company from History, the screen refreshes back to the Sync section rather than staying on History
         4) ICE090 If you deactivate a company, there is no way a reactivating it.

   0.0.0.0f  05/07/2006
         1) ICE080 Sync requests now bring the right lastaudit period/year
         2) ICE081 Should the suggested Period and Year to based from next day after the Last Audited date to the end of that year. Ie. If the Last Audited Date was 31/12/2004 then the suggested periods would be 01/2005 - 12/2005 (or 13/2005 if 13 periods within the year)
         3) ICE082 If you try to add a contact which already exists the add window closes with no error displayed. The only error appears in the log.
         4) ICE088 The login dialog follows the same behavior as exchequer login
                   If you enter an incorrect User Name or Password, on selecting OK no warning message is displayed. Should display warning and only allow three attempts

   0.0.0.0f 27/06/2006
         1) ICE041 I sent a sync request to a system which had a company with the same company code already in it. The system tried to automatically sync to that company.
              [added a security guid to company table. This security must match in both ends to be in sync]
         2) ICE067 There is currently no limit to the value you can type in the Polling Time. Can this be limited to 1440 to match the highest value the arrows will let you go.
         3) ICE069 If you take a company out of sync mode and delete emails from the archive, it is not possible to put the company back into sync mode.
         4) ICE070 You don't get a Visual alert when a Sync Request acceptence or denied is returned.
         5) ICE071 You don't get a Visual alert when a Bulk Import is received.
         6) Resizing header of the Inbox, Outbox and Deleted/Failed when changing resolution and form size
         7) Default e-mail receiver option to enable sync works properly
         8) Memory leak fix when adding company properties to comboboxes

   0.0.0.0e 16/06/2006
         1) ICE006 Changing the Polling Time does not appear to make any difference to the email polling (appears to be every 20 seconds)
         2) ICE008 There is no set tab sequence through the DSR Settings. Appears to include frames in tab sequence.
         3) ICE035 If you right-click on User in User Logins, Update is not available
         4) ICE043 If the list of companies is longer than the area in the list box. The Scroll bar goes off the bottom of the listbox and you cannot get the the end of the list.
         5) ICE045 The 'All Mail' Inbox does not show Bulk Export emails when received.
                Names are changed and only new items are going to "Inbox New". If a message arrives
                and already has a company, it goes straight to the respective company mail box
         6) ICE039 If you highlight multiple items to delete, they are deleted but the screen in not refeshed.
         7) ICE054 If you try to Sync from the Accountant, you get " __/___ is not a valid period."

         6) ICE036 Config -> Polling spelt incorrectly on the Configuration screen
         7) ICE037 Config -> Changing the Polling Time does not appear to make any difference to the email polling (appears to be every 20 seconds)
         8) ICE038 Config -> Not able to update POP3 Accounts. You have to Delete and Add New.

 0.0.0.0d  06/06/2006
         1) when history or archive tab was focused, i was still able to select request sync, bulk export...
         2) show the Dsr server and port in case where these items weren't set
         3) configuration menu is open to set the dashboard settings when something went wrong
         4) new option to delete (or not) non related dsr e-mails.
         5) new icons applied

 0.0.0.0d  31/05/2006

         1) Recycle Frame including deleted and failed messages
         2) multi select/delete messages
         3) Drag and drop feature (only moving items to deleted/failed mailbox)

 0.0.0.0c  25/05/2006
        1) IRIS should be in caps in the title bar.
        2) Not able to change the Manager Password
        3) Not able to update existing users. You have to Delete and Add New.
        4) Not able to update Contacts in the Address Book
        5) Polling spelt incorrectly on the Configuration screen
        6) Changing the Polling Time does not appear to make any difference to the email polling (appears to be every 20 seconds)
        7) Not able to update POP3 Accounts. You have to Delete and Add New.
        8) There is no set tab sequence through the DSR Settings
        9) When tabbing through the DSR settings when you get to the MAPI / SMTP selection, MAPI is automatically selected even if SMTP was previously.
        10) When you receive the first sync email and select Import, the message disappears from All Mail Inbox and nothing appears to be happening. Can status on the email change to say 'Creating Company' or something like this so the user knows something is occuring, prior to the company appearing on the companies list..
        11) The subject on Sync requests show the Period and Year as 012006 rather than 01/2006
        12) Company Count not being checked when adding comapnies via Dashboard.
        13) When you receive the Request Sync email, there are no details on the client company to be synced. Only Customer Company
        14) If you set an import running it is still possible to access the 'Import To' and 'Delete' options for the email by right clicking on the email in the inbox.
        15) Show version option on screen or about form
        16) Sync using Practice version
        17) it is possible to add a new schedule and the dsr send a e-mail before the
        company be in Dripfeed (dsr)

  Notes:
    - VAO system only does not show calls for sync, bulk export...
    only CIS calls will be made.
    - These function updates the database without calling the dsr
          actEndofDripfeedExecute (uDashboard)
          TfrmInboxFrame.tmChangeStatusTimer (uInboxFrame) =
          frmConfiguration

  note 11
    advNavSync -> advNavLink
               caption: Dri&pfeed -> Linked Com&panies
    actDripfeed -> actUpdateLink
               caption : &Dripfeed -> Up&date Link
    actEndofDripfeed >- actEndLink
               Caption: &End of Dripfeed -> End Link
    actCancelDripFeed -> actCancelLink
                caption : Cancel Dripfeed -> Cancel Link
    actRequestDripfeed -> actLinkRequest
                caption : Dripfeed &Request -> Link &Request

    lblInfo.Caption := 'Dashboard Add New Dripfeed Scheduled Task'; -> lblInfo.Caption := 'Dashboard Add New Scheduled Task';
    advSubject.Text := 'Scheduled Dripfeed from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(tvComp.Selected.Data).Desc + ']'; -> advSubject.Text := 'Scheduled Task from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(tvComp.Selected.Data).Desc + ']';
    frmDailyScheduleTask.Caption := Dripfeed Scheduled Task -> frmDailyScheduleTask.Caption := Scheduled Task
    frmExportFrame.advSubject.Text := 'Dripfeed Request from ' + ... -> frmExportFrame.advSubject.Text := 'Link Request from ' +
    advSubject.Text := 'Dripfeed from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ... -> advSubject.Text := 'Update Link from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ...
    frmDripfeed.Caption := Dripfeed ->  frmDripfeed.Caption := Update Link;
    frmRequestSync.caption := 'Dripfeed Request' -> frmRequestSync.Caption := 'Link Request';
    word "Dripfeed" changed to "Link or Linked"

    and so on... :)

-----------------------------------------------------------------------------*)

unit uDashHistory;

interface

implementation

end.
