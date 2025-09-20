package com.demo;

import com.demo.listeners.TestListener;
import com.demo.utils.ScreenshotUtil;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.*;

public class BaseTest {
    protected static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();
    protected TestListener listener = new TestListener();

    public WebDriver getDriver() {
        return tlDriver.get();
    }

    @BeforeClass(alwaysRun = true)
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized");
        tlDriver.set(new ChromeDriver(options));
        ScreenshotUtil.setDriver(getDriver());
    }

    @AfterClass(alwaysRun = true)
    public void tearDown() {
        if (getDriver() != null) {
            getDriver().quit();
            tlDriver.remove();
        }
    }
}
