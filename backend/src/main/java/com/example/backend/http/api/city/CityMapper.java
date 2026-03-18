package com.example.backend.http.api.city;

import com.example.backend.domain.city.entity.City;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CityMapper {

    public CityApiResponse toCityApiResponse(City city) {
        return new CityApiResponse(
                city.getId(),
                city.getLatitude(),
                city.getLongitude(),
                city.getName(),
                city.getPopulation(),
                city.getRegion()
        );
    }
}
