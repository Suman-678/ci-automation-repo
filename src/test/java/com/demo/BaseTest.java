package com.demo.base;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import io.github.bonigarcia.wdm.WebDriverManager;

public class BaseTest {
    protected static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

    public WebDriver getDriver() {
        return tlDriver.get();
    }

    @BeforeClass(alwaysRun = true)
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized");
        tlDriver.set(new ChromeDriver(options));
        // Removed listener.registerDriver and ScreenshotUtil.setDriver calls
    }

    @AfterClass(alwaysRun = true)
    public void tearDown() {
        if (getDriver() != null) {
            getDriver().quit();
            tlDriver.remove();
        }
    }
}
