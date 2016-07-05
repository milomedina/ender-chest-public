
bufbomb:     file format elf32-i386


Disassembly of section .init:

080487c0 <_init>:
 80487c0:	55                   	push   %ebp
 80487c1:	89 e5                	mov    %esp,%ebp
 80487c3:	53                   	push   %ebx
 80487c4:	83 ec 04             	sub    $0x4,%esp
 80487c7:	e8 00 00 00 00       	call   80487cc <_init+0xc>
 80487cc:	5b                   	pop    %ebx
 80487cd:	81 c3 14 29 00 00    	add    $0x2914,%ebx
 80487d3:	8b 93 fc ff ff ff    	mov    -0x4(%ebx),%edx
 80487d9:	85 d2                	test   %edx,%edx
 80487db:	74 05                	je     80487e2 <_init+0x22>
 80487dd:	e8 9e 00 00 00       	call   8048880 <__gmon_start__@plt>
 80487e2:	e8 09 03 00 00       	call   8048af0 <frame_dummy>
 80487e7:	e8 14 19 00 00       	call   804a100 <__do_global_ctors_aux>
 80487ec:	58                   	pop    %eax
 80487ed:	5b                   	pop    %ebx
 80487ee:	c9                   	leave  
 80487ef:	c3                   	ret    

Disassembly of section .plt:

080487f0 <__errno_location@plt-0x10>:
 80487f0:	ff 35 e4 b0 04 08    	pushl  0x804b0e4
 80487f6:	ff 25 e8 b0 04 08    	jmp    *0x804b0e8
 80487fc:	00 00                	add    %al,(%eax)
	...

08048800 <__errno_location@plt>:
 8048800:	ff 25 ec b0 04 08    	jmp    *0x804b0ec
 8048806:	68 00 00 00 00       	push   $0x0
 804880b:	e9 e0 ff ff ff       	jmp    80487f0 <_init+0x30>

08048810 <sprintf@plt>:
 8048810:	ff 25 f0 b0 04 08    	jmp    *0x804b0f0
 8048816:	68 08 00 00 00       	push   $0x8
 804881b:	e9 d0 ff ff ff       	jmp    80487f0 <_init+0x30>

08048820 <srand@plt>:
 8048820:	ff 25 f4 b0 04 08    	jmp    *0x804b0f4
 8048826:	68 10 00 00 00       	push   $0x10
 804882b:	e9 c0 ff ff ff       	jmp    80487f0 <_init+0x30>

08048830 <connect@plt>:
 8048830:	ff 25 f8 b0 04 08    	jmp    *0x804b0f8
 8048836:	68 18 00 00 00       	push   $0x18
 804883b:	e9 b0 ff ff ff       	jmp    80487f0 <_init+0x30>

08048840 <mmap@plt>:
 8048840:	ff 25 fc b0 04 08    	jmp    *0x804b0fc
 8048846:	68 20 00 00 00       	push   $0x20
 804884b:	e9 a0 ff ff ff       	jmp    80487f0 <_init+0x30>

08048850 <getpid@plt>:
 8048850:	ff 25 00 b1 04 08    	jmp    *0x804b100
 8048856:	68 28 00 00 00       	push   $0x28
 804885b:	e9 90 ff ff ff       	jmp    80487f0 <_init+0x30>

08048860 <random@plt>:
 8048860:	ff 25 04 b1 04 08    	jmp    *0x804b104
 8048866:	68 30 00 00 00       	push   $0x30
 804886b:	e9 80 ff ff ff       	jmp    80487f0 <_init+0x30>

08048870 <signal@plt>:
 8048870:	ff 25 08 b1 04 08    	jmp    *0x804b108
 8048876:	68 38 00 00 00       	push   $0x38
 804887b:	e9 70 ff ff ff       	jmp    80487f0 <_init+0x30>

08048880 <__gmon_start__@plt>:
 8048880:	ff 25 0c b1 04 08    	jmp    *0x804b10c
 8048886:	68 40 00 00 00       	push   $0x40
 804888b:	e9 60 ff ff ff       	jmp    80487f0 <_init+0x30>

08048890 <__isoc99_sscanf@plt>:
 8048890:	ff 25 10 b1 04 08    	jmp    *0x804b110
 8048896:	68 48 00 00 00       	push   $0x48
 804889b:	e9 50 ff ff ff       	jmp    80487f0 <_init+0x30>

080488a0 <calloc@plt>:
 80488a0:	ff 25 14 b1 04 08    	jmp    *0x804b114
 80488a6:	68 50 00 00 00       	push   $0x50
 80488ab:	e9 40 ff ff ff       	jmp    80487f0 <_init+0x30>

080488b0 <write@plt>:
 80488b0:	ff 25 18 b1 04 08    	jmp    *0x804b118
 80488b6:	68 58 00 00 00       	push   $0x58
 80488bb:	e9 30 ff ff ff       	jmp    80487f0 <_init+0x30>

080488c0 <memset@plt>:
 80488c0:	ff 25 1c b1 04 08    	jmp    *0x804b11c
 80488c6:	68 60 00 00 00       	push   $0x60
 80488cb:	e9 20 ff ff ff       	jmp    80487f0 <_init+0x30>

080488d0 <__libc_start_main@plt>:
 80488d0:	ff 25 20 b1 04 08    	jmp    *0x804b120
 80488d6:	68 68 00 00 00       	push   $0x68
 80488db:	e9 10 ff ff ff       	jmp    80487f0 <_init+0x30>

080488e0 <_IO_getc@plt>:
 80488e0:	ff 25 24 b1 04 08    	jmp    *0x804b124
 80488e6:	68 70 00 00 00       	push   $0x70
 80488eb:	e9 00 ff ff ff       	jmp    80487f0 <_init+0x30>

080488f0 <htons@plt>:
 80488f0:	ff 25 28 b1 04 08    	jmp    *0x804b128
 80488f6:	68 78 00 00 00       	push   $0x78
 80488fb:	e9 f0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048900 <read@plt>:
 8048900:	ff 25 2c b1 04 08    	jmp    *0x804b12c
 8048906:	68 80 00 00 00       	push   $0x80
 804890b:	e9 e0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048910 <socket@plt>:
 8048910:	ff 25 30 b1 04 08    	jmp    *0x804b130
 8048916:	68 88 00 00 00       	push   $0x88
 804891b:	e9 d0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048920 <bcopy@plt>:
 8048920:	ff 25 34 b1 04 08    	jmp    *0x804b134
 8048926:	68 90 00 00 00       	push   $0x90
 804892b:	e9 c0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048930 <getopt@plt>:
 8048930:	ff 25 38 b1 04 08    	jmp    *0x804b138
 8048936:	68 98 00 00 00       	push   $0x98
 804893b:	e9 b0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048940 <memcpy@plt>:
 8048940:	ff 25 3c b1 04 08    	jmp    *0x804b13c
 8048946:	68 a0 00 00 00       	push   $0xa0
 804894b:	e9 a0 fe ff ff       	jmp    80487f0 <_init+0x30>

08048950 <strlen@plt>:
 8048950:	ff 25 40 b1 04 08    	jmp    *0x804b140
 8048956:	68 a8 00 00 00       	push   $0xa8
 804895b:	e9 90 fe ff ff       	jmp    80487f0 <_init+0x30>

08048960 <alarm@plt>:
 8048960:	ff 25 44 b1 04 08    	jmp    *0x804b144
 8048966:	68 b0 00 00 00       	push   $0xb0
 804896b:	e9 80 fe ff ff       	jmp    80487f0 <_init+0x30>

08048970 <strcpy@plt>:
 8048970:	ff 25 48 b1 04 08    	jmp    *0x804b148
 8048976:	68 b8 00 00 00       	push   $0xb8
 804897b:	e9 70 fe ff ff       	jmp    80487f0 <_init+0x30>

08048980 <printf@plt>:
 8048980:	ff 25 4c b1 04 08    	jmp    *0x804b14c
 8048986:	68 c0 00 00 00       	push   $0xc0
 804898b:	e9 60 fe ff ff       	jmp    80487f0 <_init+0x30>

08048990 <strcasecmp@plt>:
 8048990:	ff 25 50 b1 04 08    	jmp    *0x804b150
 8048996:	68 c8 00 00 00       	push   $0xc8
 804899b:	e9 50 fe ff ff       	jmp    80487f0 <_init+0x30>

080489a0 <srandom@plt>:
 80489a0:	ff 25 54 b1 04 08    	jmp    *0x804b154
 80489a6:	68 d0 00 00 00       	push   $0xd0
 80489ab:	e9 40 fe ff ff       	jmp    80487f0 <_init+0x30>

080489b0 <close@plt>:
 80489b0:	ff 25 58 b1 04 08    	jmp    *0x804b158
 80489b6:	68 d8 00 00 00       	push   $0xd8
 80489bb:	e9 30 fe ff ff       	jmp    80487f0 <_init+0x30>

080489c0 <fwrite@plt>:
 80489c0:	ff 25 5c b1 04 08    	jmp    *0x804b15c
 80489c6:	68 e0 00 00 00       	push   $0xe0
 80489cb:	e9 20 fe ff ff       	jmp    80487f0 <_init+0x30>

080489d0 <gethostname@plt>:
 80489d0:	ff 25 60 b1 04 08    	jmp    *0x804b160
 80489d6:	68 e8 00 00 00       	push   $0xe8
 80489db:	e9 10 fe ff ff       	jmp    80487f0 <_init+0x30>

080489e0 <puts@plt>:
 80489e0:	ff 25 64 b1 04 08    	jmp    *0x804b164
 80489e6:	68 f0 00 00 00       	push   $0xf0
 80489eb:	e9 00 fe ff ff       	jmp    80487f0 <_init+0x30>

080489f0 <rand@plt>:
 80489f0:	ff 25 68 b1 04 08    	jmp    *0x804b168
 80489f6:	68 f8 00 00 00       	push   $0xf8
 80489fb:	e9 f0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a00 <bzero@plt>:
 8048a00:	ff 25 6c b1 04 08    	jmp    *0x804b16c
 8048a06:	68 00 01 00 00       	push   $0x100
 8048a0b:	e9 e0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a10 <munmap@plt>:
 8048a10:	ff 25 70 b1 04 08    	jmp    *0x804b170
 8048a16:	68 08 01 00 00       	push   $0x108
 8048a1b:	e9 d0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a20 <strdup@plt>:
 8048a20:	ff 25 74 b1 04 08    	jmp    *0x804b174
 8048a26:	68 10 01 00 00       	push   $0x110
 8048a2b:	e9 c0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a30 <gethostbyname@plt>:
 8048a30:	ff 25 78 b1 04 08    	jmp    *0x804b178
 8048a36:	68 18 01 00 00       	push   $0x118
 8048a3b:	e9 b0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a40 <strcmp@plt>:
 8048a40:	ff 25 7c b1 04 08    	jmp    *0x804b17c
 8048a46:	68 20 01 00 00       	push   $0x120
 8048a4b:	e9 a0 fd ff ff       	jmp    80487f0 <_init+0x30>

08048a50 <exit@plt>:
 8048a50:	ff 25 80 b1 04 08    	jmp    *0x804b180
 8048a56:	68 28 01 00 00       	push   $0x128
 8048a5b:	e9 90 fd ff ff       	jmp    80487f0 <_init+0x30>

Disassembly of section .text:

08048a60 <_start>:
 8048a60:	31 ed                	xor    %ebp,%ebp
 8048a62:	5e                   	pop    %esi
 8048a63:	89 e1                	mov    %esp,%ecx
 8048a65:	83 e4 f0             	and    $0xfffffff0,%esp
 8048a68:	50                   	push   %eax
 8048a69:	54                   	push   %esp
 8048a6a:	52                   	push   %edx
 8048a6b:	68 90 a0 04 08       	push   $0x804a090
 8048a70:	68 a0 a0 04 08       	push   $0x804a0a0
 8048a75:	51                   	push   %ecx
 8048a76:	56                   	push   %esi
 8048a77:	68 38 90 04 08       	push   $0x8049038
 8048a7c:	e8 4f fe ff ff       	call   80488d0 <__libc_start_main@plt>
 8048a81:	f4                   	hlt    
 8048a82:	90                   	nop
 8048a83:	90                   	nop
 8048a84:	90                   	nop
 8048a85:	90                   	nop
 8048a86:	90                   	nop
 8048a87:	90                   	nop
 8048a88:	90                   	nop
 8048a89:	90                   	nop
 8048a8a:	90                   	nop
 8048a8b:	90                   	nop
 8048a8c:	90                   	nop
 8048a8d:	90                   	nop
 8048a8e:	90                   	nop
 8048a8f:	90                   	nop

08048a90 <__do_global_dtors_aux>:
 8048a90:	55                   	push   %ebp
 8048a91:	89 e5                	mov    %esp,%ebp
 8048a93:	53                   	push   %ebx
 8048a94:	83 ec 04             	sub    $0x4,%esp
 8048a97:	80 3d ec c1 04 08 00 	cmpb   $0x0,0x804c1ec
 8048a9e:	75 3f                	jne    8048adf <__do_global_dtors_aux+0x4f>
 8048aa0:	a1 f0 c1 04 08       	mov    0x804c1f0,%eax
 8048aa5:	bb 0c b0 04 08       	mov    $0x804b00c,%ebx
 8048aaa:	81 eb 08 b0 04 08    	sub    $0x804b008,%ebx
 8048ab0:	c1 fb 02             	sar    $0x2,%ebx
 8048ab3:	83 eb 01             	sub    $0x1,%ebx
 8048ab6:	39 d8                	cmp    %ebx,%eax
 8048ab8:	73 1e                	jae    8048ad8 <__do_global_dtors_aux+0x48>
 8048aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8048ac0:	83 c0 01             	add    $0x1,%eax
 8048ac3:	a3 f0 c1 04 08       	mov    %eax,0x804c1f0
 8048ac8:	ff 14 85 08 b0 04 08 	call   *0x804b008(,%eax,4)
 8048acf:	a1 f0 c1 04 08       	mov    0x804c1f0,%eax
 8048ad4:	39 d8                	cmp    %ebx,%eax
 8048ad6:	72 e8                	jb     8048ac0 <__do_global_dtors_aux+0x30>
 8048ad8:	c6 05 ec c1 04 08 01 	movb   $0x1,0x804c1ec
 8048adf:	83 c4 04             	add    $0x4,%esp
 8048ae2:	5b                   	pop    %ebx
 8048ae3:	5d                   	pop    %ebp
 8048ae4:	c3                   	ret    
 8048ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

