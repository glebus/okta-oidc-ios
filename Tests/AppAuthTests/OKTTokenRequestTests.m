/*! @file OKTTokenRequestTests.m
    @brief AppAuth iOS SDK
    @copyright
        Copyright 2015 Google Inc. All Rights Reserved.
    @copydetails
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
    @modifications
        Copyright (C) 2019 Okta Inc.
 */

#import "OKTTokenRequestTests.h"

#import "OKTAuthorizationResponseTests.h"
#import "OKTServiceConfigurationTests.h"
#import "OKTAuthorizationRequest.h"
#import "OKTAuthorizationResponse.h"
#import "OKTScopeUtilities.h"
#import "OKTServiceConfiguration.h"
#import "OKTTokenRequest.h"

// Ignore warnings about "Use of GNU statement expression extension" which is raised by our use of
// the XCTAssert___ macros.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"

/*! @brief Test value for the @c refreshToken property.
 */
static NSString *const kRefreshTokenTestValue = @"refresh_token";

/*! @brief Test key for the @c additionalParameters property.
 */
static NSString *const kTestAdditionalParameterKey = @"A";

/*! @brief Test value for the @c additionalParameters property.
 */
static NSString *const kTestAdditionalParameterValue = @"1";

@implementation OKTTokenRequestTests

+ (OKTTokenRequest *)testInstance {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstance];
  NSArray<NSString *> *scopesArray =
      [OKTScopeUtilities scopesArrayWithString:authResponse.request.scope];
  NSDictionary *additionalParameters =
      @{ kTestAdditionalParameterKey : kTestAdditionalParameterValue };
  OKTTokenRequest *request =
      [[OKTTokenRequest alloc] initWithConfiguration:authResponse.request.configuration
                                           grantType:OKTGrantTypeAuthorizationCode
                                   authorizationCode:authResponse.authorizationCode
                                         redirectURL:authResponse.request.redirectURL
                                            clientID:authResponse.request.clientID
                                        clientSecret:authResponse.request.clientSecret
                                              scopes:scopesArray
                                        refreshToken:kRefreshTokenTestValue
                                        codeVerifier:authResponse.request.codeVerifier
                                        deviceSecret:nil
                                        subjectToken:nil
                                additionalParameters:additionalParameters];
  return request;
}

+ (OKTTokenRequest *)testInstanceCodeExchange {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstanceCodeFlow];
  NSArray<NSString *> *scopesArray =
      [OKTScopeUtilities scopesArrayWithString:authResponse.request.scope];
  NSDictionary *additionalParameters =
      @{ kTestAdditionalParameterKey : kTestAdditionalParameterValue };
  OKTTokenRequest *request =
      [[OKTTokenRequest alloc] initWithConfiguration:authResponse.request.configuration
                                           grantType:OKTGrantTypeAuthorizationCode
                                   authorizationCode:authResponse.authorizationCode
                                         redirectURL:authResponse.request.redirectURL
                                            clientID:authResponse.request.clientID
                                        clientSecret:authResponse.request.clientSecret
                                              scopes:scopesArray
                                        refreshToken:kRefreshTokenTestValue
                                        codeVerifier:authResponse.request.codeVerifier
                                        deviceSecret:nil
                                        subjectToken:nil
                                additionalParameters:additionalParameters];
  return request;
}

+ (OKTTokenRequest *)testInstanceCodeExchangeClientAuth {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstanceCodeFlowClientAuth];
  NSArray<NSString *> *scopesArray =
      [OKTScopeUtilities scopesArrayWithString:authResponse.request.scope];
  NSDictionary *additionalParameters =
      @{ kTestAdditionalParameterKey : kTestAdditionalParameterValue };
  OKTTokenRequest *request =
      [[OKTTokenRequest alloc] initWithConfiguration:authResponse.request.configuration
                                           grantType:OKTGrantTypeAuthorizationCode
                                   authorizationCode:authResponse.authorizationCode
                                         redirectURL:authResponse.request.redirectURL
                                            clientID:authResponse.request.clientID
                                        clientSecret:authResponse.request.clientSecret
                                              scopes:scopesArray
                                        refreshToken:kRefreshTokenTestValue
                                        codeVerifier:authResponse.request.codeVerifier
                                        deviceSecret:nil
                                        subjectToken:nil
                                additionalParameters:additionalParameters];
  return request;
}

