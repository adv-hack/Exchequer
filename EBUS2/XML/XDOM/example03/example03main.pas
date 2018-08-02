unit example03main;

// Code Example 03 of using XDOM 2.3.6
// Delphi 3 Implementation
//
// You need XDOM 2.3.6 or above to use this source code.
// The latest version of XDOM can be found at "http://www.philo.de/xml/".
//
// Copyright (c) 2000 by Dieter Köhler
// ("http://www.philo.de/homepage.htm")
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

interface

uses
  XDOM_2_3, TypInfo,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Tabs, FileCtrl, ComCtrls, ExtCtrls, Grids;

type
  TMainpage = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    TabControl1: TTabControl;
    Memo1: TMemo;
    TabSet1: TTabSet;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Memo2: TMemo;
    TreeView1: TTreeView;
    XmlToDomParser1: TXmlToDomParser;
    DomImplementation1: TDomImplementation;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure OpenFile(Sender: TObject);
    procedure TabSet1Click(Sender: TObject);
    procedure CloseFile(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure XmlToDomParser1ExternalSubset(sender: TObject;
      const parentSystemId: WideString; var publicId, systemId,
      content: WideString; var action: TXmlParserAction);
  private
    { Private-Deklarationen }
    procedure UpdateTreeView(const doc: TdomDocument);
  public
    { Public-Deklarationen }
  end;

var
  Mainpage: TMainpage;

implementation

{$R *.DFM}

procedure TMainpage.UpdateTreeView(const doc: TdomDocument);
  procedure HandleNodeList(Parent:TTreeNode; DomNodeList:TDomNodeList);
  var
    i:integer;
    DomNode:TDomNode;
    tn:TTreeNode;
    astr:string;
  begin
    for i:=0 to pred(DomNodeList.length) do
    begin
      DomNode:=DomNodeList.Item(i);
      if DomNode.nodeType = ntAttribute_Node then
        ShowMessage('Attribute');
      astr:=DomNode.NodeName;
      if DomNode.NodeValue <> '' then astr:=astr+' ['+DomNode.NodeValue+']';
      astr:= astr + ' ('+GetEnumName(TypeInfo(TdomNodeType), integer(DomNode.NodeType))+') ';
      if domNode.nodeType = ntText_Node
       then if TdomText(domNode).isWhitespaceInElementContent
         then astr:= astr + '-- Whitespace in element content';
      tn:=parent.owner.AddChildObject(Parent,astr,domNode);
      if assigned(DomNode.ChildNodes) then HandleNodeList(tn, DomNode.ChildNodes);
    end;
  end;
var
  root:TTreeNode;
begin
  // Quick and dirty: always build the tree completely.
  // Delphi 5 seems to have problems with this approach,
  // but I could not figure out why.
  treeview1.Items.Clear;
  Root:= treeview1.Items.AddObject(nil,concat(doc.NodeName,' (',GetEnumName(TypeInfo(TdomNodeType), integer(Doc.NodeType)),') ',Doc.classname),doc);
  HandleNodeList(Root,doc.ChildNodes);
end;

procedure TMainpage.OpenFile(Sender: TObject);
var
  UpTime: {$ifdef VER100} integer; {$else} cardinal; {$endif} // use cardinal in D4 and D5
  doc: TdomDocument;
  index,i: integer;
  durationStr: string;
begin
  OpenDialog1.InitialDir:= ExtractFileDir(Label1.caption);
  if OpenDialog1.Execute then begin

    Label8.caption:= '';
    Label10.caption:= '';

    if not FileExists (OpenDialog1.FileName) then begin
      Label3.caption:= '';
      memo2.text:= 'File not found!';
      exit;
    end;

    Memo1.Clear;
    Memo1.Update;

    with XmlToDomParser1 do begin
      UpTime:= GetTickCount;
      Doc:= FileToDom(OpenDialog1.FileName);
      durationStr := Format('%d ms', [GetTickCount - UpTime]);
      index:= TabSet1.Tabs.Add(ExtractFileName(Doc.SystemId));
      TabSet1.TabIndex:= index;
      Label3.caption:= durationStr;
    end; {with ...}

    Memo1.Update;
    TabSet1.Update;
    with memo2 do begin
      clear;
      with XmlToDomParser1.ErrorHandler.errorList do begin
        for i:= 0 to count-1 do
          memo2.Lines.Add(TXmlParserError(Items[i]).GetErrorStr(iso639_en));
      end;
      if text = '' then text:= 'Document successfully parsed.';
      update;
    end;
  end; {if OpenDialog1.Execute ...}
end;

procedure TMainpage.TabSet1Click(Sender: TObject);
var
  doc: TdomDocument;
  i: integer;
begin
  with Memo1 do begin
    clear;
    Update;
  end;
  with StringGrid1 do begin
    RowCount:= 0;
    Cells[0,0]:= '';
    Cells[1,0]:= '';
    Update;
  end;
  with StringGrid2 do begin
    RowCount:= 0;
    Cells[0,0]:= '';
    Cells[1,0]:= '';
    Update;
  end;
  Memo2.clear;
  Label1.caption:= '';
  Label3.caption:= '';
  Label8.caption:= '';
  Label10.caption:= '';
  treeview1.Items.Clear;
  if TabSet1.TabIndex > -1 then begin
    SpeedButton2.Enabled:= true;
    doc:= (XmlToDomParser1.DOMImpl.documents.Item(TabSet1.TabIndex) as TdomDocument);
    Label1.caption:= doc.systemId;
    if assigned(doc.contentModel) then begin
      if assigned(doc.contentModel.externalCM) then begin
        Label8.caption:= doc.contentModel.externalCM.publicId;
        Label10.caption:= doc.contentModel.externalCM.systemId;
      end;
    end;
    with Memo1 do begin
      Text:= Doc.CodeAsString;
      Update;
    end;
    UpdateTreeView(doc);
    Update;
    if assigned(doc.contentModel) then begin
      with StringGrid1 do begin
        RowCount:= doc.contentModel.Entities.Length;
        for i:= 0 to pred(doc.contentModel.Entities.Length) do begin
          Cells[0,i]:= doc.contentModel.Entities.item(i).nodename;
          if TdomCMEntity(doc.contentModel.Entities.item(i)).isUnusable
            then Cells[1,i]:= '# Unusable Entity'
            else Cells[1,i]:= TdomCMEntity(doc.contentModel.Entities.item(i)).LiteralValue;
        end;
        Update;
      end;
      with StringGrid2 do begin
        RowCount:= doc.contentModel.ParameterEntities.Length;
        for i:= 0 to doc.contentModel.ParameterEntities.Length-1 do begin
          Cells[0,i]:= doc.contentModel.ParameterEntities.item(i).nodename;
          if TdomCMParameterEntity(doc.contentModel.ParameterEntities.item(i)).isUnusable
            then Cells[1,i]:= '# Unusable Parameter Entity'
            else Cells[1,i]:= TdomCMParameterEntity(doc.contentModel.ParameterEntities.item(i)).nodevalue;
        end;
        Update;
      end;
    end;
  end;
end;

procedure TMainpage.CloseFile(Sender: TObject);
var
  doc: TdomDocument;
begin
  if TabSet1.TabIndex > -1 then begin
    with TabSet1 do begin
      doc:= (XmlToDomParser1.DOMImpl.documents.Item(TabIndex) as TdomDocument);
      with XmlToDomParser1.DOMImpl do begin
        FreeDocument(doc);
      end;  
      Tabs.Delete(TabIndex);
      if Tabs.Count = 0 then SpeedButton2.Enabled:= false;
    end;
  end;
end;

procedure TMainpage.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: begin Memo1.show; StringGrid1.hide; StringGrid2.hide; TreeView1.hide; end;
    1: begin Memo1.hide; StringGrid1.hide; StringGrid2.hide; TreeView1.show; end;
    2: begin Memo1.hide; StringGrid1.show; StringGrid2.hide; TreeView1.hide; end;
    3: begin Memo1.hide; StringGrid1.hide; StringGrid2.show; TreeView1.hide; end;
  end;
end;

procedure TMainpage.Button1Click(Sender: TObject);
var
  doc: TdomDocument;
  ErrorHandler: TdomStandardErrorHandler;
  i: integer;
  erOpt: TdomEntityResolveOption;
begin
  doc:= (XmlToDomParser1.DOMImpl.documents.Item(TabSet1.TabIndex) as TdomDocument);
  ErrorHandler:= TdomStandardErrorHandler.create;
  try
    if assigned(doc) then begin
      if RadioGroup1.ItemIndex = 0
        then erOpt:= erReplace
        else erOpt:= erExpand;
      if doc.validate(ErrorHandler,erOpt)
        then MessageDlg('No validity constraints detected.',mtInformation,[mbOK],0)
        else MessageDlg('Document is invalid!',mtInformation,[mbOK],0);
      with memo2 do begin
        clear;
        with ErrorHandler.errorList do begin
          for i:= 0 to count-1 do
            memo2.Lines.Add(TXmlParserError(Items[i]).GetErrorStr(iso639_en));
        end;
        update;
      end;
    end else MessageDlg('No active document!',mtError,[mbOK],0);
  finally
    ErrorHandler.free;
  end;
  TabSet1Click(Sender);
end;

procedure TMainpage.XmlToDomParser1ExternalSubset(sender: TObject;
  const parentSystemId: WideString; var publicId, systemId,
  content: WideString; var action: TXmlParserAction);
var
  fileAsStringlist: TStringlist;
  path: TFileName;
begin
  content:= '';
  if systemId <> '' then begin
    try
      fileAsStringlist:= TStringlist.create;
      try

        // Resolve path:
           path := concat(ExtractFileDir(parentSystemId),'\',SystemID);
        // This works only with relative system identifiers of
        // certain kinds.

        systemId:= path;

        fileAsStringlist.LoadFromFile(path);
        // Quick and dirty: It is assumed, that the file is encoded in
        // UTF-16BE and has no text declaration. (Otherwise, one would
        // need to read in its text declaration, strip it off from the
        // rest of the file, transform the striped file to UTF-16BE and
        // assign it to 'content'.)
        content:= copy(fileAsStringlist.Text,1,length(fileAsStringlist.Text)-2);  // Truncate last CR+LF
        action:= paOK;
      finally
        fileAsStringlist.free;
      end;
    except
      action:= paFail;
    end;
  end;
end;

end.