08048af0 <frame_dummy>:
 8048af0:	55                   	push   %ebp
 8048af1:	89 e5                	mov    %esp,%ebp
 8048af3:	83 ec 18             	sub    $0x18,%esp
 8048af6:	a1 10 b0 04 08       	mov    0x804b010,%eax
 8048afb:	85 c0                	test   %eax,%eax
 8048afd:	74 12                	je     8048b11 <frame_dummy+0x21>
 8048aff:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b04:	85 c0                	test   %eax,%eax
 8048b06:	74 09                	je     8048b11 <frame_dummy+0x21>
 8048b08:	c7 04 24 10 b0 04 08 	movl   $0x804b010,(%esp)
 8048b0f:	ff d0                	call   *%eax
 8048b11:	c9                   	leave  
 8048b12:	c3                   	ret    
 8048b13:	90                   	nop

08048b14 <smoke>:
 8048b14:	55                   	push   %ebp
 8048b15:	89 e5                	mov    %esp,%ebp
 8048b17:	83 ec 18             	sub    $0x18,%esp
 8048b1a:	c7 04 24 54 a1 04 08 	movl   $0x804a154,(%esp)
 8048b21:	e8 ba fe ff ff       	call   80489e0 <puts@plt>
 8048b26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048b2d:	e8 b3 08 00 00       	call   80493e5 <validate>
 8048b32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048b39:	e8 12 ff ff ff       	call   8048a50 <exit@plt>

08048b3e <fizz>:
 8048b3e:	55                   	push   %ebp
 8048b3f:	89 e5                	mov    %esp,%ebp
 8048b41:	83 ec 18             	sub    $0x18,%esp
 8048b44:	8b 55 08             	mov    0x8(%ebp),%edx
 8048b47:	a1 04 c2 04 08       	mov    0x804c204,%eax
 8048b4c:	39 c2                	cmp    %eax,%edx
 8048b4e:	75 22                	jne    8048b72 <fizz+0x34>
 8048b50:	b8 6f a1 04 08       	mov    $0x804a16f,%eax
 8048b55:	8b 55 08             	mov    0x8(%ebp),%edx
 8048b58:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048b5c:	89 04 24             	mov    %eax,(%esp)
 8048b5f:	e8 1c fe ff ff       	call   8048980 <printf@plt>
 8048b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048b6b:	e8 75 08 00 00       	call   80493e5 <validate>
 8048b70:	eb 14                	jmp    8048b86 <fizz+0x48>
 8048b72:	b8 90 a1 04 08       	mov    $0x804a190,%eax
 8048b77:	8b 55 08             	mov    0x8(%ebp),%edx
 8048b7a:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048b7e:	89 04 24             	mov    %eax,(%esp)
 8048b81:	e8 fa fd ff ff       	call   8048980 <printf@plt>
 8048b86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048b8d:	e8 be fe ff ff       	call   8048a50 <exit@plt>

08048b92 <bang>:
 8048b92:	55                   	push   %ebp
 8048b93:	89 e5                	mov    %esp,%ebp
 8048b95:	83 ec 18             	sub    $0x18,%esp
 8048b98:	a1 0c c2 04 08       	mov    0x804c20c,%eax
 8048b9d:	89 c2                	mov    %eax,%edx
 8048b9f:	a1 04 c2 04 08       	mov    0x804c204,%eax
 8048ba4:	39 c2                	cmp    %eax,%edx
 8048ba6:	75 25                	jne    8048bcd <bang+0x3b>
 8048ba8:	8b 15 0c c2 04 08    	mov    0x804c20c,%edx
 8048bae:	b8 b0 a1 04 08       	mov    $0x804a1b0,%eax
 8048bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048bb7:	89 04 24             	mov    %eax,(%esp)
 8048bba:	e8 c1 fd ff ff       	call   8048980 <printf@plt>
 8048bbf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8048bc6:	e8 1a 08 00 00       	call   80493e5 <validate>
 8048bcb:	eb 17                	jmp    8048be4 <bang+0x52>
 8048bcd:	8b 15 0c c2 04 08    	mov    0x804c20c,%edx
 8048bd3:	b8 d5 a1 04 08       	mov    $0x804a1d5,%eax
 8048bd8:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048bdc:	89 04 24             	mov    %eax,(%esp)
 8048bdf:	e8 9c fd ff ff       	call   8048980 <printf@plt>
 8048be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048beb:	e8 60 fe ff ff       	call   8048a50 <exit@plt>

08048bf0 <test>:
 8048bf0:	55                   	push   %ebp
 8048bf1:	89 e5                	mov    %esp,%ebp
 8048bf3:	83 ec 28             	sub    $0x28,%esp
 8048bf6:	e8 23 04 00 00       	call   804901e <uniqueval>
 8048bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048bfe:	e8 75 06 00 00       	call   8049278 <getbuf>
 8048c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048c06:	e8 13 04 00 00       	call   804901e <uniqueval>
 8048c0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048c0e:	39 d0                	cmp    %edx,%eax
 8048c10:	74 0e                	je     8048c20 <test+0x30>
 8048c12:	c7 04 24 f4 a1 04 08 	movl   $0x804a1f4,(%esp)
 8048c19:	e8 c2 fd ff ff       	call   80489e0 <puts@plt>
 8048c1e:	eb 42                	jmp    8048c62 <test+0x72>
 8048c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048c23:	a1 04 c2 04 08       	mov    0x804c204,%eax
 8048c28:	39 c2                	cmp    %eax,%edx
 8048c2a:	75 22                	jne    8048c4e <test+0x5e>
 8048c2c:	b8 1d a2 04 08       	mov    $0x804a21d,%eax
 8048c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048c34:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048c38:	89 04 24             	mov    %eax,(%esp)
 8048c3b:	e8 40 fd ff ff       	call   8048980 <printf@plt>
 8048c40:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 8048c47:	e8 99 07 00 00       	call   80493e5 <validate>
 8048c4c:	eb 14                	jmp    8048c62 <test+0x72>
 8048c4e:	b8 3a a2 04 08       	mov    $0x804a23a,%eax
 8048c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048c56:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048c5a:	89 04 24             	mov    %eax,(%esp)
 8048c5d:	e8 1e fd ff ff       	call   8048980 <printf@plt>
 8048c62:	c9                   	leave  
 8048c63:	c3                   	ret    

08048c64 <testn>:
 8048c64:	55                   	push   %ebp
 8048c65:	89 e5                	mov    %esp,%ebp
 8048c67:	83 ec 28             	sub    $0x28,%esp
 8048c6a:	e8 af 03 00 00       	call   804901e <uniqueval>
 8048c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048c72:	e8 19 06 00 00       	call   8049290 <getbufn>
 8048c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048c7a:	e8 9f 03 00 00       	call   804901e <uniqueval>
 8048c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048c82:	39 d0                	cmp    %edx,%eax
 8048c84:	74 0e                	je     8048c94 <testn+0x30>
 8048c86:	c7 04 24 f4 a1 04 08 	movl   $0x804a1f4,(%esp)
 8048c8d:	e8 4e fd ff ff       	call   80489e0 <puts@plt>
 8048c92:	eb 42                	jmp    8048cd6 <testn+0x72>
 8048c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048c97:	a1 04 c2 04 08       	mov    0x804c204,%eax
 8048c9c:	39 c2                	cmp    %eax,%edx
 8048c9e:	75 22                	jne    8048cc2 <testn+0x5e>
 8048ca0:	b8 58 a2 04 08       	mov    $0x804a258,%eax
 8048ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048ca8:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048cac:	89 04 24             	mov    %eax,(%esp)
 8048caf:	e8 cc fc ff ff       	call   8048980 <printf@plt>
 8048cb4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 8048cbb:	e8 25 07 00 00       	call   80493e5 <validate>
 8048cc0:	eb 14                	jmp    8048cd6 <testn+0x72>
 8048cc2:	b8 78 a2 04 08       	mov    $0x804a278,%eax
 8048cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048cca:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048cce:	89 04 24             	mov    %eax,(%esp)
 8048cd1:	e8 aa fc ff ff       	call   8048980 <printf@plt>
 8048cd6:	c9                   	leave  
 8048cd7:	c3                   	ret    

08048cd8 <save_char>:
 8048cd8:	55                   	push   %ebp
 8048cd9:	89 e5                	mov    %esp,%ebp
 8048cdb:	83 ec 04             	sub    $0x4,%esp
 8048cde:	8b 45 08             	mov    0x8(%ebp),%eax
 8048ce1:	88 45 fc             	mov    %al,-0x4(%ebp)
 8048ce4:	a1 10 c2 04 08       	mov    0x804c210,%eax
 8048ce9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
 8048cee:	7f 6a                	jg     8048d5a <save_char+0x82>
 8048cf0:	8b 15 10 c2 04 08    	mov    0x804c210,%edx
 8048cf6:	89 d0                	mov    %edx,%eax
 8048cf8:	01 c0                	add    %eax,%eax
 8048cfa:	8d 14 10             	lea    (%eax,%edx,1),%edx
 8048cfd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 8048d01:	c0 e8 04             	shr    $0x4,%al
 8048d04:	0f be c0             	movsbl %al,%eax
 8048d07:	0f b6 80 a4 b1 04 08 	movzbl 0x804b1a4(%eax),%eax
 8048d0e:	88 82 20 c2 04 08    	mov    %al,0x804c220(%edx)
 8048d14:	8b 15 10 c2 04 08    	mov    0x804c210,%edx
 8048d1a:	89 d0                	mov    %edx,%eax
 8048d1c:	01 c0                	add    %eax,%eax
 8048d1e:	01 d0                	add    %edx,%eax
 8048d20:	8d 50 01             	lea    0x1(%eax),%edx
 8048d23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048d27:	83 e0 0f             	and    $0xf,%eax
 8048d2a:	0f b6 80 a4 b1 04 08 	movzbl 0x804b1a4(%eax),%eax
 8048d31:	88 82 20 c2 04 08    	mov    %al,0x804c220(%edx)
 8048d37:	8b 15 10 c2 04 08    	mov    0x804c210,%edx
 8048d3d:	89 d0                	mov    %edx,%eax
 8048d3f:	01 c0                	add    %eax,%eax
 8048d41:	01 d0                	add    %edx,%eax
 8048d43:	83 c0 02             	add    $0x2,%eax
 8048d46:	c6 80 20 c2 04 08 20 	movb   $0x20,0x804c220(%eax)
 8048d4d:	a1 10 c2 04 08       	mov    0x804c210,%eax
 8048d52:	83 c0 01             	add    $0x1,%eax
 8048d55:	a3 10 c2 04 08       	mov    %eax,0x804c210
 8048d5a:	c9                   	leave  
 8048d5b:	c3                   	ret    

08048d5c <save_term>:
 8048d5c:	55                   	push   %ebp
 8048d5d:	89 e5                	mov    %esp,%ebp
 8048d5f:	8b 15 10 c2 04 08    	mov    0x804c210,%edx
 8048d65:	89 d0                	mov    %edx,%eax
 8048d67:	01 c0                	add    %eax,%eax
 8048d69:	01 d0                	add    %edx,%eax
 8048d6b:	c6 80 20 c2 04 08 00 	movb   $0x0,0x804c220(%eax)
 8048d72:	5d                   	pop    %ebp
 8048d73:	c3                   	ret    

08048d74 <Gets>:
 8048d74:	55                   	push   %ebp
 8048d75:	89 e5                	mov    %esp,%ebp
 8048d77:	83 ec 28             	sub    $0x28,%esp
 8048d7a:	8b 45 08             	mov    0x8(%ebp),%eax
 8048d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048d80:	c7 05 10 c2 04 08 00 	movl   $0x0,0x804c210
 8048d87:	00 00 00 
 8048d8a:	eb 1c                	jmp    8048da8 <Gets+0x34>
 8048d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048d8f:	89 c2                	mov    %eax,%edx
 8048d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d94:	88 10                	mov    %dl,(%eax)
 8048d96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048d9d:	0f be c0             	movsbl %al,%eax
 8048da0:	89 04 24             	mov    %eax,(%esp)
 8048da3:	e8 30 ff ff ff       	call   8048cd8 <save_char>
 8048da8:	a1 00 c2 04 08       	mov    0x804c200,%eax
 8048dad:	89 04 24             	mov    %eax,(%esp)
 8048db0:	e8 2b fb ff ff       	call   80488e0 <_IO_getc@plt>
 8048db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048db8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 8048dbc:	74 06                	je     8048dc4 <Gets+0x50>
 8048dbe:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
 8048dc2:	75 c8                	jne    8048d8c <Gets+0x18>
 8048dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dc7:	c6 00 00             	movb   $0x0,(%eax)
 8048dca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048dce:	e8 89 ff ff ff       	call   8048d5c <save_term>
 8048dd3:	8b 45 08             	mov    0x8(%ebp),%eax
 8048dd6:	c9                   	leave  
 8048dd7:	c3                   	ret    

