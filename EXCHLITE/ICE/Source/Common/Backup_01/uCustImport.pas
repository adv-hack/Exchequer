{-----------------------------------------------------------------------------
 Unit Name: uCustImport
 Author:    vmoura
 Date:      14-Oct-2005
 Purpose:
 History:
   customer import class
-----------------------------------------------------------------------------}

{ Original version of the TCustImport class. The existing version is a major
  rewrite of this. }
  
Unit uCustImport;

Interface

Uses Classes, variants, Sysutils,
  MSXML2_TLB,
  USEDLLU,
  uBaseClass, uXmlBaseClass, uconsts, uCommon, uImportBaseClass
  ;

{$I ice.inc}

{$I exdllbt.inc}

{$I exchdll.inc}

Type
  TCustImport = Class(_ImportBase)
  Protected
    Procedure AddRecord(pNode: IXMLDOMNode); Override;
    Procedure Clear; Override;
    Function GetRecordValue(pXmlNode: IXMLDOMNode; Var pRecord: Pointer):
      Boolean; Override;
    Function SaveRecord(pRecord: Pointer; pRecSize: Integer; pUpdateMode:
      Smallint): Boolean; Override;
  Public
    Destructor Destroy; Override;
    Function SaveListToDb: Boolean; Override;
  End;

Implementation

Uses uEXCHBaseClass;

{ TCustImport }

{-----------------------------------------------------------------------------
  Procedure: AddRecord
  Author:    vmoura

  Override add function into Split
  This function must be override to create records to insert into dll
-----------------------------------------------------------------------------}
Procedure TCustImport.AddRecord(pNode: IXMLDOMNode);
Var
  lRec: TXMLDoc;
Begin
  lRec := TXMLDoc.Create;
  lRec.LoadXml(pNode.xml);
  List.Add(lRec)
End;

{-----------------------------------------------------------------------------
  Procedure: Clear
  Author:    vmoura
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
Procedure TCustImport.Clear;
Var
  lCont: Integer;
  lCust: TXMLDoc;
Begin
// free the objects list
  For lCont := List.Count - 1 Downto 0 Do
    If List[lCont] <> Nil Then
      If TObject(List[lCont]) Is TXmlDoc Then
      Begin
        lCust := List[lCont];
        _FreeAndNil(lCust);
        List.Delete(lCont);
      End;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
Destructor TCustImport.Destroy;
Begin
  Clear;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetRecordValue
  Author:    vmoura
  Arguments: pXmlNode: IXMLDOMNode; Var pRecord: Pointer
  Result:    Boolean
-----------------------------------------------------------------------------}
Function TCustImport.GetRecordValue(pXmlNode: IXMLDOMNode; Var pRecord:
  Pointer): Boolean;

  Function _GetValue(pNode: IXMLDOMNode; Const pName: String): Variant;
  Begin
    _GetNodeValueByName(pNode, pName, Result);
  End;

Var
  lAux: String;
