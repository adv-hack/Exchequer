unit helpgen;

interface

uses
  TreeObj,Classes, ComObj, Dialogs, Forms;

const
  propReadOnly = 1;
  propReadWrite = 0;

  ROBmpName = 'ro.bmp';
  RWBmpName = 'rw.bmp';

type
  THelpGenerator = Class
   private
    FTopicList, FInterfaceList, FHeaderList, FContentsList : TStringList;
    FuncList, CommonList, ParamList, EnumList, FArrayList : TStringList;
    V : Variant;
    FDebug : Boolean;
    FirstHeader : Boolean;
    FProgressForm : TForm;
    FCancelled : Boolean;
    CommonListFile : string;
    WordOpen : Boolean;
    procedure FPageHeader(const s : string);
    procedure FAddContentsMember(const s, Href, AParent : string);
    procedure FAddTopic(const s, Href, tp, doc : string);
    procedure Delay(t : longint);
    procedure GetParams(const ARef : string; Params : TStringList);
    function IsGetFunction(const s : string) : integer;
    procedure ReturnValue(const s : string);
   public
    constructor Create;
    destructor Destroy; override;
    procedure InitialiseRTF;
    procedure SaveRTF(const AFileName : string);
    procedure PageBreak;
    procedure AddToTopicList(const s, Href, Tp, doc : string);
    procedure AddToFunctionList(const s, Href, ParentName : string);
    function GetPosition : longint;
    procedure SetPosition(value : longint);
    procedure PageHeader(const s : string);
    procedure AddContentsMember(const s, Href, ParentName : string;
                                  ik : byte);
    procedure AddTopic(const s, Href : string);
    function KnownInterface(const s : string) : boolean;
    procedure ParseLine(const s : string;
                           var s1, s2, s3 : string);
    procedure ParseLine4(const s : string;
                           var s1, s2, s3, s4 : string);
    procedure WriteFile;
    procedure WriteLine(const s : string);
    procedure InitializeCommonList;
    function IsCommon(const s : string) : Boolean;
    procedure Progress(const s : string);
    procedure SetTable(p1, p2 : longint);
    procedure SetBanner(p1, p2, p3 : longint);
    function GetParentStr(const s : string) : string;
    function GetFuncStr(const s : string) : string;
    function GetContentsType(const s : string) : string;
    procedure AddToParamList(const s : string);
    Procedure AddEnum(const s : string);
    procedure WriteEnumTopics;
    function EnumName(const EnumType : string; Value : Variant) : string;
    function EnumOwner(const EnumType : string) : string;
    procedure Cancel;
    function IsReadOnly(const AName, AParent : string) : Boolean;
    procedure AddToArrayList(const Arr : string);
    property ProgressForm : TForm read FProgressForm write FProgressForm;
  end;

implementation

uses
  SysUtils, Windows;

const
  RoSize   = 8;
  TextSize = 10;
  HeadSize = 12;
  PageHeadSize = 18;

  ColWidth = 175;

  FontName = 'Arial';

constructor THelpGenerator.Create;
begin
  inherited Create;
  WordOpen := False;
  FTopicList := TStringList.Create;
  FTopicList.Sorted := True;
  FInterfaceList := TStringList.Create;
  FInterfaceList.Sorted := True;
  FHeaderList := TStringList.Create;
  FContentsList := TStringList.Create;
  FContentsList.Sorted := True;
  ParamList := TStringList.Create;
  //ParamList.Sorted := True;
  FDebug := True;
  FirstHeader := True;
  FCancelled := False;

  FuncList := TStringList.Create;
  FuncList.Sorted := True;
  CommonList := TStringList.Create;
  CommonList.Sorted := True;

  EnumList := TStringList.Create;
  EnumList.Sorted := False;

  FArrayList := TStringList.Create;
  FArrayList.Sorted := True;

  CommonListFile := 'd:\rtf\commonlist.txt';

  InitializeCommonList;

end;

destructor THelpGenerator.Destroy;
begin   
  if FDebug then
  begin
{$IFDEF AllowHelp}
    FTopicList.SaveToFile('d:\topics.txt');
    FContentsList.SaveToFile('d:\contents.txt');
    FHeaderList.SaveToFile('d:\headers.txt');
    FInterfaceList.SaveToFile('d:\interface.txt');
    FuncList.SaveToFile('d:\functions.txt');
    ParamList.SaveToFile('d:\params.txt');
    EnumList.SaveToFile('d:\enum.txt');
    FArrayList.SaveToFile('d:\arrays.txt');
{$ENDIF}
  end;
  if Assigned(FTopicList) then
    FTopicList.Free;
  if Assigned(FInterfaceList) then
    FInterfaceList.Free;
  if Assigned(FHeaderList) then
    FHeaderList.Free;
  if Assigned(FContentsList) then
    FContentsList.Free;
  if Assigned(FuncList) then
    FuncList.Free;
  if Assigned(CommonList) then
    CommonList.Free;
  if Assigned(ParamList) then
    ParamList.Free;
  if Assigned(FArrayList) then
    FArrayList.Free;
  if WordOpen then
    V.AppClose;
  inherited Destroy;
