IQDatabaseManager
=============
IQDatabaseManager contains CoreData helper classes with convenience methods to communicate with CoreData for performing common tasks(inserting+updating+deleting+sorting+searching) on database records. Note that IQDatabaseManager is abstract class. You should not create it's object directly
## IQDatabaseManager Features:-

1) Convenience methods to Insert, Update, Delete records.

2) Convenience methods to do Searching and Sorting.


MyDatabaseManager
---
I created another subclass called MyDatabaseManager for demo purpose.


## Usage:-

Step1:- Just create your `Data Model` & create your `Entities` in your `Data Model`.

Step2:- Drag and drop `IQDatabaseMangerSubclass.h` & `IQDatabaseManger.h & .m` file in your project.

Step3:- Subclass `IQDatabaseManager` with your custom class name. Import `IQDatabaseManagerSubclass.h` in your .m file of your custom class(Don't import it in your .h file), this is the way of implementing protected methods in Objective-C.

Step4:- Override `+(NSURL*)modelURL` abstract method declared in `IQDatabaseManagerSubclass.h` in your subclass and return your DataModel URL.

Step5:- Just write your own wrapper in your subclass with your DataModel entities with the help of `IQDatabaseManagerSubclass.h` header file.

Step6:- To call your methods, use it's default singleton instance via `sharedManager`. For example use `[CustomDatabaseManager sharedManager] getAllData]` to call `getAllData` method.

You can also create multiple subclasses of `IQDatabaseManager` in one project. The `sharedManager` method will return singleton instance per subclass. For example if you have 4 subclasses the there will be 4 singleton instances, one for each subclass.

LICENSE
---
Distributed under the MIT License.


Contributions
---
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.


Author
---
If you wish to contact me, email at: hack.iftekhar@gmail.com
