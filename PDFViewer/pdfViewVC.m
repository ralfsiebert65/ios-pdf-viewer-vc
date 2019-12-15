//
//  pdfViewVC.m
//
//  Created by Ralf Siebert - AppArtisan.dk
//

#import "pdfViewVC.h"

@interface pdfViewVC ()

@property (strong, nonatomic) UIDocumentInteractionController *myuic;
@property (strong, nonatomic) PDFThumbnailView *thumbView;
@property (strong, nonatomic) PDFView *pview;
@property (strong, nonatomic) PDFDocument *pdfdoc;
@property (strong, nonatomic) UILongPressGestureRecognizer *swToggleRecThumbs;
@property (strong, nonatomic) UISwipeGestureRecognizer *swLeftRecPDF;
@property (strong, nonatomic) UISwipeGestureRecognizer *swRightRecPDF;
@property (assign) BOOL thumbnailsShow;
@property (assign) BOOL bookmarksShow;
@property (assign) CGFloat topbarHeight;
@property (strong, nonatomic) UIView *waitingIndicatorView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIPopoverPresentationController *popover;
@property (strong, nonatomic) NSMutableDictionary *srchDict;
@property (strong, nonatomic) NSMutableArray *srchDictKeys;
@property (strong, nonatomic) NSArray *langStrings;
@property (strong, nonatomic) NSArray *delang;
@property (strong, nonatomic) NSArray *enlang;
@property (strong, nonatomic) NSArray *frlang;
@property (assign) int srchLastKey;
@property (assign) int pdfPageCount;
@property (strong, nonatomic) UICollectionView *bookmarkCollectionView;

@property (strong, nonatomic) UIImage *imgSearch;
@property (strong, nonatomic) UIImage *imgClose;
@property (strong, nonatomic) UIImage *imgShare;
@property (strong, nonatomic) UIImage *imgBookmarkFull;
@property (strong, nonatomic) UIImage *imgBookmarkClose;
@property (strong, nonatomic) UIImage *imgBookmark;
@property (strong, nonatomic) UIImage *imgThumbs;

@property (strong, nonatomic) UIBarButtonItem *btnBookMark;


@end

