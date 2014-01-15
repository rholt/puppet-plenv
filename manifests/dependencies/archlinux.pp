class plenv::dependencies::archlinux {
  # base-devel is "build essentials" for Arch
  if ! defined(Package['base-devel']) { package { 'base-devel': ensure => installed } }

  # Other packages required to build a proper Perl
  if ! defined(Package['openssl'])  { package { 'openssl'  : ensure => installed } }
  if ! defined(Package['readline']) { package { 'readline' : ensure => installed } }
  if ! defined(Package['zlib'])     { package { 'zlib'     : ensure => installed } }
  if ! defined(Package['openssl'])  { package { 'openssl'  : ensure => installed } }
  if ! defined(Package['libyaml'])  { package { 'libyaml'  : ensure => installed } }
  if ! defined(Package['libxml2'])  { package { 'libxml2'  : ensure => installed } }
  if ! defined(Package['libxslt'])  { package { 'libxslt'  : ensure => installed } }

  # Git and curl are needed for plenv and perl-build
  if ! defined(Package['git'])  { package { 'git'  : ensure => installed } }
  if ! defined(Package['curl']) { package { 'curl' : ensure => installed } }
}
