# ########################################################################
# How to enter secret_phase 
# ########################################################################
00000000004015c4 <phase_defused>:
  4015c4: 48 83 ec 78           sub    $0x78,%rsp                        # rsp -= 120
  4015c8: 64 48 8b 04 25 28 00  mov    %fs:0x28,%rax                     # rax = %fs:0x28 
  4015cf: 00 00 
  4015d1: 48 89 44 24 68        mov    %rax,0x68(%rsp)                   # 
  4015d6: 31 c0                 xor    %eax,%eax
  4015d8: 83 3d 81 21 20 00 06  cmpl   $0x6,0x202181(%rip)               # 603760 <num_input_strings>
  # ######################################################################
  # The address 0x603760 <num_input_strings> records the total number of strings you input. 
  # In this case, it's only possible to activate the secret_phase after phase_6 
  # ######################################################################
  4015df: 75 5e                 jne    40163f <phase_defused+0x7b>
  # ######################################################################
  # It's only in phase_6 
  # ######################################################################
  4015e1: 4c 8d 44 24 10        lea    0x10(%rsp),%r8                    # r8 = rsp + 16
  4015e6: 48 8d 4c 24 0c        lea    0xc(%rsp),%rcx                    # rcx = rsp + 12
  4015eb: 48 8d 54 24 08        lea    0x8(%rsp),%rdx                    # rdx = rsp + 8
  4015f0: be 19 26 40 00        mov    $0x402619,%esi                    # rsi = 0x402619 "%d %d %s"
  4015f5: bf 70 38 60 00        mov    $0x603870,%edi                    # rdi = 0x603870 
  4015fa: e8 f1 f5 ff ff        callq  400bf0 <__isoc99_sscanf@plt>      # rdi is the string in 0x603870, which is <input_strings> + 240 
  # ######################################################################
  # Note that <input_strings> stores the input string for phase_1, 
  # <input_strings> + 80 stores the input for phase_2, 
  # Then <input_strings> + 240 stores the input string for phase_4 !!! 
  # We need to crack the phase_4 !!!
  # ######################################################################
  4015ff: 83 f8 03              cmp    $0x3,%eax                         # scan 3 characters 
  401602: 75 31                 jne    401635 <phase_defused+0x71>       # must be 3 characters, well, for phase_4, we have 7 0 as answer and we need one more element, which is the %s !!!
  401604: be 22 26 40 00        mov    $0x402622,%esi                    # 0x402622 DrEvil 
  401609: 48 8d 7c 24 10        lea    0x10(%rsp),%rdi
  40160e: e8 25 fd ff ff        callq  401338 <strings_not_equal>        # Then we know that !!! 
  # ######################################################################
  # We found the key to the secret_phase !!! 
  # We can type 7 0 DrEvil in phase_4, then after phase_6, we can enter the secret_phase !!! 
  # ######################################################################
  401613: 85 c0                 test   %eax,%eax
  401615: 75 1e                 jne    401635 <phase_defused+0x71>
  401617: bf f8 24 40 00        mov    $0x4024f8,%edi
  40161c: e8 ef f4 ff ff        callq  400b10 <puts@plt>
  401621: bf 20 25 40 00        mov    $0x402520,%edi
  401626: e8 e5 f4 ff ff        callq  400b10 <puts@plt>
  40162b: b8 00 00 00 00        mov    $0x0,%eax
  401630: e8 0d fc ff ff        callq  401242 <secret_phase>
  401635: bf 58 25 40 00        mov    $0x402558,%edi
  40163a: e8 d1 f4 ff ff        callq  400b10 <puts@plt>
  40163f: 48 8b 44 24 68        mov    0x68(%rsp),%rax
  401644: 64 48 33 04 25 28 00  xor    %fs:0x28,%rax
  40164b: 00 00 
  40164d: 74 05                 je     401654 <phase_defused+0x90>
  40164f: e8 dc f4 ff ff        callq  400b30 <__stack_chk_fail@plt>
  401654: 48 83 c4 78           add    $0x78,%rsp
  401658: c3                    retq   
  401659: 90                    nop
  40165a: 90                    nop
  40165b: 90                    nop
  40165c: 90                    nop
  40165d: 90                    nop
  40165e: 90                    nop
  40165f: 90                    nop

