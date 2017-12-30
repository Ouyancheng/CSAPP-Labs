00000000004010f4 <phase_6>:
  4010f4:	41 56                	push   %r14                        # push r14
  4010f6:	41 55                	push   %r13                        # push r13 
  4010f8:	41 54                	push   %r12                        # push r12
  4010fa:	55                   	push   %rbp                        # push rbp
  4010fb:	53                   	push   %rbx                        # push rbx
  4010fc:	48 83 ec 50          	sub    $0x50,%rsp                  # rsp -= 50
  401100:	49 89 e5             	mov    %rsp,%r13                   # r13 = rsp 
  401103:	48 89 e6             	mov    %rsp,%rsi                   # rsi = rsp
  401106:	e8 51 03 00 00       	callq  40145c <read_six_numbers>   # read_six_numbers
  40110b:	49 89 e6             	mov    %rsp,%r14                   # r14 = rsp 
  40110e:	41 bc 00 00 00 00    	mov    $0x0,%r12d                  # r12 = 0
  401114:	4c 89 ed             	mov    %r13,%rbp                   # rbp = r13 = rsp 
  401117:	41 8b 45 00          	mov    0x0(%r13),%eax              # eax = *(r13) = *(rsp + 0)
  40111b:	83 e8 01             	sub    $0x1,%eax                   # eax -= 1
  40111e:	83 f8 05             	cmp    $0x5,%eax                   # 
  401121:	76 05                	jbe    401128 <phase_6+0x34>       # if (eax <= 5) then goto jump1 
  # ####################################################################
  # Then eax - 1 <= 5, eax <= 6
  # ####################################################################
  401123:	e8 12 03 00 00       	callq  40143a <explode_bomb>
  jump1: 
  # ####################################################################
  # r12 = 0 initially
  # ####################################################################
  401128:	41 83 c4 01          	add    $0x1,%r12d                  # r12 += 1
  40112c:	41 83 fc 06          	cmp    $0x6,%r12d                  # 
  401130:	74 21                	je     401153 <phase_6+0x5f>       # if (r12 == 6) then goto jump2 
  401132:	44 89 e3             	mov    %r12d,%ebx                  # rbx = r12 
  loop1: 
  401135:	48 63 c3             	movslq %ebx,%rax                   # rax = rbx = r12 
  401138:	8b 04 84             	mov    (%rsp,%rax,4),%eax          # rax = *(rsp + rax * 4)
  40113b:	39 45 00             	cmp    %eax,0x0(%rbp)              # 
  40113e:	75 05                	jne    401145 <phase_6+0x51>       # if (rax != *(rbp)) then goto jump3
  401140:	e8 f5 02 00 00       	callq  40143a <explode_bomb>
  jump3: 
  401145:	83 c3 01             	add    $0x1,%ebx                   # rbx += 1
  401148:	83 fb 05             	cmp    $0x5,%ebx                   # 
  40114b:	7e e8                	jle    401135 <phase_6+0x41>       # if (rbx <= 5) then goto loop1 
  # ####################################################################
  # The loop above judges whether 2 - 6 elements are equal to the first element 
  # ####################################################################
  40114d:	49 83 c5 04          	add    $0x4,%r13                   # r13 = 4
  401151:	eb c1                	jmp    401114 <phase_6+0x20>       # goto ... 
  jump2: 
  # ####################################################################
  # Note that the 6 elements are in rsp, rsp+4, rsp+8, rsp+12, rsp+16, rsp+20
  # ####################################################################
  401153:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi             # rsi = rsp + 24 this is the element after the last one 
  401158:	4c 89 f0             	mov    %r14,%rax                   # rax = r14 = rsp 
  40115b:	b9 07 00 00 00       	mov    $0x7,%ecx                   # rcx = 7
  loop2: 
  401160:	89 ca                	mov    %ecx,%edx                   # rdx = rcx = 7
  401162:	2b 10                	sub    (%rax),%edx                 # rdx = 7 - (*rax)
  401164:	89 10                	mov    %edx,(%rax)                 # (*rax) = rdx 
  401166:	48 83 c0 04          	add    $0x4,%rax                   # rax += 4
  40116a:	48 39 f0             	cmp    %rsi,%rax                   # 
  40116d:	75 f1                	jne    401160 <phase_6+0x6c>       # if (rax != rsi) goto loop2
  # ####################################################################
  # The loop above replaces each element x with 7 - x
  # ####################################################################
  40116f:	be 00 00 00 00       	mov    $0x0,%esi                   # rsi = 0
  401174:	eb 21                	jmp    401197 <phase_6+0xa3>       # goto jump4 
  loop5: 
  401176:	48 8b 52 08          	mov    0x8(%rdx),%rdx              # rdx = *(rdx + 8)
  40117a:	83 c0 01             	add    $0x1,%eax                   # rax += 1
  40117d:	39 c8                	cmp    %ecx,%eax                   # 
  40117f:	75 f5                	jne    401176 <phase_6+0x82>       # if (rax != rcx) then goto loop5
  # ####################################################################
  # The loop above is obtaining the address of a link list to a specific index 
  # ####################################################################
  401181:	eb 05                	jmp    401188 <phase_6+0x94>       # goto jump5, then rax == rcx 
  loop3: 
  401183:	ba d0 32 60 00       	mov    $0x6032d0,%edx
  jump5: 
  401188:	48 89 54 74 20       	mov    %rdx,0x20(%rsp,%rsi,2)      # *(rsp + 32 + 2 * rsi) = rdx 
  40118d:	48 83 c6 04          	add    $0x4,%rsi                   # rsi += 4 
  401191:	48 83 fe 18          	cmp    $0x18,%rsi                  # 
  401195:	74 14                	je     4011ab <phase_6+0xb7>       # if (rsi == 24) then goto jump6 
  jump4: 
  # ####################################################################
  # rsi = 0 initially 
  # ####################################################################
  401197:	8b 0c 34             	mov    (%rsp,%rsi,1),%ecx          # rcx = *(rsp + rsi) 
  40119a:	83 f9 01             	cmp    $0x1,%ecx                   # 
  40119d:	7e e4                	jle    401183 <phase_6+0x8f>       # if (rcx <= 1) then goto loop3 
  40119f:	b8 01 00 00 00       	mov    $0x1,%eax                   # rax = 1
  4011a4:	ba d0 32 60 00       	mov    $0x6032d0,%edx              # rdx = 0x6032d0
  4011a9:	eb cb                	jmp    401176 <phase_6+0x82>       # goto loop5
  # ####################################################################
  # The code above prints the address of nodes according to the order read from the input 
  # The addresses are in rsp + 32, rsp + 40, rsp + 48, rsp + 56, rsp + 64, rsp + 72 
  # ####################################################################
  jump6: 
  4011ab:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx             # rbx = *(rsp + 32) 
  4011b0:	48 8d 44 24 28       	lea    0x28(%rsp),%rax             # rax = rsp + 40 
  4011b5:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi             # rsi = rsp + 80 
  4011ba:	48 89 d9             	mov    %rbx,%rcx                   # rcx = rbx 
  loop6: 
  4011bd:	48 8b 10             	mov    (%rax),%rdx                 # rdx = (*rax)
  4011c0:	48 89 51 08          	mov    %rdx,0x8(%rcx)              # *(rcx + 8) = rdx 
  4011c4:	48 83 c0 08          	add    $0x8,%rax                   # rax += 8
  4011c8:	48 39 f0             	cmp    %rsi,%rax                   # 
  4011cb:	74 05                	je     4011d2 <phase_6+0xde>       # if (rax == rsi) then goto jump7 
  4011cd:	48 89 d1             	mov    %rdx,%rcx                   # rcx = rdx 
  4011d0:	eb eb                	jmp    4011bd <phase_6+0xc9>       # goto loop6 
  # ####################################################################
  # The loop above fixed the link of the link list, it sorts the nodes according to the input 
  # ####################################################################
  jump7: 
  4011d2:	48 c7 42 08 00 00 00 	movq   $0x0,0x8(%rdx)              # *(rdx + 8) = 0 make next pointer of the last element pointing to 0 
  4011d9:	00 
  4011da:	bd 05 00 00 00       	mov    $0x5,%ebp                   # rbp = 5
  loop7: 
  4011df:	48 8b 43 08          	mov    0x8(%rbx),%rax              # rax = *(rbx + 8) rax is the next element, rbx is the previous one 
  4011e3:	8b 00                	mov    (%rax),%eax                 # rax = (*rax)  extracts the value of the node 
  4011e5:	39 03                	cmp    %eax,(%rbx)                 # 
  4011e7:	7d 05                	jge    4011ee <phase_6+0xfa>       # if (*rbx) >= rax, then goto jump8 
  4011e9:	e8 4c 02 00 00       	callq  40143a <explode_bomb>
  jump8: 
  4011ee:	48 8b 5b 08          	mov    0x8(%rbx),%rbx              # rbx = *(rbx + 8) make rbx pointing to the next element 
  4011f2:	83 ed 01             	sub    $0x1,%ebp                   # rbp -= 1
  4011f5:	75 e8                	jne    4011df <phase_6+0xeb>       # if (rbp != 0) goto loop7 
  # ####################################################################
  # The loop above judges whether the link list is re-linked in the decreasing order of value 
  # ####################################################################
  4011f7:	48 83 c4 50          	add    $0x50,%rsp
  4011fb:	5b                   	pop    %rbx
  4011fc:	5d                   	pop    %rbp
  4011fd:	41 5c                	pop    %r12
  4011ff:	41 5d                	pop    %r13
  401201:	41 5e                	pop    %r14
  401203:	c3                   	retq   