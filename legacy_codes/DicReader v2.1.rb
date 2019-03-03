# encoding: GBK
#`mode con cols=100`
system('color F0')

def m_explains
  if @ln == 26
    print "\033[F\033[s\n"
    @wd[1].each {|x| print "\n "; print "\033[1;4;7;40;37m#{x[1]}\033[0m	\033[1;41;37m例句:\033[0m #{x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m").split(':', 2)[1]}\n"}
    puts; puts
  else
    @wd[1].each {|x| print "\n "; eng = x[0].split(']', 2); print "\033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{x[1]}\033[0m\n"}
    puts; print "\033[s 直接回车查看下一个单词；输入任意内容以查看网络例句: "
    unless gets == "\n"
      if @exmp[@wd[0]].empty? then print "\033[u 暂时没有可用或可靠的网络例句. "; system('pause') end
      @exmp[@wd[0]].each_with_index do |x, i|
        print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
        print "\033[1;41;37m例句\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
        puts x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m")
        puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
        puts; print ' 直接回车查看下一个例句或继续; 输入任意内容并回车以结束: '
        break unless gets == "\n"
      end
    end
  end
  print("\033[1A ----------------------------------------------------------------------------------------\n\n")
end

loop do

  `title GRE 佛脚单词复习 by Z. S.`
  @ln = 0; print "\n\033[s"
  while @ln.zero?
    print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s词表号 (1~26, 26 = 短语): "
    @ln = gets.chomp.to_i
  end

  @rec = [0]
  fls = Dir.entries('Dic_%02d' % @ln)
  fls.each {|i| if i[0, 6] == ('Dic_%02d' % @ln) and i[-4, 4] == '.txt' then n = i.split('_')[2].to_i; @rec.push(n) unless n.zero? end}
  @rec.delete(999); @rec.sort!

  f = open('Dic_%02d\\Dic_%02d_999.txt' % [@ln, @ln])
  eval("@list = #{f.read}"); f.close
  @hash = {}; @hash_del = {}
  @list.each_with_index {|x, i| @hash[x[0]] = i}
  unless @rec[-1].zero?
    @rec[1..-1].each do |i|
      f = open('Dic_%02d\\Dic_%02d_%03d.txt' % [@ln, @ln, i])
      @hash_tmp = {}
      eval("#{f.read}.each {|x| @hash_tmp[x[0]] = @hash[x[0]]; @hash.delete(x[0])}")
      @hash_del[i] = @hash_tmp
      f.close
    end
  end

  unless @ln == 26
    f = open('Dic_%02d\\Dic_%02d_Exmp.txt' % [@ln, @ln])
    eval("@exmp = #{f.read}"); f.close
  end

  if @hash.size.zero?
    puts; puts '该列表 %02d 的单词已全部认识.' % @ln
  else
    puts; print '直接回车可随机显示单词, 或输入任意文本并回车以顺序显示单词: ' ####### 搜索模式
    @wnl = @hash.values; random = false
    if gets == "\n" then random = true; @wnl.shuffle! end
    system('cls'); `title 词表 #{@ln}, 共 #{@list.size} 词, #{random ? '随机' : '顺序'}模式`

    puts; puts '提示: 直接回车表示认识该单词, 下次将从单词列表中去除. 本词表任务结束后, 将生成 "Dic_%02d_xxx.txt" 的已背词记录, 记录号 xxx 越大, 表示记录越新, 999 号记录即包括所有单词. 若误按回车, 可在下一个单词处输入任意数字 (0~9) 并回车以撤销.' % @ln
    puts; puts '输入任意字母 (A~Z, a~z) 并回车以查看网络例句 (由百度翻译提供); 输入任意其余字符表示不认识该单词, 将显示双语释义, 并保留在单词列表中.'
    system('pause'); system('cls'); puts
  end

  $stdout.sync = true
  @wn = 0; @known = []
  while @wn < @hash.size
    @wn += 1; `title 词表 #{@ln}, 进度 #{@wn} / #{@hash.size}`
    @wd = @list[@wnl[@wn - 1]]
    print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; print '	'
    r = gets
    if r == "\n"
      @known.push(@wnl[@wn - 1])
      print "\033[1A\033[45C \033[1;7;42;37m已认识 \033[0m\033[1;41;37m ("; @wd[1].each {|x| print x[1] + '; '}
      print "\033[2D)\033[0m\r\033[s\n\n"; print " ----------------------------------------------------------------------------------------\n\n"
    elsif (r.ord > 64 and r.ord < 91) or (r.ord > 96 and r.ord < 123)
      puts; print "\033[s"
      if @ln == 26
        @wd[1].each {|e| puts " \033[1;41;37m例句\033[0m	#{e[0].gsub(@dw[0], "\033[7m#{@wd[0]}\033[0m").split(':', 2)[1]}"; puts}
        print ' '; system('pause')
      else
        if @exmp[@wd[0]].empty? then print "\033[u 暂时没有可用或可靠的网络例句. "; system('pause') end
        @exmp[@wd[0]].each_with_index do |x, i|
          print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
          print "\033[1;41;37m例句\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
          puts x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m")
          puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
          puts; print ' 直接回车查看下一个例句或继续; 输入任意内容并回车以结束: '
          break unless gets == "\n"
        end
      end
      print("\033[u\033[2A"); sleep(0.05); print "\033[J"; sleep(0.05); @wn -= 1
    elsif r.ord > 47 and r.ord < 58
      if @wn > 1
        print "\033[u"; sleep(0.05); print "\033[J"; sleep(0.05)
        @wn -= 2; @known.delete_at(-1)

        # Legacy method
=begin
      print "\033[1A\r"; sleep(0.05)
      print "\033[K"; print "\033[1A"; sleep(0.05)
      print "\033[K"; print "\033[1A"; sleep(0.05)
      print "\033[K"; @wn -= 2; @known[@wn] = false
=end
      else
        system('cls'); sleep(0.05)
        @wn = 0; puts
      end
    else
      m_explains
    end
  end

  if @known.size > 0
    @rec.push(@rec[-1] + 1)
    f = open('Dic_%02d\\Dic_%02d_%03d.txt' % [@ln, @ln, @rec[-1]], 'w')
    l = @known.map {|j| @list[j]}
    f.write(l.to_s); f.close
    puts " 此次新认识了 \033[1;4;7;44;37m#{@known.size}\033[0m 个单词! 已生成记录 \033[7m #{'Dic_%02d_%03d.txt' % [@ln, @rec[-1]]} \033[0m."
  end

  loop do
    puts "\n-----------------------------------------------------------------------------------------\n\n接下来, 直接回车将回到最开始的选择列表页面, 或者可以输入相应的数字并回车以复习之前的背词记录 (如果有的话. 下一行显示了可用的记录号): \033[s"
    @rec[1..-1].each {|j| puts("\n\033[7m%03d\033[0m	" % j + File.mtime('Dic_%02d\\Dic_%02d_%03d.txt' % [@ln, @ln, j]).to_s)}
    print "\033[u"; @rn = gets.chomp.to_i
    system('cls')
    if @rec[1..-1].include?(@rn)
      puts; print '直接回车可随机显示单词, 或输入任意文本并回车以顺序显示单词: ' ####### 搜索模式
      @wnl = @hash_del[@rn].values.sort; random = false
      if gets == "\n" then random = true; @wnl.shuffle! end
      puts "\n你选择了#{random ? '随机' : '顺序'}模式. 当每个单词出现后，请按回车键继续."; `pause`; system('cls'); puts

      @wn = 0
      while @wn < @hash_del[@rn].size
        @wn += 1; `title 词表 #{@ln}, 记录 #{'%03d' % @rn}, 进度 #{@wn} / #{@hash_del[@rn].size}`
        @wd = @list[@wnl[@wn - 1]]
        print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; print '	'; gets
        m_explains
      end
      puts ' 记录 %03d 到此结束.' % @rn
    else
      break
    end
  end
end
