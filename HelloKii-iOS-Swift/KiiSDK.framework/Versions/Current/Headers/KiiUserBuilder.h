//
//  KiiUserBuilder.h
//  KiiSDK-Private
//
//  Created on 2016/02/02.
//  Copyright (c) 2016 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KiiUser;

/** <KiiUser> builder class. */
@interface KiiUserBuilder : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 * Create a KiiUser builder. This constructor is received
 * identifier. The identifier is one of user name, email address or
 * phone number. This constructor automatically identity What is
 * identifier and build proper KiiUser object on build method.
 *
 * Some strings can be accepted as both user name and phone number. If
 * such string is passed to this constructor as identifier, then phone
 * number is prior to user name. String of email address is in
 * different class against user name and phone number. So Email
 * address is always identified correctly.
 *
 * @param identifier The user's user name, email address or phone
 * number.
 * @param password for the user.
 * @returns KiiUser object builder. nil if identifier is none of email
 * address, phone number and user name.
 */
+ (nullable instancetype)builderWithIdentifier:(NSString *)identifier
                                      password:(NSString *)password;

/**
 * Create a KiiUser builder with an email address.
 *
 * @param emailAddress email address for the user.
 * @param password for the user.
 * @returns KiiUser object builder.
 */
+ (instancetype)builderWithEmail:(NSString *)emailAddress
                        password:(NSString *)password;

/**
 * Create a KiiUser builder with an global phone number.
 *
 * @param phoneNumber global phone number for the user.
 * @param password for the user.
 * @returns KiiUser object builder.
 */
+ (instancetype)
        builderWithGlobalPhoneNumber:(NSString *)phoneNumber
                            password:(NSString *)password;

/**
 * Create a KiiUser builder with an local phone number and country code.
 *
 * @param phoneNumber local phone number for the user.
 * @param country country code for the local phone number.
 * @param password for the user.
 * @returns KiiUser object builder.
 */
+ (instancetype)
        builderWithLocalPhoneNumber:(NSString *)phoneNumber
                            country:(NSString *)country
                           password:(NSString *)password;

/**
 * Create a KiiUser builder with an user name.
 *
 * @param username user name.
 * @param password for the user.
 * @returns KiiUser object builder.
 */
+ (instancetype)builderWithUsername:(NSString *)username
                           password:(NSString *)password;

/**
 * Set email address.
 *
 * @param emailAddress email address.
 * @returns this builder object.
 */
- (instancetype)setEmail:(nullable NSString *)emailAddress;

/**
 * Set global phone number.
 *
 * If local phone number and its country code is alreday set to this
 * builder instance, this method makes country code null.
 *
 * @param phoneNumber phone number.
 * @returns this builder object.
 */
- (instancetype)setGlobalPhoneNumber:(nullable NSString *)phoneNumber;

/**
 * Set local phone number and its country code.
 *
 * If global phone number is alreday set to this builder instance,
 * this method remove the global phone number.
 *
 * @param phoneNumber local phone number
 * @param country country code.
 * @returns this builder object.
 *
 */
- (instancetype)setLocalPhoneNumber:(nullable NSString *)phoneNumber
                            country:(nullable NSString *)country;

/**
 * Set user name.
 *
 * @param username user name.
 * @returns this builder object.
 */
- (instancetype)setUsername:(nullable NSString *)username;

/**
 * Build KiiUser object.
 *
 * Build KiiUser object. This method verify set values.
 * @returns a working KiiUser object.
 */
- (KiiUser *)build;
NS_ASSUME_NONNULL_END
@end
