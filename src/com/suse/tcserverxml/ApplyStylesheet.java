/**
 * Copyright (c) 2019 SUSE LLC
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 */
package com.suse.tcserverxml;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

public class ApplyStylesheet {

    static Document document;

    public static void main(String[] argv) {
        if (argv.length != 4 && argv.length != 5) {
            System.err.println("Usage: java com.suse.tcserverxml.ApplyStylesheet stylesheet serverXmlFile docBase path [contextXmlFile]");
            System.exit(1);
        }

        String stylesheet = argv[0];
        File datafile = new File(argv[1]);
        String docBase = argv[2];
        String path = argv[3];
        String contextXml = argv.length > 4 ? argv[4] : null;

        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        try {
            DocumentBuilder builder = docFactory.newDocumentBuilder();
            document = builder.parse(datafile);

            // Use a Transformer for output
            TransformerFactory xsltFactory = TransformerFactory.newInstance();
            InputStream styleInput = ApplyStylesheet.class.getResourceAsStream(stylesheet);
            StreamSource styleSource = new StreamSource(styleInput);
            Transformer transformer = xsltFactory.newTransformer(styleSource);

            transformer.setParameter("docBase", docBase);
            transformer.setParameter("path", path.startsWith("/") ? path : "/" + path);
            if (contextXml != null) {
                transformer.setParameter("contextXml", contextXml);
            }

            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(System.out);
            transformer.transform(source, result);

        } catch (TransformerException | SAXException te) {
            System.out.println("\n** Transformation error");
            te.printStackTrace();
            System.exit(2);
        } catch (ParserConfigurationException pce) {
            System.out.println("\n** Parser configuration error");
            pce.printStackTrace();
            System.exit(3);
        } catch (IOException ioe) {
            System.out.println("\n** IO error");
            ioe.printStackTrace();
            System.exit(4);
        }
    }
}