end;

procedure THelpGenerator.InitialiseRTF;
begin
{$IFDEF AllowHelp}
  V := CreateOLEObject('Word.Basic');
  V.FileNew;
  V.Font(FontName);
  WordOpen := True;
{$ENDIF}
end;

procedure THelpGenerator.SaveRTF(const AFileName : string);
begin
{$IFDEF AllowHelp}
  WriteFile;
  V.FileSaveAs(AFilename, 6);
  V.AppClose;
  WordOpen := False;
{$ENDIF}

end;

procedure THelpGenerator.FPageHeader(const s : string);
var
  p1, p2, p3 : longint;
begin
  if FirstHeader then
    FirstHeader := False
  else
    V.InsertBreak(0);

  V.InsertFootnote('>',1);
  V.Insert('main');
  V.ClosePane;

      p1 := V.GetSelStartPos;
{      V.InsertPara;}
      V.Font(FontName);
      V.FontSize(PageHeadSize);
      V.Bold(1);
      V.Insert(s + ' Interface');
      V.Bold(0);
      V.InsertFootnote('#',1);
      V.Insert('_' + s);
      V.ClosePane;

      V.InsertFootnote('K',1);
      V.Insert(s);
      V.ClosePane;

      V.InsertFootnote('$',1);
      V.Insert(s + ' Interface');
      V.ClosePane;

     { WriteLine('');}
      V.InsertPara;
      V.Font(FontName);
      V.FontSize(TextSize);
      V.DoubleUnderline(1);
      V.Bold(1);
      V.Insert('Object Model');
      V.Bold(0);
      V.DoubleUnderline(0);
      V.Hidden(1);
      V.Insert('_ObjectModel');
      V.Insert(Char(9)+Char(9));
      V.Hidden(0);
    {  V.InsertPara;}
      P2 := V.GetSelStartPos;
      V.InsertPara;
      P3 := V.GetSelStartPos;
{  V.SetSelRange(P1, P2);
  V.ParaKeepWithNext(1);
  V.SetSelRange(P3, P3);
  V.ParaKeepWithNext(0);}
     SetBanner(p1,p2, p3);



end;

procedure THelpGenerator.FAddContentsMember(const s, Href, AParent : string);
var
  i : integer;
  j, j1 : longint;
  WantPopup : Boolean;
  tp : string;
begin
    tp := GetContentsType(s + ',' + HRef);
    if ((tp[1] = 'I') and (tp <> 'Integer')) or
      (Copy(tp, 1, 4) = 'Func') then
        WantPopup := False
    else
      WantPopup := True;

    if IsReadOnly(s, AParent) then
      V.Insert('{bmct ' + ROBmpName + '}')
    else
      V.Insert('{bmct ' + RWBmpName + '}');

    V.Font(FontName);
    V.FontSize(TextSize);
    V.Bold(0);
    if WantPopup then
      V.DottedUnderline(1)
    else
      V.DoubleUnderline(1);
    V.Insert(s);
    if WantPopup then
      V.DottedUnderline(0)
    else
      V.DoubleUnderline(0);
    V.Hidden(1);
    V.Insert(Href);
    V.Hidden(0);
    V.Insert(Char(9));
end;

procedure THelpGenerator.FAddTopic(const s, Href, tp, doc : string);
var
  IsInterface : Boolean;
  ParentStr : string;
  FuncStr : string;
  P1, P2, P3  : longint;
  WantPopup : Boolean;
  PHeaderText : Integer;
  PList : TSTringList;
  i, j : integer;
  IsMethod : Boolean;
  IsProcedure : Boolean;
  tp1, s1 : string;

  procedure Highlight(const s : string);
  begin
      if s[1] = 'T' then
      begin
        V.DoubleUnderline(1);
        V.Insert(s);
        V.DoubleUnderline(0);
        V.Hidden(1);
        V.Insert('Enum_' + s);
        V.Hidden(0);
      end
      else
      if (s[1] = 'I') and (s <> 'Integer') then
      begin
        V.DoubleUnderline(1);
        V.Insert(s);
        V.DoubleUnderline(0);
        V.Hidden(1);
        V.Insert('_' + s);
        V.Hidden(0);
      end
      else
        V.Insert(s);
  end;


  procedure InsertParameters;
  var
    j, k : integer;
    ps, ps1  : string;
  begin
    if PList.Count > 0 then
    begin
      if (WantPopup) or (FuncStr = 'Property') then
        V.Insert('  [')
      else
        V.Insert(' (');
      for j := 0 to PList.Count - 1 do
      begin
        ps := PList[j];
        k := Pos(' :', ps);
        if k > 0 then
        begin
          ps1 := Copy(ps, k + 3, Length(ps));
          Delete(ps, k, Length(ps));
        end;
        if (Pos(' v', ps1) > 0) then
        begin
          Delete(ps1, Length(ps1) - 1, 2);
          V.Bold(1);
          V.Insert('var');
          V.Bold(0);
          V.Insert(' ');
        end;
        V.Insert(ps);
        V.Insert(' : ');

        Highlight(ps1);

        if j < PList.Count - 1 then
          V.Insert('; ');
      end;
      if WantPopup or (FuncStr = 'Property') then
        V.Insert(']')
      else
        V.Insert(')');
    end;
  end;


  procedure InsertType;
  var
    s1 : string;
  begin
    if not IsMethod then
    begin
{      if (tp[1] = '@') then
        V.Insert('[..]'); }
      InsertParameters;
      if Plist.Count > 0 then
        V.Insert(' : ')
      else
        V.Insert('  : ');
      if tp[1] = '@' then
        s1 := Copy(tp, 2, Length(tp))
      else
        s1 := tp;

      Highlight(s1);

    end;
  end;

