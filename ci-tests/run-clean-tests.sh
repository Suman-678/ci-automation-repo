#!/bin/bash

# =============================================================================
# Enhanced Test Runner with Auto-Cleanup for CI Tests
# =============================================================================
# This script runs tests with automatic cleanup of old Allure reports and 
# screenshots, ensuring only the latest execution data is kept.
# =============================================================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo -e "${MAGENTA}🚀 CI Tests - Clean Test Runner${NC}"
echo -e "${MAGENTA}================================${NC}"
echo ""

# Function to run command with status tracking
run_command() {
    local cmd="$1"
    local description="$2"
    
    echo -e "${BLUE}➤ $description${NC}"
    echo -e "${YELLOW}Command: $cmd${NC}"
    echo ""
    
    if eval "$cmd"; then
        echo ""
        echo -e "${GREEN}✅ $description completed successfully${NC}"
        echo ""
    else
        echo ""
        echo -e "${RED}❌ $description failed${NC}"
        exit 1
    fi
}

# Function to start Allure server and open report
open_allure_report() {
    local port="$1"
    echo -e "${BLUE}🌐 Starting Allure report server...${NC}"
    
    cd target/site/allure-maven-plugin
    python3 -m http.server "$port" > /dev/null 2>&1 &
    local server_pid=$!
    cd "$PROJECT_ROOT"
    
    echo -e "${GREEN}📊 Allure Report Server Started!${NC}"
    echo -e "${GREEN}🌐 URL: http://localhost:$port${NC}"
    echo -e "${YELLOW}💡 Server PID: $server_pid (use 'kill $server_pid' to stop)${NC}"
    
    # Open in default browser
    if command -v open >/dev/null 2>&1; then
        open "http://localhost:$port"
        echo -e "${GREEN}🖥️  Report opened in browser${NC}"
    else
        echo -e "${YELLOW}💡 Please open http://localhost:$port in your browser${NC}"
    fi
}

# Show available options
show_help() {
    echo -e "${BLUE}Available options:${NC}"
    echo -e "${YELLOW}  all          - Run all tests (API + UI) with cleanup${NC}"
    echo -e "${YELLOW}  api          - Run only API tests with cleanup${NC}"
    echo -e "${YELLOW}  ui           - Run only UI tests with cleanup${NC}"
    echo -e "${YELLOW}  parallel     - Run tests in parallel mode with cleanup${NC}"
    echo -e "${YELLOW}  clean        - Just clean old reports/screenshots${NC}"
    echo -e "${YELLOW}  report       - Generate Allure report from existing results${NC}"
    echo -e "${YELLOW}  help         - Show this help${NC}"
    echo ""
    echo -e "${BLUE}Example usage:${NC}"
    echo -e "${YELLOW}  ./run-clean-tests.sh all${NC}"
    echo -e "${YELLOW}  ./run-clean-tests.sh api${NC}"
    echo ""
}

# Default to 'all' if no argument provided
TEST_TYPE="${1:-all}"

case "$TEST_TYPE" in
    "help")
        show_help
        exit 0
        ;;
    "clean")
        echo -e "${YELLOW}🧹 Running cleanup only...${NC}"
        ./cleanup-reports.sh
        echo -e "${GREEN}🎉 Cleanup completed!${NC}"
        exit 0
        ;;
    "report")
        echo -e "${YELLOW}📊 Generating Allure report from existing results...${NC}"
        run_command "mvn io.qameta.allure:allure-maven:report" "Generate Allure Report"
        
        if [ -d "target/site/allure-maven-plugin" ]; then
            open_allure_report 8088
        else
            echo -e "${RED}❌ No Allure report found. Run tests first.${NC}"
            exit 1
        fi
        exit 0
        ;;
    "all")
        echo -e "${YELLOW}🎯 Running ALL tests (API + UI) with auto-cleanup...${NC}"
        MAVEN_CMD="mvn clean test"
        ;;
    "api")
        echo -e "${YELLOW}🔌 Running API tests only with auto-cleanup...${NC}"
        MAVEN_CMD="mvn clean test -Dtest=ReqresApiTests"
        ;;
    "ui")
        echo -e "${YELLOW}🖥️  Running UI tests only with auto-cleanup...${NC}"
        MAVEN_CMD="mvn clean test -Dtest=Guru99Tests"
        ;;
    "parallel")
        echo -e "${YELLOW}⚡ Running tests in PARALLEL mode with auto-cleanup...${NC}"
        MAVEN_CMD="mvn clean test -Pparallel"
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $TEST_TYPE${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo -e "${BLUE}📋 Test Execution Plan:${NC}"
echo -e "${BLUE}  • Auto-cleanup old reports & screenshots ✅${NC}"
echo -e "${BLUE}  • Execute $TEST_TYPE tests ⚡${NC}"
echo -e "${BLUE}  • Generate fresh Allure report 📊${NC}"
echo -e "${BLUE}  • Open report in browser 🌐${NC}"
echo ""

# Step 1: Run tests (Maven will auto-cleanup via antrun plugin)
run_command "$MAVEN_CMD" "Execute Tests with Auto-Cleanup"

# Check test results
if [ -d "target/allure-results" ] && [ "$(ls -A target/allure-results)" ]; then
    echo -e "${GREEN}✅ Test execution completed - Allure results generated${NC}"
else
    echo -e "${RED}❌ No test results found${NC}"
    exit 1
fi

# Step 2: Generate Allure report
run_command "mvn io.qameta.allure:allure-maven:report" "Generate Fresh Allure Report"

# Step 3: Open report
if [ -d "target/site/allure-maven-plugin" ]; then
    echo ""
    echo -e "${GREEN}🎉 ALL STEPS COMPLETED SUCCESSFULLY!${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}📊 Fresh $TEST_TYPE test results ready${NC}"
    echo -e "${GREEN}🗂️  Old reports/screenshots automatically cleaned${NC}"
    echo -e "${GREEN}📁 Only latest execution data kept${NC}"
    echo ""
    
    open_allure_report 8089
else
    echo -e "${RED}❌ Allure report generation failed${NC}"
    exit 1
fi
