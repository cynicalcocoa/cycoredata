# CYCoreData

CYCoreData makes use of `NSManagedObjectContext`s parent child relationships to hide the process of writing data to disk from the main runloop. With minimal rules, anyone can write a multithreaded coredata application that keeps screen interaction as snappy as possible, while avoiding race conditions that make parent/child contexts so unruly.

Included are `NSManagedObject` category methods for reading and writing data. And also help to minimize repetitive predicate/sortDescriptor code.

The example project demonstrates the best practices for using CYCoreData.



## Installation

CYCoreData is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CYCoreData", '~> 0.1.0'

## Documentation
For more see [http://cynicalcocoa.github.io/CYCoreData/](http://cynicalcocoa.github.io/CYCoreData/)


## Architecture

#### Configure file names
In the appDelegate, `didFinishLaunchingWithOptions:` method, configure the database file name (the sqlite file coredata saves to the `NSCachesDirectory`), and model file name (the `**.xcdatamodeld` file name).

```
[CYCoreData configureDataBaseFileName:@"example_database" andModelFileName:@"ExampleModel"];

// or if your model file is in another bundle other than [NSBundle mainBundle];
// [CYCoreData configureDataBaseFileName:@"example_database" andModelFileName:@"ExampleModel" inBundleName:@"AssetsBundle"];
```
_Optional: If the unique identifier for the model objects in not an int, and/or does not stick to the uid convention, configure immediately after._

```
[CYCoreData configureModelUniqueIdentifier:@"uid" ofDataType:UniqueObjectValueTypeString withJSONSearchString:@"id"];
```

### Save / Reset

**Synchronously** means the context that writes the changes to disk will be a blocking process

```
[[CYCoreData tempContext] saveSynchronously];
```

**Asynchronously** means the context that writes the changes to disk will be a nonblocking process and return immediately

```
[[CYCoreData tempContext] saveAsynchronously];
```

**Reset** will clear the entire database

```
[CYCoreData reset]
```


### Write example
When writing to the database, create a new temporary context.<br/> 

```
NSManagedObjectContext *tempContext = [CYCoreData temporaryWriteContext];
```
Create or update your data next. 

```
NSDictionary *properties = @{ @"id": 24, @"first_name" :@"Scott", @"last_name" : @"Storch" }
User *user = [User updateOrCreateObjectInContext:tempContext withDictionary:properties];

// NOTE: updateOrCreateObjectInContext by default searches the dictionary passedin for
// the key @"id" and fetches the NSManagedObject(User) by propertyKey @"uid". To change this use
// [configureModelUniqueIdentifier:ofDataType:withJSONSearchString:] mentioned above.
```

Then immediately call the temporary context save method.<br/>

```
[tempContext saveAsynchronously];
```


### Read example
After ```[tempContext saveAsynchronously];``` is called, feel free to read your data from the read context. Use the read ```NSManagedObject+CYCoreData``` category methods for efficiency.

```
NSManagedObjectContext *readContext = [CYCoreData readContext];
NSArray *users = [User fetchAllInContext:readContext];
```
As long as this is done after the tempContext is saved, there will not be a race condition. The changes from the tempContext have been pushed to the read context and are ready to be query by the main runloop.


 






## Acknowledgement
Much inspiration and knowledge that made CYCoreData possible came from these sources.

[http://www.cocoanetics.com/2012/07/multi-context-coredata/](http://www.cocoanetics.com/2012/07/multi-context-coredata/)

[Core-Data-Management-Pragmatic-Programmers](http://www.amazon.com/Core-Data-Management-Pragmatic-Programmers/dp/1937785084)

[JCDCoreData](https://github.com/jdriscoll/JCDCoreData)



## Author

hatebyte, hatebyte@gmail.com

## License

CYCoreData is available under the MIT license. See the LICENSE file for more info.

If we meet some day, and you like it, you can buy me a beer. 

Or send bitcoin!

![Alt text](./Assets/githubaddress.png?raw=true "send bitcoin address")