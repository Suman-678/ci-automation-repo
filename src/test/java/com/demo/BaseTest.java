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
                
        // Common Chrome options
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--disable-gpu");
        options.addArguments("--disable-web-security");
        options.addArguments("--disable-features=VizDisplayCompositor");
        options.addArguments("--disable-extensions");
        options.addArguments("--disable-plugins");
        options.addArguments("--disable-images");
        options.addArguments("--disable-background-timer-throttling");
        options.addArguments("--disable-backgrounding-occluded-windows");
        options.addArguments("--disable-renderer-backgrounding");
        options.addArguments("--window-size=1920,1080");
        
        // Unique user data directory for CI
        String userDataDir = System.getProperty("java.io.tmpdir") + "/chrome-user-data-" + System.currentTimeMillis();
        options.addArguments("--user-data-dir=" + userDataDir);
        
        // Environment-specific options
        if (System.getProperty("ci.environment") != null) {
            // CI environment - use headless mode
            options.addArguments("--headless");
        } else {
            // Local environment - maximize window
            options.addArguments("--start-maximized");
        }
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
