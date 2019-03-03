# encoding: GBK
require 'win32ole'
require 'Win32API'

@voice = WIN32OLE.new('SAPI.SpVoice')
@keybd = Win32API.new('user32', 'keybd_event', 'llll', 'l')
@wait = Win32API.new('user32', 'LoadCursor', 'll', 'l').call(0, 32514) # "等待"光标
@cursor = Win32API.new('user32', 'SetSystemCursor', 'll', 'l')

$use_voice = true

def declaim(str, flag = 1) # SVSFlagsAsync(1), SVSFPurgeBeforeSpeak(2)
  return unless $use_voice
  @voice.Speak(str, flag.zero? ? 1 : flag) # 重改SVSDefault的过程
  
  if flag == 0 # 阻止朗读时的键盘输入, 或者回车跳过
    @cursor.call(@wait, 32512) # 更改光标
    @th1 = Thread.new {`pause`; @th2.exit} # pause之前阻止键盘输入
	@th2 = Thread.new do # pause过程中可回车跳过
      while @voice.Status.RunningState != 1; end # SpeechRunState.SRSEDone
      @keybd.call(0x0D, 0, 0, 0); @keybd.call(0x0D, 0, 2, 0) # 朗读结束模拟键盘回车以继续
    end
    @th2.join # 等待线程2
	@cursor.call(@wait, 32512) # 回复光标
    @th1.join # 一定要加这一句, 防止线程1还未退出
  end
end