begin
  IsInterface := False;
  PList := TStringList.Create;
  GetParams(HRef, PList);
  IsMethod := (Pos('Function', tp) = 1) or (Pos('@Function', tp) = 1);

  IsProcedure := (Pos(':', tp) = Length(tp) - 1);

  WantPopup := False;
  PHeaderText := PageHeadSize;

  i := Pos(':', tp);
  if i <> 0 then
    tp1 := Copy(tp, i + 2, Length(tp))
  else
    tp1 := tp;

  if Length(tp1) > 0 then if(tp1[1] = 'I') and (tp1 <> 'Integer') then
    IsInterface := True
  else
    IsInterface := False;

  If not IsInterface and not IsMethod then
  begin
    WantPopup := True;
    PHeaderText := TextSize;
  end;

  ParentStr := GetParentStr(HRef);
  FuncStr := GetFuncStr(HRef);
  if FuncStr = 'Method' then
    FuncStr := 'Function';
  V.InsertBreak(0);
  P1 := V.GetSelStartPos;

  if not WantPopup then
  begin
    V.InsertFootnote('>',1);
    V.Insert('main');
    V.ClosePane;
  end;

 { V.InsertPara;}
  V.Bold(1);
  V.Font(FontName);
  V.FontSize(PHeaderText);
  if ParentStr <> 'Common' then
    V.Insert(ParentStr + '.');
  V.Insert(s);

  if Not WantPopup and IsReadOnly(s, ParentStr) then
  begin
    V.Font(FontName);
    V.FontSize(RoSize);
    V.Insert('  (Read-Only)');
  end;


  V.Font(FontName);
  V.FontSize(TextSize);
  V.InsertFootnote('#',1);
  V.Insert(HRef);
  V.ClosePane;

  V.InsertFootnote('$',1);
  V.Insert(s);
  V.ClosePane;

  if Not WantPopup  and (FuncStr <> 'Property') then
  begin
   { V.InsertFootnote('K',1);
    V.Insert(s);
    V.ClosePane;}

    V.InsertFootnote('K',1);
    if ParentStr = 'Common' then
      V.Insert(s)
    else
    begin
      V.Insert(ParentStr + ';');
      V.Insert(ParentStr + ': ' + s + ';');
    end;
    V.ClosePane;
  end;

  V.Underline(0);
  if WantPopup then
  begin
    InsertType;
    if IsReadOnly(s, ParentStr) then
    begin
      V.Font(FontName);
      V.FontSize(RoSize);
      V.Insert('  (Read-Only)');
    end;

    if Doc <> '' then
    begin
{      WriteLine('');}
      V.InsertPara;
      V.Bold(0);
      V.Font(FontName);
      V.FontSize(TextSize);
      V.Insert(Doc);
    end;


  end
  else
  begin
    if FuncStr = 'Function' then
      V.Insert('  Method');
  {  V.InsertPara;}
    if (ParentStr <> 'Common') then
    begin
      V.InsertPara;
      V.Font(FontName);
      V.FontSize(TextSize);
      V.DoubleUnderline(1);
      V.Bold(1);
      V.Insert(ParentStr);
      V.Bold(0);
      V.DoubleUnderline(0);
      V.Hidden(1);
      V.Insert('_' + ParentStr);
      V.Hidden(0);
    end;

    P2 := V.GetSelStartPos;

    V.InsertPara;
{    P3 := V.GetSelStartPos;}
    //set non-scrolling region
    V.SetSelRange(P1, P2);
    V.ParaKeepWithNext(1);
{    V.SetSelRange(P3, P3);}
    V.SetSelRange(0, 0);

    V.EndOfDocument;

