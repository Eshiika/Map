package com.example.backend.domain.city.dto;

public interface CityDTO {
    Long getId();
    String getName();
    Double getLatitude();
    Double getLongitude();
    Long getPopulation();
    String getRegion();
}
