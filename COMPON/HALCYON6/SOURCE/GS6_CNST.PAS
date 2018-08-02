unit gs6_cnst;
{-----------------------------------------------------------------------------
                                 Constant Values

       gs6_cnst Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          14 May 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the constant strings that are used for messages.
       They are placed here for easier internationalization.

   Changes:
------------------------------------------------------------------------------}
interface

resourcestring
   gsErrHalcyonError      = 'Halcyon Error';
   gsErrHalcyonSubCode    = 'Subcode';

   gsErrTableIsNil        = 'A table is not assigned to this object';
   gsErrTableIsActive     = 'Cannot perform this operation on an open table';
   gsErrOverwriteTable    = 'Table exists.  Do you want to overwrite?';
   gsErrInvalidFieldList  = 'Field list is invalid';
   gsErrNoTableName       = 'Table name missing';
   gsErrCannotFindFile    = 'Cannot find file %s';
   gsErrErrorGettingFile  = 'Error getting %s';
   gsErrIndexAlreadyOpen  = 'Index file %s already open';
   gsErrRecordOutOfRange  = 'Record request beyond range of table';
   gsErrDeleteRecord      = 'Cannot delete the record';
   gsErrUnDeleteRecord    = 'Cannot recall the record';
   gsErrInvalidBookmark   = 'Bookmark is invalid for table ';
   gsErrRecordLockAlready = 'Record is locked by another user';
   gsErrBusyIndexing      = 'Table is busy building an index';
   gsErrBusyCopying       = 'Table is busy copying';
   gsErrFilterExpression  = 'Filter expression must return boolean result';
   gsErrNotBrowsing       = 'Dataset is not in browse mode';
   gsErrNotEditing        = 'Dataset not in edit or insert mode';
   gsErrDataSetReadOnly   = 'Cannot modify a read-only dataset';
   gsErrRelationIndex     = 'Master/Detail relation failed, no index open for %s';
   gsErrRelationFields    = 'Master/Detail relation failed, field missmatch for %s';
   gsErrAliasAssigned     = 'Alias %s already assigned';

   {disk}
   gsErrInvalidFileObject = 'File object class is invalid or nil';
   gsErrPathNotFound      = 'Path %s not found';
   gsErrAccessDenied      = 'File %s access denied';
   gsErrLockViolated      = 'File %s lock violated';
   gsErrFileAlreadyOpen   = 'File %s is open by another process';
   gsErrGetFileSize       = 'Error getting FileSize for file %s';
   gsErrFlushFailed       = 'Error on Flush for file %s';
   gsErrLockFailed        = 'Can not Lock file %s';
   gsErrSeekFailed        = 'Error in FileSeek of file %s';
   gsErrNoSuchFile        = 'File %s could not be found';
   gsErrReadFailed        = 'Error on Read of file %s';
   gsErrCloseFailed       = 'Error in Close of file %s';
   gsErrRenameFailed      = 'Error on Rename of file %s';
   gsErrResetFailed       = 'Access denied to file %s';
   gsErrRewriteFailed     = 'Could not create file %s';
   gsErrNoFullAccess      = '%s requires full access to file %s';
   gsErrTruncateFailed    = 'Error in Truncate of file %s';
   gsErrUnlockFailed      = 'Error in Unlock of file %s';
   gsErrWriteFailed       = 'Error writing to %s';

   {gsd6sql}
   gsErrNoSuchFunction   = 'There is no function for %s';
   gsErrArgValueNeeded   = '%s needed for Argument %d of %s';
   gsErrArgRange         = 'Argument for %s must be %s';
   gsErrMissingSide      = 'Target value missing for %s operation';
   gsErrOpConflict       = 'The two sides of an operation do not match';
   gsErrArgInvalid       = 'A %s value is required but invalid';
   gsErrArgEmpty         = 'A value is required for %s';
   gsErrArgNotSame       = 'All arguments for %s must be of the same type';
   gsErrFieldInvalid     = 'Field/variable %s is unknown';
   gsErrConstructBad     = 'Expression cannot be evaluated';
   gsErrNoEndParend      = 'Missing closing parentheses';
   gsErrNoEndPeriod      = 'Missing closing period';
   gsErrNoEndQuote       = 'Missing closing "%s" on literal';
   gsErrNoTrueFalse      = 'Expecting ".T." or ".F."';
   gsErrSyntax           = 'Syntax Error in expression "%s"';
   gsErrBadEndParend     = 'Unexpected closing parentheses found';

   {Miscellaneous}
   gsErrVariantAppend    = 'Variant type is not valid for append';
   gsErrVariantTypes     = 'Variant types mismatch for compare';
   gsErrVariantSort      = 'Variant type cannot be sorted';
   gsErrSortLength       = 'Sort key length must be 1-%d bytes, is %d';
   gsErrSortBegun        = 'Cannot add sort keys after beginning retrieval';
   gsErrCollectionIndex  = 'Collection index out of range';
   gsErrFieldData        = 'Field data is incorrect for %s';
   gsErrFieldNumber      = 'Invalid numeric value in field %s';
   gsErrNumberTooBig     = 'numeric value too big in field %s';
   gsErrFieldDate        = 'Invalid date in field %s';
   gsErrFieldName        = 'There is no field name %s';
   gsErrFieldInput       = 'Invalid %s value for field %s';
   gsErrFieldPosition    = 'Invalid field number %s in %s';
   gsErrFieldType        = 'Field %s is the incorrect type';
   gsErrFieldTypeUnknown = 'FieldType for field %s is unknown';
   gsErrBadMemoRecord    = 'Memo record is bad in %s';
   gsErrDBFRecordNo      = 'Record number %d is not in table %s';
   gsErrDBFHeader        = 'Table Header for %s is invalid';
   gsErrIndexKeySync     = 'Cannot find key in %s to match current record';
   gsErrIndexOpen        = 'Index file %s had errors on open';
   gsErrIndexCorrupted   = 'Index file %s is corrupted';
   gsErrIndexTagMissing  = 'Cannot find index tag %s';
   gsErrIndexTagEmpty    = 'Tag field is empty';
   gsErrIndexLocks       = 'Could not lock indexes for Table %s';
   gsErrIndexCollate     = 'General collate is invalid for file %s';
   gsErrIndexFind        = 'No index is assigned for Find operation';
   gsErrIndexKey         = 'No index key has been created';
   gsErrUnExpectedPassword = 'A Password is included for unencrypted file %s';
   gsErrNoPassword       = 'No Password for encrypted file %s';
   gsErrBadPassword      = 'Invalid Password for encrypted file s%';

implementation

end.
