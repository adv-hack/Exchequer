unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils, Grids, Menus;

Type
  THackStringGrid = Class(TStringGrid);

  //------------------------------

  TForm1 = class(TForm)
    edtTableName: TEdit;
    lblTableName: TLabel;
    btnGetColumns: TButton;
    Label2: TLabel;
    edtCompanyCode: TEdit;
    Label3: TLabel;
    Bevel1: TBevel;
    btnGenerateCode: TButton;
    memGeneratedCode: TMemo;
    sgColumnInfo: TStringGrid;
    lblColumnInfo: TLabel;
    memDelphiRecord: TMemo;
    Button1: TButton;
    edtConnectionString: TComboBox;
    chkCompareQuery: TCheckBox;
    PopupMenu1: TPopupMenu;
    mnuDeleteSQLColumns: TMenuItem;
    btnOneOff: TButton;
    chkInsertCode: TCheckBox;
    ServerLbl: TLabel;
    ServerTxt: TEdit;
    DatabaseLbl: TLabel;
    DatabaseTxt: TEdit;
    BuildConnectionStringBtn: TButton;
    procedure btnGetColumnsClick(Sender: TObject);
    procedure btnGenerateCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mnuDeleteSQLColumnsClick(Sender: TObject);
    procedure btnOneOffClick(Sender: TObject);
    procedure BuildConnectionStringBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses SQLCallerU;

Const
  colColumnName = 0;
  colColumnType = 1;
  colColumnLength = 2;
  colDelphiField = 3;
  colDelphiFieldType = 4;

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Configure stringgrid to receive results
  sgColumnInfo.RowCount := 2;

  sgColumnInfo.Cells[colColumnName, 0] := 'Column Name';
  sgColumnInfo.ColWidths[colColumnName] := 150;

  sgColumnInfo.Cells[colColumnType, 0] := 'Type';
  sgColumnInfo.ColWidths[colColumnType] := 75;

  sgColumnInfo.Cells[colColumnLength, 0] := 'Length';
  sgColumnInfo.ColWidths[colColumnLength] := 45;

  sgColumnInfo.Cells[colDelphiField, 0] := 'Record Field';
  sgColumnInfo.ColWidths[colDelphiField] := 120;

  sgColumnInfo.Cells[colDelphiFieldType, 0] := 'Record Field';
  sgColumnInfo.ColWidths[colDelphiFieldType] := 75;

  lblColumnInfo.Caption := '';
end;

procedure TForm1.btnGetColumnsClick(Sender: TObject);
Var
  oSQLCaller : TSQLCaller;
  iNextRow, iBinaryCount : Integer;
