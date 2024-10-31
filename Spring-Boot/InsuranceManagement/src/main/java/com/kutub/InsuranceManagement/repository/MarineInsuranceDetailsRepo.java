package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.MarineInsuranceDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarineInsuranceDetailsRepo extends JpaRepository<MarineInsuranceDetails ,Long > {

}
