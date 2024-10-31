package com.kutub.InsuranceManagement.repository;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.entity.Policy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BillRepository extends JpaRepository<Bill, Integer> {

    // Custom query to find bills by policyholder in the associated policy
    @Query("SELECT b FROM Bill b  WHERE LOWER(b.policy.policyholder) LIKE LOWER(CONCAT('%', :policyholder, '%'))")
    List<Bill> findBillsByPolicyholder(@Param("policyholder") String policyholder);
    


    // Custom query to find bills by policy ID
    @Query("SELECT b FROM Bill b WHERE b.policy.id = :policyId")
    List<Bill> findBillsByPolicyId(@Param("policyId") int policyId);

    

}
