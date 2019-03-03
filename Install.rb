# encoding: GBK
`title Last-minute GRE Operating Preparation`
@pwd = Dir.pwd.gsub(/\/$/, '').gsub('/', '\\') # ��ǰĿ¼, ȥĩβ/�Ų��滻\��
require 'win32ole'
@WshShell = WIN32OLE.new('WScript.Shell')
@strDesktop = @WshShell.SpecialFolders('Desktop') # ����Ŀ¼
@strFonts = @WshShell.SpecialFolders('Fonts') # ����Ŀ¼

puts
if `reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts\" /v \"*�Ⱦ��ɴ���� SC*`.include?('0') # ����δƥ�䵽������
  puts ' �� ���ڰ�װ��ɴ�������� ...'
  print ' �� ���ڸ����ļ� ... '
  system("copy sarasa-mono-sc-r.ttf #{@strFonts}\\sarasa-mono-sc-r.ttf /y") # ֱ�Ӹ���
  print ' �� ����д��ע��� ... '
  result = system("reg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts\" /v \"�Ⱦ��ɴ���� SC Regular\" /t REG_SZ /d sarasa-mono-sc-r.ttf /f")
  if result
    puts ' �� ��װ����ɹ�.'
  else # �޷�д��
    puts ' �� ��װ����ʧ��, ���Թ���ԱȨ������. '
	`del \"#{@strFonts}\\sarasa-mono-sc-r.ttf\"` # ʧ��ʱ�ع�
  end
else
  puts ' �� ϵͳ�Ѱ�װ��ɴ��������, ���� ...'
end

puts "\n �� ���ڴ��������ݷ�ʽ ..."

if File.exist?(@strDesktop + '\DicReader.lnk') or File.exist?(@strDesktop + '\DicSearcher.lnk') or File.exist?(@strDesktop + '\WordCount.lnk')
  puts ' �� ���������ҵ�������֮ǰ�����Ŀ�ݷ�ʽ, �밴�������ȷ�ϸ���.'
  `pause`
  system("del \"#{@strDesktop}\\DicReader.lnk\" \"#{@strDesktop}\\DicSearcher.lnk\" \"#{@strDesktop}\\WordCount.lnk\" 2>nul") # �����STDERR
end
@oShellLink1 = @WshShell.CreateShortcut(@strDesktop + '\DicReader.lnk')
@oShellLink2 = @WshShell.CreateShortcut(@strDesktop + '\DicSearcher.lnk')
@oShellLink3 = @WshShell.CreateShortcut(@strDesktop + '\WordCount.lnk')
@oShellLink1.TargetPath = @oShellLink2.TargetPath = @oShellLink3.TargetPath = @pwd + "\\bin\\ruby.exe"
@oShellLink1.WorkingDirectory = @oShellLink2.WorkingDirectory = @oShellLink3.WorkingDirectory = @pwd + "\\dics"
@oShellLink1.Arguments = "..\\src\\DicReader.rb"
@oShellLink2.Arguments = "..\\src\\DicSearcher.rb"
@oShellLink3.Arguments = "..\\src\\WordCount.rb"
@oShellLink1.Description = 'ѧϰ/��ϰ�����ʱ��еĵ���'
@oShellLink2.Description = '���Ҹ��ʱ��з���һ�������ĵ���'
@oShellLink3.Description = 'ʹ�ü��±�д��ʱ��ʾ������ʱ��'
@oShellLink1.Save; @oShellLink2.Save; @oShellLink3.Save

# �޸Ŀ�ݷ�ʽ�Ŀ���̨����
@f = [open(@strDesktop + '\DicReader.lnk', 'r+b'), open(@strDesktop + '\DicSearcher.lnk', 'r+b'), open(@strDesktop + '\WordCount.lnk', 'r+b')]
for i in [0, 1, 2]
  begin
    loop do # Ѱ�ұ�ʶ A0 00 00 09 (������Ϣ)
      if @f[i].readbyte == 9 then
        if @f[i].read(3).bytes == [0, 0, 0xA0] then
	      break
        else
	      @f[i].seek(-3, IO::SEEK_CUR) # ������λ��������Ȼ����λ֮ǰ��ʼѰ��
	    end
      end
    end
    @f[i].seek(-8, IO::SEEK_CUR)
  rescue EOFError # ���û�ж�����Ϣ��ʶ����ĩβд��
    @f[i].seek(-4, IO::SEEK_END)
  end
  # ����̨����: ���/���ڴ�С; ����λ��; ǰ/����ɫ; ���弰��С ��
  # https://msdn.microsoft.com/en-us/library/dd891381.aspx
  @f[i].print "\xCC\x00\x00\x00\x02\x00\x00\xA0\xF0\x00\x84\x00d\x00\x88\x13d\x00#{i == 2 ? "\x03" : "#"}\x00#{i == 1 ? "\x84\x03" : "\x00\x00"}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\b\x00\x14\x006\x00\x00\x00\x90\x01\x00\x00I{\xDD\x8D\xF4f\xB1~\xD1\x9ESO \x00S\x00C\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00d\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x002\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x80\x00\x00\x00\x80\x80\x00\x80\x00\x00\x00\x80\x00\x80\x00\x80\x80\x00\x00\xC0\xC0\xC0\x00\x80\x80\x80\x00\x00\x00\xFF\x00\x00\xFF\x00\x00\x00\xFF\xFF\x00\xFF\x00\x00\x00\xFF\x00\xFF\x00\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\f\x00\x00\x00\x04\x00\x00\xA0\xA8\x03\x00\x00\x8E\x00\x00\x00\t\x00\x00\xA0\x82\x00\x00\x001SPS\a\x06W\f\x96\x03\xDEC\x9Da\xE3!\xD7\xDFP&\x11\x00\x00\x00\x03\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x01\x00\x00\x00\x00\v\x00\x00\x00\xFF\xFF\x00\x00\x11\x00\x00\x00\x02\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x04\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x06\x00\x00\x00\x00\x02\x00\x00\x00\xFF\x00\x00\x00\x11\x00\x00\x00\x05\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  @f[i].close
end
puts ' �� �����洴����ݷ�ʽ�ɹ�.'
print " �� �ѽ���.\n\n "