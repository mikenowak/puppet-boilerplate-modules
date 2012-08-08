require 'spec_helper'

describe 'boilerplate', :type => 'class' do

  let(:title) { 'boilerplate' }
  let(:node) { 'puppetdev.casanowak.com' }

  debianish              = [ 'Debian', 'Ubuntu' ]
  debianish_package      = '[TODO/FIXME]'
  debianish_config_path  = '[TODO/FIXME]'
  debianish_config_mode  = '0600'
  debianish_config_owner = 'root'
  debianish_config_group = 'root'

  debianish_service      = '[TODO/FIXME]'

  redhatish              = [ 'RedHat', 'CentOS', 'Fedora' ]
  redhatish_package      = '[TODO/FIXME]'
  redhatish_config_path  = '[TODO/FIXME]'
  redhatish_config_mode  = '0600'
  redhatish_config_owner = 'root'
  redhatish_config_group = 'root'

  redhatish_service      = '[TODO/FIXME]'

  unknown                = [ 'Foobar' ]


  describe 'Test installation' do

    debianish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        it { should contain_package("#{debianish_package}").with_ensure('present') }
        it { should contain_file("#{debianish_config_path}").with(
          'ensure' => 'present',
          'mode'   => "#{debianish_config_mode}",
          'owner'  => "#{debianish_config_owner}",
          'group'  => "#{debianish_config_group}",
        ) }
        it { should contain_service("#{debianish_service}").with_ensure('running') }
        it { should contain_service("#{debianish_service}").with_enable('true') }
        it 'should allow version to be overridden to a specific version number' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{debianish_package}").with_ensure('1.2.3')
        end
        it 'should allow version to be overridden with to latest' do
          params[:version] = 'latest'
          subject.should contain_package("#{debianish_package}").with_ensure('latest')
        end
        it 'should allow status to be overridden with value disabled' do
          params[:status] = 'disabled'
          subject.should contain_service("#{debianish_service}").with_ensure('stopped')
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end
        it 'should allow status to be overridden with value running' do
          params[:status] = 'running'
          subject.should contain_service("#{debianish_service}").with_ensure('running')
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end
        it 'should allow status to be overridden with value unmanaged' do
          params[:status] = 'unmanaged'
          subject.should contain_service("#{debianish_service}").without_ensure
          subject.should contain_service("#{debianish_service}").with_enable('false')
        end
        it 'should allow template to be overridden' do
          params[:template] = 'boilerplate/spec.erb'
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end
        it 'should generate a template that uses a custom option' do
          params[:template] = 'boilerplate/spec.erb'
          params[:options]  = { 'opt_a' => 'value_z' }
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "value_z"
        end
      end
    end

    redhatish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        it { should contain_package("#{redhatish_package}").with_ensure('present') }
        it { should contain_file("#{redhatish_config_path}").with(
          'ensure' => 'present',
          'mode'   => "#{redhatish_config_mode}",
          'owner'  => "#{redhatish_config_owner}",
          'group'  => "#{redhatish_config_group}",
        ) }
        it { should contain_service("#{redhatish_service}").with_ensure('running') }
        it { should contain_service("#{redhatish_service}").with_enable('true') }
        it 'should allow version to be overridden to a specific version number' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{redhatish_package}").with_ensure('1.2.3')
        end
        it 'should allow version to be overridden with to latest' do
          params[:version] = 'latest'
          subject.should contain_package("#{redhatish_package}").with_ensure('latest')
        end
        it 'should allow status to be overridden with value disabled' do
          params[:status] = 'disabled'
          subject.should contain_service("#{redhatish_service}").with_ensure('stopped')
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end
        it 'should allow status to be overridden with value running' do
          params[:status] = 'running'
          subject.should contain_service("#{redhatish_service}").with_ensure('running')
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end
        it 'should allow status to be overridden with value unmanaged' do
          params[:status] = 'unmanaged'
          subject.should contain_service("#{redhatish_service}").without_ensure
          subject.should contain_service("#{redhatish_service}").with_enable('false')
        end
        it 'should allow template to be overridden' do
          params[:template] = 'boilerplate/spec.erb'
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end
        it 'should generate a template that uses a custom option' do
          params[:template] = 'boilerplate/spec.erb'
          params[:options]  = { 'opt_a' => 'value_z' }
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_z"
        end
      end
    end

    unknown.each do |os|
      describe "for an unknown operating system" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        it { expect { should contain_package('boilerplate').with_ensure('present') }.to raise_error(Puppet::Error, /"#{title}" provides no package default value for "#{os}"/) }
      end
    end

  end

describe 'Test uninstallation' do

    debianish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {:ensure => 'absent' } }
        let(:facts) { {:operatingsystem => os } }

        it { should contain_package("#{debianish_package}").with_ensure('purged') }
        it { should contain_file("#{debianish_config_path}").with_ensure('absent') }
        it { should contain_service("#{debianish_service}").with_ensure('stopped') }
        it { should contain_service("#{debianish_service}").with_enable('false') }
      end
    end

    redhatish.each do |os|

      describe "for operating system #{os}" do
        let(:params) { {:ensure => 'absent' } }
        let(:facts) { {:operatingsystem => os } }

        it { should contain_package("#{redhatish_package}").with_ensure('purged') }
        it { should contain_file("#{redhatish_config_path}").with_ensure('absent') }
        it { should contain_service("#{redhatish_service}").with_ensure('stopped') }
        it { should contain_service("#{redhatish_service}").with_enable('false') }
      end
    end

    unknown.each do |os|
      describe "for an unknown operating system" do
        let(:params) {{}}
        let(:facts) { {:operatingsystem => os } }

        it { expect { should contain_package('boilerplate').with_ensure('present') }.to raise_error(Puppet::Error, /"#{title}" provides no package default value for "#{os}"/) }
      end
    end

  end

  describe 'Test for invalid parameters' do

    (debianish + redhatish).each do |os|
      describe "for operating system #{os}" do
        let(:facts) { {:operatingsystem => os } }
        let(:params) { { } }

        it 'invalid ensure value should generate error' do
          params[:ensure] = 'foo'
          expect { subject.should contain_package('boilerplate').with_ensure('present') }.to raise_error(Puppet::Error, /"#{params[:ensure]}" is not a valid ensure parameter value/)
        end

        it 'invalid status value should generate error' do
          params[:status] = 'bar'
          expect { subject.should contain_service('boilerplate').with_ensure('running') }.to raise_error(Puppet::Error, /"#{params[:status]}" is not a valid status parameter value/)
        end
        
      end
    end

  end

end
