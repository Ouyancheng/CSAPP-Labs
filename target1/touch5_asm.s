touch5_asm: 
	movq %rsp, %rax 
	lea (%rdi, %rsi, 1), %rax 
	ret 
