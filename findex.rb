require 'digest/md5'
require 'optparse'
require 'yaml'

require 'fmatch'
require 'fmeta'

include FileMatch


DBFILE = "fmetadata.db"


banner = "usage: findex [options] <PATH>"
options = {
    dbfile: DBFILE,
    updatedb: true,
}
OptionParser.new do |opts|
    opts.banner = banner

    opts.on "-d", "--db-file PATH", "Specify the DB PATH to use." do |path|
        options[:dbfile] = path
    end

    opts.on "-n", "--no-update-db", "Do not update the DB." do
        options[:updatedb] = false
    end

    opts.on "-u", "--update-db", "Update the DB when applicable." do
        options[:updatedb] = true
    end
end.parse!

if ARGV.size != 1
    $stderr << "#{banner}\n"
    exit 0
end


puts "Loading DB #{options[:dbfile]} ..."
t0 = Time.now
h = {}
needupdate = true
if File.exists?(options[:dbfile])
    obj = YAML::load(File.read(options[:dbfile]))
    if obj.is_a?(Hash)
        h = obj
        needupdate = false
    end
end
t1 = Time.now
puts "Loaded DB in #{(t1-t0).round(2)}s."

indexpath = ARGV[0]
nnewfiles = 0
nskipfiles = 0
ndupfiles = 0
nfailfiles = 0
puts "Indexing #{indexpath} ..."
t0 = Time.now

for fpath in Dir.glob("#{indexpath}/**/*", File::FNM_DOTMATCH).select { |e| File.ftype(e) == "file" && has_folder?(".git", e.force_encoding("binary")) == false }
    begin
        fpath = File.realpath(fpath).force_encoding("binary")
        fsize = File.size(fpath)

        if fsize == 0
            nskipfiles += 1
            puts "[SKIP]: #{fpath}"
            next
        end

        # Lazy index the file.
        if h[fsize].nil?
            h[fsize] = fpath
            needupdate = true
            nnewfiles += 1
            puts "[NEW]: #{fpath} nil"
        else
            if h[fsize].is_a?(String)
                p = h[fsize]
                if p == fpath
                    ndupfiles += 1
                    puts "[DUP]: #{fpath}"
                    puts "       #{p}"
                    next
                end

                d = Digest::MD5.hexdigest(File.read(p))
                h[fsize] = { d => FileMeta.new(fsize, p, d) }
                needupdate = true
            end
            digest = Digest::MD5.hexdigest(File.read(fpath))
            if h[fsize][digest].nil?
                h[fsize][digest] = FileMeta.new(fsize, fpath, digest)
                needupdate = true
                nnewfiles += 1
                puts "[NEW]: #{fpath} #{digest}"
            else
                ndupfiles += 1
                puts "[DUP]: #{fpath}"
                puts "       #{h[fsize][digest].path}"
            end
        end
    rescue StandardError => e
        nfailfiles += 1
        puts "[FAIL]: file=\"#{fpath}\" #{e.message}"
    end
end
t1 = Time.now
puts "Indexing completed in #{(t1-t0).round(2)}s."

puts "Indexed:"
puts "     NEW: #{nnewfiles}"
puts "     DUP: #{ndupfiles}"
puts "    SKIP: #{nskipfiles}"
puts "    FAIL: #{nfailfiles}"

if needupdate && options[:updatedb]
    puts "Updating DB #{options[:dbfile]} ..."
    t0 = Time.now
    File.write(options[:dbfile], YAML::dump(h))
    t1 = Time.now
    puts "Updated DB in #{(t1-t0).round(2)}s."
else
    puts "Skip updating DB."
end
