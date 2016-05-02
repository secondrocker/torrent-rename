require "torrent-rename/becoding.rb"

class TorrentRename
  attr_accessor :path , :decode_obj

  def initialize(path)
    self.path=path
    file = File.open(self.path, 'rb')
    b_str = file.read.strip
    file.close
    @decode_obj=b_str.bdecode
  end

  def replace_file
    decode_obj["info"]["name"] = hashed_file_name(decode_obj["info"]["name"])
    if decode_obj["info"].has_key? "name.utf-8"
      decode_obj["info"]["name.utf-8"] = hashed_file_name(decode_obj["info"]["name.utf-8"])
    end
    if decode_obj["info"].has_key? "files"
      decode_obj["info"]["files"].each_with_index do |f,i|
          ["path","path.utf-8"].each do |p|
            if decode_obj["info"]["files"][i].has_key? p
              decode_obj["info"]["files"][i][p].each_with_index do |d,j |
                if decode_obj["info"]["files"][i][p][j]
                  decode_obj["info"]["files"][i][p][j] =
                    hashed_file_name(decode_obj["info"]["files"][i][p][j] )
                end
              end
            end
          end
      end
    end
    encode_str = decode_obj.bencode
    final_name = File.join File.dirname(path),hashed_file_name(File.basename(path))
    n_file = File.new final_name , "w"
    n_file.puts encode_str
    n_file.close
    puts "生成文件:#{final_name}"
  end

  def hashed_file_name(name)
    reg = /(^.+)(\.\w+$)/
    reg =~ name
    if $1
      $1.hash.to_s + $2
    else
      name.hash.to_s
    end
  end
end
