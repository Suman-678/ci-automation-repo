#!/bin/bash

# CI Tests Runner Script
# This script provides convenient ways to run different test configurations

echo "🚀 CI Test Suite Runner"
echo "======================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Maven is installed
check_maven() {
    if ! command -v mvn &> /dev/null; then
        print_error "Maven is not installed or not in PATH"
        exit 1
    fi
    print_success "Maven found: $(mvn -v | head -n 1)"
}

# Function to clean previous results
clean_results() {
    print_status "Cleaning previous test results..."
    rm -rf target/allure-results/*
    rm -rf screenshots/*
    mkdir -p screenshots
    print_success "Cleaned previous results"
}

# Function to run API tests only
run_api_tests() {
    print_status "Running API Tests..."
    mvn test -Dtest=ReqresApiTests
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_success "API tests completed successfully"
    else
        print_error "API tests failed with exit code $exit_code"
    fi
    return $exit_code
}

# Function to run UI tests only
run_ui_tests() {
    print_status "Running UI Tests..."
    mvn test -Dtest=Guru99Tests
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_success "UI tests completed successfully"
    else
        print_error "UI tests failed with exit code $exit_code"
    fi
    return $exit_code
}

# Function to run all tests
run_all_tests() {
    print_status "Running All Tests..."
    mvn test
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_success "All tests completed successfully"
    else
        print_error "Some tests failed with exit code $exit_code"
    fi
    return $exit_code
}

# Function to run tests in parallel
run_parallel_tests() {
    print_status "Running Tests in Parallel Mode..."
    mvn test -Pparallel
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_success "Parallel tests completed successfully"
    else
        print_error "Parallel tests failed with exit code $exit_code"
    fi
    return $exit_code
}

# Function to generate Allure report
generate_report() {
    print_status "Generating Allure Report..."
    if mvn allure:report; then
        print_success "Allure report generated successfully"
        print_status "Report location: target/site/allure-maven-plugin/index.html"
    else
        print_error "Failed to generate Allure report"
    fi
}

# Function to serve Allure report
serve_report() {
    print_status "Starting Allure Report Server..."
    print_warning "This will start a local server. Press Ctrl+C to stop."
    mvn allure:serve
}

# Function to show test results summary
show_summary() {
    echo ""
    echo "📊 Test Results Summary"
    echo "======================"
    
    if [ -d "target/surefire-reports" ]; then
        local total_tests=$(find target/surefire-reports -name "*.xml" -exec grep -l "testcase" {} \; | wc -l)
        local passed_tests=$(find target/surefire-reports -name "*.xml" -exec grep -o 'tests="[0-9]*"' {} \; | cut -d'"' -f2 | awk '{sum+=$1} END {print sum}')
        local failed_tests=$(find target/surefire-reports -name "*.xml" -exec grep -o 'failures="[0-9]*"' {} \; | cut -d'"' -f2 | awk '{sum+=$1} END {print sum}')
        local skipped_tests=$(find target/surefire-reports -name "*.xml" -exec grep -o 'skipped="[0-9]*"' {} \; | cut -d'"' -f2 | awk '{sum+=$1} END {print sum}')
        
        echo "Total Test Classes: $total_tests"
        echo "Passed Tests: $((passed_tests - failed_tests - skipped_tests))"
        echo "Failed Tests: ${failed_tests:-0}"
        echo "Skipped Tests: ${skipped_tests:-0}"
    else
        print_warning "No test results found. Run tests first."
    fi
    
    if [ -d "screenshots" ] && [ "$(ls -A screenshots)" ]; then
        local screenshot_count=$(ls -1 screenshots/*.png 2>/dev/null | wc -l)
        echo "Screenshots captured: $screenshot_count"
    fi
    
    echo ""
}

# Function to display help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  api           Run API tests only"
    echo "  ui            Run UI tests only"
    echo "  all           Run all tests (default)"
    echo "  parallel      Run tests in parallel mode"
    echo "  report        Generate Allure report"
    echo "  serve         Start Allure report server"
    echo "  clean         Clean previous results"
    echo "  summary       Show test results summary"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 api        # Run only API tests"
    echo "  $0 parallel   # Run all tests in parallel"
    echo "  $0 all && $0 report  # Run tests and generate report"
    echo ""
}

# Main script logic
main() {
    check_maven
    
    case "${1:-all}" in
        "api")
            clean_results
            run_api_tests
            show_summary
            ;;
        "ui")
            clean_results
            run_ui_tests
            show_summary
            ;;
        "all")
            clean_results
            run_all_tests
            show_summary
            ;;
        "parallel")
            clean_results
            run_parallel_tests
            show_summary
            ;;
        "report")
            generate_report
            ;;
        "serve")
            serve_report
            ;;
        "clean")
            clean_results
            ;;
        "summary")
            show_summary
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