0000000000401242 <secret_phase>:
  401242:	53                   	push   %rbx                              # push rbx 
  401243:	e8 56 02 00 00       	callq  40149e <read_line>                # read a line 
  401248:	ba 0a 00 00 00       	mov    $0xa,%edx                         # rdx = 10
  40124d:	be 00 00 00 00       	mov    $0x0,%esi                         # rsi = 0 
  401252:	48 89 c7             	mov    %rax,%rdi                         # rdi = rax, note that rax is the address of the input string 
  401255:	e8 76 f9 ff ff       	callq  400bd0 <strtol@plt>               # note that strtol has 3 parameters 
  # ######################################################################
  # long int strtol(const char *str, char **endptr, int base); 
  # rdi (str) is the input string 
  # rsi (endptr) is nullptr 
  # rdx (base) is 10 
  # ######################################################################
  40125a:	48 89 c3             	mov    %rax,%rbx                         # rbx is the converted number 
  40125d:	8d 40 ff             	lea    -0x1(%rax),%eax                   # rax -= 1, rax is the converted number - 1 
  401260:	3d e8 03 00 00       	cmp    $0x3e8,%eax                       # 
  401265:	76 05                	jbe    40126c <secret_phase+0x2a>        # if (rax <= 0x3e8) then goto jump1 
  401267:	e8 ce 01 00 00       	callq  40143a <explode_bomb>
  # ######################################################################
  # We need 1001, not 1000 !!! 
  # ######################################################################
  jump1: 
  40126c:	89 de                	mov    %ebx,%esi                         # rsi = rbx = 1001 
  40126e:	bf f0 30 60 00       	mov    $0x6030f0,%edi                    # rdi = 0x6030f0 (address)
  401273:	e8 8c ff ff ff       	callq  401204 <fun7>                     # call fun7 
  401278:	83 f8 02             	cmp    $0x2,%eax                         # 
  40127b:	74 05                	je     401282 <secret_phase+0x40>        # if (rax == 2) then goto jump2 
  40127d:	e8 b8 01 00 00       	callq  40143a <explode_bomb>
  jump2: 
  401282:	bf 38 24 40 00       	mov    $0x402438,%edi 
  401287:	e8 84 f8 ff ff       	callq  400b10 <puts@plt>
  40128c:	e8 33 03 00 00       	callq  4015c4 <phase_defused>
  401291:	5b                   	pop    %rbx
  401292:	c3                   	retq   
  401293:	90                   	nop
  401294:	90                   	nop
  401295:	90                   	nop
  401296:	90                   	nop
  401297:	90                   	nop
  401298:	90                   	nop
  401299:	90                   	nop
  40129a:	90                   	nop
  40129b:	90                   	nop
  40129c:	90                   	nop
  40129d:	90                   	nop
  40129e:	90                   	nop
  40129f:	90                   	nop


(gdb) x/64xg 0x6030f0 
0x6030f0 <n1>:  0x0000000000000024      0x0000000000603110
0x603100 <n1+16>:       0x0000000000603130      0x0000000000000000
0x603110 <n21>: 0x0000000000000008      0x0000000000603190
0x603120 <n21+16>:      0x0000000000603150      0x0000000000000000
0x603130 <n22>: 0x0000000000000032      0x0000000000603170
0x603140 <n22+16>:      0x00000000006031b0      0x0000000000000000
0x603150 <n32>: 0x0000000000000016      0x0000000000603270
0x603160 <n32+16>:      0x0000000000603230      0x0000000000000000
0x603170 <n33>: 0x000000000000002d      0x00000000006031d0
0x603180 <n33+16>:      0x0000000000603290      0x0000000000000000
0x603190 <n31>: 0x0000000000000006      0x00000000006031f0
0x6031a0 <n31+16>:      0x0000000000603250      0x0000000000000000
0x6031b0 <n34>: 0x000000000000006b      0x0000000000603210
0x6031c0 <n34+16>:      0x00000000006032b0      0x0000000000000000
0x6031d0 <n45>: 0x0000000000000028      0x0000000000000000
0x6031e0 <n45+16>:      0x0000000000000000      0x0000000000000000
0x6031f0 <n41>: 0x0000000000000001      0x0000000000000000
0x603200 <n41+16>:      0x0000000000000000      0x0000000000000000
0x603210 <n47>: 0x0000000000000063      0x0000000000000000
0x603220 <n47+16>:      0x0000000000000000      0x0000000000000000
0x603230 <n44>: 0x0000000000000023      0x0000000000000000
0x603240 <n44+16>:      0x0000000000000000      0x0000000000000000
0x603250 <n42>: 0x0000000000000007      0x0000000000000000
0x603260 <n42+16>:      0x0000000000000000      0x0000000000000000
0x603270 <n43>: 0x0000000000000014      0x0000000000000000
0x603280 <n43+16>:      0x0000000000000000      0x0000000000000000
0x603290 <n46>: 0x000000000000002f      0x0000000000000000
0x6032a0 <n46+16>:      0x0000000000000000      0x0000000000000000
0x6032b0 <n48>: 0x00000000000003e9      0x0000000000000000
0x6032c0 <n48+16>:      0x0000000000000000      0x0000000000000000
0x6032d0 <node1>:       0x000000010000014c      0x00000000006032e0
0x6032e0 <node2>:       0x00000002000000a8      0x0000000000000000

