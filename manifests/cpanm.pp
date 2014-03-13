# Install a cpanm module under plenv for a certain user's perl version.
# Requires plenv::compile for the passed in user and perl version
#
define plenv::cpanm(
  $user,
  $perl,
  $module = $title,
  $modversion = '',
  $home   = $::plenv::default_home_path,
  $root   = $::plenv::default_root_path,
  $source = '',
  $ensure = present
) {

  if !defined(Class['plenv']) {
    fail('You must include the plenv base class before using any plenv defined resource types')
  }

  if ! defined( Exec["plenv::compile ${user} ${perl}"] ) {
    fail("Plenv-Perl ${perl} for user ${user} not found in catalog")
  }

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  plenvcpanm {"${user}/${perl}/${module}":
    ensure  => $ensure,
    user    => $user,
    module  => $module,
    modversion => $modversion,
    perl    => $perl,
    plenv   => "${root_path}/versions/${perl}",
    source  => $source,
    require => Exec["plenv::installcpanm ${user} ${perl}"],
  }
}