{    V.InsertPara;}
{    WriteLine('');}
    p1 := V.GetSelStartPos;
    V.Bold(1);
    V.Font(FontName);
    V.FontSize(TextSize);

    if Doc <> '' then
    begin
      V.Bold(0);
      V.Font(FontName);
      V.FontSize(TextSize);
      V.Insert(Doc);
      V.InsertPara;
    end;
    V.Bold(0);
    V.InsertPara;
    V.Insert(Char(9));
    if not IsProcedure then
      V.Insert(FuncStr + ' ')
    else
      V.Insert('Procedure ');
    V.Bold(0);
    V.Insert(s);
    InsertParameters;
{    if tp <> 'Function' then}
    begin
{      if (tp[1] = '@') then
        V.Insert('[..]');}
      if not IsProcedure then
        V.Insert(' : ');
      
    end;
    If IsInterface then
    begin
      V.DoubleUnderline(1);
      V.Bold(1);
      V.Insert(tp1);
      V.Bold(0);
      V.DoubleUnderline(0);
      V.Hidden(1);
      V.Insert('_' + tp1);
      V.Hidden(0);
    end
    else
    begin
      if Length(tp1) > 0 then
      begin
        if tp1[1] = '@' then
          V.Insert(Copy(tp1, 2, Length(tp1)))
        else
          V.Insert(tp1);
      end;
    end;




    V.InsertPara;
    WriteLine('');
    V.Font(FontName);
    V.Bold(1);
    V.Insert('Description');
    V.Bold(0);
    V.InsertPara;

    if IsReadOnly(s, ParentStr) then
      V.Insert('  (Read only)');



  if PList.Count > 0 then
  begin
    V.InsertPara;
    WriteLine('');
    V.Font(FontName);
    V.Bold(1);
    V.Insert('Parameters');
    V.Bold(0);
    V.InsertPara;
    for i := 0 to PList.Count - 1 do
    begin
      V.Italic(1);
      s1 := PList[i];
{      if s1[Length(s1)] = 'v' then
        Delete(s1, Length(s1)-1, 2);}
      j := Pos(' :', s1);
      if j > 0 then
        Delete(s1, j, Length(s1));
      V.Insert(s1);
      V.Italic(0);
      V.InsertPara;
    end;
  end;

  if not IsProcedure and not IsInterface then
  begin
    ReturnValue(s);
  end;


    V.InsertPara;
    WriteLine('');
    V.Font(FontName);
    V.Bold(1);
    V.Insert('Notes');
    V.InsertPara;
    p2 := V.GetSelStartPos;
    V.SetSelRange(p1, p2);
    V.ParaKeepWithNext(0);

    V.SetSelRange(0, 0);
    V.EndOfDocument;

  end;



end;

procedure THelpGenerator.PageBreak;
begin
  V.InsertBreak(0);
end;

procedure THelpGenerator.AddToTopicList(const s, HRef, Tp, doc : string);
var
  s1 : string;
  i : integer;
  Found : Boolean;
begin
  s1 := s + ',' + HRef;
  i := 0;
  Found := False;
  while (i < FTopicList.Count) and not Found do
  begin
    Application.processMessages;

    if Pos(s1, FTopicList[i]) > 0 then
      Found := True
    else
      inc(i);
  end;

  if not Found then
  begin
    s1 := s1 + ',' + Tp;
    if doc <> '' then
      s1 := s1 + ',' + doc;
    if FTopicList.IndexOf(s1) = -1 then
      FTopicList.Add(s1);
  end;
end;



function THelpGenerator.KnownInterface(const s : string) : boolean;
begin
  Result := FInterfaceList.IndexOf(s) <> -1;
end;

function THelpGenerator.GetPosition : longint;
begin
  Result := V.GetSelStartPos;
end;

procedure THelpGenerator.SetPosition(value : longint);
begin
  V.SetSelRange(Value, Value);
end;

procedure THelpGenerator.ParseLine(const s : string;
                                      var s1, s2, s3 : string);
var
  i, j, k : integer;
  len : integer;
begin
  s1 := '';
  s2 := '';
  s3 := '';
  Len := Length(s);
  if Len > 0 then
  begin
    i := 1;
    while (i < Len) and (s[i] <> ',') do inc(i);
    s1 := Copy(s, 1, i-1);
    if i < Len then
    begin
      inc(i);
      j := i;
      while (i < Len) and (s[i] <> ',') do inc(i);
      s2 := Copy(s, j, i - j);
      if i < len then
      begin
        inc(i);
        j := i;
        while (i < Len) and (s[i] <> ',') do inc(i);
        if i < Len then
          s3 := Copy(s, j, i - j)
        else
          s3 := Copy(s, j, i - j + 1);
      end;
    end;
  end;
end;

procedure THelpGenerator.ParseLine4(const s : string;
                                      var s1, s2, s3, s4 : string);
var
  i, j, k : integer;
  len : integer;
begin
  s1 := '';
  s2 := '';
  s3 := '';
  s4 := '';
  Len := Length(s);
  if Len > 0 then
  begin
    i := 1;
    while (i < Len) and (s[i] <> ',') do inc(i);
    s1 := Copy(s, 1, i-1);
    if i < Len then
    begin
      inc(i);
      j := i;
      while (i < Len) and (s[i] <> ',') do inc(i);
      s2 := Copy(s, j, i - j);
      if i < len then
      begin
        inc(i);
        j := i;
        while (i < Len) and (s[i] <> ',') do inc(i);
        if i < Len then
          s3 := Copy(s, j, i - j)
        else
          s3 := Copy(s, j, i - j + 1);

        if i < len then
        begin
          inc(i);
          j := i;
          while (i < Len) {and (s[i] <> ',')} do inc(i);
          s4 := Copy(s, j, i - j + 1);
        end;
      end;
    end;
  end;
