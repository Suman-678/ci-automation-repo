package com.demo.utils;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;

import java.time.Duration;

public class WebDriverFactory {

    private static ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    public enum BrowserType {
        CHROME, FIREFOX, EDGE
    }

    // Initialize WebDriver with specified browser
    public static void initDriver(BrowserType browserType, boolean headless) {
        WebDriver webDriver = null;
        
        switch (browserType) {
            case CHROME:
                WebDriverManager.chromedriver().setup();
                ChromeOptions chromeOptions = new ChromeOptions();
                chromeOptions.addArguments("--start-maximized");
                chromeOptions.addArguments("--disable-web-security");
                chromeOptions.addArguments("--disable-features=VizDisplayCompositor");
                if (headless) {
                    chromeOptions.addArguments("--headless");
                }
                webDriver = new ChromeDriver(chromeOptions);
                break;
                
            case FIREFOX:
                WebDriverManager.firefoxdriver().setup();
                FirefoxOptions firefoxOptions = new FirefoxOptions();
                if (headless) {
                    firefoxOptions.addArguments("--headless");
                }
                webDriver = new FirefoxDriver(firefoxOptions);
                break;
                
            case EDGE:
                WebDriverManager.edgedriver().setup();
                EdgeOptions edgeOptions = new EdgeOptions();
                edgeOptions.addArguments("--start-maximized");
                if (headless) {
                    edgeOptions.addArguments("--headless");
                }
                webDriver = new EdgeDriver(edgeOptions);
                break;
                
            default:
                throw new IllegalArgumentException("Browser type not supported: " + browserType);
        }
        
        driver.set(webDriver);
        setupWebDriver();
    }

    // Initialize WebDriver with default Chrome browser
    public static void initDriver() {
        initDriver(BrowserType.CHROME, false);
    }

    // Setup common WebDriver configurations
    private static void setupWebDriver() {
        WebDriver webDriver = driver.get();
        webDriver.manage().window().maximize();
        webDriver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        webDriver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
        webDriver.manage().deleteAllCookies();
    }

    // Get current driver
    public static WebDriver getDriver() {
        return driver.get();
    }

    // Quit driver
    public static void quitDriver() {
        if (driver.get() != null) {
            driver.get().quit();
            driver.remove();
        }
    }

    // Check if driver is initialized
    public static boolean isDriverInitialized() {
        return driver.get() != null;
    }
}
