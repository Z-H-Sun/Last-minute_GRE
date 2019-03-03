@echo off

REM 打开当前盘符及目录
%~d0
cd "%~dp0"

REM 运行主程序
bin\ruby.exe Install.rb

set/p X=可以删除安装文件 , 按 Y 确认，任意键退出: 
if /i "%X%"=="Y" del *.* /q & pause