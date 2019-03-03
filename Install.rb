# encoding: GBK
`title Last-minute GRE Operating Preparation`
@pwd = Dir.pwd.gsub(/\/$/, '').gsub('/', '\\') # 当前目录, 去末尾/号并替换\号
require 'win32ole'
@WshShell = WIN32OLE.new('WScript.Shell')
@strDesktop = @WshShell.SpecialFolders('Desktop') # 桌面目录
@strFonts = @WshShell.SpecialFolders('Fonts') # 字体目录

puts
if `reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts\" /v \"*等距更纱黑体 SC*`.include?('0') # 字体未匹配到给定项
  puts ' ━ 正在安装更纱黑体字体 ...'
  print ' ┕ 正在复制文件 ... '
  system("copy sarasa-mono-sc-r.ttf #{@strFonts}\\sarasa-mono-sc-r.ttf /y") # 直接覆盖
  print ' ┕ 正在写入注册表 ... '
  result = system("reg add \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts\" /v \"等距更纱黑体 SC Regular\" /t REG_SZ /d sarasa-mono-sc-r.ttf /f")
  if result
    puts ' ┕ 安装字体成功.'
  else # 无法写入
    puts ' ┕ 安装字体失败, 请以管理员权限运行. '
	`del \"#{@strFonts}\\sarasa-mono-sc-r.ttf\"` # 失败时回滚
  end
else
  puts ' ━ 系统已安装更纱黑体字体, 跳过 ...'
end

puts "\n ━ 正在创建桌面快捷方式 ..."

if File.exist?(@strDesktop + '\DicReader.lnk') or File.exist?(@strDesktop + '\DicSearcher.lnk') or File.exist?(@strDesktop + '\WordCount.lnk')
  puts ' ┕ 在桌面上找到可能是之前创立的快捷方式, 请按任意键以确认覆盖.'
  `pause`
  system("del \"#{@strDesktop}\\DicReader.lnk\" \"#{@strDesktop}\\DicSearcher.lnk\" \"#{@strDesktop}\\WordCount.lnk\" 2>nul") # 不输出STDERR
end
@oShellLink1 = @WshShell.CreateShortcut(@strDesktop + '\DicReader.lnk')
@oShellLink2 = @WshShell.CreateShortcut(@strDesktop + '\DicSearcher.lnk')
@oShellLink3 = @WshShell.CreateShortcut(@strDesktop + '\WordCount.lnk')
@oShellLink1.TargetPath = @oShellLink2.TargetPath = @oShellLink3.TargetPath = @pwd + "\\bin\\ruby.exe"
@oShellLink1.WorkingDirectory = @oShellLink2.WorkingDirectory = @oShellLink3.WorkingDirectory = @pwd + "\\dics"
@oShellLink1.Arguments = "..\\src\\DicReader.rb"
@oShellLink2.Arguments = "..\\src\\DicSearcher.rb"
@oShellLink3.Arguments = "..\\src\\WordCount.rb"
@oShellLink1.Description = '学习/复习各个词表中的单词'
@oShellLink2.Description = '查找各词表中符合一定条件的单词'
@oShellLink3.Description = '使用记事本写作时显示词数及时间'
@oShellLink1.Save; @oShellLink2.Save; @oShellLink3.Save

# 修改快捷方式的控制台属性
@f = [open(@strDesktop + '\DicReader.lnk', 'r+b'), open(@strDesktop + '\DicSearcher.lnk', 'r+b'), open(@strDesktop + '\WordCount.lnk', 'r+b')]
for i in [0, 1, 2]
  begin
    loop do # 寻找标识 A0 00 00 09 (额外信息)
      if @f[i].readbyte == 9 then
        if @f[i].read(3).bytes == [0, 0, 0xA0] then
	      break
        else
	      @f[i].seek(-3, IO::SEEK_CUR) # 若后三位不符合仍然从三位之前开始寻找
	    end
      end
    end
    @f[i].seek(-8, IO::SEEK_CUR)
  rescue EOFError # 如果没有额外信息标识则在末尾写入
    @f[i].seek(-4, IO::SEEK_END)
  end
  # 控制台属性: 光标/窗口大小; 窗口位置; 前/背景色; 字体及大小 等
  # https://msdn.microsoft.com/en-us/library/dd891381.aspx
  @f[i].print "\xCC\x00\x00\x00\x02\x00\x00\xA0\xF0\x00\x84\x00d\x00\x88\x13d\x00#{i == 2 ? "\x03" : "#"}\x00#{i == 1 ? "\x84\x03" : "\x00\x00"}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\b\x00\x14\x006\x00\x00\x00\x90\x01\x00\x00I{\xDD\x8D\xF4f\xB1~\xD1\x9ESO \x00S\x00C\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00d\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x002\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x80\x00\x00\x00\x80\x80\x00\x80\x00\x00\x00\x80\x00\x80\x00\x80\x80\x00\x00\xC0\xC0\xC0\x00\x80\x80\x80\x00\x00\x00\xFF\x00\x00\xFF\x00\x00\x00\xFF\xFF\x00\xFF\x00\x00\x00\xFF\x00\xFF\x00\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\f\x00\x00\x00\x04\x00\x00\xA0\xA8\x03\x00\x00\x8E\x00\x00\x00\t\x00\x00\xA0\x82\x00\x00\x001SPS\a\x06W\f\x96\x03\xDEC\x9Da\xE3!\xD7\xDFP&\x11\x00\x00\x00\x03\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x01\x00\x00\x00\x00\v\x00\x00\x00\xFF\xFF\x00\x00\x11\x00\x00\x00\x02\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x04\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x06\x00\x00\x00\x00\x02\x00\x00\x00\xFF\x00\x00\x00\x11\x00\x00\x00\x05\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  @f[i].close
end
puts ' ┕ 在桌面创建快捷方式成功.'
print " ━ 已结束.\n\n "