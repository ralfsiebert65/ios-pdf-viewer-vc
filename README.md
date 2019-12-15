PDF Viewer Komponente

Eigenschaften:

    PDF Viewer für zeitgleich ein PDF Dokument.
    - Suchfunktion
    - Bookmarkfunktion
    - Thumbnail-Navigation
    - Drucken der PDF Datei
    - Share Funktion
    - PDF Datei per Email versenden

Grundlagen:

    - Basiert auf dem Apple PDFKit
    - Mindestens iOS 11
    - Benötigt einen ViewController, der in einem Navigationcontroller eingebunden ist
    - Aufruf üblicherweise per Segue

Benötigte Frameworks:

    - Messages
    - MessageUI
    - PDFKit
    - WebKit
    - CoreGraphics

Einbinden ins Projekt:

    - Einen UIViewcontroller im Storyboard erstellen und in einen Navigationcontroller einbinden
    - Die Dateien pdfViewVC.h und pdfViewVC.m in das Projekt kopieren
    - Den UIViewcontroller im Storyboard mit der Klasse pdfVieweVC verknüpfen

Parameter:

    NSString *pdffile;
    
        pdffile = Die PDF Datei mit vollständigem Pfad
    
    NSMutableArray *bookmarkPageIndexes;
    
        bookmarkPageIndexes = NSMutableArray welches die Indexnummern der Seiten enthält welche mit einem Lesezeichen versehen wurden.
       
    NSString *language
    
        language =  [de, en, fr] - Sprache der Custom Dialogelemente. Unterstützt werden de = deutsch, en = englisch; fr = französisch
    
        Wird die Sprache nicht angegeben wird automatisch 'de' eingestellt.
    
       
Rückgabe beim Beenden des PDF VC

    Die Methode viewWillDisappear löst eine Notification aus, die im UserDictionary die Werte
    
    Key: pdffile            Object: PDF Dateiname mit follständigem Pfad 
    Key: bookmarkarray      Objekt: NSArray<NSString*> mit den Indexwerten der Bookmarks zu der PDF Datei. Die Indexwerte sind Strings.
    
    NotificationName:       dk.appartisan.pdfviewer.komp.close.notification
    

Sonstige Methoden:

    Es gibt eine Klassenmethode mit der Bezeichnung:

    +(UIImage *) getPdfThumbnailFromPDFFile:(NSString *) fromFilePath withWidth:(CGFloat) width

    Die Klassenmethode liefert von der ersten Seite einer PDF Datei ein Thumbnail mit der Breite 'width' zurück.
    Übergeben wird der Dateiname der PDF Datei mit vollständigem Pfad.

Beispiel:

    Die Klasse ist hier in ein Beispielprojekt eingebunden um die Funktionsweise darzustellen.
    
   
