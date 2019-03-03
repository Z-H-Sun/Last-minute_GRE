# encoding: GBK
require 'Win32API'
Win32API.new('user32', 'SetWindowPos', 'lllllll', 'l').call(Win32API.new('kernel32', 'GetConsoleWindow', 'l', 'l').call(0), -1, 0, 0, 0, 0, 3) # �������ڶ���
SdMsg =  Win32API.new('user32', 'SendMessage', 'LLLP', 'I')
hWnd = 0

loop do
  begin
    raise(Interrupt) if Win32API.new('user32', 'IsWindow', 'l', 'l').call(hWnd).zero? # �����Ѳ���������ֹ
    len = SdMsg.call(hWnd, 0xE, 0, '') # �ı�����
    buf = "\0" * len
    SdMsg.call(hWnd, 0xD, len + 1, buf) # �ı�����
    strs = buf.split
    strs.delete_if {|s| s.match(/[a-zA-Z]/).nil?} # ֻƥ�京Ӣ����ĸ�ģ��������֣����ɿո������СƬ��
	
	ts = (Time.now - @timest).round # ��ʱ
	print "\007\033[1;7;47;37m" if ts == 1800 # ��ʱ����
	
	print "\r Word Count: "
    print '%03d' % strs.size
    print ' ('; parawds = []
    paras = buf.split("\r\n")
    paras.each {|p| c = p.split; c.delete_if {|s| s.match(/[a-zA-Z]/).nil?}; parawds.push('%03d' % c.size) if c != []} # ÿ��������������
    print parawds.join('; ')
    print ')          Time: '
	print '%02d : %02d' % [ts / 60, ts % 60]
	print '                    '; sleep 1
  rescue Interrupt
    system('cls'); puts
    print "\033[0m\r Press any key to start ..."; `pause`
    system('start notepad'); sleep(0.5)
    hWnd = Win32API.new('user32', 'GetForegroundWindow', '', 'l').call() # ��ǰ����
    hWnd = Win32API.new('user32', 'FindWindowEx', 'llpp', 'l').call(hWnd, 0, "Edit\0", "\0") # Ѱ��������Ӵ���
    @timest = Time.now
  end
end