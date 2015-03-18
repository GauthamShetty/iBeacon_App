//
//  ProductViewController.m
//  iBeacon_Retail
//
//  Created by shruthi on 02/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "ProductViewController.h"
#import "prodCell.h"
#import "Products.h"
#import "NetworkOperations.h"

typedef void (^ DataCallbackBlock)(id, int);

@interface ProductViewController ()
@property(nonatomic,strong) Products * product;
@property(nonatomic,strong)NetworkOperations *networks;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"prodCell" bundle:nil];
    [self.prodCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"prodCell"];
    if(![self.dataArray count]>0){
          [self getProductListing];
    }
  
}


-(void) getProductListing{
    self.networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Prod_Api"]);
 // send block as parameter to get callbacks
    [self.networks fetchDataFromServer:[dict objectForKey:@"Prod_Api"] withreturnMethod:^(NSMutableArray* data){
        self.dataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[self.dataArray count]);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.prodCollectionView reloadData];
                           
                       });
    }];
   // [self.prodCollectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Collection view delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    prodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"prodCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    
    Products *prodObject= [[Products alloc] initWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    cell.productName.text=prodObject.prodName;
    return cell;
 
}

#pragma searchBar delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self applyFilters:[NSSet setWithObject:searchBar.text]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end