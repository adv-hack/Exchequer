  TEntityRec = record
    etFolioNo          : LongInt;
    etDescription      : string[60];
    etType             : char;
    etFormat           : string[20];
    etDummyChar        : char;
    etSpare            : Array [1..300] of Char;
  end;{TEntityRec}

  TFieldRec = record
    fiFolioNo           : LongInt;
    fiEntityFolio       : LongInt;
    fiLineNo            : LongInt;
    fiDescription       : string[60];
    fiValidationMode    : LongInt;
    fiWindowCaption     : string[60];
    fiLookupRef         : String[20];
    fiDummyChar         : char;
    fiSpare             : Array [1..300] of Char;
  end;{TEntityRec}

  TListItemRec = record
//    liFolioNo           : LongInt;
    liFieldFolio        : LongInt;
    liLineNo            : LongInt;
    liDescription       : string[60];
    liDummyChar         : char;
    liSpare             : Array [1..300] of Char;
  end;{TEntityRec}