08048dd8 <usage>:
 8048dd8:	55                   	push   %ebp
 8048dd9:	89 e5                	mov    %esp,%ebp
 8048ddb:	83 ec 18             	sub    $0x18,%esp
 8048dde:	b8 94 a2 04 08       	mov    $0x804a294,%eax
 8048de3:	8b 55 08             	mov    0x8(%ebp),%edx
 8048de6:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048dea:	89 04 24             	mov    %eax,(%esp)
 8048ded:	e8 8e fb ff ff       	call   8048980 <printf@plt>
 8048df2:	c7 04 24 b2 a2 04 08 	movl   $0x804a2b2,(%esp)
 8048df9:	e8 e2 fb ff ff       	call   80489e0 <puts@plt>
 8048dfe:	c7 04 24 c8 a2 04 08 	movl   $0x804a2c8,(%esp)
 8048e05:	e8 d6 fb ff ff       	call   80489e0 <puts@plt>
 8048e0a:	c7 04 24 e4 a2 04 08 	movl   $0x804a2e4,(%esp)
 8048e11:	e8 ca fb ff ff       	call   80489e0 <puts@plt>
 8048e16:	c7 04 24 20 a3 04 08 	movl   $0x804a320,(%esp)
 8048e1d:	e8 be fb ff ff       	call   80489e0 <puts@plt>
 8048e22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048e29:	e8 22 fc ff ff       	call   8048a50 <exit@plt>

08048e2e <bushandler>:
 8048e2e:	55                   	push   %ebp
 8048e2f:	89 e5                	mov    %esp,%ebp
 8048e31:	83 ec 18             	sub    $0x18,%esp
 8048e34:	c7 04 24 48 a3 04 08 	movl   $0x804a348,(%esp)
 8048e3b:	e8 a0 fb ff ff       	call   80489e0 <puts@plt>
 8048e40:	c7 04 24 68 a3 04 08 	movl   $0x804a368,(%esp)
 8048e47:	e8 94 fb ff ff       	call   80489e0 <puts@plt>
 8048e4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048e53:	e8 f8 fb ff ff       	call   8048a50 <exit@plt>

08048e58 <seghandler>:
 8048e58:	55                   	push   %ebp
 8048e59:	89 e5                	mov    %esp,%ebp
 8048e5b:	83 ec 18             	sub    $0x18,%esp
 8048e5e:	c7 04 24 80 a3 04 08 	movl   $0x804a380,(%esp)
 8048e65:	e8 76 fb ff ff       	call   80489e0 <puts@plt>
 8048e6a:	c7 04 24 68 a3 04 08 	movl   $0x804a368,(%esp)
 8048e71:	e8 6a fb ff ff       	call   80489e0 <puts@plt>
 8048e76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048e7d:	e8 ce fb ff ff       	call   8048a50 <exit@plt>

08048e82 <illegalhandler>:
 8048e82:	55                   	push   %ebp
 8048e83:	89 e5                	mov    %esp,%ebp
 8048e85:	83 ec 18             	sub    $0x18,%esp
 8048e88:	c7 04 24 a8 a3 04 08 	movl   $0x804a3a8,(%esp)
 8048e8f:	e8 4c fb ff ff       	call   80489e0 <puts@plt>
 8048e94:	c7 04 24 68 a3 04 08 	movl   $0x804a368,(%esp)
 8048e9b:	e8 40 fb ff ff       	call   80489e0 <puts@plt>
 8048ea0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048ea7:	e8 a4 fb ff ff       	call   8048a50 <exit@plt>

08048eac <launch>:
 8048eac:	55                   	push   %ebp
 8048ead:	89 e5                	mov    %esp,%ebp
 8048eaf:	83 ec 68             	sub    $0x68,%esp
 8048eb2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048eb9:	8d 45 b0             	lea    -0x50(%ebp),%eax
 8048ebc:	25 f0 3f 00 00       	and    $0x3ff0,%eax
 8048ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8048ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048ec7:	03 45 f0             	add    -0x10(%ebp),%eax
 8048eca:	83 c0 0f             	add    $0xf,%eax
 8048ecd:	83 c0 0f             	add    $0xf,%eax
 8048ed0:	c1 e8 04             	shr    $0x4,%eax
 8048ed3:	c1 e0 04             	shl    $0x4,%eax
 8048ed6:	29 c4                	sub    %eax,%esp
 8048ed8:	8d 44 24 0c          	lea    0xc(%esp),%eax
 8048edc:	83 c0 0f             	add    $0xf,%eax
 8048edf:	c1 e8 04             	shr    $0x4,%eax
 8048ee2:	c1 e0 04             	shl    $0x4,%eax
 8048ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048eeb:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048eef:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
 8048ef6:	00 
 8048ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048efa:	89 04 24             	mov    %eax,(%esp)
 8048efd:	e8 be f9 ff ff       	call   80488c0 <memset@plt>
 8048f02:	b8 d3 a3 04 08       	mov    $0x804a3d3,%eax
 8048f07:	89 04 24             	mov    %eax,(%esp)
 8048f0a:	e8 71 fa ff ff       	call   8048980 <printf@plt>
 8048f0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048f13:	74 07                	je     8048f1c <launch+0x70>
 8048f15:	e8 4a fd ff ff       	call   8048c64 <testn>
 8048f1a:	eb 05                	jmp    8048f21 <launch+0x75>
 8048f1c:	e8 cf fc ff ff       	call   8048bf0 <test>
 8048f21:	a1 08 c2 04 08       	mov    0x804c208,%eax
 8048f26:	85 c0                	test   %eax,%eax
 8048f28:	75 16                	jne    8048f40 <launch+0x94>
 8048f2a:	c7 04 24 68 a3 04 08 	movl   $0x804a368,(%esp)
 8048f31:	e8 aa fa ff ff       	call   80489e0 <puts@plt>
 8048f36:	c7 05 08 c2 04 08 00 	movl   $0x0,0x804c208
 8048f3d:	00 00 00 
 8048f40:	c9                   	leave  
 8048f41:	c3                   	ret    

08048f42 <launcher>:
 8048f42:	55                   	push   %ebp
 8048f43:	89 e5                	mov    %esp,%ebp
 8048f45:	83 ec 38             	sub    $0x38,%esp
 8048f48:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f4b:	a3 14 c2 04 08       	mov    %eax,0x804c214
 8048f50:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048f53:	a3 18 c2 04 08       	mov    %eax,0x804c218
 8048f58:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
 8048f5f:	00 
 8048f60:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
 8048f67:	00 
 8048f68:	c7 44 24 0c 32 01 00 	movl   $0x132,0xc(%esp)
 8048f6f:	00 
 8048f70:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
 8048f77:	00 
 8048f78:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
 8048f7f:	00 
 8048f80:	c7 04 24 00 60 58 55 	movl   $0x55586000,(%esp)
 8048f87:	e8 b4 f8 ff ff       	call   8048840 <mmap@plt>
 8048f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048f8f:	81 7d f4 00 60 58 55 	cmpl   $0x55586000,-0xc(%ebp)
 8048f96:	74 34                	je     8048fcc <launcher+0x8a>
 8048f98:	a1 e0 c1 04 08       	mov    0x804c1e0,%eax
 8048f9d:	89 c2                	mov    %eax,%edx
 8048f9f:	b8 e0 a3 04 08       	mov    $0x804a3e0,%eax
 8048fa4:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8048fa8:	c7 44 24 08 47 00 00 	movl   $0x47,0x8(%esp)
 8048faf:	00 
 8048fb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8048fb7:	00 
 8048fb8:	89 04 24             	mov    %eax,(%esp)
 8048fbb:	e8 00 fa ff ff       	call   80489c0 <fwrite@plt>
 8048fc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048fc7:	e8 84 fa ff ff       	call   8048a50 <exit@plt>
 8048fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fcf:	05 f8 ff 0f 00       	add    $0xffff8,%eax
 8048fd4:	a3 24 ce 04 08       	mov    %eax,0x804ce24
 8048fd9:	8b 15 24 ce 04 08    	mov    0x804ce24,%edx
 8048fdf:	89 e0                	mov    %esp,%eax
 8048fe1:	89 d4                	mov    %edx,%esp
 8048fe3:	89 c2                	mov    %eax,%edx
 8048fe5:	89 15 1c c2 04 08    	mov    %edx,0x804c21c
 8048feb:	8b 15 18 c2 04 08    	mov    0x804c218,%edx
 8048ff1:	a1 14 c2 04 08       	mov    0x804c214,%eax
 8048ff6:	89 54 24 04          	mov    %edx,0x4(%esp)
 8048ffa:	89 04 24             	mov    %eax,(%esp)
 8048ffd:	e8 aa fe ff ff       	call   8048eac <launch>
 8049002:	a1 1c c2 04 08       	mov    0x804c21c,%eax
 8049007:	89 c4                	mov    %eax,%esp
 8049009:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
 8049010:	00 
 8049011:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049014:	89 04 24             	mov    %eax,(%esp)
 8049017:	e8 f4 f9 ff ff       	call   8048a10 <munmap@plt>
 804901c:	c9                   	leave  
 804901d:	c3                   	ret    

0804901e <uniqueval>:
 804901e:	55                   	push   %ebp
 804901f:	89 e5                	mov    %esp,%ebp
 8049021:	83 ec 18             	sub    $0x18,%esp
 8049024:	e8 27 f8 ff ff       	call   8048850 <getpid@plt>
 8049029:	89 04 24             	mov    %eax,(%esp)
 804902c:	e8 6f f9 ff ff       	call   80489a0 <srandom@plt>
 8049031:	e8 2a f8 ff ff       	call   8048860 <random@plt>
 8049036:	c9                   	leave  
 8049037:	c3                   	ret    