# ##############################################################################################################################
# 
#                                                             0x6030f0
#                               0x603110                        0x24                        0x603130
#                 0x603190        0x8         0x603150                        0x603170        0x32          0x6031b0 
#       0x6031f0    0x6   0x603250     0x603270  0x16  0x603230        z0x6031d0  0x2d  0x603290      0x603210  0x6b  0x6032b0 
#          0x1               0x7         0x14            0x23            0x28            0x2f          0x63           0x3e9  
# 
# ##############################################################################################################################

# #####################################################################
# rdi is the pointer of the root, rsi is 1001 
# #####################################################################
0000000000401204 <fun7>:
  401204: 48 83 ec 08           sub    $0x8,%rsp                      # rsp -= 8
  401208: 48 85 ff              test   %rdi,%rdi                      # 
  40120b: 74 2b                 je     401238 <fun7+0x34>             # if (rdi == 0) then goto jump1 
  40120d: 8b 17                 mov    (%rdi),%edx                    # rdx = (*rdi) this is the pointer of the value of rdi 
  40120f: 39 f2                 cmp    %esi,%edx                      # 
  401211: 7e 0d                 jle    401220 <fun7+0x1c>             # if (rdx <= rsi) then goto jump2 
  401213: 48 8b 7f 08           mov    0x8(%rdi),%rdi                 # rdi = *(rdi + 8) this is the pointer of the left child of rdi 
  401217: e8 e8 ff ff ff        callq  401204 <fun7>                  # fun7(left, 1001)
  40121c: 01 c0                 add    %eax,%eax                      # rax = rax * 2
  40121e: eb 1d                 jmp    40123d <fun7+0x39>             # goto jump3 
  jump2: 
  401220: b8 00 00 00 00        mov    $0x0,%eax                      # rax = 0
  401225: 39 f2                 cmp    %esi,%edx                      # 
  401227: 74 14                 je     40123d <fun7+0x39>             # if (rdx == rsi) then goto jump3 
  401229: 48 8b 7f 10           mov    0x10(%rdi),%rdi                # rdi = *(rdi + 16) this is the pointer of the right child of rdi 
  40122d: e8 d2 ff ff ff        callq  401204 <fun7>                  # fun7(right, 1001)
  401232: 8d 44 00 01           lea    0x1(%rax,%rax,1),%eax          # rax = rax * 2 + 1
  401236: eb 05                 jmp    40123d <fun7+0x39>             # goto jump3 
  jump1: 
  401238: b8 ff ff ff ff        mov    $0xffffffff,%eax               # rax = -1 
  jump3: 
  40123d: 48 83 c4 08           add    $0x8,%rsp
  401241: c3                    retq   

# #####################################################################
# we can interpret it as C programming language code 
# #####################################################################
# int fun7(node *root, int num) {
#     if (root == nullptr) return -1;
#     if (root->val > num) {
#         return 2 * fun7(root->left, num);
#     }  else if (root->val == num) {
#         return 0; 
#     } else {
#         return 2 * fun7(root->right, num) + 1; 
#     }
# }
# #####################################################################

# We need fun7 to return 2, we can input 22. 
