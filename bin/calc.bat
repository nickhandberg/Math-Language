@echo off
set /P name=Enter program name found in test directory:
set pathname=../test/
set "directory=%pathname%%name%" 
ruby load "%directory%"