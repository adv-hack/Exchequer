(*-----------------------------------------------------------------------------
 Unit Name: uDashBoard
 Author:    vmoura
 Purpose:

                  _ Application
                 |  _ database
                 | |  _ file structure
                 | | |  _ xml changes
                 | | | |
                 | | | |
 initial version 0.0.0.0b > fixes

///////////////////////////////////////////////////////////////////////////////

A document explaining the dashboard and its units can be found at X:\EXCHLITE\ICE\IceDocumentation\IRIS - Dashboard.exe units and objects.doc

 Defines
 DEBUG = work in debug mode :)
 ISVAO = set the isvao property true for disabling actions

 History:
      0.0.0.0r
      1) CIS Subcontractor interface (export and import)

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
-----------------------------------------------------------------------------*)

Unit uDashBoard;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Variants,
  Dialogs, ImgList, StdActns, ActnList, StdCtrls, ComCtrls, ExtCtrls, CommCtrl,
  AppEvnts, DB, ADODB,

  Math, dateutils, strutils,

  umailBoxBaseFrame, uInboxFrame, uOutboxFrame, uRecycleFrame,

  uAdoDsr, uInterfaces, 

  AdvGlowButton, ToolPanels, AdvNavBar, AdvPanel, AdvMenuStylers, Grids,
  BaseGrid, AdvGrid, DBAdvGrid, Menus, AdvMenus, AdvToolBar,
  AdvToolBarStylers, htmltv, AdvAlertWindow, AdvOfficeStatusBar,
  AdvOfficeStatusBarStylers, HTMListB, AdvSplitter, AdvScrollBox

  ;

Const
  cADDONDESC = 'Export Add-ons';
  cDSRCHECKTIMER = 60000;

