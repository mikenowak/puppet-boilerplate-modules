require 'spec_helper'

describe 'boilerplate', :type => 'class' do

  let(:title) { 'boilerplate' }
  let(:node) { 'puppetdev.casanowak.com' }

  debianish              = [ 'Debian', 'Ubuntu' ]
  debianish_package      = '[FIXME/TODO]'
  debianish_config_path  = '[FIXME/TODO]'
  debianish_config_mode  = '0644'
  debianish_config_owner = 'root'
  debianish_config_group = 'root'

  redhatish              = [ 'RedHat', 'CentOS', 'Fedora' ]
  redhatish_package      = '[FIXME/TODO]'
  redhatish_config_path  = '[FIXME/TODO]'
  redhatish_config_mode  = '0644'
  redhatish_config_owner = 'root'
  redhatish_config_group = 'root'

  unknown                = [ 'Foobar' ]


  describe 'Test installation' do

    debianish.each do |os|
      describe "for operating system #{os}" do
        let(:params) { {} }
        let(:facts) { {:operatingsystem => os } }

        ### Components

        # package
        it { should contain_package("#{debianish_package}").with_ensure('present') }

        # config
        it { should contain_file("#{debianish_config_path}").with_ensure('present') }
        it { should contain_file("#{debianish_config_path}").with_mode("#{debianish_config_mode}") }
        it { should contain_file("#{debianish_config_path}").with_owner("#{debianish_config_owner}") }
        it { should contain_file("#{debianish_config_path}").with_group("#{debianish_config_group}") }


        ### Parameters

        # version
        it 'should allow package version to be overridden with version => "1.2.3"' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{debianish_package}").with_ensure('1.2.3')
        end
        it 'should allow package version to be overridden with version => "latest"' do
          params[:version] = 'latest'
          subject.should contain_package("#{debianish_package}").with_ensure('latest')
        end

        # template
        it 'should allow template to be overridden' do
          params[:template] = 'boilerplate/spec.erb'
          content = catalogue.resource('file', "#{debianish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end
        
        # options
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

        ### Components

        # package
        it { should contain_package("#{redhatish_package}").with_ensure('present') }

        # config
        it { should contain_file("#{redhatish_config_path}").with_ensure('present') }
        it { should contain_file("#{redhatish_config_path}").with_mode("#{redhatish_config_mode}") }
        it { should contain_file("#{redhatish_config_path}").with_owner("#{rehatish_config_owner}") }
        it { should contain_file("#{redhatish_config_path}").with_group("#{redhatish_config_group}") }


        ## Parameters

        # version
        it 'should allow package version to be overridden with version => "1.2.3"' do
          params[:version] = '1.2.3'
          subject.should contain_package("#{redhatish_package}").with_ensure('1.2.3')
        end
        it 'should allow package version to be overridden with version => "latest"' do
          params[:version] = 'latest'
          subject.should contain_package("#{redhatish_package}").with_ensure('latest')
        end

        # template
        it 'should allow template to be overridden' do
          params[:template] = 'boilerplate/spec.erb'
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_a"
        end

        # options
        it 'should generate a template that uses a custom option' do
          params[:template] = 'boilerplate/spec.erb'
          params[:options]  = { 'opt_a' => 'value_z' }
          content = catalogue.resource('file', "#{redhatish_config_path}").send(:parameters)[:content]
          content.should match "value_z"
        end

        # additionsa - insert here
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

        ### Components
 
        # package
        it { should contain_package("#{debianish_package}").with_ensure('purged') }

        # config
        it { should contain_file("#{debianish_config_path}").with_ensure('absent') }
      end
    end

    redhatish.each do |os|

      describe "for operating system #{os}" do
        let(:params) { {:ensure => 'absent' } }
        let(:facts) { {:operatingsystem => os } }

        ### Components

        # package
        it { should contain_package("#{redhatish_package}").with_ensure('purged') }

        # config
        it { should contain_file("#{redhatish_config_path}").with_ensure('absent') }
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

      end
    end

  end

end
