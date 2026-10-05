@echo off
setlocal

echo ========================================
echo Freight Rate ML Assessment
echo ========================================

REM Move to the folder containing this file
cd /d "%~dp0"

echo.
echo [1/4] Checking Python...
py --version
if errorlevel 1 goto :error

echo.
echo [2/4] Running feature engineering...
py -m jupyter nbconvert ^
    --to notebook ^
    --execute notebooks\feature_engineering.ipynb ^
    --output feature_engineering.ipynb ^
    --output-dir notebooks

if errorlevel 1 goto :error

echo.
echo [3/4] Training model and creating predictions...
py -m jupyter nbconvert ^
    --to notebook ^
    --execute notebooks\model.ipynb ^
    --output model.ipynb ^
    --output-dir notebooks

if errorlevel 1 goto :error

echo.
echo [4/4] Running official scorer...
py score.py ^
    --predictions outputs\validation_predictions.csv ^
    --december-predictions outputs\december_chart_predictions.csv

if errorlevel 1 goto :error

echo.
echo ========================================
echo SUCCESS
echo ========================================
echo Predictions and December output created.
echo Official scorer passed.
echo.
pause
exit /b 0


:error
echo.
echo ========================================
echo ERROR
echo ========================================
echo Pipeline failed. Check the error above.
echo.
pause
exit /b 1