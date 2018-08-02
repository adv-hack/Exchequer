<%@ Language=JavaScript %>

<HTML>
  <BODY>
	<DIV id = "tgtResult"></DIV>
		
<% 
	var strDisplayTree = "";
	var Ex1 = "Exercise1.xml";
	var Ex2 = "Exercise2.xml";
	var csvfile = "Exercise2.csv";
	var c;
	var csv;
	
	function displayTree(base)
	{
		var i, win, indent;
	
		indent = "2em";
	
		if (base.nodeType == 1)
		{
			strDisplayTree += "<DIV Style='margin-left:" + indent + "'>[" + base.tagName + getAttributes(base) + "]";
		
			for (i=0;i<base.childNodes.length;i++)
				displayTree(base.childNodes.item(i));
		
			strDisplayTree += "[/" + base.tagName + "]" + "</DIV>";
		}
		else
		if (base.text != "")
			strDisplayTree += "<SPAN>" + base.text + "</SPAN>";
	}

	function getAttributes(elem)
	{
		var i;
		var strResult = "";
		
		xmapAtts = elem.attributes;
		
		for (i=0;i<xmapAtts.length;i++)
			strResult += ' ' + xmapAtts.item(i).name + '="' + xmapAtts.item(i).value + '"';
			
		return(strResult);
	}
	
	//Use this function to display the contents of the XML file
	function RenderXML(rootnode)
	{
		displayTree(rootnode);
		%><%=strDisplayTree%><%
	}
	
	//This can be used to display the content of a Node
	function DisplayContents(Obj)
	{
		%><%=Obj%><BR/><%
	}
	
	//this is used to load a file into the DOM and set the root node
	function loadintoDOM(file)
	{
		var root, source; //,strResult;
		
		source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.load(Server.MapPath(file));
		
		if (source.parseError !=0)
			%><%=source.parseError.reason%><%
			
		root = source.documentElement;
		
		return(root);
	}
	
	//This loads the csv file and returns the file into an array
	function loadcsvfile(file)
	{
		var fso, ts, s;
		
		fso = new ActiveXObject("Scripting.FileSystemObject");
		ts = fso.OpenTextFile(Server.MapPath(file),1);
		
		s = ts.ReadLine();
		
		return(s.split(","));
	}
	
	function CountBlanks(base)
	{
		var i;
			
		if (base.text == "") c++;	
		if (base.nodeType == 1)
			for (i=0;i<base.childNodes.length;i++)
				CountBlanks(base.childNodes.item(i));
		
	}

	function SetXML(base)
	{
		var i;
			
		// %><%=base.nodeType%><BR/><%
		if (base.childNodes.length == 0) base.text = csv[c++]
		else
			for (i=0;i<base.childNodes.length;i++)
				SetXML(base.childNodes.item(i));
		
	}

	
	function main()
	{
		root = loadintoDOM("exercise1.xml");
		DisplayContents(root.getElementsByTagName("OrderDate").item(0).text);
		DisplayContents(root.getElementsByTagName("TaxNumber").item(0).text);
		DisplayContents(root.getElementsByTagName("Name").item(1).text);
		
		root.getElementsByTagName("Fax").item(0).text = "12414441114";
		DisplayContents(root.getElementsByTagName("Fax").item(0).text);
		
		c = 0;
		CountBlanks(root);		
		%><%=c%><BR/><%
		
		root2 = loadintoDOM("exercise2.xml");
		csv = loadcsvfile("exercise2.csv");
		//%><%=csv[0]%><BR/><%
		c = 0;
		SetXML(root2);
		RenderXML(root2);
		
	}
	
	main();
%>
  </BODY>
</HTML>
