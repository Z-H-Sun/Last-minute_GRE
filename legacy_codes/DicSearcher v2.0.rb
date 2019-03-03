# encoding: GBK
#`mode con cols=100`
system('color F0'); @hash = {}; @list = []; @exmp = {}
`title GRE ��ŵ��ʲ��� by Z. S.`

for n in '01'..'26'
  f = open("Dic_#{n}\\Dic_#{n}_999.txt")
  eval("@list.push(#{f.read})"); f.close

  @list[-1].each_with_index {|x, i| @hash[x[0]] = [n, i]; x[1].each{|y| if @hash.has_key?(y[1]) then if @hash[y[1]] != [n, i] then y[1] += "||#{n}#{i}" end end; @hash[y[1]] = [n,i]}}
  unless n == '26'
    f = open("Dic_#{n}\\Dic_#{n}_Exmp.txt")
    eval("@exmp.merge!(#{f.read})")
    f.close
  end
end
loop do
  print "\n ������Ҫ���ҵĵ���/�������������, �����г����� \033[1;4;7;44;37m����\033[0m �������ݵĽ�� (֧��������ʽ): \033[s"
  print "\n\n ����: \033[7mCret\033[0m ��ƥ�� \033[7mconcrete\033[0m; \033[7m^bi.ho\033[0m ��ƥ�� \033[7mbishop\033[0m; \033[7mno.*aL$\033[0m ��ƥ�� \033[7mnominal\033[0m; \033[7m����\033[0m ��ƥ�� \033[7manachronism\033[0m.\033[u"
  c = gets.chomp
  sleep(0.05); print "\033[J"; sleep(0.05)
  @result = c.empty? ? [] : @hash.keys.find_all {|x| x.match(c.downcase)}; puts

  if @result.empty?
    print "\n δ�ҵ�ָ��������, "; system('pause'); system('cls')
    next
  elsif @result.size > 1
    puts "\n ���ҵ� #{@result.size} ����¼: \n"
    @result.each_with_index {|x, i| print "\n \033[1;4;7;41;37m[#{i + 1}]\033[0m " + x.split('||')[0]; puts "	\033[1;7;44;37mWord List #{@hash[x][0]}, # #{@hash[x][1] + 1}\033[0m"}

    @ln = 0; print "\n\033[s"
  else
    @ln = 1
  end

  @input = []
  while @input.size < @result.size
    if @result.size != 1
      while @ln.zero? or @ln > @result.size or @input.include?(@ln)
        print "\033[u"; sleep(0.05); print "\033[K"; print "\033[s ��ѡ����Ҫ��ʾ�ĵ���/��������Ӧ�ı��, ��ֱ�ӻس��Խ���: "
        @ln = gets.chomp
        @ln = @ln.empty? ? -1 : @ln.to_i
      end
      if @ln == -1 then break end
      @input.push(@ln)
    end

    lin, wdn = @hash[@result[@ln - 1]]; lin = lin.to_i - 1; @wd = @list[lin][wdn]
    print "\n ----------------------------------------------------------------------------------------\n\n"
    puts " \033[1;7;44;37m* #{@wd[0][0].upcase + @wd[0][1..-1]}\033[0m	\033[1;7;41;37mWord List %02d, # #{wdn + 1}\033[0m" % (lin + 1)

    if lin == 25
      @wd[1].each {|x| print "\n "; print "\033[1;4;7;40;37m#{x[1].split('||')[0]}\033[0m	\033[1;41;37m����:\033[0m #{x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m").split(':', 2)[1]}\n"}
      puts; puts
    else
      @wd[1].each {|x| print "\n "; eng = x[0].split(']', 2); print "\033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;7;40;37m#{x[1].split('||')[0]}\033[0m\n"}
      print "\n\033[s"
      if @exmp[@wd[0]].empty? then print "\033[u ��ʱû�п��û�ɿ�����������. " end
      @exmp[@wd[0]].each_with_index do |x, i|
        print "\033[u "; sleep(0.05); print "\033[J"; sleep(0.05)
        print "\033[1;41;37m����\033[0m	\033[1;4;7;44;37m#{i + 1})\033[0m "
        puts x[0].gsub(@wd[0], "\033[7m#{@wd[0]}\033[0m")
        puts; print '	'; print x[1]; print '	'; puts "\033[1;7;47;37m#{x[2]}\033[0m"
        puts; print ' ֱ�ӻس��鿴��һ����������; �����������ݲ��س��Խ���: '
        break unless gets == "\n"
      end
    end
    print ' '; system('pause')
    break if @result.size == 1
    print "\n ----------------------------------------------------------------------------------------\n\n\033[s"
  end
  system('cls')
end