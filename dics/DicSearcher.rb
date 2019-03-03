# encoding: GBK
#`mode con cols=100`
require '../src/DicDeclaimer.rb'
system('color F0'); @hash = {}; @list = []; @exmp = {}
`title GRE 佛脚单词查找 by Z. S.`

for n in '01'..'26'
  f = open("Dic_#{n}/Dic_#{n}_999.txt")
  eval("@list.push(#{f.read})"); f.close

  @list[-1].each_with_index {|x, i| @hash[x[0]] = [n, i]; x[1].each{|y| if @hash.has_key?(y[1]) then if @hash[y[1]] != [n, i] then y[1] += "||#{n}#{i}" end end; @hash[y[1]] = [n,i]}}
  # hash中存有<单词 及 中文释义-列表号 及 编号>的映射, 当中文释义重复时, 必须添加标识符以示区分
  unless n == '26'
    f = open("Dic_#{n}/Dic_#{n}_Exmp.txt")
    eval("@exmp.merge!(#{f.read})")
    f.close
  end
end

loop do
  begin
    print "\n 请输入要查找的单词/短语或中文释义, 程序将列出所有 \033[1;4;7;44;37m包含\033[0m 输入内容的结果 (支持正则表达式): \033[s"
    print "\n\n 例如: \033[7mCret\033[0m 可匹配 \033[7mconcrete\033[0m; \033[7m^bi.ho\033[0m 可匹配 \033[7mbishop\033[0m; \033[7mno.*aL$\033[0m 可匹配 \033[7mnominal\033[0m; \033[7m错乱\033[0m 可匹配 \033[7manachronism\033[0m.\033[u"
    c = $stdin.gets.chomp
    sleep(0.05); print "\033[J"; sleep(0.05)
    begin
      @result = c.empty? ? [] : @hash.keys.find_all {|x| x.split('||')[0].match(c.downcase)}; puts # 正则表达式匹配
    rescue
      print "\n\n 错误的匹配字符串, "; system('pause'); system('cls')
    end

    if @result.empty?
      print "\n 未找到指定的内容, "; system('pause'); system('cls')
      next
    elsif @result.size > 1
      puts "\n 已找到 #{@result.size} 条记录: \n"
      @result.each_with_index {|x, i| print "\n \033[1;4;7;41;37m[#{i + 1}]\033[0m " + x.split('||')[0]; puts "	\033[1;7;44;37mWord List #{@hash[x][0]}, # #{@hash[x][1] + 1}\033[0m"}

      @ln = 0; print "\n\033[s"
    else
      @ln = 0
    end

    @input = []
    while @input.size < @result.size # 不允许输入重复的编号
      if @result.size != 1
        while @ln.zero? or @ln > @result.size or @input.include?(@ln)
          print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s 请选择需要显示的单词/短语所对应的编号 (以 m 结尾表示不朗读单词及释义), 或直接回车以结束: "
          @ln = $stdin.gets.chomp
          $use_voice = (@ln[-1] != 'm')
          @ln = @ln.empty? ? -1 : @ln.to_i
        end
        if @ln < 0 then break end # 不必循环
      end
      @input.push(@ln) # 列入已选择的编号

      lin, wdn = @hash[@result[@ln - 1]]; lin = lin.to_i - 1; @wd = @list[lin][wdn] # 列表号, 单词编号
      print "\n ----------------------------------------------------------------------------------------\n\n"
      puts " \033[1;7;44;37m* #{@wd[0].capitalize}\033[0m	\033[1;7;41;37m [#{@ln}], Word List %02d, # #{wdn + 1}\033[0m" % (lin + 1)
      declaim('', 3) # 清空当前朗读任务
      declaim(@wd[0])

      if lin == 25
        @wd[1].each {|x| e = x[1].split('||')[0]; print "\n \033[1;4;7;40;37m#{e}\033[0m"; declaim(e, 0)
        print "	\033[1;41;37m例句:\033[0m #{x[0].gsub(/(?<foo>\b#{@wd[0].gsub(/(?<foo>.)(\W+)/, '(\k<foo>|.s|.es|.{0,2}ed|.{0,2}ing)\b|\b')}\b)/i, "\033[7m\\k<foo>\033[0m").gsub("\033[0m \033[7m", ' ').split(':', 2)[1]}\n"}
      else
        @wd[1].each {|x| eng = x[0].split(']', 2); e = x[1].split('||')[0]
        if eng[0].include?('adv') then declaim '副词' elsif eng[0].include?('v') then declaim '动词' end
        if eng[0].include?('conj') then declaim '连词' elsif eng[0].include?('n') then declaim '名词' end
        declaim '形容词' if eng[0].include?('adj')
        declaim '介词' if eng[0].include?('prep')
        declaim e
        print "\n \033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{e}\033[0m\n"}
        print "\n\033[s"
        if @exmp[@wd[0]].empty? then print "\033[u 暂时没有可用或可靠的网络例句. " end
        @exmp[@wd[0]].each_with_index do |x, i|
          print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
          print "\033[1;41;37m例句\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
          puts x[0].gsub(/(?<foo>\b#{@wd[0][0..-2]}.*?\b)/i, "\033[7m\\k<foo>\033[0m")
          puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
          puts; print ' 直接回车查看下一个例句或继续; 输入任意内容并回车以结束: '
          break unless $stdin.gets == "\n"
        end
      end
      print "\n ----------------------------------------------------------------------------------------\n\n\033[s"
    end
    print ' '; system('pause') if @ln >= 0
  rescue Interrupt
    next
  ensure
    system('cls')
  end
end