#!/bin/bash

# =============================================================================
# Cleanup Script for CI Tests - Allure Reports & Screenshots
# =============================================================================
# This script ensures only the latest test run data is kept by removing
# old Allure reports and screenshots before generating new ones.
# =============================================================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}🧹 CI Tests - Cleanup Script${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""

# Function to clean directory with feedback
clean_directory() {
    local dir_path="$1"
    local dir_name="$2"
    
    if [ -d "$dir_path" ]; then
        echo -e "${YELLOW}🗑️  Removing old $dir_name...${NC}"
        rm -rf "$dir_path"
        echo -e "${GREEN}✅ Old $dir_name removed${NC}"
    else
        echo -e "${YELLOW}ℹ️  No old $dir_name found${NC}"
    fi
}

# Function to create directory
create_directory() {
    local dir_path="$1"
    local dir_name="$2"
    
    mkdir -p "$dir_path"
    echo -e "${GREEN}📁 Created fresh $dir_name directory${NC}"
}

echo -e "${YELLOW}🧹 Starting cleanup process...${NC}"
echo ""

# Clean Allure results
clean_directory "target/allure-results" "Allure results"
clean_directory "target/site/allure-maven-plugin" "Allure reports"

# Clean screenshots
clean_directory "screenshots" "screenshots"

# Clean any old Maven artifacts for fresh build
clean_directory "target/classes" "compiled classes"
clean_directory "target/test-classes" "compiled test classes"

echo ""
echo -e "${BLUE}📁 Creating fresh directories...${NC}"

# Recreate directories
create_directory "target/allure-results" "Allure results"
create_directory "screenshots" "screenshots"

echo ""
echo -e "${GREEN}✅ CLEANUP COMPLETED!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}📊 Ready for fresh test execution${NC}"
echo -e "${GREEN}🗂️  All old reports and screenshots removed${NC}"
echo -e "${GREEN}📁 Fresh directories created${NC}"
echo ""
echo -e "${BLUE}💡 Next steps:${NC}"
echo -e "${BLUE}  • Run: mvn test${NC}"
echo -e "${BLUE}  • Generate report: mvn io.qameta.allure:allure-maven:report${NC}"
echo -e "${BLUE}  • View report: Open target/site/allure-maven-plugin/index.html${NC}"
echo ""
