@interface NSDictionary (Keychain)

-(void) storeToKeychainWithKey:(NSString *)aKey;

+(NSDictionary *) dictionaryFromKeychainWithKey:(NSString *)aKey;

-(void) deleteFromKeychainWithKey:(NSString *)aKey;

@end