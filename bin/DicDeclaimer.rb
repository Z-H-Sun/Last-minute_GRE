# encoding: GBK
require 'win32ole'
require 'Win32API'

# Win10�＾�����߸��º�, ruby��STDIN.gets�������ַ�����������, �ʴ˴�ʹ��cmd�ķ���.
# ����, ruby��gets��֧��F7�鿴��ʷ��¼ (׼ȷ��˵�ǰ�ESC���Ҽ���ſ���), ��cmd�ķ������.
# /V��־��ΪEnableDelayedExpansion
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
    when '\xa0', '?' # ������A/S, Ĭ������²��ı� $use_voice
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
@wait = Win32API.new('user32', 'LoadCursor', 'll', 'l').call(0, 32514) # "�ȴ�"���
@cursor = Win32API.new('user32', 'SetSystemCursor', 'll', 'l')

$use_voice = true
@voices = [nil, nil]
for i in @voice.GetVoices
  des = i.GetDescription.downcase
  if des.include?('chinese') then # ���Ľ�����
    @voices[0] = i
  elsif des.include?('english') then # Ӣ�Ľ�����
    @voices[1] = i
  end
end
@voices[1] = @voices[0] if @voices[1].nil? # û��Ӣ�ｲ���˾������ĵĴպ�

def declaim(str, flag = 1, lang = 0) # flag: SVSFlagsAsync(1), SVSFPurgeBeforeSpeak(2); lang: Chinese(0), English(1)
  return unless $use_voice
  return if @voices[lang].nil? # û�ж�Ӧ���ԵĽ����˹���
  @voice.Voice = @voices[lang]
  @voice.Speak(str, flag.zero? ? 1 : flag) # �ظ�SVSDefault�Ĺ���
  
  if flag.zero? # ��ֹ�ʶ�ʱ�ļ�������, ���߻س�����
    @cursor.call(@wait, 32512) # ���Ĺ��
    @th1 = Thread.new {`pause`; @th2.exit} # pause֮ǰ��ֹ��������
	@th2 = Thread.new do # pause�����пɻس�����
      while @voice.Status.RunningState != 1; end # SpeechRunState.SRSEDone
      @keybd.call(0x0D, 0, 0, 0); @keybd.call(0x0D, 0, 2, 0) # �ʶ�����ģ����̻س��Լ���
    end
    @th2.join # �ȴ��߳�2
    @cursor.call(@wait, 32512) # �ظ����
    @th1.join # һ��Ҫ����һ��, ��ֹ�߳�1��δ�˳�
  end
end