@implementation pdfViewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pdfPageChanged:) name:PDFViewPageChangedNotification object:nil];
    
    self.delang = @[@"Abbrechen",@"Lesezeichenübersicht",@"Lesezeichen entfernen",@"Lesezeichen",@"PDF Dokument",@"Der Suchbegriff wurde nicht gefunden.",@"Suchergebnis",@"Weiter suchen",@"Ok",@"Suchtext",@"Suchen",@"Dokument teilen",@"Per Email senden",@"Dokument drucken",@"Aktion",@"Lesezeichen hinzufügen"];
    self.enlang = @[@"Cancel",@"Bookmark overview",@"Delete bookmark",@"Bookmark",@"PDF document",@"The searchstring would not be found.",@"Searchresult",@"Search next",@"Ok",@"Searchtext",@"Search",@"Share document",@"Send document by email",@"Print document",@"Action",@"Add bookmark"];
    self.frlang = @[@"Abandonner",@"Vue d'ensemble signet",@"Supprimer le signet",@"Signet",@"Document PDF",@"Le terme de recherche n'a pas été trouvé.",@"Résultats de la recherche",@"Continuer à chercher",@"Ok",@"Texte de recherche",@"Recherche",@"Document suivant",@"Envoyer par mail",@"Document d'impression",@"Action",@"Ajouter un favori"];
    
    self.imgSearch = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAABwwZ6vBoAAAGPSURBVEgNfJO9SgNBFIV3Z2d3IAGLwC5b2Okb5AW2slIsJA9hIxZKCpsN+BY2PoHgAwQkhZ2gPoKV1gq23hP84mQkKS53Zs6559z5y/q+d5PJpFB0XecZa51gLca1Bo7GJjxDfDwel4qUqLliE079Ns7SBPHUAIEYTzmpeIpLI4OUgpqPRqPdqvJ9URQPzuWvFi95ns+dc1d1XbfiUE8jEiXQXB0XgLJAE5+Z4LcZLLz3FyGEw6qqjr1306LIHw37svVLxBFEB3PlpQkABiZ8a92+DYfhIC2GMxiEI9vZu3FvUo7mChrIeBkUawcyaJpmD3LaBMV1vbNvO/ooy/IMDjVwtL5mojvQEW3bQdyhxnaEJ1bz2bZtHRv8MwH8veQFc7pT1hqFKW4mz7ab85RD/eriJaBXpEsGJFMcm4ApW83MHsO9cDjguo61f6JnqlcEQRkDuldOcdvFqd3jE5wY1zgTgLv+gZ4pJDBwzcGUNVeE8GcS44xXxyWyne1c/yAWQEiZohS347q22rtN+A8AAAD//3OiX4cAAAFqSURBVJVTsUrEQBDN7rqbkELSLKRM4Q9IfiA/YCXp7sT2GrGxsongX/gHFoI/YSfY+QtaXHU2CoLzgi+MyyXgwZC5eTPvzdtNsr7vHcNae+2ceeq67qBtW49AjmAPnqyxR+ZevfebtIfzmQZijLUx5qMs8xMSzQmgDpIQwkpmtk3TVPsWQC0bhsFSCIPyu7LWvMV4eDQnQAdVVR6LwE5cnGsO4pyfRFBAoME5dyfD77LlqR7WPb8OdtL3HYJbESMH/09OCECAoGx3gS0lXsTdDc48z/1G8lvcgdS3cOC9W0v+JflZ6gACOKnxTlIRbl/XdZThS3kZHoX4GSGEDxDUdwABqX8WRbHmkuQYnVBgH8iadqiHkXMeAnSU9oxOSKJBLbCEUwRPOsIdcQE8p+OaE6CYxkmg7wB9qENAjvVei48imoCkmuA/OBf4I5J+J5qc26UiSz0kRw/np++ERAAIspYusoRrJ8gx+wNHpgqXwA2hdQAAAABJRU5ErkJggg=="];
    self.imgClose = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAAAr1tloCgAAAB7SURBVEgNYmAYzkCcQs8R1J8GtOAbEDuRaRFIH0g/yBysAOQCkIL/UJpUi2AWwPTj9BG6QmItIlkfqRpIVQ8PRmI1EqsObjA6g5ABhOTRzcPJx2UQLnGcBhGSQDewHKiBklSI0z5ki0BJFJZMQeJUBSAfwCwA0SA+UQAAAAD//4YT9N8AAABqSURBVGNgIA44AZV9A+L/SBjEB4lTBSBbADK4HIhhFlLFInQLYC7HJU6yrwgZREieoIXEGkCsOgwLSdVIqnpwaiEnUom2SJzCVINuEcg8rCANKEpJsoRZBDIHL8DpAry6EJKU6keYNOhYAFBIdPgHcA/NAAAAAElFTkSuQmCC"];
    self.imgThumbs = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAAB6zPPFOAAAAG3SURBVEgNfJO9SsRAFIWDP6DgD9ha2GV2TbFkJmxmXJU0PoBFHsAXkWBrYWWjjegbaGFnIxYuWPsAgo2VYB/vmd2THeLG4jIz99x7vvlJoqqqFsqyXEQURbHEOfIM5kIdOer06NIjmhtjlhHtQqwRXTr7/6vxEJoTkKTDgdLuVml7H0as7UO4bs9nujtXo9E6byDiDgiAEBv7IQZvKrXXysyip+1VGF26wL6k/5KezXVNj72SFMWaFNX9dO8wPCEbuDtuLqyhho3EqX2l5iEQd/XwQMy/k8wNZRc11ixiM0cACOGcGkZAxGPM/ohfhiQfJZ7yPN8gZJ5B2xzrEIC1v2KBUAshY9wx6IAkJt9Hcz/Lj3BCBOZtSBvQCfGCkLGD6byOpxABvuCNAJZ4hs6YB/CbxMciftSbh0eSEJgSIg9400AyexcCVOrOYu2OmQPAQ+RGpMdD8BzNf9IFwRvFxp0ixGAThv4a5eubwN0n8jAnzH9d4UkgeLokIcKAJ6EWGkB3zq1KzfsEYuteZivWQP8DQRJmOEkIwcNzZxjlv9lROj9JnNuS8ULq+U4YfwbObcMrhLD/FwAA//9iayWAAAABjklEQVSdUztOxDAUjPhINNBS08Rhg1hiL7H3A8olcgAuQQVSaOlpWFFwBQo6LrDaW1DScIJd3phMcEJAiOLJzhu/mXnPcVSW5SZCabdItLvHPtZuPdD5mTFmuyiKLZXnB8q4V+QZcn7NQE5p+0Au8ICP9REBinjSWgR7a+2eYMs+8lBE8FWa5UNfb9ycIuCPqqrawAZJlbk51FGcGjvzBZm7osCn43YHLWzkLkMR7L+LiINQhF1iRQGDY/gJl9H6Tloi+PCdCIi9dyedkKRLzmLiNAFxb1ImIhwL5DEpfyc9Iitl7HU8GudpHQPjLALfyDP6cKXHL2L6mSYiCNQjav6uJLM3nDXuh8FcuBLjWmPvh9nkvBHBpiuC3JG1+2k+G4Yhv+kxI8z7vYxXsAvgYnwHHGgAaziuO3Hxhn/c/+e4PIbMmHmuDYYzgksny1jeEkgpAPMQ+non0+muuLiVw0//icTYx/R0ckIBXoMX4TshCHU6YLt095czJCcHaprHSCIc6pJ3jfyG0wjPoPYDypSLgr2TiNYAAAAASUVORK5CYII="];
    self.imgShare = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABIAAAAZCAYAAAA8CX6UAAABfGlDQ1BJQ0MgUHJvZmlsZQAAKJFjYGAqSSwoyGFhYGDIzSspCnJ3UoiIjFJgv8PAzcDDIMRgxSCemFxc4BgQ4MOAE3y7xsAIoi/rgsxK8/x506a1fP4WNq+ZclYlOrj1gQF3SmpxMgMDIweQnZxSnJwLZOcA2TrJBUUlQPYMIFu3vKQAxD4BZIsUAR0IZN8BsdMh7A8gdhKYzcQCVhMS5AxkSwDZAkkQtgaInQ5hW4DYyRmJKUC2B8guiBvAgNPDRcHcwFLXkYC7SQa5OaUwO0ChxZOaFxoMcgcQyzB4MLgwKDCYMxgwWDLoMjiWpFaUgBQ65xdUFmWmZ5QoOAJDNlXBOT+3oLQktUhHwTMvWU9HwcjA0ACkDhRnEKM/B4FNZxQ7jxDLX8jAYKnMwMDcgxBLmsbAsH0PA4PEKYSYyjwGBn5rBoZt5woSixLhDmf8xkKIX5xmbARh8zgxMLDe+///sxoDA/skBoa/E////73o//+/i4H2A+PsQA4AJHdp4IxrEg8AAAAcaURPVAAAAAIAAAAAAAAADQAAACgAAAANAAAADAAAAQ7jrwIXAAAA2klEQVRIDWJgwAMaGhq4LCws9lhbWx8CsfEoxS115swZLn9//0NAFf9B2M/P79DmzZtJM2zbtm3sERERe9TV1S9KSUmtlJWVXampqXkxNDR0D0gOt/VoMkFBQev19fVvFRQUSAKlZoJwVVWVpKGh4a2AgID1aMpxc/X09EqSkpKkoCrABoHYIDEtLa0S3Drxy8ANwqvMwcFBAKjAGA3LI2lCNwgkh6I+MzNTkIGDg+MOUAIcM0g0SDMMoBsE4qOoh5oBFgTZgAugG4SuDqQXZPCoQeghg+CDwwgAAAD//3DnQGsAAABTSURBVGNgYGD4D8TGQIwLzARKgDAuANILMoNOBrm7u1eBMC7nAMWJdhEeM8BSowYRCqFBH9gx0PQAikpSMUjvfwZBQcHtYAYkhYOSOslYQUFhBwCF9oTwQH44aQAAAABJRU5ErkJggg=="];
    self.imgBookmark = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAAAZ87a6qoAAAAzSURBVEgNYmAYYPAfaD+pmGQngywgBZCqHmw2qZpIVT9qCSlRCFFLahiTqn40ToZ7nAAAAAD//wXRkUkAAABXSURBVGNgwA3+45bCKkOqerAhpGoiVf2oJVjjCq8gqWFMqnq8cYLLMFziJPkEZAg6RjaAYktghqMbimwwMhtZHV42zGBCmolVh9UyQoajayJVPbp+yvgAskFGup5UM/wAAAAASUVORK5CYII="];
    self.imgBookmarkFull = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAAAYr6wHiUAAAAuSURBVEgNYqhnYGCgNcZpAdDu/6RiXI4dtQRrUI4GF9ZgwZXqRoNrNLhQShIAAAAA//9BoYhdAAAAT0lEQVRjqGdgYMCGgcL/ScXYzAGJYbUALDFqCZbQGQ0urClv6KQuZJdiy0PI8shsoiIeWQM6G9kydDkYH68lMEXE0CDLcKnDaQkuDeSIAwCKbsEfpIdnNgAAAABJRU5ErkJggg=="];
    self.imgBookmarkClose = [self stringToUIImage:@"iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAAMAAAAn328kIQAAABrSURBVEgN7FJBCsAwCMuT9sM9vcUyIdgolLKbB0GjxiDB+wB/R3oAwDiNTGx5JFtSuAlSuGF9ZPtAvyt1i3LR9btKgs+65YxStbwdfK9IGOM8cm4u8QG1xBjnSpTzrB4XnEcS7xmuegrznQkAAP//Fkd0WgAAAIFJREFUrVFbCoAwDOuRvKFHVyoLxJCWTvwYfeQ1XZxHhDsRcVV7h7kd9DYgQSfiHfcVfztETdXY4VshrcH6rS0HaVo7kXJz7vhbb+LMsfs1pDKr9s9X4iZaVZSzHtYo/4XxwD2LYK64chjnvn0TZ87i7MHJqhjmNgSkSf0UMjGecm6iwcZ/aaXZMgAAAABJRU5ErkJggg=="];
    
    
    // Rechte Barbuttonitems
    UIBarButtonItem *btnFindString = [[UIBarButtonItem alloc]init];
    btnFindString.action = @selector(btnFindStringClick);
    btnFindString.image = self.imgSearch;
    btnFindString.target = self;
    self.navigationItem.rightBarButtonItem = btnFindString;
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc]init];
    btnShare.action = @selector(btnShareClick);
    btnShare.image = self.imgShare;
    btnShare.target = self;
    self.navigationItem.rightBarButtonItem = btnShare;
    UIBarButtonItem *btnThumbs = [[UIBarButtonItem alloc]init];
    btnThumbs.action = @selector(btnThumbClick);
    btnThumbs.image = self.imgThumbs;
    btnThumbs.target = self;
    self.navigationItem.rightBarButtonItems = @[btnFindString,btnShare,btnThumbs];
    
    // Linke Barbuttonitems
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc]init];
    btnClose.action = @selector(btnCloseClick);
    btnClose.image = self.imgClose;
    btnClose.target = self;
    self.btnBookMark = [[UIBarButtonItem alloc]init];
    self.btnBookMark.action = @selector(btnBookmarkClick);
    self.btnBookMark.image = self.imgBookmark;
    self.btnBookMark.target = self;
    self.navigationItem.leftBarButtonItems = @[btnClose, self.btnBookMark];
    
    self.topbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (self.bookmarkPageIndexes == nil) {
        self.bookmarkPageIndexes = [NSMutableArray new];
    }
    
    self.thumbnailsShow = NO;
    self.bookmarksShow = NO;
    self.srchLastKey = -1;
    
    // Dictionary und Array für die Sucheregebnisse
    self.srchDict = [NSMutableDictionary new];
    self.srchDictKeys = [NSMutableArray new];
    
    // Die Suche bei grossen Dokumenten kann länger dauern, daher ein Wait Indicator
    self.waitingIndicatorView = [[UIView alloc] init];
    [self.waitingIndicatorView setFrame:[UIScreen mainScreen].bounds];
    self.waitingIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.waitingIndicatorView.center;
    [self.waitingIndicatorView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    // PDF Doc und Thumbnail View vorbereiten
    NSURL * fileURL = [NSURL fileURLWithPath:self.pdffile];
    self.pdfdoc = [[PDFDocument alloc] initWithURL:fileURL];
    self.pview = [[PDFView alloc] initWithFrame:CGRectMake(0, self.topbarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topbarHeight)];
    self.pview.delegate = self;
    self.pdfdoc.delegate = self;
    self.pview.document = self.pdfdoc;
    // self.pview.pageShadowsEnabled = YES;
    self.pview.displayDirection = kPDFDisplayDirectionHorizontal;
    self.pview.displayMode = kPDFDisplaySinglePage;
    [self.pview setBackgroundColor:[UIColor lightGrayColor]];
    self.thumbView = [[PDFThumbnailView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height + 500.0, self.view.frame.size.width, 80.0)];
    self.thumbView.PDFView = self.pview;
    self.thumbView.backgroundColor = [UIColor lightGrayColor];
    self.thumbView.layoutMode = PDFThumbnailLayoutModeHorizontal;
    self.thumbView.thumbnailSize = CGSizeMake(30.0, 50.0);
    // self.pview.autoScales = YES;
    self.pview.displaysAsBook = YES;
    [self.view addSubview:self.pview];
    [self.view addSubview:self.thumbView];
    
    self.pdfPageCount = (int)[self.pdfdoc pageCount];
    
    
    // Blättern zwischen den Seiten - Gesten
    self.swLeftRecPDF = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPDFPage:)];
    self.swLeftRecPDF.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swRightRecPDF = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(priorPDFPage:)];
    self.swRightRecPDF.direction = UISwipeGestureRecognizerDirectionRight;
    [self.pview addGestureRecognizer:self.swLeftRecPDF];
    [self.pview addGestureRecognizer:self.swRightRecPDF];
    
    
    // Bookmark CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(100.0, 155.0)];
    layout.minimumInteritemSpacing = 5.0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(5.0, 5.0, 15.0, 15.0)];
    self.bookmarkCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.bookmarkCollectionView setDataSource:self];
    [self.bookmarkCollectionView setDelegate:self];
    [self.bookmarkCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"bookmarkcell"];
    [self.bookmarkCollectionView setBackgroundColor:[UIColor lightGrayColor]];
    [self.pview addSubview:self.bookmarkCollectionView];
    [self.bookmarkCollectionView setHidden:YES];
    
    [self scalePDFViewToFit];
    
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (([self.language isEqualToString:@"de"]) || ([self.language isEqualToString:@"en"]) || ([self.language isEqualToString:@"fr"])) {
        if ([self.language isEqualToString:@"de"]) {
            self.langStrings = self.delang;
        }
        if ([self.language isEqualToString:@"en"]) {
            self.langStrings = self.enlang;
        }
        if ([self.language isEqualToString:@"fr"]) {
            self.langStrings = self.frlang;
        }
    } else {
        self.langStrings = self.delang;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

-(void) pdfPageChanged:(NSNotification *) notification {
    
    [self handleBookMarkImage];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSDictionary *udict = @{@"pdffile": self.pdffile, @"indexarray" : self.bookmarkPageIndexes};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dk.appartisan.pdfviewer.komp.close.notification" object:nil userInfo:udict];
    
}


#pragma mark - Thumbnail Methoden


- (void)btnThumbClick {
    
    if (self.thumbnailsShow) {
        [UIView animateWithDuration:0.5 animations:^{
            self.thumbView.frame = CGRectMake(0,self.view.frame.size.height + 500.0, self.view.frame.size.width, 80.0);
            self.thumbnailsShow = NO;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.thumbView.frame = CGRectMake(0,self.view.frame.size.height - 85.0, self.view.frame.size.width, 80.0);
            self.thumbnailsShow = YES;
        }];
    }
}


-(void) hideThumbs:(CGSize) size {
    self.thumbView.frame = CGRectMake(0,size.height + 500.0, size.width, 80.0);
}

-(void) showThumbs:(CGSize) size {
    self.thumbView.frame = CGRectMake(0,size.height - 85.0, size.width, 80.0);
}


#pragma mark - Seitennavigation

-(void) nextPDFPage:(UISwipeGestureRecognizer *) recognizer {
    
    if ([self.pview canGoToNextPage]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.pview goToNextPage:nil];
        }];
    }
}

