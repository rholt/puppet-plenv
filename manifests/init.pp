class plenv (

 $plenvrc_template       = $::plenv::params::plenvrc_template,
 $cpanfile_template      = $::plenv::params::cpanfile_template,
 $plenv_git_url          = $::plenv::params::plenv_git_url,
 $bash_profile           = $::plenv::params::local_bash_profile,
 $default_paths          = $::plenv::params::default_paths,
 $default_exec_timeout   = $::plenv::params::default_exec_timeout,
 $default_root_path      = $::plenv::params::default_root_path,
 $default_home_path      = $::plenv::params::default_home_path,
 $default_cpan_modules   = $::plenv::params::default_cpan_modules,
 $default_cpanfile_content = $::plenv::params::default_cpanfile_content,
 $carton_lock_file       = $::plenv::params::carton_lock_file,
 $cpanfile_name          = $::plenv::params::cpanfile_name

) inherits plenv::params {
   require plenv::dependencies
}
