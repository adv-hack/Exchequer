unit history;

interface

{

03/04/2003 v5.51.059
=====================================================
Extended line debug form to list elert names, types & descriptions as well

Added ability to specify how often the engine tries to run or send sentimails before adding
them to its queue. The value is specified in the sentimail engine workstation setup/Polling tab
and applies to all engines. Setting the value to less than zero will result in sentinels never being
added to the queue - i.e. only sent directly.

Added field to sentinels to specify a number of hours from running the sentinel (or adding it
to the queue) after which, if the sentinel hasn't finished, the administrator should be notified
by email. Value is set on a new page (Notify) in the wizard (in elmanage) between Expiry and Active.

Changed wizard so that even if report writer is not licenced, the Type page is shown with the
Report radio button greyed out. (At request of KH).

Changed version no to v5.51

02/04/2003 v5.50.058
=====================================================
Added new bitmaps to elmanage now Sentimail is (R) rather than TM.
Change so that elmanage doesn't try to open reports.dat unless report writer is licenced.


27/08/2002 v5.00.047
=====================================================
Changed ElManage so that it's not possible to create Report-based Sentinels if
Report Writer isn't licenced.

17/4/2002 - ????
=====================================================
Sentinel:
Fixed bug where csv files weren't being saved to folder.

ElManage:
Added /AXD command-line param to control access to record debug info by dblclickin admnform
Added password handling in report tree
Disabled browse for form button on email manage unless send paperless ticked.
Ok button on Add Email was acting weirdly - fixed.




12/4/2002 v5.00.034
  Released

27/02/2002 b500.027

  Sentinel - amended to deal with local program files

-------------------------------------------------------
13/02/2002 Version b500.026 - First release candidate
}
implementation

end.
