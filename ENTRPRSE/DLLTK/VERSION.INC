{ Version.Inc }
Const
  {$IFNDEF WIN32}
  BitVer   = '16-Bit';
  {$ELSE}
  BitVer   = '32-Bit';
  {$ENDIF}


    // MH 20/04/2017 2017-R1: Added 'V' to keep sorting order with move from '9' to '10'

    {$IFDEF TC}
    BuildVer = 'TKDLL~V1101.363t';
    {$ELSE}
    BuildVer = 'TKDLL~V1101.363';
    {$ENDIF}

  { Version Notes

  TKDLL4.31 = Enterprise Version Number
  436.009   = DLL Version Number }

  //EntVer   = 'Enterprise 5.00 Beta';

  Ver  = BuildVer + '\' + BitVer;
