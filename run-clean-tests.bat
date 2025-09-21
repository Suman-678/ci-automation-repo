@echo off
setlocal enabledelayedexpansion

echo 🚀 CI Tests - Clean Test Runner
echo ================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Maven is not installed or not in PATH
    pause
    exit /b 1
)

REM Get the test type parameter (default to 'all')
set TEST_TYPE=%1
if "%TEST_TYPE%"=="" set TEST_TYPE=all

if "%TEST_TYPE%"=="help" goto :show_help

echo [INFO] Test Execution Plan:
echo   • Auto-cleanup old reports ^& screenshots ✅
echo   • Execute %TEST_TYPE% tests ⚡
echo   • Generate fresh Allure report 📊
echo.

REM Run tests with cleanup
if "%TEST_TYPE%"=="all" (
    echo [INFO] Running ALL tests (API + UI) with auto-cleanup...
    mvn clean test
) else if "%TEST_TYPE%"=="api" (
    echo [INFO] Running API tests only with auto-cleanup...
    mvn clean test -Dtest=ReqresApiTests
) else if "%TEST_TYPE%"=="ui" (
    echo [INFO] Running UI tests only with auto-cleanup...
    mvn clean test -Dtest=Guru99Tests
) else if "%TEST_TYPE%"=="parallel" (
    echo [INFO] Running tests in PARALLEL mode with auto-cleanup...
    mvn clean test -Pparallel
) else if "%TEST_TYPE%"=="clean" (
    echo [INFO] Running cleanup only...
    mvn clean
    echo [SUCCESS] Cleanup completed!
    goto :end
) else if "%TEST_TYPE%"=="report" (
    echo [INFO] Generating Allure report from existing results...
    mvn allure:report
    if exist target\site\allure-maven-plugin (
        echo [SUCCESS] Allure report generated!
        echo [INFO] Report location: target\site\allure-maven-plugin\index.html
        echo [INFO] To serve report: mvn allure:serve
    ) else (
        echo [ERROR] No Allure report found. Run tests first.
    )
    goto :end
) else (
    echo [ERROR] Unknown option: %TEST_TYPE%
    goto :show_help
)

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Test execution completed
    
    REM Generate Allure report
    echo [INFO] Generating Fresh Allure Report...
    mvn allure:report
    
    if exist target\site\allure-maven-plugin (
        echo.
        echo 🎉 ALL STEPS COMPLETED SUCCESSFULLY!
        echo ====================================
        echo 📊 Fresh %TEST_TYPE% test results ready
        echo 🗂️  Old reports/screenshots automatically cleaned
        echo 📁 Only latest execution data kept
        echo.
        echo [INFO] Report location: target\site\allure-maven-plugin\index.html
        echo [INFO] To serve report: mvn allure:serve
    ) else (
        echo [ERROR] Allure report generation failed
    )
) else (
    echo.
    echo [ERROR] Tests failed
)

goto :end

:show_help
echo Available options:
echo   all          - Run all tests (API + UI) with cleanup
echo   api          - Run only API tests with cleanup
echo   ui           - Run only UI tests with cleanup
echo   parallel     - Run tests in parallel mode with cleanup
echo   clean        - Just clean old reports/screenshots
echo   report       - Generate Allure report from existing results
echo   help         - Show this help
echo.
echo Example usage:
echo   %0 all
echo   %0 api
echo.

:end
pause
