require 'spec_helper'

describe 'plenv::install', :type => :define do
  let(:user)   { 'tester' }
  let(:title)  { "plenv::install::#{user}" }
  let(:params) { {:user => user} }

  context 'install plenv' do
    it "clones plenv from the official repository" do
      should contain_exec("plenv::checkout #{user}").
        with_command("git clone https://github.com/tokuhirom/plenv.git /home/#{user}/.plenv")
    end

    it "appends in a rc file, a command to include .plenv/bin folder in PATH env variable" do
      should contain_exec("plenv::shrc #{user}").
        with_command("echo 'source /home/#{user}/.plenvrc' >> /home/#{user}/.profile").
        with_path(['/bin','/usr/bin','/usr/sbin'])
    end

    it "creates a cache folder" do
      should contain_file("plenv::cache-dir #{user}").
        with(:ensure => "directory", :path => "/home/#{user}/.plenv/cache")
    end

    it "installs perl-build plugin from official repository" do
       should contain_plenv__plugin__perlbuild("plenv::perlbuild::#{user}")
    end
  end
end