begin
  oSQLCaller := TSQLCaller.Create;
  Try
    oSQLCaller.ConnectionString := edtConnectionString.Text;

    (* Old query replaced as doesn't allow automatic suppression of PositionId and calculated columns
    Select('Select COLUMN_NAME, DATA_TYPE, IS_NULLABLE ' +
           'From INFORMATION_SCHEMA.COLUMNS ' +
           'Where (TABLE_SCHEMA = ' + QuotedStr(edtCompanyCode.Text) + ') And (TABLE_NAME = ' + QuotedStr(edtTableName.Text) + ') ' +
           'Order By ORDINAL_POSITION', edtCompanyCode.Text);
    *)

    // Query returns Column Name and Data Type - allegedly in the correct order - for a specified table and
    // automatically suppresses PositionId and calculated columns
    oSQLCaller.Select('Select C.Name As ''ColumnName'', t.name As ''DataType'', C.Max_Length as ''MaxLength'' ' +
                      'From Sys.columns C ' +
                      'INNER JOIN sys.types t ON c.system_type_id = t.system_type_id ' +
                      'Where Object_Id = OBJECT_ID(' + QuotedStr(edtCompanyCode.Text + '.' + edtTableName.Text) + ') ' +
                      '  And (C.is_identity = 0) ' +  // Suppress PositionId columns
                      '  And (C.is_computed = 0) ' +  // Suppress Computed columns
                      'Order By Column_Id');

    lblColumnInfo.Caption := '';

    If (oSQLCaller.ErrorMsg = '') And (oSQLCaller.Records.RecordCount > 0) Then
    Begin
      sgColumnInfo.RowCount := oSQLCaller.Records.RecordCount + 1;
      iNextRow := 1;
      iBinaryCount := 0;

      oSQLCaller.Records.First;
      While (Not oSQLCaller.Records.EOF) Do
      Begin
        sgColumnInfo.Cells[colColumnName, iNextRow] := oSQLCaller.Records.FieldByName('ColumnName').Value;
        sgColumnInfo.Cells[colColumnType, iNextRow] := oSQLCaller.Records.FieldByName('DataType').Value;
        sgColumnInfo.Cells[colColumnLength, iNextRow] := oSQLCaller.Records.FieldByName('MaxLength').Value;
        iNextRow := iNextRow + 1;

        If (oSQLCaller.Records.FieldByName('DataType').Value = 'varbinary') Then
          iBinaryCount := iBinaryCount + 1;

        oSQLCaller.Records.Next;
      End; // While (Not Records.EOF)

      lblColumnInfo.Caption := '(' + IntToStr(oSQLCaller.Records.RecordCount) + ' columns found, ' + IntToStr(iBinaryCount) + ' Binary columns found)';

      (* Replaced with StringGrid
      memSQLColumns.Clear;
      Records.First;
      While (Not Records.EOF) Do
      Begin
        memSQLColumns.Lines.Add(Records.FieldByName('ColumnName').Value);
        Records.Next;
      End; // While (Not Records.EOF)
      *)
    End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
    Else
      ShowMessage ('Error: ' + oSQLCaller.ErrorMsg);
  Finally
    oSQLCaller.Free;
  End; // Try..Finally
end;

procedure TForm1.btnGenerateCodeClick(Sender: TObject);
Var
  bContinue, bLastItem : Boolean;
  S : ANSIString;
  I, iMaxLen : SmallInt;
