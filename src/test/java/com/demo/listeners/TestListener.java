package com.demo.listeners;

import com.demo.utils.ScreenshotUtil;
import io.qameta.allure.Allure;
import org.openqa.selenium.WebDriver;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

import java.io.FileInputStream;
import java.lang.reflect.Method;

public class TestListener implements ITestListener {

    private WebDriver getDriverFromTest(Object testInstance) {
        try {
            Method method = testInstance.getClass().getDeclaredMethod("getDriver");
            method.setAccessible(true);
            return (WebDriver) method.invoke(testInstance);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void captureAndAttachScreenshot(WebDriver driver, String testName, String status) {
        String screenshotPath = ScreenshotUtil.captureScreenshot(driver, testName + "_" + status);
        try (FileInputStream fis = new FileInputStream(screenshotPath)) {
            Allure.addAttachment(testName + "_" + status + "_screenshot", fis);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null) {
            captureAndAttachScreenshot(driver, result.getName(), "PASS");
        }
    }

    @Override
    public void onTestFailure(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null) {
            captureAndAttachScreenshot(driver, result.getName(), "FAIL");
        }
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        WebDriver driver = getDriverFromTest(result.getInstance());
        if (driver != null) {
            captureAndAttachScreenshot(driver, result.getName(), "SKIPPED");
        }
    }
}
