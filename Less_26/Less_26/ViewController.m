//
//  ViewController.m
//  Less_26
//
//  Created by Andrey Proskurin on 10.11.17.
//  Copyright © 2017 Andrey Proskurin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOutlet;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchArray;

@property (assign, nonatomic) BOOL isSearchMode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.searchArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 30; i++) {
        [self.dataArray insertObject:[NSString stringWithFormat:@"String %lu", i+1] atIndex:i];
    }
    //[self createSomeFile];
    [self readFromFile];
    [self verifyEmail:@"1qweqweqweqe.12qwasda@gmaqqqweqweil.coooqqweqwe"];
    [self verifyPassword:@"qwe12qqqweqq"];
    
}

#pragma mark - создание с чтение из файла

- (void)createSomeFile {
    // информация о пути к файлу
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDirectory = path.firstObject;
    NSString *pathWithFileName = [pathDirectory stringByAppendingPathComponent:@"some file.txt"];
    
    NSString *someText = @"1\n2\n3\n4\n5";
    
    NSError *error = nil;
    BOOL success = [someText writeToFile:pathWithFileName
                              atomically:YES
                                encoding:NSUTF8StringEncoding
                                   error:&error];
    
    NSLog(@"%@", success ? @"File saved!" : @"File isn't created");
}

- (void)readFromFile {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDirectory = path.firstObject;
    NSString *pathWithFileName = [pathDirectory stringByAppendingPathComponent:@"some file.txt"];
    
    NSError *error = nil;
    NSString *textFromFile = [NSString stringWithContentsOfFile:pathWithFileName
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    NSLog(@"%@", textFromFile);
}

#pragma mark - NSRegularExpression

- (void)verifyEmail:(NSString *)email {
    
    if (email.length == 0) {
        return; // return nil;
    }
    // переделать паттерн
    NSString *regExPattern = @"([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}\\.([a-z0-9]){2,4}"; // почитать
    
    NSError *error = nil;
    NSRegularExpression *regExp =
    [[NSRegularExpression alloc] initWithPattern:regExPattern
                                         options:NSRegularExpressionCaseInsensitive
                                           error:&error];
    NSUInteger regMatches = [regExp numberOfMatchesInString:email
                                                    options:0
                                                      range:NSMakeRange(0, email.length)];
    
    NSLog(@"%lu", regMatches);
    
//    изменить проверку на валидность
    if (regMatches == 0) {
        NSLog(@"%@", @"Email is not valid");
    } else {
        NSLog(@"%@", @"Email is valid");
    }
}

- (void)verifyPassword:(NSString *)password {
    if (password.length == 0) {
        return; // return nil;
    }
//    переделать паттерн
    NSString *regExPattern = @"([A-Za-z0-9]){4,8}"; // почитать
    
    NSError *error = nil;
    NSRegularExpression *regExp =
    [[NSRegularExpression alloc] initWithPattern:regExPattern
                                         options:NSRegularExpressionCaseInsensitive
                                           error:&error];
    NSUInteger regMatches = [regExp numberOfMatchesInString:password
                                                    options:0
                                                      range:NSMakeRange(0, password.length)];
    
    NSLog(@"%lu", regMatches);
    
//    изменить проверку на валидность
    if (regMatches == 0) {
        NSLog(@"%@", @"Password is not valid");
    } else {
        NSLog(@"%@", @"Password is valid");
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSearchMode ? self.searchArray.count : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.isSearchMode ? self.searchArray[indexPath.row] : self.dataArray[indexPath.row];
}



#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked");
    
    [searchBar resignFirstResponder];
    [self.tableViewOutlet reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarCancelButtonClicked");
    
    self.searchBarOutlet.text = @"";
    self.isSearchMode = NO;
    [searchBar resignFirstResponder];
    [self.tableViewOutlet reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearchMode = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
    
    if (self.searchBarOutlet.text.length != 0) {
        self.isSearchMode = YES;
    } else {
        self.isSearchMode = NO;
    }
    
    [self.tableViewOutlet reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
    
    [self.searchArray removeAllObjects];
    
    if(searchText.length != 0) {
        self.isSearchMode = YES;
        [self searchText];
    } else {
        self.isSearchMode = NO;
    }
    
    [self.tableViewOutlet reloadData];
}

#pragma mark - private

- (void)searchText {
    NSString *searchText = self.searchBarOutlet.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    self.searchArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
}

@end











