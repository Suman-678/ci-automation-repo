# CI Test Suite - Comprehensive Web Application Testing Framework

This is a robust test automation framework that supports both UI and API testing with parallel execution capabilities.

## Project Structure

```
ci-tests/
├── src/
│   ├── main/java/com/demo/
│   │   ├── App.java                 # Main application class
│   │   └── utils/
│   │       ├── ApiUtils.java        # API testing utilities
│   │       ├── DriverManager.java   # Driver management utilities
│   │       └── WebDriverFactory.java # Enhanced WebDriver factory
│   └── test/java/com/demo/
│       ├── BaseTest.java           # Base test class with common setup
│       ├── api/
│       │   └── ReqresApiTests.java # Comprehensive API tests
│       ├── ui/
│       │   └── Guru99Tests.java    # UI automation tests
│       ├── listeners/
│       │   └── TestListener.java   # Test event listener for screenshots
│       └── utils/
│           ├── ApiResponseStore.java # Thread-safe response storage
│           └── ScreenshotUtil.java   # Screenshot capture utilities
├── src/test/resources/
│   └── testng.xml                  # TestNG configuration
├── testng-parallel.xml             # Parallel execution configuration
├── pom.xml                         # Maven dependencies and build config
└── screenshots/                    # Auto-generated screenshots
```

## Features

### ✅ Fixed Issues
- **401 Authentication Errors**: Replaced problematic ReqRes endpoints with working alternatives
- **Corrupted UI Tests**: Rebuilt Guru99Tests.java with proper UI automation
- **Threading Issues**: Implemented ThreadLocal patterns for WebDriver management
- **Missing Dependencies**: Added comprehensive Maven dependencies

### 🚀 Enhancements Added
- **Multiple API Endpoints**: Both ReqRes and JSONPlaceholder APIs for comprehensive testing
- **Data-Driven Testing**: Parameterized tests using TestNG DataProvider
- **Enhanced UI Tests**: Complete user journey testing (login, navigation, search, logout)
- **Improved Screenshot Capture**: Thread-safe screenshot utilities with Allure integration
- **Parallel Execution**: Optimized TestNG configurations for concurrent test execution
- **Cross-Browser Support**: Chrome, Firefox, and Edge browser support with headless options

## Test Cases

### API Tests (ReqresApiTests.java)
1. `testGetUsersList` - Test user list retrieval with pagination
2. `testGetUsersListWithPagination` - Validate pagination functionality
3. `testGetUserFromJsonPlaceholder` - Individual user data validation
4. `testCreateUser` - User creation API testing
5. `testCreatePost` - Post creation functionality
6. `testUpdatePost` - Post update operations
7. `testDeletePost` - Post deletion testing
8. `testGetUsersWithDataProvider` - Data-driven user testing (5 users)
9. `testGetNonExistentUser` - Error handling for 404 responses
10. `testApiResponseTime` - Performance testing with response time validation

### UI Tests (Guru99Tests.java)
1. `verifyHomePageTitle` - Homepage load validation
2. `testUserLogin` - User authentication testing
3. `testFlightBookingNavigation` - Navigation flow testing
4. `testFlightSearch` - Flight search functionality
5. `testUserLogout` - Logout functionality
6. `testRegistrationPageNavigation` - Registration page access
7. `testInvalidLogin` - Negative testing for authentication

## Running Tests

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Internet connection for API tests

### Command Line Execution

```bash
# Run all tests (default configuration)
mvn test

# Run with parallel execution profile
mvn test -Pparallel

# Run only API tests
mvn test -Dtest=ReqresApiTests

# Run only UI tests
mvn test -Dtest=Guru99Tests

# Run with specific TestNG configuration
mvn test -DsuiteXmlFile=testng-parallel.xml

# Generate Allure reports
mvn allure:report
mvn allure:serve
```

### IDE Execution
- Import as Maven project
- Run individual test classes or methods
- Use TestNG plugin for enhanced testing experience

## Threading and Parallel Execution

### Threading Strategy
- **ThreadLocal WebDriver**: Each thread maintains its own WebDriver instance
- **API Tests**: Can run in parallel (stateless)
- **UI Tests**: Sequential execution to avoid browser conflicts
- **Screenshot Capture**: Thread-safe implementation

### Configuration Options

#### testng.xml (Mixed Execution)
- API tests: parallel="methods" with 2 threads
- UI tests: parallel="methods" with 1 thread
- Overall suite: parallel="tests" with 3 threads

#### testng-parallel.xml (Full Parallel)
- Classes run in parallel
- Data provider thread count: 3
- Preserve order for UI tests

### Performance Optimizations
- **Implicit Wait**: 10 seconds for element location
- **Page Load Timeout**: 30 seconds maximum
- **API Response Time**: < 5 seconds validation
- **Parallel Fork Count**: 1 with reused forks

## Reporting

### Allure Reports
- Automatic screenshot capture on test failure
- Step-by-step execution tracking
- Performance metrics and timing
- Detailed error logs and stack traces

### Console Output
- Real-time test execution status
- API response details
- Screenshot save locations
- Test completion summaries

## Browser Support

### Supported Browsers
- **Chrome** (default) - with options for headless execution
- **Firefox** - cross-platform compatibility
- **Edge** - Windows environment support

### WebDriver Configuration
- Automatic driver management via WebDriverManager
- Configurable browser options (headless, maximized, etc.)
- Cross-platform path resolution

## Best Practices Implemented

### Code Organization
- Page Object Model ready structure
- Separation of concerns (tests, utilities, configuration)
- Thread-safe utility classes
- Proper exception handling

### Test Design
- Independent test execution
- Data-driven testing capabilities
- Negative testing scenarios
- Performance validation

### Maintenance
- Clear naming conventions
- Comprehensive documentation
- Modular utility functions
- Easy configuration management

## Troubleshooting

### Common Issues
1. **Browser Driver Issues**: WebDriverManager handles automatic driver setup
2. **Network Timeouts**: API tests include retry logic and timeout handling
3. **Element Not Found**: Explicit waits implemented throughout UI tests
4. **Parallel Execution Conflicts**: ThreadLocal patterns prevent cross-thread interference

### Debugging
- Enable verbose logging with `-Dverbose=1`
- Check screenshot directory for visual debugging
- Review Allure reports for detailed execution flow
- Use IDE debugging with breakpoints for step-through analysis

## Future Enhancements

### Potential Additions
- Database testing integration
- Mobile testing capabilities (Appium)
- Docker containerization
- CI/CD pipeline integration (Jenkins, GitHub Actions)
- Load testing with JMeter integration
- API schema validation
- Visual regression testing
