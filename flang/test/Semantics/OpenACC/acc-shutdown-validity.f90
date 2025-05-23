! RUN: %python %S/../test_errors.py %s %flang -fopenacc

! Check OpenACC clause validity for the following construct and directive:
!   2.14.2 Shutdown

program openacc_shutdown_validity

  implicit none

  integer :: i, j
  integer, parameter :: N = 256
  logical :: ifCondition = .TRUE.
  real(8), dimension(N) :: a

  !$acc parallel
  !ERROR: Directive SHUTDOWN may not be called within a compute region
  !$acc shutdown
  !$acc end parallel

  !$acc serial
  !ERROR: Directive SHUTDOWN may not be called within a compute region
  !$acc shutdown
  !$acc end serial

  !$acc kernels
  !ERROR: Directive SHUTDOWN may not be called within a compute region
  !$acc shutdown
  !$acc end kernels

  !$acc parallel
  !$acc loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do
  !$acc end parallel

  !$acc serial
  !$acc loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do
  !$acc end serial

  !$acc kernels
  !$acc loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do
  !$acc end kernels

  !$acc parallel loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do

  !$acc serial loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do

  !$acc kernels loop
  do i = 1, N
    !ERROR: Directive SHUTDOWN may not be called within a compute region
    !$acc shutdown
    a(i) = 3.14
  end do

  !$acc shutdown
  !$acc shutdown if(.TRUE.)
  !$acc shutdown if(ifCondition)
  !$acc shutdown device_num(1)
  !$acc shutdown device_num(i)
  !$acc shutdown device_type(*)
  !$acc shutdown device_type(*, default, host)
  !$acc shutdown device_num(i) device_type(default, host) if(ifCondition)

  !ERROR: At most one IF clause can appear on the SHUTDOWN directive
  !$acc shutdown if(.TRUE.) if(ifCondition)

  !ERROR: At most one DEVICE_NUM clause can appear on the SHUTDOWN directive
  !$acc shutdown device_num(1) device_num(i)

  ! OK
  !$acc shutdown device_type(*) device_type(host, default)

end program openacc_shutdown_validity
