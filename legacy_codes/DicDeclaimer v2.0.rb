# encoding: GBK
require 'win32ole'
#require 'Win32API'

@voice = WIN32OLE.new('SAPI.SpVoice')
#@keybd = Win32API.new('user32', 'keybd_event', 'llll', 'l')

$use_voice = true

# Legacy Method
=begin
`start /B mshta VBScript:CreateObject("SAPI.SpVoice").Speak("Good luck")(Window.Close)`

 @block = Win32API.new('user32', 'BlockInput', 'i', 'l')
 @block.call(1) if flag == 0
=end

def declaim(str, flag = 1) # SVSFlagsAsync(1), SVSFPurgeBeforeSpeak(2)
  return unless $use_voice
  @voice.speak(str, flag)
=begin
  if flag == 0 # 阻止朗读时的键盘输入
    th = Thread.new{`pause`}; sleep(0.05)
    @keybd.call(0x0D, 0, 0, 0); @keybd.call(0x0D, 0, 2, 0)
    th.join
  end
=end
end


