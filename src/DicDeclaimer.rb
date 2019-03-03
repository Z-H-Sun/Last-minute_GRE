# encoding: GBK
require 'win32ole'
require 'Win32API'

@voice = WIN32OLE.new('SAPI.SpVoice')
@keybd = Win32API.new('user32', 'keybd_event', 'llll', 'l')
@wait = Win32API.new('user32', 'LoadCursor', 'll', 'l').call(0, 32514) # "�ȴ�"���
@cursor = Win32API.new('user32', 'SetSystemCursor', 'll', 'l')

$use_voice = true

def declaim(str, flag = 1) # SVSFlagsAsync(1), SVSFPurgeBeforeSpeak(2)
  return unless $use_voice
  @voice.Speak(str, flag.zero? ? 1 : flag) # �ظ�SVSDefault�Ĺ���
  
  if flag == 0 # ��ֹ�ʶ�ʱ�ļ�������, ���߻س�����
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