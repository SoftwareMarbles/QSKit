//
//  NSStringTests.m
//  Q Branch Standard Kit
//
//  Created by Brent Simmons on 10/31/13.
//  Copyright (c) 2013 Q Branch LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+QSKit.h"


@interface NSStringTests : XCTestCase
@end

@implementation NSStringTests


- (void)testQSStringIsEmpty {

	XCTAssertTrue(QSStringIsEmpty(nil));
	XCTAssertTrue(QSStringIsEmpty(@""));

	XCTAssertFalse(QSStringIsEmpty(@" "));
	XCTAssertFalse(QSStringIsEmpty(@"foo"));
}


- (void)testQSEqualStrings {

	NSString *s1 = nil;
	NSString *s2 = nil;

	XCTAssertTrue(QSEqualStrings(s1, s2));

	s2 = @"Foo";
	XCTAssertFalse(QSEqualStrings(s1, s2));

	s1 = @"Bar";
	s2 = nil;
	XCTAssertFalse(QSEqualStrings(s1, s2));

	s1 = @"x";
	s2 = @"y";
	XCTAssertFalse(QSEqualStrings(s1, s2));

	s1 = @"";
	s2 = @"";
	XCTAssertTrue(QSEqualStrings(s1, s2));

	s1 = @"I am un chien";
	s2 = @"Andalusia";
	XCTAssertFalse(QSEqualStrings(s1, s2));
}


- (void)testQSStringReplaceAll {

	NSString *s = @"where is my cat";
	s = QSStringReplaceAll(s, @"cat", @"mind");
	XCTAssertEqualObjects(s, @"where is my mind");

	s = QSStringReplaceAll(s, @"dog", @"foo");
	XCTAssertEqualObjects(s, @"where is my mind");

	XCTAssertNotNil(QSStringReplaceAll(@"", @"foo", @"bar"));
	XCTAssertNil(QSStringReplaceAll(nil, @"foo", @"bar"));
}


- (void)testQSMD5HashString {

	NSString *s = @"Walked the sand with the crustaceans";
	NSString *hashString = [s qs_md5HashString];
	NSString *expectedHashString = @"612c8f4562f9e9c5b4ca9c8369fab59e";

	/*Original value comes from command line: md5 -s 'Walked the sand with the crustaceans'*/

	XCTAssertTrue([hashString isEqualToString:expectedHashString]);

	s = @"Garfiéld";
	hashString = [s qs_md5HashString];
	expectedHashString = @"0fdde95291a6bf0d0f22492067249382";
	XCTAssertTrue([hashString isEqualToString:expectedHashString]);
}


- (void)testQSMD5Hash {

	NSString *s = @"Walked the sand with the crustaceans";
	NSData *hashData = [s qs_md5Hash];
	static const unsigned char expectedHashData[] = {0x61, 0x2c, 0x8f, 0x45, 0x62, 0xf9, 0xe9, 0xc5, 0xb4, 0xca, 0x9c, 0x83, 0x69, 0xfa, 0xb5, 0x9e};

	XCTAssertEqual((size_t)[hashData length], sizeof(expectedHashData));
	OSStatus result = memcmp([hashData bytes], expectedHashData, sizeof(expectedHashData));
	XCTAssertEqual(result, (OSStatus)0);

	s = @"Garfiéld";
	hashData = [s qs_md5Hash];
	static const unsigned char expectedHashData2[] = {0x0f, 0xdd, 0xe9, 0x52, 0x91, 0xa6, 0xbf, 0x0d, 0x0f, 0x22, 0x49, 0x20, 0x67, 0x24, 0x93, 0x82};

	XCTAssertEqual((size_t)[hashData length], sizeof(expectedHashData));
	result = memcmp([hashData bytes], expectedHashData2, sizeof(expectedHashData2));
	XCTAssertEqual(result, (OSStatus)0);
}


- (void)testQSStringWithCollapsedWhitespace {

	NSString *s = @"   ";
	XCTAssertTrue([[s qs_stringWithCollapsedWhitespace] isEqualToString:@""]);

	s = @"   x   ";
	XCTAssertTrue([[s qs_stringWithCollapsedWhitespace] isEqualToString:@"x"]);

	s = @"  x\t  \ny foo\r";
	XCTAssertTrue([[s qs_stringWithCollapsedWhitespace] isEqualToString:@"x y foo"]);

	s = @"Foo";
	XCTAssertTrue([[s qs_stringWithCollapsedWhitespace] isEqualToString:@"Foo"]);
}


