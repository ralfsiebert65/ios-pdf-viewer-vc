//
//  pdfViewVC.h
//
//  Created by Ralf Siebert - AppArtisan.dk
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
#import <WebKit/WebKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface pdfViewVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, PDFViewDelegate, PDFDocumentDelegate, UIDocumentInteractionControllerDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *pdffile;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSMutableArray *bookmarkPageIndexes;

+(UIImage *) getPdfThumbnailFromPDFFile:(NSString *) fromFilePath withWidth:(CGFloat) width;

@end

NS_ASSUME_NONNULL_END
