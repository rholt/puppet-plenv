Puppet::Type.newtype(:plenvmodule) do
  desc 'A Perl Module installed inside an plenv-installed Perl'

  ensurable do
    newvalue(:present) { provider.install   }
    newvalue(:absent ) { provider.uninstall }

    newvalue(:latest) {
      provider.uninstall if provider.current
      provider.install
    }

    newvalue(/./)  do
      provider.uninstall if provider.current
      provider.install
    end

    aliasvalue :installed, :present

    defaultto :present

    def retrieve
      provider.current || :absent
    end

    def insync?(current)
      requested = @should.first

      case requested
      when :present, :installed
        current != :absent
      when :latest
        current == provider.latest
      when :absent
        current == :absent
      else
        current == [requested]
      end
    end
  end

  newparam(:name) do
    desc 'Module qualified name within an plenv repository'
  end

  newparam(:modulename) do
    desc 'The Module name'
  end

  newparam(:perl) do
    desc 'The perl interpreter version'
  end

  newparam(:plenv) do
    desc 'The plenv root'
  end

  newparam(:user) do
    desc 'The plenv owner'
  end

  newparam(:source) do
    desc 'The module source'
  end

end
