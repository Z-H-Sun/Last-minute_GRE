@echo off

REM �򿪵�ǰ�̷���Ŀ¼
%~d0
cd "%~dp0"

REM ����������
bin\ruby.exe Install.rb

set/p X=����ɾ����װ�ļ� , �� Y ȷ�ϣ�������˳�: 
if /i "%X%"=="Y" del *.* /q & pause