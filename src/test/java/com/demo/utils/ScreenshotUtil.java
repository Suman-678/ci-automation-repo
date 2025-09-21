package com.demo.utils;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;

public class ScreenshotUtil {

    private static ThreadLocal<WebDriver> driver = new ThreadLocal<>();
    private static AtomicBoolean cleanupPerformed = new AtomicBoolean(false);

    public static void setDriver(WebDriver webDriver) {
        driver.set(webDriver);
    }

    public static WebDriver getDriver() {
        return driver.get();
    }

    /**
     * Clean old screenshots at the start of test session (only once)
     */
    private static void cleanOldScreenshotsIfNeeded() {
        if (cleanupPerformed.compareAndSet(false, true)) {
            try {
                String screenshotDir = System.getProperty("user.dir") + "/screenshots/";
                Path dirPath = Paths.get(screenshotDir);
                
                if (Files.exists(dirPath)) {
                    System.out.println("🧹 Cleaning old screenshots for fresh test session...");
                    Files.walk(dirPath)
                        .filter(Files::isRegularFile)
                        .filter(path -> path.toString().endsWith(".png"))
                        .forEach(path -> {
                            try {
                                Files.delete(path);
                            } catch (IOException e) {
                                System.out.println("Warning: Could not delete " + path);
                            }
                        });
                    System.out.println("✅ Old screenshots cleaned");
                }
            } catch (IOException e) {
                System.out.println("Warning: Could not clean old screenshots: " + e.getMessage());
            }
        }
    }

    public static void captureScreenshot(WebDriver driver, String testName) {
        try {
            // Clean old screenshots only once per test session
            cleanOldScreenshotsIfNeeded();
            
            File srcFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            String destDir = System.getProperty("user.dir") + "/screenshots/";
            Files.createDirectories(Paths.get(destDir));
            String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String destPath = destDir + testName + "_" + timestamp + ".png";
            Files.copy(srcFile.toPath(), Paths.get(destPath));
            System.out.println("Screenshot saved: " + destPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static byte[] takeScreenshot(String testName) {
        WebDriver currentDriver = getDriver();
        if (currentDriver != null) {
            try {
                byte[] screenshot = ((TakesScreenshot) currentDriver).getScreenshotAs(OutputType.BYTES);
                captureScreenshot(currentDriver, testName);
                return screenshot;
            } catch (Exception e) {
                System.err.println("Failed to take screenshot: " + e.getMessage());
                return new byte[0];
            }
        }
        return new byte[0];
    }

    public static void clearDriver() {
        driver.remove();
    }
}
