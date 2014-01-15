class plenv::dependencies {
  case $::osfamily {
    archlinux      : { require plenv::dependencies::archlinux }
    debian         : { require plenv::dependencies::ubuntu    }
    redhat, Linux  : { require plenv::dependencies::centos    }
    suse           : { require plenv::dependencies::suse      }
    default        : { notice("Could not load dependencies for ${::osfamily}") }
  }
}