Begin
  Result := True;

  If pXmlNode <> Nil Then
  Begin
    With TBatchCURec(pRecord^) Do
    Try
    // test if the node is a customer
      Try
        lAux := Uppercase(_GetValue(pXmlNode, 'custsupp'));
      Except
        lAux := '';
      End;

      If (lAux <> '') And (lAux = 'C') Then
      Begin
        Try
          CustSupp := lAux[1];
        Except
        End;

        //CustCode := pXmlNode.attributes[1].nodeValue;
        CustCode := _GetValue(pXmlNode, 'custcode');

      // get field by field and store values using the record structure
        Company := _GetValue(pXmlNode, 'company');
        // <company><![CDATA[marks & spencer                           xyyyyyyy]]></company>
        AreaCode := _GetValue(pXmlNode, 'areacode');
        // <areacode>1.9xczseg65</areacode>
        AreaCode := _GetValue(pXmlNode, 'repcode');
        // <repcode>2</repcode>
        AreaCode := _GetValue(pXmlNode, 'remitcode');
        // <remitcode>2</remitcode>
        AreaCode := _GetValue(pXmlNode, 'vatregno');
        // <vatregno>3</vatregno>
        Addr[1] := _GetValue(pXmlNode, 'addr1');
        // <addr1><![CDATA[abc & cool]]></addr1>
        Addr[2] := _GetValue(pXmlNode, 'addr2');
        // <addr2><![CDATA[def]]></addr2>
        Addr[3] := _GetValue(pXmlNode, 'addr3');
        // <addr3><![CDATA[ghi]]></addr3>
        Addr[4] := _GetValue(pXmlNode, 'addr4');
        // <addr4><![CDATA[jkl]]></addr4>
        Addr[5] := _GetValue(pXmlNode, 'addr5');
        // <addr5><![CDATA[jkl]]></addr5>
        DespAddr := _GetValue(pXmlNode, 'despaddr');
        // <despaddr>0</despaddr>
        daddr[1] := _GetValue(pXmlNode, 'daddr1');
        // <daddr1><![CDATA[abcd1]]></daddr1>
        daddr[2] := _GetValue(pXmlNode, 'daddr2');
        // <daddr2><![CDATA[efgh2]]></daddr2>
        daddr[3] := _GetValue(pXmlNode, 'daddr3');
        // <daddr3><![CDATA[ijkl3]]></daddr3>
        daddr[4] := _GetValue(pXmlNode, 'daddr4');
        // <daddr4><![CDATA[mnop4]]></daddr4>
        daddr[5] := _GetValue(pXmlNode, 'daddr5');
        // <daddr5><![CDATA[jkl]]></daddr5>
        Contact := _GetValue(pXmlNode, 'contact');
        // <contact>me</contact>
        phone := _GetValue(pXmlNode, 'phone');
        // <phone><![CDATA[54654]]></phone>
        Fax := _GetValue(pXmlNode, 'fax');
        // <fax><![CDATA[465456]]></fax>
        refno := _GetValue(pXmlNode, 'refno');
        // <refno>CBD567</refno>
        tradterm := _GetValue(pXmlNode, 'tradterm');
        // <tradterm>0</tradterm>
        STerms[1] := _GetValue(pXmlNode, 'sterms1');
        // <sterms1><![CDATA[]]></sterms1>
        STerms[2] := _GetValue(pXmlNode, 'sterms2');
        // <sterms2><![CDATA[]]></sterms2>
        currency := _GetValue(pXmlNode, 'currency');
        // <currency>1</currency>

        // treating char values
        Try
          lAux := String(_GetValue(pXmlNode, 'vatcode'));

          If lAux <> '' Then
            vatcode := lAux[1]
          Else
            vatcode := #0;
        Except
          vatcode := #0;
        End;

        // <vatcode>b</vatcode>
        payterms := _GetValue(pXmlNode, 'payterms');
        // <payterms>12</payterms>
        creditlimit := _GetValue(pXmlNode, 'creditlimit');
        // <creditlimit>2000</creditlimit>
        discount := _GetValue(pXmlNode, 'discount');
        // <discount>12.5</discount>
        creditstatus := _GetValue(pXmlNode, 'creditstatus');
        // <creditstatus>6</creditstatus>
        custcc := _GetValue(pXmlNode, 'custcc');
        // <custcc>b</custcc>

        // treating char values
        Try
          lAux := String(_GetValue(pXmlNode, 'cdiscch'));
          If lAux <> '' Then
            cdiscch := lAux[1]
          Else
            cdiscch := #0;
        Except
          cdiscch := #0;
        End;
        // <cdiscch>b</cdiscch>
        custdep := _GetValue(pXmlNode, 'custdep');
        // <custdep>b</custdep>
        eecmember := _GetValue(pXmlNode, 'eecmember');
        // <eecmember>1</eecmember>
        incstat := _GetValue(pXmlNode, 'incstat');
        // <incstat>0</incstat>
        defnomcode := _GetValue(pXmlNode, 'defnomcode');
        // <defnomcode>3</defnomcode>
        defmlocstk := _GetValue(pXmlNode, 'defmlocstk');
        // <defmlocstk/>
        accstatus := _GetValue(pXmlNode, 'accstatus');
        // <accstatus>1</accstatus>

        // treating char values
        Try
          lAux := String(_GetValue(pXmlNode, 'paytype'));
          If lAux <> '' Then
            paytype := lAux[1] // <paytype/>
          Else
            paytype := #0;
        Except
          paytype := #0;
        End;

        banksort := _GetValue(pXmlNode, 'banksort'); // <banksort/>
        bankacc := _GetValue(pXmlNode, 'bankacc'); // <bankacc/>
        bankref := _GetValue(pXmlNode, 'bankref');
        // <bankref><![CDATA[]]></bankref>
        lastused := _GetValue(pXmlNode, 'lastused'); // <lastused/>
        phone2 := _GetValue(pXmlNode, 'phone2');
        // <phone2><![CDATA[3164]]></phone2>
        userdef1 := _GetValue(pXmlNode, 'userdef1');
        // <userdef1><![CDATA[]]></userdef1>
        userdef2 := _GetValue(pXmlNode, 'userdef2');
        // <userdef2><![CDATA[]]></userdef2>
        sopinvcode := _GetValue(pXmlNode, 'sopinvcode');
        // <sopinvcode/>
        sopautowoff := _GetValue(pXmlNode, 'sopautowoff');
        // <sopautowoff>1</sopautowoff>
        bordval := _GetValue(pXmlNode, 'bordval');
        // <bordval>128000</bordval>
        defcosnom := _GetValue(pXmlNode, 'defcosnom');
        // <defcosnom>2</defcosnom>
        defctrlnom := _GetValue(pXmlNode, 'defctrlnom');
        // <defctrlnom>5</defctrlnom>
        dirdeb := _GetValue(pXmlNode, 'dirdeb');
        // <dirdeb>4</dirdeb>
        ccdsdate := _GetValue(pXmlNode, 'ccdsdate'); // <ccdsdate/>
        ccdedate := _GetValue(pXmlNode, 'ccdedate'); // <ccdedate/>
        ccdname := _GetValue(pXmlNode, 'ccdname');
        // <ccdname><![CDATA[]]></ccdname>
        ccdcardno := _GetValue(pXmlNode, 'ccdcardno');
        // <ccdcardno><![CDATA[]]></ccdcardno>
        ccdsaref := _GetValue(pXmlNode, 'ccdsaref'); // <ccdsaref/>
        defsetddays := _GetValue(pXmlNode, 'defsetddays');
        // <defsetddays>10</defsetddays>
        defsetdisc := _GetValue(pXmlNode, 'defsetdisc');
        // <defsetdisc>8</defsetdisc>
        defformno := _GetValue(pXmlNode, 'defformno');
        // <defformno>0</defformno>
        statdmode := _GetValue(pXmlNode, 'statdmode');
        // <statdmode>1</statdmode>
        emailaddr := _GetValue(pXmlNode, 'emailaddr');
        // <emailaddr>a</emailaddr>
        emlsndrdr := _GetValue(pXmlNode, 'emlsndrdr');
        // <emlsndrdr>true</emlsndrdr>
        ebuspwrd := _GetValue(pXmlNode, 'ebuspwrd');
        // <ebuspwrd><![CDATA[]]></ebuspwrd>
        postcode := _GetValue(pXmlNode, 'postcode');
        // <postcode><![CDATA[]]></postcode>
        custcode2 := _GetValue(pXmlNode, 'custcode2');
        // <custcode2><![CDATA[]]></custcode2>
        allowweb := _GetValue(pXmlNode, 'allowweb');
        // <allowweb>1</allowweb>
        emlzipatc := _GetValue(pXmlNode, 'emlzipatc');
        // <emlzipatc>false</emlzipatc>
        userdef3 := _GetValue(pXmlNode, 'userdef3');
        // <userdef3><![CDATA[]]></userdef3>
        userdef4 := _GetValue(pXmlNode, 'userdef4');
        // <userdef4><![CDATA[]]></userdef4>
        timechange := _GetValue(pXmlNode, 'timechange');
        // <timechange/>
        ssddelterms := _GetValue(pXmlNode, 'ssddelterms');
        // <ssddelterms/>

        // treating char values
        Try
          lAux := String(_GetValue(pXmlNode, 'cvatincflg'));
          If lAux <> '' Then
            cvatincflg := lAux[1]
          Else
            cvatincflg := #0;
        Except
          cvatincflg := #0;
        End;
        // <cvatincflg/>
        ssdmodetr := _GetValue(pXmlNode, 'ssdmodetr');
        // <ssdmodetr>1</ssdmodetr>
        lastopo := _GetValue(pXmlNode, 'lastopo');
        // <lastopo><![CDATA[]]></lastopo>
        invdmode := _GetValue(pXmlNode, 'invdmode');
        // <invdmode>1</invdmode>
        emlsndhtml := _GetValue(pXmlNode, 'emlsndhtml');
        // <emlsndhtml>false</emlsndhtml>
        weblivecat := _GetValue(pXmlNode, 'weblivecat');
        // <weblivecat><![CDATA[]]></weblivecat>
        webprevcat := _GetValue(pXmlNode, 'webprevcat');
        // <webprevcat><![CDATA[]]></webprevcat>
        sopconsho := _GetValue(pXmlNode, 'sopconsho');
        // <sopconsho>3</sopconsho>
        emluseedz := _GetValue(pXmlNode, 'emluseedz');
        // <emluseedz>false</emluseedz>
        deftagno := _GetValue(pXmlNode, 'deftagno');
        // <deftagno>1</deftagno>
        orderconsmode := _GetValue(pXmlNode, 'orderconsmode');
        // <orderconsmode>2</orderconsmode>
      End
      Else
        Result := False;
    Except
      On e: Exception Do
      Begin
        Result := False;
        DoLogMessage('TCustImport.GetRecordValue', cLOADINGXMLVALUEERROR,
          'Error: '
          + e.message);
      End;
    End; // try...
  End // node <> nil
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveListToDb
  Author:    vmoura
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}
Function TCustImport.SaveListToDb: Boolean;
Var
  lCont: Integer;
  lCust: ^TBatchCURec;
  lHeader: TMsgHeader;
