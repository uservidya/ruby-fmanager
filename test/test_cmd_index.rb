require 'tempfile'
require 'test/unit'
require 'yaml'

require 'fmanager'


RB = "ruby -Ilib"
FM = "bin/fm"
DATA = "test/data"
NEWDATA = "test/newdata"


class TestCmdIndex < Test::Unit::TestCase

    include FManager


    def setup
        @stdout = Tempfile.new("test.out")
        @stderr = Tempfile.new("test.err")
        @stdout.close
        @stderr.close
    end

    def teardown
        @stdout.unlink
        @stderr.unlink
    end


    def test_no_arguments
        assert( execute_fm_index() )
        assert_match(/usage: fm index/, File.read(@stderr.path))
    end


    def test_help_option
        assert( execute_fm_index("-h") )
        assert_match(/Show this message./, File.read(@stdout.path))
    end


    def test_default_db
        fname = "fmetadata.db"
        assert( File.exists?(fname) == false, "File #{fname} already exists. Test is unable to continue." )
        assert( execute_fm_index("#{DATA}") )
        assert_test_db_content(fname)
        File.unlink(fname)
    end


    def test_db_file_option
        dbfile = Tempfile.new("test.db")
        dbfile.close
        fname = dbfile.path
        assert( execute_fm_index("-d #{fname} #{DATA}") )
        assert_test_db_content(fname)
        dbfile.unlink
    end


    def test_no_update_db_option
        data = "hello world"
        dbfile = Tempfile.new("test.db")
        dbfile.write(data)
        dbfile.close
        fname = dbfile.path
        assert( execute_fm_index("-n -d #{fname} #{DATA}") )
        assert_match( /Indexing completed/, File.read(@stdout.path) )
        fdata = File.read(fname)
        assert_equal(data, fdata)
        dbfile.unlink
    end


    def test_update_db_option
        dbfile = Tempfile.new("test.db")
        dbfile.close
        fname = dbfile.path
        assert( execute_fm_index("-u -d #{fname} #{DATA}") )
        assert_test_db_content(fname)
        dbfile.unlink
    end


    def test_existing_db
        dbfile = Tempfile.new("test.db")
        dbfile.close
        fname = dbfile.path
        assert( execute_fm_index("-d #{fname} #{DATA}") )
        assert( execute_fm_index("-d #{fname} #{NEWDATA}") )
        h = YAML::load( File.read(fname) )

        # file0.txt
        fsize = 13
        digest = "8b362a13f2467448f69c826a7450cf3b"
        assert(f0 = h[fsize][digest])
        assert_equal(fsize, f0.fsize)
        assert_equal(digest, f0.digest)
        assert_match(/newdata\/file0.txt/, f0.path)
        dbfile.unlink

        assert_equal(4, h.size)
    end


    def execute_fm_index(argv = "")
        system("#{RB} #{FM} index #{argv} > #{@stdout.path} 2> #{@stderr.path}")
    end

    def assert_test_db_content(path)
        assert( File.exists?(path) )
        h = YAML::load( File.read(path) )

        # data0.txt and data2.txt
        fsize = 53
        digest = "be4af635154944fdf305dcb91a9613ba"
        assert(f0 = h[fsize][digest])
        assert_equal(fsize, f0.fsize)
        assert_equal(digest, f0.digest)
        assert_match(/data\/data0.txt|data\/data2.txt/, f0.path)

        # data1.txt
        fsize = 13
        digest = "2632561a9eb94e0d05e3e032cc5adeed"
        assert(f1 = h[fsize][digest])
        assert_equal(fsize, f1.fsize)
        assert_equal(digest, f1.digest)
        assert_match(/data\/data1.txt/, f1.path)

        #data3.txt
        fsize = 13
        digest = "412cb2c7b6a2cd60c55e3548066cbdeb"
        assert(f3 = h[fsize][digest])
        assert_equal(fsize, f3.fsize)
        assert_equal(digest, f3.digest)
        assert_match(/data\/data3.txt/, f3.path)

        # data4.txt
        fsize = 77
        assert_match(/data\/data4.txt/, h[fsize])

        assert_equal(3, h.size)
    end

end