08049038 <main>:
 8049038:	55                   	push   %ebp
 8049039:	89 e5                	mov    %esp,%ebp
 804903b:	83 e4 f0             	and    $0xfffffff0,%esp
 804903e:	53                   	push   %ebx
 804903f:	83 ec 3c             	sub    $0x3c,%esp
 8049042:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 8049049:	00 
 804904a:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 8049051:	00 
 8049052:	c7 44 24 28 01 00 00 	movl   $0x1,0x28(%esp)
 8049059:	00 
 804905a:	c7 44 24 04 58 8e 04 	movl   $0x8048e58,0x4(%esp)
 8049061:	08 
 8049062:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
 8049069:	e8 02 f8 ff ff       	call   8048870 <signal@plt>
 804906e:	c7 44 24 04 2e 8e 04 	movl   $0x8048e2e,0x4(%esp)
 8049075:	08 
 8049076:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 804907d:	e8 ee f7 ff ff       	call   8048870 <signal@plt>
 8049082:	c7 44 24 04 82 8e 04 	movl   $0x8048e82,0x4(%esp)
 8049089:	08 
 804908a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 8049091:	e8 da f7 ff ff       	call   8048870 <signal@plt>
 8049096:	a1 e4 c1 04 08       	mov    0x804c1e4,%eax
 804909b:	a3 00 c2 04 08       	mov    %eax,0x804c200
 80490a0:	e9 83 00 00 00       	jmp    8049128 <main+0xf0>
 80490a5:	0f be 44 24 2f       	movsbl 0x2f(%esp),%eax
 80490aa:	83 e8 67             	sub    $0x67,%eax
 80490ad:	83 f8 0e             	cmp    $0xe,%eax
 80490b0:	77 69                	ja     804911b <main+0xe3>
 80490b2:	8b 04 85 78 a4 04 08 	mov    0x804a478(,%eax,4),%eax
 80490b9:	ff e0                	jmp    *%eax
 80490bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 80490be:	8b 00                	mov    (%eax),%eax
 80490c0:	89 04 24             	mov    %eax,(%esp)
 80490c3:	e8 10 fd ff ff       	call   8048dd8 <usage>
 80490c8:	eb 5e                	jmp    8049128 <main+0xf0>
 80490ca:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 80490d1:	00 
 80490d2:	c7 44 24 28 05 00 00 	movl   $0x5,0x28(%esp)
 80490d9:	00 
 80490da:	eb 4c                	jmp    8049128 <main+0xf0>
 80490dc:	a1 e8 c1 04 08       	mov    0x804c1e8,%eax
 80490e1:	89 04 24             	mov    %eax,(%esp)
 80490e4:	e8 37 f9 ff ff       	call   8048a20 <strdup@plt>
 80490e9:	a3 f4 c1 04 08       	mov    %eax,0x804c1f4
 80490ee:	a1 f4 c1 04 08       	mov    0x804c1f4,%eax
 80490f3:	89 04 24             	mov    %eax,(%esp)
 80490f6:	e8 5d 0f 00 00       	call   804a058 <gencookie>
 80490fb:	a3 04 c2 04 08       	mov    %eax,0x804c204
 8049100:	eb 26                	jmp    8049128 <main+0xf0>
 8049102:	90                   	nop
 8049103:	c7 05 f8 c1 04 08 01 	movl   $0x1,0x804c1f8
 804910a:	00 00 00 
 804910d:	eb 19                	jmp    8049128 <main+0xf0>
 804910f:	c7 05 fc c1 04 08 01 	movl   $0x1,0x804c1fc
 8049116:	00 00 00 
 8049119:	eb 0d                	jmp    8049128 <main+0xf0>
 804911b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804911e:	8b 00                	mov    (%eax),%eax
 8049120:	89 04 24             	mov    %eax,(%esp)
 8049123:	e8 b0 fc ff ff       	call   8048dd8 <usage>
 8049128:	c7 44 24 08 28 a4 04 	movl   $0x804a428,0x8(%esp)
 804912f:	08 
 8049130:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049133:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049137:	8b 45 08             	mov    0x8(%ebp),%eax
 804913a:	89 04 24             	mov    %eax,(%esp)
 804913d:	e8 ee f7 ff ff       	call   8048930 <getopt@plt>
 8049142:	88 44 24 2f          	mov    %al,0x2f(%esp)
 8049146:	80 7c 24 2f ff       	cmpb   $0xff,0x2f(%esp)
 804914b:	0f 85 54 ff ff ff    	jne    80490a5 <main+0x6d>
 8049151:	a1 f4 c1 04 08       	mov    0x804c1f4,%eax
 8049156:	85 c0                	test   %eax,%eax
 8049158:	75 23                	jne    804917d <main+0x145>
 804915a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804915d:	8b 10                	mov    (%eax),%edx
 804915f:	b8 30 a4 04 08       	mov    $0x804a430,%eax
 8049164:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049168:	89 04 24             	mov    %eax,(%esp)
 804916b:	e8 10 f8 ff ff       	call   8048980 <printf@plt>
 8049170:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049173:	8b 00                	mov    (%eax),%eax
 8049175:	89 04 24             	mov    %eax,(%esp)
 8049178:	e8 5b fc ff ff       	call   8048dd8 <usage>
 804917d:	e8 2e 01 00 00       	call   80492b0 <initialize_bomb>
 8049182:	8b 15 f4 c1 04 08    	mov    0x804c1f4,%edx
 8049188:	b8 5c a4 04 08       	mov    $0x804a45c,%eax
 804918d:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049191:	89 04 24             	mov    %eax,(%esp)
 8049194:	e8 e7 f7 ff ff       	call   8048980 <printf@plt>
 8049199:	8b 15 04 c2 04 08    	mov    0x804c204,%edx
 804919f:	b8 68 a4 04 08       	mov    $0x804a468,%eax
 80491a4:	89 54 24 04          	mov    %edx,0x4(%esp)
 80491a8:	89 04 24             	mov    %eax,(%esp)
 80491ab:	e8 d0 f7 ff ff       	call   8048980 <printf@plt>
 80491b0:	a1 04 c2 04 08       	mov    0x804c204,%eax
 80491b5:	89 04 24             	mov    %eax,(%esp)
 80491b8:	e8 e3 f7 ff ff       	call   80489a0 <srandom@plt>
 80491bd:	e8 9e f6 ff ff       	call   8048860 <random@plt>
 80491c2:	25 f0 0f 00 00       	and    $0xff0,%eax
 80491c7:	05 00 01 00 00       	add    $0x100,%eax
 80491cc:	89 44 24 18          	mov    %eax,0x18(%esp)
 80491d0:	8b 44 24 28          	mov    0x28(%esp),%eax
 80491d4:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 80491db:	00 
 80491dc:	89 04 24             	mov    %eax,(%esp)
 80491df:	e8 bc f6 ff ff       	call   80488a0 <calloc@plt>
 80491e4:	89 44 24 24          	mov    %eax,0x24(%esp)
 80491e8:	8b 44 24 24          	mov    0x24(%esp),%eax
 80491ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 80491f2:	c7 44 24 20 01 00 00 	movl   $0x1,0x20(%esp)
 80491f9:	00 
 80491fa:	eb 28                	jmp    8049224 <main+0x1ec>
 80491fc:	8b 44 24 20          	mov    0x20(%esp),%eax
 8049200:	c1 e0 02             	shl    $0x2,%eax
 8049203:	89 c3                	mov    %eax,%ebx
 8049205:	03 5c 24 24          	add    0x24(%esp),%ebx
 8049209:	e8 52 f6 ff ff       	call   8048860 <random@plt>
 804920e:	89 c2                	mov    %eax,%edx
 8049210:	81 e2 f0 00 00 00    	and    $0xf0,%edx
 8049216:	b8 80 00 00 00       	mov    $0x80,%eax
 804921b:	29 d0                	sub    %edx,%eax
 804921d:	89 03                	mov    %eax,(%ebx)
 804921f:	83 44 24 20 01       	addl   $0x1,0x20(%esp)
 8049224:	8b 44 24 20          	mov    0x20(%esp),%eax
 8049228:	3b 44 24 28          	cmp    0x28(%esp),%eax
 804922c:	7c ce                	jl     80491fc <main+0x1c4>
 804922e:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
 8049235:	00 
 8049236:	eb 26                	jmp    804925e <main+0x226>
 8049238:	8b 44 24 20          	mov    0x20(%esp),%eax
 804923c:	c1 e0 02             	shl    $0x2,%eax
 804923f:	03 44 24 24          	add    0x24(%esp),%eax
 8049243:	8b 00                	mov    (%eax),%eax
 8049245:	03 44 24 18          	add    0x18(%esp),%eax
 8049249:	89 44 24 04          	mov    %eax,0x4(%esp)
 804924d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 8049251:	89 04 24             	mov    %eax,(%esp)
 8049254:	e8 e9 fc ff ff       	call   8048f42 <launcher>
 8049259:	83 44 24 20 01       	addl   $0x1,0x20(%esp)
 804925e:	8b 44 24 20          	mov    0x20(%esp),%eax
 8049262:	3b 44 24 28          	cmp    0x28(%esp),%eax
 8049266:	7c d0                	jl     8049238 <main+0x200>
 8049268:	b8 00 00 00 00       	mov    $0x0,%eax
 804926d:	83 c4 3c             	add    $0x3c,%esp
 8049270:	5b                   	pop    %ebx
 8049271:	89 ec                	mov    %ebp,%esp
 8049273:	5d                   	pop    %ebp
 8049274:	c3                   	ret    
 8049275:	90                   	nop
 8049276:	90                   	nop
 8049277:	90                   	nop

08049278 <getbuf>:
 8049278:	55                   	push   %ebp
 8049279:	89 e5                	mov    %esp,%ebp
 804927b:	83 ec 38             	sub    $0x38,%esp
 804927e:	8d 45 d8             	lea    -0x28(%ebp),%eax
 8049281:	89 04 24             	mov    %eax,(%esp)
 8049284:	e8 eb fa ff ff       	call   8048d74 <Gets>
 8049289:	b8 01 00 00 00       	mov    $0x1,%eax
 804928e:	c9                   	leave  
 804928f:	c3                   	ret    

08049290 <getbufn>:
 8049290:	55                   	push   %ebp
 8049291:	89 e5                	mov    %esp,%ebp
 8049293:	81 ec 18 02 00 00    	sub    $0x218,%esp
 8049299:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 804929f:	89 04 24             	mov    %eax,(%esp)
 80492a2:	e8 cd fa ff ff       	call   8048d74 <Gets>
 80492a7:	b8 01 00 00 00       	mov    $0x1,%eax
 80492ac:	c9                   	leave  
 80492ad:	c3                   	ret    
 80492ae:	90                   	nop
 80492af:	90                   	nop

080492b0 <initialize_bomb>:
 80492b0:	55                   	push   %ebp
 80492b1:	89 e5                	mov    %esp,%ebp
 80492b3:	81 ec 28 24 00 00    	sub    $0x2428,%esp
 80492b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80492c0:	a1 fc c1 04 08       	mov    0x804c1fc,%eax
 80492c5:	85 c0                	test   %eax,%eax
 80492c7:	74 0c                	je     80492d5 <initialize_bomb+0x25>
 80492c9:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 80492d0:	e8 51 0a 00 00       	call   8049d26 <init_timeout>
 80492d5:	a1 f8 c1 04 08       	mov    0x804c1f8,%eax
 80492da:	85 c0                	test   %eax,%eax
 80492dc:	0f 84 01 01 00 00    	je     80493e3 <initialize_bomb+0x133>
 80492e2:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
 80492e9:	00 
 80492ea:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
 80492f0:	89 04 24             	mov    %eax,(%esp)
 80492f3:	e8 d8 f6 ff ff       	call   80489d0 <gethostname@plt>
 80492f8:	85 c0                	test   %eax,%eax
 80492fa:	74 18                	je     8049314 <initialize_bomb+0x64>
 80492fc:	c7 04 24 54 a5 04 08 	movl   $0x804a554,(%esp)
 8049303:	e8 d8 f6 ff ff       	call   80489e0 <puts@plt>
 8049308:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 804930f:	e8 3c f7 ff ff       	call   8048a50 <exit@plt>
 8049314:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804931b:	eb 2d                	jmp    804934a <initialize_bomb+0x9a>
 804931d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049320:	8b 04 85 c0 b1 04 08 	mov    0x804b1c0(,%eax,4),%eax
 8049327:	8d 95 f0 fb ff ff    	lea    -0x410(%ebp),%edx
 804932d:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049331:	89 04 24             	mov    %eax,(%esp)
 8049334:	e8 57 f6 ff ff       	call   8048990 <strcasecmp@plt>
 8049339:	85 c0                	test   %eax,%eax
 804933b:	75 09                	jne    8049346 <initialize_bomb+0x96>
 804933d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8049344:	eb 12                	jmp    8049358 <initialize_bomb+0xa8>
 8049346:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 804934a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804934d:	8b 04 85 c0 b1 04 08 	mov    0x804b1c0(,%eax,4),%eax
 8049354:	85 c0                	test   %eax,%eax
 8049356:	75 c5                	jne    804931d <initialize_bomb+0x6d>
 8049358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804935c:	75 50                	jne    80493ae <initialize_bomb+0xfe>
 804935e:	b8 8c a5 04 08       	mov    $0x804a58c,%eax
 8049363:	8d 95 f0 fb ff ff    	lea    -0x410(%ebp),%edx
 8049369:	89 54 24 04          	mov    %edx,0x4(%esp)
 804936d:	89 04 24             	mov    %eax,(%esp)
 8049370:	e8 0b f6 ff ff       	call   8048980 <printf@plt>
 8049375:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804937c:	eb 16                	jmp    8049394 <initialize_bomb+0xe4>
 804937e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049381:	8b 04 85 c0 b1 04 08 	mov    0x804b1c0(,%eax,4),%eax
 8049388:	89 04 24             	mov    %eax,(%esp)
 804938b:	e8 50 f6 ff ff       	call   80489e0 <puts@plt>
 8049390:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8049394:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049397:	8b 04 85 c0 b1 04 08 	mov    0x804b1c0(,%eax,4),%eax
 804939e:	85 c0                	test   %eax,%eax
 80493a0:	75 dc                	jne    804937e <initialize_bomb+0xce>
 80493a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80493a9:	e8 a2 f6 ff ff       	call   8048a50 <exit@plt>
 80493ae:	8d 85 f0 db ff ff    	lea    -0x2410(%ebp),%eax
 80493b4:	89 04 24             	mov    %eax,(%esp)
 80493b7:	e8 a7 09 00 00       	call   8049d63 <init_driver>
 80493bc:	85 c0                	test   %eax,%eax
 80493be:	79 23                	jns    80493e3 <initialize_bomb+0x133>
 80493c0:	b8 c7 a5 04 08       	mov    $0x804a5c7,%eax
 80493c5:	8d 95 f0 db ff ff    	lea    -0x2410(%ebp),%edx
 80493cb:	89 54 24 04          	mov    %edx,0x4(%esp)
 80493cf:	89 04 24             	mov    %eax,(%esp)
 80493d2:	e8 a9 f5 ff ff       	call   8048980 <printf@plt>
 80493d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80493de:	e8 6d f6 ff ff       	call   8048a50 <exit@plt>
 80493e3:	c9                   	leave  
 80493e4:	c3                   	ret    