-(void) priorPDFPage:(UISwipeGestureRecognizer *) recognizer {
    
    if ([self.pview canGoToPreviousPage]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.pview goToPreviousPage:nil];
        }];
    }
}

#pragma mark - Allgemeine Methoden / Hilfsmethoden

- (void)btnCloseClick {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self hideThumbs:size];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        //
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (self.thumbnailsShow) {
            [self showThumbs:size];
        }
        self.topbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        [self.pview setFrame:CGRectMake(0, self.topbarHeight, size.width, size.height - self.topbarHeight)];
        [self.bookmarkCollectionView setFrame:self.view.bounds];
        [self scalePDFViewToFit];
    }];
    
    
}

-(void) scalePDFViewToFit {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pview.scaleFactor = self.pview.scaleFactorForSizeToFit;
        [self.pview layoutIfNeeded];
    }];
    
}

-(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    //    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

-(UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Print, Email, Share Auswahlmenü

- (void)btnShareClick {
    
    NSString *title = [self.langStrings objectAtIndex:14];
    NSString *message = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *printAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:13] style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self printDocument];
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        }];
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:12] style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self emailDocument];
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        }];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:11] style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self shareDocument];
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:0] style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
    
    [alert addAction:printAction];
    [alert addAction:emailAction];
    [alert addAction:shareAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - Suchen Methode

- (void)btnFindStringClick {
    
    
    NSString *title = [self.langStrings objectAtIndex:10];
    NSString *message = @"";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [self.langStrings objectAtIndex:9];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:8] style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         NSArray * textfields = alert.textFields;
                                                         UITextField * myTextField = textfields[0];
                                                         NSString *inputValue = myTextField.text;
                                                         
                                                         [self showWaitingIndicator];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             NSArray *findArray = [self.pdfdoc findString:inputValue withOptions:NSCaseInsensitiveSearch];
                                                             
                                                             if (findArray) {
                                                                 int z = 0;
                                                                 self.srchLastKey = -1;
                                                                 [self.srchDict removeAllObjects];
                                                                 [self.srchDictKeys removeAllObjects];
                                                                 for (PDFSelection *ps in findArray) {
                                                                     NSArray *pages = [ps pages];
                                                                     for (PDFPage *pp in pages) {
                                                                         z++;
                                                                         NSDictionary *tdict = @{@"pselection" : ps , @"ppage" : pp };
                                                                         [self.srchDict setObject:tdict forKey:[NSString stringWithFormat:@"%d",z]];
                                                                     }
                                                                 }
                                                                 if ([self.srchDict count] > 0) {
                                                                     self.srchDictKeys = [[self.srchDict allKeys] mutableCopy];
                                                                     [self.srchDictKeys sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                                                                         return [str1 compare:str2 options:(NSNumericSearch)];
                                                                     }];
                                                                     if ([self.srchDictKeys count] > 0) {
                                                                         self.srchLastKey = 0;
                                                                         NSDictionary *tdict = [self.srchDict objectForKey:[self.srchDictKeys objectAtIndex:0]];
                                                                         PDFPage *tpage = [tdict objectForKey:@"ppage"];
                                                                         PDFSelection *tselection = [tdict objectForKey:@"pselection"];
                                                                         [self.pview goToPage:tpage];
                                                                         [self.pview setCurrentSelection:tselection];
                                                                     }
                                                                 }
                                                                 [self showSearchResult:(int)[self.srchDictKeys count] forText:inputValue];
                                                             } else {
                                                                 [self showSearchResult:0 forText:inputValue];
                                                             }
                                                             
                                                             [self hideWaitingIndicator];
                                                         });
                                                         
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:0] style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
    UIAlertAction *nextAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:7] style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           self.srchLastKey++;
                                                           NSDictionary *tdict = [self.srchDict objectForKey:[self.srchDictKeys objectAtIndex:self.srchLastKey]];
                                                           PDFPage *tpage = [tdict objectForKey:@"ppage"];
                                                           PDFSelection *tselection = [tdict objectForKey:@"pselection"];
                                                           [self.pview goToPage:tpage];
                                                           [self.pview setCurrentSelection:tselection];
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
    
    [alert addAction:okAction];
    if ([self.srchDictKeys count] > 1) {
        if (self.srchLastKey < (int)([self.srchDictKeys count] -1)) {
            [alert addAction:nextAction];
        }
    }
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) showSearchResult:(int) searchCount forText:(NSString*) searchText {
    
    if (searchCount == 0) {
        
        NSString *title = [self.langStrings objectAtIndex:6];
        NSString *message = [NSString stringWithFormat:[self.langStrings objectAtIndex:5],searchText];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:8] style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - Share Methode

-(void) shareDocument {
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSURL *ergurl = [NSURL fileURLWithPath:self.pdffile];
        self.myuic = [UIDocumentInteractionController interactionControllerWithURL:ergurl];
        self.myuic.delegate = self;
        [self.myuic presentOpenInMenuFromRect:CGRectZero inView:self.pview animated:YES];
    });
    
}


