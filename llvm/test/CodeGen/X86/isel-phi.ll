; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-linux-gnu -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X86
; RUN: llc -mtriple=i686-linux-gnu -fast-isel -fast-isel-abort=1 -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X86
; TODO: enable when x87 is supported
; llc -mtriple=i686-linux-gnu -global-isel -global-isel-abort=1 -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X86,GLOBAL-X86
; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X64,DAG-X64
; RUN: llc -mtriple=x86_64-linux-gnu -fast-isel -fast-isel-abort=1 -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X64,DAG-X64
; RUN: llc -mtriple=x86_64-linux-gnu -global-isel -global-isel-abort=1 -verify-machineinstrs < %s -o - | FileCheck %s --check-prefixes=X64,GLOBAL-X64

define i1 @test_i1(i1 %a, i1 %b, i1 %c, i1 %pred0, i1 %pred1) {
; X86-LABEL: test_i1:
; X86:       # %bb.0: # %entry
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB0_1
; X86-NEXT:  # %bb.2: # %cond
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB0_4
; X86-NEXT:  # %bb.3:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_1:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_4: # %cond.false
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i1:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testb $1, %cl
; X64-NEXT:    je .LBB0_1
; X64-NEXT:  # %bb.2: # %cond
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    testb $1, %r8b
; X64-NEXT:    jne .LBB0_4
; X64-NEXT:  # %bb.3: # %cond.false
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:  .LBB0_4: # %cond.end
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
; X64-NEXT:  .LBB0_1:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
entry:
  br i1 %pred0, label %cond, label %cond.end

cond:
  br i1 %pred1, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %res = phi i1 [ %a, %entry ], [ %b, %cond.true ], [ %c, %cond.false ]
  ret i1 %res
}

define i8 @test_i8(i8 %f, i8 %t, i1 %pred) {
; X86-LABEL: test_i8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB1_2: # %cond.false
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    je .LBB1_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
; X64-NEXT:  .LBB1_2: # %cond.false
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i8 [ %f, %cond.true ], [ %t, %cond.false ]
  ret i8 %cond
}

define i16 @test_i16(i16 %f, i16 %t, i1 %pred) {
; X86-LABEL: test_i16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB2_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB2_2: # %cond.false
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    je .LBB2_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
; X64-NEXT:  .LBB2_2: # %cond.false
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i16 [ %f, %cond.true ], [ %t, %cond.false ]
  ret i16 %cond
}

define i32 @test_i32(i32 %f, i32 %t, i1 %pred) {
; X86-LABEL: test_i32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB3_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB3_2: # %cond.false
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    jne .LBB3_2
; X64-NEXT:  # %bb.1: # %cond.false
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:  .LBB3_2: # %cond.end
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %f, %cond.true ], [ %t, %cond.false ]
  ret i32 %cond
}

define i64 @test_i64(i64 %f, i64 %t, i1 %pred) {
; X86-LABEL: test_i64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB4_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB4_2: # %cond.false
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_i64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    jne .LBB4_2
; X64-NEXT:  # %bb.1: # %cond.false
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:  .LBB4_2: # %cond.end
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i64 [ %f, %cond.true ], [ %t, %cond.false ]
  ret i64 %cond
}

define float @test_float(float %f, float %t, i1 %pred) {
; X86-LABEL: test_float:
; X86:       # %bb.0: # %entry
; X86-NEXT:    flds {{[0-9]+}}(%esp)
; X86-NEXT:    flds {{[0-9]+}}(%esp)
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    jne .LBB5_2
; X86-NEXT:  # %bb.1: # %cond.false
; X86-NEXT:    fstp %st(0)
; X86-NEXT:    fldz
; X86-NEXT:    fxch %st(1)
; X86-NEXT:  .LBB5_2: # %cond.end
; X86-NEXT:    fstp %st(1)
; X86-NEXT:    retl
;
; X64-LABEL: test_float:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testb $1, %dil
; X64-NEXT:    jne .LBB5_2
; X64-NEXT:  # %bb.1: # %cond.false
; X64-NEXT:    movaps %xmm1, %xmm0
; X64-NEXT:  .LBB5_2: # %cond.end
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi float [ %f, %cond.true ], [ %t, %cond.false ]
  ret float %cond
}

define double @test_double(i32 %a, double %f, double %t, i1 %pred) {
; X86-LABEL: test_double:
; X86:       # %bb.0: # %entry
; X86-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    jne .LBB6_2
; X86-NEXT:  # %bb.1: # %cond.false
; X86-NEXT:    fstp %st(0)
; X86-NEXT:    fldz
; X86-NEXT:    fxch %st(1)
; X86-NEXT:  .LBB6_2: # %cond.end
; X86-NEXT:    fstp %st(1)
; X86-NEXT:    retl
;
; X64-LABEL: test_double:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    jne .LBB6_2
; X64-NEXT:  # %bb.1: # %cond.false
; X64-NEXT:    movaps %xmm1, %xmm0
; X64-NEXT:  .LBB6_2: # %cond.end
; X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %f, %cond.true ], [ %t, %cond.false ]
  ret double %cond
}

