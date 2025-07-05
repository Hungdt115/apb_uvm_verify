echo off

set TOP="%1"
set TB_TOP="%2"
set TESTNAME="%3"

rem =========================================================================
rem == Vivado Simulator (xvlog/xelab/xsim)
rem =========================================================================

call C:/Xilinx/Vivado/2024.2/settings64.bat

set PROJECT_ROOT=%~dp0..
if not exist "%PROJECT_ROOT%\log" mkdir "%PROJECT_ROOT%\log"  
if not exist "%PROJECT_ROOT%\rep" mkdir "%PROJECT_ROOT%\rep" 

echo.
echo *********************************************************
echo APB Protocol Verification - Vivado Sim  
echo Top module:   %TOP%  
echo Test pattern: %TESTNAME%  
echo *********************************************************
echo.

echo ------------------------
echo -- Compile source !!! --
echo ------------------------

call xvlog -sv -i ../src ../src/%TOP%.v --log ../log/xvlog_%TOP%.log

if %ERRORLEVEL% neq 0 (
  echo.
  echo ##### Compile error !!! #####
  goto END
)

echo -------------------------------
echo -- Compile UVM testbench !!! --
echo -------------------------------

REM call xvlog -sv -f hdl_files.f ../test/%TB_TOP%.sv -L uvm --log ../log/xvlog_%TB_TOP%.log
call xvlog -sv -i ../env -i ../src -i ../test ../%TB_TOP%.sv  -L uvm --log ../log/xvlog_%TB_TOP%.log

if %ERRORLEVEL% neq 0 (
  echo.
  echo ##### Compile testbench error !!! #####
  echo.
  goto END
)

echo --------------------------
echo -- Elaborate source !!! --
echo --------------------------

call xelab -debug typical -cc_type bcesfxt %TB_TOP% -L uvm --log ../log/xelab_%TOP%.log 
  
if %ERRORLEVEL% neq 0 (  
  echo.  
  echo ##### Elaborate error !!! #####  
  goto END  
)  

echo ---------------------------
echo -- Simulation start !!! --
echo ---------------------------

call xsim %TB_TOP% -R --log "%PROJECT_ROOT%\log\xsim_%TOP%.log" --testplusarg "UVM_TESTNAME=%TESTNAME%"  
  
if %ERRORLEVEL% neq 0 (  
  echo.  
  echo ##### Simulation error !!! #####  
  echo Check log: %PROJECT_ROOT%\log\xsim_%TOP%.log  
  goto END  
)  

REM echo ------------------------------
REM echo -- Code coverage report !!! --
REM echo ------------------------------

REM call xcrg -cc_report ../rep -cc_db work.%TB_TOP% -cc_dir ./xsim.codeCov/ -report_format html --log ../log/xcrg_%TB_TOP%.log

REM if %ERRORLEVEL% neq 0 (
  REM echo.
  REM echo ##### Code coverage error !!! #####
  REM echo.
  REM goto END
REM )   

:END

pause