Type
  TDSRAlive = class(TThread)
  protected
    Procedure Execute; Override;
  Public
  end;

  {thread to check the companies after the user request to create a company}
  TDASHCheckComp = Class(TThread)
  Private
    Procedure ChekComp;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Execute; Override;
  End;

  {the company's mailbox}
  TMailBoxCompany = Class(TCompany)
  Private
    fMailBoxType: TBoxType;
    fMailBoxBaseFrame: TfrmMailBoxBaseFrame;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  Published
    Property MailBoxType: TBoxType Read fMailBoxType Write fMailBoxType;
    Property MailBox: TfrmMailBoxBaseFrame Read fMailBoxBaseFrame Write
      fMailBoxBaseFrame;
  End;

  TfrmDashboard = Class(TForm)
    advDockdashTop: TAdvDockPanel;
    advDockDashRight: TAdvDockPanel;
    advDockDashBotton: TAdvDockPanel;
    advToolMenu: TAdvToolBar;
    tlbFile: TAdvToolBar;
    advMainMenu: TAdvMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    alDashboard: TActionList;
    imgDashBoard: TImageList;
    AdvMenuStyler: TAdvMenuOfficeStyler;
    AdvToolBarStyler: TAdvToolBarOfficeStyler;
    ppmNew: TAdvPopupMenu;
    advDockDashLeft: TAdvDockPanel;
    advPanelBackgroud: TAdvPanel;
    advPanelNav: TAdvPanel;
    advNav: TAdvNavBar;
    AdvNavLink: TAdvNavBarPanel;
    tvBox: THTMLTreeview;
    imgBox: TImageList;
    tvComp: THTMLTreeview;
    btnNew: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    actArchive: TAction;
    actAddSchedule: TAction;
    actUserLogin: TAction;
    actNewCompany: TAction;
    ActConfiguration: TAction;
    sbDash: TAdvOfficeStatusBar;
    actLinkRequest: TAction;
    imgNavBarBig: TImageList;
    actClose: TAction;
    N1: TMenuItem;
    mnuNew: TMenuItem;
    mnuSystem: TMenuItem;
    mnuComp: TMenuItem;
    mnuUser: TMenuItem;
    N40: TMenuItem;
    mnuConfiguration: TMenuItem;
    actUserPermission: TAction;
    N5: TMenuItem;
    mnuUserPermissions: TMenuItem;
    advNavHistory: TAdvNavBarPanel;
    tvHistory: THTMLTreeview;
    actRefreshCompany: TAction;
    actContacts: TAction;
    mnuEmailContacts: TMenuItem;
    actUpdateLink: TAction;
    mnuView: TMenuItem;
    mnuEventLog: TMenuItem;
    advEventLog: TAdvPanel;
    tmEventLog: TTimer;
    ppmIcelog: TPopupMenu;
    mnuViewLocation: TMenuItem;
    actBulkExport: TAction;
    mnuRequestSync: TMenuItem;
    ppmRebuild: TAdvPopupMenu;
    actRecreate: TAction;
    actEndLink: TAction;
    dsLog: TDataSource;
    qryLog: TADOQuery;
    advGridLog: TDBAdvGrid;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    btnCheckMail: TAdvToolBarButton;
    actCheckMailNow: TAction;
    ppmStatusBar: TAdvPopupMenu;
    actCheckDSRStatus: TAction;
    mnuCheckDSRStatus: TMenuItem;
    advNavArchive: TAdvNavBarPanel;
    tvArchive: THTMLTreeview;
    actStartDSRService: TAction;
    actStopDSRService: TAction;
    mnuStartDSRService: TMenuItem;
    mnuStopDSRService: TMenuItem;
    tmStart: TTimer;
    mnuHelp: TMenuItem;
    actAbout: TAction;
    actUpdateManagerPassword: TAction;
    mnuUpdateManagerPassword: TMenuItem;
    appEvents: TApplicationEvents;
    actDeactivateComp: TAction;
    actDeleteCompany: TAction;
    actActivateCompany: TAction;
    actLogView: TAction;
    imgTabSmall: TImageList;
    mnuReadingPane: TMenuItem;
    btnSystem: TAdvToolBarButton;
    ppmSystem: TAdvPopupMenu;
    mnuNewCompany: TMenuItem;
    N10: TMenuItem;
    mnuContacts: TMenuItem;
    mnuUserLogins: TMenuItem;
    mnuUpdateManagerPassw: TMenuItem;
    mnuConfig: TMenuItem;
    N2: TMenuItem;
    tlbNew: TAdvToolBar;
    btnRequestDripfeed: TAdvToolBarButton;
    btnBulkExport: TAdvToolBarButton;
    btnDripFeed: TAdvToolBarButton;
    btnEndofDripFeed: TAdvToolBarButton;
    qryLogId: TAutoIncField;
    qryLogDescription: TStringField;
    qryLogLocation: TStringField;
    qryLogLastUpdate: TDateTimeField;
    tpDashboard: TAdvToolPanelTab;
    tpCompany: TAdvToolPanel;
    btnCompBulkExport: TAdvGlowButton;
    btnCompEndDripfeed: TAdvGlowButton;
    btnCompDripFeed: TAdvGlowButton;
    btnCompDripFeedReq: TAdvGlowButton;
    SbStyler: TAdvOfficeStatusBarOfficeStyler;
    imgError: TImage;
    tmErrorEvent: TTimer;
    advAlert: TAdvAlertWindow;
    btnCompAddDripFeed: TAdvGlowButton;
    actReminder: TAction;
    N4: TMenuItem;
    mnuReminderWindow: TMenuItem;
    actDeleteInbox: TAction;
    actImport: TAction;
    actDeny: TAction;
    actAccept: TAction;
    actRemoveSchedule: TAction;
    actViewSchedule: TAction;
    actChangeSchedule: TAction;
    tmUpdateCompanyInfo: TTimer;
    N11: TMenuItem;
    mnuInbox: TMenuItem;
    mnuOutbox: TMenuItem;
    actDeleteOutbox: TAction;
    mnuDeleteOutbox: TMenuItem;
    N12: TMenuItem;
    mnuViewSchedule: TMenuItem;
    mnuChangeSchedule: TMenuItem;
    mnuRemoveSchedule: TMenuItem;
    tmCheckEmail: TTimer;
    Accept1: TMenuItem;
    Deny1: TMenuItem;
    N13: TMenuItem;
    Import1: TMenuItem;
    N14: TMenuItem;
    Delete1: TMenuItem;
    BulkExport1: TMenuItem;
    Dripfeed1: TMenuItem;
    N15: TMenuItem;
    About1: TMenuItem;
    mnuHelpContents: TMenuItem;
    lbCompStatus: THTMListBox;
    N16: TMenuItem;
    ClearEventLog1: TMenuItem;
    actClearEventLog: TAction;
    actSelectAllInbox: TAction;
    actSelectAllOutbox: TAction;
    N17: TMenuItem;
    SelectAll1: TMenuItem;
    N18: TMenuItem;
    SelectAll2: TMenuItem;
    actDeleteRecycle: TAction;
    actSelectAllRecycle: TAction;
    DeletedFailed1: TMenuItem;
    SelectAll3: TMenuItem;
    N19: TMenuItem;
    Delete2: TMenuItem;
    EndofDripfeed3: TMenuItem;
    RequestDripfeed1: TMenuItem;
    BulkExport2: TMenuItem;
    Dripfeed2: TMenuItem;
    EndofDripfeed1: TMenuItem;
    AdvPanelStyler: TAdvPanelStyler;
    btnDeleteCompany: TAdvToolBarButton;
    btnActivateCompany: TAdvToolBarButton;
    btnRecreate: TAdvToolBarButton;
    RecreateCompany1: TMenuItem;
    ActivateCompany1: TMenuItem;
    DeleteCompany1: TMenuItem;
    RecreateCompany2: TMenuItem;
    ActivateCompany2: TMenuItem;
    DeleteCompany2: TMenuItem;
    btnAddSchedule: TAdvToolBarButton;
    actCancelLink: TAction;
    btnMore: TAdvToolBarMenuButton;
    ppmMore: TAdvPopupMenu;
    DeactivateCompany2: TMenuItem;
    RefreshCompanies2: TMenuItem;
    mnuFileMore: TMenuItem;
    DeactivateCompany3: TMenuItem;
    RefreshCompanies3: TMenuItem;
    N9: TMenuItem;
    N6: TMenuItem;
    mnuCompMore: TMenuItem;
    N3: TMenuItem;
    DeactivateCompany4: TMenuItem;
    RefreshCompanies4: TMenuItem;
    CancelDripfeed3: TMenuItem;
    CancelDripfeed4: TMenuItem;
    DripfeedScheduledTask1: TMenuItem;
    CancelDripfeed1: TMenuItem;
    DripfeedScheduledTask2: TMenuItem;
    btnCompMore: TAdvGlowButton;
    RecreateCompany3: TMenuItem;
    ActivateCompany3: TMenuItem;
    DeleteCompany3: TMenuItem;
    actInboxPreview: TAction;
    actOutboxPreview: TAction;
    actRecyclePreview: TAction;
    N8: TMenuItem;
    Preview1: TMenuItem;
    N20: TMenuItem;
    actOutboxPreview1: TMenuItem;
    N21: TMenuItem;
    Preview2: TMenuItem;
    actViewCISResponse: TAction;
    ViewCISResponse1: TMenuItem;
    actRecycleRestore: TAction;
    actRecycleRestore1: TMenuItem;
    actResend: TAction;
    Resend1: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    More1: TMenuItem;
    RefreshCompanies1: TMenuItem;
    N24: TMenuItem;
    actSubContractorVerification: TAction;
    SubcontractorVerification1: TMenuItem;
    SubcontractorVerification2: TMenuItem;
    btnCompSubcontractorVerification: TAdvGlowButton;
    btnSubContractorVerification: TAdvToolBarButton;
    Splitter: TAdvSplitter;
    sbMail: TAdvScrollBox;
    lblNoItem: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure tvBoxChange(Sender: TObject; Node: TTreeNode);
    Procedure tvCompChange(Sender: TObject; Node: TTreeNode);
    Procedure AdvNavLinkResize(Sender: TObject);
    Procedure actLinkRequestExecute(Sender: TObject);
    Procedure tvBoxClick(Sender: TObject);
    Procedure tvCompClick(Sender: TObject);
    Procedure actNewCompanyExecute(Sender: TObject);
    Procedure actUserLoginExecute(Sender: TObject);
    Procedure ActConfigurationExecute(Sender: TObject);
    Procedure actRefreshCompanyExecute(Sender: TObject);
    Procedure ppmCompanyPopup(Sender: TObject);
    Procedure actContactsExecute(Sender: TObject);
    Procedure actUpdateLinkExecute(Sender: TObject);
    Procedure tmEventLogTimer(Sender: TObject);
    Procedure mnuViewLocationClick(Sender: TObject);
    Procedure actBulkExportExecute(Sender: TObject);
    Procedure advNavPanelActivate(Sender: TObject; OldActivePanel,
      NewActivePanel: Integer; Var Allow: Boolean);
    Procedure actRecreateExecute(Sender: TObject);
    Procedure actCloseExecute(Sender: TObject);
    Procedure actEndLinkExecute(Sender: TObject);
    Procedure actCheckMailNowExecute(Sender: TObject);
    Procedure actCheckDSRStatusExecute(Sender: TObject);
    Procedure actStartDSRServiceExecute(Sender: TObject);
    Procedure actStopDSRServiceExecute(Sender: TObject);
    Procedure tmStartTimer(Sender: TObject);
    Procedure actAboutExecute(Sender: TObject);
    Procedure actUpdateManagerPasswordExecute(Sender: TObject);
    Procedure tvBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    Procedure tvBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure appEventsException(Sender: TObject; E: Exception);
    Procedure actDeactivateCompExecute(Sender: TObject);
    Procedure actDeleteCompanyExecute(Sender: TObject);
    Procedure actActivateCompanyExecute(Sender: TObject);
    Procedure actLogViewExecute(Sender: TObject);
    Procedure mnuReadingPaneClick(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure btnSystemClick(Sender: TObject);
    Procedure ppmSystemPopup(Sender: TObject);
    Procedure btnNewClick(Sender: TObject);
    Procedure tmErrorEventTimer(Sender: TObject);
    Procedure imgErrorDblClick(Sender: TObject);
    Procedure actAddScheduleExecute(Sender: TObject);
    Procedure actReminderExecute(Sender: TObject);
    Procedure tmUpdateCompanyInfoTimer(Sender: TObject);
    Procedure actRemoveScheduleExecute(Sender: TObject);
    Procedure tvBoxEnter(Sender: TObject);
    Procedure mnuInboxClick(Sender: TObject);
    Procedure tmCheckEmailTimer(Sender: TObject);
    Procedure mnuHelpContentsClick(Sender: TObject);
    Procedure ppmRebuildPopup(Sender: TObject);
    Procedure advNavChange(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure actClearEventLogExecute(Sender: TObject);
    Procedure actCancelLinkExecute(Sender: TObject);
    Procedure tpDashboardTabSlideInDone(Sender: TObject; Index: Integer;
      APanel: TAdvToolPanel);
    procedure actSubContractorVerificationExecute(Sender: TObject);
    procedure sbDashPanelRightClick(Sender: TObject; PanelIndex: Integer);
  Private
    fInboxFrame: TfrmInboxFrame;
    fOutboxFrame: TfrmOutboxFrame;
    fRecycle: TfrmRecycleFrame;
    fClosing: Boolean;

    fDb: TADODSR;
    fCheckComp: TDASHCheckComp;
    Procedure HandleMessage(Var Msg: TMessage);
    Procedure Init;
    Procedure LoadExchequerVersion;
    Procedure SetTreviewSize;
    Procedure LoadMailBox(pFrame: TfrmMailBoxBaseFrame);
    Function GetInboxNode: TTreeNode;
    Function GetOutboxNode: TTreeNode;
    Function GetRecycleNode: TTreeNode;
    Procedure LoadCompanies;
    Function CreateCompanyMailBox(pComp: TCompany; pMailBox: TBoxType; Const
      pMenuActive: Boolean = True; Const pArchive: Boolean = False):
      TMailBoxCompany;
    Procedure GetExPeriodYear(pCompany: Longword; Out pParam1, pParam2:
      WideString);
    Procedure DeleteNode(pNode: TTreeNode);
    Procedure RemoveChild(pNode: TTreeNode);
    Function FindBoxNode(Const pName: String): TTreeNode;
    Function FindNode(Sender: THTMLTreeview; Const pExCode: String): TTreeNode;
    Procedure SelectFirstNode(Sender: THTMLTreeview);
    Procedure SetStatusBarItemCount(pTotal: Integer);
    Procedure SetStatusBarError(Const pValue: String);

    Procedure BringFrametoFront(pFrame: TfrmMailBoxBaseFrame; Const pCaption:
      String);
    Procedure LockControl(pControl: TWinControl; pLock: Boolean);

    Procedure CheckDSRStatus;
    Procedure HideMenus;
    Procedure HideFrames;
    Procedure FramesTimer(Const pActive: Boolean);
    Procedure SetFrameFocus(pFocus: Boolean);
    Function GetSelectedFrame: TfrmMailBoxBaseFrame;
    Procedure ChangeActionStatus(Const pCategory: String; Const pValue: Boolean);

    Procedure CheckCompanyActions;
    Procedure ChangeHistoryBarButtons(pValue: Boolean);
    Procedure ChangeNewToolBarButtons(pValue: Boolean);
    Function CheckCompanyinProcess(pCompany: Integer): Boolean;

    Procedure RemoveAddon;
    Procedure LoadAddOn;

    Procedure OnExecuteAddon(Sender: TObject);

    {events related with baseframe}
    Procedure UpdateCompanyInboxNode(pCompany: Integer; Const pText: String);
    Procedure UpdateInboxNode(pCompany: Integer; Const pText: String);
    //Procedure UpdateInboxAfterLoad(Sender: TObject; pResult: Longword);
    Procedure UpdateAfterLoad(Sender: TObject; pResult: Longword);
    //Procedure UpdateOutboxAfterLoad(Sender: TObject; pResult: Longword);
    Procedure UpdateCompany;
    Procedure UpdateAfterCallDSR(pResult: Longword);
    Procedure AfterUpdateMessage(Sender: Tobject; pMsg: TMessageInfo);
    Procedure NewMessageArrived(Sender: TObject; Const pText: String);
    Procedure AfterDelete(Sender: TObject);

    //Procedure SetIsVao(Const Value: Boolean);
    Procedure SetIsCIS(Const Value: Boolean);
  Public
    Procedure CheckCompanies(pFromMenu: Boolean);
  Published
  End;

Var
  frmDashboard: TfrmDashboard;

Implementation

Uses
  AdvOutlookList, OutlookGroupedList,
  uConsts, uCommon, uRequestSync, uDailyScheduleTask, uDashSettings, uCompany,
  uUsers, uDashConfig, uUserPermission, uAddressBook, uSync, uExportFrame,
  uDashGlobal, uBulkExport, uDSR, uAbout, uUpdateManagerPwd,
  uEndofSyncRequest, uAddOnExport, EntLicence, uDashReminder, uWait,
  uSubcontractorVerification;

{$R *.dfm}

{-----------------------------------------------------------------------------------}

{ TMailBoxCompany }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TMailBoxCompany.Create;
Begin
  Inherited Create;
  fMailBoxBaseFrame := Nil;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TMailBoxCompany.Destroy;
Begin
  If Assigned(fMailBoxBaseFrame) Then
    FreeAndNil(fMailBoxBaseFrame);

  Inherited Destroy;
End;


{-----------------------------------------------------------------------------------}

{ TDASHCheckComp }

{-----------------------------------------------------------------------------
  Procedure: ChekComp
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDASHCheckComp.ChekComp;
Var
  lCont: Integer;
Begin
  If Assigned(frmDashboard) Then
  Begin
//    lCont := 0;
    lCont := frmDashboard.tvComp.Items.Count;
    With frmDashboard Do
    Try
      CheckCompanies(False);

      If frmDashboard.tvComp.Items.Count > lCont Then
        Terminate;
    Finally
    End; {with frmDashboard do}
  End; {If Assigned(frmDashboard) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDASHCheckComp.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLowest;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDASHCheckComp.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDASHCheckComp.Execute;
Var
  lStartTime: TDateTime;
Begin
  lstartTime := now;
  While Not Terminated Do
  Begin
    Application.ProcessMessages;
    Synchronize(ChekComp);
    Sleep(5000);
    {synchronize with dashboard}
    Synchronize(ChekComp);
    {do it for 90sec, otherwise, the other timer will do it}
    If (MilliSecondsBetween(Now, lStartTime) > 45000) Then
      Terminate;
  End; {While Not Terminated Do}
End;

{-----------------------------------------------------------------------------------}

{ TDSRAlive }

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRAlive.Execute;
var
  lTick: Longint;
begin
  ReturnValue := S_FALSE;
  lTick := GetTickCount + cDSRCHECKTIMER;

  while (lTick > GetTickCount) and not Terminated do 
  begin
    try
      ReturnValue := TDsr.DSR_Alive(_DashboardGetDSRServer, _DashboardGetDSRPort);
    except
      on E:Exception do
      begin
        ReturnValue := S_FALSE;
        Break;
      end; {begin}
    end; {try}

    if ReturnValue = S_OK then
      Break;

    Sleep(1);
  end; {while not Terminated do}

  Terminate;
end;


{------------------------------DASHBOARD-------------------------------------------}

{-----------------------------------------------------------------------------
  Procedure: CreateCompanyMailBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.CreateCompanyMailBox(pComp: TCompany; pMailBox: TBoxType;
  Const pMenuActive: Boolean = True; Const pArchive: Boolean = False):
  TMailBoxCompany;
Var
  lComp: TMailBoxCompany;
Begin
  lComp := TMailBoxCompany.Create;
  With lComp Do
  Begin
    lComp.Assign(pComp);
    MailBoxType := pMailBox;
    { instead loading records on the inbox and outbox  frames
    i will check the records on the database and load them according with the
    number of items on the respective box type}
    Case MailBoxType Of
      btInbox:
        Begin
          MailBox := TfrmInboxFrame.Create(Nil);
          MailBox.OnUpdateInboxNode := UpdateCompanyInboxNode;
          MailBox.MailBoxName := cDashInbox;
          MailBox.OnAfterUpdateMessage := AfterUpdateMessage;
          MailBox.OnNewMessageArrived := NewMessageArrived;
          TfrmInboxFrame(MailBox).CompanyActive := lComp.Active;

          //MailBox.OnAfterLoadMessages := UpdateInboxAfterLoad;
        End;
      btOutbox:
        Begin
          MailBox := TfrmOutboxFrame.Create(Nil);
          MailBox.MailBoxName := cDashOutbox;
          //MailBox.OnAfterLoadMessages := UpdateOutboxAfterLoad;
        End;
    End; {Case MailBoxType Of}

    MailBox.Parent := sbMail;
    MailBox.MenuActive := pMenuActive;
    MailBox.Company := Id;
    MailBox.TimerActive := True;
    MailBox.OnAfterCallDSR := UpdateAfterCallDSR;
    MailBox.SendToBack;
    MailBox.Archive := pArchive;
    MailBox.OnAfterDelete := AfterDelete;
    MailBox.OnAfterLoadMessages := UpdateAfterLoad;

    Try
      MailBox.GetMail;
    Finally
      Mailbox.TimerActive := True;
    End; {try}
  End; {With lComp Do}

  Result := lComp;
End;

  {avoid flicking every time a user click one node... It is working better than
  lockwindowupdate wich was delaying the node for some msec...}
Procedure TfrmDashboard.LockControl(pControl: TWinControl; pLock: Boolean);
Begin
  If (pControl = Nil) Or (pControl.Handle = 0) Then
    Exit;

  If pLock Then
    SendMessage(pControl.Handle, WM_SETREDRAW, 0, 0)
  Else
  Begin
    SendMessage(pControl.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(pControl.Handle, Nil, 0, RDW_ERASE Or RDW_FRAME Or RDW_INVALIDATE
      Or RDW_ALLCHILDREN);
  End; {else begin}
End; {Procedure _LockControl(pControl: TWinControl; pLock: Boolean);}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura

  doing everything on formcreate was quite freezing the windows such a number of tasks
  to do.

  so, spliting the tasks, the easy part goes on formcreate and after refreshing the screen
  the hard part starts, but at least with everything visible
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.FormCreate(Sender: TObject);
Begin
  frmWait:= TfrmWait.Create(Nil);
  btnMore.Enabled := False;
  ChangeNewToolBarButtons(True);
  ChangeHistoryBarButtons(False);
  {handle form close messages}
  Self.Windowproc := HandleMessage;
  CheckCompanyActions;

{$IFDEF QA}
  mnuViewLocation.Visible := True;
{$ELSE}
  mnuViewLocation.Visible := False;
{$ENDIF}

  glDashLoading := True;

  fClosing := False;
  btnNew.Enabled := False;
  btnSystem.Enabled := False;
  advEventLog.Height := 0;
  advGridLog.Columns[3].Width := 0;

  {check and adjust screen size}
  If Screen.Width >= 1024 Then
  Begin
    ClientHeight := 690 - sbDash.Height;
    ClientWidth := 1000;
    WindowState := wsNormal;
  End
  Else
  Begin
    ClientHeight := 530 - sbDash.Height;
    ClientWidth := 792;
  End;

  advNav.ActivePanel := AdvNavLink;
  SetTreviewSize;

  {disable action list}
  ChangeActionStatus('all', False);

  {create and set the inbox, outbox and recycle nodes}

  lblNoItem.Visible := False;

  //GetRecycleNode;
  {add the recyble frame to the scroll box}
  fRecycle := TfrmRecycleFrame.Create(Nil);
  fRecycle.Parent := sbMail;
  fRecycle.MailBoxName := cDashRecycle;
  fRecycle.Company := 0;
  fRecycle.MenuActive := True;
  fRecycle.AdvOutlook.DragDropSetting := ddDisabled;
  fRecycle.TimerActive := True;
  fRecycle.OnAfterDelete := AfterDelete;
  fRecycle.OnAfterLoadMessages := UpdateAfterLoad;
  fRecycle.OnUpdateCompany := UpdateCompany;

  //GetOutboxNode;
  {add the outbox frame to the scroll box}
  fOutboxFrame := TfrmOutboxFrame.Create(Nil);
  fOutboxFrame.Parent := sbMail;
  fOutboxFrame.MailBoxName := cDashSent;
  fOutboxFrame.Company := 0;
  fOutboxFrame.OnAfterLoadMessages := UpdateAfterLoad;
  fOutboxFrame.TimerActive := True;
  fOutboxFrame.OnAfterCallDSR := UpdateAfterCallDSR;
  fOutboxFrame.AdvOutlook.DragDropSetting := ddDisabled;
  fOutboxFrame.OnAfterDelete := AfterDelete;

  //GetInboxNode;
  {add the inbox frame to the scroll box}
  fInboxFrame := TfrmInboxFrame.Create(Nil);
  fInboxFrame.Parent := sbMail;
  fInboxFrame.MailBoxName := cDashNew;
  fInboxFrame.Company := 0;
  fInboxFrame.OnUpdateInboxNode := UpdateInboxNode;
  fInboxFrame.OnAfterLoadMessages := UpdateAfterLoad;
  fInboxFrame.OnUpdateCompany := UpdateCompany;
  fInboxFrame.OnAfterCallDSR := UpdateAfterCallDSR;
  fInboxFrame.TimerActive := True;
  fInboxFrame.MenuActive := True;
  fInboxFrame.CompanyActive := True;
  fInboxFrame.BringToFront;
  fInboxFrame.AdvOutlook.DragDropSetting := ddDisabled;
  fInboxFrame.OnNewMessageArrived := NewMessageArrived;
  fInboxFrame.OnAfterDelete := AfterDelete;

  GetInboxNode;
  GetOutboxNode;
  GetRecycleNode;

  Application.ProcessMessages;
  mnuReadingPane.checked := _DashboardGetReadPane;

  {start init section}
  tmStart.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: HandleMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.HandleMessage(Var Msg: TMessage);
Begin
  If Msg.Msg = WM_CLOSE Then
  Begin
    FramesTimer(False);
    tmUpdateCompanyInfo.Enabled := False;
    tmEventLog.Enabled := False;
    actRefreshCompany.Enabled := False;
    tmErrorEvent.Enabled := False;
    tmCheckEmail.Enabled := False;
    fClosing := True;
  End; {if Msg.Msg = wm_close then}

  Self.WndProc(Msg);
End;

{-----------------------------------------------------------------------------
  Procedure: Init
  Author:    vmoura

-----------------------------------------------------------------------------}
Procedure TfrmDashboard.Init;

  procedure SetFocusInbox;
  begin
    try
      ActiveControl := tvBox;
    finally
    end;
  end; {procedure SetFocusInbox;}

  procedure ChangeToCIS;
  begin
    {check ICS and VAO }
    If Assigned(fDB) And fDb.Connected Then
    Begin
      glIsVAO := fDb.GetSystemValue(cISVAOPARAM) = '1';
      glIsCIS := fDb.GetSystemValue(cISCISPARAM) = '1';
      SetIsCIS(glIsCIS);
    End; {if Assigned(fDB) and fDb.Connected then}
  end; {procedure ChangeToCIS;}

var
  lOldCis: Boolean;

Begin
  frmWait.Start;
  advNav.ActivePanel := AdvNavLink;
  Application.ProcessMessages;
  SetFocusInbox;
  fRecycle.ResizeHeaders;
  fOutboxFrame.ResizeHeaders;
  fInboxFrame.ResizeHeaders;
  Application.ProcessMessages;

  ChangeActionStatus('all', False);

  _CallDebugLog('About to connect the database...');
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On E: Exception Do
    Begin
      ShowDashboardDialog('An exception has occurred:' + #13#13 + E.Message,
        mtError, [mbok]);

      _LogMSG('Dashboard error connecting to the database: ' + E.MEssage);
    End;
  End; {try}

  ChangeToCIS;

  lOldCis := glISCIS;

  ChangeHistoryBarButtons(False);
  ChangeNewToolBarButtons(True);

  Application.ProcessMessages;

  glDSROnline := False;
  //advNav.ActivePanel := AdvNavLink;
  advEventLog.Height := 0;
  tmEventLog.Enabled := False;
  qryLogLocation.Visible := False;

  //SetTreviewSize;

  Application.ProcessMessages;

  _logMsg('***** DASHBOARD Start *****');
  _logMsg('The DASHBOARD Version is ' + cDASHVERSION);
  _logMsg('The Service Version is ' + cDSRVERSION);

  ForceDirectories(_GetApplicationPath + cBULKDIR);
  ForceDirectories(_GetApplicationPath + cDBBACKUP);

  If (_FileSize(_GetApplicationPath + cDASHBOARDINI) > 0) And
    (_DashboardGetDBServer <> '') Then
    _logMsg('Dashboard config file found and database server is ' +
      _DashboardGetDBServer)
  Else
  Begin
    _logMsg('The Dashboard config file not found or dbserver not set.');
    _logMsg('The Dashboard is setting the database server to local machine');
    _DashboardSetDBServer(_GetComputerName);
  End;

  If _DashboardGetDSRServer = '' Then
  Begin
    _LogMSG('The Service server is not set. ');
    _LogMSG('The Dashboard is setting the Service server to local machine...');
    _DashboardSetDSRServer(_GetComputerName);
  End; {If _DashboardGetDSRServer = '' Then}

  If _DashboardGetDSRPort <= 0 Then
  Begin
    _LogMSG('The Service server connection port is not valid. ');
    _LogMSG('The Dashboard is setting the Service connection port to default...');
    _DashboardSetDSRPort(cDEFAULTDSRPORT);
  End; {If _DashboardGetDSRPort <= 0 Then}

(*  _CallDebugLog('About to connect the database...');

  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On E: Exception Do
    Begin
      ShowDashboardDialog('An exception has occurred:' + #13#13 + E.Message,
        mtError, [mbok]);

      _LogMSG('Dashboard error connecting to the database: ' + E.MEssage);
    End;
  End; {try}

  {check ICS and VAO }
  If Assigned(fDB) And fDb.Connected Then
  Begin
    glIsVAO := fDb.GetSystemValue(cISVAOPARAM) = '1';
    glIsCIS := fDb.GetSystemValue(cISCISPARAM) = '1';
    SetIsCIS(glIsCIS);
  End; {if Assigned(fDB) and fDb.Connected then}*)

  SetFocusInbox;
  Application.ProcessMessages;

  {check the service status}
  _CallDebugLog('Checking DSRWrapperServer server...');
  actStartDSRService.Visible := _ServiceExists(cDSRSERVICE, _DashboardGetDSRServer);
  actStopDSRService.Visible := _ServiceExists(cDSRSERVICE, _DashboardGetDSRServer);
  sbDash.Panels[5].Text := 'Version ' + cDASHVERSION;

  {checl dsr status}
  CheckDSRStatus;

  ChangeToCIS;

  ChangeHistoryBarButtons(False);
  ChangeNewToolBarButtons(True);

  {load stored companies}
  LoadCompanies;

  Application.ProcessMessages;

  //tmCheckEmail.Interval := _DashboardGetPollingTime * cDSRCHEKMAILINTERVAL;
  tmCheckEmail.Interval := StrToIntDef(fDb.GetSystemValue(cPOLLINGTIMEPARAM), 1) * cDSRCHEKMAILINTERVAL;

  tmEventLog.Enabled := True;
  tmUpdateCompanyInfo.Enabled := True;
  tmCheckEmail.Enabled := True;
  mnuReadingPaneClick(Nil);
  btnSystem.Enabled := True;

  {check reminder active}
  //If _DashboardGetShowReminder Then
  if fDb.GetSystemValue(cSHOWREMINDERPARAM) = '1' then
    actReminderExecute(Self);

  glDashLoading := False;

  SetFocusInbox;
  //tvBoxClick(tvBox);
  Application.ProcessMessages;
  frmWait.Stop;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.DeleteNode(pNode: TTreeNode);
Var
  lComp: TCompany;
  lCompBox: TMailBoxCompany;
Begin
  If pNode <> Nil Then
    If pNode.Data <> Nil Then
    Begin
      If lowercase(TObject(pNode.Data).ClassName) = lowercase(TCompany.ClassName)
        Then
      Begin
        lComp := TCompany(pNode.Data);
        If Assigned(lComp) Then
        Begin
          FreeAndNil(lComp);
          //pNode.Data := Nil;
        End; {If Assigned(lComp) Then}

//        RemoveChild(pNode);

        pNode.Data := Nil;

        Try
          pNode.DeleteChildren;
          pNode.Delete;
        Except
        End;

      End {If TObject(tvComp.Items[lCont].Data) Is TCompany Then}
      Else If Lowercase(TObject(pNode.Data).ClassName) =
        Lowercase(TMailBoxCompany.ClassName) Then
      Begin
        lCompBox := TMailBoxCompany(pNode.Data);
        If Assigned(lCompBox) Then
        Begin
          FreeAndNil(lCompBox);
          //pNode.Data := Nil;
        End; {If Assigned(lCompBox) Then}

//        RemoveChild(pNode);

        pNode.Data := Nil;

        Try
          pNode.DeleteChildren;
          pNode.Delete;
        Except
        End;

      End; {If TMailBoxCompany(pNode.Data).ClassName = TMailBoxCompany.ClassName}
    End; {If pNode.data <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: RemoveChild
  Author:    vmoura

  remove the inbox/outbox child nodes
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.RemoveChild(pNode: TTreeNode);
Var
  lCont: Integer;
  lMailBox: TMailBoxCompany;
Begin
  If (pNode <> Nil) And pNode.HasChildren Then
  Begin
    Try
      For lCont := pNode.Count - 1 Downto 0 Do
    {check the "Inbox/Outbox" nodes}
        If (Lowercase(pNode.Item[lCont].Text) = lowercase(cdashinbox)) Or
          (Lowercase(pNode.Item[lCont].Text) = lowercase(cdashoutbox)) Then
          If pNode.Item[lCont].Data <> Nil Then
          Begin
          {remove the company mailbox}
            lMailBox := TMailBoxCompany(pNode.Item[lCont].Data);
            If Assigned(lMailBox) Then
              FreeAndNil(lMailBox);

            pNode.Item[lCont].Data := Nil;
          End; {If pNode.Item[lCont].Data <> Nil Then}
    Finally
      Try
        pNode.DeleteChildren;
      Except
      End;
    End; {try...finally}
  End; {If (pNode <> Nil) And pNode.HasChildren Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.LoadCompanies;
  Function _AddChild(Sender: THTMLTreeview; pNode: TTreeNode; Const pDesc:
    String): TTreeNode;
  Begin
    Sender.Items.BeginUpdate;
    Result := Sender.Items.AddChild(pNode, pDesc);
    Result.StateIndex := 1;
    Sender.Items.EndUpdate;
  End;

Var
  lComp1, lComp2, lComp3: TCompany;
  lCompanies: OleVariant;
  lTotal,
    lCont: Integer;
  lNode, lNodeArch: TTreeNode;
  lDeleted: Boolean;
//  lFrame: TfrmMailBoxBaseFrame;
Begin
  lDeleted := False;

  If Assigned(fDb) Then
  Begin
    {get the companies from database}
    {if iaoo is set, i will load only the company that belongs to a particular
    installation.
    the filter is the system dir reg entry for exchequer
    when i load the companies dataset, i will apply that filter to the directory
    field and load companies for that specific install
    }
    lCompanies := null;
    Try
      lCompanies := fDb.GetCompanies(IfThen(glIsVAO, _GetEnterpriseSystemDir, ''));
    Except
    End;

    {get selected frame to check what action treeview to execute}
//    lFrame := GetSelectedFrame;
    lTotal := _GetOlevariantArraySize(lCompanies);

    LockControl(sbMail, True);
//    LockControl(Self, True);

    For lCont := 0 To lTotal - 1 Do
    Begin
      { create a object with the company detail}
      lComp1 := _CreateCompanyObj(lCompanies[lCont]);

      If lComp1 <> Nil Then
      Begin
        If lComp1.Active Then
        Begin
          {if this company was restored, delete from history tab}
          DeleteNode(FindNode(tvHistory, lComp1.ExCode));
          lNode := FindNode(tvComp, lComp1.ExCode);
        End
        Else
        Begin
          {if this company was deleted, remove from active tab}
          DeleteNode(FindNode(tvComp, lComp1.ExCode));
          lNode := FindNode(tvHistory, lComp1.ExCode);
        End; {begin}

          {avoid create and destroy every time a new comp is added}
        If lNode = Nil Then
        Begin
          If lComp1.Active Then
            lNode := tvComp.Items.Add(Nil, _ChangeAmpersand(lComp1.Desc) + ' (' +
              lComp1.ExCode + ')')
          Else {If lComp1.Active Then}
          Begin
            lNode := tvHistory.Items.Add(Nil, _ChangeAmpersand(lComp1.Desc) +
              ' (' + lComp1.ExCode + ')');
            _CompanyDeleteBulk(lComp1.Guid);
          End; {else begin}

          {set the node information and refresh the treeview}
          lNode.StateIndex := 7;
          lComp2 := TCompany.Create;
          lComp2.Assign(lComp1);
          lNode.Data := lComp2;
          lNode.TreeView.Refresh;
        End {if lNode <> nil then}
        Else
        Begin
          If lNode.Data <> Nil Then
            If TCompany(lNode.Data).Guid <> lComp1.Guid Then
              TCompany(lNode.Data).Guid := lComp1.Guid;
        End;

        {check if inbox or outbox has a record}
        If (fDb <> Nil) And ((fDb.GetTotalInboxMessages(lComp1.Id) > 0) Or
          (fDb.GetTotalOutboxMessages(lComp1.Id) > 0)) Then
        Begin
          If (lNode <> Nil) And Not lNode.HasChildren Then
          Begin
            {check if active. If yes, add to normal treeview, otherwise add to history tab}
            If lComp1.Active Then
            Begin
              With _AddChild(tvComp, lNode, cDashInbox) Do
                Data := CreateCompanyMailBox(lComp1, btInbox);

              With _AddChild(tvComp, lNode, cDashOutbox) Do
                Data := CreateCompanyMailBox(lComp1, btOutbox);
            End {If lComp1.Active Then}
            Else
            Begin
              With _AddChild(tvHistory, lNode, cDashInbox) Do
                Data := CreateCompanyMailBox(lComp1, btInbox);

              With _AddChild(tvHistory, lNode, cDashOutbox) Do
                Data := CreateCompanyMailBox(lComp1, btOutbox);
            End;
          End {if (lNode <> nil) and not lNode.HasChildren then}
        End {inbox or outbox  > 0}
        Else
        Begin
          {when user has deleted all inbox/oubox messages}
          If (lNode <> Nil) And lNode.HasChildren Then
          Begin
            Try
              RemoveChild(lNode);
            Finally
            End;

            lDeleted := True;
          End;
        End; {begin}

        {add this company to archive tab}
        If (fDb.CompanyHasInboxArchive(lComp1.Id) Or
          fDb.CompanyHasOutboxArchive(lComp1.Id)) And lComp1.Active Then
        Begin
          lNodeArch := FindNode(tvArchive, lComp1.ExCode);
          {add details to the main node}
          If lNodeArch = Nil Then
          Begin
            lNodeArch := tvArchive.Items.Add(Nil, _ChangeAmpersand(lComp1.Desc) +
              ' (' + lComp1.ExCode + ')');

            lComp3 := TCompany.Create;
            lComp3.Assign(lComp1);
            lNodeArch.Data := lComp3;
            lNodeArch.StateIndex := 7;
            lNodeArch.TreeView.Refresh;
          End; {if lNodeArch = nil then}

          If (lNodeArch <> Nil) And Not lNodeArch.HasChildren Then
          Begin
            With _AddChild(tvArchive, lNodeArch, cDashInbox) Do
              Data := CreateCompanyMailBox(lComp1, btInbox, False, True);

            With _AddChild(tvArchive, lNodeArch, cDashOutbox) Do
              Data := CreateCompanyMailBox(lComp1, btOutbox, False, True);
          End; {If (lNodeArch <> Nil) And Not lNodeArch.HasChildren Then}
        End; {if (lInboxArch  or lOutboxArch) and lComp1.Active  then}
      End; {If lComp1 <> Nil Then}

      If Assigned(lComp1) Then
        FreeAndNil(lComp1);

      Application.ProcessMessages;  
    End; { for}

    lCompanies := null;
    LockControl(sbMail, False);
    //LockControl(Self, False);

    If lDeleted Then
    Begin
      Try
        If tpCompany.Locked Then
          tpCompany.Locked := False;

        {clear company info}
        lbCompStatus.Clear;

        {set focus to tvbox}
        If tvBox.CanFocus Then
        Begin
          tvBox.SetFocus;
          tvBoxClick(Nil);
        End;

        Application.ProcessMessages;
      Except
      End {If lDeleted Then}
    End {reset focus}
    Else {If lFrame <> Nil Then}
    Begin

      //If lFrame.Company = 0 Then

//      If tvBox.Selected <> Nil Then
//        tvBoxClick(Nil)
//      Else If tvComp.Selected <> Nil Then
//        tvCompClick(tvComp);

      If (tvBox.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
        tvBoxClick(Nil)
      Else If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
        tvCompClick(tvComp)
      Else If (tvHistory.Selected <> Nil) And (advNav.ActivePanel = advNavHistory)
        Then
        tvCompClick(tvHistory)
      Else
        tvCompClick(tvArchive);
    End; {else if ldeleted}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.GetInboxNode: TTreeNode;
Begin
//  Result := FindBoxNode(cDashInbox);
  Result := FindBoxNode(cDashNew);
  If Result = Nil Then
  Begin
//    Result := tvBox.Items.Add(Nil, cDashInbox);
    Result := tvBox.Items.Add(Nil, cDashNew);
    Result.StateIndex := 2;
  End; {If Result = Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.GetOutboxNode: TTreeNode;
Begin
//  Result := FindBoxNode(cDashOutbox);
  Result := FindBoxNode(cDashSent);
  If Result = Nil Then
  Begin
//    Result := tvBox.Items.Add(Nil, cDashOutbox);
    Result := tvBox.Items.Add(Nil, cDashSent);
    Result.StateIndex := 3;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetRecycleNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.GetRecycleNode: TTreeNode;
Begin
  Result := FindBoxNode(cDashRecycle);
  If Result = Nil Then
  Begin
    Result := tvBox.Items.Add(Nil, cDashRecycle);
    Result.StateIndex := 6;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMailBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.LoadMailBox(pFrame: TfrmMailBoxBaseFrame);
Begin
  If pFrame <> Nil Then
  Begin
    lblNoItem.Visible := False;
    pFrame.Visible := True;
    BringFrametoFront(pFrame, pFrame.MailBoxName);
    SetStatusBarItemCount(pFrame.Count);
  End; {If pFrame <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  frmWait.Free;
  _logMsg('***** DASHBOARD END *****');
End;

{-----------------------------------------------------------------------------
  Procedure: tvBoxChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvBoxChange(Sender: TObject; Node: TTreeNode);
Begin
  ChangeActionStatus('new', False);
  CheckCompanyActions;

  tvBoxClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: tvCompChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvCompChange(Sender: TObject; Node: TTreeNode);
Begin
  ChangeActionStatus('new', False);
  CheckCompanyActions;

  tvCompClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: FindBoxNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.FindBoxNode(Const pName: String): TTreeNode;
Var
  lCont: Integer;
Begin
  Result := Nil;
  For lCont := 0 To tvBox.Items.Count - 1 Do
  Begin
    If Pos(Lowercase(pname), Lowercase(tvBox.Items[lCont].Text)) > 0 Then
    Begin
      Result := tvBox.Items[lCont];
      Break;
    End; {If Pos(Lowercase(pname), Lowercase(tvBox.Items[lCont].Text)) > 0 Then}
  End; {For lCont := 0 To tvBox.Items.Count - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: FindCompNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.FindNode(Sender: THTMLTreeview; Const pExCode: String):
  TTreeNode;
Var
  lCont: Integer;
Begin
  Result := Nil;
  If Sender <> Nil Then
    If Sender Is THTMLTreeview Then
      With Sender As THTMLTreeview Do
        For lCont := 0 To Items.Count - 1 Do
          If Items[lCont].Data <> Nil Then
            If Lowercase(TMailBoxCompany(Items[lCont].Data).ExCode) =
              Lowercase(pExcode) Then
            Begin
              Result := Items[lCont];
              Break;
            End; { pExCode = text}
End;

{-----------------------------------------------------------------------------
  Procedure: SelectFirstNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SelectFirstNode(Sender: THTMLTreeview);
Begin
  If Sender <> Nil Then
    If Sender Is THTMLTreeview Then
      With (Sender As THTMLTreeview) Do
      Begin
        {check number of nodes}
        If Items.Count > 0 Then
          {check if there is at least one selected}
          If Selected = Nil Then
          Begin
            {if not, try getting the top one}
            If TopItem <> Nil Then
              Select(TopItem);
          End
          Else
            Select(Selected);
      End; {With (Sender As THTMLTreeview) Do}
End;

{-----------------------------------------------------------------------------
  Procedure: SetStatusBarItemCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SetStatusBarItemCount(pTotal: Integer);
Begin
  If pTotal > 0 Then
  Begin
    If pTotal = 1 Then
      sbDash.Panels[0].Text := '1 Item'
    Else
      sbDash.Panels[0].Text := Inttostr(pTotal) + ' Items';
  End
  Else
    sbDash.Panels[0].Text := '0 Items';
End;

{-----------------------------------------------------------------------------
  Procedure: AdvNavMailResize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.AdvNavLinkResize(Sender: TObject);
Begin
  SetTreviewSize;
End;

{-----------------------------------------------------------------------------
  Procedure: actRequestSyncExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actLinkRequestExecute(Sender: TObject);
Var
  lModal: TModalResult;
  lp1, lp2: WideString;
Begin
  If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
    If tvComp.Selected.Data <> Nil Then
      If TObject(tvComp.Selected.Data) Is TCompany Then
      Begin
        Application.ProcessMessages;

        Application.CreateForm(TfrmRequestSync, frmRequestSync);
        With frmRequestSync Do
        Begin
          {load drip feed parameters via dsr}
          GetExPeriodYear(TCompany(tvComp.Selected.Data).Id, lp1, lp2);

          {update visual values}
          With frmExportFrame Do
          Begin
            Try
              If Not SelectCompany(TCompany(tvComp.Selected.Data).ExCode) Then
                cbCompanies.Enabled := True;
            Except
            End;

            SetExportDetails(Nil, '', lp1, lp2);
            ParamYear1 := lP1;
            ParamYear2 := lp2;
          End; {With frmExportFrame Do}

          {get the default e-mail receiver if there is one}
          Try
            frmExportFrame.advTo.Text :=
              fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
          Except
          End;

          frmExportFrame.advSubject.Text := 'Link Request from ' +
            //_DashboardGetCompanyName + ' [' + TCompany(tvComp.Selected.Data).Desc + ']';
          fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(tvComp.Selected.Data).Desc + ']';

          lModal := ShowModal;
          FreeAndNil(frmRequestSync);
        End; {With frmRequestSync Do}

        Application.ProcessMessages;

        If lModal = mrOK Then
        Begin
          LoadCompanies;
//          tvCompClick(tvComp);
          CheckCompanyActions;
        End; {If lModal = mrOK Then}
      End; {If TObject(tvComp.Selected.Data) Is TCompany Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actExitExecute
  Author:    vmoura

  make the frame visible and set its caption
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.BringFrametoFront(pFrame: TfrmMailBoxBaseFrame;
  Const pCaption: String);
Begin
  If pFrame <> Nil Then
  Begin
    LockControl(pFrame, True);

    {change focus of all frames to false}
    SetFrameFocus(False);

    If pCaption <> '' Then
      pFrame.PanelCaption := _ChangeAmpersand(pCaption);

    pFrame.BringToFront;
    pFrame.Visible := True;
    pFrame.HasFocus := True;
    pFrame.PaneVisible := mnuReadingPane.checked;
    {check for message in the list or clear the pane list}
    If pFrame.Count > 0 Then
    Begin
      {if not item is selected, get the first valid. Otherwise, just make the selection valid}
      If pFrame.AdvOutlook.SelectedCount = 0 Then
      Begin
        Try
          pFrame.SetFirstValidItem;
        Except
        End;
      End
      Else
        pFrame.AdvOutlookSelectionChange(pFrame.AdvOutlook);
    End
    Else
      pFrame.SetPaneNoInfo;

    LockControl(pFrame, False);
  End; {If pFrame <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: tvBoxClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvBoxClick(Sender: TObject);
Begin
  If (tvBox.Selected <> Nil) Then
  Begin
    If tvComp.Selected <> Nil Then
    Try
      tvComp.ClearSelection();
    Except
    End; {If tvComp.Selected <> Nil Then}

    Case tvBox.Selected.Index Of
      0: LoadMailBox(fInboxFrame);
      1: LoadMailBox(fOutboxFrame);
      2: LoadMailBox(fRecycle);
    End; {Case tvBox.Selected.Index Of}

    ChangeActionStatus('inbox', False);
    ChangeActionStatus('outbox', False);
    ChangeActionStatus('recycle', False);
    {if company ingo is being displayed, close it}
    If tpCompany.Locked Then
      tpCompany.Locked := False;
  End; {If tvBox.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: tvCompClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvCompClick(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: TMailBoxCompany;
Begin
  If Assigned(fDb) And (Sender <> Nil) Then
  Begin
(*    LoadCompanies;*)

  {remove the previous inbox/outbox selection}
    If (Sender <> tvArchive) And ((tvBox.Selected <> Nil) And (tvComp.Selected
      <> Nil)) Then
    Try
      tvBox.ClearSelection();
    Except
    End;

    LockControl(sbMail, True);

    {get the selected treeview}
    If (Sender As THTMLTreeview).Selected <> Nil Then
    Begin
      If (Sender As THTMLTreeview).Selected.Data <> Nil Then
      Begin
        ChangeActionStatus('inbox', False);
        ChangeActionStatus('outbox', False);
        ChangeActionStatus('recycle', False);

        lComp := Nil;
       {get the selected company information }

        lNode := (Sender As THTMLTreeview).Selected;

        If TObject(lNode.Data) Is TCompany Then
          If lNode.HasChildren Then
            lNode := lNode.getFirstChild;

        If lNode <> Nil Then
          lComp := TMailBoxCompany(lNode.Data);

        If lComp <> Nil Then
        Begin
          Case lComp.MailBoxType Of
            btInbox:
              Begin
                lblNoItem.Visible := False;
                TfrmInboxFrame(lComp.MailBox).Visible := True;

                BringFrametoFront(lComp.MailBox, lComp.MailBox.MailBoxName +
                  ' - ' + lComp.Desc + ' (' + lComp.ExCode + ')');

                SetStatusBarItemCount(TfrmInboxFrame(lComp.MailBox).Count);
              End;

            btOutbox:
              Begin
                lblNoItem.Visible := False;
                TfrmOutboxFrame(lComp.MailBox).Visible := True;

                BringFrametoFront(lComp.MailBox, lComp.MailBox.MailBoxName +
                  ' - ' + lComp.Desc + ' (' + lComp.ExCode + ')');

                SetStatusBarItemCount(TfrmOutboxFrame(lComp.MailBox).Count);
              End; {begin}
          Else
            Begin
              SetStatusBarItemCount(0);
              HideFrames;
            End;
          End; {Case lComp.MailBoxType Of}
        End; {If lComp <> Nil Then}
      End; {If tvComp.Selected.Data <> Nil Then}
    End; {If tvComp.Selected <> Nil Then}

    LockControl(sbMail, False);
    
    Application.ProcessMessages;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: actNewExecute
  Author:    vmoura

  when i rezise the dashboard form, i need to resize some components
  to do not get something odd on screen
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SetTreviewSize;
Begin
  tvBox.Left := 0;
  tvBox.Width := advNav.Width;
  tvBox.Height := AdvNavLink.Sections[0].Height - 16;
  tvBox.Top := 17;
  // companies
  tvComp.Height := AdvNavLink.Height - AdvNavlink.Sections[0].Height - 17;
End;

{-----------------------------------------------------------------------------
  Procedure: actCompanyExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actNewCompanyExecute(Sender: TObject);
Begin
  If actNewCompany.Visible And actNewCompany.Enabled Then
  Begin
    Application.CreateForm(TfrmCompanyManager, frmCompanyManager);

    With frmCompanyManager Do
    Begin
      ShowModal;
      Free;
    End;

    Application.ProcessMessages;
    Sleep(1000);

    LoadCompanies;
    tvCompClick(tvComp);
  End; {If actNewCompany.Visible And actNewCompany.Enabled Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actuserExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actUserLoginExecute(Sender: TObject);
Begin
  {check if the options is available}
  If actUserLogin.Visible And actUserLogin.Enabled Then
  Begin
    Application.CreateForm(TfrmUser, frmUser);

    With frmUser Do
    Begin
      ShowModal;
      Free;
    End; {With frmUser Do}
  End; {if actUserLogin.Visible and actUserLogin.Enabled then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: ActConfigurationExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ActConfigurationExecute(Sender: TObject);
Begin
  //Application.CreateForm(TfrmConfiguration, frmConfiguration);
  Application.CreateForm(TfrmConfiguration, frmConfiguration);
  frmConfiguration.ShowModal;
  FreeAndNil(frmConfiguration);
End;

{-----------------------------------------------------------------------------
  Procedure: actRefreshCompanyExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actRefreshCompanyExecute(Sender: TObject);
Begin
  If actRefreshCompany.Enabled Then
  Begin
    frmWait.Start('Refreshing company information...');
    Application.ProcessMessages;
    try
      CheckCompanies(True);
    finally
      frmWait.Stop;
    end; {try}
  End; {If actRefreshCompany.Enabled Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadExchequerVersion
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.LoadExchequerVersion;
Var
  lPro: TelProductType;
  lRes: Integer;
Begin
    {lPro := lLic.elProductType;}
  lPro := ptExchequer;

  {try loading the value from the database first}
  lRes := StrToIntDef(fDb.GetSystemValue(cEXPRODTYPEPARAM), GENERIC_FAIL);
  If (lRes = GENERIC_FAIL) And glDSROnline Then
    lRes := TDSR.DSR_ExProductType(_DashboardGetDSRServer, _DashboardGetDSRPort);

  If (lRes <> GENERIC_FAIL) And (lRes In [Ord(ptExchequer), Ord(ptLITECust),
    Ord(ptLITEAcct)]) Then
    lPro := TelProductType(lRes);

{$IFNDEF DEBUG}
  glProduct := lPro;
{$ELSE}
//  glProduct := ptLITEAcct;
  glProduct := lPro;
{$ENDIF}

  {TelProductType = (ptExchequer=0, ptLITECust=1, ptLITEAcct=2);}

  Case lPro Of
    ptLITECust: sbDash.Panels[1].Text := 'Customer Version';
    ptLITEAcct: sbDash.Panels[1].Text := 'Practice Version';
    ptExchequer: sbDash.Panels[1].Text := 'Exchequer Version';
  End; {Case lPro Of}
End;

{-----------------------------------------------------------------------------
  Procedure: ppmCompanyPopup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ppmCompanyPopup(Sender: TObject);
Begin
  CheckCompanyActions;

  RemoveAddon;

  If _DashboardGetExportAddon Then
    LoadAddOn;
End;

{-----------------------------------------------------------------------------
  Procedure: actContactsExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actContactsExecute(Sender: TObject);
Begin
  If actContacts.Visible And actContacts.Enabled Then
  Begin
    Application.CreateForm(TfrmAddressBook, frmAddressBook);

    With frmAddressBook Do
    Begin
      ShowModal;
      Free;
    End; {with frmAddressBook do}
  End; {if actContacts.Visible and actContacts.Enabled then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: actSyncExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actUpdateLinkExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lP1, lP2: WideString;
  lModal: TModalResult;
Begin
  Inherited;

    {check the node data}
  If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
    If tvComp.Selected.Data <> Nil Then
      If TObject(tvComp.Selected.Data) Is TCompany Then
      Begin
          {get the top message}
        If glProduct = ptLITEAcct Then
          lMsg := fDb.GetTopInboxMessage(TCompany(tvComp.Selected.Data).Id)
        Else
          lMsg := fDb.GetTopOutboxMessage(TCompany(tvComp.Selected.Data).Id);

          {call sync in Dripfeed mode}
        Application.CreateForm(TfrmDripfeed, frmDripfeed);

        With frmDripfeed, frmDripfeed.frmExportFrame Do
        Begin
              {get the Dripfeed period and year}
            //GetExPeriodYear(TCompany(tvComp.Selected.Data).Id, lp1, lp2);
          TDSR.DSR_GetDripFeedParams(_DashboardGetDSRServer, _DashboardGetDSRPort,
            TCompany(tvComp.Selected.Data).Id, lp1, lp2);

            {get the default e-mail receiver if there is one}
          Try
            advTo.Text := fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
          Except
          End;

          If (lMsg <> Nil) And (advTo.Text = '') Then
          Begin
            If glProduct = ptLITEAcct Then
              advTo.Text := lMsg.From
            Else
              advTo.Text := lMsg.To_;
          End; {If lMsg <> Nil Then}

          SelectCompany(TCompany(tvComp.Selected.Data).ExCode);
            {set the message params}
          SetExportDetails(lMsg, '', lp1, lP2);

          ParamYear1 := lP1;
          ParamYear2 := lp2;

          //advSubject.Text := 'Dripfeed from ' + _DashboardGetCompanyName + ' ['
          advSubject.Text := 'Update Link from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM)
            + ' [' + TCompany(tvComp.Selected.Data).Desc + '] at ' +
            Datetimetostr(Now);

          cbJobs.Enabled := False;
          SelectDripFeed;
          lModal := ShowModal;
          FreeAndNil(frmDripfeed);
        End; {With frmExportTask, frmExportTask.frmExportFrame Do}

        If lModal = mrOK Then
        Begin
          LoadCompanies;
//          tvCompClick(tvComp);
        End; {If lModal = mrOK Then}

        Application.ProcessMessages;
        CheckCompanyActions;
      End; {If TObject(tvComp.Selected.Data) Is TCompany Then}

  If Assigned(lMsg) Then
    FreeAndNil(LMsg);

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: tmEventLogTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tmEventLogTimer(Sender: TObject);
Var
  lRecPos: Integer;
  lError: Boolean;
Begin
  tmEventLog.Enabled := False;
  lError := False;

  If Not fClosing Then
  Begin
    lRecPos := 0;

    Try
      If Not qryLog.Active Then
      Begin
        If qryLog.ConnectionString = '' Then
          qryLog.ConnectionString := fDb.ConnectionString;

        qryLog.Open;
      End;
    Except
    End;

    Try
      qryLog.DisableControls;
      qryLog.Prepared := FAlse;
      lRecPos := qryLog.RecNo;
      qryLog.Close;
      qryLog.Prepared := True;
      qryLog.Open;
    Finally
      Try
        qryLog.First;
        lError := SameDate(Date, qryLogLastUpdate.AsDateTime) And (Pos('error',
          lowercase(qryLogDescription.AsString)) > 0);
      Except
      End;

      Try
        {put the pointer where it was last}
        If qryLog.Active And Not qryLog.IsEmpty Then
        Begin
          If (qryLog.RecordCount > 0) And (lRecPos > 0) Then
            qryLog.RecNo := lRecPos
        End;
      Except
      End; {try}

      qryLog.EnableControls;

      Application.ProcessMessages;
    End; {try}
  End; {if not fClosing then}

  If lError Then
  Begin
//    imgError.Align := alNone;
    //imgError.Align := alRight;
    imgError.Top := 0;
    imgError.Left := advDockdashTop.Width - imgError.Width;
    imgError.Visible := True;
    SetStatusBarError('An error has just occurred. Please check the Event Log.');
    tmErrorEvent.Enabled := True;
  End
  Else
  Begin
//    imgError.Align := alNone;
    imgError.Visible := False;
    SetStatusBarError('');
    tmErrorEvent.Enabled := False;
  End; {begin}

  tmEventLog.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: ViewLocationClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.mnuViewLocationClick(Sender: TObject);
Begin
  Try
    If advGridLog.Columns[3].Width = 0 Then
      advGridLog.Columns[3].Width := 200
    Else
      advGridLog.Columns[3].Width := 0;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: actBulkExportExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actBulkExportExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lP1, lP2: wideString;
  lModal: TModalResult;
  lStatus: Longword;
Begin
    {get the company details taking the company info out of the selected node}
  If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
  Begin
    If tvComp.Selected.Data <> Nil Then
      If TObject(tvComp.Selected.Data) Is TCompany Then
        lMsg := fDb.GetTopOutboxMessage(TCompany(tvComp.Selected.Data).Id);

      {check if this company is doing a bulk export}
    If Not CheckCompanyinProcess(TCompany(tvComp.Selected.Data).Id) Then
    Begin
      lStatus := S_False;
        {load drip feed parameters}
      With TDSR Do
        DSR_CheckDripFeed(_DashboardGetDSRServer, _DashboardGetDSRPort,
          TCompany(tvComp.Selected.Data).Id, lStatus);

      If lStatus = S_False Then
      Begin
        If
          ShowDashboardDialog('Before starting a Bulk Export, please ensure there are no users accessing IRIS Accounts Office.'
          + #13 + #10 + 'Do you want to continue?', mtConfirmation, [mbYes, mbNo]) =
          mrYes Then
        Begin
          Application.CreateForm(TfrmBulkExport, frmBulkExport);

          With frmBulkExport, frmBulkExport.frmExportFrame Do
          Begin
        {get the default e-mail receiver if there is one}
            Try
              advTo.Text :=
                fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
            Except
            End;

            If (lMsg <> Nil) And (advTo.Text = '') Then
              advTo.Text := lMsg.To_;

        {fill details with the previus acceptance sync}
            MailInfo.Assign(lMsg);

        {get the drip feed period and year}
            //GetExPeriodYear(TCompany(tvComp.Selected.Data).Id, lp1, lp2);

            TDSR.DSR_GetDripFeedParams(_DashboardGetDSRServer,
              _DashboardGetDSRPort, TCompany(tvComp.Selected.Data).Id, lp1, lp2);

            If lp1 = '' Then
              lP1 := ifthen(MailInfo <> Nil, MailInfo.Param1, '01' +
                IntToStr(YearOf(Date)));

            If lP2 = '' Then
              lP2 := IfThen(MailInfo <> Nil, MailInfo.Param2, '01' +
                IntToStr(YearOf(IncYear(Date, 1))));

            SelectCompany(TCompany(tvComp.Selected.Data).ExCode);

          {set the export params with a subject identifier}
            SetExportDetails(MailInfo, '', lP1, lP2);
            ParamYear1 := lP1;
            ParamYear2 := lp2;

            //advSubject.Text := 'Bulk Export from ' + _DashboardGetCompanyName +
            advSubject.Text := 'Bulk Export from ' +
              fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' +
              TCompany(tvComp.Selected.Data).Desc + ']' + ' for ' + _GetPeriod(lP1)
                + '/' + _GetYear(lP1) + ' to ' + _GetPeriod(lP2) + '/' + _GetYear(lP2);

            cbJobs.Enabled := False;

            lModal := ShowModal;
            FreeAndNil(frmBulkExport);
          End; {With frmBulkExport, frmBulkExport.frmExportFrame Do}

          If lModal = mrOK Then
            LoadCompanies;
        End;
      End
      Else
        ShowDashboardDialog('The company "' +
          _ChangeAmpersand(TCompany(tvComp.Selected.Data).Desc) +
          //'" is already in Dripfeed mode.', mtInformation, [mbok]);
          '" is already in Linked Mode.', mtInformation, [mbok]);
    End
    Else
      ShowDashboardDialog('The company "' +
        _ChangeAmpersand(TCompany(tvComp.Selected.Data).Desc) +
        '" is already doing a Bulk Export...', mtInformation, [mbok]);

    Application.ProcessMessages;
    CheckCompanyActions;
  End; {If lNode <> Nil Then}

  If Assigned(lMsg) Then
    FreeAndNil(lMsg);
End;

{-----------------------------------------------------------------------------
  Procedure: advNavPanelActivate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.advNavPanelActivate(Sender: TObject;
  OldActivePanel, NewActivePanel: Integer; Var Allow: Boolean);
Begin
  {archive or history tab}
  If NewActivePanel In [0, 1] Then
  Begin
    SetFrameFocus(False);
    {disable actions}
    ChangeActionStatus('New', False);
    CheckCompanyActions;

      {check the current panel}
    Case NewActivePanel Of
      0:
        If tvArchive.Items.Count = 0 Then
        Begin
          ShowDashboardDialog('There are no items to show in this view.',
            mtInformation, [mbok]);

          Abort;
        End
        Else
        Begin
          If tvArchive.CanFocus Then
            tvArchive.SetFocus;

          SelectFirstNode(tvArchive);
          tvCompClick(tvArchive);
        End;
      1:
        If tvHistory.Items.Count = 0 Then
        Begin
          ShowDashboardDialog('There are no items to show in this view.',
            mtInformation, [mbok]);

          Abort;
        End
        Else
        Begin
          lbCompStatus.Clear;

          If tvHistory.CanFocus Then
            tvHistory.SetFocus;

          SelectFirstNode(tvHistory);
          tvCompClick(tvHistory);
        End;
    End; {Case NewActivePanel Of}
  End
  Else
  Begin
    {enable actions}
    lbCompStatus.Items.Clear;
    If tpCompany.Locked Then
      tpCompany.Locked := False;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: actRebuildExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actRecreateExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: TMailBoxCompany;
Begin
  If actRecreate.Visible And actRecreate.Enabled Then
    If advNav.ActivePanel = advNavHistory Then
    Begin
      If tvHistory.Selected <> Nil Then
        If tvHistory.Selected.Data <> Nil Then
        Begin
    {get the selected company information }
          lNode := tvHistory.Selected;
          lComp := TMailBoxCompany(lNode.Data);

          If lComp <> Nil Then
            If ShowDashboardDialog('Are you sure you want to recreate the company "'
              + _ChangeAmpersand(lComp.Desc) + '"?' + #10 + #13 +
              'Note: This company will be in the history tab until the end of the process.'
              , mtConfirmation, [mbYes, mbNo]) = mrYes Then
            Begin
              TDSR.DSR_ReCreateCompany(
                _DashboardGetDSRServer,
                _DashboardGetDSRPort,
                lComp.Id);
            End; {messagedlg}
        End; {If tvComp.Selected.Data <> Nil Then}
    End; {If advNav.ActivePanel = advNavHistory Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actCloseExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actCloseExecute(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckDSRStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.CheckDSRStatus;
Var
  lRes: Integer;
  lAlive: TDSRAlive;
  lTick: Longint;
Begin
//  tmCheckDSR.Enabled := False;

  {check for clogin windows...}
  If Not fClosing Then
  Begin
    _CallDebugLog('Checking Service status...');

    lRes := S_FALSE;
    HideMenus;

    {avoid infinte loop}
    lTick := GetTickCount + cDSRCHECKTIMER;

    Try
      lAlive:= TDSRAlive.Create(False);

      Try
        //lRes := TDSR.DSR_Alive(_DashboardGetDSRServer, _DashboardGetDSRPort);
        while (lTick > GetTickCount) and not lAlive.Terminated do
        begin
          Application.ProcessMessages;
          lRes := lAlive.ReturnValue;
          if lRes = S_OK then
            Break;
        end; {while (lTick > GetTickCount) and not lAlive.Terminated do}
      Except
        On E: exception Do
        Begin
          _LogMSG('CheckDSRStatus :- Error checking Service Status. Error: ' +
            e.Message);

          If Assigned(fDb) And fDb.Connected Then
            fDb.UpdateIceLog('TfrmDashboard.CheckDSRStatus',
              'Error checking Service Status. Error: ' + e.Message);
        End;
      End; {try}
    Finally
      lAlive.Free;
      
      glDSROnline := lRes = S_OK;

      If glDSROnline Then
      Begin
        sbDash.Panels[4].Text := '<P align="center"><b>Service Online</b></P>';
        fDb.UpdateIceLog('TfrmDashboard.CheckDSRStatus', 'The Service is Online');
      End
      Else
        sbDash.Panels[4].Text :=
          '<P align="center"><font color="clRed"><b>Service Offline</b></font></P>';

    {check all the action list details}
      //If Not glDSROnline Then
      ChangeActionStatus('all', glDSROnline);

      //CheckCompanyActions;

    {just two options availabe}
      actClose.Enabled := True;
      actCheckDSRStatus.Enabled := True;

      actStartDSRService.Enabled := Not glDSROnline;
      actStopDSRService.Enabled := glDSROnline;

      actLogView.Enabled := True;
      actAbout.Enabled := True;
      actRefreshCompany.Enabled := glDSROnline;
      ActConfiguration.Enabled := True;
      actReminder.Enabled := glDSROnline;
      actCheckMailNow.Enabled := glDSROnline;
      btnNew.Enabled := glDSROnline;
      actClearEventLog.Enabled := glDSROnline;

      If Not glDSROnline Then
      Begin
        lbCompStatus.Clear;
        lbCompStatus.Items.Add('-Company info not available-');
      End {if not glDSROnline then}
      Else If Not tmUpdateCompanyInfo.Enabled Then
        tmUpdateCompanyInfo.Enabled := True;
    End; {try}

(*  {check if iaoo, cis is running and change the visibility of some functions}
    glIsVAO := False;
    glISCIS := False;
//    If glDSROnline Then
//    Begin
    glIsVAO := StrToIntDef(fDb.GetSystemValue(cISVAOPARAM), 0) = 1;
{      lRes := StrToIntDef(fDb.GetSystemValue(cISVAOPARAM), -1);

      if lRes = -1 then
      begin
       lRes := TDSR.DSR_IsVAO(_DashboardGetDSRServer, _DashboardGetDSRPort);
        If lRes <> GENERIC_FAIL Then
          glIsVAO := Boolean(lRes);
      end
      else
        glIsVAO := lRes = 1;}

    glIsCIS := StrToIntDef(fDb.GetSystemValue(cISCISPARAM), 0) = 1;
//    End; {If glDSROnline Then}

    SetIsCIS(glIsCIS);*)

    LoadExchequerVersion;
    CheckCompanyActions;
  End; {if not fclosing}

//  tmCheckDSR.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: actEndofSyncExecute
  Author:    vmoura

  remove dripfeed mode from a specific company
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actEndLinkExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: Integer;
  lName: String;
  lRes,
    lStatus: Longword;
  lp1, lp2: WideString;
  lModal: TModalResult;
  lMsg: TMessageInfo;
  lGuid: TGuid;
Begin
  If Assigned(fDb) Then
  Begin
    Application.ProcessMessages;
    lNode := tvComp.Selected;

    If lNode <> Nil Then
    Begin
      lComp := 0;
      If lNode.Data <> Nil Then
      {get the company name and code}
        If TObject(lNode.Data) Is TCompany Then
        Begin
          lComp := TCompany(lNode.Data).Id;
          lName := TCompany(lNode.Data).Desc;
        End;

      If lComp > 0 Then
      Begin
        {check if this company is in drip feed mode}
        lRes := TDSR.DSR_CheckDripFeed(_DashboardGetDSRServer,
          _DashboardGetDSRPort, lComp, lStatus);

        {check results}
        If (lRes = S_Ok) And (lStatus = S_OK) Then
        Begin
          If ShowDashboardDialog('The company "' + _ChangeAmpersand(lName) +
            //'" is going to be removed from Dripfeed mode. Do you want to continue?',
            '" is going to be removed from Linked Mode. Do you want to continue?',
            mtConfirmation, [mbYes, mbNo]) = Mryes Then
          Begin
            Application.CreateForm(TfrmEndofSyncRequest, frmEndofSyncRequest);
            With frmEndofSyncRequest, frmEndofSyncRequest.frmExportFrame Do
            Begin
              CancelDripfeed := False;
              {get the default e-mail receiver if there is one}
              Try
                advTo.Text :=
                  fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
              Except
              End;

              If advTo.Text = '' Then
              Begin
                {get the top message}
                If glProduct = ptLITEAcct Then
                  lMsg := fDb.GetTopInboxMessage(lComp)
                Else
                  lMsg := fDb.GetTopOutboxMessage(lComp);

                If Assigned(lMsg) Then
                Begin
                  If glProduct = ptLITEAcct Then
                    advTo.Text := lMsg.From
                  Else
                    advTo.Text := lMsg.To_;
                  FreeAndNil(lMsg);
                End; {If Assigned(lMsg) Then}
              End; {If advTo.Text = '' Then}

              SelectCompany(TCompany(tvComp.Selected.Data).ExCode);
              {set the export params with a subject identifier}
              SetExportDetails(Nil, '', lP1, lP2);

              If fDb.IsEndOfSyncRequested(lComp) Then
                //advSubject.Text := 'End of Dripfeed confirmation from ' + _DashboardGetCompanyName + ' [' + TCompany(lNode.Data).Desc + ']'
                //advSubject.Text := 'End of Dripfeed confirmation from ' +
                advSubject.Text := 'End of Link confirmation from ' +
                  fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' +
                  TCompany(lNode.Data).Desc + ']'
              Else
                //advSubject.Text := 'End of Dripfeed from ' + _DashboardGetCompanyName + ' [' + TCompany(lNode.Data).Desc + ']';
                //advSubject.Text := 'End of Dripfeed from ' +
                advSubject.Text := 'End of Link from ' +
                  fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' +
                  TCompany(lNode.Data).Desc + ']';

              SelectDripFeed;
              cbJobs.Enabled := False;

              lModal := ShowModal;
            End; {With frmEndofSyncRequest, frmEndofSyncRequest.frmExportFrame Do}

            If Assigned(frmEndofSyncRequest) Then
              FreeAndNil(frmEndofSyncRequest);

            If lModal = mrOK Then
              LoadCompanies;
          End; {if messagedlg}
        End
        Else
        Begin
          {an end of drip feed was request while the company was trying to import a bulk data...}
          If
            ShowDashboardDialog('The Bulk Export cannot proceed because either the company "'
            + _ChangeAmpersand(lName) +
            //'" is not in Dripfeed mode, or an End of Dripfeed has been requested.' + #13
            '" is not in Linked Mode, or an End of Link has been requested.' + #13
            + #10 + 'Would you like to archive the company data?',
            mtConfirmation, [mbYes, mbNo]) = mrYes Then
          Begin
            FillChar(lGuid, SizeOf(TGuid), 0);

            {set inbox as archived}
            fDb.SetAllInboxMessagesStatus(lComp, cARCHIVED);
            {remove schedule syncs}
            fDb.RemoveAllOutboxSchedule(lComp);

            Application.ProcessMessages;

            {set outbox as archive}
            fDb.SetAllOutboxMessagesStatus(lComp, cARCHIVED);
            {remove the guid from the company previuos created if this is a practice version}
            If glProduct = ptLITEAcct Then
              fDb.SetCompanyGuid(lComp, lGuid);

            Application.ProcessMessages;
            LoadCompanies;
          End; {messagedlg}
        End {else begin}
      End; {if lcomp > 0}
    End; {If lNode <> Nil Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actCheckMailNowExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actCheckMailNowExecute(Sender: TObject);
Begin
  Try
    tmCheckEmail.Enabled := False;

    Try
      If glDSROnline Then
        TDSR.DSR_CheckMailNow(_DashboardGetDSRServer, _DashboardGetDSRPort);
    Except
      CheckDSRStatus;
    End;
  Finally
    {update company information}
    If glDSROnline Then
      LoadCompanies;

    tmCheckEmail.Enabled := True;
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: actCheckDSRStatusExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actCheckDSRStatusExecute(Sender: TObject);
Begin
  If Not fClosing Then
  begin
    frmWait.Start('Checking Service status...');
    Application.ProcessMessages;
    CheckDSRStatus;
    frmWait.Stop;
  end; {If Not fClosing Then}
End;

{-----------------------------------------------------------------------------
  Procedure: HideMenus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.HideMenus;
Begin
  PostMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, 0);
  PostMessage(Handle, WM_LBUTTONUP, MK_LBUTTON, 0);
End;

{-----------------------------------------------------------------------------
  Procedure: actStartDSRServiceExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actStartDSRServiceExecute(Sender: TObject);
Begin
  _LogMSG('User "' + glUserLogin + '" has requested to start the Service.');

  frmWait.Start('Starting service...');
  Application.ProcessMessages;

  {stop (in case it is paused) and start the service}
  _ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, False, True);
  _ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, True);

  Application.ProcessMessages;

  CheckDSRStatus;

  frmWait.Stop;
End;

{-----------------------------------------------------------------------------
  Procedure: actStopDSRServiceExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actStopDSRServiceExecute(Sender: TObject);
Begin
  _LogMSG('User "' + glUserLogin + '" has requested to stop the Service.');

  frmWait.Start('Stopping service...');
  Application.ProcessMessages;
  _Delay(100);

  _ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, False, True);

  Application.ProcessMessages;

  CheckDSRStatus;

  frmWait.Stop;
End;

{-----------------------------------------------------------------------------
  Procedure: tmStartTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tmStartTimer(Sender: TObject);
Begin
  tmStart.Enabled := False;
//  LockControl(sbMail, True);
  Init;
//  LockControl(sbMail, False);

  //tvBoxClick(Sender);
  Application.ProcessMessages;

  Try
    tvComp.FullExpand;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: actAboutExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actAboutExecute(Sender: TObject);
Begin
  Application.CreateForm(TFrmAbout, frmAbout);
  With frmAbout Do
  Begin
    ShowModal;
    Free;
  End; {With frmAbout Do}
End;

{-----------------------------------------------------------------------------
  Procedure: actUpdateManagerPasswordExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actUpdateManagerPasswordExecute(Sender: TObject);
Begin
  If actUpdateManagerPassword.Enabled And actUpdateManagerPassword.Visible Then
  Begin
    Application.CreateForm(TfrmUpdateManagerPwd, frmUpdateManagerPwd);

    With frmUpdateManagerPwd Do
    Begin
      Caption := 'Update Manager Password';
      ShowModal;
      Free;
    End; {With frmUpdateManagerPwd Do}
  End; {if actUpdateManagerPassword.Enabled and actUpdateManagerPassword.Visible then}
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateCompanyInboxNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.UpdateCompanyInboxNode(pCompany: Integer; Const pText:
  String);
Var
  lCont: Integer;
Begin
  With tvComp Do
    For lCont := 0 To Items.count - 1 Do
      If Items[lCont].Data <> Nil Then
        If TObject(Items[lCont].Data) Is TMailBoxCompany Then
          If TMailBoxCompany(Items[lCont].Data).Id = pCompany Then
            If TMailBoxCompany(Items[lCont].Data).MailBoxType = btInbox Then
            Begin
              Items[lCont].Text := pText;
              Break;
            End; {If TMailBoxCompany(Items[lCont].Data).MailBoxType = btInbox Then}
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateInboxNode
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.UpdateInboxNode(pCompany: Integer; Const pText: String);
Var
  lNode: TTreeNode;
Begin
  lNode := GetInboxNode;
  If lNode <> Nil Then
    lNode.Text := pText;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateAfterLoad
  Author:    vmoura
-----------------------------------------------------------------------------}
//Procedure TfrmDashboard.UpdateInboxAfterLoad(Sender: TObject; pResult: Longword);
Procedure TfrmDashboard.UpdateAfterLoad(Sender: TObject; pResult: Longword);
Begin
(*  If pResult = cDBNORECORDFOUND Then
    If Assigned(fInboxFrame) Then
      fInboxFrame.ClearItems;*)

  If Sender <> Nil Then
    If TfrmMailBoxBaseFrame(Sender).HasFocus Then
    Begin
      If pResult = cDBNORECORDFOUND Then
        TfrmMailBoxBaseFrame(Sender).ClearItems
      Else
        SetStatusBarItemCount(TfrmMailBoxBaseFrame(Sender).Count);
    End; {If TfrmMailBoxBaseFrame(Sender).HasFocus Then}
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateOutboxAfterLoad
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Procedure TfrmDashboard.UpdateOutboxAfterLoad(Sender: TObject; pResult: Longword);
Begin
//  If pResult = cDBNORECORDFOUND Then
//    If Assigned(fOutboxFrame) Then
//      fOutboxFrame.ClearItems;

  If Sender <> Nil Then
    If TfrmMailBoxBaseFrame(Sender).HasFocus Then
    Begin
      If pResult = cDBNORECORDFOUND Then
        TfrmMailBoxBaseFrame(Sender).ClearItems
      Else
        SetStatusBarItemCount(TfrmMailBoxBaseFrame(Sender).Count);
    End; {If TfrmMailBoxBaseFrame(Sender).HasFocus Then}
End;*)

{-----------------------------------------------------------------------------
  Procedure: UpdateCompany
  Author:    vmoura

  create a thread to keep checking the database until the new company is created
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.UpdateCompany;
Begin
  fCheckComp := TDASHCheckComp.Create;
  fCheckComp.Resume;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateAfterCallDSR
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.UpdateAfterCallDSR(pResult: Longword);
Begin
  If pResult = cERROR Then
    CheckDSRStatus;
End;

{-----------------------------------------------------------------------------
  Procedure: AfterUpdateMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.AfterUpdateMessage(Sender: Tobject; pMsg: TMessageInfo);
Begin
  If (pMsg <> Nil) And (Sender <> Nil) Then
  Try
    If pMsg.Status = cSYNCACCEPTED Then
      _CompanyCreateBulk(fDb.GetCompanyGuid(pMsg.Company_Id))
    Else If pMsg.Status In [cSYNCFAILED, cSYNCDENIED] Then
      _CompanyDeleteBulk(fDb.GetCompanyGuid(pMsg.Company_Id));
  Except
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: NewMessageArrived
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.NewMessageArrived(Sender: TObject; Const pText: String);
Var
  lCont: integer;
  lAdded: Boolean;
Begin
  //If _DashboardGetShowAlert Then
  if fDb.GetSystemValue(cSHOWALERTPARAM) = '1' then
    With advAlert Do
    Begin
      If Not IsVisible Then
        AlertMessages.Clear;

      {check for an added string and avoid adding a second time}
      lAdded := False;

      For lCont := 0 To AlertMessages.Count - 1 Do
      Begin
        lAdded := AnsiCompareText(Trim(AlertMessages[lCont].Text.Text), Trim(pText))
          = 0;
        If lAdded Then
          Break;
      End; {for lCont:= 0 to AlertMessages.Count - 1 do}

      If Not lAdded Then
        With AlertMessages.Add Do
          Text.Text := pText;

      If Not IsVisible Or advAlert.IsFading Then
        Show;
    End; {if _DashboardGetShowAlert then}
End;

{-----------------------------------------------------------------------------
  Procedure: HideFrames
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.HideFrames;
Var
  lCont: Integer;
Begin
  For lCont := 0 To sbMail.ControlCount - 1 Do
    If sbMail.Controls[lCont] <> Nil Then
      If TObject(sbMail.Controls[lCont]) Is TfrmMailBoxBaseFrame Then
        TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).Visible := False;
  lblNoItem.Visible := True;
End;

{-----------------------------------------------------------------------------
  Procedure: StopFramesTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.FramesTimer(Const pActive: Boolean);
Var
  lCont: Integer;
Begin
  For lCont := 0 To sbMail.ControlCount - 1 Do
    If sbMail.Controls[lCont] <> Nil Then
      If TObject(sbMail.Controls[lCont]) Is TfrmMailBoxBaseFrame Then
        TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).TimerActive := pActive;
End;

{-----------------------------------------------------------------------------
  Procedure: SetFrameFocus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SetFrameFocus(pFocus: Boolean);
Var
  lCont: Integer;
Begin
  For lCont := 0 To sbMail.ControlCount - 1 Do
    If sbMail.Controls[lCont] <> Nil Then
      If TObject(sbMail.Controls[lCont]) Is TfrmMailBoxBaseFrame Then
        TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).HasFocus := pFocus;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.CheckCompanies(pFromMenu: Boolean);
Begin
  {refresh new companies added or updated}
  If pFromMenu Then
    TDSR.DSR_CheckCompanies(_DashboardGetDSRServer, _DashboardGetDSRPort);

  LoadCompanies;
End;

{-----------------------------------------------------------------------------
  Procedure: tvBoxDragDrop
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var
  lNode: TTreeNode;
  lFrame: TfrmMailBoxBaseFrame;
Begin
  If Source Is TOutlookGroupedList Then
  Begin
    lNode := tvBox.GetNodeAt(X, Y);
    If lNode <> Nil Then
      If lowercase(Trim(lNode.Text)) = lowercase(cDashRecycle) Then
      Begin
        lFrame := GetSelectedFrame;

        {test frame and company to avoid moving messages from inbox without a company}
        If lFrame <> Nil Then
          If lFrame.Company > 0 Then
            If
              ShowDashboardDialog('Are you sure you want to delete the selected item(s)?',
              mtConfirmation, [mbYes, mbNo]) = mrYes Then
              lFrame.DeleteSelectedMessages;
      End; {If lowercase(Trim(lNode.Text)) = lowercase(cDashRecycle) Then}
  End; {if Source = TAdvOutlookList then}
End;

{-----------------------------------------------------------------------------
  Procedure: tvBoxDragOver
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; Var Accept: Boolean);
Var
  lNode: TTreeNode;
Begin
  Accept := False;
  If Source Is TOutlookGroupedList Then
  Begin
    lNode := tvBox.GetNodeAt(X, Y);
    If lNode <> Nil Then
      If lowercase(Trim(lNode.Text)) = lowercase(cDashRecycle) Then
        Accept := True;
  End; {if Source = TAdvOutlookList then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetSelectedFrame
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.GetSelectedFrame: TfrmMailBoxBaseFrame;
Var
  lCont: Integer;
Begin
  Result := Nil;

  For lCont := 0 To sbMail.ControlCount - 1 Do
    If sbMail.Controls[lCont] <> Nil Then
      If TObject(sbMail.Controls[lCont]) Is TfrmMailBoxBaseFrame Then
        If TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).Visible Then
          If TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).HasFocus Then
          Begin
            Result := TfrmMailBoxBaseFrame(sbMail.Controls[lCont]);
            Break;
          End; {If TfrmMailBoxBaseFrame(sbMail.Controls[lCont]).HasFocus Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeActionStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ChangeActionStatus(Const pCategory: String; Const
  pValue: Boolean);
Var
  lCont: Integer;
Begin
  For lCont := 0 To alDashboard.ActionCount - 1 Do
  Begin
    If lowercase(pCategory) = 'all' Then
      TAction(alDashboard.Actions[lCont]).Enabled := pValue
    Else If Lowercase(TAction(alDashboard.Actions[lCont]).Category) =
      Lowercase(pCategory) Then
      TAction(alDashboard.Actions[lCont]).Enabled := pValue;
  End; {For lCont := 0 To alDashboard.ActionCount - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: GetDripFeedParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.GetExPeriodYear(pCompany: Longword; Out pParam1,
  pParam2: WideString);
Var
  lp1, lP2: WideString;
Begin
  Try
    //TDSR.DSR_GetDripFeedParams(_DashboardGetDSRServer,
    TDSR.DSR_GetExPeriodYear(_DashboardGetDSRServer,
      _DashboardGetDSRPort,
      pCompany,
      lP1,
      lP2
      );
  Finally
    pParam1 := lp1;
    pParam2 := lP2;
  End;

  If pParam1 = '001900' Then
    pParam1 := '';

  If pParam2 = '001900' Then
    pParam2 := '';
End;

{-----------------------------------------------------------------------------
  Procedure: appEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.appEventsException(Sender: TObject; E: Exception);
Begin
  if frmWait <> nil then
    frmWait.Stop;

  If Not fClosing Then
  Begin
  {treating tdsrserror }
    If E.ClassType = TDSRError Then
    Begin
      _LogMSG('appEventsException :- A Service exception has occurred. Error: ' +
        E.Message);
      Application.ProcessMessages;
      CheckDSRStatus;
    End
    Else
      _LogMSG('appEventsException :- An exception has occurred. Error: ' +
        E.Message);
  End {if not fClosing then}
  Else
    Application.Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: actDeactivateCompExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actDeactivateCompExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: Integer;
  lName: String;
Begin
  If Assigned(fDb) Then
  Begin
    Application.ProcessMessages;
    lNode := tvComp.Selected;

    If lNode <> Nil Then
    Begin
      lComp := 0;
      If lNode.Data <> Nil Then
      {get the company name and code}
        If TObject(lNode.Data) Is TCompany Then
        Begin
          lComp := TCompany(lNode.Data).Id;
          lName := TCompany(lNode.Data).Desc;
        End;

      If lComp > 0 Then
      Begin
        If ShowDashboardDialog('The company "' + _ChangeAmpersand(lName) +
          '" is going to be deactivated from the Dashboard. Do you want to continue?',
          mtConfirmation, [mbYes, mbNo]) = Mryes Then
        Begin
          udsr.TDSR.DSR_DeactivateCompany(_DashboardGetDSRServer,
            _DashboardGetDSRPort, lComp);

          LoadCompanies;

          If tvComp.Items.Count = 0 Then
          Begin
            lbCompStatus.Clear;
            If tpCompany.Locked Then
              tpCompany.Locked := False;

            If tvBox.CanFocus Then
              tvBox.SetFocus;
            tvBoxClick(Self);
          End; {if tvComp.Items.Count = 0 then}
        End; {if messagedlg}
      End; {if lcomp > 0}
    End; {If lNode <> Nil Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actDeleteCompanyExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actDeleteCompanyExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: TMailBoxCompany;
Begin
  If Assigned(fDb) Then
    If advNav.ActivePanel = advNavHistory Then
    Begin
      If tvHistory.Selected <> Nil Then
        If tvHistory.Selected.Data <> Nil Then
        Begin
          lNode := tvHistory.Selected;
          {get the selected company information }
          If lowercase(TObject(lNode.Data).ClassName) <>
            Lowercase(TCompany.ClassName) Then
            lNode := lNode.Parent;

          If lNode.Data <> Nil Then
          Begin
            lComp := TMailBoxCompany(lNode.Data);

            If lComp <> Nil Then
              If ShowDashboardDialog('Are you sure you want to delete the company "'
                +  _ChangeAmpersand(lComp.Desc) + '" and all its data?'
                , mtConfirmation, [mbYes, mbNo]) = mrYes Then
              Begin
                udsr.TDSR.DSR_DeleteCompany(_DashboardGetDSRServer,
                  _DashboardGetDSRPort, lComp.Id);

                _CompanyDeleteBulk(lComp.Guid);

              {remove inbox/outbox tables if this exists}
                RemoveChild(lNode);
              {remove the mais node}
                DeleteNode(lNode);

                LoadCompanies;
                If tvHistory.Items.Count = 0 Then
                Try
                  advNav.ActivePanel := AdvNavLink;
                Except
                End
                Else
                Begin
                  SelectFirstNode(tvHistory);
                  tvCompClick(tvHistory);
                End;
              End; {messagedlg}
          End; {if lNode.Data <> nil then}
        End; {If tvComp.Selected.Data <> Nil Then}

      Application.ProcessMessages;
    End; {If advNav.ActivePanel = advNavHistory Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actActivateCompanyExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actActivateCompanyExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: Integer;
  lName, lCode: String;
  lRes: Cardinal;
Begin
  If Assigned(fDb) Then
  Begin
//    Application.ProcessMessages;
    lNode := tvHistory.Selected;

    If lNode <> Nil Then
    Begin
      lComp := 0;
      If lNode.Data <> Nil Then
      {get the company name and code}
        If TObject(lNode.Data) Is TCompany Then
        Begin
          lComp := TCompany(lNode.Data).Id;
          lName := TCompany(lNode.Data).Desc;
          lCode := TCompany(lNode.Data).ExCode;
        End; {If TObject(lNode.Data) Is TCompany Then}

      If lComp > 0 Then
      Begin
        If ShowDashboardDialog('The company "' + _ChangeAmpersand(lName) +
          '" is going to be activated. Do you want to continue?',
          mtConfirmation, [mbYes, mbNo]) = Mryes Then
        Begin
          lRes := udsr.TDSR.DSR_activateCompany(_DashboardGetDSRServer,
            _DashboardGetDSRPort, lComp);

          If lRes = 0 Then
          Begin
            If tvHistory.Items.Count = 0 Then
            Try
              advNav.ActivePanel := AdvNavLink;
            Except
            End;

            LoadCompanies
          End
          Else If lRes = cEXCHINVALIDCOMPCODE Then
          Begin
            ShowDashboardDialog('The company "' + _ChangeAmpersand(lName) + ' (' +
              lCode + ')'
              + '" could not be activated. This company does not exist on Iris Account Office Multi-Company Manager.',
              mtInformation, [mbOK])
          End
          Else
            ShowDashboardDialog('The company "' + _ChangeAmpersand(lName) + ' (' +
              lCode + ')'
              + '" could not be activated. Please check the log for more information.',
              mtInformation, [mbOK]);

          If tvHistory.Items.Count = 0 Then
          Begin
            Try
              advNav.ActivePanel := AdvNavLink;
            Except
            End;
          End {If tvHistory.Items.Count = 0 Then}
          Else
          Begin
            SelectFirstNode(tvHistory);
            tvCompClick(tvHistory);
          End; {begin}

          Application.ProcessMessages;
        End; {if messagedlg}
      End; {if lcomp > 0}
    End; {If lNode <> Nil Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actLogViewExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actLogViewExecute(Sender: TObject);
Begin
  mnuEventLog.Checked := Not mnuEventLog.Checked;

  LockControl(advPanelBackgroud, True);

  If mnuEventLog.Checked Then
  Begin
    advEventLog.Height := 115;
    tmEventLog.Enabled := True;
  End
  Else
    advEventLog.Height := 0;

  LockControl(advPanelBackgroud, False);
  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadAddOn
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.LoadAddOn;
Var
  lAddOnMenu: TMenuItem;
Begin
  If glDSROnline Then
  Begin
    lAddOnMenu := TMenuItem.Create(Nil);
    lAddOnMenu.Caption := cADDONDESC;
    lAddOnMenu.OnClick := OnExecuteAddon;
    ppmNew.Items.Insert(3, lAddOnMenu);
  End; {If glDSROnline Then}
End;

{-----------------------------------------------------------------------------
  Procedure: OnExecuteAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.OnExecuteAddon(Sender: TObject);
Begin
  If Assigned(fDb) Then
  Begin
    {check the node data}
    If (tvComp.Selected <> Nil) Then
      If tvComp.Selected.Data <> Nil Then
        If TObject(tvComp.Selected.Data) Is TCompany Then
        Begin
          {call export}
          Application.CreateForm(TfrmAddonExport, frmAddonExport);

          With frmAddonExport, frmAddonExport.frmExportFrame Do
          Begin
            HidePeriods;
            advSubject.Enabled := True;
            SelectCompany(TCompany(tvComp.Selected.Data).ExCode);
            ShowModal;
          End; {With frmExportTask, frmExportTask.frmExportFrame Do}

          FreeAndNil(frmAddonExport);
          Application.ProcessMessages;
        End; {If TObject(tvComp.Selected.Data) Is TCompany Then}

    Application.ProcessMessages;
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: RemoveAddon
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.RemoveAddon;
Var
  lMenuItem: TMenuItem;
Begin
  If ppmNew.Items.Count > 0 Then
  Begin
    lMenuItem := ppmNew.Items.Find(cADDONDESC);
    If Assigned(lMenuItem) Then
    Begin
      lMenuItem.Clear;
      lMenuItem.Free;
    End; {if Assigned(lMenuItem) then}
  End; {if ppmNew.Items.Count > 0 then}
End;

{-----------------------------------------------------------------------------
  Procedure: SetIsCIS
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SetIsCIS(Const Value: Boolean);
var
  lTabChange: TNotifyEvent;
  lTabActive: TOnPanelActivate;
Begin
  If Value Then
  Begin
    AdvNavLink.Caption := 'C&IS';
    actCheckMailNow.Caption := 'Check Gateway';
  End
  Else
  Begin
    //AdvNavLink.Caption := 'Dri&pfeed';
    AdvNavLink.Caption := 'Linked Com&panies';
    actCheckMailNow.Caption := 'Check Mail';
  End; {else begin}

  if Value then
    glProductNameIndex := cCISNAME
  else
    glProductNameIndex := cCLIENTLINKNAME;

  {remove the onchange and onpanelactive events to avoid the changing when setting the value to true}
  lTabChange := advNav.OnChange;
  advNav.OnChange := nil;

  lTabActive := advNav.OnPanelActivate;
  advNav.OnPanelActivate := nil;

  if Value then
    advNavArchive.TabVisible := Not Value
  else
  begin
    {i need to change the tab visible to false and then to true to be able to display the right order of the tabs.}
    advNavArchive.TabVisible := False;
    AdvNavLink.TabVisible := False;
    advNavHistory.TabVisible := False;

    advNavArchive.TabVisible := True;
    advNavHistory.TabVisible := True;
    AdvNavLink.TabVisible := True;
  end; {else begin}

  advNav.OnChange := lTabChange;
  advNav.OnPanelActivate := lTabActive;

  actContacts.Visible := Not Value;
  actDeny.Visible := Not Value;
  actAccept.Visible := Not Value;
  actRemoveSchedule.Visible := Not Value;
  actAddSchedule.Visible := Not Value;
  actChangeSchedule.Visible := Not Value;
  actViewSchedule.Visible := Not Value;
  actRecycleRestore.Visible := Not Value;

  actSubContractorVerification.Visible := Value;

  {change more options }

  If Value Then
  Begin
    btnMore.Caption := 'O&ptions...';
    btnCompMore.Caption := 'O&ptions...';
    mnuFileMore.Caption := 'O&ptions...';
    mnuCompMore.Caption := 'O&ptions...';
  End
  Else
  Begin
    btnMore.Caption := '&More...';
    btnCompMore.Caption := '&More...';
    mnuFileMore.Caption := '&More...';
    mnuCompMore.Caption := '&More...';
  End;

End;

{-----------------------------------------------------------------------------
  Procedure: mniReadingPaneClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.mnuReadingPaneClick(Sender: TObject);
Var
  lFrame: TfrmMailBoxBaseFrame;
Begin
  lFrame := GetSelectedFrame;

  If lFrame = Nil Then
  Begin
    If (tvBox.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
      tvBoxClick(Nil)
    Else If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
      tvCompClick(tvComp)
    Else If (tvHistory.Selected <> Nil) And (advNav.ActivePanel = advNavHistory)
      Then
      tvCompClick(tvHistory)
    Else
      tvCompClick(tvArchive);

    lFrame := GetSelectedFrame;
  End; {If lFrame = Nil Then}

  If lFrame <> Nil Then
  Begin
    _DashboardSetReadPane(mnuReadingPane.checked);
    lFrame.PaneVisible := mnuReadingPane.checked;
  End {if lFrame <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormCloseQuery
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.FormCloseQuery(Sender: TObject;
  Var CanClose: Boolean);
Begin
  fClosing := True;
End;

{-----------------------------------------------------------------------------
  Procedure: btnSystemClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.btnSystemClick(Sender: TObject);
Var
  lPoint: TPoint;
Begin
  lPoint.X := btnSystem.Left;
  lPoint.Y := btnSystem.Top;
  lPoint := btnSystem.ClientToScreen(lPoint);
  ppmSystem.Popup(lPoint);
  //ppmSystem.PopupAtCursor;
End;

{-----------------------------------------------------------------------------
  Procedure: ppmSystemPopup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ppmSystemPopup(Sender: TObject);
Begin
  actUpdateManagerPassword.Enabled := glDSROnline And ((lowercase(glUserLogin) =
    cADMINUSER) Or ((lowercase(glUserLogin) = cSYSTEMUSER)));

{$IFDEF DEBUG}
  actNewCompany.Visible := glDSROnline;
{$ELSE}
  actNewCompany.Visible := False;
{$ENDIF}

  actNewCompany.Enabled := actNewCompany.Visible;
  N10.Visible := actNewCompany.Visible;
End;

{-----------------------------------------------------------------------------
  Procedure: btnNewClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.btnNewClick(Sender: TObject);
Var
  lPoint: TPoint;
Begin
  lPoint.X := btnNew.Left + btnNew.Width;
  lPoint.Y := btnNew.Top;
  lPoint := btnNew.ClientToScreen(lPoint);
  ppmNew.Popup(lPoint);
  //ppmNew.PopupAtCursor;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCompanyActions
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.CheckCompanyActions;
Var
  lNode: TTreeNode;
  lComp, lStatus: Longword;
  lEOSRequested, lProcessing: Boolean;
  lBulk: Boolean;
  lGuid, lNewGuid: String;
Begin
  {disable main actions}
  actUpdateLink.Enabled := False;
  actLinkRequest.Enabled := False;
  actBulkExport.Enabled := False;
  actEndLink.Enabled := False;
  actDeactivateComp.Enabled := False;
  actAddSchedule.Enabled := False;
  actCancelLink.Enabled := False;
  actRefreshCompany.Enabled := glDSROnline;
  actViewCISResponse.Enabled := glDSROnline;
  actSubContractorVerification.Enabled := False;

  {check options that must be visible or not depending which version is running}
  tpDashboard.Enabled := (tvComp.Selected <> Nil) And (advNav.ActivePanel =
    AdvNavLink);
  actLinkRequest.Visible := (glProduct = ptLITECust) And (advNav.ActivePanel =
    AdvNavlink) And Not glISCIS;
  actBulkExport.Visible := (glProduct = ptLITECust) And (advNav.ActivePanel =
    AdvNavLink) And Not glISCIS;
  actCancelLink.Visible := (glProduct = ptLITECust) And (advNav.ActivePanel =
    AdvNavLink) And Not glISCIS;

  lNode := tvComp.Selected;

  {avoid popping up when archive or history navbar is active }
  If Assigned(fDb) And glDSROnline And (advNav.ActivePanel = AdvNavLink) And Not glIsCIS Then
  Begin
    //lNode := tvComp.Selected;

    If lNode <> Nil Then
    Begin
      lComp := 0;
      lEOSRequested := False;
      lBulk := False;

      If lNode.Data <> Nil Then
        If TObject(lNode.Data) Is TCompany Then
        Begin
          lComp := TCompany(lNode.Data).Id;
          lEOSRequested := fDb.IsEndOfSyncRequested(lComp);
          {check company guid}
          lGuid := TCompany(lNode.Data).Guid;

          {check the guid of the company. Also, it is possible that the company
          has just been updated and the guid has changed to a new one. SO, update it}
          lNewGuid := fDb.GetCompanyGuid(lComp);
          If (lGuid = '') Or (TCompany(lNode.Data).Guid <> lNewGuid) Then
          Begin
            lGuid := lNewGuid;
            TCompany(lNode.Data).Guid := lNewGuid;
          End; {If (lGuid = '') or (TCompany(lNode.Data).Guid <> lNewGuid) Then}

          lBulk := (fDb.InboxMessageStatusExists(lcomp, cSYNCACCEPTED) Or
            _CompanyHasReqBulk(lGuid));
        End; {If TObject(lNode.Data) Is TCompany Then}

      {check Dripfeed}
      lStatus := S_False;
      With TDSR Do
        DSR_CheckDripFeed(_DashboardGetDSRServer, _DashboardGetDSRPort, lComp,
          lStatus);

      {check if this company is doing something}
      lProcessing := CheckCompanyinProcess(lComp);

      actLinkRequest.Enabled := (lStatus <> S_OK) And Not lBulk And Not lEOSRequested And (glProduct <> ptLITEAcct);

{$IFDEF debug}
      actBulkExport.Enabled := (lStatus <> S_OK);
{$ELSE}
      actBulkExport.Enabled := (lStatus <> S_OK) And (lBulk) And Not
        lEOSRequested And (glProduct <> ptLITEAcct);
{$ENDIF}

      actUpdateLink.Enabled := (lStatus = S_OK) And Not lEOSRequested;
      actEndLink.Enabled := ((lStatus = S_OK) And Not lProcessing) Or lEOSRequested;

      {check if cancel should be available }
      If actCancelLink.Visible Then
        actCancelLink.Enabled := actBulkExport.Enabled And (lStatus <> S_OK) And
          Not CheckCompanyinProcess(lComp);

      {delete the bulk req file}
      If (lStatus = S_OK) Or (actLinkRequest.Enabled And Not actBulkExport.Enabled) Then
        _CompanyDeleteBulk(lGuid);

      {i can only deactivate companies that are not in sync mode}
      //actDeactivateComp.Enabled := (lStatus <> S_OK) And Not lEOSRequested;
      actDeactivateComp.Enabled := Not actUpdateLink.Enabled And Not
        actBulkExport.Enabled And Not lEOSRequested;

      If glProduct = ptLITEAcct Then
        actDeactivateComp.Enabled := actDeactivateComp.Enabled And Not lProcessing;
//          (Not fDb.InboxMessageStatusExists(lComp, cLOADINGFILES)) And
//          (Not fDb.InboxMessageStatusExists(lComp, cPOPULATING));

{$IFDEF DEBUG}
      actAddSchedule.Enabled := True;
{$ELSE}
      actAddSchedule.Enabled := (lStatus = S_OK) And Not fDb.ScheduleExists(lComp)
        And Not lEOSRequested;
{$ENDIF}
    End; {If lNode <> Nil Then}
  End {If Assigned(fDb) And glDSROnline And (advNav.ActivePanel = AdvNavLink) And not glIsCIS then}
  Else If glISCIS and glDSROnline Then
  begin
    actDeactivateComp.Enabled := glDSROnline and (advNav.ActivePanel = AdvNavLink) and (lNode <> nil);
    actSubContractorVerification.Enabled := glDSROnline and (advNav.ActivePanel = AdvNavLink) and (lNode <> nil);
  end; {else begin}

  btnMore.Enabled := actCancelLink.Enabled Or actDeactivateComp.Enabled Or
    actRefreshCompany.Enabled;
  mnuFileMore.Enabled := btnMore.Enabled;
  mnuCompMore.Enabled := btnMore.Enabled;
  btnCompMore.Enabled := btnMore.Enabled;

  {check inbox/outbox/recycle menu states}
  mnuInboxClick(Nil);
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCompanyBulkinProcess
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDashboard.CheckCompanyinProcess(pCompany: Integer): Boolean;
Begin
  With fDb Do
    Result := OutboxMessageProcessing(pCompany) Or InboxMessageProcessing(pCompany);
{    OutboxMessageStatusExists(pCompany, cBULKPROCESSING)
      Or OutboxMessageStatusExists(pCompany, cLOADINGFILES) Or
      OutboxMessageStatusExists(pCompany, cCHECKING) Or
      OutboxMessageStatusExists(pCompany, cSENDING)};
End;

{-----------------------------------------------------------------------------
  Procedure: SetStatusBarError
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.SetStatusBarError(Const pValue: String);
Begin
  If pValue <> '' Then
    sbDash.Panels[6].Text := '<font color="clRed"><b>' + pValue + '</b></font>'
  Else
    sbDash.Panels[6].Text := '';
End;

{-----------------------------------------------------------------------------
  Procedure: tmErrorEventTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tmErrorEventTimer(Sender: TObject);
Begin
  tmErrorEvent.Enabled := False;
  {make this image "blink"}
  imgError.Top := 0;
  imgError.Left := advDockdashTop.Width - imgError.Width;
  imgError.Visible := Not imgError.Visible;
  tmErrorEvent.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: imgErrorDblClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.imgErrorDblClick(Sender: TObject);
Begin
  actLogViewExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: actAddScheduleExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actAddScheduleExecute(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lp1, lp2: wideString;
  lModal: TModalResult;
Begin
  If Assigned(fDb) Then
  Begin
    {check the node data}
    If (tvComp.Selected <> Nil) Then
      If tvComp.Selected.Data <> Nil Then
        If TObject(tvComp.Selected.Data) Is TCompany Then
        Begin
          {get the top message}
          If glProduct = ptLITEAcct Then
            lMsg := fDb.GetTopInboxMessage(TCompany(tvComp.Selected.Data).Id)
          Else
            lMsg := fDb.GetTopOutboxMessage(TCompany(tvComp.Selected.Data).Id);

          Application.CreateForm(TfrmDailyScheduleTask, frmDailyScheduleTask);

          {populate fields}
          With frmDailyScheduleTask, frmDailyScheduleTask.frmExportFrame Do
          Begin
            lblInfo.Caption := 'Dashboard Add New Scheduled Task';

              {get the Dripfeed period and year}
            GetExPeriodYear(TCompany(tvComp.Selected.Data).Id, lp1, lp2);

            {get the default e-mail receiver if there is one}
            Try
              advTo.Text := fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
            Except
            End;

            If (lMsg <> Nil) And (advTo.Text = '') Then
            Begin
              If glProduct = ptLITEAcct Then
                advTo.Text := lMsg.From
              Else
                advTo.Text := lMsg.To_;
            End; {If lMsg <> Nil Then}

            SelectCompany(TCompany(tvComp.Selected.Data).Id);
            {set the message params}
            SetExportDetails(lMsg, '', lp1, lP2);

            //advSubject.Text := 'Scheduled Dripfeed from ' + _DashboardGetCompanyName + ' [' + TCompany(tvComp.Selected.Data).Desc + ']';
            advSubject.Text := 'Scheduled Task from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(tvComp.Selected.Data).Desc + ']';

            cbJobs.Enabled := False;

            lModal := ShowModal;
            frmDailyScheduleTask.Free;
          End; {with frmDailyScheduleTask do}

          If Assigned(lMsg) Then
            FreeAndNil(lMsg);

          If lModal = mrOK Then
          Begin
            LoadCompanies;
            tvCompClick(tvComp);
            CheckCompanyActions;
          End; {If lModal = mrOK Then}
        End; {If TObject(tvComp.Selected.Data) Is TCompany Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: actReminderExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actReminderExecute(Sender: TObject);
Begin
  If glDSROnline Then
  Begin
    Application.CreateForm(TfrmReminder, frmReminder);
    If Assigned(frmReminder) Then
    Begin
      If frmReminder.CheckReminder Then
        frmReminder.ShowModal
      Else If Not glDashLoading Then
        ShowDashboardDialog('There are no items to show in this view.',
          mtInformation, [mbok]);

      frmReminder.Free;
    End; {if Assigned(frmReminder) then}
  End; {If glDSROnline Then}
End;

{-----------------------------------------------------------------------------
  Procedure: tmUpdateCompanyInfoTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tmUpdateCompanyInfoTimer(Sender: TObject);
Const
  cREDTEXT = '<font color="clRed"><b>%s</b></font>';
Var
  lMsg: TMessageInfo;
  lTotalIn, lTotalOut: integer;
  //lComp: TCompany;
  lComp: TMailBoxCompany;
  lNode: TTreeNode;
  lP1, lP2: WideString;
  lRes: Longword;
Begin
  tmUpdateCompanyInfo.Enabled := False;

  {check which node is selected. It will only load info from tvcomp selected node}
  If (tvComp.Selected <> Nil) And Not fClosing Then
  Begin
    {load the company information}
    lNode := tvComp.Selected;

    If TObject(lNode.Data) Is TCompany Then
      If lNode.HasChildren Then
        lNode := lNode.getFirstChild;

    If lNode <> Nil Then
      lComp := TMailBoxCompany(lNode.Data);

    If lComp <> Nil Then
    Begin
      {double check company actions}
      CheckCompanyActions;

      Try
        lbCompStatus.Clear;
        lbCompStatus.Items.Add('-Company Info-');
        lbCompStatus.Items.Add('Name: ' + _ChangeAmpersand(lComp.Desc));
        lbCompStatus.Items.Add('Code: ' + lComp.ExCode);
        lbCompStatus.Items.Add('Directory: ' + lComp.Directory);
        lbCompStatus.Items.Add('');

        If Not glIsVAO And Not glIsCIS Then
        Begin
          If Not glDSROnline Then
            //lbCompStatus.Items.Add('-Dripfeed status not available-')
            lbCompStatus.Items.Add('-Link status not available-')
          Else
          Begin
            //lbCompStatus.Items.Add('-Dripfeed status-');
            lbCompStatus.Items.Add('-Link status-');

          {get the dripfeed params}
            If actUpdateLink.Enabled Then
            Try
              lRes := TDSR.DSR_GetDripFeedParams(_DashboardGetDSRServer,
                _DashboardGetDSRPort, lComp.Id, lP1, lP2);
            Finally
              If (lp1 <> '') And (lp2 <> '') Then
                lbCompStatus.Items.Add('Period: ' +
                  _GetPeriod(lp1) + DateSeparator + _GetYear(lp1) +
                  ' - ' + _GetPeriod(lp2) + DateSeparator + _GetYear(lp2));
            End; {If actUpdateLink.Enabled Then}

          {update info for customer version}
            If glProduct = ptLITECust Then
            Begin
              If CheckCompanyinProcess(TCompany(lNode.Data).Id) Then
                lbCompStatus.Items.Add(Format(cREDTEXT,
                  ['Please ensure there are no users accessing IRIS Accounts Office.']));

              If actUpdateLink.Enabled Then
                //lbCompStatus.Items.Add('<font color="clBlue">Company in Dripfeed mode...</b></font>')
                lbCompStatus.Items.Add('<font color="clBlue">Company in Linked Mode...</b></font>')
              Else If actBulkExport.Enabled Then
              Begin
                If Not CheckCompanyinProcess(TCompany(lNode.Data).Id) Then
                  lbCompStatus.Items.Add('<font color="clBlue">Bulk Export available...</b></font>');
              End
              Else
              Begin
                If fDb.IsEndOfSyncRequested(lComp.Id) Then
                Begin
                  //lbCompStatus.Items.Add(Format(cREDTEXT, ['End of Dripfeed requested.']));
                  lbCompStatus.Items.Add(Format(cREDTEXT, ['End of Link requested.']));
                End {if fDb.IsEndOfSyncRequested(lComp) then}
                Else
                Begin
                  //lbCompStatus.Items.Add('<font color="clGreen"><b>Company can make a Dripfeed request...</b></font>');
                  lbCompStatus.Items.Add('<font color="clGreen"><b>Company can make a Link Request...</b></font>');

                  lMsg := fDb.GetTopOutboxMessage(lComp.Id);
                  If Not fDb.InboxMessageStatusExists(lComp.Id, cSYNCACCEPTED) And
                    (lMsg <> Nil) Then
                    If lMsg.Mode = Ord(RmSync) Then
                    Begin
                      If Not fDb.InboxMessageStatusExists(lComp.Id, cSYNCDENIED) And
                        Not fDb.InboxMessageStatusExists(lComp.Id, cSYNCFAILED) Then
                      Begin
                        lbCompStatus.Items.Add('-or-');
                        //lbCompStatus.Items.Add('<font color="clGreen"><b>Waiting Dripfeed confirmation...</b></font>');
                        lbCompStatus.Items.Add('<font color="clGreen"><b>Waiting Link confirmation...</b></font>');
                      End;

                      lMsg.Free;
                    End; {lMsg.Mode = Ord(RmSync)}
                End; {else begin }
              End; {begin}
            End {If glProduct = ptLITECust Then}
            Else
            Begin
    {update info for practice version}
              If actUpdateLink.Enabled Then
                //lbCompStatus.Items.Add('<font color="clBlue">Company in Dripfeed mode...</b></font>')
                lbCompStatus.Items.Add('<font color="clBlue">Company in Linked Mode...</b></font>')
              Else
              Begin
                {end of sync has been requested}
                If fDb.IsEndOfSyncRequested(lComp.Id) Then
                  //lbCompStatus.Items.Add(Format(cREDTEXT, ['End of Dripfeed requested.']))
                  lbCompStatus.Items.Add(Format(cREDTEXT, ['End of Link requested.']))
                Else
                Begin
                  {cancel dripfeed process has been requested}
                  If fDb.InboxMessageStatusExists(lComp.Id, cDRIPFEEDCANCELLED) Then
                    //lbCompStatus.Items.Add(Format(cREDTEXT, ['Dripfeed process cancelled.']))
                    lbCompStatus.Items.Add(Format(cREDTEXT, ['Link process cancelled.']))
                  Else
                  Begin
                    lMsg := fDb.GetTopInboxMessage(lComp.Id);
                    If lMsg <> Nil Then
                    Begin
                      If lMsg.Status = cREADYIMPORT Then
                        lbCompStatus.Items.Add('Company ready to import data...')
                      Else
                      Begin
                        If lMsg.Status = cPOPULATING Then
                          lbCompStatus.Items.Add('Populating Client...')
                        Else If lMsg.Mode = Ord(rmSync) Then
                          lbCompStatus.Items.Add('Company waiting Bulk Export data...')
                        Else
                          //lbCompStatus.Items.Add('Company waiting Dripfeed data...');
                          lbCompStatus.Items.Add('Company waiting Linked data...');
                      End; {else begin}

                      lMsg.Free;
                    End
                    Else
                      lbCompStatus.Items.Add('Company waiting data...');
                  End; {if fDb.InboxMessageStatusExists(lComp.Id, cDRIPFEEDCANCELLED) then}
                End; {If fDb.IsEndOfSyncRequested(lComp.Id) Then}
              End; {If actUpdateLink.Enabled Then}
            End; {begin}
          End; {else If Not glDSROnline Then}
        End; {if not glisvao and not glCIS then}

        lbCompStatus.Items.Add('');
        lTotalIn := fDb.GetTotalInboxMessages(lComp.Id);
        lTotalOut := fDb.GetTotalOutboxMessages(lComp.Id);
        lbCompStatus.Items.Add('Total Messages: ' + Inttostr(lTotalIn +
          lTotalOut));
        lbCompStatus.Items.Add('Inbox: ' + inttostr(lTotalIn));
        lbCompStatus.Items.Add('Outbox: ' + inttostr(lTotalOut));
      Except
        On e: exception Do
        Begin
          lbCompStatus.Clear;
          lbCompStatus.Items.Add('-Company info not available-');
          fDb.UpdateIceLog('TfrmDashboard.tmUpdateCompanyInfoTimer',
            'Error loading company info. Error: ' + e.Message);
        End; {begin}
      End; {try}
    End
    Else
    Begin
      lbCompStatus.Clear;
      lbCompStatus.Items.Add('-Company info not available-');
    End {begin}
  End; {if tvComp.Selected <> nil Then}

  tmUpdateCompanyInfo.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: actRemoveScheduleExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actRemoveScheduleExecute(Sender: TObject);
Var
  lFrame: TfrmMailBoxBaseFrame;
Begin
  {get the active frame}
  lFrame := GetSelectedFrame;

  If lFrame <> Nil Then
    {check type of mailbox}
    Case lFrame.BoxType Of
      btInbox:
        Begin
          {check each actions do call}
          If Sender = actDeleteInbox Then
            TfrmInboxFrame(lFrame).actDeleteExecute(Sender)
          Else If Sender = actImport Then
            TfrmInboxFrame(lFrame).actImportExecute(Sender)
          Else If Sender = actDeny Then
            TfrmInboxFrame(lFrame).actDenyExecute(Sender)
          Else If Sender = actAccept Then
            TfrmInboxFrame(lFrame).actImportExecute(Sender)
          Else If Sender = actSelectAllInbox Then
            TfrmInboxFrame(lFrame).actSelectAllExecute(Sender)
          Else If Sender = actInboxPreview Then
            TfrmInboxFrame(lFrame).actPreviewExecute(Sender)
        End;
      btOutbox:
        Begin
          {check each actions do call}
          If Sender = actDeleteOutbox Then
            TfrmOutboxFrame(lFrame).actDeleteExecute(Sender)
          Else If Sender = actRemoveSchedule Then
            TfrmOutboxFrame(lFrame).actRemoveScheduleExecute(Sender)
          Else If Sender = actViewSchedule Then
            {calling with actviewschedule as sender}
            TfrmOutboxFrame(lFrame).actViewScheduleExecute(Nil)
          Else If Sender = actChangeSchedule Then
            // change schedule needs a sender to be able to edit items
            TfrmOutboxFrame(lFrame).actViewScheduleExecute(TfrmOutboxFrame(lFrame).actChangeSchedule)
          Else If Sender = actSelectAllOutbox Then
            TfrmOutboxFrame(lFrame).actSelectAllExecute(Sender)
          Else If Sender = actOutboxPreview Then
            TfrmOutboxFrame(lFrame).actPreviewExecute(Sender)
          Else If Sender = actViewCISResponse Then
            TfrmOutboxFrame(lFrame).actViewCISResponseExecute(Sender)
          Else If Sender = actResend Then
            TfrmOutboxFrame(lFrame).actResendExecute(Sender)
        End;
      btRecycle:
        Begin
          {check each actions do call}
          If Sender = actDeleteRecycle Then
            TfrmRecycleFrame(lFrame).actDeleteExecute(Sender)
          Else If Sender = actSelectAllRecycle Then
            TfrmRecycleFrame(lFrame).actSelectAllExecute(Sender)
          Else If Sender = actRecyclePreview Then
            TfrmRecycleFrame(lFrame).actPreviewExecute(Sender)
          Else If Sender = actRecycleRestore Then
            TfrmRecycleFrame(lFrame).actRestoreExecute(Sender)
        End;
    End; {Case lFrame.BoxType Of}
End;

{-----------------------------------------------------------------------------
  Procedure: tvBoxEnter
  Author:    vmoura

  disable actions from the buttons
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tvBoxEnter(Sender: TObject);
Begin
  ChangeActionStatus('inbox', False);
  ChangeActionStatus('outbox', False);
  ChangeActionStatus('recycle', False);
End;

{-----------------------------------------------------------------------------
  Procedure: mnuInboxClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.mnuInboxClick(Sender: TObject);
Var
  lFrame: TfrmMailBoxBaseFrame;
Begin
  {get the active frame}
  lFrame := GetSelectedFrame;

  {disable actions}
  ChangeActionStatus('inbox', False);
  ChangeActionStatus('outbox', False);
  ChangeActionStatus('recycle', False);

  If lFrame <> Nil Then
    {check type of mail box}
    Case TfrmMailBoxBaseFrame(lFrame).BoxType Of
      btInbox:
        Begin
           {verify actions status over a selected msg}
          TfrmInboxFrame(lFrame).CheckActions(Nil);
          actDeleteInbox.Enabled := TfrmInboxFrame(lFrame).actDelete.Enabled;
          actImport.Enabled := TfrmInboxFrame(lFrame).actImport.Enabled;
          actDeny.Enabled := TfrmInboxFrame(lFrame).actDeny.Enabled;
          actAccept.Enabled := TfrmInboxFrame(lFrame).actAccept.Enabled;
          actSelectAllInbox.Enabled := TfrmInboxFrame(lFrame).actSelectAll.Enabled;
          actInboxPreview.Enabled := TfrmInboxFrame(lFrame).actPreview.Enabled;
          actInboxPreview.Checked := TfrmInboxFrame(lFrame).actPreview.Checked;
        End; {begin btinbox}
      btOutbox:
        Begin
          TfrmOutboxFrame(lFrame).CheckActions(Nil);
          actDeleteOutbox.Enabled := TfrmOutboxFrame(lFrame).actDelete.Enabled;
          actRemoveSchedule.Enabled :=
            TfrmOutboxFrame(lFrame).actRemoveSchedule.Enabled;
          actViewSchedule.Enabled :=
            TfrmOutboxFrame(lFrame).actViewSchedule.Enabled;
          actChangeSchedule.Enabled :=
            TfrmOutboxFrame(lFrame).actChangeSchedule.Enabled;
          actSelectAllOutbox.Enabled :=
            TfrmOutboxFrame(lFrame).actSelectAll.Enabled;
          actOutboxPreview.Enabled := TfrmOutboxFrame(lFrame).actPreview.Enabled;
          actOutboxPreview.Checked := TfrmOutboxFrame(lFrame).actPreview.Checked;
          actViewCISResponse.Enabled :=
            TfrmOutboxFrame(lFrame).actViewCISResponse.Enabled;
          actViewCISResponse.Visible :=
            TfrmOutboxFrame(lFrame).actViewCISResponse.Visible;
          actResend.Visible := TfrmOutboxFrame(lFrame).actResend.Visible;
          actResend.Enabled := TfrmOutboxFrame(lFrame).actResend.Enabled;
        End; {begin btoutbox}

      btRecycle:
        Begin
          TfrmRecycleFrame(lFrame).CheckActions(Nil);
          actDeleteRecycle.Enabled := TfrmRecycleFrame(lFrame).actDelete.Enabled;
          actSelectAllRecycle.Enabled :=
            TfrmRecycleFrame(lFrame).actSelectAll.Enabled;
          actRecyclePreview.Enabled := TfrmRecycleFrame(lFrame).actPreview.Enabled;
          actRecyclePreview.Checked := TfrmRecycleFrame(lFrame).actPreview.Checked;
          actRecycleRestore.Enabled := TfrmRecycleFrame(lFrame).actRestore.Enabled;
        End; {begin btRecycle}
    End; {Case TfrmMailBoxBaseFrame(lFrame).BoxType Of}
End;

{-----------------------------------------------------------------------------
  Procedure: tmCheckEmailTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tmCheckEmailTimer(Sender: TObject);
Begin
  tmCheckEmail.Enabled := False;

  If Not fClosing And glDSROnline Then
  Try
    actCheckMailNowExecute(Nil);
  Except
  End;

  tmCheckEmail.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: mnuHelpContentsClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.mnuHelpContentsClick(Sender: TObject);
Begin
  Application.HelpContext(1);
End;

{-----------------------------------------------------------------------------
  Procedure: AfterDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.AfterDelete(Sender: TObject);
Begin
  If Sender <> Nil Then
    With TfrmMailBoxBaseFrame(Sender) Do
    Begin
      Try
        {update number of items}
        SetStatusBarItemCount(Count);
      Finally
        If Count = 0 Then
          ClearItems;

        {check if there is at least one item selected}
        If AdvOutlook.SelectedCount = 0 Then
        Begin
          Try
            SetFirstValidItem;
          Except
          End;
        End
        Else
          AdvOutlookSelectionChange(AdvOutlook);
      End; {try}
    End; {With TfrmMailBoxBaseFrame(Sender) Do}
End;

{-----------------------------------------------------------------------------
  Procedure: ppmRebuildPopup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ppmRebuildPopup(Sender: TObject);
Var
  lNode: TTreeNode;
  lPoint: TPoint;
Begin
  {ensure user is left clicking on a company node }
  lPoint := tvHistory.ScreenToClient(Mouse.CursorPos);
  lNode := tvHistory.GetNodeAt(lPoint.X, lPoint.y);

  If lNode = Nil Then
    Abort;
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeNewToolBarButtons
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ChangeNewToolBarButtons(pValue: Boolean);
Begin
  actDeleteCompany.Visible := False;
  actActivateCompany.Visible := False;
  actRecreate.Visible := False;
  actLinkRequest.Visible := pValue And (glProduct = ptLITECust) And Not glISCIS;
  actBulkExport.Visible := pValue And (glProduct = ptLITECust) And Not glISCIS;
  actUpdateLink.Visible := pValue And Not glISCIS;
  actEndLink.Visible := pValue And Not glISCIS;
  actAddSchedule.Visible := pValue And Not glISCIS;
  actCancelLink.Visible := pValue And (glProduct = ptLITECust) And Not glISCIS;
  actDeactivateComp.Visible := pValue {and not glISCIS};

  //actRefreshCompany.Visible := pValue;

  actSubContractorVerification.Visible := pValue and glISCIS;

//  btnMore.Visible := pValue;
//  btnMore.Enabled := btnMore.Visible;
//  mnuFileMore.Visible := pValue;
//  mnuCompMore.Visible := pValue;
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeHistoryBarButtons
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.ChangeHistoryBarButtons(pValue: Boolean);
Begin
  actSubContractorVerification.Visible := not pValue And glISCIS;

  {i need to change the visibility according to the order of the buttons to appear correct}
  If pValue Then
  Begin
    actRecreate.Visible := pValue And Not glISCIS;
    actActivateCompany.Visible := pValue;
    actDeleteCompany.Visible := pValue;
  End
  Else
  Begin
    actDeleteCompany.Visible := pValue;
    actActivateCompany.Visible := pValue;
    actRecreate.Visible := pValue;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: advNavChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.advNavChange(Sender: TObject);
Begin
  If (advNav.ActivePanel = advNavHistory) Or (advNav.ActivePanel = advNavArchive)
    Then
  Begin
    If tpCompany.Locked Then
      tpCompany.Locked := False;

    ChangeNewToolBarButtons(False);
    ChangeActionStatus('New', False);
    {set the correct focus}
    If (advNav.ActivePanel = advNavHistory) And tvHistory.CanFocus Then
    Begin
      ChangeHistoryBarButtons(True);
      Try
        tvHistory.SetFocus;
      Except
      End
    End
    Else If (advNav.ActivePanel = advNavArchive) And tvArchive.CanFocus Then
    Begin
      ChangeHistoryBarButtons(False);
      Try
        tvArchive.SetFocus;
      Except
      End
    End; {If (advNav.ActivePanel = advNavArchive) And tvArchive.CanFocus Then}
  End
  Else
  Begin
    {dripfeed tab}
    ChangeNewToolBarButtons(True);
    ChangeHistoryBarButtons(False);

    CheckCompanyActions;

    If tvBox.Selected <> Nil Then
    Begin
      tvBoxClick(Self);
      If tvBox.CanFocus Then
      Try
        tvBox.SetFocus;
      Except
      End;
    End {If tvBox.Selected <> Nil Then}
    Else If tvComp.Selected <> Nil Then
    Begin
      tvCompClick(tvComp);
      If tvComp.CanFocus Then
      Try
        tvComp.SetFocus
      Except
      End;
    End; {If tvComp.Selected <> Nil Then}
  End; {else begin}
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If ssAlt In Shift Then
    Case key Of
      Ord('o'), Ord('O'): advNav.ActivePanel := advNavHistory;
      Ord('v'), Ord('V'): advNav.ActivePanel := advNavArchive;
      Ord('p'), Ord('P'): advNav.ActivePanel := AdvNavLink;
      Ord('i'), Ord('I'): If glISCIS Then
          advNav.ActivePanel := AdvNavLink;
    End; {Case key Of}
End;

{-----------------------------------------------------------------------------
  Procedure: actClearEventLogExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actClearEventLogExecute(Sender: TObject);
Begin
  If Assigned(fDb) And fDb.Connected And glDSROnline Then
    If ShowDashboardDialog('Are you sure you want to clear the Event Log?',
      mtConfirmation, [mbYes, mbNo]) = mRyes Then
    Try
      {clear event log based on todays date 0=today, 1= yesterday and so on...}
      fDb.DeleteIceDBLog(0);
      qryLog.Close;
    Except
      On e: exception Do
        _LogMSG('actClearEventLogExecute :- An exception has occurred:' +
          E.Message);
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: actCancelDripFeedExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.actCancelLinkExecute(Sender: TObject);
Var
  lNode: TTreeNode;
  lComp: Integer;
  lName: String;
//  lRes,
//    lStatus: Longword;
  lp1, lp2: WideString;
  lModal: TModalResult;
  lMsg: TMessageInfo;
  lGuid: String;
Begin
  If Assigned(fDb) Then
  Begin
    Application.ProcessMessages;
    lNode := tvComp.Selected;

    {check if node is nil or it has changed for resfresh reason}
    If lNode <> Nil Then
    Begin
      lComp := 0;
      If lNode.Data <> Nil Then
      {get the company name and code and guid}
        If TObject(lNode.Data) Is TCompany Then
        Begin
          lComp := TCompany(lNode.Data).Id;
          lName := TCompany(lNode.Data).Desc;
          lGuid := TCompany(lNode.Data).Guid;
          If lGuid = '' Then
            lGuid := fDb.GetCompanyGuid(lComp);
        End;

      If lComp > 0 Then
      Begin
        If
          ShowDashboardDialog('Are you sure you want to cancel the Link Request for company "'
          + _ChangeAmpersand(lName) + '"?', mtConfirmation, [mbYes, mbNo]) = Mryes
          Then
        Begin
          Application.CreateForm(TfrmEndofSyncRequest, frmEndofSyncRequest);
          With frmEndofSyncRequest, frmEndofSyncRequest.frmExportFrame Do
          Begin
            CancelDripfeed := True;
            {get the default e-mail receiver if there is one}
            Try
              advTo.Text :=
                fDb.GetDefaultReceiver(TCompany(tvComp.Selected.Data).Id);
            Except
            End;

            If advTo.Text = '' Then
            Begin
              {get the top message to be able to indentify the from/to in case no default was selected}
              If glProduct = ptLITEAcct Then
                lMsg := fDb.GetTopInboxMessage(lComp)
              Else
                lMsg := fDb.GetTopOutboxMessage(lComp);

              If Assigned(lMsg) Then
              Begin
                If glProduct = ptLITEAcct Then
                  advTo.Text := lMsg.From
                Else
                  advTo.Text := lMsg.To_;
                FreeAndNil(lMsg);
              End; {If Assigned(lMsg) Then}
            End; {If advTo.Text = '' Then}

            SelectCompany(TCompany(tvComp.Selected.Data).ExCode);
            {set the export params with a subject identifier}
            SetExportDetails(Nil, '', lP1, lP2);

            //advSubject.Text := 'Cancel Dripfeed from ' + _DashboardGetCompanyName + ' [' + TCompany(lNode.Data).Desc + ']';
            //advSubject.Text := 'Cancel Dripfeed from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(lNode.Data).Desc + ']';
            advSubject.Text := 'Cancel Link from ' + fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + TCompany(lNode.Data).Desc + ']';

            SelectDripFeed;
            cbJobs.Enabled := False;

            lModal := ShowModal;
          End; {With frmEndofSyncRequest, frmEndofSyncRequest.frmExportFrame Do}

          If Assigned(frmEndofSyncRequest) Then
            FreeAndNil(frmEndofSyncRequest);

          {refresh company data}
          If lModal = mrOK Then
          Begin
            _CompanyDeleteBulk(lGuid);
            LoadCompanies;
          End; {If lModal = mrOK Then}
        End; {if messagedlg}
      End; {if lcomp > 0}
    End; {If lNode <> Nil Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: tpDashboardTabSlideInDone
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDashboard.tpDashboardTabSlideInDone(Sender: TObject;
  Index: Integer; APanel: TAdvToolPanel);
Begin
  HideMenus;
End;

{-----------------------------------------------------------------------------
  Procedure: actSubContractorVerificationExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmDashboard.actSubContractorVerificationExecute(
  Sender: TObject);
Var
  lModal: TModalResult;
Begin
    {get the company details taking the company info out of the selected node}
  If (tvComp.Selected <> Nil) And (advNav.ActivePanel = AdvNavLink) Then
  Begin
    If tvComp.Selected.Data <> Nil Then
    Begin
      Application.CreateForm(TfrmSubVerification, frmSubVerification);

      With frmSubVerification, frmSubVerification.frmExportFrame Do
      Begin
        SubContractorVerification := True;
        SelectCompany(TCompany(tvComp.Selected.Data).ExCode);

        advSubject.Text := 'Subcontractors Verification ' +
          fDB.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' +
          TCompany(tvComp.Selected.Data).Desc + ']';

        lModal := ShowModal;
        FreeAndNil(frmSubVerification);
      End; {With frmBulkExport, frmBulkExport.frmExportFrame Do}

      If lModal = mrOK Then
        LoadCompanies;
    End;

    Application.ProcessMessages;
    CheckCompanyActions;
  End; {If lNode <> Nil Then}
end;

{-----------------------------------------------------------------------------
  Procedure: sbDashPanelRightClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmDashboard.sbDashPanelRightClick(Sender: TObject;
  PanelIndex: Integer);
begin
  if PanelIndex = 4 then
    ppmStatusBar.PopupAtCursor;
end;

End.

