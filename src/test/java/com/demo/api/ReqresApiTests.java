package com.demo.api;

import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.Test;

public class ReqresApiTests {

    private static final String BASE_URL = "https://reqres.in/api";

    @Test
    public void testGetUsers() {
        Response response = RestAssured
                .given()
                .baseUri(BASE_URL)
                .when()
                .get("/users?page=2")
                .then()
                .statusCode(200)
                .extract()
                .response();

        String lastName = response.jsonPath().getString("data[0].last_name");
        System.out.println("Last Name of first user: " + lastName);
        Assert.assertNotNull(lastName, "Last name shouldn't be null");
    }

    @Test
    public void testCreateUser() {
        String requestBody = "{ \"name\": \"John Doe\", \"job\": \"QA Engineer\" }";

        Response response = RestAssured
                .given()
                .baseUri(BASE_URL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .when()
                .post("/users")
                .then()
                .statusCode(201)
                .extract()
                .response();

        String name = response.jsonPath().getString("name");
        String job = response.jsonPath().getString("job");

        System.out.println("Created User: " + name + " - " + job);
        Assert.assertEquals(name, "John Doe");
        Assert.assertEquals(job, "QA Engineer");
    }

    @Test
    public void testUpdateUser() {
        String requestBody = "{ \"name\": \"John Smith\", \"job\": \"Senior QA\" }";

        Response response = RestAssured
                .given()
                .baseUri(BASE_URL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .when()
                .put("/users/2")
                .then()
                .statusCode(200)
                .extract()
                .response();

        String job = response.jsonPath().getString("job");
        System.out.println("Updated Job: " + job);
        Assert.assertEquals(job, "Senior QA");
    }

    @Test
    public void testDeleteUser() {
        RestAssured
                .given()
                .baseUri(BASE_URL)
                .when()
                .delete("/users/2")
                .then()
                .statusCode(204);

        System.out.println("User deleted successfully.");
    }
}
