	.file	"libTinyFS.c"
	.comm	_ctr_state, 36, 5
	.comm	_disks, 2048, 5
.lcomm _system_mounted,4,4
.lcomm _block_count,4,4
.lcomm _mounted_disk,4,4
	.text
	.def	_init_superblock;	.scl	3;	.type	32;	.endef
_init_superblock:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$552, %esp
	movb	$1, -268(%ebp)
	movb	$68, -267(%ebp)
	movb	$1, -266(%ebp)
	movb	$2, -265(%ebp)
	movl	8(%ebp), %eax
	subl	$1, %eax
	movb	%al, -264(%ebp)
	movl	$251, 8(%esp)
	movl	$0, 4(%esp)
	leal	-268(%ebp), %eax
	addl	$5, %eax
	movl	%eax, (%esp)
	call	_memset
	leal	-268(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_writeBlock
	testl	%eax, %eax
	jns	L2
	movl	$-1, %eax
	jmp	L9
L2:
	movb	$4, -524(%ebp)
	movb	$68, -523(%ebp)
	movl	$2, -12(%ebp)
	jmp	L4
L8:
	movl	8(%ebp), %eax
	subl	$1, %eax
	cmpl	-12(%ebp), %eax
	jne	L5
	movb	$0, -522(%ebp)
	jmp	L6
L5:
	movl	-12(%ebp), %eax
	addl	$1, %eax
	movb	%al, -522(%ebp)
L6:
	movl	$253, 8(%esp)
	movl	$0, 4(%esp)
	leal	-524(%ebp), %eax
	addl	$3, %eax
	movl	%eax, (%esp)
	call	_memset
	leal	-524(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_writeBlock
	testl	%eax, %eax
	jns	L7
	movl	$-1, %eax
	jmp	L9
L7:
	addl	$1, -12(%ebp)
L4:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	jl	L8
	movl	$0, %eax
L9:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.globl	_tfs_mkfs
	.def	_tfs_mkfs;	.scl	2;	.type	32;	.endef
_tfs_mkfs:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_openDisk
	movl	%eax, -12(%ebp)
	movl	12(%ebp), %eax
	cltd
	movzbl	%dl, %edx
	addl	%edx, %eax
	sarl	$8, %eax
	movl	%eax, _block_count
	movl	_block_count, %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_init_superblock
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.globl	_tfs_mount
	.def	_tfs_mount;	.scl	2;	.type	32;	.endef
_tfs_mount:
LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$296, %esp
	movl	$0, -12(%ebp)
	movl	_system_mounted, %eax
	testl	%eax, %eax
	je	L13
	movl	$-2, %eax
	jmp	L20
L13:
	cmpl	$0, 8(%ebp)
	jne	L15
	movl	$-2, %eax
	jmp	L20
L15:
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_openDisk
	movl	%eax, _mounted_disk
	movl	_mounted_disk, %eax
	cmpl	$-1, %eax
	jne	L16
	movl	$-2, %eax
	jmp	L20
L16:
	movl	$1, _system_mounted
	jmp	L17
L19:
	movl	_mounted_disk, %eax
	leal	-268(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_readBlock
	movzbl	-267(%ebp), %eax
	cmpb	$68, %al
	je	L18
	movl	$-2, %eax
	jmp	L20
L18:
	addl	$1, -12(%ebp)
L17:
	movl	_block_count, %eax
	cmpl	%eax, -12(%ebp)
	jl	L19
	movl	$0, %eax
L20:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.globl	_tfs_unmount
	.def	_tfs_unmount;	.scl	2;	.type	32;	.endef
_tfs_unmount:
LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE16:
	.globl	_tfs_openFile
	.def	_tfs_openFile;	.scl	2;	.type	32;	.endef
_tfs_openFile:
LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE17:
	.globl	_tfs_closeFile
	.def	_tfs_closeFile;	.scl	2;	.type	32;	.endef
_tfs_closeFile:
LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE18:
	.globl	_tfs_writeFile
	.def	_tfs_writeFile;	.scl	2;	.type	32;	.endef
_tfs_writeFile:
LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE19:
	.globl	_tfs_deleteFile
	.def	_tfs_deleteFile;	.scl	2;	.type	32;	.endef
_tfs_deleteFile:
LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE20:
	.globl	_tfs_readByte
	.def	_tfs_readByte;	.scl	2;	.type	32;	.endef
_tfs_readByte:
LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE21:
	.globl	_tfs_seek
	.def	_tfs_seek;	.scl	2;	.type	32;	.endef
_tfs_seek:
LFB22:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	$0, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE22:
	.ident	"GCC: (GNU) 5.3.0"
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	_writeBlock;	.scl	2;	.type	32;	.endef
	.def	_openDisk;	.scl	2;	.type	32;	.endef
	.def	_readBlock;	.scl	2;	.type	32;	.endef
