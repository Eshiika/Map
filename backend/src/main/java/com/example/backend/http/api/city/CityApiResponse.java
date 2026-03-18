package com.example.backend.http.api.city;

public record CityApiResponse (
    Long id,
    String name,
    Double latitude,
    Double longitude,
    Long population,
    String region
) {}