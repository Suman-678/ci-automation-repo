# 🧹 Automated Cleanup System for CI Tests

## 📋 Overview

This document describes the comprehensive automated cleanup system implemented to ensure **only the latest Allure reports and screenshots are kept**, automatically removing old data before each test run.

## ✅ Implemented Solutions

### 1. 🔧 **Maven Auto-Cleanup (Primary Method)**
- **File**: `pom.xml` (Updated)
- **How it works**: Automatically cleans old reports and screenshots before every Maven test execution
- **Triggers**: During `test-compile` phase of any Maven command
- **What it cleans**:
  - `target/allure-results/*`
  - `target/site/allure-maven-plugin/*` 
  - `screenshots/*`

```xml
<!-- Auto-cleanup before tests -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-antrun-plugin</artifactId>
    <version>3.1.0</version>
    <executions>
        <execution>
            <id>clean-old-results</id>
            <phase>test-compile</phase>
            <goals>
                <goal>run</goal>
            </goals>
            <configuration>
                <target>
                    <echo message="🧹 Cleaning old Allure reports and screenshots..." />
                    <delete dir="${project.build.directory}/allure-results" quiet="true" />
                    <delete dir="${project.build.directory}/site/allure-maven-plugin" quiet="true" />
                    <delete dir="${project.basedir}/screenshots" quiet="true" />
                    <mkdir dir="${project.build.directory}/allure-results" />
                    <mkdir dir="${project.basedir}/screenshots" />
                    <echo message="✅ Cleanup completed - Ready for fresh test run!" />
                </target>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### 2. 📜 **Manual Cleanup Script**
- **File**: `cleanup-reports.sh` (New)
- **Usage**: `./cleanup-reports.sh`
- **Purpose**: Manual cleanup when needed
- **Features**:
  - Colorized output
  - Detailed feedback
  - Safe error handling
  - Creates fresh directories

### 3. 📸 **Smart Screenshot Cleanup**
- **File**: `src/test/java/com/demo/utils/ScreenshotUtil.java` (Updated)
- **How it works**: Automatically cleans old screenshots before first screenshot of test session
- **Thread-safe**: Uses `AtomicBoolean` to ensure cleanup happens only once per session
- **Benefits**: No manual intervention required

### 4. 🚀 **Enhanced Test Runner**
- **File**: `run-clean-tests.sh` (New)
- **Features**:
  - Multiple execution modes (all, api, ui, parallel)
  - Auto-cleanup integrated
  - Auto-report generation
  - Auto-browser opening
  - Comprehensive status feedback

## 🎯 Usage Examples

### Standard Maven Commands (Auto-cleanup Enabled)
```bash
# All commands now automatically clean old data
mvn test                                    # Clean + Run all tests
mvn test -Dtest=ReqresApiTests             # Clean + Run API tests
mvn test -Dtest=Guru99Tests                # Clean + Run UI tests
mvn clean test                             # Extra clean + Run tests
```

### Enhanced Test Runner (Recommended)
```bash
# Complete workflow with automation
./run-clean-tests.sh all                   # API + UI tests
./run-clean-tests.sh api                   # API tests only
./run-clean-tests.sh ui                    # UI tests only
./run-clean-tests.sh parallel              # Parallel execution
./run-clean-tests.sh clean                 # Cleanup only
./run-clean-tests.sh report                # Generate report only
```

### Manual Cleanup
```bash
# When you need to clean manually
./cleanup-reports.sh
```

## 📊 Benefits

### ✅ **Automatic Operation**
- No manual intervention required
- Integrated into existing workflows
- Works with all Maven commands

### ✅ **Clean Data**
- Only latest test execution data kept
- No confusion from old results
- Accurate Allure reports always

### ✅ **Storage Efficient**
- Prevents accumulation of old files
- Keeps project directory clean
- Reduces disk usage

### ✅ **Reliable Reporting**
- Fresh Allure reports every time
- Correct test counts and results
- No stale data artifacts

## 🔧 Technical Details

### Maven Integration
- Uses `maven-antrun-plugin` for file operations
- Executes during `test-compile` phase
- Creates necessary directories after cleanup
- Silent operation with informative echo messages

### Screenshot Management
- Thread-safe singleton cleanup
- Automatic detection of test session start
- Preserves new screenshots during session
- Java NIO for efficient file operations

### Error Handling
- Graceful handling of missing directories
- Quiet cleanup (no errors if files don't exist)
- Automatic directory recreation
- Comprehensive logging

## 🎯 Result

**Perfect Solution**: Every test run now automatically ensures:
1. ✅ Old Allure reports are removed
2. ✅ Old screenshots are cleaned  
3. ✅ Only current execution data exists
4. ✅ Fresh, accurate reports generated
5. ✅ No manual cleanup required

## 📝 Files Modified/Created

### Modified Files
- `pom.xml` - Added auto-cleanup plugin
- `src/test/java/com/demo/utils/ScreenshotUtil.java` - Added smart cleanup logic

### New Files
- `cleanup-reports.sh` - Manual cleanup script
- `run-clean-tests.sh` - Enhanced test runner
- `CLEANUP-AUTOMATION.md` - This documentation

---

🎉 **The cleanup system is now fully automated and requires no manual intervention!** 🎉
