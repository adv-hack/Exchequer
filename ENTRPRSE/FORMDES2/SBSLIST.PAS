unit sbslist;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSBSList = class(TList)
  private
    { Private declarations }
    FDescription : String;
  protected
    { Protected declarations }
  public
    { Public declarations }
    Property Description : String Read FDescription Write FDescription;
    constructor CreateList(ListDescr: String);Virtual;
    destructor Destroy; override;
  end;

implementation

constructor TSBSList.CreateList(ListDescr:String);
begin
  Inherited Create;

  FDescription := ListDescr;
end;

destructor TSBSList.Destroy;
{Var
  MsgStr : String;}
begin
  (* MH 23/04/96: Hide for final release
  If (Count > 0) Then Begin
    If (FDescription = '') Then FDescription := 'Unknown';

    MsgStr := Trim(FDescription) +
              #13#10 +
              #13#10 +
              'Destroy called with elements still in the list.' + #0;

    Application.MessageBox (@MsgStr[1],
                            'TSBSList',
                            (MB_ICONERROR Or MB_Ok));
  End; { If }
  *)

  Inherited Destroy;
end;

end.
