require 'win32ole'
@voice = WIN32OLE.new('SAPI.SpVoice')

$USE_VOICE = false # true
alias print_old print
alias puts_old puts

# Legacy Method
=begin
`start /B mshta VBScript:CreateObject("SAPI.SpVoice").Speak("Good luck")(Window.Close)`
=end

def print(obj, *smth)
  print_old(obj, *smth)
  @voice.speak(obj.gsub(/\033\[.*?[a-zA-Z]/,''), 3) if $USE_VOICE # SVSFlagsAsync & SVSFPurgeBeforeSpeak
end

def puts(obj='', *arg)
  puts_old(obj, *arg)
  @voice.speak(obj.gsub(/\033\[.*?[a-zA-Z]/,''), 3) if $USE_VOICE # SVSFlagsAsync & SVSFPurgeBeforeSpeak
end