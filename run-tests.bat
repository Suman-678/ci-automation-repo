@echo off
setlocal enabledelayedexpansion

echo 🚀 CI Test Suite Runner
echo =======================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Maven is not installed or not in PATH
    pause
    exit /b 1
)

echo [SUCCESS] Maven found
echo.

REM Get the test type parameter (default to 'all')
set TEST_TYPE=%1
if "%TEST_TYPE%"=="" set TEST_TYPE=all

REM Clean previous results
echo [INFO] Cleaning previous test results...
if exist target\allure-results rmdir /s /q target\allure-results
if exist screenshots rmdir /s /q screenshots
mkdir screenshots 2>nul
echo [SUCCESS] Cleaned previous results
echo.

REM Run tests based on parameter
if "%TEST_TYPE%"=="api" (
    echo [INFO] Running API Tests...
    mvn test -Dtest=ReqresApiTests
) else if "%TEST_TYPE%"=="ui" (
    echo [INFO] Running UI Tests...
    mvn test -Dtest=Guru99Tests
) else if "%TEST_TYPE%"=="parallel" (
    echo [INFO] Running Tests in Parallel Mode...
    mvn test -Pparallel
) else if "%TEST_TYPE%"=="all" (
    echo [INFO] Running All Tests...
    mvn test
) else if "%TEST_TYPE%"=="help" (
    goto :show_help
) else (
    echo [ERROR] Unknown option: %TEST_TYPE%
    goto :show_help
)

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Tests completed successfully
) else (
    echo.
    echo [ERROR] Some tests failed
)

echo.
echo 📊 Test Results Summary
echo ======================
if exist target\surefire-reports (
    echo Test reports available in: target\surefire-reports\
) else (
    echo [WARNING] No test results found
)

if exist screenshots\*.png (
    echo Screenshots captured in: screenshots\
)

echo.
echo [INFO] To generate Allure report, run: mvn allure:report
echo [INFO] To serve Allure report, run: mvn allure:serve
goto :end

:show_help
echo Usage: %0 [OPTION]
echo.
echo Options:
echo   api           Run API tests only
echo   ui            Run UI tests only
echo   all           Run all tests (default)
echo   parallel      Run tests in parallel mode
echo   help          Show this help message
echo.
echo Examples:
echo   %0 api        # Run only API tests
echo   %0 parallel   # Run all tests in parallel
echo.

:end
pause
