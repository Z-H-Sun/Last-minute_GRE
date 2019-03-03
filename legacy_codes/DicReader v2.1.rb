# encoding: GBK
#`mode con cols=100`
system('color F0')

def m_explains
  if @ln == 26
    print "\033[F\033[s\n"
    @wd[1].each {|x| print "\n "; print "\033[1;4;7;40;37m#{x[1]}\033[0m	\033[1;41;37m����:\033[0m #{x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m").split(':', 2)[1]}\n"}
    puts; puts
  else
    @wd[1].each {|x| print "\n "; eng = x[0].split(']', 2); print "\033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{x[1]}\033[0m\n"}
    puts; print "\033[s ֱ�ӻس��鿴��һ�����ʣ��������������Բ鿴��������: "
    unless gets == "\n"
      if @exmp[@wd[0]].empty? then print "\033[u ��ʱû�п��û�ɿ�����������. "; system('pause') end
      @exmp[@wd[0]].each_with_index do |x, i|
        print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
        print "\033[1;41;37m����\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
        puts x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m")
        puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
        puts; print ' ֱ�ӻس��鿴��һ����������; �����������ݲ��س��Խ���: '
        break unless gets == "\n"
      end
    end
  end
  print("\033[1A ----------------------------------------------------------------------------------------\n\n")
end

loop do

  `title GRE ��ŵ��ʸ�ϰ by Z. S.`
  @ln = 0; print "\n\033[s"
  while @ln.zero?
    print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s�ʱ�� (1~26, 26 = ����): "
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
    puts; puts '���б� %02d �ĵ�����ȫ����ʶ.' % @ln
  else
    puts; print 'ֱ�ӻس��������ʾ����, �����������ı����س���˳����ʾ����: ' ####### ����ģʽ
    @wnl = @hash.values; random = false
    if gets == "\n" then random = true; @wnl.shuffle! end
    system('cls'); `title �ʱ� #{@ln}, �� #{@list.size} ��, #{random ? '���' : '˳��'}ģʽ`

    puts; puts '��ʾ: ֱ�ӻس���ʾ��ʶ�õ���, �´ν��ӵ����б���ȥ��. ���ʱ����������, ������ "Dic_%02d_xxx.txt" ���ѱ��ʼ�¼, ��¼�� xxx Խ��, ��ʾ��¼Խ��, 999 �ż�¼���������е���. ���󰴻س�, ������һ�����ʴ������������� (0~9) ���س��Գ���.' % @ln
    puts; puts '����������ĸ (A~Z, a~z) ���س��Բ鿴�������� (�ɰٶȷ����ṩ); �������������ַ���ʾ����ʶ�õ���, ����ʾ˫������, �������ڵ����б���.'
    system('pause'); system('cls'); puts
  end

  $stdout.sync = true
  @wn = 0; @known = []
  while @wn < @hash.size
    @wn += 1; `title �ʱ� #{@ln}, ���� #{@wn} / #{@hash.size}`
    @wd = @list[@wnl[@wn - 1]]
    print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; print '	'
    r = gets
    if r == "\n"
      @known.push(@wnl[@wn - 1])
      print "\033[1A\033[45C \033[1;7;42;37m����ʶ \033[0m\033[1;41;37m ("; @wd[1].each {|x| print x[1] + '; '}
      print "\033[2D)\033[0m\r\033[s\n\n"; print " ----------------------------------------------------------------------------------------\n\n"
    elsif (r.ord > 64 and r.ord < 91) or (r.ord > 96 and r.ord < 123)
      puts; print "\033[s"
      if @ln == 26
        @wd[1].each {|e| puts " \033[1;41;37m����\033[0m	#{e[0].gsub(@dw[0], "\033[7m#{@wd[0]}\033[0m").split(':', 2)[1]}"; puts}
        print ' '; system('pause')
      else
        if @exmp[@wd[0]].empty? then print "\033[u ��ʱû�п��û�ɿ�����������. "; system('pause') end
        @exmp[@wd[0]].each_with_index do |x, i|
          print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
          print "\033[1;41;37m����\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
          puts x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m")
          puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
          puts; print ' ֱ�ӻس��鿴��һ����������; �����������ݲ��س��Խ���: '
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
    puts " �˴�����ʶ�� \033[1;4;7;44;37m#{@known.size}\033[0m ������! �����ɼ�¼ \033[7m #{'Dic_%02d_%03d.txt' % [@ln, @rec[-1]]} \033[0m."
  end

  loop do
    puts "\n-----------------------------------------------------------------------------------------\n\n������, ֱ�ӻس����ص��ʼ��ѡ���б�ҳ��, ���߿���������Ӧ�����ֲ��س��Ը�ϰ֮ǰ�ı��ʼ�¼ (����еĻ�. ��һ����ʾ�˿��õļ�¼��): \033[s"
    @rec[1..-1].each {|j| puts("\n\033[7m%03d\033[0m	" % j + File.mtime('Dic_%02d\\Dic_%02d_%03d.txt' % [@ln, @ln, j]).to_s)}
    print "\033[u"; @rn = gets.chomp.to_i
    system('cls')
    if @rec[1..-1].include?(@rn)
      puts; print 'ֱ�ӻس��������ʾ����, �����������ı����س���˳����ʾ����: ' ####### ����ģʽ
      @wnl = @hash_del[@rn].values.sort; random = false
      if gets == "\n" then random = true; @wnl.shuffle! end
      puts "\n��ѡ����#{random ? '���' : '˳��'}ģʽ. ��ÿ�����ʳ��ֺ��밴�س�������."; `pause`; system('cls'); puts

      @wn = 0
      while @wn < @hash_del[@rn].size
        @wn += 1; `title �ʱ� #{@ln}, ��¼ #{'%03d' % @rn}, ���� #{@wn} / #{@hash_del[@rn].size}`
        @wd = @list[@wnl[@wn - 1]]
        print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; print '	'; gets
        m_explains
      end
      puts ' ��¼ %03d ���˽���.' % @rn
    else
      break
    end
  end
end
