echo off

del *.log
del modelsim.ini
del *.vcd
del *.wlf
del transcript
del *.wdb
del *.pb
del *.jou
del *.out
rmdir /s /q work
rmdir /s /q xsim.dir
rmdir /s /q xsim.codeCov
rmdir /s /q xsim.covdb
rmdir /s /q .Xil
pause