begin
  // Check Table Name is defined
  bContinue := (edtTableName.Text <> '');
  If (Not bContinue) Then
    ShowMessage ('Table Name Not Defined');

  If bContinue Then
  Begin
    // Check we have SQL Columns defined
    bContinue := (sgColumnInfo.RowCount > 2);
    If (Not bContinue) Then
      ShowMessage ('No SQL Columns Defined');
  End; // If bContinue

  If bContinue Then
  Begin
    memGeneratedCode.Text := '';
    With memGeneratedCode.Lines Do
    Begin
      If chkInsertCode.Checked Then
      Begin
        // Use info on window to create a SQL Insert query using this layout:-
        //
        //  INSERT INTO [COMPANY].<Table>  (
        //                                  Column1,
        //                                  Column2,
        //                                  etc...
        //                                 )
        //  VALUES (
        //          :Column1Param,
        //          :Column2Param,
        //          etc...
        //         )

        S := '  sqlQuery := ' + QuotedStr('INSERT INTO [COMPANY].' + edtTableName.Text + ' (');
        Add (S + ' + ');

        // Run through SQL Columns creating Columns list
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          bLastItem := (I = (sgColumnInfo.RowCount - 1));
          Add (StringOfChar(' ', Length(S) - 1) + QuotedStr(sgColumnInfo.Cells[colColumnName, I] + IfThen(bLastItem, '', ', ')) + ' + ');
        End; // For I

        Add (StringOfChar(' ', Length(S) - 1) + QuotedStr(') ') + ' + ');
        S := '              ' + QuotedStr('VALUES (');
        Add (S + ' + ');

        // Run through SQL Columns creating Values list
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          bLastItem := (I = (sgColumnInfo.RowCount - 1));
          Add (StringOfChar(' ', Length(S) - 1) + QuotedStr(':' + sgColumnInfo.Cells[colColumnName, I] + IfThen(bLastItem, '', ', ')) + ' + ');
        End; // For I

        Add (StringOfChar(' ', Length(S) - 1) + QuotedStr(')') + ';');

        // Gap between separate sections of code
        Add (''); Add (''); Add ('');

        //------------------------------

        // Use info on window to create a list of TParameter variables to minimise lookups within the ADO object
        S := '    ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          If (I = (sgColumnInfo.RowCount - 1)) Then
          Begin
            // Last item
            S := S + sgColumnInfo.Cells[colColumnName, I] + 'Param : TParameter;';
            Add (S);
          End // If (I = (sgColumnInfo.RowCount - 1))
          Else
          Begin
            S := S + sgColumnInfo.Cells[colColumnName, I] + 'Param, ';
            If (Length(S) > 70) Then
            Begin
              Add (S);
              S := '    ';
            End; // If (Length(S) > 70)
          End; // Else
        End; // For I

        // Gap between separate sections of code
        Add (''); Add (''); Add ('');

        //------------------------------

        // Use info on window to create a section of code initialising the TParameter variables declared above
        Add ('  With FADOQuery.Parameters Do');
        Add ('  Begin');
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          Add ('    ' + sgColumnInfo.Cells[colColumnName, I] + 'Param := FindParam(' + QuotedStr(sgColumnInfo.Cells[colColumnName, I]) + ');');
        End; // For I
        Add ('  End; // With FADOQuery.Parameters');

        // Gap between separate sections of code
        Add (''); Add (''); Add ('');

        //------------------------------

        // Use info on window to create a section of code initialising the TParameter variables declared above - run through
        // twice so we can make the data type comments line up nicely - OCD or what!
        iMaxLen := 0;
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          If (Uppercase(sgColumnInfo.Cells[colDelphiFieldType, I]) = 'CHAR') Then
          Begin
            If (Uppercase(sgColumnInfo.Cells[colColumnType, I]) = 'VARCHAR') Then
              S := '    ' + sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := ConvertCharToSQLEmulatorVarChar(' + sgColumnInfo.Cells[colDelphiField, I] + ');'
            Else
              S := '    ' + sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := Ord(' + sgColumnInfo.Cells[colDelphiField, I] + ');'
          End // If (Uppercase(sgColumnInfo.Cells[colDelphiFieldType, I]) = 'CHAR')
          Else If (Uppercase(sgColumnInfo.Cells[colColumnType, I]) = 'VARBINARY') Then
            S := '    ' + sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := CreateVariantArray (@' + sgColumnInfo.Cells[colDelphiField, I] + ', SizeOf(' + sgColumnInfo.Cells[colDelphiField, I] + '));'
          Else
            S := '    ' + sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := ' + sgColumnInfo.Cells[colDelphiField, I] + ';';
          If (Length(S) > iMaxLen) Then
            iMaxLen := Length(S);
        End; // For I

        // stick a 5 character gap between the longest line and the comment
        iMaxLen := iMaxLen + 5;

        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          If (Uppercase(sgColumnInfo.Cells[colDelphiFieldType, I]) = 'CHAR') Then
          Begin
            If (Uppercase(sgColumnInfo.Cells[colColumnType, I]) = 'VARCHAR') Then
              S := sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := ConvertCharToSQLEmulatorVarChar(' + sgColumnInfo.Cells[colDelphiField, I] + ');'
            Else
              S := sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := Ord(' + sgColumnInfo.Cells[colDelphiField, I] + ');'
          End // If (Uppercase(sgColumnInfo.Cells[colDelphiFieldType, I]) = 'CHAR')
          Else If (Uppercase(sgColumnInfo.Cells[colColumnType, I]) = 'VARBINARY') Then
            S := '*** BINARY *** ' + sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := CreateVariantArray (@' + sgColumnInfo.Cells[colDelphiField, I] + ', SizeOf(' + sgColumnInfo.Cells[colDelphiField, I] + '));'
          Else
            S := sgColumnInfo.Cells[colColumnName, I] + 'Param.Value := ' + sgColumnInfo.Cells[colDelphiField, I] + ';';
          S := '    ' + S + StringofChar(' ', iMaxLen - Length(S)) + '// SQL=' + sgColumnInfo.Cells[colColumnType, I] + ', Delphi=' + sgColumnInfo.Cells[colDelphiFieldType, I];
          Add(S);
        End; // For I

        // Gap between separate sections of code
        Add (''); Add (''); Add ('');
      End; // If chkInsertCode.Checked

      //------------------------------ SQL Compare Query ----------------------------
      If chkCompareQuery.Checked Then
      Begin
        // Declare Source Table variables
        Add('-- Target Table columns');
        S := 'DECLARE ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + '@src' + sgColumnInfo.Cells[colColumnName, I] + ' ' + sgColumnInfo.Cells[colColumnType, I];
          If (sgColumnInfo.Cells[colColumnType, I] = 'varchar') Or (sgColumnInfo.Cells[colColumnType, I] = 'varbinary') Then
            S := S + '(' + sgColumnInfo.Cells[colColumnLength, I] + ')';
          Add(S);
          S := '      , ';
        End; // For I

        Add('');
        Add('-- Target Table columns');
        Add('');

        S := '      , ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + '@trg' + sgColumnInfo.Cells[colColumnName, I] + ' ' + sgColumnInfo.Cells[colColumnType, I];
          If (sgColumnInfo.Cells[colColumnType, I] = 'varchar') Or (sgColumnInfo.Cells[colColumnType, I] = 'varbinary') Then
            S := S + '(' + sgColumnInfo.Cells[colColumnLength, I] + ')';
          Add(S);
          S := '      , ';
        End; // For I

        Add('');
        Add('-- Local Variables');
        Add('');
        Add('      , @OK int');
        Add('      , @ERRCOUNT int');
        Add('');

        S := 'DECLARE src' + edtTableName.Text + ' CURSOR FOR SELECT ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + sgColumnInfo.Cells[colColumnName, I];
          Add(S);
          S := '                                    , ';
        End; // For I
        Add('                               FROM   ConvMasterPR70.' + edtCompanyCode.Text + '.' + edtTableName.Text);

        Add('');
        Add('SELECT @ERRCOUNT = 0');
        Add('');

        Add('');
        Add('OPEN src' + edtTableName.Text);
        Add('');

        S := 'FETCH NEXT FROM src' + edtTableName.Text + ' INTO ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + '@src' + sgColumnInfo.Cells[colColumnName, I];
          Add(S);
          S := '                               , ';
        End; // For I

        Add('');
        Add('WHILE @@FETCH_STATUS = 0');
        Add('BEGIN');
        Add('  -- Initialise variable to keep track of errors');
        Add('  Select @OK = 1');
        Add('');
        Add('  -- Get Target Columns for same row');

        S := '  SELECT ';
        For I := 2 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + '@trg' + sgColumnInfo.Cells[colColumnName, I] + ' = ' + sgColumnInfo.Cells[colColumnName, I];
          Add(S);
          S := '       , ';
        End; // For I
        Add('  FROM Exch70Conv.' + edtCompanyCode.Text + '.' + edtTableName.Text);
        Add('  WHERE acCode = @srcacCode');  // <-- needs to be customised per table

        Add('');
        Add('  -- Check for missing target');
        Add('  IF (@OK = 1) AND ((@src' + sgColumnInfo.Cells[colColumnName, 1] + ' IS NOT NULL) And (@trg' + sgColumnInfo.Cells[colColumnName, 1] + ' IS NULL))');
        Add('  BEGIN');
        Add('    PRINT ''Code: '' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + ''  Missing''');
        Add('    Select @OK = 0');
        Add('  END');

        // Per column comparison check
        Add('');
        Add('  -- Compare columns');
        For I := 2 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := '  IF (@OK = 1) AND ((@src' + sgColumnInfo.Cells[colColumnName, I] + ' <> @trg' + sgColumnInfo.Cells[colColumnName, I] + ') Or ' +
                   '((@src' + sgColumnInfo.Cells[colColumnName, I] + ' IS NULL) And (@trg' + sgColumnInfo.Cells[colColumnName, I] + ' IS NOT NULL)) Or ' +
                   '((@src' + sgColumnInfo.Cells[colColumnName, I] + ' IS NOT NULL) And (@trg' + sgColumnInfo.Cells[colColumnName, I] + ' IS NULL)))';
          Add (S);
          Add('  BEGIN');

          // Non-variant file
          S := '    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + ';
          // ExchqSS - VarBinary key field
          //S := '    PRINT ' + QuotedStr('Code: ') + ' + master.sys.fn_varbintohexstr(@src' + sgColumnInfo.Cells[colColumnName, 1] + ') + ';
          // Company.Dat
          //S := '    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + master.sys.fn_varbintohexstr(@src' + sgColumnInfo.Cells[colColumnName, 2] + ') + ';
          // Variant file
          //S := '    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + @src' + sgColumnInfo.Cells[colColumnName, 2] + ' + ';
          // ExchqChk - SubType = Int
          //S := '    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + Char(@src' + sgColumnInfo.Cells[colColumnName, 2] + ') + ';

          If (UpperCase(sgColumnInfo.Cells[colColumnType, I]) = 'BIT') Or (UpperCase(sgColumnInfo.Cells[colColumnType, I]) = 'INT') Then
            //Add('    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + ' + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' = ') + ' + STR(@src' + sgColumnInfo.Cells[colColumnName, I] + ') + '' / '' + STR(@trg' + sgColumnInfo.Cells[colColumnName, I] + ')')
            S := S + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' = ') + ' + STR(@src' + sgColumnInfo.Cells[colColumnName, I] + ') + '' / '' + STR(@trg' + sgColumnInfo.Cells[colColumnName, I] + ')'
          Else If (UpperCase(sgColumnInfo.Cells[colColumnType, I]) = 'VARBINARY') Then
            //Add('    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + ' + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' is different'))
            S := S + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' is different')
          Else
            //Add('    PRINT ' + QuotedStr('Code: ') + ' + @src' + sgColumnInfo.Cells[colColumnName, 1] + ' + ' + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' = ') + ' + @src' + sgColumnInfo.Cells[colColumnName, I] + ' + '' / '' + @trg' + sgColumnInfo.Cells[colColumnName, I]);
            S := S + QuotedStr('  ' + edtTableName.Text + '.' + sgColumnInfo.Cells[colColumnName, I] + ' = ') + ' + @src' + sgColumnInfo.Cells[colColumnName, I] + ' + '' / '' + @trg' + sgColumnInfo.Cells[colColumnName, I];

          Add (S);
          Add('    Select @OK = 0');
          Add('  END');
          //Add('');
        End; // For I

          
        Add('');
        Add('  IF (@OK = 0)');
        Add('  BEGIN');
        Add('    Select @ErrCount = @ErrCount + 1');
        Add('  END');
        Add('');

        S := '  FETCH NEXT FROM src' + edtTableName.Text + ' INTO ';
        For I := 1 To (sgColumnInfo.RowCount - 1) Do
        Begin
          S := S + '@src' + sgColumnInfo.Cells[colColumnName, I];
          Add(S);
          S := '                                 , ';
        End; // For I

        Add('  END');
        Add('');
        Add('  PRINT ''=================''');
        Add('  PRINT ''ErrCount = '' + STR(@ErrCount)');
        Add('');
        Add('  CLOSE src' + edtTableName.Text);
        Add('  DEALLOCATE src' + edtTableName.Text);
      End; // If chkCompareQuery.Checked
    End; // With memGeneratedCode.Lines
  End; // If bContinue
