" vim: set ts=4 sw=4 sts=0:
"-----------------------------------------------------------------------------
" ʸ�������ɴ�Ϣ
"
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconv��eucJP-ms���б����Ƥ��뤫������å�
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconv��JISX0213���б����Ƥ��뤫������å�
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodings����
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" ������ʬ
	unlet s:enc_euc
	unlet s:enc_jis
endif
" ���ܸ��ޤޤʤ����� fileencoding �� encoding ��Ȥ��褦�ˤ���
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" ���ԥ����ɤμ�ưǧ��
set fileformats=unix,dos,mac
" ���Ȥ�����ʸ�������äƤ⥫��������֤�����ʤ��褦�ˤ���
if exists('&ambiwidth')
	set ambiwidth=double
endif

"-----------------------------------------------------------------------------
" �Խ���Ϣ
"
"�����ȥ���ǥ�Ȥ���
set autoindent
"�Х��ʥ��Խ�(xxd)�⡼�ɡ�vim -b �Ǥε�ư���⤷���� *.bin ��ȯư���ޤ���
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufWritePre * if &binary | %!xxd -r | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod | endif
augroup END

"-----------------------------------------------------------------------------
" ������Ϣ
"
"����ʸ���󤬾�ʸ���ξ�����ʸ����ʸ������̤ʤ���������
set ignorecase
"����ʸ�������ʸ�����ޤޤ�Ƥ�����϶��̤��Ƹ�������
set smartcase
"�������˺Ǹ�ޤǹԤä���ǽ�����
set wrapscan
"����ʸ�������ϻ��˽缡�о�ʸ����˥ҥåȤ����ʤ�
set noincsearch

"-----------------------------------------------------------------------------
" ������Ϣ
"
"���󥿥å����ϥ��饤�Ȥ�ͭ���ˤ���
if has("syntax")
	syntax on
endif
"���ֹ��ɽ�����ʤ�
"set nonumber
"���ֹ��ɽ������
set number
"���֤κ�¦�˥�������ɽ��
"set listchars=tab:\ \ 
"set list
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
"�����������ꤹ��
set tabstop=4
set shiftwidth=4
set softtabstop=4
"������Υ��ޥ�ɤ򥹥ơ�������ɽ������
set showcmd
"������ϻ����б������̤�ɽ��
set showmatch
"�������ʸ����Υϥ��饤�Ȥ�ͭ���ˤ���
set hlsearch
"���ơ������饤�����ɽ��
set laststatus=2
"���ơ������饤���ʸ�������ɤȲ���ʸ����ɽ������
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P


"-----------------------------------------------------------------------------
" �ޥå����
"
"�Хåե���ư�ѥ����ޥå�
" F2: ���ΥХåե�
" F3: ���ΥХåե�
" F4: �Хåե����
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
"ɽ����ñ�̤ǹ԰�ư����
nnoremap j gj
nnoremap k gk
"�ե졼�ॵ���������Ƥ��ѹ�����
map <kPlus> <C-W>+
map <kMinus> <C-W>-
