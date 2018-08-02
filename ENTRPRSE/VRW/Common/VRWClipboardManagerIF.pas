unit VRWClipboardManagerIF;

interface

uses VRWReportIF;

type
  IVRWClipboardManager = interface
  ['{61D8A4C2-305C-437D-A9C9-CCE4A5FADA0D}']
    { Clears all controls from list of pending items. }
    procedure ClearClipboard;

    { Adds the control to the list of pending items. }
    procedure CopyToClipboard(Control: IVRWControl);

    { Copies all the pending items to the clipboard, and clears the list }
    procedure CommitClipboard;

    { Pastes the control(s) from the clipboard. }
    procedure PasteFromClipboard(Report: IVRWReport; IntoRegion: IVRWRegion = nil; OnPaste: TVRWOnPasteControl = nil);

    { Returns True if there are any controls on the clipboard }
    function CanPaste: Boolean;

  end;

implementation

end.
