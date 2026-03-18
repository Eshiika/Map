package com.example.backend.http.api.city;

import com.example.backend.domain.city.dto.CityDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CityMapper {

    public CityApiResponse toCityApiResponse(CityDTO city) {
        return new CityApiResponse(
                city.getId(),
                city.getName(),
                city.getLatitude(),
                city.getLongitude(),
                city.getPopulation(),
                city.getRegion()
        );
    }
}
