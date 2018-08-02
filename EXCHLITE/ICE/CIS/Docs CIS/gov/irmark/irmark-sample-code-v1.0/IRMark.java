
import java.io.*;
import javax.xml.parsers.*;
import java.security.*;

import org.w3c.dom.*;

import org.apache.xml.security.signature.*;
import org.apache.xml.security.transforms.*;
import org.apache.xml.security.Init;

import org.bouncycastle.util.encoders.Base64;

/**
 * This code generates an IRmark value for an input document.
 * The value is a base64 encoded SHA1 digest of a signature
 * transform over a certain style of document. The value has
 * to be placed inside documents to be signed by the XPE when
 * used in a EDS/IR deployment.
 *
 * The code has a number of jar dependencies:-
 * 	xmlsec.jar - The Apache XML Security Library
 * 	log4j-1.2.5.jar - The Apache Log utility
 *  xalan.jar - Apache XSLT/XPath processor
 *  xercesImpl.jar - Apache XML processor
 *  bc-jce-jdk13-114.jar - Bouncy Castle JCE library
 *
 *  The Bouncy Castle JCE provider is automatically downloaded
 *  by the Apache XML sec library build so you may already have
 *  that.
 */
public class IRMark {

   /**
    * Generate and print the IRmark.
    *
    * @param args - Pass the filename of the input document
    * @throws Exception
    */
	public static void main(String args[]) throws Exception {

   		// Init the Apache XML security library
		Init.init();

		// Check we are given a file to work with
		if (args.length!=1) {
			System.out.println("Use: IRmark <file> ");
			return;
		}

		// Open the input file
		FileInputStream fis=null;
		try {
			fis=new FileInputStream(args[0]);
		} catch (FileNotFoundException e) {
			System.out.println("The file " + args[0] + " could not be opened.");
			return;
		}

		// Load file into a byte array
		byte[] data=null;
		try {
			int bytes=fis.available();
			data=new byte[bytes];
			fis.read(data);
		} catch (IOException e) {
			System.out.println("Error reading file.");
			e.printStackTrace();
		}

		// First part is to run the a transform over the input to extract the
		// fragment to be digested. This is done by setting up a Transforms
		// object from a Template and then executing against the input document

		// The transforms to be performed are specified by using the template XML below.
      	String transformStr =
        "<?xml version='1.0'?>\n"
      	+ "<dsig:Transforms xmlns:dsig='http://www.w3.org/2000/09/xmldsig#' xmlns:gt='http://www.govtalk.gov.uk/CM/envelope' xmlns:ir='http://www.govtalk.gov.uk/taxation/SA'>\n"
      	+ "<dsig:Transform Algorithm='http://www.w3.org/TR/1999/REC-xpath-19991116'>\n"
      	+ "<dsig:XPath>\n"
      	+ "count(ancestor-or-self::node()|/gt:GovTalkMessage/gt:Body)=count(ancestor-or-self::node())\n"
		+ " and count(self::ir:IRmark)=0 \n"
		+ " and count(../self::ir:IRmark)=0 \n"
		+ "</dsig:XPath>\n"
      	+ "</dsig:Transform>\n"
      	+ "<dsig:Transform Algorithm='http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments'/>\n"
      	+ "</dsig:Transforms>\n"
      	;

		// Parse the transform details to create a document
		DocumentBuilderFactory dbf=DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		DocumentBuilder db=dbf.newDocumentBuilder();
		Document doc=db.parse(new ByteArrayInputStream(transformStr.getBytes()));

		// Construct a Apache security Transforms object from that document
		Transforms transforms = new Transforms(doc.getDocumentElement(), null);

		// Now perform the transform on the input to get the results.
      	XMLSignatureInput input = new XMLSignatureInput(data);
      	XMLSignatureInput result = transforms.performTransforms(input);

      	// Uncomment this line to see transform output
      	// System.out.println(new String(result.getBytes()));

      	// Second part is to run output via SHA1 digest
      	// This is done via the standard java.security API
		MessageDigest md = MessageDigest.getInstance("SHA");
		md.update(result.getBytes());
		byte[] digest=md.digest();

		// And finally print a Base64 of the digest with
		// The help of the BouncyCastle JCE library
		System.out.println("IRmark: " + new String(Base64.encode(digest)));
   }
}
