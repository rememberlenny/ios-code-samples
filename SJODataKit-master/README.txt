# SJODataKit

Some simple and lightweight additions to the Core Data stack to help reduce the boilerplate code in your app.

##Overview

###SJODataStore

This class manages the Core Data setup and initialisation for an application. The model is automatically loaed from the bundle, and lightweight migration is enabled. 
Best practice would be to create an `SJODataStore` as a property on your appDelegate, then pass this to the view controllers as needed.


###NSManagedObject(SJODataKitAdditions)

Additions to `NSManagedObject` to reduce boilerplate and simplify common operations.
These methods never should __never__ be called directly on NSManagedObject (e.g. `[NSManagedObject entityName]`), but instead only on subclasses.

###SJOSearchableFetchedResultsController
This class provides a simpler way to replicate the often-used pattern of a searchable Core Data-backed table view. Must be used as a subclass.

Usage
=======
Add the following to your `Podfile`:

    pod 'SJODataKit', :git => 'https://github.com/blork/SJODataKit.git'

Import `SJODataKit.h` in your project.

See the included example project for more details.

License
=======
This project made available under the MIT License.

Copyright (C) 2013 Sam Oakley

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
