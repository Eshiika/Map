package com.example.backend.http.api.city;

public record CityApiResponse (
    Long id,
    Double latittude,
    Double longitude,
    String name,
    Long population,
    String region
) {}
