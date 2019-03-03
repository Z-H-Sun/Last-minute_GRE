# encoding: GBK
#`mode con cols=100`
require '../src/DicDeclaimer.rb'
system('color F0') # �׵׺���

def m_explains(mode = 0) # mode = 1 : ֻ��ʾ�����ģʽ
  if @ln == 26
    print "\033[F\033[s\n" if mode.zero? # ����λ��, ��һ�����䷵��
    @wd[1].each do |x|
      print "\n \033[1;4;7;40;37m#{x[1]}\033[0m	" if mode.zero?
      print " \033[1;41;37m����\033[0m "
      declaim(x[1], 0) if mode.zero? # �ʶ�����; ��һ��佫�����г��ֵĵ��ʱ��. ��������������ȥ�����ڵı���. (�������з���ĸ�����滻Ϊͨ���. Ҫ����ĩβy��Ϊi, ĩβ˫д. ƥ�䵥�ʱ߽� (�ո�)). ���, �����ı�Ǽ�Ŀո�ҲҪһ����.
      puts x[0].gsub(/(?<foo>\b#{@wd[0].gsub(/(?<foo>.)(\W+)/, '(\k<foo>|.s|.es|.{0,2}ed|.{0,2}ing)\b|\b')}\b)/i, "\033[7m\\k<foo>\033[0m").gsub("\033[0m \033[7m", ' ').split(':', 2)[1]
      puts unless mode.zero?
    end
    if mode.zero? then print "\n\n" else print ' '; system('pause') end
  else
    if mode.zero?
      @wd[1].each do |x|
        eng = x[0].split(']', 2) # �ʶ�����
        if eng[0].include?('adv') then declaim '����' elsif eng[0].include?('v') then declaim '����' end
        if eng[0].include?('conj') then declaim '����' elsif eng[0].include?('n') then declaim '����' end
        declaim '���ݴ�' if eng[0].include?('adj')
        declaim '���' if eng[0].include?('prep')
        declaim x[1]
        print "\n \033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{x[1]}\033[0m\n" # ������ԡ���������
      end
      puts; print "\033[s ֱ�ӻس��鿴��һ�����ʣ��������������Բ鿴��������: "
      if $stdin.gets == "\n" then print("\033[1A ----------------------------------------------------------------------------------------\n\n"); return true end
    end
    if @exmp[@wd[0]].empty? then print "\033[u ��ʱû�п��û�ɿ�����������. "; system('pause') end
    @exmp[@wd[0]].each_with_index do |x, i|
      print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05) # ������һ����ʾ������
      print "\033[1;41;37m����\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
      puts x[0].gsub(/(?<foo>\b#{@wd[0][0..-2]}.*?\b)/i, "\033[7m\\k<foo>\033[0m") # ��������еĵ��ʣ���������������ȥ�����ڵı��� (\bƥ�䵥�ʱ߽�, ��?��ʾ��̰��, �ҵ�����ı߽�)
      puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m" # ������Դ
      puts; print ' ֱ�ӻس��鿴��һ����������; �����������ݲ��س��Խ���: '
      break unless $stdin.gets == "\n"
    end
  end
  print("\033[1A ----------------------------------------------------------------------------------------\n\n") if mode.zero?
end

loop do

  `title GRE ��ŵ��ʸ�ϰ by Z. S.`
  @ln = 0; print "\n\033[s"
  while @ln.zero? # �������ò��Ծ�����
    print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s�ʱ�� (1~26, 26 = ����, �� m ��β��ʾ�������ʶ����ʼ�����): "
    @ln = $stdin.gets.chomp
    $use_voice = (@ln[-1] != 'm')
    @ln = @ln.to_i
  end

  @rec = [0] # ���뱳�ʼ�¼
  fls = Dir.entries('Dic_%02d' % @ln)
  fls.each {|i| if i[0, 6] == ('Dic_%02d' % @ln) and i[-4, 4] == '.txt' then n = i.split('_')[2].to_i; @rec.push(n) unless n.zero? end}
  @rec.delete(999); @rec.sort!

  f = open('Dic_%02d/Dic_%02d_999.txt' % [@ln, @ln]) # ���뵥�ʱ�, ����<����-���>ӳ��
  eval("@list = #{f.read}"); f.close
  @hash = {}; @hash_del = {}
  @list.each_with_index {|x, i| @hash[x[0]] = i}

  unless @rec[-1].zero?
    @rec[1..-1].each do |i|
      f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, i])
      @hash_tmp = {}
      eval("#{f.read}.each {|x| @hash_tmp[x[0]] = @hash[x[0]]; @hash.delete(x[0])}") # ��¼��ɾ���ѱ�����
      @hash_del[i] = @hash_tmp
      f.close
    end
  end

  unless @ln == 26 # ��������
    f = open('Dic_%02d/Dic_%02d_Exmp.txt' % [@ln, @ln])
    eval("@exmp = #{f.read}"); f.close
  end

  if @hash.size.zero?
    puts; puts '���б� %02d �ĵ�����ȫ����ʶ.' % @ln
  else
    puts; print 'ֱ�ӻس��������ʾ����, �����������ı����س���˳����ʾ����: '
    @wnl = @hash.values; random = false
    if $stdin.gets == "\n" then random = true; @wnl.shuffle! end # ����˳��
    system('cls'); `title �ʱ� #{@ln}, �� #{@list.size} ��, #{random ? '���' : '˳��'}ģʽ`

    puts; puts '��ʾ: ֱ�ӻس���ʾ��ʶ�õ���, �´ν��ӵ����б���ȥ��. ���ʱ����������, ������ "Dic_%02d_xxx.txt" ���ѱ��ʼ�¼, ��¼�� xxx Խ��, ��ʾ��¼Խ��, 999 �ż�¼���������е���. ���󰴻س�, ������һ�����ʴ������������� (0~9) ���س��Գ���.' % @ln
    puts; puts '����������ĸ (A~Z, a~z) ���س��Բ鿴�������� (�ɰٶȷ����ṩ); �������������ַ���ʾ����ʶ�õ���, ����ʾ˫������, �������ڵ����б���.'
    system('pause'); system('cls'); puts
  end

  $stdout.sync = true # ǿ�ƻ������������������̨, ��ȻRuby 2���ϰ汾Ĭ�����
  @wn = 0; @known = [] # ����, �±��ᵥ���б�
  while @wn < @hash.size
    @wn += 1; `title �ʱ� #{@ln}, ���� #{@wn} / #{@hash.size}`
    @wd = @list[@wnl[@wn - 1]]
    declaim('', 3) # ��յ�ǰ�ʶ�����
    print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim @wd[0]; print '	'
    r = $stdin.gets
    if r == "\n"
      @known.push(@wnl[@wn - 1]) # ��ʶ����, ��Ȼ��ʾ���ʶ���������
      print "\033[1A\033[45C \033[1;7;42;37m����ʶ \033[0m\033[1;41;37m ("; @wd[1].each {|x| print x[1] + '; '; declaim(x[1], 0)}
      print "\033[2D)\033[0m\r\033[s\n\n"; print " ----------------------------------------------------------------------------------------\n\n"
    elsif (r.ord > 64 and r.ord < 91) or (r.ord > 96 and r.ord < 123) # [a-zA-Z]: ��ʾ����
      puts; print "\033[s"
      m_explains(1)
      print("\033[u\033[2A"); sleep(0.05); print "\033[J"; sleep(0.05); @wn -= 1
    elsif r.ord > 47 and r.ord < 58
      if @wn > 1
        print "\033[u"; sleep(0.05); print "\033[J"; sleep(0.05) # ������һ��������λ��
        @wn -= 2; @known.delete(@wnl[@wn]) # ��������һ����, ������ʶ�ʱ���ɾ��������

        # Legacy method
=begin
      print "\033[1A\r"; sleep(0.05)
      print "\033[K"; print "\033[1A"; sleep(0.05)
      print "\033[K"; print "\033[1A"; sleep(0.05)
      print "\033[K"; @wn -= 2; @known[@wn] = false
=end
      else # ��һ�������޷�����
        system('cls'); sleep(0.05)
        @wn = 0; puts
      end
    else
      m_explains # ����ʶ�õ���
    end
  end

  if @known.size > 0
    @rec.push(@rec[-1] + 1) # ��������ʶ�ʱ�
    @hash_tmp = {}
    @known.each {|j| @hash_tmp[@list[j]] = j}
    @hash_del[@rec[-1]] = @hash_tmp

    f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rec[-1]], 'w')
    l = @known.map {|j| @list[j]}
    f.write(l.to_s); f.close
    puts " �˴�����ʶ�� \033[1;4;7;44;37m#{@known.size}\033[0m ������! �����ɼ�¼ \033[7m #{'Dic_%02d_%03d.txt' % [@ln, @rec[-1]]} \033[0m."
  end

  loop do
    puts "\n-----------------------------------------------------------------------------------------\n\n������, ֱ�ӻس����ص��ʼ��ѡ���б�ҳ��, ���߿���������Ӧ�����ֲ��س��Ը�ϰ֮ǰ�ı��ʼ�¼ (����еĻ�. ��һ����ʾ�˿��õļ�¼��): \033[s"
    @rec[1..-1].each {|j| puts("\n\033[7m%03d\033[0m	" % j + File.mtime('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, j]).to_s)}
    print "\033[u"; @rn = $stdin.gets.chomp.to_i
    system('cls')
    if @rec[1..-1].include?(@rn)
      puts; print 'ֱ�ӻس��������ʾ����, �����������ı����س���˳����ʾ����: '
      @wnl = @hash_del[@rn].values.sort; random = false
      if $stdin.gets == "\n" then random = true; @wnl.shuffle! end
      puts "\n��ѡ����#{random ? '���' : '˳��'}ģʽ. ��ÿ�����ʳ��ֺ�, �밴�س�������, ���������� (1~9) �ص���һ��Ŀ, �������������������Խ��ô����������������ʱ�."; `pause`; system('cls'); puts

      @wn = 0; @patch = [] # patchΪ���²���ʶ�ĵ���, ��Ҫ������ʶ�ʱ��������޳�
      while @wn < @hash_del[@rn].size
        @wn += 1; `title �ʱ� #{@ln}, ��¼ #{'%03d' % @rn}, ���� #{@wn} / #{@hash_del[@rn].size}`
        @wd = @list[@wnl[@wn - 1]]
        print " \033[1;4;7;44;37m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim @wd[0]; print '	'; r = $stdin.gets.chomp
        if r.empty?
        elsif r.ord > 47 and r.ord < 58 # ������һ������, �õ��ʲ�����patch�б�
          if @wn > 1
            print "\033[u"; sleep(0.05); print "\033[J"; sleep(0.05)
            @wn -= 2; @patch.delete(@list[@wnl[@wn]][0])
          else
            system('cls'); sleep(0.05)
            @wn = 0; puts
          end
          next
        else
          print "\033[1A\033[45C \033[1;7;42;37m�����¼������ʱ�\033[0m\n"; @patch.push(@wd[0])
        end
        m_explains
      end
      puts ' ��¼ %03d ���˽���.' % @rn
      f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn])
      eval("@list_tmp = #{f.read}"); f.close
      @list_tmp.delete_if {|x| @patch.include?(x[0])}
      f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn], 'w')
      f.write(@list_tmp.to_s); f.close # ����д������ʶ�ʱ�
    else
      break
    end
  end
end