Begin
  Result := True;

    // test the record list
  If List.Count > 0 Then
  Begin
      // initialize the dll
      If InitDll(DataPath) Then
      Begin
        New(lCust);

        lHeader := GetHeader(XMLDoc.Doc);

        For lCont := 0 To List.Count - 1 Do
        Begin
          FillChar(lCust^, SizeOf(lCust^), #0);

      // get the customer values
          If GetRecordValue(TXMLDOC(List[lCont]).Doc, pointer(lCust)) Then
          Begin
        // try to save the record into the database
            If Not SaveRecord(Pointer(lCust), SizeOf(lCust^), lHeader.Flag) Then
            Begin
              DologMessage('_ImportBase.SaveListtoDB', cSAVINGXMLRECORDERROR,
                ' Record: ' + inttostr(lCont));
              Result := False;
              Break;
            End; // if not saverecord
          End
          Else
          Begin
            DoLogMessage('TCustImport.SaveListToDb', cLOADINGXMLRECORDERROR);
            Result := False;
            Break;
          End;
        End; // for

        Dispose(lCust);
      End // initdll
      Else
        Result := False;

    CloseDll; // finalize the dll
  End // count > 0
  Else
  Begin
    Result := False;
    DoLogMessage('_ImportBase.SaveListtoDB', cNOXMLRECORDSFOUND);
  End;

End;

{-----------------------------------------------------------------------------
  Procedure: SaveRecord
  Author:    vmoura
  Arguments: pRecord: Pointer; pRecSize: Integer; pUpdateMode: Smallint
  Result:    Boolean

  How to save the data is not well define yet. Into the xml header, there is a flag
  and this flar sinalize what should be done
-----------------------------------------------------------------------------}
Function TCustImport.SaveRecord(pRecord: Pointer; pRecSize: Integer;
  pUpdateMode: Smallint):
  Boolean;
Var
  lRes,
    lUpdateMode: SmallInt;
Begin
  Result := False;
  // test the update mode
  lUpdateMode := B_Update;

  Try
    Case TDBOption(pUpdateMode) Of
      dbdoUpdate: lUpdateMode := B_Update;
      dbDoAdd: lUpdateMode := B_Insert;
      //dbDoDelete : lUpdateMode := B_Delete;
    End;

    lRes := EX_STOREACCOUNT(pRecord, pRecSize, 0, lUpdateMode);

    If lRes <> 0 Then
    Begin
      DolOGMessage('TCustImport.SaveRecord', cEXCHSAVINGVALUEERROR, 'Error: ' +
        Inttostr(lRes));
      Result := False;
    End
    Else
      Result := True;
  Except
    On e: exception Do
      DoLOGMessage('TCustImport.SaveRecord', cEXCHSAVINGVALUEERROR, 'Error: ' +
        e.message);
  End;
End;

End.