#pragma mark - Print Methoden

-(void) printDocument {
    
    NSString *orientation = [self detectPdfOrientation:self.pdffile];
    WKWebView *wvprint = [WKWebView new];
    
    
    NSURL *aurl = [NSURL fileURLWithPath:self.pdffile];
    NSURLRequest *areq = [NSURLRequest requestWithURL:aurl];
    [wvprint loadRequest:areq];
    
    UIPrintInfo *pi = [UIPrintInfo printInfo];
    pi.outputType = UIPrintInfoOutputGeneral;
    pi.jobName = wvprint.URL.absoluteString;
    if ([orientation isEqualToString:@"l"]) {
        pi.orientation = UIPrintInfoOrientationLandscape;
    } else {
        pi.orientation = UIPrintInfoOrientationPortrait;
    }
    pi.duplex = UIPrintInfoDuplexLongEdge;
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.printInfo = pi;
    pic.printFormatter = wvprint.viewPrintFormatter;
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
        
    }];
    
}

-(NSString *)detectPdfOrientation:(NSString*)filePath {
    
    const char *filestring = [filePath UTF8String];
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString (NULL, filestring,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    
    document = CGPDFDocumentCreateWithURL((CFURLRef)url);
    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1);
    CGRect appRect = CGPDFPageGetBoxRect (page, 0);
    
    if (appRect.size.width > appRect.size.height) {
        return @"l";
    } else {
        return @"p";
    }
    
    return nil;
}


