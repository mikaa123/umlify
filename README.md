\                            _ _  __
\                           | (_)/ _|
\            _   _ _ __ ___ | |_| |_ _   _
\           | | | | '_ ` _ \| | |  _| | | |
\           | |_| | | | | | | | | | | |_| |
\            \__,_|_| |_| |_|_|_|_|  \__, |
\                                     __/ |
\                                    |___/
\
\            umlify is a tool that creates
\          uml class diagrams from your code
\
\         <https://github.com/mikaa123/umlify>


Introduction
------------

umlify takes your ruby project's source code and creates an uml class diagram out of it.

Installation
------------

    gem install umlify

How to use
----------

1. Go to your gem project directory

2. type:

    umlify 'lib/\*\*/\*'

3. Open uml.html

Example
-------

Here is umlify umlified:

![umlify's uml](http://img43.imageshack.us/img43/2756/umlify.png)

How it works
------------

umlify parses your source codes using regular expressions to build an uml
diagram using [yUML](http://yuml.me/)'s api.

On dynamic languages
--------------------

Ruby's extreme decoupling and duck-typing philosophy doesn't judge a class by its hierarchy.
Thus, variables don't have a predefined type, which conflicts with uml's static typed object-model.
The objective of this project isn't to bend uml's model to make it semantically comply with
duck typing (by the use of interfaces, or other tricks), but to add a basic visual representation
of the code of your project for documenting and helping maintainers.

How to add associations to a diagram
------------------------------------

Because of the above point, there's no direct way to automatically draw associations between your
classes. However, if you want an association to be shown on your diagram simply add an annotation
on top of an `attr_accessor`, such as:

    # type: Unicorn
    attr_accessor :animal

Contribute
----------

If you are interested by this project (I hope you are!), you can send me your comments
(mikaa123 at gmail), test the application and create some issue when you find a bug.

If you want to contribute, you can check the TODO, it's a good place to start. :)
Just fork and send a pull request. I'd love to have some help.

License
-------

Copyright (C) 2011 by Michael Sokol

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

