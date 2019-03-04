# Last-minute_GRE 简介
Last-minute_GRE 是一个使用 Ruby 语言编写的、用于 GRE Verbal 及 Analytical Writing 考试准备的开源控制台程序。

## 总述
DicReader、DicSearcher、WordCount 是三个使用 Ruby 2.2 语言编写的开源控制台程序。本仓库内的程序运行平台为 Win 10 x64，且需要新版控制台支持（至少 Win10 2016 TH2 更新，开始支持 ANSI escape code），否则可能会出现显示不正确的问题。

*适用于 Mac OS X 平台运行的相应程序正在改写和调试中。*

## 声明
本程序词表来源为《新东方 2017 佛脚词汇表单词》，仅供学习交流之用，切勿用于商业用途。*此外，由于在字符串分割、处理的过程中，无法避免一些意料之外的因素，本程序所显示的内容可能会存在极少量的错误（已知的有：某些单词英文释义不完整、识别单词遗漏）*。虽然**不影响正常使用**，但并**不能**完全用于替代《佛脚词汇表》，建议对照查看。

## 安装
其实并不能称为安装，**因为不会写入软件列表**。运行 Install.bat，程序会自动安装字体（等距更纱黑体 sarasa-mono-sc-r.ttf，用于提升 Windows 控制台用户界面的美观性和易读性），并在桌面上创建这三个程序的快捷方式。**安装字体的过程需要用户具有管理员权限。**
*注：经过5.0至5.5升级后，实际运行界面可能与此处效果图略有不同。下同。*

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE/raw/master/images/1.%20Installation.png" width="60%" height="60%"/>
</p>

## 功能介绍
以下分别简要介绍，具体可参见程序内说明及运行效果图。

* **DicReader**：可随机显示新东方 2017 佛脚词汇表单词，利用 Windows 自带的“讲述人”功能朗读单词及释义，显示网络例句（由百度翻译提供），并生成背词记录方便复习。具体操作说明详参程序内的说明。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE/raw/master/images/2.%20DicReader.png" width="60%" height="60%"/>
</p>

* **DicSearcher**：可查找佛脚词汇表中收录的单词，功能基本同上，方便记忆同义词、拼写相近的单词。输入内容不区分大小写，可通过单词的某一部分进行查找（如词根词缀；如只记得 ana 也可查到 anachronism），可查找中文释义，且支持正则表达式（常用的有 “.” 代表任意字符，“.\*”代表零个或一个或多个任意字符，“^”表示匹配开头，“$”表示匹配结尾等）。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE/raw/master/images/3.%20DicSearcher.png" width="60%" height="60%"/>
</p>

* **WordCount**：可以创建一个新的记事本窗口进行写作练习（不推荐使用 word 输入，因其有拼写检查功能），同时显示每个段落及总的单词数，以及当前所耗时间。30 分钟后有警告。但事实上，在 GRE 实际考试时不会显示总词数，因此勿过度依赖本功能，锻炼估计词数的能力。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE/raw/master/images/4.%20WordCount.png" width="60%" height="60%"/>
</p>

## 高级玩法
* 按 Ctrl+C (中止符) 可退出当前循环；
* 由于程序本质上是 Windows 控制台程序（默认开启快速编辑模式），因此支持各种控制台特性，例如 Alt+Enter 全屏，左键选中按 Enter 复制，按右键粘贴，ESC 清除该行内容等。还有一些控制台功能，如 F7/F8/F9 显示/搜索/选择输入历史记录，↑↓键显示上/下一条输入历史记录。默认缓冲区历史记录为 50 条，且可按 Alt+F7 清空。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE/raw/master/images/5.%20History Records.png" width="60%" height="60%"/>
</p>

## 更新记录：
* V 5.0 -> 5.5 (03/03/2019) 在一年前的 Win 10 更新后，Ruby 的 STDIN.gets（特别是在输入中文时）出现了很大的 bug，但目前尚未找到官方说明及解决方案。此外，F7/F8/F9 等功能在使用 STDIN.gets 时也无法实现。但不知为何，**只要先按 ESC 或右键之后就一切正常了**。由于此不稳定因素，将其替换为了 CMD 中的 SET /P 方法。除此以外，还修改了控制键为 W/A/S/D，无需回车，使用起来更方便。修改了 Install.bat 代码。因此次升级，软件截图可能与实际运行效果略有区别。**注意**：当限定控制键为 W/A/S/D 后，**按下其他键会发出“滴”报警声**。