- (void)testQSStringByTrimmingWhitespace {

	NSString *s = @"   ";
	XCTAssertTrue([[s qs_stringByTrimmingWhitespace] isEqualToString:@""]);

	s = @" \t\r\n \n  ";
	XCTAssertTrue([[s qs_stringByTrimmingWhitespace] isEqualToString:@""]);

	s = @"   x   ";
	XCTAssertTrue([[s qs_stringByTrimmingWhitespace] isEqualToString:@"x"]);

	s = @"  x\t  \ny foo\r";
	XCTAssertTrue([[s qs_stringByTrimmingWhitespace] isEqualToString:@"x\t  \ny foo"]);

	s = @"Foo";
	XCTAssertTrue([[s qs_stringByTrimmingWhitespace] isEqualToString:@"Foo"]);
}


- (void)testQSRGBAComponents {

	NSString *s = @"#x";
	QSRGBAComponents components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red == 0.0f && components.green == 0.0f && components.blue == 0.0f && components.alpha == 1.0f);

	s = @"#FFFFFF";
	components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red > 0.99f && components.green > 0.99f && components.blue > 0.99f && components.alpha > 0.99f);

	s = @"000000";
	components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red == 0.0f && components.green == 0.0f && components.blue == 0.0f && components.alpha == 1.0f);

	s = @"#000000";
	components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red == 0.0f && components.green == 0.0f && components.blue == 0.0f && components.alpha == 1.0f);

	s = @"FF00FF7F";
	components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red > 0.99f && components.green == 0.0f && components.blue > 0.99f && components.alpha < 0.5f && components.alpha > 0.49f);

	s = @"00FF";
	components = [s qs_rgbaComponents];
	XCTAssertTrue(components.red == 0.0f && components.green > 0.99f && components.blue == 0.0f && components.alpha > 0.99f);

	s = @"drive my car into the ocean";
	/*No matter what the input, there will be a result. Shouldn't crash or throw exception here.*/
	XCTAssertNoThrow([s qs_rgbaComponents]);

	s = nil;
	XCTAssertNoThrow([s qs_rgbaComponents]);
	s = @"";
	XCTAssertNoThrow([s qs_rgbaComponents]);
	s = @"  ";
	XCTAssertNoThrow([s qs_rgbaComponents]);
	s = @"     ";
	XCTAssertNoThrow([s qs_rgbaComponents]);
	s = @"  \t   ";
	XCTAssertNoThrow([s qs_rgbaComponents]);
}


- (void)testQSStringByStrippingPrefix {

	NSString *s = @"Foobar";

	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"Foo" caseSensitive:YES], @"bar");
	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"foo" caseSensitive:YES], @"Foobar");

	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"foo" caseSensitive:NO], @"bar");
	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"Foo" caseSensitive:NO], @"bar");

	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"bar" caseSensitive:YES], @"Foobar");
	XCTAssertEqualObjects([s qs_stringByStrippingPrefix:@"bar" caseSensitive:NO], @"Foobar");
}


- (void)testQSLinks {

	XCTAssertEqualObjects([@"www.example.com" qs_links], @[@"www.example.com"]);
	XCTAssertEqualObjects([@"http://www.example.com" qs_links], @[@"http://www.example.com"]);

	/*Tests from Justin: http://carpeaqua.com/2014/02/08/adventures-in-debugging-nsregularexpression-edition/
	 The regular expression he was using in Glassboard had a bug with ) characters.
	 That bug is fixed in the regular expression used by QSKit.*/

	NSString *samplePost = @"This is a post with http://carpeaqua.com/ https://log.carpeaqua.com http://daringfireball.net";
	NSArray *expectedResult = @[@"http://carpeaqua.com/", @"https://log.carpeaqua.com", @"http://daringfireball.net"];
	XCTAssertEqualObjects([samplePost qs_links], expectedResult);

	NSString *sampleWithRegex1 = @"Hi there.\n\n^((\\S.*)(\\:)$)((?s).*?)(?!(^.+\\:))\n\nHere's my a test post";
	XCTAssertEqual([[sampleWithRegex1 qs_links] count], (NSUInteger)0);

	NSString *sampleWithRegex2 = @"(.+\n)*(?=\\s*$) http://carpeaqua.com";
	expectedResult = @[@"http://carpeaqua.com"];
	XCTAssertEqualObjects([sampleWithRegex2 qs_links], expectedResult);

	NSString *markdownPost = @"[http://daringfireball.net](http://carpeaqua.com)";
	expectedResult = @[@"http://daringfireball.net", @"http://carpeaqua.com"];
	XCTAssertEqualObjects([markdownPost qs_links], expectedResult);
}

@end
