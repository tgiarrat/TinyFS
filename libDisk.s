	.file	"libDisk.c"
	.comm	disks,4096,32
	.comm	ctr_state,36,32
	.section	.rodata
.LC0:
	.string	"%s"
.LC1:
	.string	"%02x"
	.text
	.globl	print_hex
	.type	print_hex, @function
print_hex:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L3
	movl	$10, %edi
	call	putchar
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	print_hex, .-print_hex
	.section	.rodata
.LC2:
	.string	"GENERATED KEY:: "
.LC3:
	.string	"iv: "
.LC4:
	.string	"salt: "
.LC5:
	.string	"w"
	.text
	.globl	generateMasterKey
	.type	generateMasterKey, @function
generateMasterKey:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rdx, -104(%rbp)
	movq	%rcx, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpq	$0, -104(%rbp)
	jne	.L6
	leaq	-48(%rbp), %rax
	movq	%rax, -104(%rbp)
	leaq	-48(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	generateRandomData
.L6:
	movq	-104(%rbp), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC2, %edi
	call	print_hex
	cmpq	$0, -112(%rbp)
	jne	.L7
	leaq	-48(%rbp), %rax
	movq	%rax, -112(%rbp)
	leaq	-48(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	generateRandomData
.L7:
	leaq	-64(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	generateRandomData
	movq	-112(%rbp), %rax
	movl	$8, %edx
	movq	%rax, %rsi
	movl	$.LC3, %edi
	call	print_hex
	leaq	-64(%rbp), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC4, %edi
	call	print_hex
	leaq	-48(%rbp), %rdi
	movq	-112(%rbp), %rcx
	leaq	-64(%rbp), %rdx
	movq	-96(%rbp), %rsi
	movq	-104(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	aesXorMasterKey
	leaq	-48(%rbp), %rax
	addq	$16, %rax
	movq	-112(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	leaq	-48(%rbp), %rcx
	addq	$24, %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-88(%rbp), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$40, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movl	$0, %eax
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L9
	call	__stack_chk_fail
.L9:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	generateMasterKey, .-generateMasterKey
	.section	.rodata
.LC6:
	.string	"r"
	.text
	.globl	extractMasterKey
	.type	extractMasterKey, @function
extractMasterKey:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movq	%rcx, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-104(%rbp), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$40, %esi
	movq	%rax, %rdi
	call	fread
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	leaq	-48(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-128(%rbp), %rax
	movl	$8, %edx
	movq	%rax, %rsi
	movl	$.LC3, %edi
	call	print_hex
	leaq	-48(%rbp), %rax
	addq	$24, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	leaq	-64(%rbp), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC4, %edi
	call	print_hex
	movq	-120(%rbp), %rdi
	movq	-128(%rbp), %rcx
	leaq	-64(%rbp), %rdx
	movq	-112(%rbp), %rsi
	leaq	-80(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	aesXorMasterKey
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L12
	call	__stack_chk_fail
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	extractMasterKey, .-extractMasterKey
	.section	.rodata
.LC7:
	.string	"flatkey: "
	.text
	.globl	aesXorMasterKey
	.type	aesXorMasterKey, @function
aesXorMasterKey:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	%rcx, -80(%rbp)
	movq	%r8, -88(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rdx
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	PBKDF
	leaq	-32(%rbp), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC7, %edi
	call	print_hex
	movl	$8, %edi
	call	malloc
	movq	%rax, -40(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-88(%rbp), %rcx
	movq	-56(%rbp), %rdx
	movq	-40(%rbp), %rsi
	leaq	-32(%rbp), %rax
	movl	$16, %r8d
	movq	%rax, %rdi
	call	aes128Ctr
	movl	$0, %eax
	movq	-8(%rbp), %rdi
	xorq	%fs:40, %rdi
	je	.L15
	call	__stack_chk_fail
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	aesXorMasterKey, .-aesXorMasterKey
	.globl	PBKDF
	.type	PBKDF, @function
PBKDF:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rsi
	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rdx
	movq	-24(%rbp), %rax
	pushq	$1
	pushq	$33554432
	movl	$4, %r9d
	movq	%rcx, %r8
	movq	%rsi, %rcx
	movl	$16, %esi
	movq	%rax, %rdi
	call	crypto_pwhash
	addq	$16, %rsp
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	PBKDF, .-PBKDF
	.section	.rodata
.LC8:
	.string	"/dev/urandom"
	.text
	.globl	generateRandomData
	.type	generateRandomData, @function
generateRandomData:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$.LC6, %esi
	movl	$.LC8, %edi
	call	fopen
	movq	%rax, -8(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rcx
	movq	-24(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	generateRandomData, .-generateRandomData
	.globl	changePassword
	.type	changePassword, @function
changePassword:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	%rcx, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rdx
	movq	-72(%rbp), %rsi
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	extractMasterKey
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rdx
	movq	-80(%rbp), %rsi
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	generateMasterKey
	movl	$0, %eax
	movq	-8(%rbp), %rdi
	xorq	%fs:40, %rdi
	je	.L21
	call	__stack_chk_fail
.L21:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	changePassword, .-changePassword
	.section	.rodata
.LC9:
	.string	"r+"
.LC10:
	.string	"UNLOCKED KEY:: "
	.align 8
.LC11:
	.string	"nBytes is not an integral number of blocksize"
	.align 8
.LC12:
	.string	"ERROR writing blocks, status: %d\n"
	.text
	.globl	openDisk
	.type	openDisk, @function
openDisk:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32848, %rsp
	movq	%rdi, -32824(%rbp)
	movl	%esi, -32828(%rbp)
	movq	%rdx, -32840(%rbp)
	movq	%rcx, -32848(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -32816(%rbp)
	jmp	.L23
.L25:
	addl	$1, -32816(%rbp)
.L23:
	movl	-32816(%rbp), %eax
	cltq
	movq	disks(,%rax,8), %rax
	testq	%rax, %rax
	je	.L24
	cmpl	$512, -32816(%rbp)
	jne	.L25
.L24:
	cmpl	$512, -32816(%rbp)
	jne	.L26
	movl	$-1, %eax
	jmp	.L27
.L26:
	movl	$32, %edi
	call	malloc
	movq	%rax, %rdx
	movl	-32816(%rbp), %eax
	cltq
	movq	%rdx, disks(,%rax,8)
	movl	-32816(%rbp), %eax
	cltq
	movq	disks(,%rax,8), %rax
	movq	%rax, -32800(%rbp)
	movq	-32824(%rbp), %rax
	movl	$.LC9, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, %rdx
	movq	-32800(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-32800(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L28
	movq	-32824(%rbp), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, %rdx
	movq	-32800(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-32824(%rbp), %rax
	movl	$.LC9, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, %rdx
	movq	-32800(%rbp), %rax
	movq	%rdx, (%rax)
.L28:
	movl	$16, %edi
	call	malloc
	movq	%rax, %rdx
	movq	-32800(%rbp), %rax
	movq	%rdx, 16(%rax)
	movl	$16, %edi
	call	malloc
	movq	%rax, %rdx
	movq	-32800(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-32800(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-32800(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-32840(%rbp), %rsi
	movq	-32848(%rbp), %rax
	movq	%rax, %rdi
	call	extractMasterKey
	movq	-32800(%rbp), %rax
	movq	16(%rax), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC10, %edi
	call	print_hex
	cmpl	$0, -32828(%rbp)
	jle	.L29
	movl	-32828(%rbp), %eax
	andl	$4095, %eax
	testl	%eax, %eax
	je	.L30
	movl	$.LC11, %edi
	call	puts
.L30:
	movl	-32828(%rbp), %eax
	leal	4095(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$12, %eax
	movl	%eax, -32808(%rbp)
	movq	-32800(%rbp), %rax
	movl	-32828(%rbp), %edx
	movl	%edx, 8(%rax)
	movl	$0, -32812(%rbp)
	jmp	.L31
.L33:
	leaq	-32784(%rbp), %rdx
	movl	-32812(%rbp), %ecx
	movl	-32816(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	writeBlock
	movl	%eax, -32804(%rbp)
	cmpl	$0, -32804(%rbp)
	je	.L32
	movl	-32804(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
.L32:
	addl	$1, -32812(%rbp)
.L31:
	movl	-32812(%rbp), %eax
	cmpl	-32808(%rbp), %eax
	jl	.L33
	jmp	.L34
.L29:
	movq	-32800(%rbp), %rax
	movq	(%rax), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-32800(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -32792(%rbp)
	movq	-32800(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	rewind
	movq	-32792(%rbp), %rax
	movl	%eax, %edx
	movq	-32800(%rbp), %rax
	movl	%edx, 8(%rax)
.L34:
	movl	-32816(%rbp), %eax
.L27:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L35
	call	__stack_chk_fail
.L35:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	openDisk, .-openDisk
	.globl	closeDisk
	.type	closeDisk, @function
closeDisk:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	disks(,%rax,8), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L37
	movl	$2, %eax
	jmp	.L38
.L37:
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$8, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movl	-20(%rbp), %eax
	cltq
	movq	$0, disks(,%rax,8)
	movl	$0, %eax
.L38:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	closeDisk, .-closeDisk
	.globl	readBlock
	.type	readBlock, @function
readBlock:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4144, %rsp
	movl	%edi, -4132(%rbp)
	movl	%esi, -4136(%rbp)
	movq	%rdx, -4144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	-4132(%rbp), %eax
	cltq
	movq	disks(,%rax,8), %rax
	movq	%rax, -4120(%rbp)
	cmpq	$0, -4120(%rbp)
	jne	.L40
	movl	$2, %eax
	jmp	.L45
.L40:
	movq	-4120(%rbp), %rax
	movl	8(%rax), %eax
	leal	4095(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$12, %eax
	cmpl	-4136(%rbp), %eax
	jle	.L42
	cmpl	$0, -4136(%rbp)
	jns	.L43
.L42:
	movl	$1, %eax
	jmp	.L45
.L43:
	movl	-4136(%rbp), %eax
	sall	$12, %eax
	movslq	%eax, %rcx
	movq	-4120(%rbp), %rax
	movq	(%rax), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-4120(%rbp), %rax
	movq	(%rax), %rdx
	leaq	-4112(%rbp), %rax
	movq	%rdx, %rcx
	movl	$4096, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movq	-4120(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-4120(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-4136(%rbp), %edi
	movq	-4144(%rbp), %rsi
	leaq	-4112(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	aesCtrXorBlock
	testl	%eax, %eax
	je	.L44
	movl	$1, %eax
	jmp	.L45
.L44:
	movl	$0, %eax
.L45:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L46
	call	__stack_chk_fail
.L46:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	readBlock, .-readBlock
	.globl	writeBlock
	.type	writeBlock, @function
writeBlock:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4144, %rsp
	movl	%edi, -4132(%rbp)
	movl	%esi, -4136(%rbp)
	movq	%rdx, -4144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	-4132(%rbp), %eax
	cltq
	movq	disks(,%rax,8), %rax
	movq	%rax, -4120(%rbp)
	cmpq	$0, -4120(%rbp)
	jne	.L48
	movl	$2, %eax
	jmp	.L51
.L48:
	movq	-4120(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-4120(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-4136(%rbp), %edi
	leaq	-4112(%rbp), %rsi
	movq	-4144(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	aesCtrXorBlock
	testl	%eax, %eax
	je	.L50
	movl	$1, %eax
	jmp	.L51
.L50:
	movl	-4136(%rbp), %eax
	sall	$12, %eax
	movslq	%eax, %rcx
	movq	-4120(%rbp), %rax
	movq	(%rax), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fseek
	movq	-4120(%rbp), %rax
	movq	(%rax), %rdx
	leaq	-4112(%rbp), %rax
	movq	%rdx, %rcx
	movl	$4096, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	-4120(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	fflush
	movl	$0, %eax
.L51:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L52
	call	__stack_chk_fail
.L52:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	writeBlock, .-writeBlock
	.globl	aesCtrXorBlock
	.type	aesCtrXorBlock, @function
aesCtrXorBlock:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%rcx, -48(%rbp)
	movl	%r8d, -52(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movzbl	-16(%rbp), %edx
	movl	-52(%rbp), %eax
	shrl	$24, %eax
	xorl	%edx, %eax
	movb	%al, -16(%rbp)
	movzbl	-15(%rbp), %eax
	movl	%eax, %edx
	movl	-52(%rbp), %eax
	andl	$16711680, %eax
	sarl	$16, %eax
	xorl	%edx, %eax
	movb	%al, -15(%rbp)
	movzbl	-14(%rbp), %eax
	movl	%eax, %edx
	movl	-52(%rbp), %eax
	andl	$65280, %eax
	sarl	$8, %eax
	xorl	%edx, %eax
	movb	%al, -14(%rbp)
	movzbl	-13(%rbp), %eax
	movl	%eax, %edx
	movl	-52(%rbp), %eax
	xorl	%edx, %eax
	movb	%al, -13(%rbp)
	movq	-32(%rbp), %rcx
	movq	-24(%rbp), %rdx
	leaq	-16(%rbp), %rsi
	movq	-40(%rbp), %rax
	movl	$4096, %r8d
	movq	%rax, %rdi
	call	aes128Ctr
	testl	%eax, %eax
	je	.L54
	movl	$1, %eax
	jmp	.L56
.L54:
	movl	$0, %eax
.L56:
	movq	-8(%rbp), %rdi
	xorq	%fs:40, %rdi
	je	.L57
	call	__stack_chk_fail
.L57:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	aesCtrXorBlock, .-aesCtrXorBlock
	.globl	aes128Ctr
	.type	aes128Ctr, @function
aes128Ctr:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$352, %rsp
	movq	%rdi, -312(%rbp)
	movq	%rsi, -320(%rbp)
	movq	%rdx, -328(%rbp)
	movq	%rcx, -336(%rbp)
	movl	%r8d, -340(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-320(%rbp), %rdx
	leaq	-304(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	init_ctr
	leaq	-256(%rbp), %rdx
	movq	-312(%rbp), %rax
	movl	$128, %esi
	movq	%rax, %rdi
	call	AES_set_encrypt_key
	testl	%eax, %eax
	je	.L59
	movl	$1, %eax
	jmp	.L61
.L59:
	movl	-340(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-304(%rbp), %rax
	leaq	20(%rax), %r9
	leaq	-304(%rbp), %rdi
	leaq	-256(%rbp), %rcx
	movq	-336(%rbp), %rsi
	movq	-328(%rbp), %rax
	subq	$8, %rsp
	leaq	-304(%rbp), %r8
	addq	$16, %r8
	pushq	%r8
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	AES_ctr128_encrypt
	addq	$16, %rsp
	movl	$0, %eax
.L61:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L62
	call	__stack_chk_fail
.L62:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	aes128Ctr, .-aes128Ctr
	.globl	init_ctr
	.type	init_ctr, @function
init_ctr:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, 16(%rax)
	movq	-8(%rbp), %rax
	addq	$20, %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movl	$8, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	init_ctr, .-init_ctr
	.globl	sha256Hash
	.type	sha256Hash, @function
sha256Hash:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movq	%rdx, -152(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	SHA256_Init
	testl	%eax, %eax
	jne	.L66
	movl	$1, %eax
	jmp	.L70
.L66:
	movl	-140(%rbp), %eax
	movslq	%eax, %rdx
	movq	-136(%rbp), %rcx
	leaq	-128(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	SHA256_Update
	testl	%eax, %eax
	jne	.L68
	movl	$1, %eax
	jmp	.L70
.L68:
	leaq	-128(%rbp), %rdx
	movq	-152(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	SHA256_Final
	testl	%eax, %eax
	jne	.L69
	movl	$1, %eax
	jmp	.L70
.L69:
	movl	$0, %eax
.L70:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L71
	call	__stack_chk_fail
.L71:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	sha256Hash, .-sha256Hash
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