+ (OKTTokenRequest *)testInstanceRefresh {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstance];
  NSArray<NSString *> *scopesArray =
      [OKTScopeUtilities scopesArrayWithString:authResponse.request.scope];
  NSDictionary *additionalParameters =
      @{ kTestAdditionalParameterKey : kTestAdditionalParameterValue };
  OKTTokenRequest *request =
      [[OKTTokenRequest alloc] initWithConfiguration:authResponse.request.configuration
                                           grantType:OKTGrantTypeAuthorizationCode
                                   authorizationCode:authResponse.authorizationCode
                                         redirectURL:nil
                                            clientID:authResponse.request.clientID
                                        clientSecret:authResponse.request.clientSecret
                                              scopes:scopesArray
                                        refreshToken:kRefreshTokenTestValue
                                        codeVerifier:authResponse.request.codeVerifier
                                        deviceSecret:nil
                                        subjectToken:nil
                                additionalParameters:additionalParameters];
  return request;
}

/*! @brief Tests the @c NSCopying implementation by round-tripping an instance through the copying
        process and checking to make sure the source and destination instances are equivalent.
 */
- (void)testCopying {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstance];
  OKTTokenRequest *request = [[self class] testInstance];

  XCTAssertEqualObjects(request.configuration.authorizationEndpoint,
                        authResponse.request.configuration.authorizationEndpoint,
                        @"Request and response authorization endpoints should be equal.");
  XCTAssertEqualObjects(request.grantType, OKTGrantTypeAuthorizationCode,
                        @"Request grant type should be OKTGrantTypeAuthorizationCode.");
  XCTAssertEqualObjects(request.authorizationCode, authResponse.authorizationCode,
                        @"Request and response authorization codes should be equal.");
  XCTAssertEqualObjects(request.redirectURL, authResponse.request.redirectURL,
                        @"Request and response redirectURLs should be equal.");
  XCTAssertEqualObjects(request.clientID, authResponse.request.clientID,
                        @"Request and response clientIDs should be equal.");
  XCTAssertEqualObjects(request.clientSecret, authResponse.request.clientSecret,
                        @"Request and response clientSecrets should be equal.");
  XCTAssertEqualObjects(request.scope, authResponse.request.scope,
                        @"Request and response scope values should be equal.");
  XCTAssertEqualObjects(request.refreshToken, kRefreshTokenTestValue,
                        @"Request refreshToken should be equal to kRefreshTokenTestValue.");
  XCTAssertEqualObjects(request.codeVerifier, authResponse.request.codeVerifier,
                        @"Request and response codeVerifiers should be equal.");
  XCTAssertNotNil(request.additionalParameters,
                        @"Request's additionalParameters field should not be nil.");
  XCTAssertEqualObjects(request.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue,
                        @"The request's kTestAdditionalParameterKey additional parameter should "
                        "be equal to kTestAdditionalParameterValue.");

  OKTTokenRequest *requestCopy = [request copy];

  // Not a full test of the configuration deserialization, but should be sufficient as a smoke test
  // to make sure the configuration IS actually getting carried along in the copy implementation.
  XCTAssertEqualObjects(requestCopy.configuration.authorizationEndpoint,
                        request.configuration.authorizationEndpoint, @"");

  XCTAssertEqualObjects(requestCopy.grantType, request.grantType, @"");
  XCTAssertEqualObjects(requestCopy.authorizationCode, request.authorizationCode, @"");
  XCTAssertEqualObjects(requestCopy.redirectURL, request.redirectURL, @"");
  XCTAssertEqualObjects(requestCopy.clientID, request.clientID, @"");
  XCTAssertEqualObjects(requestCopy.clientSecret, request.clientSecret, @"");
  XCTAssertEqualObjects(requestCopy.scope, authResponse.request.scope, @"");
  XCTAssertEqualObjects(requestCopy.refreshToken, kRefreshTokenTestValue, @"");
  XCTAssertEqualObjects(requestCopy.codeVerifier, authResponse.request.codeVerifier, @"");
  XCTAssertNotNil(requestCopy.additionalParameters, @"");
  XCTAssertEqualObjects(requestCopy.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue, @"");
}

/*! @brief Tests the @c NSSecureCoding by round-tripping an instance through the coding process and
        checking to make sure the source and destination instances are equivalent.
 */
