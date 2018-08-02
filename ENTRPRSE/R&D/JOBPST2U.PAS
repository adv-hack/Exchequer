unit JobPst2U;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,JobPostU;

{*
  // This is a dummy unit to avoid any circular reference as it has to be called from within TentPost
     To get hold of the Update_JobActual.

*}

Type

TPostJobObj      =  Object(TPostJob)

                     private
                       CallBackVar  :  Byte;

                   end; {Class..}




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU;

end.