unit COMTKVER;

interface

Const
  // HM 05/11/04: Moved version number out of oToolkit.Pas so it could be
  // referenced by the error logging

  // MH 20/04/2017 2017-R1: Added 'V' to keep sorting order with move from '9' to '10'

  {$IFNDEF WANTEXE04}
  COMTKVersion = 'TKCOM~V1101.645';       // Release Version
  {$ELSE}
  COMTKVersion = 'TKCOM~V1101.645E';      // Release Version
  {$ENDIF}

implementation


end.
