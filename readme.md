# SGC File Manager

[![Build Status](https://travis-ci.org/xman/ruby-fmanager.png?branch=master)](https://travis-ci.org/xman/ruby-fmanager)
[![Code Climate](https://codeclimate.com/github/xman/ruby-fmanager.png)](https://codeclimate.com/github/xman/ruby-fmanager)

A gem to manage files scattered over multiple storage resources.

We have desktops, laptops, pads, phones, SD cards, thumbdrives, etc. but we
don't have an easy way to manage the photos, videos, and data files.
* Important files could be lost without backups.
* Duplicated files could be scattered everywhere, taking up storage space.
* Important files might be accidentally deleted.

Backup and recovery:
* Lost of important files without backups?
* Backup storage fails during recovery?
* Redundant backups in case we didn't backup?

Trash and recovery:
* Accidentally deleted important files?
* Deleted yet to backup files?

Duplicates:
* Backup the same data over and over again?
* Wonder if you have copied the photos in SD cards?
* Duplicated backups taking up too much space?


What if fmanager
* helps ensure k copies of backups over multiple storage resources,
* maintains recycle bins for file deletions, readily for recovery,
* helps identifying duplicated and large backup files for removal,

THAT'LL BE GREAT!!!

Your support is important to the success of the project.

Any feedback is highly appreciated.

Let us know if these would be useful.

Let us know your difficulty of managing data files.


### How to install

Install the latest gem:
```
$ gem install fmanager
```

Build and install custom gem:
```
$ gem build fmanager.gemspec
$ gem install fmanager-XX.YY.ZZ.gem
```


### Getting started

Index main storage, then secondary storage to find duplicates:
```
$ fm index myfolder
...
# fmetadata.db is created by default.

$ fm index anotherfolder
...
# New, or duplicated files are reported.
```

Get help info:
```
# Show 'fm' commands available.
$ fm

# Show help information of the 'index' command.
$ fm index -h
```


Run tests:
```
$ cd fmanager
$ rake test
```


### How to contribute

1. Create an account in github http://github.com
2. Fork this project [ruby-fmanager](http://github.com/xman/ruby-fmanager)
3. Make changes and submit commits to your repository.
4. Send a pull request.


### How to file a bug report

Submit new issues at https://github.com/xman/ruby-fmanager/issues

Please provide information on the ruby-fmanager version or the commit hash,
OS platform, Ruby version, how to reproduce the issue, the error messages.


### License

SGC File Manager is released under the GNU GPLv3. See the file [COPYING](https://github.com/xman/ruby-fmanager/blob/master/COPYING).


### The Author

ShinYee (shinyee speedgocomputing com)