end;


procedure TForm1.Button1Click(Sender: TObject);
Var
  iCurrentLine, iPos, iCount : Integer;
  sLine, sOrigLine : String;
  bError : Boolean;

  //------------------------------

  Procedure RemoveBrackets (Var TheLine : String; Const OpeningBracket, ClosingBracket : ShortString);
  Var
    iPos1, iPos2 : Integer;
  Begin // RemoveBrackets
    // Check for any comments using { ... } layout
    Repeat
      iPos1 := Pos(OpeningBracket, TheLine);
      iPos2 := Pos(ClosingBracket, TheLine);

      If (iPos1 <> 0) And (iPos2 > iPos1) Then
      Begin
        // Delete comment
        Delete (TheLine, iPos1, (iPos2-iPos1+Length(ClosingBracket)));
      End // If (iPos1 <> 0) And (iPos2 > iPos1)
      Else If (iPos1 > 0) And (iPos2 = 0) Then
      Begin
        // Error - opening bracket only
        ShowMessage ('Error: Opening Bracket only found on line ' + IntToStr(iCurrentLine) + ':-' + #13#13 + TheLine);
        bError := True;
      End // If (iPos1 > 0) And (iPos2 = 0)
      Else If (iPos1 = 0) And (iPos2 > 0) Then
      Begin
        // Error - closing bracket only
        ShowMessage ('Error: Closing Bracket only found on line ' + IntToStr(iCurrentLine) + ':-' + #13#13 + TheLine);
        bError := True;
      End; // If (iPos1 > 0) And (iPos2 = 0)
    Until bError Or ((iPos1 = 0) And (iPos2 = 0));
  End; // RemoveBrackets

  //------------------------------

begin
  // Check the SQL Columns have been retrieved
  If ((sgColumnInfo.RowCount - 1) > 1) Then
  Begin
    bError := False;
    iCurrentLine := 0;
    While (iCurrentLine < memDelphiRecord.Lines.Count) And (Not bError) Do
    Begin
      sLine := memDelphiRecord.Lines[iCurrentLine];

      RemoveBrackets (sLine, '{', '}');
      If (Not bError) Then
        RemoveBrackets (sLine, '(*', '*)');

      If (Not bError) Then
      Begin
        // Remove any '//' style comments
        iPos := Pos('//', sLine);
        If (iPos > 0) Then
          Delete (sLine, iPos, 255);
      End; // If (Not bError)

      If (Not bError) Then
      Begin
        // Remove any leading/trailing spaces
        sLine := Trim(sLine);

        // Remove any completely blank lines
        If (sLine = '') Then
          memDelphiRecord.Lines.Delete(iCurrentLine)
        Else
        Begin
          // check for ':'
          iPos := Pos(':', sLine);
          If (iPos = 0) Then
          Begin
            // Colon missing
            ShowMessage ('Error: Colon (:) missing on line ' + IntToStr(iCurrentLine) + ':-' + #13#13 + sLine);
            bError := True;
          End // If (iPos = 0)
          Else
          Begin
            // remove any duplicated spaces
            Repeat
              sOrigLine := sLine;
              sLine := StringReplace (sLine, '  ', ' ', [rfReplaceAll]);
            Until (sOrigLine = sLine);

            // Update memo with changes and move onto the next line
            memDelphiRecord.Lines[iCurrentLine] := sLine;
            iCurrentLine := iCurrentLine + 1;
          End; // Else
        End; // Else
      End; // If (Not bError)
    End; // While (iCurrentLine < memDelphiRecord.Lines.Count) And (Not bError)

    //------------------------------

    // If OK then copy the delphi details into the string grid to match up with the SQL columns
    If (Not bError) Then
    Begin
      // Check the number of elements matches the SQL Columns
      If ((sgColumnInfo.RowCount - 1) = memDelphiRecord.Lines.Count) Then
        iCount := memDelphiRecord.Lines.Count
      Else If ((sgColumnInfo.RowCount - 1) > memDelphiRecord.Lines.Count) Then
        iCount := memDelphiRecord.Lines.Count
      Else
        iCount := (sgColumnInfo.RowCount - 1);

      // Copy details into the Record Field column
      For iCurrentLine := 0 To iCount Do
      Begin
        sLine := memDelphiRecord.Lines[iCurrentLine];
        iPos := Pos (':',sLine);
        If (iPos > 0) Then
        Begin
          // Extract field name
          sgColumnInfo.Cells [colDelphiField, iCurrentLine + 1] := Trim(Copy (sLine, 1, iPos-1));

          // Extract Data type - lose any semi-colon
          sgColumnInfo.Cells [colDelphiFieldType, iCurrentLine + 1] := StringReplace(Trim(Copy (sLine, iPos + 1, 255)), ';', '', [rfReplaceAll]);
        End; // If (iPos > 0)
      End; // For iCurrentLine

      If ((sgColumnInfo.RowCount - 1) <> memDelphiRecord.Lines.Count) Then
        ShowMessage ('Error: Row Count Mismatch - SQL Columns = ' + IntToStr((sgColumnInfo.RowCount - 1)) + ', Delphi Record = ' + IntToStr(memDelphiRecord.Lines.Count));
    End; // If (Not bError)
  End // If ((sgColumnInfo.RowCount - 1) > 0)
  Else
    ShowMessage ('The SQL Columns must be retrieved before the Delphi Record Structure can be processed');
end;

procedure TForm1.mnuDeleteSQLColumnsClick(Sender: TObject);
Var
  sFromCode, sToCode : ShortString;
  bLooking, bDelete : Boolean;
  I : Integer;
begin
  //
  sFromCode := UpperCase(InputBox('Delete SQL Columns', 'Enter Column Name for first column to be deleted', ''));
  sToCode := UpperCase(InputBox('Delete SQL Columns', 'Enter Column Name for last column to be deleted', ''));

  ShowMessage ('Delete Columns ' + sFromCode + ' to ' + sToCode + ' inclusively');

  bLooking := True;
  I := 1;
  While (I < sgColumnInfo.RowCount) Do
  Begin
    If (UpperCase(sgColumnInfo.Cells[colColumnName, I]) = sFromCode) Then
    Begin
      // Found start item - delete and mark as deleting
      If (UpperCase(sgColumnInfo.Cells[colColumnName, I]) <> sToCode) Then
        bLooking := False;
      bDelete := True;
    End // If (UpperCase(sgColumnInfo.Cells[colColumnName, I]) = sFromCode)
    Else If (UpperCase(sgColumnInfo.Cells[colColumnName, I]) = sToCode) Then
    Begin
      // Found last item - delete this row and exit the delete section
      bLooking := True;
      bDelete := True;
    End // If (UpperCase(sgColumnInfo.Cells[colColumnName, I]) = sToCode)
    Else
      bDelete := Not bLooking;

    If bDelete Then
    Begin
      THackStringGrid(sgColumnInfo).DeleteRow(I);
//      sgColumnInfo.Cells[colColumnName, I] := '*** DELETE ***';
//      I := I + 1;
    End // If bDelete
    Else
      I := I + 1;
  End; // While (I < sgColumnInfo.RowCount)
end;

procedure TForm1.btnOneOffClick(Sender: TObject);
//Const
//  VATType : Array [1..24] of String = ('Standard',
//                                       'Exempt',
//                                       'Zero',
//                                       'Rate1',
//                                       'Rate2',
//                                       'Rate3',
//                                       'Rate4',
//                                       'Rate5',
//                                       'Rate6',
//                                       'Rate7',
//                                       'Rate8',
//                                       'Rate9',
//                                       'Rate10',
//                                       'Rate11',
//                                       'Rate12',
//                                       'Rate13',
//                                       'Rate14',
//                                       'Rate15',
//                                       'Rate16',
//                                       'Rate17',
//                                       'Rate18',
//                                       'IAdj',
//                                       'OAdj',
//                                       'Spare8');

Const
  CISTaxType : Array [1..11] of String = ('Construct',
                                          'Technical',
                                          'CISRate1',
                                          'CISRate2',
                                          'CISRate3',
                                          'CISRate4',
                                          'CISRate5',
                                          'CISRate6',
                                          'CISRate7',
                                          'CISRate8',
                                          'CISRate9');

Var
  //EmployeeNom : Array[1..6,False..True] of LongInt;
  I : Integer;
begin
  memGeneratedCode.Clear;

    // System Setup - VAT Record
//  With memGeneratedCode.Lines Do
//  Begin
//    For I := Low(VATType) To High(VATType) Do
//    Begin
//      Add('VAT[' + VATType[I] + '].Code : Char;');
//      Add('VAT[' + VATType[I] + '].Desc : String[10];');
//      Add('VAT[' + VATType[I] + '].Rate : Real;');
//      Add('VAT[' + VATType[I] + '].Spare : Byte;');
//      Add('VAT[' + VATType[I] + '].Include : Boolean;');
//      Add('VAT[' + VATType[I] + '].Spare2 : Array [1..2] of Byte;');
//    End; // For I
//  End; // With memGeneratedCode

  // System Setup - Currency Record
//  With memGeneratedCode.Lines Do
//  Begin
//    For I := 0 To 30 Do
//    Begin
//      Add ('Currencies[' + IntToStr(I) + '].SSymb : String[3];');
//      Add ('Currencies[' + IntToStr(I) + '].Desc  : String[11];');
//      Add ('Currencies[' + IntToStr(I) + '].CRates[False] : Real;');
//      Add ('Currencies[' + IntToStr(I) + '].CRates[True] : Real;');
//      Add ('Currencies[' + IntToStr(I) + '].PSymb :  String[3];');
//    End; // For I
//  End; // With memGeneratedCode

  // System Setup - Job Costing - determine what order the array cells in a 2D are stored in memory
  //EmployeeNom : Array[1..6,False..True] of LongInt;
//  With memGeneratedCode.Lines Do
//  Begin
//    Add ('[1,False]: ' + IntToStr(LongInt(@EmployeeNom[1, False])));
//    Add ('[1,True]: ' + IntToStr(LongInt(@EmployeeNom[1, True])));
//    Add ('[2,False]: ' + IntToStr(LongInt(@EmployeeNom[2, False])));
//    Add ('[2,True]: ' + IntToStr(LongInt(@EmployeeNom[2, True])));
//  End; // With memGeneratedCode

  // System Setup - Form Definition Sets
//  With memGeneratedCode.Lines Do
//  Begin
//    For I := 1 To 120 Do
//      Add ('PrimaryForm[' + IntToStr(I) + '] : String[8];');
//  End; // With memGeneratedCode


  // System Setup - CIS Settings
  With memGeneratedCode.Lines Do
  Begin
    For I := Low(CISTaxType) To High(CISTaxType) Do
    Begin
      Add ('CISRate[' + CISTaxType[I] + '].Code : Char;');
      Add ('CISRate[' + CISTaxType[I] + '].Desc : String[10];');
      Add ('CISRate[' + CISTaxType[I] + '].Rate : Double;');
      Add ('CISRate[' + CISTaxType[I] + '].GLCode : LongInt;');
      Add ('CISRate[' + CISTaxType[I] + '].RCCDep[False] : String[3];');
      Add ('CISRate[' + CISTaxType[I] + '].RCCDep[True] : String[3];');
      Add ('CISRate[' + CISTaxType[I] + '].Spare : Array[1..10] of Byte;');
    End; // For I
  End; // With memGeneratedCode
end;

procedure TForm1.BuildConnectionStringBtnClick(Sender: TObject);
const
  BaseStr = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=%s;Data Source=%s';
var
  ConnStr: string;
begin
  ConnStr := Format(BaseStr, [DatabaseTxt.Text, ServerTxt.Text]);
  edtConnectionString.Text := ConnStr;
end;

end.

