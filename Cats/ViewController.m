//
//  ViewController.m
//  Cats
//
//  Created by Thomas Alexanian on 2016-11-21.
//  Copyright © 2016 Thomas Alexanian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray<Photo*> *photos;
@property (nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=bf34b7ad76edfca25529531b8fc2f869&tags=cat"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    
    self.photos = [NSMutableArray new];
    [self pullData:urlRequest];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [self.view addGestureRecognizer:tap];
}

-(void)didTap {
    [self.searchTextField resignFirstResponder];
}

-(void)pullData:(NSURLRequest*)urlReq {
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:urlReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        
        NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        
        assert(self.photos);
        [self.photos removeAllObjects];
        for (NSDictionary *dict in tempDict[@"photos"][@"photo"]) {
            
            Photo *photo = [[Photo alloc] initWithInfo:dict];
            [self.photos addObject:photo];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
            
        }];
    }];
    
    [dataTask resume];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    Photo* photo = self.photos[indexPath.item];
    
    if (!photo.image)
    {
        NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString: photo.url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error: %@", error.localizedDescription);
                return;
            }
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            photo.image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.cellImageView.image = photo.image;
            }];
        }];
        
        [downloadTask resume];
    }
    else
    {
        cell.cellImageView.image = photo.image;
    }
    
    cell.cellLabel.text = self.photos[indexPath.row].title;
    
    return cell;
}


- (IBAction)onButtonTapped:(id)sender {
    NSString *encodedSearchText = [self.searchTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=bf34b7ad76edfca25529531b8fc2f869&tags=%@", encodedSearchText];
    NSURLRequest *newUrlRequest = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:str]];
    [self pullData:newUrlRequest];
    [self.searchTextField resignFirstResponder];
}



@end
