@echo off
title Last-minute GRE Operating Preparation

REM �򿪵�ǰ�̷���Ŀ¼
cd /d "%~dp0"

REM ��װ����
echo.
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "*�Ⱦ��ɴ���� SC*" >nul 2>nul
if errorlevel 1 (
  echo �� ���ڰ�װ��ɴ�������� ...

  REM ��ȡ����ԱȨ��
  net session >nul 2>nul
  if errorlevel 1 (
    echo �� ��Ҫ��ȡ����ԱȨ�ޣ��밴��������� ...
    pause >nul
    echo �� ���Եȣ����������������� ...
    echo require 'Win32API'; Win32API.new('shell32','ShellExecute','lppppl','l'^^^).call(0,'runas','%~nx0','','',5^^^) | bin\ruby.exe & exit
  )

  <NUL set /p d=�� ���ڸ����ļ� ... 
  CALL REM ���ô������
  copy "sarasa-mono-sc-r.ttf" "%systemroot%\Fonts" /y
  if errorlevel 1 goto err
  <NUL set /p d=�� ����д��ע��� ... 
  CALL REM ���ô������
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "�Ⱦ��ɴ���� SC Regular" /t REG_SZ /d sarasa-mono-sc-r.ttf /f"
  if errorlevel 1 del "%systemroot%\Fonts\sarasa-mono-sc-r.ttf" >nul 2>nul & goto err
  echo �� ��װ����ɹ�.
) else (
  echo �� ϵͳ�Ѱ�װ��ɴ��������, ���� ...
)

REM ���������� [https://stackoverflow.com/questions/12976351/escaping-parentheses-within-parentheses-for-batch-file]
(
echo # encoding: GBK
echo @pwd = Dir.pwd.gsub(/\/$/, ''^^^).gsub('/', '\\'^^^) # ��ǰĿ¼, ȥĩβ/�Ų��滻\��
echo require 'win32ole'
echo @WshShell = WIN32OLE.new('WScript.Shell'^^^)
echo @strDesktop = @WshShell.SpecialFolders('Desktop'^^^) # ����Ŀ¼

echo puts "\n�� ���ڴ��������ݷ�ʽ ..."
echo if File.exist?(@strDesktop + '\DicReader.lnk'^^^) or File.exist?(@strDesktop + '\DicSearcher.lnk'^^^) or File.exist?(@strDesktop + '\WordCount.lnk'^^^)
echo   puts '�� ���������ҵ�������֮ǰ�����Ŀ�ݷ�ʽ, ������.'
echo   system('del "' + @strDesktop + '\DicReader.lnk" "' + @strDesktop + '\DicSearcher.lnk" "' + @strDesktop + '\WordCount.lnk" 2^^^>nul'^^^) # �����STDERR
echo end
echo @oShellLink1 = @WshShell.CreateShortcut(@strDesktop + '\DicReader.lnk'^^^)
echo @oShellLink2 = @WshShell.CreateShortcut(@strDesktop + '\DicSearcher.lnk'^^^)
echo @oShellLink3 = @WshShell.CreateShortcut(@strDesktop + '\WordCount.lnk'^^^)
echo @oShellLink1.TargetPath = @oShellLink2.TargetPath = @oShellLink3.TargetPath = @pwd + "\\bin\\ruby.exe"
echo @oShellLink1.WorkingDirectory = @oShellLink2.WorkingDirectory = @oShellLink3.WorkingDirectory = @pwd + "\\bin"
echo @oShellLink1.Arguments = "DicReader.rb"
echo @oShellLink2.Arguments = "DicSearcher.rb"
echo @oShellLink3.Arguments = "WordCount.rb"
echo @oShellLink1.Description = 'ѧϰ/��ϰ�����ʱ��еĵ���'
echo @oShellLink2.Description = '���Ҹ��ʱ��з���һ�������ĵ���'
echo @oShellLink3.Description = 'ʹ�ü��±�д��ʱ��ʾ������ʱ��'
echo @oShellLink1.Save; @oShellLink2.Save; @oShellLink3.Save

echo # �޸Ŀ�ݷ�ʽ�Ŀ���̨����
echo @f = [open(@strDesktop + '\DicReader.lnk', 'r+b'^^^), open(@strDesktop + '\DicSearcher.lnk', 'r+b'^^^), open(@strDesktop + '\WordCount.lnk', 'r+b'^^^)]
echo for i in [0, 1, 2]
echo   begin
echo     loop do # Ѱ�ұ�ʶ A0 00 00 09 [������Ϣ]
echo       if @f[i].readbyte == 9 then
echo         if @f[i].read(3^^^).bytes == [0, 0, 0xA0] then
echo 	      break
echo         else
echo 	      @f[i].seek(-3, IO::SEEK_CUR^^^) # ������λ��������Ȼ����λ֮ǰ��ʼѰ��
echo 	    end
echo       end
echo     end
echo     @f[i].seek(-8, IO::SEEK_CUR^^^)
echo   rescue EOFError # ���û�ж�����Ϣ��ʶ����ĩβд��
echo     @f[i].seek(-4, IO::SEEK_END^^^)
echo   end
echo   # ����̨����: ���/���ڴ�С; ����λ��; ǰ/����ɫ; ���弰��С �� [https://msdn.microsoft.com/en-us/library/dd891381.aspx]
echo   @f[i].print "\xCC\x00\x00\x00\x02\x00\x00\xA0\xF0\x00\x84\x00d\x00\x88\x13d\x00#{i == 2 ? "\x03" : "#"}\x00#{i == 1 ? "\x84\x03" : "\x00\x00"}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\b\x00\x14\x006\x00\x00\x00\x90\x01\x00\x00I{\xDD\x8D\xF4f\xB1~\xD1\x9ESO \x00S\x00C\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00d\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x002\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x80\x00\x00\x00\x80\x80\x00\x80\x00\x00\x00\x80\x00\x80\x00\x80\x80\x00\x00\xC0\xC0\xC0\x00\x80\x80\x80\x00\x00\x00\xFF\x00\x00\xFF\x00\x00\x00\xFF\xFF\x00\xFF\x00\x00\x00\xFF\x00\xFF\x00\xFF\xFF\x00\x00\xFF\xFF\xFF\x00\f\x00\x00\x00\x04\x00\x00\xA0\xA8\x03\x00\x00\x8E\x00\x00\x00\t\x00\x00\xA0\x82\x00\x00\x001SPS\a\x06W\f\x96\x03\xDEC\x9Da\xE3!\xD7\xDFP&\x11\x00\x00\x00\x03\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x01\x00\x00\x00\x00\v\x00\x00\x00\xFF\xFF\x00\x00\x11\x00\x00\x00\x02\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x04\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x11\x00\x00\x00\x06\x00\x00\x00\x00\x02\x00\x00\x00\xFF\x00\x00\x00\x11\x00\x00\x00\x05\x00\x00\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
echo   @f[i].close
echo end
echo puts '�� �����洴����ݷ�ʽ�ɹ�.'
echo puts "\n�� �ѽ���."
) | bin\ruby.exe
goto finalize

:err
echo �� ��װ����ʧ��, ���Թ���ԱȨ������.
:finalize
echo.
pause