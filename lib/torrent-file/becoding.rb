class Array
  def bencode
    self.inject("l"){|estr,ele| estr += ele.bencode}+"e"
  end
end

class Hash
  def bencode
    self.inject("d"){|estr,p| estr += p[0].bencode+p[1].bencode}+"e"
  end
end

class Integer
  def bencode
    "i#{self}e"
  end
end

class String
  #转化为becode字符
  def bencode
    "#{self.length}:#{self}"
  end

  #获得torrent对象
  def bdecode
    @index = 0
    seek_value
  end

  private
  #移动 size并截取这部分字符
  def move(size)
    cut_str = self[@index,size]
    @index += size
    cut_str
  end
  #查找字符串
  def seek_str
    s_len = ''
    while /\d/.match self[@index]
      s_len += self[@index]
      move(1)
    end
    move(1) if self[@index] == ":"
    move(s_len.to_i)
  end

  #查找int
  def seek_int
    move(1) #移过 i 字符
    tmp_int = ''
    tmp_int += move(1) while self[@index] != "e"
    move(1) #移过 e 字符
    tmp_int.to_i
  end

  #查找 list
  def seek_list
    move(1)#移过 l 字符
    tmp_list = []
    while self[@index] != "e"
      tmp_list << seek_value
    end
    move(1) #移过 e 字符
    tmp_list
  end

  # 查找字典
  def seek_dic
    move(1) #移过 d 字符
    tmp_dic = {}
    while self[@index] != "e"
      key = seek_str
      tmp_dic[key] = seek_value
    end
    move(1) #移过 e 字符
    tmp_dic
  end
  #未知时开始读取
  def seek_value
    case self[@index]
    when "d"
      seek_dic
    when "l"
      seek_list
    when "i"
      seek_int
    else
      seek_str
    end
  end
end
