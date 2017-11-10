//
//  ViewController.m
//  Less_26
//
//  Created by Andrey Proskurin on 10.11.17.
//  Copyright © 2017 Andrey Proskurin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end











