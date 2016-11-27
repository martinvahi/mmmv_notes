Kibuvits Ruby Library
===========================================================================

Estonian word "kibuvits" stands for "Rosa".

For example, "Metskibuvits", which has a direct translation
of "forest rosa", stands for "Rosa majalis"(
http://en.wikipedia.org/wiki/Rosa_majalis
http://elurikkus.ut.ee/kirjeldus.php?lang=eng&id=19366&rank=70&id_puu=18622&rank_puu=60 ).

An Estonian word "mets" stands for "forest".

---------------------------------------------------------------------------

##                         Table of Contents

1. Introduction
2. Dependencies
3. Library Layout
4. Usage
5. A few Forking Related Remarks
6. A few Comments on KRL Design and Ideology

---------------------------------------------------------------------------

##                       1. Introduction


Milestone releases of the Kibuvits Ruby Library (hereafter KRL) are
published at

http://technology.softf1.com/kibuvits_ruby_library/

Intermittent releases are part of the mmmv_devel_tools project at

https://github.com/martinvahi/mmmv_devel_tools/

Flawtrack/bugs:
http://www.softf1.com/cgi-bin/tree1/technology/flaws/kibuvits_ruby_library.bash/


The Kibuvits Ruby Library is a mixture of various Ruby routines
that I, Martin.Vahi@softf1.com, have found to be useful, handy, or
even necessary for coding in Ruby.  The KRL is licensed under
the BSD license: http://www.opensource.org/licenses/bsd-license.php

The API is not meant to stay stable. If feasible from
refactoring labor point of view, the Kibuvits Ruby Library
will be thoroughly refactored every time I find a solution
that I like more than the one I previously liked the most.
Forking the KRL is not just encouraged, but it is a necessity by design.



---------------------------------------------------------------------------

##                        2. Dependencies


The Kibuvits Ruby Library (KRL) is supported/tested only
on Linux and FreeBSD. Ruby version has to be 2.1.3p242 or newer.

Majority of the KRL can be run without installing any extra
gems or operating system packages, but some components of the KRL,
for example,

    ./src/include/wrappers/*

depend on the presence of some operating system packages
that might not be present without explicitly installing them.
The current list of those packages is:

    ImageMagick, rsync

The

    ./src/dev_tools/install_dependency_gems.bash

can be used for installing some dependencies.


---------------------------------------------------------------------------

##                       3. Library Layout

As backward compatibility is not maintained, KRL version
numbering does not have the meaning that version numbering
usually has. Series of KRL versions like 1, 2, 3, 4 should
be interpreted as hashes or ID-s, a bit like dog, cat, cow, horse.
It does hold that the bigger the numbers, the newer the library.

KRL code is partly in the role of KRL documentation. The only regions
that are part of the implementation but not part of the public API are
private methods and code in the

    ./src/include/incomplete
    ./src/include/bonnet

The

    ./src/dev_tools/deprecated_code_museum

is not part of the current implementation. It's a place, where
"museum artifacts" are held.

It is strongly encouraged to study a some lessons from
the ./doc/examples, before trying to use the KRL. For example,
certain method name prefixes indicate the
behavior and return types of the methods.
The naming conventions are described in

    ./doc/examples/lesson_01_naming_conventions.rb


The ./doc/examples/COMMENTS.txt has further details about
the example code and its prerequisites.

In case of some KRL Ruby files, some out-commented demo/test code
might reside at the end of the file. It's possible to play with it by cd-ing
into the folder, where the Ruby file resides, uncommenting
the demo/devel code and executing the file. An example:

    ruby kibuvits_ProgFTE.rb

Most of the code examples can be obtained from the KRL selftests.
The selftests system is explained in the

    ./src/dev_tools/selftests/COMMENTS.txt

All of the KRL class names start with a string "Kibuvits_".
All of the KRL specific constants start with a string "KIBUVITS".
All of the KRL library files and almost all of the KRL global
functions start with a string "kibuvits_".


---------------------------------------------------------------------------

##                         4. Usage

KRL versions are not guaranteed to be backwards compatible.
KRL has not been designed to allow more than one version of it
to be used in a single Ruby application. Every project that
depends on the KRL must include a copy of the KRL in its sources.

For automatic version checks the KRL defines a Ruby constant named

    KIBUVITS_s_NUMERICAL_VERSION

The version changes with every release and its value
can be edited/read from the

    ./src/include/kibuvits_boot.rb.

The KRL defines a Ruby constant named

    KIBUVITS_HOME

which holds a full path to the folder that contains the README.md
that You are currently reading. It is OK to define the KIBUVITS_HOME
in a KRL client project.

The whole KRL can be included by

    require KIBUVITS_HOME+"/src/include/kibuvits_all.rb"



---------------------------------------------------------------------------

##                 5. A few Forking Related Remarks


To create a difficultly maintainable and unstable hack that
contains multiple versions of the KRL in a single
application, one might want to rename the "Kibuvits" and
"kibuvits" and "KIBUVITS" to different, hack specific, strings.

For example, in one version of the KRL

    "Kibuvits" -> "Kibuvits_UFOversion"
    "kibuvits" -> "kibuvits_UFOversion"
    "KIBUVITS" -> "KIBUVITS_UFOversion"

and in the other:

    "Kibuvits" -> "Kibuvits_Rocketversion"
    "kibuvits" -> "kibuvits_Rocketversion"
    "KIBUVITS" -> "KIBUVITS_Rocketversion"


---------------------------------------------------------------------------

##               6. A few Comments on KRL Design and Ideology


The reason, why KRL is and probably will stay UNIX specific
is that rewriting Bash, diff, grep and other, reliable, classical,
UNIX command-line tools at an era, where most of the new commercial
software is web based and most of the web servers run UNIX-like operating
systems, is not that rewarding. Phones run Linux, routers
run Linux, most mature open source operating systems are POSIX compliant
and as of 2014 the Microsoft has never been a trustworthy
business partner for multitude-and-freedom-of-choice lovers.

The KRL will probably never be distributed as a gem, because
gems are global and that would make it hard to use different
KRL versions in different projects without using some
extra tool like the "bundler".

The design ideology partly rests on the following ideas:

1) Everything starts from the motivations of people that are involved.

2) To learn/advance, one needs to "train"/"exercise"/ at the
   edge of one's capabilities (without falling over the edge, i.e.
   without taking too heavy weights), but to work at the edge, one
   needs the freedom to be there. In the context of software
   development skills creative freedom to exercise at the
   edge of one's capabilities is paramount.

3) It's not always possible to clean code up without
   dropping historical components, without breaking
   backwards compatibility.

Forking provides a private space. As of 2014
I(martin.vahi@softf1.com) believe that in the case of
team efforts, the project must be divided to code regions,
where the code maintainer has the ultimate authority. This
does not mean that people are not allowed to cooperate voluntarily,
but it does mean that if one learns to drive a car,
one should have the option to be the only one behind the wheel.

Obviously the ideology that I just described here does not suite to
lazy and passive people, but this project does not target lazy,
passive, people, nor do I (martin.vahi@softf1.com)
want to have anything to do with them.


---------------------------------------------------------------------------

##             7. Arbitrary list of Sources of Inspiration


The Seed7 programming language, http://seed7.sourceforge.net/
is very interesting, but as of 2014_11the authors of the Seed7
find that regular expressions are against their design philosophy

    http://seed7.sourceforge.net/faq.htm#regular_expressions

and that's why in my(martin.vahi@softf1.com) view the Seed7
is never able to compete with Ruby.


---------------------------------------------------------------------------
