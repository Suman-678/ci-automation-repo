#!/bin/bash

# =============================================================================
# MINIMAL Test Runner - Keep Only Final HTML Report
# =============================================================================
# This script runs tests, generates Allure report, then removes all raw
# result files, keeping only the final HTML report for minimal file count.
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

echo -e "${MAGENTA}🎯 MINIMAL Test Runner - Final Report Only${NC}"
echo -e "${MAGENTA}===========================================${NC}"
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

# Function to clean raw results but keep HTML report
minimize_files() {
    echo -e "${BLUE}🧹 Minimizing files - Keeping only HTML report...${NC}"
    
    # Count files before
    local before_count=$(find target/ -type f | wc -l)
    local allure_results_count=$(ls -1 target/allure-results/ 2>/dev/null | wc -l)
    
    echo -e "${YELLOW}📊 Before cleanup:${NC}"
    echo -e "${YELLOW}  • Allure raw results: $allure_results_count files${NC}"
    echo -e "${YELLOW}  • Total target files: $before_count files${NC}"
    
    # Remove raw allure results but keep the HTML report
    if [ -d "target/allure-results" ]; then
        rm -rf target/allure-results
        echo -e "${GREEN}✅ Removed raw Allure results${NC}"
    fi
    
    # Remove compiled classes (optional)
    if [ -d "target/classes" ]; then
        rm -rf target/classes
        echo -e "${GREEN}✅ Removed compiled classes${NC}"
    fi
    
    if [ -d "target/test-classes" ]; then
        rm -rf target/test-classes
        echo -e "${GREEN}✅ Removed compiled test classes${NC}"
    fi
    
    # Keep only the essential HTML report
    local after_count=$(find target/ -type f | wc -l)
    
    echo ""
    echo -e "${GREEN}📊 After cleanup:${NC}"
    echo -e "${GREEN}  • Raw results: 0 files ✅${NC}"
    echo -e "${GREEN}  • Total target files: $after_count files${NC}"
    echo -e "${GREEN}  • Space saved: $((before_count - after_count)) files removed${NC}"
    echo ""
}

# Function to start Allure server and open report
open_minimal_report() {
    local port="$1"
    echo -e "${BLUE}🌐 Starting minimal Allure report server...${NC}"
    
    if [ -d "target/site/allure-maven-plugin" ]; then
        cd target/site/allure-maven-plugin
        python3 -m http.server "$port" > /dev/null 2>&1 &
        local server_pid=$!
        cd "$PROJECT_ROOT"
        
        echo -e "${GREEN}📊 Minimal Report Server Started!${NC}"
        echo -e "${GREEN}🌐 URL: http://localhost:$port${NC}"
        echo -e "${YELLOW}💡 Server PID: $server_pid (use 'kill $server_pid' to stop)${NC}"
        
        # Open in default browser
        if command -v open >/dev/null 2>&1; then
            open "http://localhost:$port"
            echo -e "${GREEN}🖥️  Minimal report opened in browser${NC}"
        else
            echo -e "${YELLOW}💡 Please open http://localhost:$port in your browser${NC}"
        fi
    else
        echo -e "${RED}❌ No HTML report found${NC}"
        exit 1
    fi
}

# Show available options
show_help() {
    echo -e "${BLUE}Available options:${NC}"
    echo -e "${YELLOW}  all          - Run all tests, generate report, minimize files${NC}"
    echo -e "${YELLOW}  api          - Run API tests, generate report, minimize files${NC}"
    echo -e "${YELLOW}  ui           - Run UI tests, generate report, minimize files${NC}"
    echo -e "${YELLOW}  minimize     - Minimize existing files (keep only HTML report)${NC}"
    echo -e "${YELLOW}  help         - Show this help${NC}"
    echo ""
    echo -e "${BLUE}Example usage:${NC}"
    echo -e "${YELLOW}  ./run-minimal-tests.sh all${NC}"
    echo -e "${YELLOW}  ./run-minimal-tests.sh api${NC}"
    echo ""
}

# Default to 'all' if no argument provided
TEST_TYPE="${1:-all}"

case "$TEST_TYPE" in
    "help")
        show_help
        exit 0
        ;;
    "minimize")
        echo -e "${YELLOW}🎯 Minimizing existing files...${NC}"
        minimize_files
        
        if [ -d "target/site/allure-maven-plugin" ]; then
            open_minimal_report 8091
        else
            echo -e "${RED}❌ No existing report found. Run tests first.${NC}"
            exit 1
        fi
        exit 0
        ;;
    "all")
        echo -e "${YELLOW}🎯 Running ALL tests with MINIMAL file strategy...${NC}"
        MAVEN_CMD="mvn clean test"
        ;;
    "api")
        echo -e "${YELLOW}🔌 Running API tests with MINIMAL file strategy...${NC}"
        MAVEN_CMD="mvn clean test -Dtest=ReqresApiTests"
        ;;
    "ui")
        echo -e "${YELLOW}🖥️  Running UI tests with MINIMAL file strategy...${NC}"
        MAVEN_CMD="mvn clean test -Dtest=Guru99Tests"
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $TEST_TYPE${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo -e "${BLUE}📋 MINIMAL Execution Plan:${NC}"
echo -e "${BLUE}  • Clean old data ✅${NC}"
echo -e "${BLUE}  • Execute $TEST_TYPE tests ⚡${NC}"
echo -e "${BLUE}  • Generate HTML report 📊${NC}"
echo -e "${BLUE}  • Remove all raw result files 🗑️${NC}"
echo -e "${BLUE}  • Keep only final HTML report 📄${NC}"
echo -e "${BLUE}  • Open minimal report 🌐${NC}"
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
run_command "mvn io.qameta.allure:allure-maven:report" "Generate HTML Report"

# Step 3: Minimize files (remove raw results, keep only HTML)
minimize_files

# Step 4: Open minimal report
echo ""
echo -e "${GREEN}🎉 MINIMAL STRATEGY COMPLETED!${NC}"
echo -e "${GREEN}===============================${NC}"
echo -e "${GREEN}📊 $TEST_TYPE test execution finished${NC}"
echo -e "${GREEN}🗂️  All raw result files removed${NC}"
echo -e "${GREEN}📄 Only final HTML report kept${NC}"
echo -e "${GREEN}💾 Maximum space efficiency achieved${NC}"
echo ""

open_minimal_report 8091
