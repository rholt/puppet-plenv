require 'spec_helper'

describe 'plenv::carton', :type => :define do
  let :pre_condition do
     'class { "plenv" : }'
  end
  let(:user)   { 'tester' }
  let(:title)  { "5.18.2" }
  let(:home)   { "/home/#{user}" }
  let(:perl)   { "#{title}" }
  let(:params) { {:user => user, :modules => [ 'Mojolicious' ], :perl => perl, :home => home } }

  before :each do
    Puppet[:trace] = true
  end

  context 'run plenv::carton' do

    it "creates a cpanfile based on the list of modules" do
      should contain_file("#{home}/cpanfile").
        with_content("requires 'Mojolicious';\n")
    end

    it "executes carton install from the location of the cpanfile as ${user} user " do
      should contain_exec("plenv::carton #{user} #{perl}").
        with_command("env HOME=#{home} PLENV_VERSION=#{perl} carton install").
        with_cwd("#{home}").
        with_path("#{home}/bin:#{home}/.plenv/shims:/bin:/usr/bin")
    end

  end
end

