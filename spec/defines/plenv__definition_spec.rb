require 'spec_helper'

describe 'plenv::definition', :type => :define do
  let(:user)         { 'tester' }
  let(:perl_version) { '5.10.1' }
  let(:title)        { "plenv::definition::#{user}::#{perl_version}" }
  let(:dot_plenv)    { "/home/#{user}/.plenv" }
  let(:target_path)  { "#{dot_plenv}/plugins/perl-build/share/perl-build/#{perl_version}" }
  let(:params)       { {:user => user, :perl => perl_version, :source => definition} }

  context 'puppet' do
    let(:definition)   { 'puppet:///custom-definition' }
    it 'copies the file to the right path' do
      should contain_file("plenv::definition-file #{user} #{perl_version}").with(
        :path => target_path,
        :source  => definition
      )
    end
  end

  context 'http' do
    let(:definition) { 'http://gist.com/ree' }
    it 'downloads file to the right path' do
      should contain_exec("plenv::definition-file #{user} #{perl_version}").with(
        :command => "wget #{definition} -O #{target_path}",
        :creates => target_path
      )
    end
  end

  context 'https' do
    let(:definition) { 'https://gist.com/ree' }
    it 'downloads file to the right path' do
      should contain_exec("plenv::definition-file #{user} #{perl_version}").with(
        :command => "wget #{definition} -O #{target_path}",
        :creates => target_path
      )
    end
  end
end