#pragma mark - EMail Methoden

-(void) emailDocument {
    
    
    NSString *emailTitle =  [self.langStrings objectAtIndex:4];
    
    NSString *messageBody = @"";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    NSString *docname = [self.pdffile lastPathComponent];
    NSString *attfile = self.pdffile;
    NSData *myData = [NSData dataWithContentsOfFile:attfile];
    [mc addAttachmentData:myData mimeType:@"application/pdf" fileName:docname];
    
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // Email Interface PopUp schliessen
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark - Waiting Inidcator Methoden

-(void) showWaitingIndicator {
    if([self.waitingIndicatorView isDescendantOfView:self.pview]) {
        [self.waitingIndicatorView removeFromSuperview];
    }
    [self.pview addSubview:self.waitingIndicatorView];
}

-(void) hideWaitingIndicator {
    if([self.waitingIndicatorView isDescendantOfView:self.pview]) {
        [self.waitingIndicatorView removeFromSuperview];
    }
}

#pragma mark - Bookmark Methoden

- (void)btnBookmarkClick {
    
    if (self.bookmarksShow == YES) {
        [self.bookmarkCollectionView setHidden:YES];
        self.bookmarksShow = NO;
        [self handleBookMarkImage];
    } else {
        
        PDFPage *page = [self.pview currentPage];
        NSUInteger pindex = [self.pdfdoc indexForPage:page];
        NSString *spindex = [NSString stringWithFormat:@"%d",(int)pindex];
        
        NSUInteger i = [self.bookmarkPageIndexes indexOfObject:spindex];
        
        if (i == NSNotFound) {
            NSString *title = [self.langStrings objectAtIndex:3];
            NSString *message = @"";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:15] style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 // dosomething
                                                                 
                                                                 [self.bookmarkPageIndexes addObject:spindex];
                                                                 [self handleBookMarkImage];
                                                                 
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                             }];
            
            UIAlertAction *overviewAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:1] style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [self.bookmarkPageIndexes sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                                                                           return [str1 compare:str2 options:(NSNumericSearch)];
                                                                       }];
                                                                       [self.bookmarkCollectionView reloadData];
                                                                       [self.bookmarkCollectionView setHidden:NO];
                                                                       self.bookmarksShow = YES;
                                                                       self.btnBookMark.image = self.imgBookmarkClose;
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
            
            UIAlertAction *abbruchAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:0] style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            
            [alert addAction:okAction];
            if ([self.bookmarkPageIndexes count] > 0) {
                [alert addAction:overviewAction];
            }
            [alert addAction:abbruchAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            NSString *title = [self.langStrings objectAtIndex:3];
            NSString *message = @"";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:2] style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 // dosomething
                                                                 [self.bookmarkPageIndexes removeObjectAtIndex:i];
                                                                 [self handleBookMarkImage];
                                                                 
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                             }];
            
            UIAlertAction *overviewAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:1] style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [self.bookmarkPageIndexes sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                                                                           return [str1 compare:str2 options:(NSNumericSearch)];
                                                                       }];
                                                                       [self.bookmarkCollectionView reloadData];
                                                                       [self.bookmarkCollectionView setHidden:NO];
                                                                       self.bookmarksShow = YES;
                                                                       self.btnBookMark.image = self.imgBookmarkClose;
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
            
            UIAlertAction *abbruchAction = [UIAlertAction actionWithTitle:[self.langStrings objectAtIndex:0] style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            
            [alert addAction:okAction];
            if ([self.bookmarkPageIndexes count] > 0) {
                [alert addAction:overviewAction];
            }
            [alert addAction:abbruchAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

-(void) handleBookMarkImage {
    
    if (self.bookmarksShow == YES) {
        self.btnBookMark.image = self.imgBookmarkClose;
    } else {
        PDFPage *page = [self.pview currentPage];
        NSUInteger pindex = [self.pdfdoc indexForPage:page];
        NSString *spindex = [NSString stringWithFormat:@"%d",(int)pindex];
        
        NSUInteger i = [self.bookmarkPageIndexes indexOfObject:spindex];
        if (i == NSNotFound) {
            self.btnBookMark.image = self.imgBookmark;
        } else {
            self.btnBookMark.image = self.imgBookmarkFull;
        }
    }
}


#pragma mark - Klassen Methoden

// Thumbnail der ersten Seite einer PDF Datei erstellen und zurückgeben
+(UIImage *) getPdfThumbnailFromPDFFile:(NSString *) fromFilePath withWidth:(CGFloat) width {
    
    UIImage *retImage;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fromFilePath]) {
        
        NSURL *url = [NSURL fileURLWithPath:fromFilePath];
        PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
        PDFPage *page = [doc pageAtIndex:0];
        CGRect pageSize = [page boundsForBox:kPDFDisplayBoxMediaBox];
        CGFloat pdfScale = width / pageSize.size.width;
        CGFloat scale = UIScreen.mainScreen.scale * pdfScale;
        CGSize screensize = CGSizeMake(pageSize.size.width * scale, pageSize.size.height * scale);
        
        retImage = [page thumbnailOfSize:screensize forBox:kPDFDisplayBoxMediaBox];
    }
    
    return retImage;
}

