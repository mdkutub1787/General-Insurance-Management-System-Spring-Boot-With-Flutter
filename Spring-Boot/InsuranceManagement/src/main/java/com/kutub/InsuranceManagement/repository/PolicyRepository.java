package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.Policy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PolicyRepository extends JpaRepository<Policy, Integer> {


    // Search Policy records by policyholder name (full or partial, case-insensitive)
    @Query("SELECT p FROM Policy p WHERE LOWER(p.policyholder) LIKE LOWER(CONCAT('%', :policyholder, '%'))")
    List<Policy> findByPolicyHolder(@Param("policyholder") String policyholder);

    // Search Policy records by bank name (full or partial, case-insensitive)
    @Query("SELECT p FROM Policy p WHERE LOWER(p.bankName) LIKE LOWER(CONCAT('%', :bankName, '%'))")
    List<Policy> findByBankName(@Param("bankName") String bankName);


}
