# puppet-plenv

## About

This project is based on the work done by Andreas Loupasakis and others
( see [puppet-rbenv](https://github.com/alup/puppet-rbenv) ). It provides manifests for the
installation and operation of the [plenv](https://github.com/tokuhirom/plenv) (perl Version Management)
 utility.

In a nutshell, it supports the following conveniences:

* Defined resources for the installation of perl envs for one or more users.
* Resources for the compilation of perl interpreters (one or many, predefined perl build definitions), under specific plenvs, users.
* Tools for the installation of arbitrary CPAN modules under specific plenvs.
* Infrastructure to support plenv plugins. [perl-build](https://github.com/tokuhirom/perl-build) is already included
* Resource for handling `Carton`.

## Plenv installation

You can use the module in your manifest with the following code:

```
plenv::install { 'someuser': }


plenv::compile { '5.18.2':
    user => 'someuser',
    global => true
}

plenv::carton { '5.18.2':
    home => '/home/someuser',
    user => 'someuser',
    modules => [ ['Moose','2.1201'],['Module::Starter::PBP','0.0.3'] ]
}

```

This will apply an plenv installation under "someuser" home dir
and place it into ".plenv". You can change the resource title to
your taste, and pass the user on which install plenv using the
`user` parameter.

It will compile perl version 5.18.2 into someusers plenv environment and set this as the global version.

It will create a cpanfile containing the listed modules and versions into the  directory specified by 'home'
and then use Carton to install those modules.

## Perl compilation

The resource title is used as the perl version, but if you have
multiple Perls under multiple users, you'll have to define them
explicitly:

```
plenv::compile { "someuser/5.18.2":
  user => "someuser",
  perl => "5.18.2",
}

plenv::compile { "otheruser/5.14.2":
  user => otheruser",
  perl => "5.14.2",
}
```

`plenv rehash` is performed each time a new perl or a new CPAN module is
installed.

You can use the `global => true` parameter to set an interpreter as the
default (`plenv global`) one for the given user. Please note that only one global
is allowed, duplicate resources will be defined if you specify
multiple global perl version.


## CPAN module installation

You can install and keep modules updated for a specific perl interpreter:

```
plenv::cpanm { "Acme::Bleach":
  user => "someuser",
  perl => "5.18.2",
}
```

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

Plese use github issues: [http://github.com/rholt/puppet-plenv/](http://github.com/rholt/puppet-plenv/).

# SEE ALSO

[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) provides same feature. But plenv provides project local file: __ .perl-version __.

Most of puppet-plenv was derived from [puppet-rbenv](https://github.com/alup/puppet-rbenv).

# LICENSE

## plenv itself

SEE [plenv on Github](https://github.com/tokuhirom/plenv) for licensing

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## puppet-plenv

    (The MIT license)

    Copyright 2012 Andreas Loupasakis, Marcello Barnaba <vjt@openssl.it>, Fabio Rehm$
    Modified work Copyright 2014 Rohan Holt

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


