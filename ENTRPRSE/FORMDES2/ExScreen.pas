unit ExScreen;

{
/////////////////////////////////////////////////////////////////////////////////
       A      TTTTTTTT  TTTTTTTT  EEEEEE   N    N  TTTTTTTT  II   OOOOOOO N    N
      A A        TT        TT     E        N N  N     TT     II   O     O N N  N
     A   A       TT        TT     EEE      N  N N     TT     II   O     O N  N N
    A AAA A      TT        TT     E        N   NN     TT     II   O     O N   NN
   A       A     TT        TT     EEEEEE   N    N     TT     II   OOOOOOO N    N
/////////////////////////////////////////////////////////////////////////////////

We have a problem running the TMS components and the HTML help

The HTML uses the screen variable to be work properly and the TMS components complain
that the FONT are not the same when setting font.assing(screen.menufont) when a exe calls a dll, for example.

The work around is this unit (excreen.pas) which does the job and correct the problem.
This unit MUST be added to the uses clause of any tms components that complain
about Tfont is not a tfont so the tms can load their proper screen variable from forms

The units that received the FIXSCREEN define are:
Advmenus.pas
 
}


interface

uses Forms;


function Screen: TScreen;

var
  TempScreen  : TScreen;

implementation

function Screen: TScreen;
begin
  Result := TempScreen;
end;


initialization
  TempScreen := forms.Screen;

end.
