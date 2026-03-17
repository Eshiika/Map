package com.example.backend.domain.repository;

import com.example.backend.common.*;
import com.example.backend.domain.City;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

@AppRepository
public interface CityRepository extends JpaRepository<City,Long> {

    @Query(value = """
        SELECT *
        FROM cities c
        WHERE (:region IS NULL OR c.region = :region)
        AND c.population >= :habitantMin
        AND ST_DWithin(
            ST_SetSRID(ST_MakePoint(c.longitude, c.latitude), 4326)::geography,
            ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326)::geography,
            :rayon
        )
        ORDER BY ST_Distance(
            ST_SetSRID(ST_MakePoint(c.longitude, c.latitude), 4326)::geography,
            ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326)::geography
        )
    """, nativeQuery = true)
    List<City> getCities(String region, Pageable pageable, int habitantMin, double latitude, double longitude, double rayon);

    @Query("""
        SELECT DISTINCT c.region
        FROM City c
        ORDER BY c.region
    """)
    List<String> getRegion();
}
