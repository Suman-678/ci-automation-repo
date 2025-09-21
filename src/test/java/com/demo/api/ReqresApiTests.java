package com.demo.api;

import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import org.testng.annotations.DataProvider;

public class ReqresApiTests {

    // Base URI for ReqRes API (working endpoints)
    private static final String BASE_URL = "https://reqres.in/api";
    // Alternative API for more comprehensive testing
    private static final String JSON_PLACEHOLDER_URL = "https://jsonplaceholder.typicode.com";

    @BeforeClass
    public void setUp() {
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
    }

    @Test(priority = 1)
    public void testGetUsersList() {
        Response response = RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .when()
                .get("/users")
                .then()
                .statusCode(200)
                .extract()
                .response();

        int totalUsers = response.jsonPath().getInt("size()");
        String firstUserEmail = response.jsonPath().getString("[0].email");
        String firstUserName = response.jsonPath().getString("[0].name");
        
        System.out.println("Total users: " + totalUsers);
        System.out.println("First user: " + firstUserName + " (" + firstUserEmail + ")");
        
        Assert.assertTrue(totalUsers > 0, "Users list should not be empty");
        Assert.assertNotNull(firstUserEmail, "First user should have an email");
        Assert.assertTrue(firstUserEmail.contains("@"), "Email should contain @ symbol");
    }

    @Test(priority = 2)
    public void testGetSingleUser() {
        Response response = RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .when()
                .get("/users/1")
                .then()
                .statusCode(200)
                .extract()
                .response();

        String name = response.jsonPath().getString("name");
        String username = response.jsonPath().getString("username");
        String email = response.jsonPath().getString("email");

        System.out.println("User: " + name + " (" + username + ") - " + email);
        Assert.assertEquals(name, "Leanne Graham");
        Assert.assertEquals(username, "Bret");
        Assert.assertTrue(email.contains("@"), "Email should contain @ symbol");
    }

    @Test(priority = 3)
    public void testCreateUser() {
        String requestBody = "{\n" +
                "    \"name\": \"John Doe\",\n" +
                "    \"username\": \"johndoe\",\n" +
                "    \"email\": \"john.doe@test.com\"\n" +
                "}";

        Response response = RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .when()
                .post("/users")
                .then()
                .statusCode(201)
                .extract()
                .response();

        String name = response.jsonPath().getString("name");
        String username = response.jsonPath().getString("username");
        String email = response.jsonPath().getString("email");
        int id = response.jsonPath().getInt("id");

        System.out.println("Created User: " + name + " (" + username + ") - " + email + " (ID: " + id + ")");
        Assert.assertEquals(name, "John Doe");
        Assert.assertEquals(username, "johndoe");
        Assert.assertEquals(email, "john.doe@test.com");
        Assert.assertTrue(id > 0, "Created user should have a valid ID");
    }

    @Test(priority = 4)
    public void testUpdatePost() {
        String requestBody = "{\n" +
                "    \"title\": \"Updated Test Post\",\n" +
                "    \"body\": \"This is an updated test post\",\n" +
                "    \"userId\": 1\n" +
                "}";

        Response response = RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .when()
                .put("/posts/1")
                .then()
                .statusCode(200)
                .extract()
                .response();

        String title = response.jsonPath().getString("title");
        String body = response.jsonPath().getString("body");
        int id = response.jsonPath().getInt("id");

        System.out.println("Updated Post: " + title + " (ID: " + id + ")");
        Assert.assertEquals(title, "Updated Test Post");
        Assert.assertEquals(id, 1);
    }

    @Test(priority = 5)
    public void testDeletePost() {
        RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .when()
                .delete("/posts/1")
                .then()
                .statusCode(200);
        System.out.println("Post deleted successfully.");
    }

    @Test(priority = 6)
    public void testGetNonExistentUser() {
        RestAssured
                .given()
                .baseUri(JSON_PLACEHOLDER_URL)
                .when()
                .get("/users/999")
                .then()
                .statusCode(404);
        System.out.println("Non-existent user correctly returned 404");
    }
}