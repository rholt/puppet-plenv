# Puppet-Plenv

## About

This project provides manifests for the installation of
[plenv](https://github.com/tokuhirom/plenv) (perl Version Management).
In a nutshell, it supports the following conveniences:

* Defined resources for the installation of perl envs for one or more users.
* Resources for the compilation of perl interpreters (one or many, predefined perl build definitions), under specific plenvs, users.
* Tools for the installation of arbitrary CPAN modules under specific plenvs.
* Infrastructure to support plenv plugins. [perl-build](https://github.com/tokuhirom/perl-build) is already included
* Resource for handling `Carton`.

## Plenv installation

You can use the module in your manifest with the following code:

```
plenv::install { "someuser":
  group => 'project',
  home  => '/project'
}
```

This will apply an plenv installation under "someuser" home dir
and place it into ".plenv". You can change the resource title to
your taste, and pass the user on which install plenv using the
`user` parameter.

The plenv directory can be changed by passing the "root" parameter,
that must be an absolute path.

## Perl compilation

To compile a perl interpreter, you use `plenv::compile` as follows:

```
plenv::compile { "1.9.3-p327":
  user => "someuser",
  home => "/project",
}
```

The resource title is used as the perl version, but if you have
multiple Perls under multiple users, you'll have to define them
explicitly:

```
plenv::compile { "foo/1.8.7":
  user => "foo",
  perl => "1.8.7-p370",
}

plenv::compile { "bar/1.8.7":
  user => bar",
  perl => "1.8.7-p370",
}
```

`plenv rehash` is performed each time a new perl or a new CPAN module is
installed.

You can use the `global => true` parameter to set an interpreter as the
default (`plenv global`) one for the given user. Please note that only one global
is allowed, duplicate resources will be defined if you specify
multiple global perl version.

If you're using debugger CPAN modules, you'll probably need to keep source tree after building.
This is achieved by passing `keep => true` parameter.

```
plenv::compile { "bar/1.8.7":
  user => bar",
  perl => "1.8.7-p370",
  keep => true,
}
```

## CPAN module installation

You can install and keep modules updated for a specific perl interpreter:

```
plenv::cpanm { "Acme::Bleach":
  user => "foobarbaz",
  perl => "1.9.3-p327",
}
```

CPAN Modules are handled using a custom Package provider that handles cpanm,

## plenv plugins

To add a plugin to a plenv installation, you use `plenv::plugin` as follows:

```
plenv::plugin { "my-plugin":
  user   => "someuser",
  source => "git://github.com/user/my-plugin.git"
}
```

*NOTICE: `plenv::install` automatically requires [perl-build](https://github.com/tokuhirom/perl-build)
to compile perls, if you want to use a different repository, you can specify
the resource on a separate manifest:*

```
plenv::plugin::perlbuild { "someuser":
  source => "git://path-to-your/git/repo"
}
```

## Install module from puppet forge

You can install the latest release of this module by using the following
command:

```
puppet module install rholt-plenv
```

## Usage with Vagrant

A simple way to test this module is by using the
[Vagrant](http://http://vagrantup.com/) library.

An example of a Vagrantfile:

```
Vagrant::Config.run do |config|
   config.vm.box = "lucid32"
   config.vm.provision :puppet, :facter => { "osfamily" => "debian" }, :module_path => "modules" do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file  = "base.pp"
     puppet.options        = %w[ --libdir=\\$modulepath/plenv/lib ]
   end
end
```

The `--libdir=\\$modulepath/plenv/lib` argument is important to make
puppet aware of the plenvcpanm custom provider and type.


## Notes

This project contains a custom `plenvcpanm` type for use by the client via module.

Custom types and facts (plugins) are gathered together and distributed via a file mount on
your Puppet master.

To enable module distribution you need to make changes on both the Puppet master and the clients.
Specifically, `pluginsync` must be enabled in puppet.conf configuration file on both the master and the clients.

```
[main]
pluginsync = true
```

## Supported Platforms

* CentOS
* Debian
* RHEL
* SuSE
* Ubuntu

# BUG REPORTING

Plese use github issues: [http://github.com/rholt/puppet-plenv/](http://github.com/rholt/puppt-plenv/).

# AUTHOR

Rohan Holt <rohan.holt @ GMAIL COM>

# SEE ALSO

[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) provides same feature. But plenv provides project local file: __ .perl-version __.

Most of part was inspired from [puppet-rbenv](https://github.com/alup/puppet-rbenv).

# LICENSE

## plenv itself

Copyright (C) Rohan Holt

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## puppet-rbenv

puppet-plenv uses puppet-rbenv code

    (The MIT license)

    Copyright 2012 Andreas Loupasakis, Marcello Barnaba <vjt@openssl.it>, Fabio Rehm$

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
## License

