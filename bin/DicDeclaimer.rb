# encoding: GBK
require 'win32ole'
require 'Win32API'

# Win10秋季创意者更新后, ruby的STDIN.gets对中文字符处理有问题, 故此处使用cmd的方法.
# 另外, ruby的gets不支持F7查看历史记录 (准确的说是按ESC或右键后才可以), 而cmd的方法则可.
# /V标志意为EnableDelayedExpansion
def getinput(choice = '')
  return `cmd /V /C \"set /p var=&& echo !var!\"`.chomp if choice.empty?
  decision = `choice /C #{choice} /N`.chomp.downcase; puts
  return decision
end

def getnumber
  n = `choice /C 0123456789as /N`.chomp.downcase
  return 0 if n == 'a' or n == 's'
  print n
  loop do
    l = `choice /C 0123456789as\xa0 /N /D \xa0 /T 1`.chomp.downcase
    case l
    when '\xa0', '?' # 不输入A/S, 默认情况下不改变 $use_voice
    when 'a'
        $use_voice = false
    when 's'
        $use_voice = true
    else
        n += l; print l; next
    end
    puts; return n.to_i    
  end
end

@voice = WIN32OLE.new('SAPI.SpVoice')
@keybd = Win32API.new('user32', 'keybd_event', 'llll', 'l')
@wait = Win32API.new('user32', 'LoadCursor', 'll', 'l').call(0, 32514) # "等待"光标
@cursor = Win32API.new('user32', 'SetSystemCursor', 'll', 'l')

$use_voice = true
@voices = [nil, nil]
for i in @voice.GetVoices
  des = i.GetDescription.downcase
  if des.include?('chinese') then # 中文讲述人
    @voices[0] = i
  elsif des.include?('english') then # 英文讲述人
    @voices[1] = i
  end
end
@voices[1] = @voices[0] if @voices[1].nil? # 没有英语讲述人就用中文的凑合

def declaim(str, flag = 1, lang = 0) # flag: SVSFlagsAsync(1), SVSFPurgeBeforeSpeak(2); lang: Chinese(0), English(1)
  return unless $use_voice
  return if @voices[lang].nil? # 没有对应语言的讲述人功能
  @voice.Voice = @voices[lang]
  @voice.Speak(str, flag.zero? ? 1 : flag) # 重改SVSDefault的过程
  
  if flag.zero? # 阻止朗读时的键盘输入, 或者回车跳过
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