- (void)testSecureCoding {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstance];
  OKTTokenRequest *request = [[self class] testInstance];

  XCTAssertEqualObjects(request.configuration.authorizationEndpoint,
                        authResponse.request.configuration.authorizationEndpoint, @"");
  XCTAssertEqualObjects(request.grantType, OKTGrantTypeAuthorizationCode, @"");
  XCTAssertEqualObjects(request.authorizationCode, authResponse.authorizationCode, @"");
  XCTAssertEqualObjects(request.redirectURL, authResponse.request.redirectURL, @"");
  XCTAssertEqualObjects(request.clientID, authResponse.request.clientID, @"");
  XCTAssertEqualObjects(request.clientSecret, authResponse.request.clientSecret, @"");
  XCTAssertEqualObjects(request.scope, authResponse.request.scope, @"");
  XCTAssertEqualObjects(request.refreshToken, kRefreshTokenTestValue, @"");
  XCTAssertEqualObjects(request.codeVerifier, authResponse.request.codeVerifier, @"");
  XCTAssertNotNil(request.additionalParameters, @"");
  XCTAssertEqualObjects(request.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue, @"");

  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:request];
  OKTTokenRequest *requestCopy = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  // Not a full test of the configuration deserialization, but should be sufficient as a smoke test
  // to make sure the configuration IS actually getting serialized and deserialized in the
  // NSSecureCoding implementation. We'll leave it up to the OKTServiceConfiguration tests to make
  // sure the NSSecureCoding implementation of that class is correct.
  XCTAssertEqualObjects(requestCopy.configuration.authorizationEndpoint,
                        request.configuration.authorizationEndpoint, @"");
  XCTAssertEqualObjects(requestCopy.grantType, request.grantType, @"");
  XCTAssertEqualObjects(requestCopy.authorizationCode, request.authorizationCode, @"");
  XCTAssertEqualObjects(requestCopy.redirectURL, request.redirectURL, @"");
  XCTAssertEqualObjects(requestCopy.clientID, request.clientID, @"");
  XCTAssertEqualObjects(requestCopy.clientSecret, request.clientSecret, @"");
  XCTAssertEqualObjects(requestCopy.scope, authResponse.request.scope, @"");
  XCTAssertEqualObjects(requestCopy.refreshToken, kRefreshTokenTestValue, @"");
  XCTAssertEqualObjects(requestCopy.codeVerifier, authResponse.request.codeVerifier, @"");
  XCTAssertNotNil(requestCopy.additionalParameters, @"");
  XCTAssertEqualObjects(requestCopy.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue, @"");
}

- (void)testURLRequestNoClientAuth {
  OKTTokenRequest *request = [[self class] testInstanceCodeExchange];
  NSURLRequest *urlRequest = [request URLRequest];

  id authorization = [urlRequest.allHTTPHeaderFields objectForKey:@"Authorization"];
  XCTAssertNil(authorization);
}

- (void)testURLRequestBasicClientAuth {
  OKTTokenRequest *request = [[self class] testInstanceCodeExchangeClientAuth];
  NSURLRequest* urlRequest = [request URLRequest];

  id authorization = [urlRequest.allHTTPHeaderFields objectForKey:@"Authorization"];
  XCTAssertNotNil(authorization);
}

- (void)testAuthorizationCodeNullRedirectURL {
  OKTAuthorizationResponse *authResponse = [OKTAuthorizationResponseTests testInstance];
  NSArray<NSString *> *scopesArray =
      [OKTScopeUtilities scopesArrayWithString:authResponse.request.scope];
  NSDictionary *additionalParameters =
      @{ kTestAdditionalParameterKey : kTestAdditionalParameterValue };
  XCTAssertThrows([[OKTTokenRequest alloc] initWithConfiguration:authResponse.request.configuration
                                                       grantType:OKTGrantTypeAuthorizationCode
                                               authorizationCode:authResponse.authorizationCode
                                                     redirectURL:nil
                                                        clientID:authResponse.request.clientID
                                                    clientSecret:authResponse.request.clientSecret
                                                          scopes:scopesArray
                                                    refreshToken:kRefreshTokenTestValue
                                                    codeVerifier:authResponse.request.codeVerifier
                                                    deviceSecret:nil
                                                    subjectToken:nil
                                            additionalParameters:additionalParameters], @"");
}

@end

#pragma GCC diagnostic pop