080493e5 <validate>:
 80493e5:	55                   	push   %ebp
 80493e6:	89 e5                	mov    %esp,%ebp
 80493e8:	81 ec 38 40 00 00    	sub    $0x4038,%esp
 80493ee:	a1 f4 c1 04 08       	mov    0x804c1f4,%eax
 80493f3:	85 c0                	test   %eax,%eax
 80493f5:	75 11                	jne    8049408 <validate+0x23>
 80493f7:	c7 04 24 dc a5 04 08 	movl   $0x804a5dc,(%esp)
 80493fe:	e8 dd f5 ff ff       	call   80489e0 <puts@plt>
 8049403:	e9 2a 01 00 00       	jmp    8049532 <validate+0x14d>
 8049408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804940c:	78 06                	js     8049414 <validate+0x2f>
 804940e:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
 8049412:	7e 11                	jle    8049425 <validate+0x40>
 8049414:	c7 04 24 08 a6 04 08 	movl   $0x804a608,(%esp)
 804941b:	e8 c0 f5 ff ff       	call   80489e0 <puts@plt>
 8049420:	e9 0d 01 00 00       	jmp    8049532 <validate+0x14d>
 8049425:	c7 05 08 c2 04 08 01 	movl   $0x1,0x804c208
 804942c:	00 00 00 
 804942f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049432:	8b 14 85 c0 c1 04 08 	mov    0x804c1c0(,%eax,4),%edx
 8049439:	83 ea 01             	sub    $0x1,%edx
 804943c:	89 14 85 c0 c1 04 08 	mov    %edx,0x804c1c0(,%eax,4)
 8049443:	8b 04 85 c0 c1 04 08 	mov    0x804c1c0(,%eax,4),%eax
 804944a:	85 c0                	test   %eax,%eax
 804944c:	7e 11                	jle    804945f <validate+0x7a>
 804944e:	c7 04 24 2e a6 04 08 	movl   $0x804a62e,(%esp)
 8049455:	e8 86 f5 ff ff       	call   80489e0 <puts@plt>
 804945a:	e9 d3 00 00 00       	jmp    8049532 <validate+0x14d>
 804945f:	c7 04 24 39 a6 04 08 	movl   $0x804a639,(%esp)
 8049466:	e8 75 f5 ff ff       	call   80489e0 <puts@plt>
 804946b:	a1 f8 c1 04 08       	mov    0x804c1f8,%eax
 8049470:	85 c0                	test   %eax,%eax
 8049472:	0f 84 ae 00 00 00    	je     8049526 <validate+0x141>
 8049478:	c7 04 24 20 c2 04 08 	movl   $0x804c220,(%esp)
 804947f:	e8 cc f4 ff ff       	call   8048950 <strlen@plt>
 8049484:	83 c0 20             	add    $0x20,%eax
 8049487:	3d 00 20 00 00       	cmp    $0x2000,%eax
 804948c:	76 11                	jbe    804949f <validate+0xba>
 804948e:	c7 04 24 40 a6 04 08 	movl   $0x804a640,(%esp)
 8049495:	e8 46 f5 ff ff       	call   80489e0 <puts@plt>
 804949a:	e9 93 00 00 00       	jmp    8049532 <validate+0x14d>
 804949f:	8b 15 04 c2 04 08    	mov    0x804c204,%edx
 80494a5:	b8 77 a6 04 08       	mov    $0x804a677,%eax
 80494aa:	c7 44 24 10 20 c2 04 	movl   $0x804c220,0x10(%esp)
 80494b1:	08 
 80494b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80494b6:	8b 55 08             	mov    0x8(%ebp),%edx
 80494b9:	89 54 24 08          	mov    %edx,0x8(%esp)
 80494bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 80494c1:	8d 85 f4 df ff ff    	lea    -0x200c(%ebp),%eax
 80494c7:	89 04 24             	mov    %eax,(%esp)
 80494ca:	e8 41 f3 ff ff       	call   8048810 <sprintf@plt>
 80494cf:	a1 f4 c1 04 08       	mov    0x804c1f4,%eax
 80494d4:	8d 95 f4 bf ff ff    	lea    -0x400c(%ebp),%edx
 80494da:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80494de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 80494e5:	00 
 80494e6:	8d 95 f4 df ff ff    	lea    -0x200c(%ebp),%edx
 80494ec:	89 54 24 04          	mov    %edx,0x4(%esp)
 80494f0:	89 04 24             	mov    %eax,(%esp)
 80494f3:	e8 1b 0a 00 00       	call   8049f13 <driver_post>
 80494f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80494fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80494ff:	75 0e                	jne    804950f <validate+0x12a>
 8049501:	c7 04 24 80 a6 04 08 	movl   $0x804a680,(%esp)
 8049508:	e8 d3 f4 ff ff       	call   80489e0 <puts@plt>
 804950d:	eb 17                	jmp    8049526 <validate+0x141>
 804950f:	b8 b0 a6 04 08       	mov    $0x804a6b0,%eax
 8049514:	8d 95 f4 bf ff ff    	lea    -0x400c(%ebp),%edx
 804951a:	89 54 24 04          	mov    %edx,0x4(%esp)
 804951e:	89 04 24             	mov    %eax,(%esp)
 8049521:	e8 5a f4 ff ff       	call   8048980 <printf@plt>
 8049526:	c7 04 24 ee a6 04 08 	movl   $0x804a6ee,(%esp)
 804952d:	e8 ae f4 ff ff       	call   80489e0 <puts@plt>
 8049532:	c9                   	leave  
 8049533:	c3                   	ret    

08049534 <sigalrm_handler>:
 8049534:	55                   	push   %ebp
 8049535:	89 e5                	mov    %esp,%ebp
 8049537:	83 ec 18             	sub    $0x18,%esp
 804953a:	b8 f8 a6 04 08       	mov    $0x804a6f8,%eax
 804953f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 8049546:	00 
 8049547:	89 04 24             	mov    %eax,(%esp)
 804954a:	e8 31 f4 ff ff       	call   8048980 <printf@plt>
 804954f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049556:	e8 f5 f4 ff ff       	call   8048a50 <exit@plt>

0804955b <rio_readinitb>:
 804955b:	55                   	push   %ebp
 804955c:	89 e5                	mov    %esp,%ebp
 804955e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049561:	8b 55 0c             	mov    0xc(%ebp),%edx
 8049564:	89 10                	mov    %edx,(%eax)
 8049566:	8b 45 08             	mov    0x8(%ebp),%eax
 8049569:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 8049570:	8b 45 08             	mov    0x8(%ebp),%eax
 8049573:	8d 50 0c             	lea    0xc(%eax),%edx
 8049576:	8b 45 08             	mov    0x8(%ebp),%eax
 8049579:	89 50 08             	mov    %edx,0x8(%eax)
 804957c:	5d                   	pop    %ebp
 804957d:	c3                   	ret    

0804957e <rio_read>:
 804957e:	55                   	push   %ebp
 804957f:	89 e5                	mov    %esp,%ebp
 8049581:	83 ec 28             	sub    $0x28,%esp
 8049584:	eb 62                	jmp    80495e8 <rio_read+0x6a>
 8049586:	8b 45 08             	mov    0x8(%ebp),%eax
 8049589:	8d 50 0c             	lea    0xc(%eax),%edx
 804958c:	8b 45 08             	mov    0x8(%ebp),%eax
 804958f:	8b 00                	mov    (%eax),%eax
 8049591:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049598:	00 
 8049599:	89 54 24 04          	mov    %edx,0x4(%esp)
 804959d:	89 04 24             	mov    %eax,(%esp)
 80495a0:	e8 5b f3 ff ff       	call   8048900 <read@plt>
 80495a5:	8b 55 08             	mov    0x8(%ebp),%edx
 80495a8:	89 42 04             	mov    %eax,0x4(%edx)
 80495ab:	8b 45 08             	mov    0x8(%ebp),%eax
 80495ae:	8b 40 04             	mov    0x4(%eax),%eax
 80495b1:	85 c0                	test   %eax,%eax
 80495b3:	79 16                	jns    80495cb <rio_read+0x4d>
 80495b5:	e8 46 f2 ff ff       	call   8048800 <__errno_location@plt>
 80495ba:	8b 00                	mov    (%eax),%eax
 80495bc:	83 f8 04             	cmp    $0x4,%eax
 80495bf:	74 27                	je     80495e8 <rio_read+0x6a>
 80495c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80495c6:	e9 82 00 00 00       	jmp    804964d <rio_read+0xcf>
 80495cb:	8b 45 08             	mov    0x8(%ebp),%eax
 80495ce:	8b 40 04             	mov    0x4(%eax),%eax
 80495d1:	85 c0                	test   %eax,%eax
 80495d3:	75 07                	jne    80495dc <rio_read+0x5e>
 80495d5:	b8 00 00 00 00       	mov    $0x0,%eax
 80495da:	eb 71                	jmp    804964d <rio_read+0xcf>
 80495dc:	8b 45 08             	mov    0x8(%ebp),%eax
 80495df:	8d 50 0c             	lea    0xc(%eax),%edx
 80495e2:	8b 45 08             	mov    0x8(%ebp),%eax
 80495e5:	89 50 08             	mov    %edx,0x8(%eax)
 80495e8:	8b 45 08             	mov    0x8(%ebp),%eax
 80495eb:	8b 40 04             	mov    0x4(%eax),%eax
 80495ee:	85 c0                	test   %eax,%eax
 80495f0:	7e 94                	jle    8049586 <rio_read+0x8>
 80495f2:	8b 45 10             	mov    0x10(%ebp),%eax
 80495f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80495f8:	8b 45 08             	mov    0x8(%ebp),%eax
 80495fb:	8b 40 04             	mov    0x4(%eax),%eax
 80495fe:	3b 45 10             	cmp    0x10(%ebp),%eax
 8049601:	73 09                	jae    804960c <rio_read+0x8e>
 8049603:	8b 45 08             	mov    0x8(%ebp),%eax
 8049606:	8b 40 04             	mov    0x4(%eax),%eax
 8049609:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804960c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804960f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049612:	8b 40 08             	mov    0x8(%eax),%eax
 8049615:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049619:	89 44 24 04          	mov    %eax,0x4(%esp)
 804961d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049620:	89 04 24             	mov    %eax,(%esp)
 8049623:	e8 18 f3 ff ff       	call   8048940 <memcpy@plt>
 8049628:	8b 45 08             	mov    0x8(%ebp),%eax
 804962b:	8b 50 08             	mov    0x8(%eax),%edx
 804962e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049631:	01 c2                	add    %eax,%edx
 8049633:	8b 45 08             	mov    0x8(%ebp),%eax
 8049636:	89 50 08             	mov    %edx,0x8(%eax)
 8049639:	8b 45 08             	mov    0x8(%ebp),%eax
 804963c:	8b 40 04             	mov    0x4(%eax),%eax
 804963f:	89 c2                	mov    %eax,%edx
 8049641:	2b 55 f4             	sub    -0xc(%ebp),%edx
 8049644:	8b 45 08             	mov    0x8(%ebp),%eax
 8049647:	89 50 04             	mov    %edx,0x4(%eax)
 804964a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804964d:	c9                   	leave  
 804964e:	c3                   	ret    

0804964f <rio_readlineb>:
 804964f:	55                   	push   %ebp
 8049650:	89 e5                	mov    %esp,%ebp
 8049652:	83 ec 28             	sub    $0x28,%esp
 8049655:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049658:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804965b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
 8049662:	eb 58                	jmp    80496bc <rio_readlineb+0x6d>
 8049664:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 804966b:	00 
 804966c:	8d 45 eb             	lea    -0x15(%ebp),%eax
 804966f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049673:	8b 45 08             	mov    0x8(%ebp),%eax
 8049676:	89 04 24             	mov    %eax,(%esp)
 8049679:	e8 00 ff ff ff       	call   804957e <rio_read>
 804967e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049681:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
 8049685:	75 17                	jne    804969e <rio_readlineb+0x4f>
 8049687:	0f b6 55 eb          	movzbl -0x15(%ebp),%edx
 804968b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804968e:	88 10                	mov    %dl,(%eax)
 8049690:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049694:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
 8049698:	3c 0a                	cmp    $0xa,%al
 804969a:	75 1c                	jne    80496b8 <rio_readlineb+0x69>
 804969c:	eb 29                	jmp    80496c7 <rio_readlineb+0x78>
 804969e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80496a2:	75 0d                	jne    80496b1 <rio_readlineb+0x62>
 80496a4:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80496a8:	75 1c                	jne    80496c6 <rio_readlineb+0x77>
 80496aa:	b8 00 00 00 00       	mov    $0x0,%eax
 80496af:	eb 1f                	jmp    80496d0 <rio_readlineb+0x81>
 80496b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80496b6:	eb 18                	jmp    80496d0 <rio_readlineb+0x81>
 80496b8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 80496bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80496bf:	3b 45 10             	cmp    0x10(%ebp),%eax
 80496c2:	72 a0                	jb     8049664 <rio_readlineb+0x15>
 80496c4:	eb 01                	jmp    80496c7 <rio_readlineb+0x78>
 80496c6:	90                   	nop
 80496c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496ca:	c6 00 00             	movb   $0x0,(%eax)
 80496cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80496d0:	c9                   	leave  
 80496d1:	c3                   	ret    

080496d2 <rio_writen>:
 80496d2:	55                   	push   %ebp
 80496d3:	89 e5                	mov    %esp,%ebp
 80496d5:	83 ec 28             	sub    $0x28,%esp
 80496d8:	8b 45 10             	mov    0x10(%ebp),%eax
 80496db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80496de:	8b 45 0c             	mov    0xc(%ebp),%eax
 80496e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80496e4:	eb 4a                	jmp    8049730 <rio_writen+0x5e>
 80496e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80496e9:	89 44 24 08          	mov    %eax,0x8(%esp)
 80496ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 80496f4:	8b 45 08             	mov    0x8(%ebp),%eax
 80496f7:	89 04 24             	mov    %eax,(%esp)
 80496fa:	e8 b1 f1 ff ff       	call   80488b0 <write@plt>
 80496ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8049702:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8049706:	7f 1c                	jg     8049724 <rio_writen+0x52>
 8049708:	e8 f3 f0 ff ff       	call   8048800 <__errno_location@plt>
 804970d:	8b 00                	mov    (%eax),%eax
 804970f:	83 f8 04             	cmp    $0x4,%eax
 8049712:	75 09                	jne    804971d <rio_writen+0x4b>
 8049714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804971b:	eb 07                	jmp    8049724 <rio_writen+0x52>
 804971d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049722:	eb 15                	jmp    8049739 <rio_writen+0x67>
 8049724:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049727:	29 45 ec             	sub    %eax,-0x14(%ebp)
 804972a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804972d:	01 45 f4             	add    %eax,-0xc(%ebp)
 8049730:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8049734:	75 b0                	jne    80496e6 <rio_writen+0x14>
 8049736:	8b 45 10             	mov    0x10(%ebp),%eax
 8049739:	c9                   	leave  
 804973a:	c3                   	ret    

