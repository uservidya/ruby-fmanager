require 'test/unit'

require 'fmanager'


class TestVersion < Test::Unit::TestCase

    def test_version
        assert( defined?(FManager::VERSION), "FManager::VERSION not defined." )
        assert( FManager::VERSION.is_a?(String), "FManager::VERSION not a string." )
    end

end
