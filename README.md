                            _ _  __
                           | (_)/ _|
            _   _ _ __ ___ | |_| |_ _   _
           | | | | '_ ` _ \| | |  _| | | |
           | |_| | | | | | | | | | | |_| |
            \__,_|_| |_| |_|_|_|_|  \__, |
                                     __/ |
                                    |___/

            umlify is a tool that creates
          uml class diagrams from your code

         <https://github.com/mikaa123/umlify>

Introduction
------------

umlify takes your ruby project's source code and creates an uml class diagram out of it.

Installation
------------

    gem install umlify

How to use
----------

1. Go to your gem project directory
2. type: `umlify lib/*/*`
3. Open uml.html

If you want umlify to try to guess the types of the associations, use
`umlify -s lib/*/*` at step 2.

Example
-------

Here is umlify umlified:

![umlify's uml](http://img43.imageshack.us/img43/2756/umlify.png)

Features
--------

* Tries to guess the types of the instance variables (smart mode)
* __new__ Use RubyParser instead of regular expression as of v1.0.0
* __new__ supports inhertiance (v0.4.2)
* supports associations (see "How to add associations to a diagram)
* supports methods and instance variables

How it works
------------

umlify parses your source codes using regular expressions to build an uml
diagram using [yUML](http://yuml.me/)'s api.

Note: Regexps parsing is really dirty. This point needs serious
improvement

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
classes. However, if you want an association to be shown on your diagram simply annotate your classes such as:

    # type of @weapon: Rainbow
    class Unicorn

      def initialize weapon
        @weapon = weapon
      end
    end

Smart mode
----------

If you use umlify with the `-s` or `--smart` option, it'll try to guess
the types of the associations based on the name of the instance
variables.

If you class variable is @duck, then it will try to create an
association with the "Duck" class, if it exists.

If your variable is @ducks, it will try to create an association with a
cardinality of '*' with a class called "Duck", if such a class exists.

Contribute
----------

If you are interested by this project (I hope you are!), you can send me your comments
(mikaa123 at gmail), test the application and create some issue when you find a bug.

If you want to contribute, you can check the TODO, it's a good place to start. :)
Just fork and send a pull request. I'd love to have some help.

Not having the expected results?
--------------------------------

If you have found a bug, or if the results you obtained don't correspond
to your code, you can raise an issue and link to your github project
page.

Real project testing is way more efficient than on test cases. :)

License
-------

Copyright (C) 2011 Michael Sokol

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

