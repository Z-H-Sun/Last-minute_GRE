# encoding: GBK
require './DicDeclaimer.rb'
system 'color F0' # 白底黑字
Dir.chdir '../dics'

def m_explains(mode = 0) # mode = 1 : 只显示例句的模式
  if @ln == 26
    print "\033[F\033[s\n" if mode.zero? # 保存位置, 下一句例句返回
    @wd[1].each do |x|
      print "\n \033[1;4;7;40;37m#{x[1]}\033[0m	" if mode.zero?
      print " \033[1;41;37m例句\033[0m "
      declaim(x[1], 0) if mode.zero? # 朗读解释; 下一语句将词组中出现的单词标出. 考虑了三单、过去、现在的变形. (将词组中非字母部分替换为通配符. 要考虑末尾y变为i, 末尾双写. 匹配单词边界 (空格)). 最后, 连续的标记间的空格也要一起标出.
      puts x[0].gsub(/(?<foo>\b#{@wd[0].gsub(/(?<foo>.)(\W+)/, '(\k<foo>|.s|.es|.{0,2}ed|.{0,2}ing)\b|\b')}\b)/i, "\033[7m\\k<foo>\033[0m").gsub("\033[0m \033[7m", ' ').split(':', 2)[1]
      puts unless mode.zero?
    end
    if mode.zero? then print "\n\n" else print ' '; system('pause') end
  else
    if mode.zero?
      @wd[1].each do |x|
        eng = x[0].split(']', 2) # 朗读词性
        if eng[0].include?('adv') then declaim '副词' elsif eng[0].include?('v') then declaim '动词' end
        if eng[0].include?('conj') then declaim '连词' elsif eng[0].include?('n') then declaim '名词' end
        declaim '形容词' if eng[0].include?('adj')
        declaim '介词' if eng[0].include?('prep')
        declaim x[1]
        print "\n \033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{x[1]}\033[0m\n" # 标出词性、中文释义
      end
      puts; print "\033[s 按 S 查看下一个单词；或按 D 以查看网络例句: "
      if getinput('sd') == 's' then print("\033[1A ----------------------------------------------------------------------------------------\n\n"); return true end
    end
    if @exmp[@wd[0]].empty? then print "\033[u 暂时没有可用或可靠的网络例句. "; system('pause') end
    @exmp[@wd[0]].each_with_index do |x, i|
      print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05) # 覆盖上一次显示的内容
      print "\033[1;41;37m例句\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
      puts x[0].gsub(/(?<foo>\b#{@wd[0][0..-2]}.*?\b)/i, "\033[7m\\k<foo>\033[0m") # 标出例句中的单词，考虑了三单、过去、现在的变形 (\b匹配单词边界, 加?表示非贪心, 找到最近的边界)
      puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m" # 例句来源
      puts; print ' 按 D 查看下一个例句或继续; 或按 S 以结束: '
      break if getinput('sd') == 's'
    end
  end
  print("\033[1A ----------------------------------------------------------------------------------------\n\n") if mode.zero?
end

loop do
  begin # Ctrl+C 退出当前
    `title GRE 佛脚单词复习 by Z. S.`
    @ln = 0; print "\n\033[s"
    while @ln < 1 or @ln > 26 # 如果输入得不对就重来
      print "\033[u"; sleep(0.05); print "\033[K"; print "\r请键入词表号 (1~26, 26 = 短语, 以 A 结尾表示静音): "; sleep(0.05);print "\033[s"
      print "\n\n键入前一个数字后, 有 1 秒钟的间隔以键入下一个数字. 或者可按 S 直接确认; 或按 A 确认并进入静音模式, 将不朗读单词及释义.\033[u"
      @ln = getnumber
    end

    print "\033[J" # 清除后边的所有文本
    @rec = [0] # 读入背词记录
    fls = Dir.entries('Dic_%02d' % @ln)
    fls.each {|i| if i[0, 6] == ('Dic_%02d' % @ln) and i[-4, 4] == '.txt' then n = i.split('_')[2].to_i; @rec.push(n) unless n.zero? end}
    @rec.delete(999); @rec.sort!

    f = open('Dic_%02d/Dic_%02d_999.txt' % [@ln, @ln]) # 读入单词表, 建立<单词-编号>映射
    eval("@list = #{f.read}"); f.close
    @hash = {}; @hash_del = {}
    @list.each_with_index {|x, i| @hash[x[0]] = i}

    unless @rec[-1].zero?
      @rec[1..-1].each do |i|
        f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, i])
        @hash_tmp = {}
        eval("#{f.read}.each {|x| @hash_tmp[x[0]] = @hash[x[0]]; @hash.delete(x[0])}") # 记录、删除已背单词
        @hash_del[i] = @hash_tmp
        f.close
      end
    end

    unless @ln == 26 # 读入例句
      f = open('Dic_%02d/Dic_%02d_Exmp.txt' % [@ln, @ln])
      eval("@exmp = #{f.read}"); f.close
    end

    if @hash.size.zero?
      puts; puts '该列表 %02d 的单词已全部认识.' % @ln
    else
      puts; print '按 S 可随机显示单词, 或按 D 以顺序显示单词: '
      @wnl = @hash.values; random = false
      if getinput('sd') == 's' then random = true; @wnl.shuffle! end # 打乱顺序
      system('cls'); `title 词表 #{@ln}, 共 #{@list.size} 词, #{random ? '随机' : '顺序'} ^| #{$use_voice ? '朗读' : '静音'}模式`

      puts; puts '提示: 每次显示单词后, 按下 [W/A/S/D] 键以控制. 按 S 表示认识该单词, 下次将从单词列表中去除. 本词表任务结束后, 将生成 "Dic_%02d_###.txt" 的已背词记录, 记录号 ### 越大, 表示记录越新, 999 号记录即包括所有单词. 若按错控制键, 可在下一个单词处按 W 以撤销.' % @ln
      puts; puts 'W = 上一单词; S = 下一单词; D = 查看详细信息 (网络例句由百度翻译提供); A = 不认识该单词, 将显示双语释义, 并保留在单词列表中. 按下 W 后, 将按顺序朗读单词释义, 过程中可按任意键以中断. 任何等待用户输入处均可按 Ctrl+C 以跳出当前过程并返回上一界面.'; puts
      system('pause'); system('cls'); puts
    end

    $stdout.sync = true # 强制缓冲区立即输出至控制台, 虽然Ruby 2以上版本默认如此
    @wn = 0; @known = [] # 进度, 新背会单词列表
    while @wn < @hash.size
      @wn += 1; `title 词表 #{@ln}, 进度 #{@wn} / #{@hash.size}`
      @wd = @list[@wnl[@wn - 1]]
      declaim('', 3) # 清空当前朗读任务
      print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim(@wd[0], 1, 1); print '	'
      r = getinput('wasd')
      case r
      when 's'
        @known.push(@wnl[@wn - 1]) # 认识单词, 仍然显示、朗读中文释义
        print "\033[1A\033[45C \033[1;7;42;37m已认识 \033[0m\033[1;41;37m ("; @wd[1].each {|x| print x[1] + '; '; declaim(x[1], 0)}
        print "\033[2D)\033[0m\r\033[s\n\n"; print " ----------------------------------------------------------------------------------------\n\n"
      when 'd'
        puts; print "\033[s"
        m_explains(1)
        print("\033[u\033[2A"); sleep(0.05); print "\033[J"; sleep(0.05); @wn -= 1
      when 'w'
        if @wn > 1
          print "\033[u"; sleep(0.05); print "\033[J"; sleep(0.05) # 返回上一处保留的位置
          @wn -= 2; @known.delete(@wnl[@wn]) # 回退至上一单词, 从已认识词表中删除本单词
        else # 第一个单词无法回退
          system('cls'); sleep(0.05)
          @wn = 0; puts
        end
      else
        m_explains # 不认识该单词
      end
    end

    if @known.size > 0
      @rec.push(@rec[-1] + 1) # 更新已认识词表
      @hash_tmp = {}
      @known.each {|j| @hash_tmp[@list[j]] = j}
      @hash_del[@rec[-1]] = @hash_tmp

      f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rec[-1]], 'w')
      l = @known.map {|j| @list[j]}
      f.write(l.to_s); f.close
      puts " 此次新认识了 \033[1;4;7;44;37m#{@known.size}\033[0m 个单词! 已生成记录 \033[7m #{'Dic_%02d_%03d.txt' % [@ln, @rec[-1]]} \033[0m."
    end

    loop do
      begin # Ctrl+C 退出当前
        puts "\n-----------------------------------------------------------------------------------------\n\n接下来, 按 [A/S] 键将回到最开始的选择列表页面, 或者键入相应记录号以复习之前的背词记录 (如果有的话. 注意 “1 秒钟间隔”, 可用 [A/S] 切换静音/朗读模式). 下一行显示了可用的记录号: \033[s"
        @rec[1..-1].each {|j| puts("\n\033[7m%03d\033[0m	" % j + File.mtime('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, j]).to_s)}
        print "\033[u"; @rn = getnumber
        print "\033[J"
        if @rec[1..-1].include?(@rn)
          puts; print '按 S 可随机显示单词, 或按 D 以顺序显示单词: '
          @wnl = @hash_del[@rn].values.sort; random = false
          if getinput('sd') == 's' then random = true; @wnl.shuffle! end
          print "\n你选择了#{random ? '随机' : '顺序'} | #{$use_voice ? '朗读' : '静音'}模式. 当每个单词出现后, 请用 [W/A/S] 键控制: S = 上一单词, W = 下一单词, A = 将该词语重新纳入至生词本.\n\n"; system('pause'); system('cls'); puts

          @wn = 0; @patch = [] # patch为重新不认识的单词, 需要从已认识词表中重新剔除
          while @wn < @hash_del[@rn].size
            @wn += 1; `title 词表 #{@ln}, 记录 #{'%03d' % @rn}, 进度 #{@wn} / #{@hash_del[@rn].size}`
            @wd = @list[@wnl[@wn - 1]]
            print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim(@wd[0], 1, 1)
            print '	'; r = getinput('was').downcase.chomp
            case r
            when 's'
            when 'w' # 返回上一个单词, 该单词不列入patch列表
              if @wn > 1
                print "\033[u"; sleep(0.05); print "\033[J"; sleep(0.05)
                @wn -= 2; @patch.delete(@list[@wnl[@wn]][0])
              else
                system('cls'); sleep(0.05)
                @wn = 0; puts
              end
              next
            else
              print "\033[1A\033[45C \033[1;7;42;37m已重新加入生词本\033[0m\n"; @patch.push(@wd[0])
            end
            m_explains
          end
          puts ' 记录 %03d 到此结束.' % @rn
          f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn])
          eval("@list_tmp = #{f.read}"); f.close
          @list_tmp.delete_if {|x| @patch.include?(x[0])}
          f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn], 'w')
          f.write(@list_tmp.to_s); f.close # 重新写入已认识词表
        else
          system('cls'); break
        end
      rescue Interrupt
        next
      end
    end
  rescue Interrupt
    system('cls'); next
  end
end