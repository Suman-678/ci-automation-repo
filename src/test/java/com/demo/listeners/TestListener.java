package com.demo.listeners;

import com.demo.utils.ScreenshotUtil;
import org.openqa.selenium.WebDriver;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

import java.lang.reflect.Method;

public class TestListener implements ITestListener {

    private WebDriver getDriverFromTest(Object testInstance) {
        try {
            Method method = testInstance.getClass().getDeclaredMethod("getDriver");
            method.setAccessible(true);
            return (WebDriver) method.invoke(testInstance);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null)
            ScreenshotUtil.captureScreenshot(driver, result.getName() + "_PASS");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null)
            ScreenshotUtil.captureScreenshot(driver, result.getName() + "_FAIL");
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null)
            ScreenshotUtil.captureScreenshot(driver, result.getName() + "_SKIPPED");
    }

    @Override
    public void onTestStart(ITestResult result) {
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult result) {
    }

    @Override
    public void onStart(ITestContext context) {
    }

    @Override
    public void onFinish(ITestContext context) {
    }
}