0804973b <urlencode>:
 804973b:	55                   	push   %ebp
 804973c:	89 e5                	mov    %esp,%ebp
 804973e:	83 ec 28             	sub    $0x28,%esp
 8049741:	8b 45 08             	mov    0x8(%ebp),%eax
 8049744:	89 04 24             	mov    %eax,(%esp)
 8049747:	e8 04 f2 ff ff       	call   8048950 <strlen@plt>
 804974c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804974f:	e9 07 01 00 00       	jmp    804985b <urlencode+0x120>
 8049754:	8b 45 08             	mov    0x8(%ebp),%eax
 8049757:	0f b6 00             	movzbl (%eax),%eax
 804975a:	3c 2a                	cmp    $0x2a,%al
 804975c:	74 5a                	je     80497b8 <urlencode+0x7d>
 804975e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049761:	0f b6 00             	movzbl (%eax),%eax
 8049764:	3c 2d                	cmp    $0x2d,%al
 8049766:	74 50                	je     80497b8 <urlencode+0x7d>
 8049768:	8b 45 08             	mov    0x8(%ebp),%eax
 804976b:	0f b6 00             	movzbl (%eax),%eax
 804976e:	3c 2e                	cmp    $0x2e,%al
 8049770:	74 46                	je     80497b8 <urlencode+0x7d>
 8049772:	8b 45 08             	mov    0x8(%ebp),%eax
 8049775:	0f b6 00             	movzbl (%eax),%eax
 8049778:	3c 5f                	cmp    $0x5f,%al
 804977a:	74 3c                	je     80497b8 <urlencode+0x7d>
 804977c:	8b 45 08             	mov    0x8(%ebp),%eax
 804977f:	0f b6 00             	movzbl (%eax),%eax
 8049782:	3c 2f                	cmp    $0x2f,%al
 8049784:	76 0a                	jbe    8049790 <urlencode+0x55>
 8049786:	8b 45 08             	mov    0x8(%ebp),%eax
 8049789:	0f b6 00             	movzbl (%eax),%eax
 804978c:	3c 39                	cmp    $0x39,%al
 804978e:	76 28                	jbe    80497b8 <urlencode+0x7d>
 8049790:	8b 45 08             	mov    0x8(%ebp),%eax
 8049793:	0f b6 00             	movzbl (%eax),%eax
 8049796:	3c 40                	cmp    $0x40,%al
 8049798:	76 0a                	jbe    80497a4 <urlencode+0x69>
 804979a:	8b 45 08             	mov    0x8(%ebp),%eax
 804979d:	0f b6 00             	movzbl (%eax),%eax
 80497a0:	3c 5a                	cmp    $0x5a,%al
 80497a2:	76 14                	jbe    80497b8 <urlencode+0x7d>
 80497a4:	8b 45 08             	mov    0x8(%ebp),%eax
 80497a7:	0f b6 00             	movzbl (%eax),%eax
 80497aa:	3c 60                	cmp    $0x60,%al
 80497ac:	76 1e                	jbe    80497cc <urlencode+0x91>
 80497ae:	8b 45 08             	mov    0x8(%ebp),%eax
 80497b1:	0f b6 00             	movzbl (%eax),%eax
 80497b4:	3c 7a                	cmp    $0x7a,%al
 80497b6:	77 14                	ja     80497cc <urlencode+0x91>
 80497b8:	8b 45 08             	mov    0x8(%ebp),%eax
 80497bb:	0f b6 10             	movzbl (%eax),%edx
 80497be:	8b 45 0c             	mov    0xc(%ebp),%eax
 80497c1:	88 10                	mov    %dl,(%eax)
 80497c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 80497c7:	e9 8b 00 00 00       	jmp    8049857 <urlencode+0x11c>
 80497cc:	8b 45 08             	mov    0x8(%ebp),%eax
 80497cf:	0f b6 00             	movzbl (%eax),%eax
 80497d2:	3c 20                	cmp    $0x20,%al
 80497d4:	75 0c                	jne    80497e2 <urlencode+0xa7>
 80497d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 80497d9:	c6 00 2b             	movb   $0x2b,(%eax)
 80497dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 80497e0:	eb 75                	jmp    8049857 <urlencode+0x11c>
 80497e2:	8b 45 08             	mov    0x8(%ebp),%eax
 80497e5:	0f b6 00             	movzbl (%eax),%eax
 80497e8:	3c 1f                	cmp    $0x1f,%al
 80497ea:	76 0a                	jbe    80497f6 <urlencode+0xbb>
 80497ec:	8b 45 08             	mov    0x8(%ebp),%eax
 80497ef:	0f b6 00             	movzbl (%eax),%eax
 80497f2:	84 c0                	test   %al,%al
 80497f4:	79 0a                	jns    8049800 <urlencode+0xc5>
 80497f6:	8b 45 08             	mov    0x8(%ebp),%eax
 80497f9:	0f b6 00             	movzbl (%eax),%eax
 80497fc:	3c 09                	cmp    $0x9,%al
 80497fe:	75 50                	jne    8049850 <urlencode+0x115>
 8049800:	8b 45 08             	mov    0x8(%ebp),%eax
 8049803:	0f b6 00             	movzbl (%eax),%eax
 8049806:	0f b6 d0             	movzbl %al,%edx
 8049809:	b8 1c a7 04 08       	mov    $0x804a71c,%eax
 804980e:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049812:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049816:	8d 45 ec             	lea    -0x14(%ebp),%eax
 8049819:	89 04 24             	mov    %eax,(%esp)
 804981c:	e8 ef ef ff ff       	call   8048810 <sprintf@plt>
 8049821:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
 8049825:	89 c2                	mov    %eax,%edx
 8049827:	8b 45 0c             	mov    0xc(%ebp),%eax
 804982a:	88 10                	mov    %dl,(%eax)
 804982c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 8049830:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
 8049834:	89 c2                	mov    %eax,%edx
 8049836:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049839:	88 10                	mov    %dl,(%eax)
 804983b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 804983f:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
 8049843:	89 c2                	mov    %eax,%edx
 8049845:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049848:	88 10                	mov    %dl,(%eax)
 804984a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 804984e:	eb 07                	jmp    8049857 <urlencode+0x11c>
 8049850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049855:	eb 1c                	jmp    8049873 <urlencode+0x138>
 8049857:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 804985b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804985f:	0f 95 c0             	setne  %al
 8049862:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8049866:	84 c0                	test   %al,%al
 8049868:	0f 85 e6 fe ff ff    	jne    8049754 <urlencode+0x19>
 804986e:	b8 00 00 00 00       	mov    $0x0,%eax
 8049873:	c9                   	leave  
 8049874:	c3                   	ret    

