@echo off
title Last-minute GRE Operating Preparation

REM 打开当前盘符及目录
cd /d "%~dp0"

REM 安装字体
echo.
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "*等距更纱黑体 SC*" >nul 2>nul
if errorlevel 1 (
  echo ━ 正在安装更纱黑体字体 ...

  REM 获取管理员权限
  net session >nul 2>nul
  if errorlevel 1 (
    echo ┕ 需要获取管理员权限，请按任意键继续 ...
    pause >nul
    echo ┕ 请稍等，正在重新启动程序 ...
    echo require 'Win32API'; Win32API.new('shell32','ShellExecute','lppppl','l'^^^).call(0,'runas','%~nx0','','',5^^^) | bin\ruby.exe & exit
  )

  <NUL set /p d=┕ 正在复制文件 ... 
  CALL REM 重置错误代码
  copy "sarasa-mono-sc-r.ttf" "%systemroot%\Fonts" /y
  if errorlevel 1 goto err
  <NUL set /p d=┕ 正在写入注册表 ... 
  CALL REM 重置错误代码
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "等距更纱黑体 SC Regular" /t REG_SZ /d sarasa-mono-sc-r.ttf /f"
  if errorlevel 1 del "%systemroot%\Fonts\sarasa-mono-sc-r.ttf" >nul 2>nul & goto err
  echo ┕ 安装字体成功.
) else (
  echo ━ 系统已安装更纱黑体字体, 跳过 ...
)

REM 运行主程序 [https://stackoverflow.com/questions/12976351/escaping-parentheses-within-parentheses-for-batch-file]
(
echo # encoding: GBK
echo @pwd = Dir.pwd.gsub(/\/$/, ''^^^).gsub('/', '\\'^^^) # 当前目录, 去末尾/号并替换\号
echo require 'win32ole'
echo @WshShell = WIN32OLE.new('WScript.Shell'^^^)
echo @strDesktop = @WshShell.SpecialFolders('Desktop'^^^) # 桌面目录

echo puts "\n━ 正在创建桌面快捷方式 ..."
echo if File.exist?(@strDesktop + '\DicReader.lnk'^^^) or File.exist?(@strDesktop + '\DicSearcher.lnk'^^^) or File.exist?(@strDesktop + '\WordCount.lnk'^^^)
echo   puts '┕ 在桌面上找到可能是之前创立的快捷方式, 将覆盖.'
echo   system('del "' + @strDesktop + '\DicReader.lnk" "' + @strDesktop + '\DicSearcher.lnk" "' + @strDesktop + '\WordCount.lnk" 2^^^>nul'^^^) # 不输出STDERR
echo end
echo @oShellLink1 = @WshShell.CreateShortcut(@strDesktop + '\DicReader.lnk'^^^)
echo @oShellLink2 = @WshShell.CreateShortcut(@strDesktop + '\DicSearcher.lnk'^^^)
echo @oShellLink3 = @WshShell.CreateShortcut(@strDesktop + '\WordCount.lnk'^^^)
echo @oShellLink1.TargetPath = @oShellLink2.TargetPath = @oShellLink3.TargetPath = @pwd + "\\bin\\ruby.exe"
echo @oShellLink1.WorkingDirectory = @oShellLink2.WorkingDirectory = @oShellLink3.WorkingDirectory = @pwd + "\\bin"
echo @oShellLink1.Arguments = "DicReader.rb"
echo @oShellLink2.Arguments = "DicSearcher.rb"
echo @oShellLink3.Arguments = "WordCount.rb"
echo @oShellLink1.Description = '学习/复习各个词表中的单词'
echo @oShellLink2.Description = '查找各词表中符合一定条件的单词'
echo @oShellLink3.Description = '使用记事本写作时显示词数及时间'
echo @oShellLink1.Save; @oShellLink2.Save; @oShellLink3.Save

echo # 修改快捷方式的控制台属性
echo @f = [open(@strDesktop + '\DicReader.lnk', 'r+b'^^^), open(@strDesktop + '\DicSearcher.lnk', 'r+b'^^^), open(@strDesktop + '\WordCount.lnk', 'r+b'^^^)]
echo for i in [0, 1, 2]
echo   begin
echo     loop do # 寻找标识 A0 00 00 09 [额外信息]
echo       if @f[i].readbyte == 9 then
echo         if @f[i].read(3^^^).bytes == [0, 0, 0xA0] then
echo 	      break
echo         else
echo 	      @f[i].seek(-3, IO::SEEK_CUR^^^) # 若后三位不符合仍然从三位之前开始寻找
echo 	    end
echo       end
echo     end
echo     @f[i].seek(-8, IO::SEEK_CUR^^^)
echo   rescue EOFError # 如果没有额外信息标识则在末尾写入
echo     @f[i].seek(-4, IO::SEEK_END^^^)
echo   end
echo   # 控制台属性: 光标/窗口大小; 窗口位置; 前/背景色; 字体及大小 等 [https://msdn.microsoft.com/en-us/library/dd891381.aspx]
echo   @f[i].print "\xCC\x00\x00\x00\x02\x00\x00\xA0\xF0\x00\x84\x00d\x00\x88\x13d\x00#{i == 2 ? "\x03" : "#"}\x00#{i == 1 ? "\x84\x03" : "\x00\x00"}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\b\x00\x14\x006\x00\x00\x00\x90\x01\x00\x00I{\xDD\x8D\xF4f\xB1~\xD1\x9ESO \x00S\x00C\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00d\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x002\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x80\x00\x00\x00\x80\x80\x00\x80\x00\x00\x00\x80\x00\x80\x00\x80\x80\x00\x00\xC0\xC0\xC0\x00\x80\x80\x80\x00\x00\x00\xFF\x00\x00\xFF\x00\x00\x00\xFF\xFF\x00\xFF\x00\x00\x00\xFF\x00\xFF\x00\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\f\x00\x00\x00\x04\x00\x00\xA0\xA8\x03\x00\x00\x8E\x00\x00\x00\t\x00\x00\xA0\x82\x00\x00\x001SPS\a\x06W\f\x96\x03\xDEC\x9Da\xE3!\xD7\xDFP&\x11\x00\x00\x00\x03\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x01\x00\x00\x00\x00\v\x00\x00\x00\xFF\xFF\x00\x00\x11\x00\x00\x00\x02\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x04\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x06\x00\x00\x00\x00\x02\x00\x00\x00\xFF\x00\x00\x00\x11\x00\x00\x00\x05\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
echo   @f[i].close
echo end
echo puts '┕ 在桌面创建快捷方式成功.'
echo puts "\n━ 已结束."
) | bin\ruby.exe
goto finalize

:err
echo ┕ 安装字体失败, 请以管理员权限运行.
:finalize
echo.
pause