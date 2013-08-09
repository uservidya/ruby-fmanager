require 'digest/md5'
require 'yaml'


class FileMeta
    attr_reader :fsize
    attr_reader :digest
    attr_reader :path

    def initialize(fsize, path, digest)
        @fsize = fsize
        @digest = digest
        @path = path
    end
end


DBFILE = "fmetadata.db"


if ARGV.size != 1
    $stderr << "usage: findex <PATH>\n"
    exit 0
end


puts "Loading DB #{DBFILE} ..."
h = {}
needupdate = true
if File.exists?(DBFILE)
    obj = YAML::load(File.read(DBFILE))
    if obj.is_a?(Hash)
        h = obj
        needupdate = false
    end
end
puts "Loaded DB."

indexpath = ARGV[0]
puts "Indexing #{indexpath} ..."

for fpath in Dir.glob("#{indexpath}/**/*").select { |e| File.directory?(e) == false && File.exists?(e) }
    begin
        fpath = File.realpath(fpath).force_encoding("binary")
        fsize = File.size(fpath)

        # Lazy index the file.
        if h[fsize].nil?
            h[fsize] = fpath
            needupdate = true
            puts "[NEW]: #{fpath} nil"
        else
            if h[fsize].is_a?(String)
                p = h[fsize]
                d = Digest::MD5.hexdigest(File.read(p))
                h[fsize] = { d => FileMeta.new(fsize, p, d) }
                needupdate = true
            end
            digest = Digest::MD5.hexdigest(File.read(fpath))
            if h[fsize][digest].nil?
                h[fsize][digest] = FileMeta.new(fsize, fpath, digest)
                needupdate = true
                puts "[NEW]: #{fpath} #{digest}"
            end
        end
    rescue StandardError => e
        puts "[FAIL]: file=\"#{fpath}\" #{e.message}"
    end
end
puts "Indexing completed."

if needupdate
    puts "Updating DB #{DBFILE} ..."
    File.write(DBFILE, YAML::dump(h))
    puts "Updated DB."
else
    puts "Skip updating DB."
end
