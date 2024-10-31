package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarineInsuranceBillRepo extends JpaRepository<MarineInsuranceBill,Long> {

}
