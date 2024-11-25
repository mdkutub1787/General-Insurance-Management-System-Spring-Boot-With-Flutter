package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MarineInsuranceBillRepo extends JpaRepository<MarineInsuranceBill,Long> {


    // Custom query to find bills by policy ID
    @Query("SELECT b FROM MarineInsuranceBill b WHERE b.marineDetails.id = :marineDetailsId")
    List<MarineInsuranceBill> findMarineBillsByMarinePolicyId(@Param("marineDetailsId") long marineDetailsId);
}
