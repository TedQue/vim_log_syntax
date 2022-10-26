VIM 适用于 LOG 文件的语法高亮配置
阙荣文 - Que's C++ Studio

1. VIM 事件
VIM 在运行过程中,随着用户动作会触发很多*事件*,包括 VIM 程序启动,退出,某个文件被加载,等等.
[:h autocmd] 可以查看所有的事件列表.
VIM 脚本通过 autocmd 命令可以告知 VIM 程序"当某个事件触发时,执行某某某操作",
比如实现当 *.c 文件被加载时,应用 c 语言语法对该文件执行语法高亮着色,类似于编程语言中的回调函数或者钩子.

2. VIM filetype
filetype 是 VIM 运行时非常重要的一个变量,其值通常由一系列预定义的 autocmd 设置.
[:h filetype] 查看详细说明

[:filetype on] 开启 filetype 文件类型检测机制,该命令实际上执行 $VIMRUNTIME/filetype.vim 脚本,里面是一组用于根据文件扩展名识别类型的 autocmd 命令
[:filetype] 可以查看当前是否已激活 filetype 机制, [:syntax on] 命令会自动开启 filetype,所以通常情况下 filetype 机制都是激活的(因为用于编程环境的 VIM 总会打开 syntax)

$VIMRUNTIME/filetype.vim 文件在设置完默认的文件类型之后,执行命令 [runtime! ftdetect/*.vim]
表示加载所有 runtime 路径(包括系统级 VIM 运行时路径 $VIMRUNTIME /usr/share/vim/vim90 和用户级运行时路径 ~/.vim, [:echo &runtimepath] 可以查看全部路径) ftdetect 子目录下所有 .vim 文件的内容.
所以当需要添加自定义 filetype 时,通常我们把自己的规则放在 ~/.vim/ftdetect 目录下:
(a). 创建自己的 'runtimepath'
	[:!mkdir ~/.vim]
	[:!mkdir ~/.vim/ftdetect]

(b). 定义自己的 filetype autocmd
	[:w ~/.vim/ftdetect/log.vim]

	" 当发生事件 BufRead/BufNewFile (文件读入或新建) 时如果文件名以 log 结尾则设置 filetype 为 "log"
	" setf 等效于 set filetype
	au BufRead,BufNewFile *.log		setf log

现在,当我们打开一个扩展名为 log 的文件时 VIM 将自动设置 &filetype 为 "log",
同时, &filetype 值的变化会使 VIM 触发名为 FileType 的事件,后续 syntax 将根据该事件应用相应的语法着色规则.

3. VIM 语法着色机制
为了对文件内容着色, VIM 需要对文件内容分组,识别哪些内容分别属于关键字组,字符串组,常量组,预处理组等等.
组名虽然可以任意取,但大多数编程语言的规则都是类似的,且目前已经有一套惯例组名,我们自定义的分组规则最好也遵循这个惯例.
因为最终颜色主题方案 colorscheme 是根据这些组名来着色的,遵循命名惯例可以很方便的应用已有的颜色主题方案.

[:h group-name] 可以查看这些惯例组名,如下: 
	*Comment	any comment

	*Constant	any constant
	 String		a string constant: "this is a string"
	 Character	a character constant: 'c', '\n'
	 Number		a number constant: 234, 0xff
	 Boolean	a boolean constant: TRUE, false
	 Float		a floating point constant: 2.3e10

	*Identifier	any variable name
	 Function	function name (also: methods for classes)

	*Statement	any statement
	 Conditional	if, then, else, endif, switch, etc.
	 Repeat		for, do, while, etc.
	 Label		case, default, etc.
	 Operator	"sizeof", "+", "*", etc.
	 Keyword	any other keyword
	 Exception	try, catch, throw

	*PreProc	generic Preprocessor
	 Include	preprocessor #include
	 Define		preprocessor #define
	 Macro		same as Define
	 PreCondit	preprocessor #if, #else, #endif, etc.

	*Type		int, long, char, etc.
	 StorageClass	static, register, volatile, etc.
	 Structure	struct, union, enum, etc.
	 Typedef	A typedef

	*Special	any special symbol
	 SpecialChar	special character in a constant
	 Tag		you can use CTRL-] on this
	 Delimiter	character that needs attention
	 SpecialComment	special things inside a comment
	 Debug		debugging statements

	*Underlined	text that stands out, HTML links

	*Ignore		left blank, hidden  |hl-Ignore|

	*Error		any erroneous construct

	*Todo		anything that needs extra attention; mostly the keywords TODO FIXME and XXX

[:syn] 定义分组规则,包括:
(a) 单词匹配
	[syn keywrod <group-name> <keyword1 kw2 kw3 ...>]

(b) 单行匹配
	[syn match <group-name> <pattern>]

(c) 多行匹配
	[syn region <group-name> start=<pattern> skip=<pattern> end=<pattern>]

定义 log 语法只需了解上述 3 种规则就足够了,详情请参考 [:h syntax]
完成内容分组后,还需要再指定每个分组分别着上什么颜色才可以实现语法高亮效果,
这是命令 highlight 的工作([:h highlight] 查看详细说明),例如:
	" 设置组 "String" 的颜色
	[hi String guifg=#A1A6A8 guibg=NONE guisp=NONE gui=NONE ctermfg=248 ctermbg=NONE cterm=NONE]

对前述的每个惯用组名都指定一条 hi 命令,并把这些命令集中到一个文件中就是颜色主题方案.
现有的颜色主题方案安装在 $VIMRUNTIME/colors/ 目录下,命令 [:color <tab>] 可以切换颜色主题.

总结一下 VIM 语法着色的过程:
一切始于[:syntax on],实际执行脚本 [:source $VIMRUNTIME/syntax/syntax.vim],注册 autocmd 当 FileType 事件
发生时,设置选项 &syntax 的值,同时加载对应的语法着色文件.

以加载 *.log 文件为例:
	BufRead 事件 ->
	执行 ~/.vim/ftdetect/log.vim -> 
	选项 &filetype = log ->
	触发 FileType 事件 ->
	选项 &syntax = log ->
	触发 Syntax 事件 ->
	执行 ~/.vim/syntax/log.vim

我们在 ~/.vim/syntax/log.vim 定义了用于对 LOG 文件内容进行分组的规则,分组完毕后 VIM 再根据当前颜色主题对各组着色. 

4. 我的 log 格式示例

	# 注释 ----------
	10/25/2022 08:26:08 - INFO - Welcome to FuturesGene v2.10.5 by Que's C++ Studio
	10/25/2022 08:26:08 - DEBUG - [1]fgnc (pid 329) started
	10/25/2022 08:26:08 - INFO - [1]"event/conf/reload" timer: "08:00:00;12:00:00;20:00:00"
	10/25/2022 08:26:08 - INFO - [1]"status/session/running" timer: "08:30:00,11:40:00;13:00:00,15:35:00;20:30:00,02:35:00"
	10/25/2022 08:26:08 - DEBUG - node[1] ctl/1/0x0000 status capture map
	10/25/2022 08:26:08 - TRACE - node[1] capture "event/conf/reload":1
	10/25/2022 08:30:00 - WARNING - [2]CTPQuotes invalid login, empty trading day, retry in 30s ...

格式为: <日期> <时间> - <日志级别> - <内容>
我的目标是对上述各个部分,以及<内容>中的字符串,数字常量分别着色,所以需要写出识别各分组的模式串(pattern),
所幸大多数规则可以参考现有的 c 或 python 语法文件,比如字符串,数字常量等模式都是相同的,直接复制过来就可以了.

编辑文件 ~/.vim/syntax/log.vim 定义分组规则:
	" 参考 c 语法文件 $VIMRUNTIME/syntax/c.vim 先自定义组名,最后再链接到惯用组名
	let s:cpo_save = &cpo
	set cpo&vim

	" 如果您的日志级别关键字与我的不同,请在此处修改
	syn keyword	logLabel		FATAL ERROR WARNING INFO DEBUG TRACE 
	" FATAL ERROR 直接归类到惯用组名 "Error" 通常显示为红色
	syn keyword Error			FATAL ERROR
	" WARNING 归类到 TODO 组,通常显示为黄色
	syn keyword Todo			WARNING

	" 字符串, 数字常量的规则与 c 一致,直接复制过来
	" string charracter
	syn region	logString		start=+"+ skip=+\\\\\|\\"+ end=+"+
	syn match	logCharacter	"L\='[^\\]'"

	" integer number, or floating point number without a dot and with "f".
	syn match	logNumbers	display transparent "\<\d\|\.\d" contains=logNumber,logFloat,logOctal
	syn match	logNumber	display contained "\d\+\%(u\=l\{0,2}\|ll\=u\)\>"
	syn match	logNumber	display contained "0x\x\+\%(u\=l\{0,2}\|ll\=u\)\>"
	syn match	logFloat	display contained "\d\+\.\d*\%(e[-+]\=\d\+\)\=[fl]\="
	syn match	logFloat	display contained "\.\d\+\%(e[-+]\=\d\+\)\=[fl]\=\>"
	syn match	logFloat	display contained "\d\+e[-+]\=\d\+[fl]\=\>"

	" 不是很严格的 date time 模式串,可以匹配 YYYYMMDD, MM/DD/YYYY, YYYY-MM-DD, HH:MM:SS 格式的时间字符串
	syn match	logDate	"\<\d\{2,4}[/-]\d\{2}[/-]\d\{2,4}\>"
	syn match	logDate	"\<[12]\d\{3}[01]\d[0123]\d\>"
	syn match	logTime	"\<\d\{2}:\d\{2}:\d\{2}\>"

	" # 开头的单行注释,类似 cpp // 开头的注释,复制过来,把 // 改为 #
	syn region	logComment	start="^\s*#" end="$" keepend

	" 把上述组名链接到惯用组名,方便应用到现有的颜色主题
	" 日志级别归类为 label, 类似 c 的 case, goto label
	" 日期时间归类为预处理符号,类似 c 的 #include
	hi def link logLabel		Label
	hi def link logString		String
	hi def link logCharacter	Character
	hi def link logNumbers		Number
	hi def link logNumber		Number
	hi def link logFloat		Number
	hi def link logDate			PreProc
	hi def link logTime			PreProc
	hi def link logComment		Comment

	let b:current_syntax = "log"

	let &cpo = s:cpo_save
	unlet s:cpo_save

5. 安装
复制源码包到 ~/.vim/ 即可

6. screenshot
Ubuntu 18.04 终端默认的亮紫色背景非常费眼睛,改为前景色: #B0B0B0 背景色: #2E3436 内置调色板: Tango
VIM colorscheme 为 qpp (已包含在源码包中) 效果如下:


