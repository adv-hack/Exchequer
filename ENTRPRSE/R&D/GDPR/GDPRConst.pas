unit GDPRConst;

interface

uses oAnonymisationDiaryBtrieveFile;

const
  NotesAnonymisationControlCentreList : Array[1..2] of String =
    (
      'Leave Notes intact',
      'Delete all Notes'
    );
  LettersAnonymisationControlCentreList : Array[1..3] of String =
    (
      'Leave Letters intact',
      'Delete all the Letter records, but leave the Letter files intact',
      'Delete all the Letter records and delete the Letter files'
    );
  LinksAnonymisationControlCentreList : Array[1..3] of String =
    (
      'Leave Links intact',
      'Delete all the Link records, but leave the linked files intact',
      'Delete all the Link records and delete the linked files'
    );

  capAnonymisedStatus = 'Anonymised %s';
  capAnonymisedPendingStatus = 'Anonymisation Pending for %s';
  capAnonymised = '*ANONYMISED*';

  AnonDiaryEntityTypeDesc : Array[TAnonymisationDiaryEntity] of String =
    (
                       'Customer',
                       'Supplier',
                       'Employee'
    );


  strDeleteNotes = 'DeleteNotes';
  strDeleteLetters = 'DeleteLetters';
  strDeleteLinks = 'DeleteLinks';

  msgAnonymiseConfirmation = 'You have ticked %s entities for Anonymisation.'#13#13 +
                             'Click the Yes button to Anonymise the entities, click the No button to cancel';

implementation

end.