define ptr @test_ptr(ptr %a, ptr %b, ptr %c, ptr %d, ptr %e, ptr %f, ptr %g, i1 %pred0, i1 %pred1, i1 %pred2) {
; X86-LABEL: test_ptr:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB7_6
; X86-NEXT:  # %bb.1: # %cond.true
; X86-NEXT:    testb $1, %cl
; X86-NEXT:    je .LBB7_3
; X86-NEXT:  # %bb.2:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_6: # %cond.false
; X86-NEXT:    testb $1, %cl
; X86-NEXT:    je .LBB7_10
; X86-NEXT:  # %bb.7: # %cond.false.true
; X86-NEXT:    testb $1, %al
; X86-NEXT:    je .LBB7_9
; X86-NEXT:  # %bb.8:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_3: # %cond.true.false
; X86-NEXT:    testb $1, %al
; X86-NEXT:    je .LBB7_5
; X86-NEXT:  # %bb.4:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_10: # %cond.false.false
; X86-NEXT:    testb $1, %al
; X86-NEXT:    je .LBB7_12
; X86-NEXT:  # %bb.11:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_9: # %cond.false.true.false
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_5: # %cond.true.false.false
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
; X86-NEXT:  .LBB7_12: # %cond.false.false.false
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; DAG-X64-LABEL: test_ptr:
; DAG-X64:       # %bb.0: # %entry
; DAG-X64-NEXT:    movq %rdi, %rax
; DAG-X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %edi
; DAG-X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r10d
; DAG-X64-NEXT:    testb $1, {{[0-9]+}}(%rsp)
; DAG-X64-NEXT:    je .LBB7_4
; DAG-X64-NEXT:  # %bb.1: # %cond.true
; DAG-X64-NEXT:    testb $1, %r10b
; DAG-X64-NEXT:    jne .LBB7_9
; DAG-X64-NEXT:  # %bb.2: # %cond.true.false
; DAG-X64-NEXT:    testb $1, %dil
; DAG-X64-NEXT:    movq %rsi, %rax
; DAG-X64-NEXT:    jne .LBB7_9
; DAG-X64-NEXT:  # %bb.3: # %cond.true.false.false
; DAG-X64-NEXT:    movq %rdx, %rax
; DAG-X64-NEXT:    retq
; DAG-X64-NEXT:  .LBB7_4: # %cond.false
; DAG-X64-NEXT:    testb $1, %r10b
; DAG-X64-NEXT:    je .LBB7_7
; DAG-X64-NEXT:  # %bb.5: # %cond.false.true
; DAG-X64-NEXT:    testb $1, %dil
; DAG-X64-NEXT:    movq %rcx, %rax
; DAG-X64-NEXT:    jne .LBB7_9
; DAG-X64-NEXT:  # %bb.6: # %cond.false.true.false
; DAG-X64-NEXT:    movq %r8, %rax
; DAG-X64-NEXT:    retq
; DAG-X64-NEXT:  .LBB7_7: # %cond.false.false
; DAG-X64-NEXT:    testb $1, %dil
; DAG-X64-NEXT:    movq %r9, %rax
; DAG-X64-NEXT:    jne .LBB7_9
; DAG-X64-NEXT:  # %bb.8: # %cond.false.false.false
; DAG-X64-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; DAG-X64-NEXT:  .LBB7_9: # %cond.end
; DAG-X64-NEXT:    retq
;
; GLOBAL-X64-LABEL: test_ptr:
; GLOBAL-X64:       # %bb.0: # %entry
; GLOBAL-X64-NEXT:    movq %rdi, %rax
; GLOBAL-X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r11d
; GLOBAL-X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r10d
; GLOBAL-X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %edi
; GLOBAL-X64-NEXT:    testb $1, %r11b
; GLOBAL-X64-NEXT:    je .LBB7_4
; GLOBAL-X64-NEXT:  # %bb.1: # %cond.true
; GLOBAL-X64-NEXT:    testb $1, %r10b
; GLOBAL-X64-NEXT:    jne .LBB7_9
; GLOBAL-X64-NEXT:  # %bb.2: # %cond.true.false
; GLOBAL-X64-NEXT:    testb $1, %dil
; GLOBAL-X64-NEXT:    movq %rsi, %rax
; GLOBAL-X64-NEXT:    jne .LBB7_9
; GLOBAL-X64-NEXT:  # %bb.3: # %cond.true.false.false
; GLOBAL-X64-NEXT:    movq %rdx, %rax
; GLOBAL-X64-NEXT:    retq
; GLOBAL-X64-NEXT:  .LBB7_4: # %cond.false
; GLOBAL-X64-NEXT:    testb $1, %r10b
; GLOBAL-X64-NEXT:    je .LBB7_7
; GLOBAL-X64-NEXT:  # %bb.5: # %cond.false.true
; GLOBAL-X64-NEXT:    testb $1, %dil
; GLOBAL-X64-NEXT:    movq %rcx, %rax
; GLOBAL-X64-NEXT:    jne .LBB7_9
; GLOBAL-X64-NEXT:  # %bb.6: # %cond.false.true.false
; GLOBAL-X64-NEXT:    movq %r8, %rax
; GLOBAL-X64-NEXT:    retq
; GLOBAL-X64-NEXT:  .LBB7_7: # %cond.false.false
; GLOBAL-X64-NEXT:    testb $1, %dil
; GLOBAL-X64-NEXT:    movq %r9, %rax
; GLOBAL-X64-NEXT:    jne .LBB7_9
; GLOBAL-X64-NEXT:  # %bb.8: # %cond.false.false.false
; GLOBAL-X64-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; GLOBAL-X64-NEXT:  .LBB7_9: # %cond.end
; GLOBAL-X64-NEXT:    retq
entry:
  br i1 %pred0, label %cond.true, label %cond.false

cond.true:
  br i1 %pred1, label %cond.end, label %cond.true.false

cond.true.false:
  br i1 %pred2, label %cond.true.false.true, label %cond.true.false.false

cond.true.false.true:
  br label %cond.end

cond.true.false.false:
  br label %cond.end

cond.false:
  br i1 %pred1, label %cond.false.true, label %cond.false.false

cond.false.true:
  br i1 %pred2, label %cond.false.true.true, label %cond.false.true.false

cond.false.true.true:
  br label %cond.end

cond.false.true.false:
  br label %cond.end

cond.false.false:
  br i1 %pred2, label %cond.false.false.true, label %cond.false.false.false

cond.false.false.true:
  br label %cond.end

cond.false.false.false:
  br label %cond.end

cond.end:
  %res = phi ptr [ %a, %cond.true ], [ %b, %cond.true.false.true ], [ %c, %cond.true.false.false ], [ %d, %cond.false.true.true ], [ %e, %cond.false.true.false ], [ %f, %cond.false.false.true ], [ %g, %cond.false.false.false ]
  ret ptr %res
}

