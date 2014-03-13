require 'spec_helper'

describe 'plenv::installcpanm', :type => :define do
  let :pre_condition do
      'class { "plenv" : }'
  end
  let(:user)         { 'tester' }
  let(:perl_version) { '5.10.1' }
  let(:title)        { "plenv::installcpanm #{user} #{perl_version}" }
  let(:carton)       { 'present' }
  let(:params)       { {:user => user, :perl => perl_version, :carton => carton } }

  describe 'when the perl version has not been installed' do
     let(:perl_version) { '0.0.0' }
     it 'fails' do
       expect {
         should contain_class('foo')
       }.to raise_error(Puppet::Error, /Plenv-Perl #{perl_version} for user #{user} not found in catalog/)
     end
  end

  #it "installs cpanm into perl of the chosen version" do
  #  should contain_exec("plenv::installcpanm #{user} #{perl_version}").
  #    with_command("env PLENV_VERSION=\"#{perl_version}\" plenv install-cpanm")
  #end

  #it "installs carton" do
  #  should contain_plenv__cpanm("plenv::carton #{user} #{perl_version}").
  #    with_ensure(carton)
  #end
end
