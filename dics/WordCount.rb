# encoding: GBK
require 'Win32API'
Win32API.new('user32', 'SetWindowPos', 'lllllll', 'l').call(Win32API.new('kernel32', 'GetConsoleWindow', 'l', 'l').call(0), -1, 0, 0, 0, 0, 3) # 窗体置于顶层
SdMsg =  Win32API.new('user32', 'SendMessage', 'LLLP', 'I')
hWnd = 0

loop do
  begin
    raise(Interrupt) if Win32API.new('user32', 'IsWindow', 'l', 'l').call(hWnd).zero? # 窗口已不存在则终止
    len = SdMsg.call(hWnd, 0xE, 0, '') # 文本长度
    buf = "\0" * len
    SdMsg.call(hWnd, 0xD, len + 1, buf) # 文本内容
    strs = buf.split
    strs.delete_if {|s| s.match(/[a-zA-Z]/).nil?} # 只匹配含英文字母的（不算数字）、由空格隔开的小片段
	
	ts = (Time.now - @timest).round # 耗时
	print "\007\033[1;7;47;37m" if ts == 1800 # 超时警告
	
	print "\r Word Count: "
    print '%03d' % strs.size
    print ' ('; parawds = []
    paras = buf.split("\r\n")
    paras.each {|p| c = p.split; c.delete_if {|s| s.match(/[a-zA-Z]/).nil?}; parawds.push('%03d' % c.size) if c != []} # 每个段落内数词数
    print parawds.join('; ')
    print ')          Time: '
	print '%02d : %02d' % [ts / 60, ts % 60]
	print '                    '; sleep 1
  rescue Interrupt
    system('cls'); puts
    print "\033[0m\r Press any key to start ..."; `pause`
    system('start notepad'); sleep(0.5)
    hWnd = Win32API.new('user32', 'GetForegroundWindow', '', 'l').call() # 当前窗口
    hWnd = Win32API.new('user32', 'FindWindowEx', 'llpp', 'l').call(hWnd, 0, "Edit\0", "\0") # 寻找输入框子窗口
    @timest = Time.now
  end
end