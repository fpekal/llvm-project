; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc <2 x i64> @ctpop_2i64_t(<2 x i64> %src){
; CHECK-LABEL: ctpop_2i64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    vmov r0, r1, d9
; CHECK-NEXT:    bl __popcountdi2
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    vmov r0, r1, d8
; CHECK-NEXT:    asrs r5, r4, #31
; CHECK-NEXT:    bl __popcountdi2
; CHECK-NEXT:    asrs r1, r0, #31
; CHECK-NEXT:    vmov q0[2], q0[0], r0, r4
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r5
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %0 = call <2 x i64> @llvm.ctpop.v2i64(<2 x i64> %src)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x i32> @ctpop_4i32_t(<4 x i32> %src){
; CHECK-LABEL: ctpop_4i32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov.i8 q4, #0x55
; CHECK-NEXT:    vshr.u32 q5, q0, #1
; CHECK-NEXT:    vand q4, q5, q4
; CHECK-NEXT:    vmov.i8 q3, #0x33
; CHECK-NEXT:    vsub.i32 q0, q0, q4
; CHECK-NEXT:    vmov.i8 q2, #0xf
; CHECK-NEXT:    vshr.u32 q4, q0, #2
; CHECK-NEXT:    vand q0, q0, q3
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i32 q0, q0, q4
; CHECK-NEXT:    vshr.u32 q3, q0, #4
; CHECK-NEXT:    vadd.i32 q0, q0, q3
; CHECK-NEXT:    vand q0, q0, q2
; CHECK-NEXT:    vmul.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #24
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.ctpop.v4i32(<4 x i32> %src)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <8 x i16> @ctpop_8i16_t(<8 x i16> %src){
; CHECK-LABEL: ctpop_8i16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov.i8 q4, #0x55
; CHECK-NEXT:    vshr.u16 q5, q0, #1
; CHECK-NEXT:    vand q4, q5, q4
; CHECK-NEXT:    vmov.i8 q3, #0x33
; CHECK-NEXT:    vsub.i16 q0, q0, q4
; CHECK-NEXT:    vmov.i8 q2, #0xf
; CHECK-NEXT:    vshr.u16 q4, q0, #2
; CHECK-NEXT:    vand q0, q0, q3
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i16 q0, q0, q4
; CHECK-NEXT:    vshr.u16 q3, q0, #4
; CHECK-NEXT:    vadd.i16 q0, q0, q3
; CHECK-NEXT:    vand q0, q0, q2
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #8
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.ctpop.v8i16(<8 x i16> %src)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <16 x i8> @ctpop_16i8_t(<16 x i8> %src){
; CHECK-LABEL: ctpop_16i8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov.i8 q3, #0x55
; CHECK-NEXT:    vshr.u8 q4, q0, #1
; CHECK-NEXT:    vand q3, q4, q3
; CHECK-NEXT:    vmov.i8 q2, #0x33
; CHECK-NEXT:    vsub.i8 q0, q0, q3
; CHECK-NEXT:    vmov.i8 q1, #0xf
; CHECK-NEXT:    vshr.u8 q3, q0, #2
; CHECK-NEXT:    vand q0, q0, q2
; CHECK-NEXT:    vand q3, q3, q2
; CHECK-NEXT:    vadd.i8 q0, q0, q3
; CHECK-NEXT:    vshr.u8 q2, q0, #4
; CHECK-NEXT:    vadd.i8 q0, q0, q2
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.ctpop.v16i8(<16 x i8> %src)
  ret <16 x i8> %0
}

declare <2 x i64> @llvm.ctpop.v2i64(<2 x i64>)
declare <4 x i32> @llvm.ctpop.v4i32(<4 x i32>)
declare <8 x i16> @llvm.ctpop.v8i16(<8 x i16>)
declare <16 x i8> @llvm.ctpop.v16i8(<16 x i8>)
