require 'test/unit'

require 'fmanager'


class TestFMatchHasFolder < Test::Unit::TestCase

    include FManager


    def test_absolute_path
        path = "/abc/defg/hij"

        # Full folder name.
        assert( has_folder?("abc", path) )
        assert( has_folder?("defg", path) )
        assert( has_folder?("hij", path) )

        # Partial folder name.
        assert( has_folder?("efg", path) == false )
        assert( has_folder?("ac", path) == false )

        # Non-existing name.
        assert( has_folder?("jih", path) == false )
        assert( has_folder?("xyz", path) == false )
    end

    def test_relative_path_trailing_slash
        path = "abc0123/defg/hij456/"

        # Full folder name.
        assert( has_folder?("abc0123", path) )
        assert( has_folder?("defg", path) )
        assert( has_folder?("hij456", path) )

        # Partial folder name.
        assert( has_folder?("abc012", path) == false )
        assert( has_folder?("efg", path) == false )
        assert( has_folder?("456", path) == false )

        # Non-existing name.
        assert( has_folder?("xyz", path) == false )
        assert( has_folder?("aabbc", path) == false )
    end

end