+(UIImage *) getPdfThumbnailFromPDFPage:(PDFPage *)inPDFPage withWidth:(CGFloat) width {
    
    UIImage *retImage;
    
    if (inPDFPage != nil) {
        
        PDFPage *page = inPDFPage;
        CGRect pageSize = [page boundsForBox:kPDFDisplayBoxMediaBox];
        CGFloat pdfScale = width / pageSize.size.width;
        CGFloat scale = UIScreen.mainScreen.scale * pdfScale;
        CGSize screensize = CGSizeMake(pageSize.size.width * scale, pageSize.size.height * scale);
        
        retImage = [page thumbnailOfSize:screensize forBox:kPDFDisplayBoxMediaBox];
    }
    
    return retImage;
}


#pragma mark - Collectionview Delegates

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *spindex = [self.bookmarkPageIndexes objectAtIndex:indexPath.row];
    NSUInteger pindex = (NSUInteger)[spindex integerValue];
    PDFPage *page = [self.pdfdoc pageAtIndex:pindex];
    [self.pview goToPage:page];
    [self.bookmarkCollectionView setHidden:YES];
    self.bookmarksShow = NO;
    [self handleBookMarkImage];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookmarkcell" forIndexPath:indexPath];
    
    NSString *spindex = [self.bookmarkPageIndexes objectAtIndex:indexPath.row];
    NSUInteger pindex = (NSUInteger)[spindex integerValue];
    
    PDFPage *page = [self.pdfdoc pageAtIndex:pindex];
    
    UIImage *pimg = [pdfViewVC getPdfThumbnailFromPDFPage:page withWidth:90.0];
    
    for (UIView *i in [cell.contentView subviews]) {
        [i removeFromSuperview];
    }
    
    if (pimg != nil) {
        UIImageView *imgv = [[UIImageView alloc] initWithImage:pimg];
        [imgv setFrame:CGRectMake(10.0, 10.0, 90.0, 125.0)];
        [cell addSubview:imgv];
    }
    
    UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 145.0, 90.0, 20.0)];
    lbltitle.textColor = [UIColor blackColor];
    lbltitle.text = [NSString stringWithFormat:@"%@",page.label];
    lbltitle.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:lbltitle];
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.bookmarkPageIndexes count];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


@end