define x86_fp80 @test_fp80(x86_fp80 %f, x86_fp80 %t, i1 %pred) {
; X86-LABEL: test_fp80:
; X86:       # %bb.0: # %entry
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    jne .LBB8_2
; X86-NEXT:  # %bb.1: # %cond.false
; X86-NEXT:    fstp %st(0)
; X86-NEXT:    fldz
; X86-NEXT:    fxch %st(1)
; X86-NEXT:  .LBB8_2: # %cond.end
; X86-NEXT:    fstp %st(1)
; X86-NEXT:    retl
;
; DAG-X64-LABEL: test_fp80:
; DAG-X64:       # %bb.0: # %entry
; DAG-X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; DAG-X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; DAG-X64-NEXT:    testb $1, %dil
; DAG-X64-NEXT:    jne .LBB8_2
; DAG-X64-NEXT:  # %bb.1: # %cond.false
; DAG-X64-NEXT:    fstp %st(0)
; DAG-X64-NEXT:    fldz
; DAG-X64-NEXT:    fxch %st(1)
; DAG-X64-NEXT:  .LBB8_2: # %cond.end
; DAG-X64-NEXT:    fstp %st(1)
; DAG-X64-NEXT:    retq
;
; GLOBAL-X64-LABEL: test_fp80:
; GLOBAL-X64:       # %bb.0: # %entry
; GLOBAL-X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; GLOBAL-X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; GLOBAL-X64-NEXT:    testb $1, %dil
; GLOBAL-X64-NEXT:    jne .LBB8_2
; GLOBAL-X64-NEXT:  # %bb.1: # %cond.false
; GLOBAL-X64-NEXT:    fstp %st(1)
; GLOBAL-X64-NEXT:    fldz
; GLOBAL-X64-NEXT:  .LBB8_2: # %cond.end
; GLOBAL-X64-NEXT:    fstp %st(0)
; GLOBAL-X64-NEXT:    retq
entry:
  br i1 %pred, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi x86_fp80 [ %f, %cond.true ], [ %t, %cond.false ]
  ret x86_fp80 %cond
}