08049875 <submitr>:
 8049875:	55                   	push   %ebp
 8049876:	89 e5                	mov    %esp,%ebp
 8049878:	53                   	push   %ebx
 8049879:	81 ec 54 a0 00 00    	sub    $0xa054,%esp
 804987f:	c7 85 c8 7f ff ff 00 	movl   $0x0,-0x8038(%ebp)
 8049886:	00 00 00 
 8049889:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049890:	00 
 8049891:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049898:	00 
 8049899:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 80498a0:	e8 6b f0 ff ff       	call   8048910 <socket@plt>
 80498a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80498a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 80498ac:	79 26                	jns    80498d4 <submitr+0x5f>
 80498ae:	b8 24 a7 04 08       	mov    $0x804a724,%eax
 80498b3:	c7 44 24 08 26 00 00 	movl   $0x26,0x8(%esp)
 80498ba:	00 
 80498bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 80498bf:	8b 45 20             	mov    0x20(%ebp),%eax
 80498c2:	89 04 24             	mov    %eax,(%esp)
 80498c5:	e8 76 f0 ff ff       	call   8048940 <memcpy@plt>
 80498ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80498cf:	e9 49 04 00 00       	jmp    8049d1d <submitr+0x4a8>
 80498d4:	8b 45 08             	mov    0x8(%ebp),%eax
 80498d7:	89 04 24             	mov    %eax,(%esp)
 80498da:	e8 51 f1 ff ff       	call   8048a30 <gethostbyname@plt>
 80498df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80498e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80498e6:	75 30                	jne    8049918 <submitr+0xa3>
 80498e8:	b8 4c a7 04 08       	mov    $0x804a74c,%eax
 80498ed:	8b 55 08             	mov    0x8(%ebp),%edx
 80498f0:	89 54 24 08          	mov    %edx,0x8(%esp)
 80498f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 80498f8:	8b 45 20             	mov    0x20(%ebp),%eax
 80498fb:	89 04 24             	mov    %eax,(%esp)
 80498fe:	e8 0d ef ff ff       	call   8048810 <sprintf@plt>
 8049903:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049906:	89 04 24             	mov    %eax,(%esp)
 8049909:	e8 a2 f0 ff ff       	call   80489b0 <close@plt>
 804990e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049913:	e9 05 04 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049918:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
 804991f:	00 
 8049920:	8d 45 d8             	lea    -0x28(%ebp),%eax
 8049923:	89 04 24             	mov    %eax,(%esp)
 8049926:	e8 d5 f0 ff ff       	call   8048a00 <bzero@plt>
 804992b:	66 c7 45 d8 02 00    	movw   $0x2,-0x28(%ebp)
 8049931:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049934:	8b 40 0c             	mov    0xc(%eax),%eax
 8049937:	89 c2                	mov    %eax,%edx
 8049939:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804993c:	8b 40 10             	mov    0x10(%eax),%eax
 804993f:	8b 00                	mov    (%eax),%eax
 8049941:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049945:	8d 55 d8             	lea    -0x28(%ebp),%edx
 8049948:	83 c2 04             	add    $0x4,%edx
 804994b:	89 54 24 04          	mov    %edx,0x4(%esp)
 804994f:	89 04 24             	mov    %eax,(%esp)
 8049952:	e8 c9 ef ff ff       	call   8048920 <bcopy@plt>
 8049957:	8b 45 0c             	mov    0xc(%ebp),%eax
 804995a:	0f b7 c0             	movzwl %ax,%eax
 804995d:	89 04 24             	mov    %eax,(%esp)
 8049960:	e8 8b ef ff ff       	call   80488f0 <htons@plt>
 8049965:	66 89 45 da          	mov    %ax,-0x26(%ebp)
 8049969:	8d 45 d8             	lea    -0x28(%ebp),%eax
 804996c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8049973:	00 
 8049974:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049978:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804997b:	89 04 24             	mov    %eax,(%esp)
 804997e:	e8 ad ee ff ff       	call   8048830 <connect@plt>
 8049983:	85 c0                	test   %eax,%eax
 8049985:	79 30                	jns    80499b7 <submitr+0x142>
 8049987:	b8 78 a7 04 08       	mov    $0x804a778,%eax
 804998c:	8b 55 08             	mov    0x8(%ebp),%edx
 804998f:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049993:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049997:	8b 45 20             	mov    0x20(%ebp),%eax
 804999a:	89 04 24             	mov    %eax,(%esp)
 804999d:	e8 6e ee ff ff       	call   8048810 <sprintf@plt>
 80499a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80499a5:	89 04 24             	mov    %eax,(%esp)
 80499a8:	e8 03 f0 ff ff       	call   80489b0 <close@plt>
 80499ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80499b2:	e9 66 03 00 00       	jmp    8049d1d <submitr+0x4a8>
 80499b7:	8b 45 1c             	mov    0x1c(%ebp),%eax
 80499ba:	89 04 24             	mov    %eax,(%esp)
 80499bd:	e8 8e ef ff ff       	call   8048950 <strlen@plt>
 80499c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80499c5:	8b 45 10             	mov    0x10(%ebp),%eax
 80499c8:	89 04 24             	mov    %eax,(%esp)
 80499cb:	e8 80 ef ff ff       	call   8048950 <strlen@plt>
 80499d0:	89 c3                	mov    %eax,%ebx
 80499d2:	8b 45 14             	mov    0x14(%ebp),%eax
 80499d5:	89 04 24             	mov    %eax,(%esp)
 80499d8:	e8 73 ef ff ff       	call   8048950 <strlen@plt>
 80499dd:	01 c3                	add    %eax,%ebx
 80499df:	8b 45 18             	mov    0x18(%ebp),%eax
 80499e2:	89 04 24             	mov    %eax,(%esp)
 80499e5:	e8 66 ef ff ff       	call   8048950 <strlen@plt>
 80499ea:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
 80499ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80499f0:	89 d0                	mov    %edx,%eax
 80499f2:	01 c0                	add    %eax,%eax
 80499f4:	01 d0                	add    %edx,%eax
 80499f6:	8d 04 01             	lea    (%ecx,%eax,1),%eax
 80499f9:	83 e8 80             	sub    $0xffffff80,%eax
 80499fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80499ff:	81 7d f4 00 20 00 00 	cmpl   $0x2000,-0xc(%ebp)
 8049a06:	76 31                	jbe    8049a39 <submitr+0x1c4>
 8049a08:	b8 a0 a7 04 08       	mov    $0x804a7a0,%eax
 8049a0d:	c7 44 24 08 38 00 00 	movl   $0x38,0x8(%esp)
 8049a14:	00 
 8049a15:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049a19:	8b 45 20             	mov    0x20(%ebp),%eax
 8049a1c:	89 04 24             	mov    %eax,(%esp)
 8049a1f:	e8 1c ef ff ff       	call   8048940 <memcpy@plt>
 8049a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049a27:	89 04 24             	mov    %eax,(%esp)
 8049a2a:	e8 81 ef ff ff       	call   80489b0 <close@plt>
 8049a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a34:	e9 e4 02 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049a39:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
 8049a40:	00 
 8049a41:	8d 85 cc 9f ff ff    	lea    -0x6034(%ebp),%eax
 8049a47:	89 04 24             	mov    %eax,(%esp)
 8049a4a:	e8 b1 ef ff ff       	call   8048a00 <bzero@plt>
 8049a4f:	8d 95 cc 9f ff ff    	lea    -0x6034(%ebp),%edx
 8049a55:	8b 45 1c             	mov    0x1c(%ebp),%eax
 8049a58:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049a5c:	89 04 24             	mov    %eax,(%esp)
 8049a5f:	e8 d7 fc ff ff       	call   804973b <urlencode>
 8049a64:	85 c0                	test   %eax,%eax
 8049a66:	79 31                	jns    8049a99 <submitr+0x224>
 8049a68:	b8 d8 a7 04 08       	mov    $0x804a7d8,%eax
 8049a6d:	c7 44 24 08 43 00 00 	movl   $0x43,0x8(%esp)
 8049a74:	00 
 8049a75:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049a79:	8b 45 20             	mov    0x20(%ebp),%eax
 8049a7c:	89 04 24             	mov    %eax,(%esp)
 8049a7f:	e8 bc ee ff ff       	call   8048940 <memcpy@plt>
 8049a84:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049a87:	89 04 24             	mov    %eax,(%esp)
 8049a8a:	e8 21 ef ff ff       	call   80489b0 <close@plt>
 8049a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a94:	e9 84 02 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049a99:	b8 1c a8 04 08       	mov    $0x804a81c,%eax
 8049a9e:	8d 95 cc 9f ff ff    	lea    -0x6034(%ebp),%edx
 8049aa4:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049aa8:	8b 55 18             	mov    0x18(%ebp),%edx
 8049aab:	89 54 24 10          	mov    %edx,0x10(%esp)
 8049aaf:	8b 55 14             	mov    0x14(%ebp),%edx
 8049ab2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049ab6:	8b 55 10             	mov    0x10(%ebp),%edx
 8049ab9:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049abd:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049ac1:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049ac7:	89 04 24             	mov    %eax,(%esp)
 8049aca:	e8 41 ed ff ff       	call   8048810 <sprintf@plt>
 8049acf:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049ad5:	89 04 24             	mov    %eax,(%esp)
 8049ad8:	e8 73 ee ff ff       	call   8048950 <strlen@plt>
 8049add:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049ae1:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049aee:	89 04 24             	mov    %eax,(%esp)
 8049af1:	e8 dc fb ff ff       	call   80496d2 <rio_writen>
 8049af6:	85 c0                	test   %eax,%eax
 8049af8:	79 31                	jns    8049b2b <submitr+0x2b6>
 8049afa:	b8 68 a8 04 08       	mov    $0x804a868,%eax
 8049aff:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
 8049b06:	00 
 8049b07:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b0b:	8b 45 20             	mov    0x20(%ebp),%eax
 8049b0e:	89 04 24             	mov    %eax,(%esp)
 8049b11:	e8 2a ee ff ff       	call   8048940 <memcpy@plt>
 8049b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049b19:	89 04 24             	mov    %eax,(%esp)
 8049b1c:	e8 8f ee ff ff       	call   80489b0 <close@plt>
 8049b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b26:	e9 f2 01 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b32:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049b38:	89 04 24             	mov    %eax,(%esp)
 8049b3b:	e8 1b fa ff ff       	call   804955b <rio_readinitb>
 8049b40:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049b47:	00 
 8049b48:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b52:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049b58:	89 04 24             	mov    %eax,(%esp)
 8049b5b:	e8 ef fa ff ff       	call   804964f <rio_readlineb>
 8049b60:	85 c0                	test   %eax,%eax
 8049b62:	7f 31                	jg     8049b95 <submitr+0x320>
 8049b64:	b8 94 a8 04 08       	mov    $0x804a894,%eax
 8049b69:	c7 44 24 08 36 00 00 	movl   $0x36,0x8(%esp)
 8049b70:	00 
 8049b71:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049b75:	8b 45 20             	mov    0x20(%ebp),%eax
 8049b78:	89 04 24             	mov    %eax,(%esp)
 8049b7b:	e8 c0 ed ff ff       	call   8048940 <memcpy@plt>
 8049b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049b83:	89 04 24             	mov    %eax,(%esp)
 8049b86:	e8 25 ee ff ff       	call   80489b0 <close@plt>
 8049b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b90:	e9 88 01 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049b95:	ba ca a8 04 08       	mov    $0x804a8ca,%edx
 8049b9a:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049ba0:	8d 8d c8 5f ff ff    	lea    -0xa038(%ebp),%ecx
 8049ba6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 8049baa:	8d 8d c8 7f ff ff    	lea    -0x8038(%ebp),%ecx
 8049bb0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8049bb4:	8d 8d cc 7f ff ff    	lea    -0x8034(%ebp),%ecx
 8049bba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8049bbe:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049bc2:	89 04 24             	mov    %eax,(%esp)
 8049bc5:	e8 c6 ec ff ff       	call   8048890 <__isoc99_sscanf@plt>
 8049bca:	8b 85 c8 7f ff ff    	mov    -0x8038(%ebp),%eax
 8049bd0:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049bd5:	0f 84 92 00 00 00    	je     8049c6d <submitr+0x3f8>
 8049bdb:	8b 95 c8 7f ff ff    	mov    -0x8038(%ebp),%edx
 8049be1:	b8 dc a8 04 08       	mov    $0x804a8dc,%eax
 8049be6:	8d 8d c8 5f ff ff    	lea    -0xa038(%ebp),%ecx
 8049bec:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8049bf0:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049bf8:	8b 45 20             	mov    0x20(%ebp),%eax
 8049bfb:	89 04 24             	mov    %eax,(%esp)
 8049bfe:	e8 0d ec ff ff       	call   8048810 <sprintf@plt>
 8049c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049c06:	89 04 24             	mov    %eax,(%esp)
 8049c09:	e8 a2 ed ff ff       	call   80489b0 <close@plt>
 8049c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c13:	e9 05 01 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049c18:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049c1f:	00 
 8049c20:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049c26:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049c2a:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049c30:	89 04 24             	mov    %eax,(%esp)
 8049c33:	e8 17 fa ff ff       	call   804964f <rio_readlineb>
 8049c38:	85 c0                	test   %eax,%eax
 8049c3a:	7f 32                	jg     8049c6e <submitr+0x3f9>
 8049c3c:	b8 0c a9 04 08       	mov    $0x804a90c,%eax
 8049c41:	c7 44 24 08 31 00 00 	movl   $0x31,0x8(%esp)
 8049c48:	00 
 8049c49:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049c4d:	8b 45 20             	mov    0x20(%ebp),%eax
 8049c50:	89 04 24             	mov    %eax,(%esp)
 8049c53:	e8 e8 ec ff ff       	call   8048940 <memcpy@plt>
 8049c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049c5b:	89 04 24             	mov    %eax,(%esp)
 8049c5e:	e8 4d ed ff ff       	call   80489b0 <close@plt>
 8049c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c68:	e9 b0 00 00 00       	jmp    8049d1d <submitr+0x4a8>
 8049c6d:	90                   	nop
 8049c6e:	c7 44 24 04 3d a9 04 	movl   $0x804a93d,0x4(%esp)
 8049c75:	08 
 8049c76:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049c7c:	89 04 24             	mov    %eax,(%esp)
 8049c7f:	e8 bc ed ff ff       	call   8048a40 <strcmp@plt>
 8049c84:	85 c0                	test   %eax,%eax
 8049c86:	75 90                	jne    8049c18 <submitr+0x3a3>
 8049c88:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049c8f:	00 
 8049c90:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049c96:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049c9a:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049ca0:	89 04 24             	mov    %eax,(%esp)
 8049ca3:	e8 a7 f9 ff ff       	call   804964f <rio_readlineb>
 8049ca8:	85 c0                	test   %eax,%eax
 8049caa:	7f 2e                	jg     8049cda <submitr+0x465>
 8049cac:	b8 40 a9 04 08       	mov    $0x804a940,%eax
 8049cb1:	c7 44 24 08 38 00 00 	movl   $0x38,0x8(%esp)
 8049cb8:	00 
 8049cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049cbd:	8b 45 20             	mov    0x20(%ebp),%eax
 8049cc0:	89 04 24             	mov    %eax,(%esp)
 8049cc3:	e8 78 ec ff ff       	call   8048940 <memcpy@plt>
 8049cc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049ccb:	89 04 24             	mov    %eax,(%esp)
 8049cce:	e8 dd ec ff ff       	call   80489b0 <close@plt>
 8049cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049cd8:	eb 43                	jmp    8049d1d <submitr+0x4a8>
 8049cda:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049ce4:	8b 45 20             	mov    0x20(%ebp),%eax
 8049ce7:	89 04 24             	mov    %eax,(%esp)
 8049cea:	e8 81 ec ff ff       	call   8048970 <strcpy@plt>
 8049cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049cf2:	89 04 24             	mov    %eax,(%esp)
 8049cf5:	e8 b6 ec ff ff       	call   80489b0 <close@plt>
 8049cfa:	c7 44 24 04 78 a9 04 	movl   $0x804a978,0x4(%esp)
 8049d01:	08 
 8049d02:	8b 45 20             	mov    0x20(%ebp),%eax
 8049d05:	89 04 24             	mov    %eax,(%esp)
 8049d08:	e8 33 ed ff ff       	call   8048a40 <strcmp@plt>
 8049d0d:	85 c0                	test   %eax,%eax
 8049d0f:	75 07                	jne    8049d18 <submitr+0x4a3>
 8049d11:	b8 00 00 00 00       	mov    $0x0,%eax
 8049d16:	eb 05                	jmp    8049d1d <submitr+0x4a8>
 8049d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d1d:	81 c4 54 a0 00 00    	add    $0xa054,%esp
 8049d23:	5b                   	pop    %ebx
 8049d24:	5d                   	pop    %ebp
 8049d25:	c3                   	ret    

08049d26 <init_timeout>:
 8049d26:	55                   	push   %ebp
 8049d27:	89 e5                	mov    %esp,%ebp
 8049d29:	83 ec 18             	sub    $0x18,%esp
 8049d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049d30:	74 2e                	je     8049d60 <init_timeout+0x3a>
 8049d32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049d36:	79 07                	jns    8049d3f <init_timeout+0x19>
 8049d38:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
 8049d3f:	c7 44 24 04 34 95 04 	movl   $0x8049534,0x4(%esp)
 8049d46:	08 
 8049d47:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 8049d4e:	e8 1d eb ff ff       	call   8048870 <signal@plt>
 8049d53:	8b 45 08             	mov    0x8(%ebp),%eax
 8049d56:	89 04 24             	mov    %eax,(%esp)
 8049d59:	e8 02 ec ff ff       	call   8048960 <alarm@plt>
 8049d5e:	eb 01                	jmp    8049d61 <init_timeout+0x3b>
 8049d60:	90                   	nop
 8049d61:	c9                   	leave  
 8049d62:	c3                   	ret    

08049d63 <init_driver>:
 8049d63:	55                   	push   %ebp
 8049d64:	89 e5                	mov    %esp,%ebp
 8049d66:	83 ec 38             	sub    $0x38,%esp
 8049d69:	c7 45 f0 7b a9 04 08 	movl   $0x804a97b,-0x10(%ebp)
 8049d70:	c7 45 f4 26 47 00 00 	movl   $0x4726,-0xc(%ebp)
 8049d77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d7e:	00 
 8049d7f:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
 8049d86:	e8 e5 ea ff ff       	call   8048870 <signal@plt>
 8049d8b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d92:	00 
 8049d93:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049d9a:	e8 d1 ea ff ff       	call   8048870 <signal@plt>
 8049d9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049da6:	00 
 8049da7:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049dae:	e8 bd ea ff ff       	call   8048870 <signal@plt>
 8049db3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049dba:	00 
 8049dbb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049dc2:	00 
 8049dc3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049dca:	e8 41 eb ff ff       	call   8048910 <socket@plt>
 8049dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8049dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 8049dd6:	79 26                	jns    8049dfe <init_driver+0x9b>
 8049dd8:	b8 24 a7 04 08       	mov    $0x804a724,%eax
 8049ddd:	c7 44 24 08 26 00 00 	movl   $0x26,0x8(%esp)
 8049de4:	00 
 8049de5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049de9:	8b 45 08             	mov    0x8(%ebp),%eax
 8049dec:	89 04 24             	mov    %eax,(%esp)
 8049def:	e8 4c eb ff ff       	call   8048940 <memcpy@plt>
 8049df4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049df9:	e9 13 01 00 00       	jmp    8049f11 <init_driver+0x1ae>
 8049dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8049e01:	89 04 24             	mov    %eax,(%esp)
 8049e04:	e8 27 ec ff ff       	call   8048a30 <gethostbyname@plt>
 8049e09:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8049e0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8049e10:	75 30                	jne    8049e42 <init_driver+0xdf>
 8049e12:	b8 4c a7 04 08       	mov    $0x804a74c,%eax
 8049e17:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8049e1a:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049e22:	8b 45 08             	mov    0x8(%ebp),%eax
 8049e25:	89 04 24             	mov    %eax,(%esp)
 8049e28:	e8 e3 e9 ff ff       	call   8048810 <sprintf@plt>
 8049e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049e30:	89 04 24             	mov    %eax,(%esp)
 8049e33:	e8 78 eb ff ff       	call   80489b0 <close@plt>
 8049e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e3d:	e9 cf 00 00 00       	jmp    8049f11 <init_driver+0x1ae>
 8049e42:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
 8049e49:	00 
 8049e4a:	8d 45 d8             	lea    -0x28(%ebp),%eax
 8049e4d:	89 04 24             	mov    %eax,(%esp)
 8049e50:	e8 ab eb ff ff       	call   8048a00 <bzero@plt>
 8049e55:	66 c7 45 d8 02 00    	movw   $0x2,-0x28(%ebp)
 8049e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049e5e:	8b 40 0c             	mov    0xc(%eax),%eax
 8049e61:	89 c2                	mov    %eax,%edx
 8049e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8049e66:	8b 40 10             	mov    0x10(%eax),%eax
 8049e69:	8b 00                	mov    (%eax),%eax
 8049e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049e6f:	8d 55 d8             	lea    -0x28(%ebp),%edx
 8049e72:	83 c2 04             	add    $0x4,%edx
 8049e75:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049e79:	89 04 24             	mov    %eax,(%esp)
 8049e7c:	e8 9f ea ff ff       	call   8048920 <bcopy@plt>
 8049e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049e84:	0f b7 c0             	movzwl %ax,%eax
 8049e87:	89 04 24             	mov    %eax,(%esp)
 8049e8a:	e8 61 ea ff ff       	call   80488f0 <htons@plt>
 8049e8f:	66 89 45 da          	mov    %ax,-0x26(%ebp)
 8049e93:	8d 45 d8             	lea    -0x28(%ebp),%eax
 8049e96:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8049e9d:	00 
 8049e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049ea5:	89 04 24             	mov    %eax,(%esp)
 8049ea8:	e8 83 e9 ff ff       	call   8048830 <connect@plt>
 8049ead:	85 c0                	test   %eax,%eax
 8049eaf:	79 34                	jns    8049ee5 <init_driver+0x182>
 8049eb1:	b8 8c a9 04 08       	mov    $0x804a98c,%eax
 8049eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8049eb9:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049ebd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8049ec0:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049ec8:	8b 45 08             	mov    0x8(%ebp),%eax
 8049ecb:	89 04 24             	mov    %eax,(%esp)
 8049ece:	e8 3d e9 ff ff       	call   8048810 <sprintf@plt>
 8049ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049ed6:	89 04 24             	mov    %eax,(%esp)
 8049ed9:	e8 d2 ea ff ff       	call   80489b0 <close@plt>
 8049ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049ee3:	eb 2c                	jmp    8049f11 <init_driver+0x1ae>
 8049ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049ee8:	89 04 24             	mov    %eax,(%esp)
 8049eeb:	e8 c0 ea ff ff       	call   80489b0 <close@plt>
 8049ef0:	b8 78 a9 04 08       	mov    $0x804a978,%eax
 8049ef5:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 8049efc:	00 
 8049efd:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049f01:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f04:	89 04 24             	mov    %eax,(%esp)
 8049f07:	e8 34 ea ff ff       	call   8048940 <memcpy@plt>
 8049f0c:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f11:	c9                   	leave  
 8049f12:	c3                   	ret    

