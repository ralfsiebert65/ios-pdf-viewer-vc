//
//  masterTblVC.m
//
//  Created by Ralf Siebert - AppArtisan.dk
//

#import "masterTblVC.h"

@interface masterTblVC ()
    
@property (strong, nonatomic) NSMutableDictionary *pdflist;
@property (strong, nonatomic) NSMutableArray *pdflistkeys;
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) NSString *selectedPDF;


@end

@implementation masterTblVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pdflist = [NSMutableDictionary new];
    
    self.tView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.pdflist removeAllObjects];
    NSString *a = [[NSBundle mainBundle] pathForResource:@"testpdf1" ofType:@"pdf"];
    NSString *b = [[NSBundle mainBundle] pathForResource:@"testpdf2" ofType:@"pdf"];
    
    [self.pdflist setObject:a forKey:@"testpdf1.pdf"];
    [self.pdflist setObject:b forKey:@"testpdf2.pdf"];
    
    [self.pdflistkeys removeAllObjects];
    self.pdflistkeys = [[self.pdflist allKeys] mutableCopy];
    
    [self.tView reloadData];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.pdflistkeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pdfcell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.pdflistkeys objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *pdfkey = [self.pdflistkeys objectAtIndex:indexPath.row];
    self.selectedPDF = [self.pdflist objectForKey:pdfkey];
    
    [self performSegueWithIdentifier:@"pdfviewsegue" sender:self];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"pdfviewsegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        pdfViewVC *dvc = (pdfViewVC *)([navController viewControllers][0]);
        dvc.pdffile = self.selectedPDF;
        dvc.bookmarkPageIndexes = [@[@"1",@"4"] mutableCopy];
        self.selectedPDF = @"";

    }
    
}


@end
