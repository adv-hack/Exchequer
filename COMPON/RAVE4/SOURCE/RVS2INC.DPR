program RVS2INC;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

var
  IncList1: TStringList;
  IncList2: TStringList;
  I1: integer;

  function CutWord(var Value: string;
                   var SepCh: char;
                       SepStr: string): string;

  var
    I1: integer;
    CutLen: integer;
    NoSep: boolean;

  begin { CutWord }
  { Find first occurrence of SepStr characters }
    CutLen := -1;
    SepCh := #0;
    I1 := 0;
    NoSep := false;
    While I1 < Length(Value) do begin
      Inc(I1);
      If Value[I1] = '<' then begin
        NoSep := true;
      end else if Value[I1] = '>' then begin
        NoSep := false;
      end else if not NoSep then begin
        If Pos(Value[I1],SepStr) > 0 then begin { Found separator }
          SepCh := Value[I1];
          CutLen := I1 - 1;
          Break;
        end; { if }
      end; { else }
    end; { while }

    If CutLen >= 0 then begin
      If CutLen = 0 then begin
        Result := '';
      end else begin
        Result := Trim(Copy(Value,1,CutLen));
      end; { else }
      Delete(Value,1,CutLen + 1);
      Value := Trim(Value);
    end else begin
      Result := Trim(Value);
      Value := '';
    end; { else }
  end;  { CutWord }

  function StripTypes(ParamList: string): string;

  var
    SepCh: char;
    Item: string;

  begin { StripTypes }
    Result := '';
    Repeat
      Item := Trim(CutWord(ParamList,SepCh,',:;'));
      If Pos(' ',Item) > 0 then begin // Remove var & const
        Delete(Item,1,Pos(' ',Item));
        Item := Trim(Item);
      end; { if }
      If Result = '' then begin
        Result := Item;
      end else begin
        Result := Result + ',' + Item;
      end; { else }
      If SepCh = ':' then begin // Remove type
        CutWord(ParamList,SepCh,';');
      end; { if }
    until ParamList = '';
  end;  { StripTypes }

  procedure AddFunction(FuncItem: string;
                        CodeItem: string;
                        ModuleName: string);

  var
    SepCh: char;
    FuncName: string;
    FixedName: string;
    ParamList: string;
    ParamListAdd: string;
    StrippedParams: string;
    ResultType: string;
    S1: string;
    I1: integer;
    CompName: string;
    BaseFuncName: string;
    IsSetter: boolean;

  begin { AddFunction }
    FuncName := CutWord(FuncItem,SepCh,'(:;');
    ParamList := '';
    StrippedParams := '';
    ResultType := '';
    If SepCh = '(' then begin
      ParamList := CutWord(FuncItem,SepCh,')');
      StrippedParams := StripTypes(ParamList);
      CutWord(FuncItem,SepCh,':;');
    end; { if }
    If SepCh = ':' then begin
      ResultType := CutWord(FuncItem,SepCh,';');
    end; { if }
    If SepCh = ';' then begin

    // Look for ClassName.FuncName or plain FuncName
      IsSetter := false;
      I1 := Pos('.',FuncName);
      If I1 = 0 then begin // plain FuncName
        FixedName := 'Rave' + FuncName; // Probably same as Delphi name, add Rave
        CompName := '';
        BaseFuncName := FuncName;
        ParamListAdd := '';
      end else begin // ClassName.FuncName
        FixedName := FuncName;
        FixedName[I1] := '_';
        CompName := Copy(FuncName,1,I1 - 1);
        BaseFuncName := Copy(FuncName,I1 + 1,Length(FuncName) - I1);
        If SameText(Copy(BaseFuncName,1,3),'Get') and (ResultType <> '') and
         (ParamList = '') then begin
          Delete(BaseFuncName,1,3);
        end else if SameText(Copy(BaseFuncName,1,3),'Set') and
         SameText(StrippedParams,'Value') then begin
          Delete(BaseFuncName,1,3);
          IsSetter := true;
        end; { if }
        If ParamList = '' then begin
          ParamListAdd := 'RaveSelf:' + CompName;
        end else begin
          ParamListAdd := 'RaveSelf:' + CompName + ';';
        end; { else }
      end; { else }

     // Build CodeItem if it is blank
      If CodeItem = '' then begin
        If ResultType <> '' then begin
          CodeItem := 'Result:=';
        end; { if }
        If CompName <> '' then begin
          CodeItem := CodeItem + 'RaveSelf.'
        end; { else }
        CodeItem := CodeItem + BaseFuncName;
        If ParamList <> '' then begin
          If IsSetter then begin
            CodeItem := CodeItem + ':=';
          end else begin
            CodeItem := CodeItem + '(';
          end; { else }
          CodeItem := CodeItem + StrippedParams;
          If not IsSetter then begin
            CodeItem := CodeItem + ')';
          end; { if }
          CodeItem := CodeItem + ';';
        end; { if }
      end; { if }

    // Build first line of source
      If ResultType = '' then begin
        S1 := 'procedure ';
      end else begin
        S1 := 'function ';
      end; { else }
      S1 := S1 + FixedName;
      If (ParamListAdd + ParamList) <> '' then begin
        S1 := S1 + '(' + ParamListAdd + ParamList + ')';
      end; { if }
      If ResultType <> '' then begin
        S1 := S1 + ':' + ResultType;
      end; { if }
      S1 := S1 + ';pascal;begin ' + CodeItem + ' end;';

    // Remove unnecessary spaces
      I1 := 10; // Skip initial "procedure" or "function"
      While I1 < (Length(S1) - 1) do begin
        Inc(I1);
        If S1[I1] = ' ' then begin
          If (UpCase(S1[I1 - 1]) in ['0'..'9','A'..'Z']) and
           (UpCase(S1[I1 + 1]) in ['0'..'9','A'..'Z']) then Continue;
          Delete(S1,I1,1);
          Dec(I1);
        end; { if }
      end; { while }

    // Add first line of source
      IncList1.Add('  ' + S1);

    // Build and add second line of source
      IncList2.Add('    (A:@' + FixedName + ';B:''' + UpperCase(FuncName) +
       ''';C:''' + UpperCase(ModuleName) + ''')');
    end; { if }
  end;  { AddFunction }

  procedure Convert(FromPath: string;
                    FileName: string);

  var
    InFile: text;
    Line: string;
    SepCh: char;
    Item: string;
    FuncItem: string;
    CodeItem: string;
    I1: integer;

  begin { Convert }
    AssignFile(InFile,FromPath + FileName + '.RVS');
    Reset(InFile);
    While not SeekEOF(InFile) do begin
      Readln(InFile,Line);
      If SameText(Line,'IMPLEMENTATION') then Break;
    end; { while }

    While not SeekEOF(InFile) do begin
      Readln(InFile,Line);
      Item := CutWord(Line,SepCh,' ');
      If SameText(Item,'function') then begin
        I1 := Pos('; external;',Line);
        If I1 > 0 then begin
          FuncItem := Copy(Line,1,I1);
          Delete(Line,1,I1 + 10);
          Line := Trim(Line);
          If (Length(Line) >= 2) and (Line[1] = '/') and (Line[2] = '/') then begin
            Delete(Line,1,2);
            CodeItem := Trim(Line);
          end else begin
            CodeItem := ''; // CodeItem will be built
          end; { else }
          AddFunction(FuncItem,CodeItem,FileName);
        end; { if }
      end; { if }
    end; { while }
    CloseFile(InFile);
  end;  { Convert }

  procedure ConvertFiles(FileSpec: string);

  var
    SearchRec: TSearchRec;
    ErrCode: integer;
    FromPath: string;

  begin { ConvertFiles }
    FromPath := ExtractFilePath(FileSpec);
    ErrCode := FindFirst(FileSpec,faArchive,SearchRec);
    While ErrCode = 0 do begin
      Writeln('Converting ',SearchRec.Name);
      Convert(FromPath,Copy(SearchRec.Name,1,Pos('.',SearchRec.Name) - 1));
      ErrCode := FindNext(SearchRec);
    end; { while }
    FindClose(SearchRec);
  end;  { ConvertFiles }

  procedure OutputIncFile;

  var
    OutFile: text;
    I1: integer;

  begin { OutputIncFile }
    Assign(OutFile,'RVLESys.inc');
    Rewrite(OutFile);
    Writeln(OutFile,'(* This file is automatically generated by RVS2INC.');
    Writeln(OutFile,'   Do not modify or changes will be lost! *)');
    Writeln(OutFile);
    For I1 := 0 to IncList1.Count - 1 do begin
      Writeln(OutFile,IncList1[I1]);
    end; { for }
    Writeln(OutFile);
    Writeln(OutFile,'const');
    Writeln(OutFile,'  RaveFuncItemCount = ' + IntToStr(IncList2.Count) + ';');
    Writeln(OutFile);
    Writeln(OutFile,'var');
    Writeln(OutFile,'  {TransOff}');
    Writeln(OutFile,'  RaveFuncItems: array[1..RaveFuncItemCount] of TRaveFuncItem = (');
    For I1 := 0 to IncList2.Count - 1 do begin
      If I1 = (IncList2.Count - 1) then begin
        Writeln(OutFile,IncList2[I1]);
      end else begin
        Writeln(OutFile,IncList2[I1] + ',');
      end; { else }
    end; { for }
    Writeln(OutFile,'  );');
    Writeln(OutFile,'  {TransOn}');
    Close(OutFile);
  end;  { OutputIncFile }

begin
  If ParamCount = 0 then begin
    Writeln('usage: RVS2INC filespec [filespec]');
  end else begin
    IncList1 := TStringList.Create;
    IncList2 := TStringList.Create;
    try
      For I1 := 1 to ParamCount do begin
        ConvertFiles(ParamStr(I1));
      end; { for }
      OutputIncFile;
    finally
      IncList1.Free;
      IncList2.Free;
    end; { tryf }
  end; { if }
end.