08049f13 <driver_post>:
 8049f13:	55                   	push   %ebp
 8049f14:	89 e5                	mov    %esp,%ebp
 8049f16:	83 ec 38             	sub    $0x38,%esp
 8049f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049f1d:	74 37                	je     8049f56 <driver_post+0x43>
 8049f1f:	b8 b5 a9 04 08       	mov    $0x804a9b5,%eax
 8049f24:	8b 55 0c             	mov    0xc(%ebp),%edx
 8049f27:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049f2b:	89 04 24             	mov    %eax,(%esp)
 8049f2e:	e8 4d ea ff ff       	call   8048980 <printf@plt>
 8049f33:	b8 78 a9 04 08       	mov    $0x804a978,%eax
 8049f38:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 8049f3f:	00 
 8049f40:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049f44:	8b 45 14             	mov    0x14(%ebp),%eax
 8049f47:	89 04 24             	mov    %eax,(%esp)
 8049f4a:	e8 f1 e9 ff ff       	call   8048940 <memcpy@plt>
 8049f4f:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f54:	eb 72                	jmp    8049fc8 <driver_post+0xb5>
 8049f56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8049f5a:	74 4b                	je     8049fa7 <driver_post+0x94>
 8049f5c:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f5f:	0f b6 00             	movzbl (%eax),%eax
 8049f62:	84 c0                	test   %al,%al
 8049f64:	74 41                	je     8049fa7 <driver_post+0x94>
 8049f66:	8b 45 14             	mov    0x14(%ebp),%eax
 8049f69:	89 44 24 18          	mov    %eax,0x18(%esp)
 8049f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049f70:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049f74:	c7 44 24 10 cc a9 04 	movl   $0x804a9cc,0x10(%esp)
 8049f7b:	08 
 8049f7c:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049f83:	c7 44 24 08 d3 a9 04 	movl   $0x804a9d3,0x8(%esp)
 8049f8a:	08 
 8049f8b:	c7 44 24 04 26 47 00 	movl   $0x4726,0x4(%esp)
 8049f92:	00 
 8049f93:	c7 04 24 7b a9 04 08 	movl   $0x804a97b,(%esp)
 8049f9a:	e8 d6 f8 ff ff       	call   8049875 <submitr>
 8049f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8049fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049fa5:	eb 21                	jmp    8049fc8 <driver_post+0xb5>
 8049fa7:	b8 78 a9 04 08       	mov    $0x804a978,%eax
 8049fac:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 8049fb3:	00 
 8049fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049fb8:	8b 45 14             	mov    0x14(%ebp),%eax
 8049fbb:	89 04 24             	mov    %eax,(%esp)
 8049fbe:	e8 7d e9 ff ff       	call   8048940 <memcpy@plt>
 8049fc3:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fc8:	c9                   	leave  
 8049fc9:	c3                   	ret    
 8049fca:	90                   	nop
 8049fcb:	90                   	nop

08049fcc <hash>:
 8049fcc:	55                   	push   %ebp
 8049fcd:	89 e5                	mov    %esp,%ebp
 8049fcf:	83 ec 10             	sub    $0x10,%esp
 8049fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8049fd9:	eb 19                	jmp    8049ff4 <hash+0x28>
 8049fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8049fde:	6b d0 67             	imul   $0x67,%eax,%edx
 8049fe1:	8b 45 08             	mov    0x8(%ebp),%eax
 8049fe4:	0f b6 00             	movzbl (%eax),%eax
 8049fe7:	0f be c0             	movsbl %al,%eax
 8049fea:	8d 04 02             	lea    (%edx,%eax,1),%eax
 8049fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8049ff0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 8049ff4:	8b 45 08             	mov    0x8(%ebp),%eax
 8049ff7:	0f b6 00             	movzbl (%eax),%eax
 8049ffa:	84 c0                	test   %al,%al
 8049ffc:	75 dd                	jne    8049fdb <hash+0xf>
 8049ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804a001:	c9                   	leave  
 804a002:	c3                   	ret    

0804a003 <check>:
 804a003:	55                   	push   %ebp
 804a004:	89 e5                	mov    %esp,%ebp
 804a006:	53                   	push   %ebx
 804a007:	83 ec 10             	sub    $0x10,%esp
 804a00a:	8b 45 08             	mov    0x8(%ebp),%eax
 804a00d:	c1 e8 1c             	shr    $0x1c,%eax
 804a010:	85 c0                	test   %eax,%eax
 804a012:	75 07                	jne    804a01b <check+0x18>
 804a014:	b8 00 00 00 00       	mov    $0x0,%eax
 804a019:	eb 37                	jmp    804a052 <check+0x4f>
 804a01b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804a022:	eb 23                	jmp    804a047 <check+0x44>
 804a024:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804a027:	8b 55 08             	mov    0x8(%ebp),%edx
 804a02a:	89 d3                	mov    %edx,%ebx
 804a02c:	89 c1                	mov    %eax,%ecx
 804a02e:	d3 eb                	shr    %cl,%ebx
 804a030:	89 d8                	mov    %ebx,%eax
 804a032:	25 ff 00 00 00       	and    $0xff,%eax
 804a037:	83 f8 0a             	cmp    $0xa,%eax
 804a03a:	75 07                	jne    804a043 <check+0x40>
 804a03c:	b8 00 00 00 00       	mov    $0x0,%eax
 804a041:	eb 0f                	jmp    804a052 <check+0x4f>
 804a043:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
 804a047:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
 804a04b:	7e d7                	jle    804a024 <check+0x21>
 804a04d:	b8 01 00 00 00       	mov    $0x1,%eax
 804a052:	83 c4 10             	add    $0x10,%esp
 804a055:	5b                   	pop    %ebx
 804a056:	5d                   	pop    %ebp
 804a057:	c3                   	ret    

0804a058 <gencookie>:
 804a058:	55                   	push   %ebp
 804a059:	89 e5                	mov    %esp,%ebp
 804a05b:	83 ec 28             	sub    $0x28,%esp
 804a05e:	8b 45 08             	mov    0x8(%ebp),%eax
 804a061:	89 04 24             	mov    %eax,(%esp)
 804a064:	e8 63 ff ff ff       	call   8049fcc <hash>
 804a069:	89 04 24             	mov    %eax,(%esp)
 804a06c:	e8 af e7 ff ff       	call   8048820 <srand@plt>
 804a071:	e8 7a e9 ff ff       	call   80489f0 <rand@plt>
 804a076:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804a079:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a07c:	89 04 24             	mov    %eax,(%esp)
 804a07f:	e8 7f ff ff ff       	call   804a003 <check>
 804a084:	85 c0                	test   %eax,%eax
 804a086:	74 e9                	je     804a071 <gencookie+0x19>
 804a088:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804a08b:	c9                   	leave  
 804a08c:	c3                   	ret    
 804a08d:	90                   	nop
 804a08e:	90                   	nop
 804a08f:	90                   	nop

0804a090 <__libc_csu_fini>:
 804a090:	55                   	push   %ebp
 804a091:	89 e5                	mov    %esp,%ebp
 804a093:	5d                   	pop    %ebp
 804a094:	c3                   	ret    
 804a095:	66 66 2e 0f 1f 84 00 	nopw   %cs:0x0(%eax,%eax,1)
 804a09c:	00 00 00 00 

0804a0a0 <__libc_csu_init>:
 804a0a0:	55                   	push   %ebp
 804a0a1:	89 e5                	mov    %esp,%ebp
 804a0a3:	57                   	push   %edi
 804a0a4:	56                   	push   %esi
 804a0a5:	53                   	push   %ebx
 804a0a6:	e8 4f 00 00 00       	call   804a0fa <__i686.get_pc_thunk.bx>
 804a0ab:	81 c3 35 10 00 00    	add    $0x1035,%ebx
 804a0b1:	83 ec 1c             	sub    $0x1c,%esp
 804a0b4:	e8 07 e7 ff ff       	call   80487c0 <_init>
 804a0b9:	8d bb 20 ff ff ff    	lea    -0xe0(%ebx),%edi
 804a0bf:	8d 83 20 ff ff ff    	lea    -0xe0(%ebx),%eax
 804a0c5:	29 c7                	sub    %eax,%edi
 804a0c7:	c1 ff 02             	sar    $0x2,%edi
 804a0ca:	85 ff                	test   %edi,%edi
 804a0cc:	74 24                	je     804a0f2 <__libc_csu_init+0x52>
 804a0ce:	31 f6                	xor    %esi,%esi
 804a0d0:	8b 45 10             	mov    0x10(%ebp),%eax
 804a0d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a0d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a0da:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a0de:	8b 45 08             	mov    0x8(%ebp),%eax
 804a0e1:	89 04 24             	mov    %eax,(%esp)
 804a0e4:	ff 94 b3 20 ff ff ff 	call   *-0xe0(%ebx,%esi,4)
 804a0eb:	83 c6 01             	add    $0x1,%esi
 804a0ee:	39 fe                	cmp    %edi,%esi
 804a0f0:	72 de                	jb     804a0d0 <__libc_csu_init+0x30>
 804a0f2:	83 c4 1c             	add    $0x1c,%esp
 804a0f5:	5b                   	pop    %ebx
 804a0f6:	5e                   	pop    %esi
 804a0f7:	5f                   	pop    %edi
 804a0f8:	5d                   	pop    %ebp
 804a0f9:	c3                   	ret    

0804a0fa <__i686.get_pc_thunk.bx>:
 804a0fa:	8b 1c 24             	mov    (%esp),%ebx
 804a0fd:	c3                   	ret    
 804a0fe:	90                   	nop
 804a0ff:	90                   	nop

0804a100 <__do_global_ctors_aux>:
 804a100:	55                   	push   %ebp
 804a101:	89 e5                	mov    %esp,%ebp
 804a103:	53                   	push   %ebx
 804a104:	83 ec 04             	sub    $0x4,%esp
 804a107:	a1 00 b0 04 08       	mov    0x804b000,%eax
 804a10c:	83 f8 ff             	cmp    $0xffffffff,%eax
 804a10f:	74 13                	je     804a124 <__do_global_ctors_aux+0x24>
 804a111:	bb 00 b0 04 08       	mov    $0x804b000,%ebx
 804a116:	66 90                	xchg   %ax,%ax
 804a118:	83 eb 04             	sub    $0x4,%ebx
 804a11b:	ff d0                	call   *%eax
 804a11d:	8b 03                	mov    (%ebx),%eax
 804a11f:	83 f8 ff             	cmp    $0xffffffff,%eax
 804a122:	75 f4                	jne    804a118 <__do_global_ctors_aux+0x18>
 804a124:	83 c4 04             	add    $0x4,%esp
 804a127:	5b                   	pop    %ebx
 804a128:	5d                   	pop    %ebp
 804a129:	c3                   	ret    
 804a12a:	90                   	nop
 804a12b:	90                   	nop

Disassembly of section .fini:

0804a12c <_fini>:
 804a12c:	55                   	push   %ebp
 804a12d:	89 e5                	mov    %esp,%ebp
 804a12f:	53                   	push   %ebx
 804a130:	83 ec 04             	sub    $0x4,%esp
 804a133:	e8 00 00 00 00       	call   804a138 <_fini+0xc>
 804a138:	5b                   	pop    %ebx
 804a139:	81 c3 a8 0f 00 00    	add    $0xfa8,%ebx
 804a13f:	e8 4c e9 ff ff       	call   8048a90 <__do_global_dtors_aux>
 804a144:	59                   	pop    %ecx
 804a145:	5b                   	pop    %ebx
 804a146:	c9                   	leave  
 804a147:	c3                   	ret    