end;


procedure THelpGenerator.PageHeader(const s : string);
begin
  FHeaderList.Add(s);
  if not KnownInterface(s) then
    FInterfaceList.Add(s);

end;

procedure THelpGenerator.AddContentsMember(const s, Href, ParentName : string;
                                           ik : Byte);
var
  s1, s2 : string;
  i : integer;
  j : longint;
  Found : Boolean;
begin
  Found := False;
  s1 := ParentName;
  i := Pos('[', s1);
  if i > 0 then
    Delete(s1, i, Length(s1));


  s1 := s1 + ',' + HRef + ',' + s;
  i := 0;
  while (i < FContentsList.Count) and not Found do
  begin
    Application.ProcessMessages;
    s2 := FContentsList[i];
    if (Pos(s, s2) > 0) and (Pos(ParentName + ',', s2) > 0) then
      Found := True
    else
      inc(i);
  end;

  if not Found then
  begin
   j := propReadOnly or (ik and 2); {gives us ro & get = 3, ro & put = 1, rw & get = 2, rw & put = 0}
   FContentsList.AddObject(s1, TObject(j));
  end
  else
  begin
    j := longint(FContentsList.Objects[i]);
    if (j and propReadOnly) = 0 then
    begin
      {already rw so don't do anything}
    end
    else
    if (j and 2) = (ik and 2) then
    begin
      {same invokekind so don't do anything}
    end
    else
    begin
      j := propReadWrite or (ik and 2);
      FContentsList.Objects[i] := TObject(j);
    end;
  end;
end;

procedure THelpGenerator.AddToFunctionList(const s, Href, ParentName : string);
var
  s1 : string;
  i : integer;
begin
  s1 := ParentName;
  i := Pos('[', s1);
  if i > 0 then
    Delete(s1, i, Length(s1));

  FuncList.Add(s1 + ',' + HRef + ',' + s);
end;

procedure THelpGenerator.AddTopic(const s, Href : string);
begin
end;

procedure THelpGenerator.WriteFile;
var
  i, j, k : integer;
  ThisParent : String;
  AParent, AHRef, AName, Doc : string;
  p1, p2, p3, p4, p5 : longint;
  sr : string;
  TotalTopics : integer;
  OrderedList : TStringList;
begin
  //V.AppShow;
  V.ViewNormal;// if not in normal view can't insert breaks
  OrderedList := TStringList.Create;
  OrderedList.Sorted := True;
  TotalTopics := FTopicList.Count;
  Progress('Starting rtf file...');
  for i := 0 to FHeaderList.Count - 1 do
  begin
    Progress('Header: ' + FHeaderList[i]);
    FPageHeader(FHeaderList[i]);
    Application.ProcessMessages;
    ThisParent := FHeaderList[i];
    j := 0;
    while (j < FContentsList.Count) and
          (Pos(ThisParent + ',',FContentsList[j]) <> 1) do
    begin
      Application.ProcessMessages;
      inc(j);
    end;

    if j < FContentsList.Count then
    begin
    //Properties
     OrderedList.Clear;
     V.InsertPara;
     V.Underline(0);
     V.Font(FontName);
     V.Bold(1);
     V.Insert('Properties' + '  ( {bmct ro.bmp} - Read only )');
    WriteLine('');
     V.Font(FontName);
     V.FontSize(TextSize);
     V.Bold(0);
 {    V.InsertPara;}
{     WriteLine();
     V.InsertPara;}

     p1 := V.GetSelStartPos;

     while (j < FContentsList.Count) and
          (Pos(ThisParent + ',',FContentsList[j]) = 1) do
     begin
       ParseLine(FContentsList[j], AParent, AHRef, AName);
       OrderedList.Add(AName + ',' + AHRef + ',' + AParent);
       Application.ProcessMessages;
       inc(j);
     end;

     for j := 0 to OrderedList.Count - 1 do
     begin
       ParseLine(OrderedList[j], AName, AHRef, AParent);
       FAddContentsMember(AName, AHRef, AParent);
       Progress('Writing properties: ' + IntToStr(j));
       Application.ProcessMessages;
       if FCancelled then
       begin
        ShowMessage('Process Cancelled');
        Break;
       end;
     end;

    if FCancelled then
      Exit;


     V.InsertPara;
     p2 := V.GetSelStartPos;
     V.InsertPara;
     SetTable(p1, p2);
    end;

    //functions
    j := 0;
    while (j < FuncList.Count) and
          (Pos(ThisParent + ',',FuncList[j]) <> 1) do
    begin
      Application.ProcessMessages;
      inc(j);
    end;

    if j < FuncList.Count then
    begin
     OrderedList.Clear;
     V.InsertPara;
     V.Font(FontName);
     V.Bold(1);
     V.InsertPara;
     WriteLine('Methods');
     V.InsertPara;
     p3 := V.GetSelStartPos;

     while (j < FuncList.Count) and
           (Pos(ThisParent + ',',FuncList[j]) = 1) do
     begin
       ParseLine(FuncList[j], AParent, AHRef, AName);
       OrderedList.Add(AName + ',' + AHRef + ',' + AParent);
       Application.ProcessMessages;
       inc(j);
     end;

     for j := 0 to OrderedList.Count - 1 do
     begin
       ParseLine(OrderedList[j], AName, AHRef, AParent);
       FAddContentsMember(AName, AHRef, AParent);
       Progress('Writing methods: ' + IntToStr(j));
       Application.ProcessMessages;
       if FCancelled then
       begin
        ShowMessage('Process Cancelled');
        Break;
       end;
     end;

    if FCancelled then
      Exit;

     V.InsertPara;
     p4 := V.GetSelStartPos;
     V.InsertPara;
     p5 := V.GetSelStartPos;
     p2 := V.GetSelStartPos;
     V.InsertPara;
     SetTable(p3, p4);
     V.InsertPara;
    end;

    V.Font(FontName);
    V.Bold(1);
    V.Insert('Notes');
    V.InsertPara;
    WriteLine('');
    V.Insert('Tasks');
    V.InsertPara;

  end;

  if FCancelled then
    Exit;

  for i := 0 to FTopicList.Count - 1 do
  begin
    ParseLine4(FTopicList[i], AName, AHRef, AParent, Doc);
    FAddTopic(AName, AHRef, AParent, Doc);
    Progress('Writing topics: ' + IntToStr(i + 1) + ' of ' +
                          IntToStr(TotalTopics));
    Application.ProcessMessages;

    if FCancelled then
    begin
      
      ShowMessage('Process Cancelled');
      Break;
    end;

  end;

  if FCancelled then EXIT;

  WriteEnumTopics;

  if FCancelled then EXIT;

  V.InsertBreak(0);
  V.Font(FontName);
  V.FontSize(PageHeadSize);
  V.Bold(1);
  P1 := V.GetSelStartPos;
{  V.InsertPara;}
  V.Insert('Object Model');
  V.Bold(0);
  V.InsertFootnote('#',1);
  V.Insert('_ObjectModel');
  V.ClosePane;
  V.InsertPara;
{  WriteLine('');}
  P2 := V.GetSelStartPos;
  V.InsertPara;
  P3 := V.GetSelStartPos;
  V.Font(FontName);
  V.FontSize(TextSize);
  V.Bold(0);
  WriteLine('This is the object model');
{  V.SetSelRange(P1, P2);
  V.ParaKeepWithNext(1);
  V.SetSelRange(P2,P2);
  V.ParaKeepWithNext(0);}
  SetBanner(p1, p2, p3);
  V.EndOfDocument;

  V.InsertBreak(0);
  V.Font(FontName);
  V.FontSize(PageHeadSize);
  V.Bold(1);
  P1 := V.GetSelStartPos;
  V.InsertPara;
  V.Insert('IDispatch interface');
  V.Bold(0);
  V.InsertFootnote('#',1);
  V.Insert('_IDispatch');
  V.ClosePane;
  V.InsertPara;
  WriteLine('');
  P2 := V.GetSelStartPos;
  V.InsertPara;
  P3 := V.GetSelStartPos;
  V.Font(FontName);
  V.FontSize(TextSize);
  V.Bold(0);

  WriteLine('IDispatch is the ancestor type of all the Toolkit interfaces');
  WriteLine('See Windows SDK for details of the IDispatch interface.');
{  V.SetSelRange(P1, P2);
  V.ParaKeepWithNext(1);
  V.SetSelRange(P2,P2);
  V.ParaKeepWithNext(0);}
  SetBanner(p1, p2, p3);
  V.EndOfDocument;


  V.InsertBreak(0);

  ShowMessage('Finished');
end;

procedure THelpGenerator.WriteLine(const s : string);
begin
  V.Insert(s);
  V.InsertBreak(6);
  V.InsertPara;
end;

procedure THelpGenerator.InitializeCommonList;
begin
  Try
{$IFDEF AllowHelp}
    CommonList.LoadFromFile(CommonListFile);
{$ENDIF}
  Except
  End;
end;

function THelpGenerator.IsCommon(const s : string) : Boolean;
begin
  Result := CommonList.IndexOf(s) <> -1;
end;

procedure THelpGenerator.Progress(const s : string);
begin
  If Assigned(FProgressForm) then
  begin
    FProgressForm.Caption := s;
    FProgressForm.Update;
  end;
end;

procedure THelpGenerator.SetTable(p1, p2 : longint);
begin
  V.SetSelRange(p1, p2);
  if p1 <> p2 then
  begin
    V.TextToTable(1, 4, 0, ColWidth);
    V.FormatParagraph(24, 24);
    V.SetSelRange(0,0);
    V.EndOfDocument;
  end;
end;

procedure THelpGenerator.SetBanner(p1, p2, p3 : longint);
begin
  V.SetSelRange(p1, p2);
  if p1 <> p2 then
  begin
    V.ParaKeepWithNext(1);
    V.SetSelRange(p3,p3);
    V.ParaKeepWithNext(0);
    V.EndOfDocument;
  end;
end;

function THelpGenerator.GetParentStr(const s : string) : string;
var
  i, j : integer;
begin
  i := 1;
  while (i < Length(s)) and (s[i] <> '_') do inc(i);
  inc(i);
  j := i;
  while (i < Length(s)) and (s[i] <> '_') do inc(i);
  Result := Copy(s, j, i - j);
end;

function THelpGenerator.GetFuncStr(const s : string) : string;
var
  i, j : integer;
begin
  i := 1;
  while (i < Length(s)) and (s[i] <> '_') do inc(i);
  Result := Copy(s, 1, i-1);
end;

function THelpGenerator.GetContentsType(const s : string) : string;
var
  i : integer;
  Found : Boolean;
  AName, AHRef, AType : string;
begin
  i := 0;
  Found := False;
  while (i <= FTopicList.Count - 1) and not Found do
  begin
    if Pos(s, FTopicList[i]) = 1 then
      Found := True
    else
      inc(i);
  end;
  if Found then
  begin
    ParseLine(FTopicList[i], AName, AHRef, AType);
    REsult := AType;
  end
  else
    Result := '';
end;

procedure THelpGenerator.Delay(t : longint);// For debugging
{var
  t1, t2 :Cardinal;}
begin
{  t1 := GetTickCount;
  while GetTickCount < Cardinal(t1 + (t * 1000)) do
    Application.ProcessMessages;}
end;

procedure THelpGenerator.AddToParamList(const s : string);
begin
  if ParamList.IndexOf(s) = -1 then
    ParamList.Add(s);
end;

procedure THelpGenerator.GetParams(const ARef : string; Params : TStringList);
var
  i, j  : integer;
  s : string;
begin
  for i := 0 to ParamList.Count - 1 do
  begin
    Application.ProcessMessages;
    if Pos(ARef + ',', ParamList[i]) = 1 then
    begin
      s := ParamList[i];
      j := 1;
      while (j < Length(s)) and (s[j] <> ',') do inc(j);
      if j < Length(s) then
      begin
        Delete(s, 1, j);
        Params.Add(s);
      end;
    end;
  end;
end;

procedure THelpGenerator.AddEnum(const s : string);
begin
  if EnumList.IndexOf(s) = -1 then
    EnumList.Add(s);
end;

procedure THelpGenerator.WriteEnumTopics;
var
  i, j : integer;
  EName, ValName, Value : string;
  ThisEnum : string;
  EList : TStringList;
  p1, p2, p3 : longint;
begin
  EList := TStringList.Create;
  Try
    for i := 0 to EnumList.Count - 1 do
    begin
      ParseLine(EnumList[i], EName, ValName, Value);
      if EList.IndexOf(EName) = -1 then
        EList.Add(EName);
    end;

    for i := 0 to EList.Count - 1 do
    begin
      Progress('Writing Enumeration topics ' + IntToStr(i + 1) +
                          ' of ' + IntToStr(EList.Count));
      V.InsertBreak(0);
      p1 := V.GetSelStartPos;
      V.InsertPara;
      V.Font(FontName);
      V.FontSize(PageHeadSize);
      V.Bold(1);
      V.Insert(EList[i]);
      V.Bold(0);
      V.InsertFootNote('#',1);
      V.Insert('Enum_' + EList[i]);
      V.ClosePane;

      V.InsertFootNote('K',1);
      V.Insert(EList[i]);
      V.ClosePane;

      V.InsertFootNote('$',1);
      V.Insert(EList[i]);
      V.ClosePane;

      V.Insert(' : ' + 'TOleEnum');
      EName := EnumOwner(EList[i]);
      if (Ename <> '') and (Ename[1] = 'I') and (Ename <> 'Integer') then
      begin
        V.Font(FontName);
        V.FontSize(TextSize);

        V.InsertPara;
        WriteLine('');
        V.DoubleUnderline(1);
        V.Bold(1);
        V.Insert(Ename + ' Interface');
        V.Bold(0);
        V.DoubleUnderLine(0);
        V.Hidden(1);
        V.Insert('_' + Ename);
        V.Hidden(0);
      end
      else
      begin
        V.InsertPara;
        WriteLine('');
      end;

      p2 := V.GetSelStartPos;
      V.InsertPara;
      p3 := V.GetSelStartPos;
{      V.SetSelRange(p1, p2);
      V.ParaKeepWithNext(1);
      V.SetSelRange(P1, p1);
      V.EndOfDocument;
      V.ParaKeepWithNext(0);}
      SetBanner(p1, p2, p3);
      V.EndOfDocument;
      V.InsertPara;
      V.Bold(1);
      V.Font(FontName);
      V.FontSize(TextSize); {?}
      V.Insert('Values');
      WriteLine('');
      V.Bold(0);
      p1 := V.GetSelStartPos;
      for j := 0 to EnumList.Count - 1 do
      begin
        if Pos(EList[i] + ',', EnumList[j]) = 1 then
        begin
          ParseLine(EnumList[j], EName, ValName, Value);
          V.Insert(ValName + #9 + Value);
          V.InsertBreak(6);
        end;
      end;
      WriteLine('');
      p2 := V.GetSelStartPos;
      SetTable(p1, p2);

      if FCancelled then
      begin
        ShowMessage('Process Cancelled');
        Break;
      end;

    end;


  Finally
    EList.Free;
  End;
end;

function THelpGenerator.EnumName(const EnumType : string; Value : Variant) : string;
var
  j : integer;
  EType, ThisVal, ValName, Valstr : string;
begin
  Result := '';
  Try
    ThisVal := IntToHex(Value, 4) + 'h';
  Except
    ThisVal := 'Not an integer';
  End;
  for j := 0 to EnumList.Count - 1 do
  begin
    if Pos(EnumType + ',', EnumList[j]) = 1 then
    begin
      ParseLine(EnumList[j], EType, ValName, ValStr);
      if ValStr = ThisVal then
      begin
        Result := ValName;
        Break;
      end;
    end;
  end;
end;

function THelpGenerator.EnumOwner(const EnumType : string) : string;
var
  Etype, EOwner, EName : string;
  i, j, k : integer;

  function GetOwner(const RefString : string) : string;
  begin
    Result := '';
    j := Pos('_', RefString);
    if k > 0 then
    begin
      inc(j);
      k := j;
      while (j < Length(RefString)) and (RefString[j] <> '_') do inc(j);
      if j < Length(RefString) then
      begin
        Result := Copy(RefString, k, j - k);
      end;
    end;
  end;

begin
  Result := '';
  for i := 0 to FTopicList.Count - 1 do
  begin
    ParseLine(FTopicList[i], EName, EOwner, EType);
    if EnumType = EType then
    begin
      Result := GetOwner(EOwner);
      Break;
    end;
  end;

  if Result = '' then
  begin
  //Try params list
    for i := 0 to ParamList.Count - 1 do
    begin
      ParseLine(ParamList[i], EOwner, EType, EName);
      j := Pos(':', EType);
      if j > 0 then
        EType := Copy(EType, j + 2, Length(EType));
      if EnumType = EType then
      begin
        Result := GetOwner(EOwner);
        Break;
      end;
    end;
  end;
end;

procedure THelpGenerator.Cancel;
begin
  FCancelled := True;
end;

function THelpGenerator.IsReadOnly(const AName, AParent : string) : Boolean;
var
  i : integer;
  s : string;
  Found : Boolean;
  j : longint;
begin
  i := 0;
  Found := False;
  while (i < FContentsList.Count) and not Found do
  begin
    Application.ProcessMessages;
    s := FContentsList[i];
    if (Pos(AName + ',', s) > 0) and (Pos(AParent, s) > 0) then
      Found := True
    else
      inc(i);
  end;

  if Found then
    Result := LongInt(FContentsList.Objects[i]) and propReadOnly = propReadOnly
  else
    Result := False;

end;

procedure THelpGenerator.AddToArrayList(const Arr : string);
begin
  FArrayList.Add(Arr);
end;

function THelpGenerator.IsGetFunction(const s : string) : Integer;
const
  GetArray : Array[1..13] of String =
            ('GETFIRST','GETNEXT','GETEQUAL','GETLAST','GETPREVIOUS',
             'GETGREATERTHANOREQUAL','GETLESSTHANOREQUAL','GETLESSTHAN',
             'GETGREATERTHAN','STEPFIRST','STEPNEXT','STEPLAST',
             'STEPPREVIOUS');
var
  i : integer;
begin
  Result := 0;
  for i := 1 to 13 do
  begin
    if UpperCase(s) = GetArray[i] then
    begin
      if i in [1, 3, 5] then
        Result := 1
      else
        Result := 2;
      Break;
    end;
  end;
end;

procedure THelpGenerator.ReturnValue(const s : string);
var
  i : integer;
begin
  V.InsertPara;
  WriteLine('');
  V.Font(FontName);
  V.Bold(1);
  V.Insert('Return Value');
  V.Bold(0);
  V.InsertPara;

  i := IsGetFunction(s);

  if i > 0 then
  begin
    V.Insert('The return value indicates the success or failure of the operation.');
    V.Insert(' Possible values are: ');
    V.InsertPara;
    V.InsertPara;
    V.Insert(Char(9) +'0' + Char(9) + 'Record found successfully');
    V.InsertPara;
    if i = 1 then
      V.Insert(Char(9) +'4' + Char(9) + 'No record found')
    else
    if i = 2 then
      V.Insert(Char(9) +'9' + Char(9) + 'End of file reached');
  end
  else
  begin
    if (Pos('BUILD',UpperCase(s)) = 1) and
       (Pos('INDEX',UpperCase(s)) = Length(s) - 4) then
    begin
      V.Insert('The formatted key string is returned as the function result');
    end;
  end;


end;

end.
