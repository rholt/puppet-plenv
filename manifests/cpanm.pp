# Install a cpanm module under plenv for a certain user's perl version.
# Requires plenv::compile for the passed in user and perl version
#
define plenv::cpanm(
  $user,
  $perl,
  $module = $title,
  $home   = '',
  $root   = '',
  $source = '',
  $ensure = present
) {

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  if ! defined( Exec["plenv::compile ${user} ${perl}"] ) {
    fail("Plenv-Perl ${perl} for user ${user} not found in catalog")
  }

  plenvcpanm {"${user}/${perl}/${module}/${ensure}":
    ensure  => $ensure,
    user    => $user,
    module  => $module,
    perl    => $perl,
    plenv   => "${root_path}/versions/${perl}",
    source  => $source,
    require => Exec["plenv::installcpanm ${user} ${perl}"],
  }
}
