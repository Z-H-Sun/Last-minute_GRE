# encoding: GBK
#`mode con cols=100`
require '../src/DicDeclaimer.rb'
system('color F0'); @hash = {}; @list = []; @exmp = {}
`title GRE ��ŵ��ʲ��� by Z. S.`

for n in '01'..'26'
  f = open("Dic_#{n}/Dic_#{n}_999.txt")
  eval("@list.push(#{f.read})"); f.close

  @list[-1].each_with_index {|x, i| @hash[x[0]] = [n, i]; x[1].each{|y| if @hash.has_key?(y[1]) then if @hash[y[1]] != [n, i] then y[1] += "||#{n}#{i}" end end; @hash[y[1]] = [n,i]}}
  # hash�д���<���� �� ��������-�б�� �� ���>��ӳ��, �����������ظ�ʱ, ������ӱ�ʶ����ʾ����
  unless n == '26'
    f = open("Dic_#{n}/Dic_#{n}_Exmp.txt")
    eval("@exmp.merge!(#{f.read})")
    f.close
  end
end

loop do
  begin
    print "\n ������Ҫ���ҵĵ���/�������������, �����г����� \033[1;4;7;44;37m����\033[0m �������ݵĽ�� (֧��������ʽ): \033[s"
    print "\n\n ����: \033[7mCret\033[0m ��ƥ�� \033[7mconcrete\033[0m; \033[7m^bi.ho\033[0m ��ƥ�� \033[7mbishop\033[0m; \033[7mno.*aL$\033[0m ��ƥ�� \033[7mnominal\033[0m; \033[7m����\033[0m ��ƥ�� \033[7manachronism\033[0m.\033[u"
    c = $stdin.gets.chomp
    sleep(0.05); print "\033[J"; sleep(0.05)
    begin
      @result = c.empty? ? [] : @hash.keys.find_all {|x| x.split('||')[0].match(c.downcase)}; puts # ������ʽƥ��
    rescue
      print "\n\n �����ƥ���ַ���, "; system('pause'); system('cls')
    end

    if @result.empty?
      print "\n δ�ҵ�ָ��������, "; system('pause'); system('cls')
      next
    elsif @result.size > 1
      puts "\n ���ҵ� #{@result.size} ����¼: \n"
      @result.each_with_index {|x, i| print "\n \033[1;4;7;41;37m[#{i + 1}]\033[0m " + x.split('||')[0]; puts "	\033[1;7;44;37mWord List #{@hash[x][0]}, # #{@hash[x][1] + 1}\033[0m"}

      @ln = 0; print "\n\033[s"
    else
      @ln = 0
    end

    @input = []
    while @input.size < @result.size # �����������ظ��ı��
      if @result.size != 1
        while @ln.zero? or @ln > @result.size or @input.include?(@ln)
          print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s ��ѡ����Ҫ��ʾ�ĵ���/��������Ӧ�ı�� (�� m ��β��ʾ���ʶ����ʼ�����), ��ֱ�ӻس��Խ���: "
          @ln = $stdin.gets.chomp
          $use_voice = (@ln[-1] != 'm')
          @ln = @ln.empty? ? -1 : @ln.to_i
        end
        if @ln < 0 then break end # ����ѭ��
      end
      @input.push(@ln) # ������ѡ��ı��

      lin, wdn = @hash[@result[@ln - 1]]; lin = lin.to_i - 1; @wd = @list[lin][wdn] # �б��, ���ʱ��
      print "\n ----------------------------------------------------------------------------------------\n\n"
      puts " \033[1;7;44;37m* #{@wd[0].capitalize}\033[0m	\033[1;7;41;37m [#{@ln}], Word List %02d, # #{wdn + 1}\033[0m" % (lin + 1)
      declaim('', 3) # ��յ�ǰ�ʶ�����
      declaim(@wd[0])

      if lin == 25
        @wd[1].each {|x| e = x[1].split('||')[0]; print "\n \033[1;4;7;40;37m#{e}\033[0m"; declaim(e, 0)
        print "	\033[1;41;37m����:\033[0m #{x[0].gsub(/(?<foo>\b#{@wd[0].gsub(/(?<foo>.)(\W+)/, '(\k<foo>|.s|.es|.{0,2}ed|.{0,2}ing)\b|\b')}\b)/i, "\033[7m\\k<foo>\033[0m").gsub("\033[0m \033[7m", ' ').split(':', 2)[1]}\n"}
      else
        @wd[1].each {|x| eng = x[0].split(']', 2); e = x[1].split('||')[0]
        if eng[0].include?('adv') then declaim '����' elsif eng[0].include?('v') then declaim '����' end
        if eng[0].include?('conj') then declaim '����' elsif eng[0].include?('n') then declaim '����' end
        declaim '���ݴ�' if eng[0].include?('adj')
        declaim '���' if eng[0].include?('prep')
        declaim e
        print "\n \033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{e}\033[0m\n"}
        print "\n\033[s"
        if @exmp[@wd[0]].empty? then print "\033[u ��ʱû�п��û�ɿ�����������. " end
        @exmp[@wd[0]].each_with_index do |x, i|
          print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
          print "\033[1;41;37m����\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
          puts x[0].gsub(/(?<foo>\b#{@wd[0][0..-2]}.*?\b)/i, "\033[7m\\k<foo>\033[0m")
          puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
          puts; print ' ֱ�ӻس��鿴��һ����������; �����������ݲ��س��Խ���: '
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